Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbZCCARF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbZCCARF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbZCCAQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:16:20 -0500
Received: from ozlabs.org ([203.10.76.45]:44549 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759609AbZCCAQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:16:16 -0500
Subject: Re: [PATCH 5/6] PCI MSI: Refactor interrupt masking code
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1235410082-5016-6-git-send-email-matthew@wil.cx>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx>
	 <1235410082-5016-6-git-send-email-matthew@wil.cx>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BZxO6XPVeZxQEfrQT4hV"
Date: Tue, 03 Mar 2009 11:16:12 +1100
Message-Id: <1236039372.8230.106.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BZxO6XPVeZxQEfrQT4hV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 12:28 -0500, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
>=20
> Since most of the callers already know whether they have an MSI or
> an MSI-X capability, split msi_set_mask_bits() into msi_mask_irq()
> and msix_mask_irq().  The only callers which don't (mask_msi_irq()
> and unmask_msi_irq()) can share code in msi_set_mask_bit().  This then
> becomes the only caller of msix_flush_writes(), so we can inline it.
> The flushing read can be to any address that belongs to the device,
> so we can eliminate the calculation too.
>=20
> We can also get rid of maskbits_mask from struct msi_desc and simply
> recalculate it on the rare occasion that we need it.  The single-bit
> 'masked' element is replaced by a copy of the 32-bit 'masked' register,
> so this patch does not affect the size of msi_desc.
>=20
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/pci/msi.c   |  157 +++++++++++++++++++++++++--------------------=
------
>  include/linux/msi.h |    5 +-
>  2 files changed, 79 insertions(+), 83 deletions(-)
>=20
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index fcde04d..41f18cb 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -105,17 +105,14 @@ static inline __attribute_const__ u32 msi_mask(unsi=
gned x)
>  	return (1 << (1 << x)) - 1;
>  }
> =20
> -static void msix_flush_writes(struct irq_desc *desc)
> +static inline __attribute_const__ u32 msi_capable_mask(u16 control)
>  {

/me wonders why this is __attribute_const__ and not __const like all the
other shorthands, but not your fault.

> @@ -127,34 +124,62 @@ static void msix_flush_writes(struct irq_desc *desc=
)
>   * Returns 1 if it succeeded in masking the interrupt and 0 if the devic=
e
>   * doesn't support MSI masking.
>   */
> -static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
> +static int msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
>  {
> -	struct msi_desc *entry;
> +	u32 mask_bits =3D desc->masked;
> =20
> -	entry =3D get_irq_desc_msi(desc);
> -	BUG_ON(!entry);
> -	if (entry->msi_attrib.is_msix) {
> -		int offset =3D entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
> -			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> -		writel(flag, entry->mask_base + offset);
> -		readl(entry->mask_base + offset);
> -	} else {
> -		int pos;
> -		u32 mask_bits;
> +	if (!desc->msi_attrib.maskbit)
> +		return 0;
> =20
> -		if (!entry->msi_attrib.maskbit)
> -			return 0;
> +	mask_bits &=3D ~mask;
> +	mask_bits |=3D flag;
> +	pci_write_config_dword(desc->dev, desc->mask_pos, mask_bits);
> +	desc->masked =3D mask_bits;
> =20
> -		pos =3D entry->mask_pos;
> -		pci_read_config_dword(entry->dev, pos, &mask_bits);
> -		mask_bits &=3D ~mask;
> -		mask_bits |=3D flag & mask;
> -		pci_write_config_dword(entry->dev, pos, mask_bits);
> -	}
> -	entry->msi_attrib.masked =3D !!flag;
>  	return 1;
>  }
> =20
> +/*
> + * This internal function does not flush PCI writes to the device.
> + * All users must ensure that they read from the device before either
> + * assuming that the device state is up to date, or returning out of thi=
s
> + * file.  This saves a few milliseconds when initialising devices with l=
ots
> + * of MSI-X interrupts.
> + */
> +static void msix_mask_irq(struct msi_desc *desc, u32 flag)
> +{
> +	u32 mask_bits =3D desc->masked;
> +	unsigned offset =3D desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
> +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> +	mask_bits &=3D ~1;
> +	mask_bits |=3D flag;
> +	writel(mask_bits, desc->mask_base + offset);
> +	desc->masked =3D mask_bits;
> +}
> +
> +static int msi_set_mask_bit(unsigned irq, u32 flag)
> +{
> +	struct msi_desc *desc =3D get_irq_msi(irq);
> +
> +	if (desc->msi_attrib.is_msix) {
> +		msix_mask_irq(desc, flag);
> +		readl(desc->mask_base);		/* Flush write to device */
> +		return 1;
> +	} else {
> +		return msi_mask_irq(desc, 1, flag);
> +	}
> +}
> +
> +void mask_msi_irq(unsigned int irq)
> +{
> +	msi_set_mask_bit(irq, 1);
> +}
> +
> +void unmask_msi_irq(unsigned int irq)
> +{
> +	msi_set_mask_bit(irq, 0);
> +}

I don't see why msi_set_mask_bit() or msi_mask_irq() need to return
anything, their return values are never used AFAICT.

> +
>  void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
>  {
>  	struct msi_desc *entry =3D get_irq_desc_msi(desc);
> @@ -230,22 +255,6 @@ void write_msi_msg(unsigned int irq, struct msi_msg =
*msg)
>  	write_msi_msg_desc(desc, msg);
>  }
> =20
> -void mask_msi_irq(unsigned int irq)
> -{
> -	struct irq_desc *desc =3D irq_to_desc(irq);
> -
> -	msi_set_mask_bits(desc, 1, 1);
> -	msix_flush_writes(desc);
> -}
> -
> -void unmask_msi_irq(unsigned int irq)
> -{
> -	struct irq_desc *desc =3D irq_to_desc(irq);
> -
> -	msi_set_mask_bits(desc, 1, 0);
> -	msix_flush_writes(desc);
> -}
> -
>  static int msi_free_irqs(struct pci_dev* dev);
> =20
>  static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
> @@ -281,13 +290,9 @@ static void __pci_restore_msi_state(struct pci_dev *=
dev)
>  	pci_intx_for_msi(dev, 0);
>  	msi_set_enable(dev, 0);
>  	write_msi_msg(dev->irq, &entry->msg);
> -	if (entry->msi_attrib.maskbit) {
> -		struct irq_desc *desc =3D irq_to_desc(dev->irq);
> -		msi_set_mask_bits(desc, entry->msi_attrib.maskbits_mask,
> -				  entry->msi_attrib.masked);
> -	}
> =20
>  	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
> +	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
>  	control &=3D ~PCI_MSI_FLAGS_QSIZE;
>  	control |=3D PCI_MSI_FLAGS_ENABLE;
>  	pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
> @@ -307,9 +312,8 @@ static void __pci_restore_msix_state(struct pci_dev *=
dev)
>  	msix_set_enable(dev, 0);
> =20
>  	list_for_each_entry(entry, &dev->msi_list, list) {
> -		struct irq_desc *desc =3D irq_to_desc(entry->irq);
>  		write_msi_msg(entry->irq, &entry->msg);
> -		msi_set_mask_bits(desc, 1, entry->msi_attrib.masked);
> +		msix_mask_irq(entry, entry->masked);
>  	}
> =20
>  	BUG_ON(list_empty(&dev->msi_list));
> @@ -342,6 +346,7 @@ static int msi_capability_init(struct pci_dev *dev)
>  	struct msi_desc *entry;
>  	int pos, ret;
>  	u16 control;
> +	unsigned mask;
> =20
>  	msi_set_enable(dev, 0);	/* Ensure msi is disabled as I set it up */
> =20
> @@ -356,21 +361,15 @@ static int msi_capability_init(struct pci_dev *dev)
>  	entry->msi_attrib.is_64 =3D is_64bit_address(control);
>  	entry->msi_attrib.entry_nr =3D 0;
>  	entry->msi_attrib.maskbit =3D is_mask_bit_support(control);
> -	entry->msi_attrib.masked =3D 1;
>  	entry->msi_attrib.default_irq =3D dev->irq;	/* Save IOAPIC IRQ */
>  	entry->msi_attrib.pos =3D pos;
> -	if (entry->msi_attrib.maskbit) {
> -		unsigned int base, maskbits, temp;
> -
> -		base =3D msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
> -		entry->mask_pos =3D base;
> -		/* All MSIs are unmasked by default, Mask them all */
> -		pci_read_config_dword(dev, base, &maskbits);
> -		temp =3D msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);
> -		maskbits |=3D temp;
> -		pci_write_config_dword(dev, base, maskbits);
> -		entry->msi_attrib.maskbits_mask =3D temp;
> -	}
> +
> +	entry->mask_pos =3D msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
> +	/* All MSIs are unmasked by default, Mask them all */
> +	pci_read_config_dword(dev, entry->mask_pos, &entry->masked);
> +	mask =3D msi_capable_mask(control);
> +	msi_mask_irq(entry, mask, mask);

