Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYFZFde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYFZFde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYFZFdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:33:23 -0400
Received: from home.keithp.com ([63.227.221.253]:3693 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYFZFdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:33:22 -0400
Subject: Re: kmap_atomic_pfn for PCI BAR access?
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@gmail.com>
Cc: keithp@keithp.com, Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <21d7e9970806252202i10de9c82lb4637d9f1064f0b0@mail.gmail.com>
References: <1214242487.11887.35.camel@koto.keithp.com>
	 <4862EE4C.4060009@goop.org>
	 <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
	 <20080625213603.0e82805b@infradead.org>
	 <21d7e9970806252202i10de9c82lb4637d9f1064f0b0@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SzqGExkRK4K6m7iCPLyR"
Date: Wed, 25 Jun 2008 22:33:13 -0700
Message-Id: <1214458393.1044.42.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SzqGExkRK4K6m7iCPLyR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-26 at 15:02 +1000, Dave Airlie wrote:

> Thats why keithp wants something like kmap_atomic but for ioremap
> instead of kmaps.

Right, the usage is precisely the same as kmap_atomic -- reading and
writing from a wide range of physical addresses without needing either
permanent map nor taking the huge cost of TLB flushing.

The existing kmap_atomic_pfn is exactly what I need (modulo the lack of
prot bits), except that it only handles non-memory pages on kernels with
CONFIG_HIGHMEM set.

It seems like making this function work on non-HIGHMEM kernels would
require only the reservation of the same few PTEs that HIGHMEM kernels
use, along with suitable hacking to make them work.

> This would be for short temporary ioremaps like kmap_atomic is.

For an integrated graphics device, this is just an optimization. I take
physical pages, map them to the graphics GTT which makes them visible to
the CPU up in I/O space. Then, I map address in the GTT back to the CPU
with kmap_atomic_pfn and viola -- WC mapped access to regular pages, all
without touching the low memory mappings.

Before trying this, we just mapped the 'real' address of the page and
then used clflush to get the contents out to memory where the graphics
device could pick it up. However, the clflush is fairly expensive,
enough so that using the WC mapping turns out to be faster in practice.

Beyond simple integrated graphics performance benefits, we're looking
towards discrete graphics cards where we need to write to VRAM which can
only be made visible through the aperture; in that environment, we're
stuck choosing between ioremap (urf) or the same kmap_atomic_pfn as
above. In this case, there's no question that kmap_atomic_pfn will be a
huge performance benefit.

--=20
keith.packard@intel.com

--=-SzqGExkRK4K6m7iCPLyR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIYyoZQp8BWwlsTdMRAtGHAJ9SwssxRzjs8WjznJiqUi4u9MMMSgCgwns/
iUgc+jjVquxf40QOdob/X/g=
=lJEB
-----END PGP SIGNATURE-----

--=-SzqGExkRK4K6m7iCPLyR--

