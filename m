Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYJXEaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYJXEaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYJXEaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:30:07 -0400
Received: from home.keithp.com ([63.227.221.253]:55938 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYJXEaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:30:06 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, nickpiggin@yahoo.com.au, airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org,
       Peter Anvin <hpa@zytor.com>
In-Reply-To: <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	  <20081018223214.GA5093@elte.hu>
	 <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	  <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
	 <1224813015.22877.51.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uSkJQIlKOAAWBXLGYY2Q"
Date: Thu, 23 Oct 2008 21:29:52 -0700
Message-Id: <1224822592.22877.71.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uSkJQIlKOAAWBXLGYY2Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 19:48 -0700, Linus Torvalds wrote:

> I'm not entirely sure who wants to own up to owning that particular part=20
> of code, and is willing to make kmap_atomic_prot_pfn() also work in the=20
> absense of CONFIG_HIGHMEM.

All of the kmap_atomic functions *do* work without CONFIG_HIGHMEM, they
just don't do what we want in this case. Without knowing the history, it
seems fairly clear that the kmap functions are designed to map physical
memory pages into the kernel virtual address space. On small 32-bit
systems, that's trivial, you just use the direct map (as one does on
64-bit systems). The magic fixmap entries make this work with
CONFIG_HIGHMEM as well.

So, I fear touching the kmap API as it appears to have a specific and
useful purpose, irrespective of the memory size the kernel is configured
for.

What I've proposed is that we create a new io-space specific set of
fixmap APIs. On CONFIG_HIGHMEM, they'd just use the existing kmap_atomic
mechanism, but on small 32-bit systems, we'd enable the fixmaps and have
some for that environment as well.

> So I would suspect that if you guys actually write a patch, and make sure=
=20
> that it works on x86-32 even _without_ CONFIG_HIGHMEM, and send it to=20
> Ingo, good things will happen.

Ok, we can give this a try.

> and it probably should all work automatically. The kmap_atomic() stuff=20
> really should be almost totally independent of CONFIG_HIGHMEM, since it's=
=20
> really much more closely related to fixmaps than HIGHMEM.=20

As above, I think kmap_atomic should be left alone as a way of quickly
mapping memory pages. There are a users of both kmap_atomic_prot (xen)
and kmap_atomic_pfn (crash dumps).

> I guess there may be some debugging code that depends on HIGHMEM (eg that=
=20
> whole testing for whether a page is a highmem page or not), so it might b=
e=20
> a _bit_ more than just moving code around, but I really didn't look=20
> closer.
>=20
> Then, there's the issue of 64-bit, and just mapping everything there, and=
=20
> the interface to that. I liked the trivial extension to "struct resource"=
=20
> to have a "cached mapping" pointer. So if we can just make it pass=20
> resources around and get a page that way (and not even need kmap() on=20
> 64-bit architections), that would be good.

The io_mapping API I proposed does precisely this. On 32-bit systems, it
uses kmap_atomic for each page access while on 64-bit systems it uses
ioremap_wc at device init time and then just uses an offset for each
page access.

Hiding this detail behind an API leaves the driver code independent of
this particular choice.

> It's too late for -rc1 (which I'm planning on cutting within the hour),=20
> and if it ends up being complex, I guess that it means this will eb a=20
> 2.6.29 issue.

If we do end up pushing this out to 2.6.29, I'd like to see
kmap_atomic_prot_pfn in place as a stop-gap so that PAT performance on
32-bit systems is reasonable. I don't think too many people are running
desktop systems without CONFIG_HIGHMEM at this point, and if so, we can
just suggest that perhaps they change their configuration.

> But if it really is just a matter of mostly just some trivial code=20
> movement and both the gfx and x86 people are all happy, I'll happily take=
=20
> it for -rc2, and we can just leave this all behind us.

I'll try to get something working in the next day or so and see how it
looks. My plan at this point is to create new API for 32-bit systems:

void *io_map_atomic_wc(unsigned long pfn)
void io_unmap_atomic(void *addr);

With this, I can switch my existing io_mapping API over to an
io-specific interface and implement those using the fixmap code.

--=20
keith.packard@intel.com

--=-uSkJQIlKOAAWBXLGYY2Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJAU9AQp8BWwlsTdMRAuHBAKDCAX8nYNyRtM9/wrz/SUBcJCbyywCguZwZ
8kFzzNTEJVrjxeth6bBb/s4=
=0Wj5
-----END PGP SIGNATURE-----

--=-uSkJQIlKOAAWBXLGYY2Q--

