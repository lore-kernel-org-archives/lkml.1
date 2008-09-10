Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbYIJO6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbYIJO6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYIJO6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:58:32 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:47243 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYIJO6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:58:31 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
Date: Wed, 10 Sep 2008 16:58:07 +0200
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio>
In-Reply-To: <20080909100012.29542.62582.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2080502.vgiE3lcPIz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809101658.14823.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2080502.vgiE3lcPIz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alex Chiang wrote:
> Prevent callers of pci_create_slot() from registering slots with
> duplicate names. This condition occurs most often when PCI hotplug
> drivers are loaded on platforms with broken firmware that assigns
> identical names to multiple slots.
>
> We now rename these duplicate slots on behalf of the user.
>
> If firmware assigns the name N to multiple slots, then:
>
> 	The first registered slot is assigned N
> 	The second registered slot is assigned N-1
> 	The third registered slot is assigned N-2
> 	The Mth registered slot becomes N-M
>
> A side effect of this patch is that the error condition for when
> multiple drivers attempt to claim the same slot becomes much more
> prominent.
>
> In other words, the previous error condition returned for
> duplicate slot names (-EEXIST) masked the case when multiple
> drivers attempted to claim the same slot. Now, the -EBUSY return
> makes the true error more obvious.
>
> This is the permanent fix mentioned in earlier commits:
>
> 	shpchp: Rename duplicate slot name N as N-1, N-2, N-M...
> 	d6a9e9b40be7da84f82eb414c2ad98c5bb69986b
>
> 	pciehp: Rename duplicate slot name N as N-1, N-2, N-M...
> 	167e782e301188c7c7e31e486bbeea5f918324c1
>
> Cc: jbarnes@virtuousgeek.org
> Cc: kristen.c.accardi@intel.com
> Cc: matthew@wil.cx
> Cc: kaneshige.kenji@jp.fujitsu.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
>
>  drivers/pci/hotplug/pci_hotplug_core.c |   23 ++++--
>  drivers/pci/hotplug/pciehp_core.c      |   14 ----
>  drivers/pci/hotplug/shpchp_core.c      |   15 ----
>  drivers/pci/slot.c                     |  117
> +++++++++++++++++++++++++++----- include/linux/pci.h                    |=
 =20
