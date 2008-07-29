Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYG2C0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYG2C0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbYG2C0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:26:03 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:58116 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbYG2C0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:26:01 -0400
Date: Mon, 28 Jul 2008 21:25:56 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 22/30] W1: ds2490.c disable bit read and write
Message-ID: <20080729022556.GV24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0cPfB1ccX8kkdppm"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:25:56 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0cPfB1ccX8kkdppm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Don't export read and write bit operations, they didn't work, they
weren't used, and they can't be made to work.  The one wire low level
bit operations expect to set high or low levels, the ds2490 hardware
only supports complete read or write time slots, better to just
comment them out.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 7acf6d2..6bfd6a9 100644
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

--0cPfB1ccX8kkdppm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn+0AI852cse6PARAosTAJ9iQOGSAeXkp0mW2A0zlp+1bFmRCgCZAf6c
GxmYPnPRHVAwwXg2mTlPCXc=
=RVo8
-----END PGP SIGNATURE-----

--0cPfB1ccX8kkdppm--
