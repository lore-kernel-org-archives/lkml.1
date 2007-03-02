Return-Path: <linux-kernel-owner+w=401wt.eu-S1422785AbXCBC0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422785AbXCBC0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422786AbXCBC0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:26:53 -0500
Received: from ozlabs.org ([203.10.76.45]:44552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422785AbXCBC0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:26:52 -0500
Subject: Re: [PATCH 2/3] msi:  Fixup the msi enable/disable logic
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <m1lkijl7ms.fsf_-_@ebiederm.dsl.xmission.com>
References: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
	 <m1ps7vl7rr.fsf@ebiederm.dsl.xmission.com>
	 <m1lkijl7ms.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jBHGsqut78G9yysyj9Va"
Date: Fri, 02 Mar 2007 11:26:48 +0900
Message-Id: <1172802408.518.44.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jBHGsqut78G9yysyj9Va
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-27 at 12:31 -0700, Eric W. Biederman wrote:
> enable/disable_msi_mode have several side effects which keeps them from
> being generally useful.  So this patch replaces them with with two
> much more targeted functions: msi_set_enable and msix_set_enable.
>=20
> This patch makes pci_dev->msi_enabled and pci_dev->msix_enabled the
> definitive way to test if linux has enabled the msi capability, and
> has the appropriate msi data structures set up.
>=20
> This patch ensures that while writing the msi messages in save/restore
> and during device initialization we have the msi capability disabled
> so we don't get into races.  The pci spec requires that we do not have
> the msi capability enabled and the msi messages unmasked while we write
> the messages.  Completely disabling the capability is overkill but it
> is easy :)
>=20
> Care has been taken so we never have both a msi capability and intx
> enabled simultaneously.  We haven't run into a problem yet but better
> safe then sorry.

Hi Eric, comments below ..



> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index fd1068b..c43e7d2 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -38,6 +38,36 @@ static int msi_cache_init(void)
>  	return 0;
>  }
> =20
> +static void msi_set_enable(struct pci_dev *dev, int enable)
> +{
> +	int pos;
> +	u16 control;
> +
> +	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSI);
> +	if (pos) {
> +		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
> +		control &=3D ~PCI_MSI_FLAGS_ENABLE;
> +		if (enable)
> +			control |=3D PCI_MSI_FLAGS_ENABLE;
> +		pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
> +	}
> +}
> +
> +static void msix_set_enable(struct pci_dev *dev, int enable)
> +{
> +	int pos;
> +	u16 control;
> +
> +	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSIX);
> +	if (pos) {
> +		pci_read_config_word(dev, pos + PCI_MSIX_FLAGS, &control);
> +		control &=3D ~PCI_MSIX_FLAGS_ENABLE;
> +		if (enable)
> +			control |=3D PCI_MSIX_FLAGS_ENABLE;
> +		pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
> +	}
> +}
> +
>  static void msi_set_mask_bit(unsigned int irq, int flag)
>  {
>  	struct msi_desc *entry;
> @@ -192,44 +222,6 @@ static struct msi_desc* alloc_msi_entry(void)
>  	return entry;
>  }
> =20
> -static void enable_msi_mode(struct pci_dev *dev, int pos, int type)
> -{
> -	u16 control;
> -
> -	pci_read_config_word(dev, msi_control_reg(pos), &control);
> -	if (type =3D=3D PCI_CAP_ID_MSI) {
> -		/* Set enabled bits to single MSI & enable MSI_enable bit */
> -		msi_enable(control, 1);
> -		pci_write_config_word(dev, msi_control_reg(pos), control);
> -		dev->msi_enabled =3D 1;
> -	} else {
> -		msix_enable(control);
> -		pci_write_config_word(dev, msi_control_reg(pos), control);
> -		dev->msix_enabled =3D 1;
> -	}
> -
> -	pci_intx(dev, 0);  /* disable intx */
> -}
> -
> -static void disable_msi_mode(struct pci_dev *dev, int pos, int type)
> -{
> -	u16 control;
> -
> -	pci_read_config_word(dev, msi_control_reg(pos), &control);
> -	if (type =3D=3D PCI_CAP_ID_MSI) {
> -		/* Set enabled bits to single MSI & enable MSI_enable bit */
> -		msi_disable(control);
> -		pci_write_config_word(dev, msi_control_reg(pos), control);
> -		dev->msi_enabled =3D 0;
> -	} else {
> -		msix_disable(control);
> -		pci_write_config_word(dev, msi_control_reg(pos), control);
> -		dev->msix_enabled =3D 0;
> -	}
> -
> -	pci_intx(dev, 1);  /* enable intx */
> -}
> -
>  #ifdef CONFIG_PM
>  static int __pci_save_msi_state(struct pci_dev *dev)
>  {
> @@ -238,12 +230,11 @@ static int __pci_save_msi_state(struct pci_dev *dev=
)
>  	struct pci_cap_saved_state *save_state;
>  	u32 *cap;
> =20
> -	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSI);
> -	if (pos <=3D 0 || dev->no_msi)
> +	if (!dev->msi_enabled)
>  		return 0;
> =20
> -	pci_read_config_word(dev, msi_control_reg(pos), &control);
> -	if (!(control & PCI_MSI_FLAGS_ENABLE))
> +	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSI);
> +	if (pos <=3D 0)
>  		return 0;
> =20
>  	save_state =3D kzalloc(sizeof(struct pci_cap_saved_state) + sizeof(u32)=
 * 5,
> @@ -276,13 +267,18 @@ static void __pci_restore_msi_state(struct pci_dev =
*dev)
>  	struct pci_cap_saved_state *save_state;
>  	u32 *cap;
> =20
> +	if (!dev->msi_enabled)
> +		return;
> +
>  	save_state =3D pci_find_saved_cap(dev, PCI_CAP_ID_MSI);
>  	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSI);
>  	if (!save_state || pos <=3D 0)
>  		return;
>  	cap =3D &save_state->data[0];
> =20
> +	pci_intx(dev, 0);		/* disable intx */
>  	control =3D cap[i++] >> 16;
> +	msi_set_enable(dev, 0);
>  	pci_write_config_dword(dev, pos + PCI_MSI_ADDRESS_LO, cap[i++]);
>  	if (control & PCI_MSI_FLAGS_64BIT) {
>  		pci_write_config_dword(dev, pos + PCI_MSI_ADDRESS_HI, cap[i++]);
> @@ -292,7 +288,6 @@ static void __pci_restore_msi_state(struct pci_dev *d=
ev)
>  	if (control & PCI_MSI_FLAGS_MASKBIT)
>  		pci_write_config_dword(dev, pos + PCI_MSI_MASK_BIT, cap[i++]);
>  	pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
> -	enable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
>  	pci_remove_saved_cap(save_state);
>  	kfree(save_state);
>  }