>  3 +
>  5 files changed, 117 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c
> b/drivers/pci/hotplug/pci_hotplug_core.c index 3e37d63..2232608 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -558,7 +558,8 @@ int pci_hp_register(struct hotplug_slot *slot, struct
> pci_bus *bus, int slot_nr, const char *name)
>  {
>  	int result;
> -	struct pci_slot *pci_slot;
> +	struct pci_dev *dev;
> +	struct pci_slot *pci_slot, *tmp_slot =3D NULL;
>
>  	if (slot =3D=3D NULL)
>  		return -ENODEV;
> @@ -570,9 +571,17 @@ int pci_hp_register(struct hotplug_slot *slot, struct
> pci_bus *bus, int slot_nr, return -EINVAL;
>  	}
>
> -	/* Check if we have already registered a slot with the same name. */
> -	if (get_slot_from_name(name))
> -		return -EEXIST;
> +	/*
> +	 * If we find a tmp_slot here, it means that another slot
> +	 * driver has already created a pci_slot for this device.
> +	 * We care (below) if the existing slot has a different name from
> +	 * the new name that this particular hotplug driver is requesting.
> +	 */
> +	dev =3D pci_get_slot(bus, PCI_DEVFN(slot_nr, 0));
> +	if (dev && dev->slot) {
> +		tmp_slot =3D dev->slot;
> +		pci_dev_put(dev);
> +	}
>
>  	/*
>  	 * No problems if we call this interface from both ACPI_PCI_SLOT
> @@ -593,10 +602,10 @@ int pci_hp_register(struct hotplug_slot *slot, stru=
ct
> pci_bus *bus, int slot_nr, pci_slot->hotplug =3D slot;
>
>  	/*
> -	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
> +	 * Allow pcihp drivers to override existing slot name.
>  	 */
> -	if (strcmp(kobject_name(&pci_slot->kobj), name)) {
> -		result =3D kobject_rename(&pci_slot->kobj, name);
> +	if (tmp_slot && strcmp(kobject_name(&tmp_slot->kobj), name)) {
> +		result =3D pci_rename_slot(pci_slot, name);
>  		if (result) {
>  			pci_destroy_slot(pci_slot);
>  			return result;
> diff --git a/drivers/pci/hotplug/pciehp_core.c
> b/drivers/pci/hotplug/pciehp_core.c index cbd84f8..bed77af 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -191,7 +191,6 @@ static int init_slots(struct controller *ctrl)
>  	struct slot *slot;
>  	struct hotplug_slot *hotplug_slot;
>  	struct hotplug_slot_info *info;
> -	int len, dup =3D 1;
>  	int retval =3D -ENOMEM;
>
>  	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
> @@ -218,24 +217,11 @@ static int init_slots(struct controller *ctrl)
>  		dbg("Registering bus=3D%x dev=3D%x hp_slot=3D%x sun=3D%x "
>  		    "slot_device_offset=3D%x\n", slot->bus, slot->device,
>  		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
> -duplicate_name:
>  		retval =3D pci_hp_register(hotplug_slot,
>  					 ctrl->pci_dev->subordinate,
>  					 slot->device,
>  					 slot->name);
>  		if (retval) {
> -			/*
> -			 * If slot N already exists, we'll try to create
> -			 * slot N-1, N-2 ... N-M, until we overflow.
> -			 */
> -			if (retval =3D=3D -EEXIST) {
> -				len =3D snprintf(slot->name, SLOT_NAME_SIZE,
> -					       "%d-%d", slot->number, dup++);
> -				if (len < SLOT_NAME_SIZE)
> -					goto duplicate_name;
> -				else
> -					err("duplicate slot name overflow\n");
> -			}
>  			err("pci_hp_register failed with error %d\n", retval);
>  			goto error_info;
>  		}
> diff --git a/drivers/pci/hotplug/shpchp_core.c
> b/drivers/pci/hotplug/shpchp_core.c index bf50966..cfdd079 100644
> --- a/drivers/pci/hotplug/shpchp_core.c
> +++ b/drivers/pci/hotplug/shpchp_core.c
> @@ -102,7 +102,7 @@ static int init_slots(struct controller *ctrl)
>  	struct hotplug_slot *hotplug_slot;
>  	struct hotplug_slot_info *info;
>  	int retval =3D -ENOMEM;
> -	int i, len, dup =3D 1;
> +	int i;
>
>  	for (i =3D 0; i < ctrl->num_slots; i++) {
>  		slot =3D kzalloc(sizeof(*slot), GFP_KERNEL);
> @@ -144,23 +144,10 @@ static int init_slots(struct controller *ctrl)
>  		dbg("Registering bus=3D%x dev=3D%x hp_slot=3D%x sun=3D%x "
>  		    "slot_device_offset=3D%x\n", slot->bus, slot->device,
>  		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
> -duplicate_name:
>  		retval =3D pci_hp_register(slot->hotplug_slot,
>  				ctrl->pci_dev->subordinate, slot->device,
>  				hotplug_slot->name);
>  		if (retval) {
> -			/*
> -			 * If slot N already exists, we'll try to create
> -			 * slot N-1, N-2 ... N-M, until we overflow.
> -			 */
> -			if (retval =3D=3D -EEXIST) {
> -				len =3D snprintf(slot->name, SLOT_NAME_SIZE,
> -					       "%d-%d", slot->number, dup++);
> -				if (len < SLOT_NAME_SIZE)
> -					goto duplicate_name;
> -				else
> -					err("duplicate slot name overflow\n");
> -			}
>  			err("pci_hp_register failed with error %d\n", retval);
>  			goto error_info;
>  		}
> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> index 0c6db03..93c55ca 100644
> --- a/drivers/pci/slot.c
> +++ b/drivers/pci/slot.c
> @@ -78,6 +78,51 @@ static struct kobj_type pci_slot_ktype =3D {
>  	.default_attrs =3D pci_slot_default_attrs,
>  };
>
> +static char *make_slot_name(const char *name)
> +{
> +	char *new_name;
> +	int len, width, dup =3D 1;
> +	struct kobject *dup_slot;
> +
> +	new_name =3D kstrdup(name, GFP_KERNEL);
> +	if (!new_name)
> +		goto out;
> +
> +	/*
> +	 * Start off allocating enough room for "name-X"
> +	 */
> +	len =3D strlen(name) + 2;
> +	width =3D 1;
> +
> +try_again:
> +	dup_slot =3D kset_find_obj(pci_slots_kset, new_name);
> +	if (!dup_slot)
> +		goto out;
> +	kobject_put(dup_slot);
> +
> +	/*
> +	 * We hit this the first time through, which gives us
> +	 * space for terminating NULL, and then every power of 10
> +	 * afterwards, which gives us space to add another digit
> +	 * to "name-XX..."
> +	 */
> +	if (dup % width =3D=3D 0) {
> +		len++;
> +		width *=3D 10;
> +	}
> +
> +	new_name =3D krealloc(new_name, len, GFP_KERNEL);
> +	if (!new_name)
> +		goto out;

If krealloc() fails you will leak the old new_name here.

Eike

--nextPart2080502.vgiE3lcPIz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjH4IYACgkQXKSJPmm5/E4x2gCbBMGZd6/YKTMncHe3R02YzJ0H
WsQAoKTjoedAQ2acMZFoMfhJxt9ej4Sb
=gzOY
-----END PGP SIGNATURE-----

--nextPart2080502.vgiE3lcPIz--
