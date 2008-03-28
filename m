Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYC1NA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYC1NA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbYC1Mzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:46 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbYC1Mzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:43 -0400
Date: Fri, 28 Mar 2008 07:25:34 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 11/35] W1: recode w1_slave_found logic
Message-ID: <20080328122534.GL3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8/n5iBOhiUtMkxf"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:25:34 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O8/n5iBOhiUtMkxf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1.c 1.14
Rewrote the confusion logic in w1_slave_found.  The function is called
for each device detected by a bus search.  If the slave was found a
flag is set to show that it is still active.  If it wasn't found it
will be attached.

It would previously search through the slave list marking the slave
active if it was found.  It used a counter to determine if it exited
the loop early.  If it searched through all slaves in the list the crc
value was verified and then attached the device if it did.

Now it uses the new w1_attach_slave_device function to find the slave
device and mark the device active if it was found.  If the slave
wasn't found it will add the device if the crc is correct.  Much more
understandable.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 3ca1f4d..b18eedb 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -814,24 +814,12 @@ static void w1_slave_found(struct w1_master *dev, u64=
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
+	if(sl) {
+		set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+	} else {
+		if(rn && tmp->crc =3D=3D w1_calc_crc8((u8 *)&rn_le, 7))
+			w1_attach_slave_device(dev, tmp);
 	}
=20
 	atomic_dec(&dev->refcnt);
--=20
1.4.4.4

--O8/n5iBOhiUtMkxf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OO+AI852cse6PARAq/sAJ9c/zOOyhHCg3ff2T62wCGOYOTASQCeLq4X
xlOZbXuQ9wdi5M8fDfQPfzI=
=mHwi
-----END PGP SIGNATURE-----

--O8/n5iBOhiUtMkxf--
