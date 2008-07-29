Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYG2CSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYG2CSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYG2CSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:18:34 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:48736 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYG2CSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:18:33 -0400
Date: Mon, 28 Jul 2008 21:18:28 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 8/30] W1: recode w1_slave_found logic
Message-ID: <20080729021828.GH24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtJ+CqYNzKB4ukR4"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:18:28 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtJ+CqYNzKB4ukR4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Simplified the logic in w1_slave_found by using the new
w1_attach_slave_device function to find a slave and mark it as active
or add the device if the crc checks.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 24312e0..4bf2001 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -836,9 +836,7 @@ void w1_reconnect_slaves(struct w1_family *f, int attac=
h)
=20
 static void w1_slave_found(struct w1_master *dev, u64 rn)
 {
-	int slave_count;
 	struct w1_slave *sl;
-	struct list_head *ent;
 	struct w1_reg_num *tmp;
 	u64 rn_le =3D cpu_to_le64(rn);
=20
@@ -846,24 +844,12 @@ static void w1_slave_found(struct w1_master *dev, u64=
 rn)
=20
 	tmp =3D (struct w1_reg_num *) &rn;
=20
-	slave_count =3D 0;
-	list_for_each(ent, &dev->slist) {
-
-		sl =3D list_entry(ent, struct w1_slave, w1_slave_entry);
-
-		if (sl->reg_num.family =3D=3D tmp->family &&
-		    sl->reg_num.id =3D=3D tmp->id &&
-		    sl->reg_num.crc =3D=3D tmp->crc) {
-			set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
-			break;
-		}
-
-		slave_count++;
-	}
-
-	if (slave_count =3D=3D dev->slave_count &&
-		rn && ((rn >> 56) & 0xff) =3D=3D w1_calc_crc8((u8 *)&rn_le, 7)) {
-		w1_attach_slave_device(dev, tmp);
+	sl =3D w1_slave_search_device(dev, tmp);
+	if (sl) {
+		set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+	} else {
+		if (rn && tmp->crc =3D=3D w1_calc_crc8((u8 *)&rn_le, 7))
+			w1_attach_slave_device(dev, tmp);
 	}
=20
 	atomic_dec(&dev->refcnt);
--=20
1.4.4.4

--vtJ+CqYNzKB4ukR4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn30AI852cse6PARAsuLAJ0fF9o+2/HoboWNAVUHM85pCGbcZQCfRKTk
SyXYkLbBjwJfqXaHMaIUlgk=
=vp/P
-----END PGP SIGNATURE-----

--vtJ+CqYNzKB4ukR4--
