Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbYJRUVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbYJRUVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYJRUU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:20:59 -0400
Received: from home.keithp.com ([63.227.221.253]:42834 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYJRUU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:20:58 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net
In-Reply-To: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lvwmiopHP5J6cd7OceuZ"
Date: Sat, 18 Oct 2008 13:20:48 -0700
Message-Id: <1224361248.4384.81.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lvwmiopHP5J6cd7OceuZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-18 at 12:31 -0700, Linus Torvalds wrote:

> The important thing is that mappings need to be per-CPU, so the above may=
=20
> work, but only if it's designed so that "io_reserve_pci_resource()" will=20
> actually reserve space for 'nr_possible_cpu' page mappings, and then the=20
> "io_[un]map_atomic()" functions do per-CPU mappings.

Yes, of course. The goal is to make it look exactly like
kmap_atomic_pfn, but work on non-memory pages even on non-HIGHMEM
configs for x86 (we have to use ioremap on those systems today, which is
a fairly significant performance problem).

> And quite frankly, even so, we'd possibly still be _better_ off with just=
=20
> exposing the "kmap_atomic_pfn()" functionality even so. Because quite=20
> frankly, your "io_reserve_pci_resource()" infrastructure is going to=20
> inevitably be more complex and slower than the rather efficient=20
> kmap_atomic_pfn() thing we have.

I want it to work just like kmap_atomic_pfn; Venki wanted some way to
"know" that no-one else was mapping the pages in non-WC mode. This
seemed like a reasonable compromise; the 'mapping' object exists solely
to hold the desired prot value to keep all PTEs consistent across the
whole system.

> One small detail: our we currently have "kmap_atomic_pfn()" and=20
> "kmap_atomic_prot()", and we really should maek the fundamental core=20
> operation be "kmap_atomic_pfn_prot()", and have everything be done in=20
> terms of that. Looking at it, it also looks like kmap_atomic_prot() is=20
> actually incorrect right now, and doesn't do a "prot" thing for=20
> non-highmem pages, but just returns "page_address(page);"

Fortunately, we use kmap_atomic_pfn only for our BAR, which is not a
non-highmem page.

Right now, we're counting on having our BAR covered by an MTRR register
so that we get WC access here. I'd like to have the API expose this so
that the driver will work on systems which don't have a spare MTRR for
the graphics aperture.

--=20
keith.packard@intel.com

--=-lvwmiopHP5J6cd7OceuZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI+kUgQp8BWwlsTdMRAgaoAJwL301ASzk8j7Ds3+kL3x2VzXDiqQCgrdJU
gxtBKu1opLxSHhQJjLDaITY=
=AaRs
-----END PGP SIGNATURE-----

--=-lvwmiopHP5J6cd7OceuZ--

