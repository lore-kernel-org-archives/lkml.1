Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYC1M4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYC1M4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbYC1Mye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:54:34 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34539 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119AbYC1Myc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:54:32 -0400
Date: Fri, 28 Mar 2008 07:27:10 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 24/35] W1: ds2490.c add support for strong pullup
Message-ID: <20080328122710.GY3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I2k41U2G4dq8LTBU"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:11 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I2k41U2G4dq8LTBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c had ds_start_pulse, but I think I decided that the pulse
wasn't being enabled, as the strong pullup wasn't enabled.  If it was
working it was being called some time after every byte or block was
written.  It should have been enabled in the write command instead of
some time later to benefit any device needing it.

ds_start_pulse was also calling mdelay(750), which would effectively
lock up the computer for 3/4 of a second four times per temperature
conversion.  This was immediately noticable just typing at a virtual
terminal.

The new set_pullup will only enable the strong pullup when requested,
which is expected to be the only write operation that will benefit
=66rom a strong pullup.  Now msleep will be used for delays, resulting
in the reads and writes taking minimal system overhead.

ds2490.c 1.3
Add set_pullup.

ds2490.c 1.4
Enable existing ds_send_control to send the control command enable
strong pullup.

ds2490.c 1.6
Remove strong pullup enable bit when reading a byte.

ds2490.c 1.7
Add spu_sleep to avoid pulling the device status for the duration of
the strong pullup.

ds2490.c 1.17
Remove PULLUP_PULSE_DURATION macro, it is the delay used for a
temperature conversion which shouldn't be in the master driver anyway.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |   76 +++++++++++++++++++++------------------=
---
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 67a7f42..ac27f89 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -98,11 +98,6 @@
 #define BRANCH_MAIN			0xCC
 #define BRANCH_AUX			0x33
=20
-/*
- * Duration of the strong pull-up pulse in milliseconds.
- */
-#define PULLUP_PULSE_DURATION		750
-
 /* Status flags */
 #define ST_SPUA				0x01  /* Strong Pull-up is active */
 #define ST_PRGA				0x02  /* 12V programming pulse is being generated */
@@ -131,6 +126,11 @@ struct ds_device
=20
 	int			ep[NUM_EP];
=20
+	/* Strong PullUp
+	 * 0: pullup not active, else duration in milliseconds
+	 */
+	int			spu_sleep;
+
 	struct w1_bus_master	master;
 };
=20
@@ -192,7 +192,7 @@ static int ds_send_control_cmd(struct ds_device *dev, u=
16 value, u16 index)
=20
 	return err;
 }
-#if 0
+
 static int ds_send_control_mode(struct ds_device *dev, u16 value, u16 inde=
x)
 {
 	int err;
@@ -207,7 +207,7 @@ static int ds_send_control_mode(struct ds_device *dev, =
u16 value, u16 index)
=20
 	return err;
 }
-#endif
+
 static int ds_send_control(struct ds_device *dev, u16 value, u16 index)
 {
 	int err;
@@ -294,14 +294,6 @@ static int ds_recv_status(struct ds_device *dev, struc=
t ds_status *st)
 		if (count < 0)
 			return err;
 	}
-#if 0
-	if (st->status & ST_IDLE) {
-		printk(KERN_INFO "Resetting pulse after ST_IDLE.\n");
-		err =3D ds_start_pulse(dev, PULLUP_PULSE_DURATION);
-		if (err)
-			return err;
-	}
-#endif
=20
 	return err;
 }
@@ -472,32 +464,26 @@ static int ds_set_speed(struct ds_device *dev, int sp=
eed)
 }
 #endif  /*  0  */
