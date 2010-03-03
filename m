Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab0CCPIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:08:43 -0500
Received: from systemlinux.org ([83.151.29.59]:34457 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0CCPIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:08:42 -0500
X-Greylist: delayed 1473 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 10:08:42 EST
Date: Wed, 3 Mar 2010 15:42:41 +0100
From: Andre Noll <maan@systemlinux.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: John Hughes <john@Calva.COM>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++ on different filesystems seems to deadlock in sync
Message-ID: <20100303144241.GF21495@skl-net.de>
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM> <20100303115015.GN5768@kernel.dk> <4B8E5805.30505@Calva.COM> <20100303120317.GP5768@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+M8NfDDHYT2VBqDz"
Content-Disposition: inline
In-Reply-To: <20100303120317.GP5768@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+M8NfDDHYT2VBqDz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:03, Jens Axboe wrote:

> Our sync is currently broken in that regard, since it'll wait for too
> long. We have a debated patch going, I have included it below. Any
> chance you could give it a whirl?

That's the same patch you posted two weeks ago and on which Linus
commented he thinks it is broken. He also proposed another, simpler
patch (included below) which I'm running for a few days and which
fixes the sync problem for me.

However, it is not clear at all whether that simpler patch is
correct. Any comments on that?

Thanks
Andre

---
 fs/fs-writeback.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1a7c42c..a0a8424 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -738,11 +738,16 @@ static long wb_writeback(struct bdi_writeback *wb,
 	long wrote =3D 0;
 	struct inode *inode;
=20
-	if (wbc.for_kupdate) {
-		wbc.older_than_this =3D &oldest_jif;
-		oldest_jif =3D jiffies -
-				msecs_to_jiffies(dirty_expire_interval * 10);
-	}
+	/*
+	 * We never write back data that was dirtied _after_ we
+	 * started writeback. But kupdate doesn't even want to
+	 * write back recently dirtied stuff, only older data.
+	 */
+	oldest_jif =3D jiffies-1;
+	wbc.older_than_this =3D &oldest_jif;
+	if (wbc.for_kupdate)
+		oldest_jif -=3D msecs_to_jiffies(dirty_expire_interval * 10);
+
 	if (!wbc.range_cyclic) {
 		wbc.range_start =3D 0;
 		wbc.range_end =3D LLONG_MAX;
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--+M8NfDDHYT2VBqDz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLjnVhWto1QDEAkw8RAu+LAJ9LKi5KRV4V5RL4XfH0HzN2CKMvzACfcEI9
URewtkV1grAOubPklEBvmi8=
=sRUO
-----END PGP SIGNATURE-----

--+M8NfDDHYT2VBqDz--
