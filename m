Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYHQJG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYHQJG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 05:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHQJGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 05:06:49 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:59020 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYHQJGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 05:06:48 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Aug 2008 05:06:48 EDT
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 04/13] PCI: acpiphp: remove 'name' parameter
Date: Sun, 17 Aug 2008 10:59:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
References: <20080816235504.5461.20733.stgit@blender.achiang> <20080817001635.5461.39872.stgit@blender.achiang>
In-Reply-To: <20080817001635.5461.39872.stgit@blender.achiang>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5980540.lN4JjFqvOF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808171059.50802.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5980540.lN4JjFqvOF
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alex Chiang wrote:
> We do not need to manage our own name parameter, especially since
> the PCI core can change it on our behalf, in the case of duplicate
> slot names.
>
> Remove 'name' from acpiphp's version of struct slot.
>
> Cc: jbarnes@virtuousgeek.org
> Cc: kristen.c.accardi@intel.com
> Cc: kaneshige.kenji@jp.fujitsu.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
>
>  drivers/pci/hotplug/acpiphp.h      |    9 +++++----
>  drivers/pci/hotplug/acpiphp_core.c |   36
> +++++++++++++++++++----------------- 2 files changed, 24 insertions(+), 21
> deletions(-)
>
> diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
> index 5a58b07..f9e244d 100644
> --- a/drivers/pci/hotplug/acpiphp.h
> +++ b/drivers/pci/hotplug/acpiphp.h
> @@ -50,9 +50,6 @@
>  #define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ##
> arg) #define warn(format, arg...) printk(KERN_WARNING "%s: " format,
> MY_NAME , ## arg)
>
> -/* name size which is used for entries in pcihpfs */
> -#define SLOT_NAME_SIZE	20		/* {_SUN} */
> -
>  struct acpiphp_bridge;
>  struct acpiphp_slot;
>
> @@ -63,9 +60,13 @@ struct slot {
>  	struct hotplug_slot	*hotplug_slot;
>  	struct acpiphp_slot	*acpi_slot;
>  	struct hotplug_slot_info info;
> -	char name[SLOT_NAME_SIZE];
>  };
>
> +static inline const char *slot_name(struct slot *slot)
> +{
> +	return hotplug_slot_name(slot->hotplug_slot);
> +}
> +
>  /*
>   * struct acpiphp_bridge - PCI bridge information
>   *

I don't see a point in this function. Why not call hotplug_slot_name()=20
directly?=20

> diff --git a/drivers/pci/hotplug/acpiphp_core.c
> b/drivers/pci/hotplug/acpiphp_core.c index e984176..687cac3 100644
> --- a/drivers/pci/hotplug/acpiphp_core.c
> +++ b/drivers/pci/hotplug/acpiphp_core.c
> @@ -44,6 +44,9 @@
>
>  #define MY_NAME	"acpiphp"
>
> +/* name size which is used for entries in pcihpfs */
> +#define SLOT_NAME_SIZE  20              /* {_SUN} */
> +
>  static int debug;
>  int acpiphp_debug;
>
> @@ -84,7 +87,6 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops =
=3D {
>  	.get_adapter_status	=3D get_adapter_status,
>  };
>
> -
>  /**
>   * acpiphp_register_attention - set attention LED callback
>   * @info: must be completely filled with LED callbacks

=46uzz.

> @@ -92,7 +94,7 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops =
=3D {
>   * Description: This is used to register a hardware specific ACPI
>   * driver that manipulates the attention LED.  All the fields in
>   * info must be set.
> - */
> + **/
>  int acpiphp_register_attention(struct acpiphp_attention_info *info)
>  {
>  	int retval =3D -EINVAL;

=46uzz. Make the patch look bigger than it actually is. But that's just a n=
ote,=20
Jesse will have to judge if this is acceptable.

> @@ -113,7 +115,7 @@ int acpiphp_register_attention(struct
> acpiphp_attention_info *info) * Description: This is used to un-register a
> hardware specific acpi * driver that manipulates the attention LED.  The
> pointer to the * info struct must be the same as the one used to set it.
> - */
> + **/
>  int acpiphp_unregister_attention(struct acpiphp_attention_info *info)
>  {
>  	int retval =3D -EINVAL;
> @@ -136,7 +138,7 @@ static int enable_slot(struct hotplug_slot
> *hotplug_slot) {
>  	struct slot *slot =3D hotplug_slot->private;
>
> -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
>
>  	/* enable the specified slot */
>  	return acpiphp_enable_slot(slot->acpi_slot);
> @@ -154,7 +156,7 @@ static int disable_slot(struct hotplug_slot
> *hotplug_slot) struct slot *slot =3D hotplug_slot->private;
>  	int retval;
>
> -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
>
>  	/* disable the specified slot */
>  	retval =3D acpiphp_disable_slot(slot->acpi_slot);
> @@ -177,7 +179,7 @@ static int disable_slot(struct hotplug_slot
> *hotplug_slot) {
>  	int retval =3D -ENODEV;
>
> - 	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__,
> hotplug_slot_name(hotplug_slot));
>
>  	if (attention_info && try_module_get(attention_info->owner)) {
>  		retval =3D attention_info->set_attn(hotplug_slot, status);
> @@ -200,7 +202,7 @@ static int get_power_status(struct hotplug_slot
> *hotplug_slot, u8 *value) {
>  	struct slot *slot =3D hotplug_slot->private;
>
> -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
>
>  	*value =3D acpiphp_get_power_status(slot->acpi_slot);
>
> @@ -222,7 +224,7 @@ static int get_attention_status(struct hotplug_slot
> *hotplug_slot, u8 *value) {
>  	int retval =3D -EINVAL;
>
> -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__,
> hotplug_slot_name(hotplug_slot));
>
>  	if (attention_info && try_module_get(attention_info->owner)) {
>  		retval =3D attention_info->get_attn(hotplug_slot, value);
> @@ -245,7 +247,7 @@ static int get_latch_status(struct hotplug_slot
> *hotplug_slot, u8 *value) {
>  	struct slot *slot =3D hotplug_slot->private;
>
> -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
>
>  	*value =3D acpiphp_get_latch_status(slot->acpi_slot);
>
> @@ -265,7 +267,7 @@ static int get_adapter_status(struct hotplug_slot
> *hotplug_slot, u8 *value) {
>  	struct slot *slot =3D hotplug_slot->private;
>
> -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
>
>  	*value =3D acpiphp_get_adapter_status(slot->acpi_slot);
>
> @@ -299,7 +301,7 @@ static void release_slot(struct hotplug_slot
> *hotplug_slot) {
>  	struct slot *slot =3D hotplug_slot->private;
>
> -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
>
>  	kfree(slot->hotplug_slot);
>  	kfree(slot);
> @@ -310,6 +312,7 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot
> *acpiphp_slot) {
>  	struct slot *slot;
>  	int retval =3D -ENOMEM;
> +	char name[SLOT_NAME_SIZE];
>
>  	slot =3D kzalloc(sizeof(*slot), GFP_KERNEL);
>  	if (!slot)
> @@ -321,8 +324,6 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot
> *acpiphp_slot)
>
>  	slot->hotplug_slot->info =3D &slot->info;
>
> -	slot->hotplug_slot->name =3D slot->name;
> -
>  	slot->hotplug_slot->private =3D slot;
>  	slot->hotplug_slot->release =3D &release_slot;
>  	slot->hotplug_slot->ops =3D &acpi_hotplug_slot_ops;
> @@ -336,12 +337,13 @@ int acpiphp_register_hotplug_slot(struct acpiphp_sl=
ot
> *acpiphp_slot) slot->hotplug_slot->info->cur_bus_speed =3D PCI_SPEED_UNKN=
OWN;
>
>  	acpiphp_slot->slot =3D slot;
> -	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
> +	memset(name, 0, SLOT_NAME_SIZE);
> +	snprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);

The memset() is not needed at all. And the sizeof is IMHO a good idea anywa=
y=20
as it allows to get rid of the define.

>  	retval =3D pci_hp_register(slot->hotplug_slot,
>  					acpiphp_slot->bridge->pci_bus,
>  					acpiphp_slot->device,
> -					slot->name);
> +					name);
>  	if (retval =3D=3D -EBUSY)
>  		goto error_hpslot;
>  	if (retval) {
> @@ -349,7 +351,7 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot
> *acpiphp_slot) goto error_hpslot;
>   	}
>
> -	info("Slot [%s] registered\n", slot->hotplug_slot->name);
> +	info("Slot [%s] registered\n", slot_name(slot));
>
>  	return 0;
>  error_hpslot:
> @@ -366,7 +368,7 @@ void acpiphp_unregister_hotplug_slot(struct
> acpiphp_slot *acpiphp_slot) struct slot *slot =3D acpiphp_slot->slot;
>  	int retval =3D 0;
>
> -	info ("Slot [%s] unregistered\n", slot->hotplug_slot->name);
> +	info ("Slot [%s] unregistered\n", slot_name(slot));
>
>  	retval =3D pci_hp_deregister(slot->hotplug_slot);
>  	if (retval)

Greetings,

Eike

--nextPart5980540.lN4JjFqvOF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkin6IYACgkQXKSJPmm5/E7qEwCfetN/5WIpVHduRo9RFT8MmKer
EZAAoJDAyoadXhOcvezqmZ4FYAAFfJd3
=r38Y
-----END PGP SIGNATURE-----

--nextPart5980540.lN4JjFqvOF--
