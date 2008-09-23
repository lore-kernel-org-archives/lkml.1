Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYIWQd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYIWQd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYIWQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:33:48 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:61168 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYIWQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:33:47 -0400
Subject: Re: [PATCH] Export kmap_atomic_pfn for DRM-GEM.
From: Eric Anholt <eric@anholt.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@gmail.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200809221059.54779.jbarnes@virtuousgeek.org>
References: <1219779789-8368-1-git-send-email-eric@anholt.net>
	 <1219855961.4994.6.camel@vonnegut.anholt.net>
	 <200808281022.14296.nickpiggin@yahoo.com.au>
	 <200809221059.54779.jbarnes@virtuousgeek.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zVNcQ8zZkYD/Aa8ppdbk"
Date: Tue, 23 Sep 2008 09:32:42 -0700
Message-Id: <1222187562.4424.47.camel@vonnegut.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zVNcQ8zZkYD/Aa8ppdbk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-22 at 10:59 -0700, Jesse Barnes wrote:
> On Wednesday, August 27, 2008 5:22 pm Nick Piggin wrote:
> > > However, when other DRM drivers get around to doing memory management=
,
> > > I'm sure they'll also be interested in an ioremap_wc that doesn't eat
> > > ipi costs.  For us, the ipis for flushing were eating over 10% of CPU
> > > time.  If your patch series cuts that cost, we could drop this piece =
at
> > > that point.
> >
> > It can cut the cost quite significantly on normal vmap/vunmap loads I
> > tested. Whether it will work as well on your workload, I don't know
> > but I would have liked to find out. I raised this issue quite a while
> > back, so I'm disappointed it had not been tried...
>=20
> I think Eric has code with the vmap changes now?
>=20
> Given our discussions at KS/Plumbers would you be ok with acking these=20
> patches?  Or do you want a repost so you can check out the vmap stuff?
>=20
> After talking a bit more about it, I think we agreed that the ioctl inter=
face=20
> is actually a better approach then trying to shoehorn this stuff into sys=
tem=20
> calls, so aside from the vmap code (which could be done in 2.6.29 or when=
ever=20
> the vmap stuff lands) I think this patchset is pretty close to what we wa=
nt=20
> in drm-next now...

I've been trying to get a good test of the vmap changes.  Unfortunately,
it looks like things have changed in ioremap in the intervening time
between when I last tested and now.  I was taking 2.6.27-rc5-mm1 (since
that was the only git tree I found with Nick's changes in it,
unfortunately) and merging our stuff into there then reverting the
kmap_atomic_prot_pfn bit.

However, we've moved from 10% cost in unmapping due to IPIing to a >30%
cost in mapping due to change_page_attr.  This is regardless of whether
I do ioremap or ioremap_wc.  The physical range is covered by a WC MTRR,
and the X Server's mapping the memory using the _wc resource.  In the
DRM, I just tried moving every ioremap to _wc, and it's the same.  The
call chain looks like

i915_gem_pwrite_ioctl (60%)
ioremap_wc (39%)
ioremap_nocache (39%)
ioremap_caller (39%)
ioremap_change_attr (36%)
_set_memory_uc (36%)
change_page_attr_set_clr (36%)
vm_unmap_aliases (31%)

Maybe if I go back and generate a tree of just Nick's changes and try to
merge them forward I can get a good test.  However, it looks to me like
we've got some serious brokenness in ioremap and attribute handling
coming up.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com




--=-zVNcQ8zZkYD/Aa8ppdbk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjZGioACgkQHUdvYGzw6veUCwCbBUbpUpNeQPENm/iQDo+KXs1v
ojIAnR9Au9s9XXjoLruUV2PfTj/6Q8c4
=XLoZ
-----END PGP SIGNATURE-----

--=-zVNcQ8zZkYD/Aa8ppdbk--