=20
-static int ds_start_pulse(struct ds_device *dev, int delay)
+static int ds_set_pullup(struct ds_device *dev, int delay)
 {
 	int err;
 	u8 del =3D 1 + (u8)(delay >> 4);
-	struct ds_status st;
-
-#if 0
-	err =3D ds_stop_pulse(dev, 10);
-	if (err)
-		return err;
-
-	err =3D ds_send_control_mode(dev, MOD_PULSE_EN, PULSE_SPUE);
-	if (err)
-		return err;
-#endif
-	err =3D ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
-	if (err)
-		return err;
=20
-	err =3D ds_send_control(dev, COMM_PULSE | COMM_IM | COMM_F, 0);
+	dev->spu_sleep =3D 0;
+	err =3D ds_send_control_mode(dev, MOD_PULSE_EN, delay?PULSE_SPUE:0);
 	if (err)
 		return err;
=20
-	mdelay(delay);
+	if(delay) {
+		err =3D ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
+		if (err)
+			return err;
=20
-	ds_wait_status(dev, &st);
+		/* Just storing delay would not get the trunication and
+		 * roundup.
+		 */
+		dev->spu_sleep =3D del<<4;
+	}
=20
 	return err;
 }
@@ -558,6 +544,9 @@ static int ds_write_byte(struct ds_device *dev, u8 byte)
 	if (err)
 		return err;
=20
+	if(dev->spu_sleep)
+		msleep(dev->spu_sleep);
+
 	err =3D ds_wait_status(dev, &st);
 	if (err)
 		return err;
@@ -566,8 +555,6 @@ static int ds_write_byte(struct ds_device *dev, u8 byte)
 	if (err < 0)
 		return err;
=20
-	ds_start_pulse(dev, PULLUP_PULSE_DURATION);
-
 	return !(byte =3D=3D rbyte);
 }
=20
@@ -603,7 +590,7 @@ static int ds_read_block(struct ds_device *dev, u8 *buf=
, int len)
 	if (err < 0)
 		return err;
=20
-	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
+	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM, len);
 	if (err)
 		return err;
=20
@@ -630,14 +617,15 @@ static int ds_write_block(struct ds_device *dev, u8 *=
buf, int len)
 	if (err)
 		return err;
=20
+	if(dev->spu_sleep)
+		msleep(dev->spu_sleep);
+
 	ds_wait_status(dev, &st);
=20
 	err =3D ds_recv_data(dev, buf, len);
 	if (err < 0)
 		return err;
=20
-	ds_start_pulse(dev, PULLUP_PULSE_DURATION);
-
 	return !(err =3D=3D len);
 }
=20
@@ -803,6 +791,16 @@ static u8 ds9490r_reset(void *data)
 	return 0;
 }
=20
+static u8 ds9490r_set_pullup(void *data, int delay)
+{
+	struct ds_device *dev =3D data;
+
+	if (ds_set_pullup(dev, delay))
+		return 1;
+
+	return 0;
+}
+
 static int ds_w1_init(struct ds_device *dev)
 {
 	memset(&dev->master, 0, sizeof(struct w1_bus_master));
@@ -816,6 +814,7 @@ static int ds_w1_init(struct ds_device *dev)
 	dev->master.read_block	=3D &ds9490r_read_block;
 	dev->master.write_block	=3D &ds9490r_write_block;
 	dev->master.reset_bus	=3D &ds9490r_reset;
+	dev->master.set_pullup	=3D &ds9490r_set_pullup;
=20
 	return w1_add_master_device(&dev->master);
 }
@@ -839,6 +838,7 @@ static int ds_probe(struct usb_interface *intf,
 		printk(KERN_INFO "Failed to allocate new DS9490R structure.\n");
 		return -ENOMEM;
 	}
+	dev->spu_sleep=3D0;
 	dev->udev =3D usb_get_dev(udev);
 	if (!dev->udev) {
 		err =3D -ENOMEM;
--=20
1.4.4.4

--I2k41U2G4dq8LTBU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQeAI852cse6PARAv6gAKCBInBkyIFJBh7OnYWWWGJN4jTewwCcCSIB
4EplBRUN5LmOJ2Fiahbg7/I=
=m8ZQ
-----END PGP SIGNATURE-----

--I2k41U2G4dq8LTBU--
