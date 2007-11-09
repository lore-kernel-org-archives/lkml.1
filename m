Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbXKIJyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbXKIJyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 04:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXKIJy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 04:54:29 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:53366 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308AbXKIJy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 04:54:28 -0500
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1194601672.20251.60.camel@ymzhang>
References: <1194601672.20251.60.camel@ymzhang>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uDKTLXG01FW7ZuwYsLSX"
Date: Fri, 09 Nov 2007 10:54:24 +0100
Message-Id: <1194602064.6289.157.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uDKTLXG01FW7ZuwYsLSX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-11-09 at 17:47 +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.23, iozone sequential write/rewrite (512M) has 50% reg=
ression
> in kernel 2.6.24-rc1. 2.6.24-rc2 has the same regression.
>=20
> My machine has 8 processor cores and 8GB memory.
>=20
> By bisect, I located patch
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=3D04fbfdc14e5f48463820d6b9807daa5e9c92c51f.
>=20
>=20
> Another behavior: with kernel 2.6.23, if I run iozone for many times afte=
r rebooting machine,
> the result looks stable. But with 2.6.24-rc1, the first run of iozone got=
 a very small result and
> following run has 4Xorig_result.

So the second run is 4x as fast as the first run?

> What I reported is the regression of 2nd/3rd run, because first run has b=
igger regression.

So the 2nd and 3rd run are stable at 50% slower than .23?

> I also tried to change /proc/sys/vm/dirty_ratio,dirty_backgroud_ratio and=
 didn't get improvement.

Could you try:

---
Subject: mm: speed up writeback ramp-up on clean systems

We allow violation of bdi limits if there is a lot of room on the
system. Once we hit half the total limit we start enforcing bdi limits
and bdi ramp-up should happen. Doing it this way avoids many small
writeouts on an otherwise idle system and should also speed up the
ramp-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn>=20
---
 mm/page-writeback.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/page-writeback.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/mm/page-writeback.c	2007-09-28 10:08:33.937415368 +0200
+++ linux-2.6/mm/page-writeback.c	2007-09-28 10:54:26.018247516 +0200
@@ -355,8 +355,8 @@ get_dirty_limits(long *pbackground, long
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
-	long bdi_nr_reclaimable;
-	long bdi_nr_writeback;
+	long nr_reclaimable, bdi_nr_reclaimable;
+	long nr_writeback, bdi_nr_writeback;
 	long background_thresh;
 	long dirty_thresh;
 	long bdi_thresh;
@@ -376,11 +376,26 @@ static void balance_dirty_pages(struct a
=20
 		get_dirty_limits(&background_thresh, &dirty_thresh,
 				&bdi_thresh, bdi);
+
+		nr_reclaimable =3D global_page_state(NR_FILE_DIRTY) +
+					global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback =3D global_page_state(NR_WRITEBACK);
+
 		bdi_nr_reclaimable =3D bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback =3D bdi_stat(bdi, BDI_WRITEBACK);
+
 		if (bdi_nr_reclaimable + bdi_nr_writeback <=3D bdi_thresh)
 			break;
=20
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+				(background_thresh + dirty_thresh) / 2)
+			break;
+
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded =3D 1;
=20


--=-uDKTLXG01FW7ZuwYsLSX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHNC5PXA2jU0ANEf4RAkryAJ9LAFLdpE9kZvZ/17zbBkKtbElP4wCfe37Z
VzYzd2TNpyoZRr5unm8TlKU=
=TdEs
-----END PGP SIGNATURE-----

--=-uDKTLXG01FW7ZuwYsLSX--

