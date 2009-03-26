Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbZCZT7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbZCZT7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZCZT7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:59:30 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:35596 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZCZT73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:59:29 -0400
Subject: Re: [PATCH 2/6] drm/i915: Make GEM object's page lists refcounted
 instead of get/free.
From: Eric Anholt <eric@anholt.net>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <alpine.DEB.2.00.0903252251300.27027@skynet.skynet.ie>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <1238017510-26784-2-git-send-email-eric@anholt.net>
	 <1238017510-26784-3-git-send-email-eric@anholt.net>
	 <alpine.DEB.2.00.0903252251300.27027@skynet.skynet.ie>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7EXiT16uarzeYDVqRZtV"
Date: Thu, 26 Mar 2009 12:59:15 -0700
Message-Id: <1238097555.8275.55.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7EXiT16uarzeYDVqRZtV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 22:52 +0000, Dave Airlie wrote:
> > We've wanted this for a few consumers that touch the pages directly (su=
ch as
> > the following commit), which have been doing the refcounting outside of
> > get/put pages.
>=20
> No idea if this is a valid point or not but whenever I see refcount that=20
> isn't a kref my internal, "should this be a kref" o-meter goes off.

All usage is under the struct mutex, since "get" is the transition from
0 -> 1 refcount, so I don't see how krefs would apply here (they're
suited more to refcounting objects after creation).

Our use of krefs for our GEM object refcounts is itself somewhat dubious
-- people have noted that we're spending a decent bit of CPU on the kref
usage, since the second hottest path is a loop of reffing objects (10-50
or so) up front, and loop of unreffing at the end.  And when we're doing
that reffing, we're holding a spinlock on the table we're looking it up
from, anyway!  So we end up with like 4 locked bus transactions per
object in exec that could easily be reduced to 2 total, if we made there
be a small "object referencing" lock covering the handle tables and
object refcounts.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-7EXiT16uarzeYDVqRZtV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknL3pAACgkQHUdvYGzw6vdgUwCfbGP30J62KEMOZtT+DIuOcm39
REQAmwRLbgn8GEF6IiURYqrDc8aojdVh
=QTOZ
-----END PGP SIGNATURE-----

--=-7EXiT16uarzeYDVqRZtV--
