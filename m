Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbYGaC5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbYGaC5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbYGaCvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:51:04 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:55963 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761201AbYGaCvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:51:01 -0400
Date: Wed, 30 Jul 2008 21:50:07 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 22/30] W1: ds2490.c disable bit read and write
Message-ID: <20080731025007.GW12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:50:07 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 6fabf58..1b632d5 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -520,6 +520,7 @@ static int ds_touch_bit(struct ds_device *dev, u8 bit, u8 *tbit)
 	return 0;
 }
 
+#if 0
 static int ds_write_bit(struct ds_device *dev, u8 bit)
 {
 	int err;
@@ -538,6 +539,7 @@ static int ds_write_bit(struct ds_device *dev, u8 bit)
 
 	return 0;
 }
+#endif
 
 static int ds_write_byte(struct ds_device *dev, u8 byte)
 {
@@ -722,6 +724,7 @@ static u8 ds9490r_touch_bit(void *data, u8 bit)
 	return ret;
 }
 
+#if 0
 static void ds9490r_write_bit(void *data, u8 bit)
 {
 	struct ds_device *dev = data;
@@ -729,13 +732,6 @@ static void ds9490r_write_bit(void *data, u8 bit)
 	ds_write_bit(dev, bit);
 }
 
-static void ds9490r_write_byte(void *data, u8 byte)
-{
-	struct ds_device *dev = data;
-
-	ds_write_byte(dev, byte);
-}
-
 static u8 ds9490r_read_bit(void *data)
 {
 	struct ds_device *dev = data;
@@ -748,6 +744,14 @@ static u8 ds9490r_read_bit(void *data)
 
 	return bit & 1;
 }
+#endif
+
+static void ds9490r_write_byte(void *data, u8 byte)
+{
+	struct ds_device *dev = data;
+
+	ds_write_byte(dev, byte);
+}
 
 static u8 ds9490r_read_byte(void *data)
 {
@@ -812,8 +816,15 @@ static int ds_w1_init(struct ds_device *dev)
 
 	dev->master.data	= dev;
 	dev->master.touch_bit	= &ds9490r_touch_bit;
+	/* read_bit and write_bit in w1_bus_master are expected to set and
+	 * sample the line level.  For write_bit that means it is expected to
+	 * set it to that value and leave it there.  ds2490 only supports an
+	 * individual time slot at the lowest level.  The requirement from
+	 * pulling the bus state down to reading the state is 15us, something
+	 * that isn't realistic on the USB bus anyway.
 	dev->master.read_bit	= &ds9490r_read_bit;
 	dev->master.write_bit	= &ds9490r_write_bit;
+	*/
 	dev->master.read_byte	= &ds9490r_read_byte;
 	dev->master.write_byte	= &ds9490r_write_byte;
 	dev->master.read_block	= &ds9490r_read_block;
-- 
1.4.4.4
