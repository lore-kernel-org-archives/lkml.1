Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYHSVC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYHSVC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYHSVCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:02:16 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:55693 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbYHSVCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:02:14 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       kristen.c.accardi@intel.com, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH 04/13] PCI: acpiphp: remove 'name' parameter
Date: Tue, 19 Aug 2008 23:01:55 +0200
User-Agent: KMail/1.9.9
References: <20080816235504.5461.20733.stgit@blender.achiang> <200808171059.50802.eike-kernel@sf-tec.de> <20080819183908.GD18842@ldl.fc.hp.com>
In-Reply-To: <20080819183908.GD18842@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1535349.KVXUKykLLA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808192301.56532.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1535349.KVXUKykLLA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alex Chiang wrote:
> * Rolf Eike Beer <eike-kernel@sf-tec.de>:
> > Alex Chiang wrote:
> > > We do not need to manage our own name parameter, especially since
> > > the PCI core can change it on our behalf, in the case of duplicate
> > > slot names.
> > >
> > > Remove 'name' from acpiphp's version of struct slot.
> > >
> > > Cc: jbarnes@virtuousgeek.org
> > > Cc: kristen.c.accardi@intel.com
> > > Cc: kaneshige.kenji@jp.fujitsu.com
> > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > > ---
> > >
> > >  drivers/pci/hotplug/acpiphp.h      |    9 +++++----
> > >  drivers/pci/hotplug/acpiphp_core.c |   36
> > > +++++++++++++++++++----------------- 2 files changed, 24 insertions(+=
),
> > > 21 deletions(-)
> > >
> > > diff --git a/drivers/pci/hotplug/acpiphp.h
> > > b/drivers/pci/hotplug/acpiphp.h index 5a58b07..f9e244d 100644
> > > --- a/drivers/pci/hotplug/acpiphp.h
> > > +++ b/drivers/pci/hotplug/acpiphp.h
> > > @@ -50,9 +50,6 @@
> > >  #define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME=
 ,
