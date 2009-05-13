Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbZEMGbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbZEMGbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZEMGb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:31:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:41959 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZEMGb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:31:27 -0400
Subject: Re: [PATCH] PCI MSI: Yet another fix for MSI-X with NIU cards, v2
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A0A5556.9050209@jp.fujitsu.com>
References: <20090508131333.GV8112@parisc-linux.org>
	 <4A0A5284.1000705@jp.fujitsu.com>  <4A0A5556.9050209@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f7BwNxaa2xkWSXboEhA7"
Date: Wed, 13 May 2009 16:31:26 +1000
Message-Id: <1242196286.18059.88.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f7BwNxaa2xkWSXboEhA7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 14:06 +0900, Hidetoshi Seto wrote:
> The NIU device refuses to allow accesses to MSI-X registers before MSI-X
> is enabled.  This patch fixes the problem by moving the read & write the
> mask register (for preserved bits) to after MSI-X is enabled.
>=20
> Reported-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  drivers/pci/msi.c |   21 ++++++++++++++++++---
>  1 files changed, 18 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 6f2e629..44085e0 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -455,9 +455,7 @@ static int msix_capability_init(struct pci_dev *dev,
>  		entry->msi_attrib.default_irq =3D dev->irq;
>  		entry->msi_attrib.pos =3D pos;
>  		entry->mask_base =3D base;
> -		entry->masked =3D readl(base + j * PCI_MSIX_ENTRY_SIZE +
> -					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> -		msix_mask_irq(entry, 1);
> +		entry->masked =3D 1;
> =20
>  		list_add_tail(&entry->list, &dev->msi_list);
>  	}
> @@ -493,6 +491,23 @@ static int msix_capability_init(struct pci_dev *dev,
>  	msix_set_enable(dev, 1);
>  	dev->msix_enabled =3D 1;
> =20
> +	/*
> +	 * The states of Reserved bits[31:01] of Vector Control for MSI-X
> +	 * Table Entries must be 0.  However, for potential future use,
> +	 * software must preserve the value of these reserved bits.
> +	 * Refer PCI spec 3.0, 6.8.2.9.
> +	 *
> +	 * Note that there are some device that refuses access to MSI-X
> +	 * Table Entries before MSI-X is enabled.  Therefore we do it here.=20
> +	 */
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		int vector =3D entry->msi_attrib.entry_nr;
> +		entry->masked =3D readl(base + vector * PCI_MSIX_ENTRY_SIZE +
> +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
> +		/* Make sure it is masked */
> +		msix_mask_irq(entry, 1);
> +	}
> +
>  	return 0;
>  }

That looks better to me, hopefully it fixes DaveM's device too :)

Acked-by: Michael Ellerman <michael@ellerman.id.au>

cheers
=20


--=-f7BwNxaa2xkWSXboEhA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoKaT4ACgkQdSjSd0sB4dKsywCfZiPQWnsrWVqkCyqps5MzPIlg
n7wAoJL+vDU0b+BdjkBuHdMsQT15HQ7W
=oR3+
-----END PGP SIGNATURE-----

--=-f7BwNxaa2xkWSXboEhA7--

