Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYC1MyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYC1MyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYC1Mv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:51:56 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56326 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbYC1Mvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:51:55 -0400
Date: Fri, 28 Mar 2008 07:27:29 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 28/35] W1: ds2490.c simplify and fix ds_touch_bit
Message-ID: <20080328122729.GC3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A1Iwnsx6rNfRhs6P"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:30 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A1Iwnsx6rNfRhs6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c 1.15
Simplify and fix ds_touch_bit.  If a device is attached in the middle
of a bus search the status register will return more than the default
16 bytes.  The additional bytes indicate that it has detected a new
device.  The way ds_wait_status is coded, if it doesn't read 16 status
bytes it returns an error value.  ds_touch_bit then will detect that
error and return an error.  In that case it doesn't read the input
buffer and returns uninitialized data.  It doesn't stop there.  The
next transaction will not expect the extra byte in the input buffer
and the short read will cause an error and clear out both the old byte
and new data in the input buffer.

Just ignore the value of ds_wait_status.  It is still required to wait
until ds2490 is again idle and there is data to read when ds_recv_data
is called.  This also removes the while loop.  None of the other
commands wait and verify that the issued command is in the status
register.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 8c3d756..45e7f10 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -490,28 +490,15 @@ static int ds_set_pullup(struct ds_device *dev, int d=
elay)
=20
 static int ds_touch_bit(struct ds_device *dev, u8 bit, u8 *tbit)
 {
-	int err, count;
+	int err;
 	struct ds_status st;
-	u16 value =3D (COMM_BIT_IO | COMM_IM) | ((bit) ? COMM_D : 0);
-	u16 cmd;
=20
-	err =3D ds_send_control(dev, value, 0);
+	err =3D ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit ? COMM_D : 0),
+		0);
 	if (err)
 		return err;
=20
-	count =3D 0;
-	do {
-		err =3D ds_wait_status(dev, &st);
-		if (err)
-			return err;
-
-		cmd =3D st.command0 | (st.command1 << 8);
-	} while (cmd !=3D value && ++count < 10);
-
-	if (err < 0 || count >=3D 10) {
-		printk(KERN_ERR "Failed to obtain status.\n");
-		return -EINVAL;
-	}
+	ds_wait_status(dev, &st);
=20
 	err =3D ds_recv_data(dev, tbit, sizeof(*tbit));
 	if (err < 0)
--=20
1.4.4.4

--A1Iwnsx6rNfRhs6P
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQxAI852cse6PARAqYfAKCQe9d2nU4+12OOhM3pHgS3ZSd2ngCgug7/
Van07jWiZ3gOZOjw9KFHuPQ=
=pd/l
-----END PGP SIGNATURE-----

--A1Iwnsx6rNfRhs6P--