This looked a little weird at first, in that we're unconditionally doing
the mask - but we're not, msi_mask_irq() checks for us. I guess it's no
drama reading from mask_pos even if it's not implemented.

> @@ -435,11 +434,12 @@ static int msix_capability_init(struct pci_dev *dev=
,
>  		entry->msi_attrib.is_msix =3D 1;
>  		entry->msi_attrib.is_64 =3D 1;
>  		entry->msi_attrib.entry_nr =3D j;
> -		entry->msi_attrib.maskbit =3D 1;
> -		entry->msi_attrib.masked =3D 1;
>  		entry->msi_attrib.default_irq =3D dev->irq;
>  		entry->msi_attrib.pos =3D pos;
>  		entry->mask_base =3D base;
> +		entry->masked =3D readl(base + j * PCI_MSIX_ENTRY_SIZE +
> +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> +		msix_mask_irq(entry, 1);

I was going to say "why bother with the readl". But checking the spec,
the rest of the bits are reserved and we mustn't muck with them.

> @@ -556,9 +556,11 @@ int pci_enable_msi(struct pci_dev* dev)
>  }
>  EXPORT_SYMBOL(pci_enable_msi);
> =20
> -void pci_msi_shutdown(struct pci_dev* dev)
> +void pci_msi_shutdown(struct pci_dev *dev)
>  {
> -	struct msi_desc *entry;
> +	struct msi_desc *desc;
> +	u32 mask;
> +	u16 ctrl;
> =20
>  	if (!pci_msi_enable || !dev || !dev->msi_enabled)
>  		return;
> @@ -568,18 +570,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
>  	dev->msi_enabled =3D 0;
> =20
>  	BUG_ON(list_empty(&dev->msi_list));
> -	entry =3D list_entry(dev->msi_list.next, struct msi_desc, list);
> -	/* Return the the pci reset with msi irqs unmasked */
> -	if (entry->msi_attrib.maskbit) {
> -		u32 mask =3D entry->msi_attrib.maskbits_mask;
> -		struct irq_desc *desc =3D irq_to_desc(dev->irq);
> -		msi_set_mask_bits(desc, mask, ~mask);
> -	}
> -	if (entry->msi_attrib.is_msix)
> -		return;

You loose this return case, but we should never have hit it AFAICS
because of the check of !dev->msi_enabled earlier - so I think it's ok.

> +	desc =3D list_first_entry(&dev->msi_list, struct msi_desc, list);
> +	pci_read_config_word(dev, desc->msi_attrib.pos + PCI_MSI_FLAGS, &ctrl);
> +	mask =3D msi_capable_mask(ctrl);
> +	msi_mask_irq(desc, mask, ~mask);
> =20
>  	/* Restore dev->irq to its default pin-assertion irq */
> -	dev->irq =3D entry->msi_attrib.default_irq;
> +	dev->irq =3D desc->msi_attrib.default_irq;
>  }


cheers=20

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-BZxO6XPVeZxQEfrQT4hV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmsdswACgkQdSjSd0sB4dJ0WwCfYek21YVBSIFmnuQ77j7C+OuG
zNMAoMt3XFsDQdDHFhbrQszIssjWbJNZ
=Sibt
-----END PGP SIGNATURE-----

--=-BZxO6XPVeZxQEfrQT4hV--