I get the reasoning for disabling MSI before we start writing back the
config space, but don't we want to re-enable MSI on the way out?

> @@ -308,13 +303,11 @@ static int __pci_save_msix_state(struct pci_dev *de=
v)
>  		return 0;
> =20
>  	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSIX);
> -	if (pos <=3D 0 || dev->no_msi)
> +	if (pos <=3D 0)
>  		return 0;
> =20
>  	/* save the capability */
>  	pci_read_config_word(dev, msi_control_reg(pos), &control);
> -	if (!(control & PCI_MSIX_FLAGS_ENABLE))
> -		return 0;
>  	save_state =3D kzalloc(sizeof(struct pci_cap_saved_state) + sizeof(u16)=
,
>  		GFP_KERNEL);
>  	if (!save_state) {
> @@ -376,6 +369,8 @@ static void __pci_restore_msix_state(struct pci_dev *=
dev)
>  		return;
> =20
>  	/* route the table */
> +	pci_intx(dev, 0);		/* disable intx */
> +	msix_set_enable(dev, 0);
>  	irq =3D head =3D dev->first_msi_irq;
>  	while (head !=3D tail) {
>  		entry =3D get_irq_msi(irq);
> @@ -386,7 +381,6 @@ static void __pci_restore_msix_state(struct pci_dev *=
dev)
>  	}
> =20
>  	pci_write_config_word(dev, msi_control_reg(pos), save);
> -	enable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
>  }
> =20
>  void pci_restore_msi_state(struct pci_dev *dev)

Ditto here.

cheers

