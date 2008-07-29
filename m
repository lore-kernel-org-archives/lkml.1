Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYG2Caz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYG2Caz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYG2Caq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:30:46 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:47786 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYG2Caq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:30:46 -0400
Date: Mon, 28 Jul 2008 21:30:14 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 30/30] W1: ds2490.c optimize ds_set_pullup
Message-ID: <20080729023014.GD24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D402Py2zjJjzbYTp"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:30:15 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D402Py2zjJjzbYTp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Optimize the ds_set_pullup function.  For a strong pullup to be sent
the ds2490 has to have both the strong pullup mode enabled, and the
specific write operation has to have the SPU bit enabled.  Previously
the write always had the SPU bit enabled and both the duration and
model was set when a strong pullup was requested.  Now the strong
pullup mode is enabled at initialization time, the delay is updated
only when the value changes, and the write SPU bit is set only when a
strong pullup is required.  This removes two or three bus transactions
per strong pullup request.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |   64 ++++++++++++++++++++++++++++++---------=
----
 1 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 466048f..d38ac01 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -141,6 +141,10 @@ struct ds_device
 	 * 0: pullup not active, else duration in milliseconds
 	 */
 	int			spu_sleep;
+	/* spu_bit contains COMM_SPU or 0 depending on if the strong pullup
+	 * should be active or not for writes.
+	 */
+	u16			spu_bit;
=20
 	struct w1_bus_master	master;
 };
@@ -311,6 +315,25 @@ static void ds_dump_status(struct ds_device *dev, unsi=
gned char *buf, int count)
 	}
 }
=20
+static void ds_reset_device(struct ds_device *dev)
+{
+	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+	/* Always allow strong pullup which allow individual writes to use
+	 * the strong pullup.
+	 */
+	if (ds_send_control_mode(dev, MOD_PULSE_EN, PULSE_SPUE))
+		printk(KERN_ERR "ds_reset_device: "
+			"Error allowing strong pullup\n");
+	/* Chip strong pullup time was cleared. */
+	if (dev->spu_sleep) {
+		/* lower 4 bits are 0, see ds_set_pullup */
+		u8 del =3D dev->spu_sleep>>4;
+		if (ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del))
+			printk(KERN_ERR "ds_reset_device: "
+				"Error setting duration\n");
+	}
+}
+
 static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int siz=
e)
 {
 	int count, err;
@@ -444,7 +467,7 @@ static int ds_wait_status(struct ds_device *dev, struct=
 ds_status *st)
=20
 	if (err >=3D 16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
-		ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+		ds_reset_device(dev);
 		/* Always dump the device status. */
 		count =3D 101;
 	}
@@ -509,24 +532,26 @@ static int ds_set_speed(struct ds_device *dev, int sp=
eed)
=20
 static int ds_set_pullup(struct ds_device *dev, int delay)
 {
-	int err;
+	int err =3D 0;
 	u8 del =3D 1 + (u8)(delay >> 4);
+	/* Just storing delay would not get the trunication and roundup. */
+	int ms =3D del<<4;
+
+	/* Enable spu_bit if a delay is set. */
+	dev->spu_bit =3D delay?COMM_SPU:0;
+	/* If delay is zero, it has already been disabled, if the time is
+	 * the same as the hardware was last programmed to, there is also
+	 * nothing more to do.  Compare with the recalculated value ms
+	 * rather than del or delay which can have a different value.
+	 */
+	if (delay =3D=3D 0 || ms =3D=3D dev->spu_sleep)
+		return err;
=20
-	dev->spu_sleep =3D 0;
-	err =3D ds_send_control_mode(dev, MOD_PULSE_EN, delay?PULSE_SPUE:0);
+	err =3D ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
 	if (err)
 		return err;
=20
-	if (delay) {
-		err =3D ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
-		if (err)
-			return err;
-
-		/* Just storing delay would not get the trunication and
-		 * roundup.
-		 */
-		dev->spu_sleep =3D del<<4;
-	}
+	dev->spu_sleep =3D ms;
=20
 	return err;
 }
@@ -577,11 +602,11 @@ static int ds_write_byte(struct ds_device *dev, u8 by=
te)
 	struct ds_status st;
 	u8 rbyte;
=20
-	err =3D ds_send_control(dev, COMM_BYTE_IO | COMM_IM | COMM_SPU, byte);
+	err =3D ds_send_control(dev, COMM_BYTE_IO | COMM_IM | dev->spu_bit, byte);
 	if (err)
 		return err;
=20
-	if (dev->spu_sleep)
+	if (dev->spu_bit)
 		msleep(dev->spu_sleep);
=20
 	err =3D ds_wait_status(dev, &st);
@@ -648,11 +673,11 @@ static int ds_write_block(struct ds_device *dev, u8 *=
buf, int len)
 	if (err < 0)
 		return err;
=20
-	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
+	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | dev->spu_bit, len);
 	if (err)
 		return err;
=20
-	if (dev->spu_sleep)
+	if (dev->spu_bit)
 		msleep(dev->spu_sleep);
=20
 	ds_wait_status(dev, &st);
@@ -849,7 +874,7 @@ static int ds_w1_init(struct ds_device *dev)
 	 * the input buffer.  This will cause the next read to fail
 	 * see the note in ds_recv_data.
 	 */
-	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+	ds_reset_device(dev);
=20
 	dev->master.data	=3D dev;
 	dev->master.touch_bit	=3D &ds9490r_touch_bit;
@@ -892,6 +917,7 @@ static int ds_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 	dev->spu_sleep =3D 0;
+	dev->spu_bit =3D 0;
 	dev->udev =3D usb_get_dev(udev);
 	if (!dev->udev) {
 		err =3D -ENOMEM;
--=20
1.4.4.4

--D402Py2zjJjzbYTp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjoC2AI852cse6PARAr6qAJ9wtty0Zj5ykL64WUknR//qKH8k3gCgxRY4
M1jL+o9Nf9xPsRxG4Atr+4Y=
=S8Sl
-----END PGP SIGNATURE-----

--D402Py2zjJjzbYTp--
