Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZEKBXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZEKBXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZEKBWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:22:53 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60450 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbZEKBWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:22:52 -0400
Subject: Re: [PATCH] Fix MSI-X with NIU cards
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090508131333.GV8112@parisc-linux.org>
References: <20090508131333.GV8112@parisc-linux.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/HzGQDNYeIwQq60ea53E"
Date: Mon, 11 May 2009 11:21:51 +1000
Message-Id: <1242004911.7767.26.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/HzGQDNYeIwQq60ea53E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-08 at 07:13 -0600, Matthew Wilcox wrote:
> The NIU device refuses to allow accesses to MSI-X registers before MSI-X
> is enabled.  This patch fixes the problem by moving the read of the mask
> register to after MSI-X is enabled.
>=20
> Reported-by: David S. Miller <davem@davemloft.net>
> Tested-by: David S. Miller <davem@davemloft.net>
> Reviewed-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>=20
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 6f2e629..3627732 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -455,8 +455,6 @@ static int msix_capability_init(struct pci_dev *dev,
>  		entry->msi_attrib.default_irq =3D dev->irq;
>  		entry->msi_attrib.pos =3D pos;
>  		entry->mask_base =3D base;
> -		entry->masked =3D readl(base + j * PCI_MSIX_ENTRY_SIZE +
> -					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
>  		msix_mask_irq(entry, 1);

158 static void msix_mask_irq(struct msi_desc *desc, u32 flag)             =
    =20
159 {
160         u32 mask_bits =3D desc->masked;
...
165         writel(mask_bits, desc->mask_base + offset);


So I guess this device is just silently ignoring that write?

And aren't we violating the spec by writing 0x1 into the device there
(assuming desc->masked is 0x0 from the kzalloc), ie. we're supposed to
read and write back the reserved bits unchanged. (=C2=A7 6.8.2.9?)


> @@ -493,6 +491,12 @@ static int msix_capability_init(struct pci_dev *dev,
>  	msix_set_enable(dev, 1);
>  	dev->msix_enabled =3D 1;

Are we safe if we take an interrupt here?

> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		int vector =3D entry->msi_attrib.entry_nr;
> +		entry->masked =3D readl(base + vector * PCI_MSIX_ENTRY_SIZE +
> +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> +	}
> +
>  	return 0;
>  }
> =20

cheers


--=-/HzGQDNYeIwQq60ea53E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoHfa8ACgkQdSjSd0sB4dLdkQCdHYzLdYSGV+8EBmLAWmkZ8XGl
22EAn0q25RZ+bz2Zi/eNfl0jRN7Q+AFt
=vQoo
-----END PGP SIGNATURE-----

--=-/HzGQDNYeIwQq60ea53E--

