Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYGGCFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYGGCFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 22:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYGGCF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 22:05:29 -0400
Received: from ozlabs.org ([203.10.76.45]:50815 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbYGGCF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 22:05:27 -0400
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the
	msi_desc
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1215264855-4372-1-git-send-email-matthew@wil.cx>
References: <20080705132728.GO14894@parisc-linux.org>
	 <1215264855-4372-1-git-send-email-matthew@wil.cx>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-12q4CHEeiWXI1bsettkj"
Date: Mon, 07 Jul 2008 12:05:24 +1000
Message-Id: <1215396324.19157.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-12q4CHEeiWXI1bsettkj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-07-05 at 09:34 -0400, Matthew Wilcox wrote:
> This first part simply changes the msi_attrib data structure to store
> how many vectors have been allocated.  In order to do this, I shrink the
> 'type' from 5 bits to 2 and rename it to _type to catch any unsuspecting
> users.

Please don't, it significantly uglifies the code IMHO. Just add a new
field for the size, I'd rather call it qsize to match the register.

If you're worried about bloating msi_desc, there's several fields in
there that are per-device not per-desc, so we could do another patch to
move them into pci_dev or something hanging off it, eg.
pci_dev->msi_info rather than storing them in every desc.

cheers


> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 8c61304..92992a8 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -106,11 +106,11 @@ static void msix_flush_writes(unsigned int irq)
> =20
>  	entry =3D get_irq_msi(irq);
>  	BUG_ON(!entry || !entry->dev);
> -	switch (entry->msi_attrib.type) {
> -	case PCI_CAP_ID_MSI:
> +	switch (entry->msi_attrib._type) {
> +	case MSI_ATTRIB:
>  		/* nothing to do */
>  		break;
> -	case PCI_CAP_ID_MSIX:
> +	case MSIX_ATTRIB:
>  	{
>  		int offset =3D entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
>  			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> @@ -129,8 +129,8 @@ static void msi_set_mask_bits(unsigned int irq, u32 m=
ask, u32 flag)
> =20
>  	entry =3D get_irq_msi(irq);
>  	BUG_ON(!entry || !entry->dev);
> -	switch (entry->msi_attrib.type) {
> -	case PCI_CAP_ID_MSI:
> +	switch (entry->msi_attrib._type) {
> +	case MSI_ATTRIB:
>  		if (entry->msi_attrib.maskbit) {
>  			int pos;
>  			u32 mask_bits;
> @@ -144,7 +144,7 @@ static void msi_set_mask_bits(unsigned int irq, u32 m=
ask, u32 flag)
>  			msi_set_enable(entry->dev, !flag);
>  		}
>  		break;
> -	case PCI_CAP_ID_MSIX:
> +	case MSIX_ATTRIB:
>  	{
>  		int offset =3D entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
>  			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
> @@ -162,8 +162,8 @@ static void msi_set_mask_bits(unsigned int irq, u32 m=
ask, u32 flag)
>  void read_msi_msg(unsigned int irq, struct msi_msg *msg)
>  {
>  	struct msi_desc *entry =3D get_irq_msi(irq);
> -	switch(entry->msi_attrib.type) {
> -	case PCI_CAP_ID_MSI:
> +	switch(entry->msi_attrib._type) {
> +	case MSI_ATTRIB:
>  	{
>  		struct pci_dev *dev =3D entry->dev;
>  		int pos =3D entry->msi_attrib.pos;
> @@ -182,7 +182,7 @@ void read_msi_msg(unsigned int irq, struct msi_msg *m=
sg)
>  		msg->data =3D data;
>  		break;
>  	}
> -	case PCI_CAP_ID_MSIX:
> +	case MSIX_ATTRIB:
>  	{
>  		void __iomem *base;
>  		base =3D entry->mask_base +
> @@ -201,11 +201,17 @@ void read_msi_msg(unsigned int irq, struct msi_msg =
*msg)
>  void write_msi_msg(unsigned int irq, struct msi_msg *msg)
>  {
>  	struct msi_desc *entry =3D get_irq_msi(irq);
> -	switch (entry->msi_attrib.type) {
> -	case PCI_CAP_ID_MSI:
> +	switch (entry->msi_attrib._type) {
> +	case MSI_ATTRIB:
>  	{
>  		struct pci_dev *dev =3D entry->dev;
>  		int pos =3D entry->msi_attrib.pos;
> +		u16 msgctl;
> +
> +		pci_read_config_word(dev, msi_control_reg(pos), &msgctl);
> +		msgctl &=3D ~PCI_MSI_FLAGS_QSIZE;
> +		msgctl |=3D entry->msi_attrib.multiple << 4;
> +		pci_write_config_word(dev, msi_control_reg(pos), msgctl);
> =20
>  		pci_write_config_dword(dev, msi_lower_address_reg(pos),
>  					msg->address_lo);
> @@ -220,7 +226,7 @@ void write_msi_msg(unsigned int irq, struct msi_msg *=
msg)
>  		}
>  		break;
>  	}
> -	case PCI_CAP_ID_MSIX:
> +	case MSIX_ATTRIB:
>  	{
>  		void __iomem *base;
>  		base =3D entry->mask_base +
> @@ -359,7 +365,7 @@ static int msi_capability_init(struct pci_dev *dev)
>  	if (!entry)
>  		return -ENOMEM;
> =20
> -	entry->msi_attrib.type =3D PCI_CAP_ID_MSI;
> +	entry->msi_attrib._type =3D MSI_ATTRIB;
>  	entry->msi_attrib.is_64 =3D is_64bit_address(control);
>  	entry->msi_attrib.entry_nr =3D 0;
>  	entry->msi_attrib.maskbit =3D is_mask_bit_support(control);
> @@ -446,7 +452,7 @@ static int msix_capability_init(struct pci_dev *dev,
>  			break;
> =20
>   		j =3D entries[i].entry;
> -		entry->msi_attrib.type =3D PCI_CAP_ID_MSIX;
> +		entry->msi_attrib._type =3D MSIX_ATTRIB;
>  		entry->msi_attrib.is_64 =3D 1;
>  		entry->msi_attrib.entry_nr =3D j;
>  		entry->msi_attrib.maskbit =3D 1;
> @@ -589,12 +595,13 @@ void pci_msi_shutdown(struct pci_dev* dev)
>  		u32 mask =3D entry->msi_attrib.maskbits_mask;
>  		msi_set_mask_bits(dev->irq, mask, ~mask);
>  	}
> -	if (!entry->dev || entry->msi_attrib.type !=3D PCI_CAP_ID_MSI)
> +	if (!entry->dev || entry->msi_attrib._type !=3D MSI_ATTRIB)
>  		return;
> =20
>  	/* Restore dev->irq to its default pin-assertion irq */
>  	dev->irq =3D entry->msi_attrib.default_irq;
>  }
> +
>  void pci_disable_msi(struct pci_dev* dev)
>  {
>  	struct msi_desc *entry;
> @@ -605,7 +612,7 @@ void pci_disable_msi(struct pci_dev* dev)
>  	pci_msi_shutdown(dev);
> =20
>  	entry =3D list_entry(dev->msi_list.next, struct msi_desc, list);
> -	if (!entry->dev || entry->msi_attrib.type !=3D PCI_CAP_ID_MSI)
> +	if (!entry->dev || entry->msi_attrib._type !=3D MSI_ATTRIB)
>  		return;
> =20
>  	msi_free_irqs(dev);
> @@ -624,7 +631,7 @@ static int msi_free_irqs(struct pci_dev* dev)
>  	arch_teardown_msi_irqs(dev);
> =20
>  	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
> -		if (entry->msi_attrib.type =3D=3D PCI_CAP_ID_MSIX) {
> +		if (entry->msi_attrib._type =3D=3D MSIX_ATTRIB) {
>  			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
>  				  * PCI_MSIX_ENTRY_SIZE
>  				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> diff --git a/drivers/pci/msi.h b/drivers/pci/msi.h
> index 3898f52..b72e0bd 100644
> --- a/drivers/pci/msi.h
> +++ b/drivers/pci/msi.h
> @@ -22,12 +22,8 @@
>  #define msi_disable(control)		control &=3D ~PCI_MSI_FLAGS_ENABLE
>  #define multi_msi_capable(control) \
>  	(1 << ((control & PCI_MSI_FLAGS_QMASK) >> 1))
> -#define multi_msi_enable(control, num) \
> -	control |=3D (((num >> 1) << 4) & PCI_MSI_FLAGS_QSIZE);
>  #define is_64bit_address(control)	(!!(control & PCI_MSI_FLAGS_64BIT))
>  #define is_mask_bit_support(control)	(!!(control & PCI_MSI_FLAGS_MASKBIT=
))
> -#define msi_enable(control, num) multi_msi_enable(control, num); \
> -	control |=3D PCI_MSI_FLAGS_ENABLE
> =20
>  #define msix_table_offset_reg(base)	(base + 0x04)
>  #define msix_pba_offset_reg(base)	(base + 0x08)
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 8f29392..d322148 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -15,9 +15,13 @@ extern void unmask_msi_irq(unsigned int irq);
>  extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
>  extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
> =20
> +#define MSI_ATTRIB	1
> +#define MSIX_ATTRIB	2
> +
>  struct msi_desc {
>  	struct {
> -		__u8	type	: 5; 	/* {0: unused, 5h:MSI, 11h:MSI-X} */
> +		__u8	_type	: 2; 	/* {0: unused, 1:MSI, 2:MSI-X} */
> +		__u8	multiple: 3;	/* log2 number of messages */
>  		__u8	maskbit	: 1; 	/* mask-pending bit supported ?   */
>  		__u8	masked	: 1;
>  		__u8	is_64	: 1;	/* Address size: 0=3D32bit 1=3D64bit  */
--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-12q4CHEeiWXI1bsettkj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIcXnkdSjSd0sB4dIRAqZNAKCjV6PSeaj6BGsosunBsFTXP9kyuwCgiYDT
0MyLaDAbCARlC6V+UHkAyBA=
=qUcu
-----END PGP SIGNATURE-----

--=-12q4CHEeiWXI1bsettkj--