> @@ -411,6 +405,8 @@ static int msi_capability_init(struct pci_dev *dev)
>  	int pos, irq;
>  	u16 control;
> =20
> +	msi_set_enable(dev, 0);	/* Ensure msi is disabled as I set it up */
> +
>     	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSI);
>  	pci_read_config_word(dev, msi_control_reg(pos), &control);
>  	/* MSI Entry Initialization */
> @@ -454,7 +450,9 @@ static int msi_capability_init(struct pci_dev *dev)
>  	set_irq_msi(irq, entry);
> =20
>  	/* Set MSI enabled bits	 */
> -	enable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
> +	pci_intx(dev, 0);		/* disable intx */
> +	msi_set_enable(dev, 1);
> +	dev->msi_enabled =3D 1;
> =20
>  	dev->irq =3D irq;
>  	return 0;
> @@ -481,6 +479,8 @@ static int msix_capability_init(struct pci_dev *dev,
>  	u8 bir;
>  	void __iomem *base;
> =20
> +	msix_set_enable(dev, 0);/* Ensure msix is disabled as I set it up */
> +
>     	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSIX);
>  	/* Request & Map MSI-X table region */
>   	pci_read_config_word(dev, msi_control_reg(pos), &control);
> @@ -549,7 +549,9 @@ static int msix_capability_init(struct pci_dev *dev,
>  	}
>  	dev->first_msi_irq =3D entries[0].vector;
>  	/* Set MSI-X enabled bits */
> -	enable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
> +	pci_intx(dev, 0);		/* disable intx */
> +	msix_set_enable(dev, 1);
> +	dev->msix_enabled =3D 1;
> =20
>  	return 0;
>  }
> @@ -611,12 +613,11 @@ int pci_enable_msi(struct pci_dev* dev)
>  	WARN_ON(!!dev->msi_enabled);
> =20
>  	/* Check whether driver already requested for MSI-X irqs */
> -	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSIX);
> -	if (pos > 0 && dev->msix_enabled) {
> -			printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
> -			       "Device already has MSI-X enabled\n",
> -			       pci_name(dev));
> -			return -EINVAL;
> +	if (dev->msix_enabled) {
> +		printk(KERN_INFO "PCI: %s: Can't enable MSI.  "
> +			"Device already has MSI-X enabled\n",
> +			pci_name(dev));
> +		return -EINVAL;
>  	}
>  	status =3D msi_capability_init(dev);
>  	return status;
> @@ -625,8 +626,7 @@ int pci_enable_msi(struct pci_dev* dev)
>  void pci_disable_msi(struct pci_dev* dev)
>  {
>  	struct msi_desc *entry;
> -	int pos, default_irq;
> -	u16 control;
> +	int default_irq;
> =20
>  	if (!pci_msi_enable)
>  		return;
> @@ -636,16 +636,9 @@ void pci_disable_msi(struct pci_dev* dev)
>  	if (!dev->msi_enabled)
>  		return;
> =20
> -	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSI);
> -	if (!pos)
> -		return;
> -
> -	pci_read_config_word(dev, msi_control_reg(pos), &control);
> -	if (!(control & PCI_MSI_FLAGS_ENABLE))
> -		return;
> -
> -
> -	disable_msi_mode(dev, pos, PCI_CAP_ID_MSI);
> +	msi_set_enable(dev, 0);
> +	pci_intx(dev, 1);		/* enable intx */
> +	dev->msi_enabled =3D 0;
> =20
>  	entry =3D get_irq_msi(dev->first_msi_irq);
>  	if (!entry || !entry->dev || entry->msi_attrib.type !=3D PCI_CAP_ID_MSI=
) {
> @@ -746,8 +739,7 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_=
entry *entries, int nvec)
>  	WARN_ON(!!dev->msix_enabled);
> =20
>  	/* Check whether driver already requested for MSI irq */
> -   	if (pci_find_capability(dev, PCI_CAP_ID_MSI) > 0 &&
> -		dev->msi_enabled) {
> +   	if (dev->msi_enabled) {
>  		printk(KERN_INFO "PCI: %s: Can't enable MSI-X.  "
>  		       "Device already has an MSI irq assigned\n",
>  		       pci_name(dev));
> @@ -760,8 +752,6 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_=
entry *entries, int nvec)
>  void pci_disable_msix(struct pci_dev* dev)
>  {
>  	int irq, head, tail =3D 0, warning =3D 0;
> -	int pos;
> -	u16 control;
> =20
>  	if (!pci_msi_enable)
>  		return;
> @@ -771,15 +761,9 @@ void pci_disable_msix(struct pci_dev* dev)
>  	if (!dev->msix_enabled)
>  		return;
> =20
> -	pos =3D pci_find_capability(dev, PCI_CAP_ID_MSIX);
> -	if (!pos)
> -		return;
> -
> -	pci_read_config_word(dev, msi_control_reg(pos), &control);
> -	if (!(control & PCI_MSIX_FLAGS_ENABLE))
> -		return;
> -
> -	disable_msi_mode(dev, pos, PCI_CAP_ID_MSIX);
> +	msix_set_enable(dev, 0);
> +	pci_intx(dev, 1);		/* enable intx */
> +	dev->msix_enabled =3D 0;
> =20
>  	irq =3D head =3D dev->first_msi_irq;
>  	while (head !=3D tail) {
--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-jBHGsqut78G9yysyj9Va
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBF54todSjSd0sB4dIRAjebAJ9R4hepnknmZelfE8udLpsGza3x6ACgmtow
UYhD7OKETo8lVUnRTKXPWsU=
=tH2d
-----END PGP SIGNATURE-----

--=-jBHGsqut78G9yysyj9Va--

