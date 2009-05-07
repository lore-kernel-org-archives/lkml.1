Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZEGKYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZEGKYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbZEGKXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:23:52 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48801 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbZEGKXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:23:51 -0400
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sheng Yang <sheng@linux.intel.com>, kvm@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <20090507095302.GI8112@parisc-linux.org>
References: <20090507082841.GA31751@redhat.com>
	 <200905071651.24970.sheng@linux.intel.com>
	 <20090507092731.GH8112@parisc-linux.org>
	 <200905071740.16190.sheng@linux.intel.com>
	 <20090507095302.GI8112@parisc-linux.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m2R9BftWir2uHsr+ok1d"
Date: Thu, 07 May 2009 20:23:50 +1000
Message-Id: <1241691830.24385.6.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m2R9BftWir2uHsr+ok1d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-07 at 03:53 -0600, Matthew Wilcox wrote:
> On Thu, May 07, 2009 at 05:40:15PM +0800, Sheng Yang wrote:
> > It's indeed weird. Why the semantic of pci_enable_msix can be changed t=
o=20
> > "enable msix, or tell me how many vector do you have"? You can simply c=
all=20
> > pci_msix_table_size() to get what you want, also without any more work,=
 no? I=20
> > can't understand...
>=20
> Here's a good example.  Let's suppose you have a driver which supports
> two different models of cards, one has 16 MSI-X interrupts, the other
> has 10.  You can call pci_enable_msix() asking for 16 vectors.  If your
> card is model A, you get 16 interrupts.  If your card is model B, it says
> "you can have 10".
>=20
> This is less work in the driver (since it must implement falling back to
> a smaller number of interrupts *anyway*) than interrogating the card to
> find out how many interrupts there are, then requesting the right number,
> and still having the fallback path which is going to be less tested.

Not to mention that there's no guarantee that you'll get as many
interrupts as the device supports, so you should really be coding to
cope with that anyway. Like the example in MSI-HOWTO.txt:

197 static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec=
)
198 {
199         while (nvec >=3D FOO_DRIVER_MINIMUM_NVEC) {
200                 rc =3D pci_enable_msix(adapter->pdev,
201                                      adapter->msix_entries, nvec);
202                 if (rc > 0)
203                         nvec =3D rc;
204                 else
205                         return rc;
206         }
207=20
208         return -ENOSPC;
209 }

So I agree, this patch is an improvement.

cheers

--=-m2R9BftWir2uHsr+ok1d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoCtrYACgkQdSjSd0sB4dL2gwCgrXfph8c4uRWAhCra5/I9baEu
gk4An1J3CXjRtaSME8/2wFqVcq3Tqq97
=jczb
-----END PGP SIGNATURE-----

--=-m2R9BftWir2uHsr+ok1d--