> > > ## arg) #define warn(format, arg...) printk(KERN_WARNING "%s: " forma=
t,
> > > MY_NAME , ## arg)
> > >
> > > -/* name size which is used for entries in pcihpfs */
> > > -#define SLOT_NAME_SIZE	20		/* {_SUN} */
> > > -
> > >  struct acpiphp_bridge;
> > >  struct acpiphp_slot;
> > >
> > > @@ -63,9 +60,13 @@ struct slot {
> > >  	struct hotplug_slot	*hotplug_slot;
> > >  	struct acpiphp_slot	*acpi_slot;
> > >  	struct hotplug_slot_info info;
> > > -	char name[SLOT_NAME_SIZE];
> > >  };
> > >
> > > +static inline const char *slot_name(struct slot *slot)
> > > +{
> > > +	return hotplug_slot_name(slot->hotplug_slot);
> > > +}
> > > +
> > >  /*
> > >   * struct acpiphp_bridge - PCI bridge information
> > >   *
> >
> > I don't see a point in this function. Why not call hotplug_slot_name()
> > directly?
>
> You're correct that we don't exactly need it in acpiphp. However,
> it is a useful helper function for some of the other drivers, and
> I thought it would be better to keep consistency if possible.

I looked into all other patches and the function is the same in every one.

> Also, it helps later on, when trying to stay below the 80 column
> limit. :)

Rip it.

> > > diff --git a/drivers/pci/hotplug/acpiphp_core.c
> > > b/drivers/pci/hotplug/acpiphp_core.c index e984176..687cac3 100644
> > > --- a/drivers/pci/hotplug/acpiphp_core.c
> > > +++ b/drivers/pci/hotplug/acpiphp_core.c
> > > @@ -44,6 +44,9 @@
> > >
> > >  #define MY_NAME	"acpiphp"
> > >
> > > +/* name size which is used for entries in pcihpfs */
> > > +#define SLOT_NAME_SIZE  20              /* {_SUN} */
> > > +
> > >  static int debug;
> > >  int acpiphp_debug;
> > >
> > > @@ -84,7 +87,6 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops
> > > =3D { .get_adapter_status	=3D get_adapter_status,
> > >  };
> > >
> > > -
> > >  /**
> > >   * acpiphp_register_attention - set attention LED callback
> > >   * @info: must be completely filled with LED callbacks
> >
> > Fuzz.
>
> Yes, it's fuzz, but my practice has been to clean up* source files
> during the course of making actual, functional changes. Better
> than sending a mostly-useless whitespace patchbomb, IMO.
>
> * Note that "clean up" here means "reasonable cleanup" that
>   doesn't detract from reading the rest of the patch.
>
> > > @@ -92,7 +94,7 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops
> > > =3D { * Description: This is used to register a hardware specific ACP=
I *
> > > driver that manipulates the attention LED.  All the fields in * info
> > > must be set.
> > > - */
> > > + **/
> > >  int acpiphp_register_attention(struct acpiphp_attention_info *info)
> > >  {
> > >  	int retval =3D -EINVAL;
> >
> > Fuzz. Make the patch look bigger than it actually is. But that's just a
> > note, Jesse will have to judge if this is acceptable.
>
> See above. Fixing incorrect kerneldoc doesn't seem so bad, IMO.

As I said: Jesse's decision. The smaller the patch is the easier get's the=
=20
review.

> > > @@ -113,7 +115,7 @@ int acpiphp_register_attention(struct
> > > acpiphp_attention_info *info) * Description: This is used to
> > > un-register a hardware specific acpi * driver that manipulates the
> > > attention LED.  The pointer to the * info struct must be the same as
> > > the one used to set it. - */
> > > + **/
> > >  int acpiphp_unregister_attention(struct acpiphp_attention_info *info)
> > >  {
> > >  	int retval =3D -EINVAL;
> > > @@ -136,7 +138,7 @@ static int enable_slot(struct hotplug_slot
> > > *hotplug_slot) {
> > >  	struct slot *slot =3D hotplug_slot->private;
> > >
> > > -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
> > >
> > >  	/* enable the specified slot */
> > >  	return acpiphp_enable_slot(slot->acpi_slot);
> > > @@ -154,7 +156,7 @@ static int disable_slot(struct hotplug_slot
> > > *hotplug_slot) struct slot *slot =3D hotplug_slot->private;
> > >  	int retval;
> > >
> > > -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
> > >
> > >  	/* disable the specified slot */
> > >  	retval =3D acpiphp_disable_slot(slot->acpi_slot);
> > > @@ -177,7 +179,7 @@ static int disable_slot(struct hotplug_slot
> > > *hotplug_slot) {
> > >  	int retval =3D -ENODEV;
> > >
> > > - 	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__,
> > > hotplug_slot_name(hotplug_slot));
> > >
> > >  	if (attention_info && try_module_get(attention_info->owner)) {
> > >  		retval =3D attention_info->set_attn(hotplug_slot, status);
> > > @@ -200,7 +202,7 @@ static int get_power_status(struct hotplug_slot
> > > *hotplug_slot, u8 *value) {
> > >  	struct slot *slot =3D hotplug_slot->private;
> > >
> > > -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
> > >
> > >  	*value =3D acpiphp_get_power_status(slot->acpi_slot);
> > >
> > > @@ -222,7 +224,7 @@ static int get_attention_status(struct hotplug_sl=
ot
> > > *hotplug_slot, u8 *value) {
> > >  	int retval =3D -EINVAL;
> > >
> > > -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__,
> > > hotplug_slot_name(hotplug_slot));
> > >
> > >  	if (attention_info && try_module_get(attention_info->owner)) {
> > >  		retval =3D attention_info->get_attn(hotplug_slot, value);
> > > @@ -245,7 +247,7 @@ static int get_latch_status(struct hotplug_slot
> > > *hotplug_slot, u8 *value) {
> > >  	struct slot *slot =3D hotplug_slot->private;
> > >
> > > -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
> > >
> > >  	*value =3D acpiphp_get_latch_status(slot->acpi_slot);
> > >
> > > @@ -265,7 +267,7 @@ static int get_adapter_status(struct hotplug_slot
> > > *hotplug_slot, u8 *value) {
> > >  	struct slot *slot =3D hotplug_slot->private;
> > >
> > > -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
> > >
> > >  	*value =3D acpiphp_get_adapter_status(slot->acpi_slot);
> > >
> > > @@ -299,7 +301,7 @@ static void release_slot(struct hotplug_slot
> > > *hotplug_slot) {
> > >  	struct slot *slot =3D hotplug_slot->private;
> > >
> > > -	dbg("%s - physical_slot =3D %s\n", __func__, hotplug_slot->name);
> > > +	dbg("%s - physical_slot =3D %s\n", __func__, slot_name(slot));
> > >
> > >  	kfree(slot->hotplug_slot);
> > >  	kfree(slot);
> > > @@ -310,6 +312,7 @@ int acpiphp_register_hotplug_slot(struct
> > > acpiphp_slot *acpiphp_slot) {
> > >  	struct slot *slot;
> > >  	int retval =3D -ENOMEM;
> > > +	char name[SLOT_NAME_SIZE];
> > >
> > >  	slot =3D kzalloc(sizeof(*slot), GFP_KERNEL);
> > >  	if (!slot)
> > > @@ -321,8 +324,6 @@ int acpiphp_register_hotplug_slot(struct
> > > acpiphp_slot *acpiphp_slot)
> > >
> > >  	slot->hotplug_slot->info =3D &slot->info;
> > >
> > > -	slot->hotplug_slot->name =3D slot->name;
> > > -
> > >  	slot->hotplug_slot->private =3D slot;
> > >  	slot->hotplug_slot->release =3D &release_slot;
> > >  	slot->hotplug_slot->ops =3D &acpi_hotplug_slot_ops;
> > > @@ -336,12 +337,13 @@ int acpiphp_register_hotplug_slot(struct
> > > acpiphp_slot *acpiphp_slot) slot->hotplug_slot->info->cur_bus_speed =
=3D
> > > PCI_SPEED_UNKNOWN;
> > >
> > >  	acpiphp_slot->slot =3D slot;
> > > -	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun=
);
> > > +	memset(name, 0, SLOT_NAME_SIZE);
> > > +	snprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
> >
> > The memset() is not needed at all. And the sizeof is IMHO a good idea
> > anyway as it allows to get rid of the define.
>
> Hm, don't need a memset? I won't have garbage on the stack?
> </n00b>

Yes, you have garbage on the stack. But snprintf() does not care what is in=
=20
the buffer before it starts and the result is 0-terminated afterwards.

> On the other hand, keeping the #define is important, because
> again, that's the established convention of the PCI hotplug
> drivers.

I would not bet on this. It has been there and copied around from one drive=
r=20
to the other. If we can get rid of those I guess noone would be upset. And=
=20
you introduced at least two of them ;) Jesse?=20

Eike

--nextPart1535349.KVXUKykLLA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkirNMQACgkQXKSJPmm5/E4i6wCfee3E80R+4ZDt8xpTo2PoZRQQ
37UAoIO7Q7EjTFGwu6OQxLxi4zWSSdFV
=jEgj
-----END PGP SIGNATURE-----

--nextPart1535349.KVXUKykLLA--
