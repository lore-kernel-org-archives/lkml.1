Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZEMEtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZEMEtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZEMEtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:49:23 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52670 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZEMEtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:49:22 -0400
Subject: Re: [PATCH] Fix MSI-X with NIU cards
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A0A4F4A.7030101@jp.fujitsu.com>
References: <20090508131333.GV8112@parisc-linux.org>
	 <1242004911.7767.26.camel@concordia> <4A0A472A.8090301@jp.fujitsu.com>
	 <4A0A4F4A.7030101@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ORwRUBunQJpN022+2voM"
Date: Wed, 13 May 2009 14:49:22 +1000
Message-Id: <1242190162.18059.82.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ORwRUBunQJpN022+2voM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 13:40 +0900, Hidetoshi Seto wrote:
> Hidetoshi Seto wrote:
> > It seems that this issue was introduced by Matthew's commit:
> > commit f2440d9acbe866b917b16cc0f927366341ce9215
> > <quote>
> > @@ -435,11 +432,12 @@ static int msix_capability_init(struct pci_dev *d=
ev,
> >                 entry->msi_attrib.is_msix =3D 1;
> >                 entry->msi_attrib.is_64 =3D 1;
> >                 entry->msi_attrib.entry_nr =3D j;
> > -               entry->msi_attrib.maskbit =3D 1;
> > -               entry->msi_attrib.masked =3D 1;
> >                 entry->msi_attrib.default_irq =3D dev->irq;
> >                 entry->msi_attrib.pos =3D pos;
> >                 entry->mask_base =3D base;
> > +               entry->masked =3D readl(base + j * PCI_MSIX_ENTRY_SIZE =
+
> > +                                       PCI_MSIX_ENTRY_VECTOR_CTRL_OFFS=
ET);
> > +               msix_mask_irq(entry, 1);
> >=20
> >                 list_add_tail(&entry->list, &dev->msi_list);
> >         }
> > </quote>
> >=20
> > I'm not sure why Matthew changed it to read/write...
>=20
> Sorry, I got it.
>=20
> The problem is not the bit[0] for mask, but the reserved bits[31::01].
> According to the Spec:
> "31::01 Reserved=20
>   After reset, the state of these bits must be 0.
>   However, for potential future use, software must preserve the value of
>   these reserved bits when modifying the value of other Vector Control bi=
ts.
>   If software modifies the value of these reserved bits, the result is
>   undefined."

Yes that's what I was referring to about it being out of spec.

So to work around the NIU bug and be in spec I think we need to enable
MSI, then read the mask bits, then write them back with the mask bit
set.

cheers


--=-ORwRUBunQJpN022+2voM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoKUU4ACgkQdSjSd0sB4dJ+0ACfdcLEJk7bVen8ArQ1jyYuwKvw
aB8AnR9QaQBQb1YFmTNbgYLD5mq0ldfX
=GNMK
-----END PGP SIGNATURE-----

--=-ORwRUBunQJpN022+2voM--

