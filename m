Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYC1M5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYC1M5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYC1Mz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:27 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbYC1MzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:24 -0400
Date: Fri, 28 Mar 2008 07:28:04 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 35/35] W1: ds2490.c optimize ds_set_pullup
Message-ID: <20080328122804.GJ3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dYuLH7fbMjVsPkFl"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:28:05 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dYuLH7fbMjVsPkFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c 1.20

Optimize the ds_set_pullup function.

Previously when ds_set_pullup was called with a time, the strong pullup
mode was enabled, and the delay was set, when the write command was
called the strong pullup bit was always set, then the strong pullup
mode would be disabled by ds_set_pullup after the write.

ds_send_control_mode(dev, MOD_PULSE_EN, delay?PULSE_SPUE:0);
ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
	ds_send_control(dev, COMM_BYTE_IO | COMM_IM | COMM_SPU, byte);
ds_send_control_mode(dev, MOD_PULSE_EN, delay?PULSE_SPUE:0);

This change enables the strong pullup mode at initialization.
ds_send_control_mode(dev, MOD_PULSE_EN, PULSE_SPUE);
If ds_set_pullup was called with a time, the delay was updated only if
it had changed, and an internal variable set to enable the SPU bit on
the following write command.  The ds_set_pullup to disable the strong pullup
only updates the variable.
ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del); // if required
	ds_send_control(dev, COMM_BYTE_IO | COMM_IM | dev->spu_bit, byte);

In the best case, after the first pullup, the requested duration doesn't
change, making three less control transfers, 2 before and one after the
strong pullup enabled transaction.

In the worst case, after the hardware is initialized, it is 2 less
control transfers, as the delay has to be changed between each strong
pullup transfer.

Here is the total time for seven temperature conversions, three with 900ms
and four with 750ms.  The conversion that includes the extra set delay
control takes a little longer.  The additional time is a little closer to
the noise level than this data set might imply.  USBMon puts it between
2ms and 3ms for a control transfer.  This patch would save two to three
times that.

			750ms request
real    0m1.002s        900ms request, update duration
real    0m0.994s        900ms request,
real    0m0.994s        900ms request,
real    0m0.842s        750ms request, update duration
real    0m0.834s        750ms request,
real    0m0.834s        750ms request,
real    0m0.834s        750ms request,

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |   62 +++++++++++++++++++++++++++++----------=
---
 1 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index cde99b7..9b44205 100644
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
@@ -310,6 +314,23 @@ static void ds_dump_status(struct ds_device *dev, unsi=
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
+	if(ds_send_control_mode(dev, MOD_PULSE_EN, PULSE_SPUE))
+		printk("ds_reset_device: Error allowing string pullup\n");
+	/* Chip strong pullup time was cleared. */
+	if(dev->spu_sleep) {
+		/* lower 4 bits are 0, see ds_set_pullup */
+		u8 del=3Ddev->spu_sleep>>4;
+		if(ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del))
+			printk("ds_reset_device: Error setting duration\n");
+	}
+}
+
 static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int siz=
e)
 {
 	int count, err;
@@ -443,7 +464,7 @@ static int ds_wait_status(struct ds_device *dev, struct=
 ds_status *st)
=20
 	if(err>=3D16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
-		ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+		ds_reset_device(dev);
 		/* Always dump the device status. */
 		count=3D101;
 	}
@@ -504,24 +525,26 @@ static int ds_set_speed(struct ds_device *dev, int sp=
eed)
=20
 static int ds_set_pullup(struct ds_device *dev, int delay)
 {
-	int err;
+	int err=3D0;
 	u8 del =3D 1 + (u8)(delay >> 4);
+	/* Just storing delay would not get the trunication and roundup. */
+	int ms =3D del<<4;
+
+	/* Enable spu_bit if a delay is set. */
+	dev->spu_bit=3Ddelay?COMM_SPU:0;
+	/* If delay is zero, it has already been disabled, if the time is
+	 * the same as the hardware was last programmed to, there is also
+	 * nothing more to do.  Compare with the recalculated value ms
+	 * rather than del or delay which can have a different value.
+	 */
+	if(delay=3D=3D0 || ms=3D=3Ddev->spu_sleep)
+		return err;
=20
-	dev->spu_sleep =3D 0;
-	err =3D ds_send_control_mode(dev, MOD_PULSE_EN, delay?PULSE_SPUE:0);
+	err =3D ds_send_control(dev, COMM_SET_DURATION | COMM_IM, del);
 	if (err)
 		return err;
=20
-	if(delay) {
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
@@ -572,11 +595,11 @@ static int ds_write_byte(struct ds_device *dev, u8 by=
te)
 	struct ds_status st;
 	u8 rbyte;
=20
-	err =3D ds_send_control(dev, COMM_BYTE_IO | COMM_IM | COMM_SPU, byte);
+	err =3D ds_send_control(dev, COMM_BYTE_IO | COMM_IM | dev->spu_bit, byte);
 	if (err)
 		return err;
=20
-	if(dev->spu_sleep)
+	if(dev->spu_bit)
 		msleep(dev->spu_sleep);
=20
 	err =3D ds_wait_status(dev, &st);
@@ -643,11 +666,11 @@ static int ds_write_block(struct ds_device *dev, u8 *=
buf, int len)
 	if (err < 0)
 		return err;
=20
-	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
+	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | dev->spu_bit, len);
 	if (err)
 		return err;
=20
-	if(dev->spu_sleep)
+	if(dev->spu_bit)
 		msleep(dev->spu_sleep);
=20
 	ds_wait_status(dev, &st);
@@ -844,7 +867,7 @@ static int ds_w1_init(struct ds_device *dev)
 	 * the input buffer.  This will cause the next read to fail
 	 * see the note in ds_recv_data.
 	 */
-	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+	ds_reset_device(dev);
=20
 	dev->master.data	=3D dev;
 	dev->master.touch_bit	=3D &ds9490r_touch_bit;
@@ -887,6 +910,7 @@ static int ds_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 	dev->spu_sleep=3D0;
+	dev->spu_bit=3D0;
 	dev->udev =3D usb_get_dev(udev);
 	if (!dev->udev) {
 		err =3D -ENOMEM;
--=20
1.4.4.4

--dYuLH7fbMjVsPkFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7ORUAI852cse6PARAiZtAJ0Rn0RG6PY9/j/q3DI9eBEM1fM9pwCbBmpQ
6aoZ/6P6lQmqAkZyOznloJ0=
=fYAI
-----END PGP SIGNATURE-----

--dYuLH7fbMjVsPkFl--
