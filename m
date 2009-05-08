Return-Path: <linux-kernel-owner+w=401wt.eu-S1764989AbZEHAnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764989AbZEHAnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764161AbZEHA2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:28:39 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46776 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764156AbZEHA2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:28:36 -0400
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org,
       Sheng Yang <sheng@linux.intel.com>, Matthew Wilcox <matthew@wil.cx>,
       kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <200905080925.01398.rusty@rustcorp.com.au>
References: <20090507082841.GA31751@redhat.com>
	 <20090507095302.GI8112@parisc-linux.org>
	 <200905071819.54426.sheng@linux.intel.com>
	 <200905080925.01398.rusty@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/akGyiadmsixOdSIW8XY"
Date: Fri, 08 May 2009 10:28:36 +1000
Message-Id: <1241742516.7109.16.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/akGyiadmsixOdSIW8XY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-08 at 09:25 +0930, Rusty Russell wrote:
> On Thu, 7 May 2009 07:49:53 pm Sheng Yang wrote:
> > On Thursday 07 May 2009 17:53:02 Matthew Wilcox wrote:
> > > Here's a good example.  Let's suppose you have a driver which support=
s
> > > two different models of cards, one has 16 MSI-X interrupts, the other
> > > has 10.  You can call pci_enable_msix() asking for 16 vectors.  If yo=
ur
> > > card is model A, you get 16 interrupts.  If your card is model B, it =
says
> > > "you can have 10".
>=20
> Sheng is absolutely right, that's a horrid API.

It's not horrid, though it is tricky - but only for drivers that care,
you can still do:

if (pci_enable_msix(..))
	bail;

> If it actually enabled that number and returned it, it might make sense (=
cf.=20
> write() returning less bytes than you give it). =20

It could do that, but I think that would be worse. The driver, on
finding out it can only get a certain number of MSIs might need to make
a decision about how it allocates those - eg. in a network driver,
sharing them between TX/RX/management.

And in practice most of the drivers just bail if they can't get what
they asked for, so enabling less than they wanted would just mean they
have to go and disable them.

> But overloading the return=20
> value to save an explicit call is just ugly; it's not worth saving a few =
lines=20
> of code at cost of making all the drivers subtle and tricksy.

Looking at just this patch, I would agree, but unfortunately it's not
that simple. The first limitation on the number of MSIs the driver can
have is the number the device supports, that's what this patch does. But
there are others, and they come out of the arch code, or even the
firmware. So to implement pci_how_many_msis(), we'd need a parallel API
all the way down to the arch code, or a flag to all the existing
routines saying "don't really allocate, just find out". That would be
horrid IMHO.

cheers

--=-/akGyiadmsixOdSIW8XY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoDfLQACgkQdSjSd0sB4dKP6gCcD77E8GPOKSKErBgbfgInhswb
qfgAn3qcahKew9DjeMPe2YkLEp6TFW6+
=QBPB
-----END PGP SIGNATURE-----

--=-/akGyiadmsixOdSIW8XY--

