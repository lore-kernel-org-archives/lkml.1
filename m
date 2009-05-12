Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbZELCVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbZELCVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbZELCV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:21:28 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51344 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbZELCV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:21:27 -0400
Subject: Re: [PATCH] Fix MSI-X with NIU cards
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090511.164017.116664605.davem@davemloft.net>
References: <1242004911.7767.26.camel@concordia>
	 <20090510.223645.193708481.davem@davemloft.net>
	 <1242052211.7011.4.camel@concordia>
	 <20090511.164017.116664605.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GjJiVWLdYs1x1jPVsSmk"
Date: Tue, 12 May 2009 12:21:26 +1000
Message-Id: <1242094886.7421.26.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GjJiVWLdYs1x1jPVsSmk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 16:40 -0700, David Miller wrote:
> From: Michael Ellerman <michael@ellerman.id.au>
> Date: Tue, 12 May 2009 00:30:11 +1000
>=20
> > On Sun, 2009-05-10 at 22:36 -0700, David Miller wrote:
> >> From: Michael Ellerman <michael@ellerman.id.au>
> >> Date: Mon, 11 May 2009 11:21:51 +1000
> >>=20
> >> > So I guess this device is just silently ignoring that write?
> >>=20
> >> No, it signals a fault on the PCI bus, which is how we noticed
> >> this problem in the first place.
> >=20
> > But the patch doesn't change that? It just removes the readl AFAICS:
>=20
> I'm on slow satellite internet here out in the ocean, so I wish
> the author of this patch would help with your feedback :-/

Me too :) *cough*

> > Or has msix_mask_irq() changed since 413f81eba?
>=20
> You could ask GIT, and to answer your question, indeed it has.

Sorry it was late. I don't think it has actually:

concordia powerpc $ git log 413f81eba..1d80cac0f drivers/pci/msi.c=20
concordia powerpc $=20

And I don't see any changes in Jesse's git tree via gitweb.

I still see:

158 static void msix_mask_irq(struct msi_desc *desc, u32 flag)             =
    =20
159 {
160         u32 mask_bits =3D desc->masked;
161         unsigned offset =3D desc->msi_attrib.entry_nr * PCI_MSIX_ENTRY_=
SIZE +
162                                         PCI_MSIX_ENTRY_VECTOR_CTRL_OFFS=
ET;
163         mask_bits &=3D ~1;
164         mask_bits |=3D flag;
165         writel(mask_bits, desc->mask_base + offset);
166         desc->masked =3D mask_bits;
167 }

So I don't see how this patch works, all it's doing is moving the readl().

> Please don't stall this patch very much, as the bug it is fixing konks
> out one of my primary test machines from even booting up.

Sure, chuck it in. I just don't get how it's solving the problem, and it
looks like it's writing to the mask bit without reading the reserved
ones first, which seems to violate the spec AFAICS[1]. But we can fix it
later.

cheers

[1]: I probably don't have the latest version.

--=-GjJiVWLdYs1x1jPVsSmk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoI3SIACgkQdSjSd0sB4dLu1QCghJykMBNfBbxcjKi6gQRO9IJ8
HKkAnRemDWXbc8kdt+veMx9Lw/xeltCe
=uRej
-----END PGP SIGNATURE-----

--=-GjJiVWLdYs1x1jPVsSmk--

