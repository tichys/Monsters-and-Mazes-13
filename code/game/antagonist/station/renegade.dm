GLOBAL_DATUM_INIT(renegades, /datum/antagonist/renegade, new)

/datum/antagonist/renegade
	role_text = "Renegade"
	role_text_plural = "Renegades"
	restricted_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/hos, /datum/job/captain)
	welcome_text = "Something's going to go wrong today, I can just feel it. I'm paranoid, you've got a gun, and you're going to survive."
	antag_text = "I am a <b>minor</b> antagonist! Within the rules, \
		try to protect myself and what's important to me. I amn't here to <i>cause</i> trouble, \
		you're just willing (and equipped) to go to extremes to <b>stop</b> it. \
		My job is to oppose the other antagonists, should they threaten you, in ways that aren't quite legal. \
		Try to make sure other players have <i>fun</i>! If I am confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through my actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"

	id = MODE_RENEGADE
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 5
	hard_cap_round = 7

	hard_cap = 8
	hard_cap_round = 12
	initial_spawn_req = 3
	initial_spawn_target = 6
	antaghud_indicator = "hudrenegade"
	skill_setter = /datum/antag_skill_setter/station

	var/list/spawn_guns = list(
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/energy/crossbow,
		/obj/item/weapon/gun/energy/crossbow/largecrossbow,
		/obj/item/weapon/gun/projectile/automatic,
		/obj/item/weapon/gun/projectile/automatic/mini_uzi,
		/obj/item/weapon/gun/projectile/automatic/c20r,
		/obj/item/weapon/gun/projectile/automatic/wt550,
		/obj/item/weapon/gun/projectile/colt,
		/obj/item/weapon/gun/projectile/sec/wood/lethal,
		/obj/item/weapon/gun/projectile/silenced,
		/obj/item/weapon/gun/projectile/beretta,
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/gun/projectile/revolver/webley,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/weapon/gun/projectile/magnum_pistol,
		list(/obj/item/weapon/gun/projectile/revolver/detective, /obj/item/weapon/gun/projectile/revolver/deckard)
		)

/datum/antagonist/renegade/create_objectives(var/datum/mind/player)

	if(!..())
		return

	var/datum/objective/survive/survive = new
	survive.owner = player
	player.objectives |= survive

/datum/antagonist/renegade/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	var/gun_type = pick(spawn_guns)
	if(islist(gun_type))
		gun_type = pick(gun_type)
	var/obj/item/gun = new gun_type(get_turf(player))

	// Attempt to put into a container.
	if(player.equip_to_storage(gun))
		return

	// If that failed, attempt to put into any valid non-handslot
	if(player.equip_to_appropriate_slot(gun))
		return

	// If that failed, then finally attempt to at least let the player carry the weapon
	player.put_in_hands(gun)


/proc/rightandwrong()
	to_chat(usr, "<B>I summoned guns!</B>")
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		GLOB.renegades.add_antagonist(H.mind)