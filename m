Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbYJSTJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbYJSTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 15:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYJSTJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 15:09:19 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:49224 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYJSTJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 15:09:18 -0400
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
From: Eric Anholt <eric@anholt.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20081019175320.GA6442@elte.hu>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <200810181237.49784.nickpiggin@yahoo.com.au>
	 <1224357062.4384.72.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com>  <20081019175320.GA6442@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BczkLx/MbulrMT7iZMLE"
Date: Sun, 19 Oct 2008 12:07:54 -0700
Message-Id: <1224443274.5526.39.camel@vonnegut.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BczkLx/MbulrMT7iZMLE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 19:53 +0200, Ingo Molnar wrote:
> * Keith Packard <keithp@keithp.com> wrote:
>=20
> > On Sat, 2008-10-18 at 21:14 -0700, Keith Packard wrote:
> > > On Sun, 2008-10-19 at 00:32 +0200, Ingo Molnar wrote:
> > >=20
> > > > Mind sending patches for this? :-)
> >=20
> > Here's a patch for the i915 driver that includes the new API. Tested=20
> > on x86_32+HIGHMEM and x86_64. I stuck a new 'io_reserve.h' header in=20
> > the i915 directory for this patch, but it should go elsewhere.
> >=20
> > The new APIs are:
> >=20
> > io_reserve_create_wc
> > io_reserve_free
> > io_reserve_map_atomic_wc
> > io_reserve_unmap_atomic
> > io_reserve_map_wc
> > io_reserve_unmap
>=20
> very nice!
>=20
> I think we need a somewhat different abstraction though.
>=20
> Firstly, regarding drivers/gpu/drm/i915/io_reserve.h, that needs to move=20
> to generic code.
>=20
> Secondly, wouldnt the right abstraction be to attach this functionality=20
> to 'struct resource' ? [or at least create a second struct that embedds=20
> struct resource]
>=20
> this abstraction is definitely not a PCI thing and not a=20
> detached-from-everything thing, it's an IO resource thing. We could make=20
> it a property of struct resource:
>=20
> struct resource {
>         resource_size_t start;
>         resource_size_t end;
>         const char *name;
>         unsigned long flags;
>         struct resource *parent, *sibling, *child;
> +       void *mapping;
> };
>=20
> The APIs would be:
>=20
>   int   io_resource_init_mapping(struct resource *res);
>  void   io_resource_free_mapping(struct resource *res);
>  void * io_resource_map(struct resource *res, pfn_t pfn, unsigned long of=
fset);
>  void   io_resource_unmap(struct resource *res, void *kaddr);
>=20
> Note how simple and consistent it all gets: IO resources already know=20
> their physical location and their size limits. Being able to cache an=20
> ioremap in a mapping [and being able to use atomic kmaps on 32-bit] is a=20
> relatively simple and natural extension to the concept.
>=20
> i think that would be quite acceptable - and the APIs could just=20
> transparently work on it. This would also allow the PCI code to=20
> automatically unmap any cached mappings from resources, when the driver=20
> deinitializes.
>=20
> Linus, Jesse, what do you think?
>=20
> i think we need to finalize the API names and their abstraction level,=20
> and then could even merge those APIs into v2.6.28 on a fast path, to=20
> enable you to use it. It does not interact with anything else so it=20
> should be safe to do.

This API needs the cacheability control, which I don't see in it
currently.  In the past we've been relying on an MTRR over the GTT
resulting in all of our UC- mappings getting us the correct WC behavior,
but now there aren't enough MTRRs to go around and graphics loses out
(at about a 20% CPU cost as a conservative estimate).  The primary goal
of the new API is to let us eat PAT costs up front so we don't have to
at runtime.

Second, we need to know when we're doing a mapping whether we're
affected by atomic scheduling restrictions.  Right now our plan has been
to try doing page-by-page
io_map_atomic_wc()/copy_from_user_inatomic()/io_unmap_atomic(), and if
we fail at that at some point (map returns NULL or we get a partial
completion from copy_from_user_inatomic) then fall back to io_map_wc()
and copy_from_user() the whole thing at once.  That gets us good
performance on both x86 with highmem and x86-64, and not too shabby
performance on x86 non-highmem.

Also, while it's rare, there have been graphics cards (looking at you,
S3) where BARs were expensive for some reason and they stuffed both the
framebuffer and registers into one PCI BAR, where you want the FB to be
WC and the registers to be UC.  Not sure if they would be supportable
with this API or not.  And if it's not, I'm not sure how much we care to
design for them, but it's something to potentially consider.

Finally, I'm confused by the pfn and offset args to io_resource_map,
when I expected something parallel to ioremap but with our resource arg
added.


--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-BczkLx/MbulrMT7iZMLE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj7hYoACgkQHUdvYGzw6vc1KQCeNm4SpvFm/05KVkkBjLxxNWr5
O3AAnRIaIMreStHlbWC6FUihEPlxgBcl
=iYFl
-----END PGP SIGNATURE-----

--=-BczkLx/MbulrMT7iZMLE--

