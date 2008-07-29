Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYG2C0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYG2C0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbYG2C0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:26:18 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:58119 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582AbYG2C0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:26:17 -0400
Date: Mon, 28 Jul 2008 21:26:12 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 23/30] W1: ds2490.c simplify and fix ds_touch_bit
Message-ID: <20080729022612.GW24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kZn00QyXxdr8qbeL"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:26:12 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kZn00QyXxdr8qbeL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

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
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 6bfd6a9..b1ae1a0 100644
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

--kZn00QyXxdr8qbeL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn/EAI852cse6PARAsgeAJ91w5m5XYOQbRbkyRuIxNBLJQ86DwCgpY5x
j9THufK9c6I4ObHXT2R9fww=
=kKtq
-----END PGP SIGNATURE-----

--kZn00QyXxdr8qbeL--
