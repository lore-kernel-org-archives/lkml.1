Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZBUCd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZBUCd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 21:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZBUCdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 21:33:17 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:57390 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZBUCdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 21:33:17 -0500
Subject: Re: [PATCH] drm: Take mmap_sem up front to avoid lock order
	violations.
From: Eric Anholt <eric@anholt.net>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, krh@bitplanet.net,
       Wang Chen <wangchen@cn.fujitsu.com>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org,
       Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20090219125736.GC1747@wotan.suse.de>
References: <499BC08C.5000603@cn.fujitsu.com>
	 <1234975113-4941-1-git-send-email-krh@bitplanet.net>
	 <1235035145.4612.38.camel@laptop>  <20090219125736.GC1747@wotan.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9k0ZgoEbocIz6lNdCX8u"
Date: Fri, 20 Feb 2009 18:33:14 -0800
Message-Id: <1235183594.2636.151.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9k0ZgoEbocIz6lNdCX8u
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-19 at 13:57 +0100, Nick Piggin wrote:
> On Thu, Feb 19, 2009 at 10:19:05AM +0100, Peter Zijlstra wrote:
> > On Wed, 2009-02-18 at 11:38 -0500, krh@bitplanet.net wrote:
> > > From: Kristian H=C3=B8gsberg <krh@redhat.com>
> > >=20
> > > A number of GEM operations (and legacy drm ones) want to copy data to
> > > or from userspace while holding the struct_mutex lock.  However, the
> > > fault handler calls us with the mmap_sem held and thus enforces the
> > > opposite locking order.  This patch downs the mmap_sem up front for
> > > those operations that access userspace data under the struct_mutex
> > > lock to ensure the locking order is consistent.
> > >=20
> > > Signed-off-by: Kristian H=C3=B8gsberg <krh@redhat.com>
> > > ---
> > >=20
> > > Here's a different and simpler attempt to fix the locking order
> > > problem.  We can just down_read() the mmap_sem pre-emptively up-front=
,
> > > and the locking order is respected.  It's simpler than the
> > > mutex_trylock() game, avoids introducing a new mutex.
>=20
> The "simple" way to fix this is to just allocate a temporary buffer
> to copy a snapshot of the data going to/from userspace. Then do the
> real usercopy to/from that buffer outside the locks.
>=20
> You don't have any performance critical bulk copies (ie. that will
> blow the L1 cache), do you?=20

16kb is the most common size (batchbuffers).  32k is popular on 915
(vertex), and varying between 0-128k on 965 (vertex).  The pwrite path
generally represents 10-30% of CPU consumption in CPU-bound apps.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-9k0ZgoEbocIz6lNdCX8u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmfZ+oACgkQHUdvYGzw6veylQCbBSgmZY2O4ivhnpYN5zSchnmj
cfgAnjv6/86QXSd0gYprBPR1Dj90xq4Q
=n6sQ
-----END PGP SIGNATURE-----

--=-9k0ZgoEbocIz6lNdCX8u--
