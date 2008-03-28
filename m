Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbYC1M4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbYC1M4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbYC1Mxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:53:33 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34535 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716AbYC1Mxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:53:32 -0400
Date: Fri, 28 Mar 2008 07:27:25 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 27/35] W1: ds2490.c disable bit read and write
Message-ID: <20080328122725.GB3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qjo19A2vmS5T5MQB"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:25 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qjo19A2vmS5T5MQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Summary, don't export read and write bit operations, they didn't work,
they weren't used, and they can't be made to work.

ds2490.c 1.12
Comment out ds9490r_read_bit, ds9490r_write_bit, and ds_write_bit as
well as not exporting them to the one wire core.  As originally coded
ds_write_bit filled up the command fifo with invalid commands and left
data in the input buffer (both fixed in earlier patches).  The
underlying w1_io never even used these functions as the more advanced
byte, block, reset, and touch functions were available.

read_bit and write_bit in w1_bus_master are expected to set and sample
the line level.  For write_bit that means it is expected to set it to
that value and leave it there.  ds2490 only supports an individual
time slot at the lowest level.  The requirement from pulling the bus
state down to reading the state is 15us, something that isn't
realistic on the USB bus anyway.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index e0e9325..8c3d756 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -520,6 +520,7 @@ static int ds_touch_bit(struct ds_device *dev, u8 bit, =
u8 *tbit)
 	return 0;
 }
=20
+#if 0
 static int ds_write_bit(struct ds_device *dev, u8 bit)
 {
 	int err;
@@ -538,6 +539,7 @@ static int ds_write_bit(struct ds_device *dev, u8 bit)
=20
 	return 0;
 }
+#endif
=20
 static int ds_write_byte(struct ds_device *dev, u8 byte)
 {
@@ -722,6 +724,7 @@ static u8 ds9490r_touch_bit(void *data, u8 bit)
 	return ret;
 }
=20
+#if 0
 static void ds9490r_write_bit(void *data, u8 bit)
 {
 	struct ds_device *dev =3D data;
@@ -729,13 +732,6 @@ static void ds9490r_write_bit(void *data, u8 bit)
 	ds_write_bit(dev, bit);
 }
=20
-static void ds9490r_write_byte(void *data, u8 byte)
-{
-	struct ds_device *dev =3D data;
-
-	ds_write_byte(dev, byte);
-}
-
 static u8 ds9490r_read_bit(void *data)
 {
 	struct ds_device *dev =3D data;
@@ -748,6 +744,14 @@ static u8 ds9490r_read_bit(void *data)
=20
 	return bit & 1;
 }
+#endif
+
+static void ds9490r_write_byte(void *data, u8 byte)
+{
+	struct ds_device *dev =3D data;
+
+	ds_write_byte(dev, byte);
+}
=20
 static u8 ds9490r_read_byte(void *data)
 {
@@ -812,8 +816,15 @@ static int ds_w1_init(struct ds_device *dev)
=20
 	dev->master.data	=3D dev;
 	dev->master.touch_bit	=3D &ds9490r_touch_bit;
+	/* read_bit and write_bit in w1_bus_master are expected to set and
+	 * sample the line level.  For write_bit that means it is expected to
+	 * set it to that value and leave it there.  ds2490 only supports an
+	 * individual time slot at the lowest level.  The requirement from
+	 * pulling the bus state down to reading the state is 15us, something
+	 * that isn't realistic on the USB bus anyway.
 	dev->master.read_bit	=3D &ds9490r_read_bit;
 	dev->master.write_bit	=3D &ds9490r_write_bit;
+	*/
 	dev->master.read_byte	=3D &ds9490r_read_byte;
 	dev->master.write_byte	=3D &ds9490r_write_byte;
 	dev->master.read_block	=3D &ds9490r_read_block;
--=20
1.4.4.4

--Qjo19A2vmS5T5MQB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQsAI852cse6PARAv7XAKCbw+H72UQqHUAhsOZEuR8bPzmC8wCfXM7D
aOwurJOwcUUUvQTJzm620co=
=+fte
-----END PGP SIGNATURE-----

--Qjo19A2vmS5T5MQB--
