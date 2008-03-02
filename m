Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYCBSgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYCBSgB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYCBSfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:35:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58606 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYCBSfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:35:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 2 Mar 2008 19:35:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: replace static ROM cache by allocated cache
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_bus_info_block() is repeatedly called by workqueue jobs.
These will step on each others toes eventually if there are multiple
workqueue threads, and we end up with corrupt config ROM images.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   41 +++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 14 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -400,6 +400,9 @@ read_rom(struct fw_device *device, int g
 	return callback_data.rcode;
 }
 
+#define READ_BIB_ROM_SIZE	256
+#define READ_BIB_STACK_SIZE	16
+
 /*
  * Read the bus info block, perform a speed probe, and read all of the rest of
  * the config ROM.  We do all this with a cached bus generation.  If the bus
@@ -409,16 +412,23 @@ read_rom(struct fw_device *device, int g
  */
 static int read_bus_info_block(struct fw_device *device, int generation)
 {
-	static u32 rom[256];
-	u32 stack[16], sp, key;
-	int i, end, length;
+	u32 *rom, *stack;
+	u32 sp, key;
+	int i, end, length, ret = -1;
+
+	rom = kmalloc(sizeof(*rom) * READ_BIB_ROM_SIZE +
+		      sizeof(*stack) * READ_BIB_STACK_SIZE, GFP_KERNEL);
+	if (rom == NULL)
+		return -ENOMEM;
+
+	stack = &rom[READ_BIB_ROM_SIZE];
 
 	device->max_speed = SCODE_100;
 
 	/* First read the bus info block. */
 	for (i = 0; i < 5; i++) {
 		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
-			return -1;
+			goto out;
 		/*
 		 * As per IEEE1212 7.2, during power-up, devices can
 		 * reply with a 0 for the first quadlet of the config
@@ -428,7 +438,7 @@ static int read_bus_info_block(struct fw
 		 * retry mechanism will try again later.
 		 */
 		if (i == 0 && rom[i] == 0)
-			return -1;
+			goto out;
 	}
 
 	device->max_speed = device->node->max_speed;
@@ -478,26 +488,26 @@ static int read_bus_info_block(struct fw
 		 */
 		key = stack[--sp];
 		i = key & 0xffffff;
-		if (i >= ARRAY_SIZE(rom))
+		if (i >= READ_BIB_ROM_SIZE)
 			/*
 			 * The reference points outside the standard
 			 * config rom area, something's fishy.
 			 */
-			return -1;
+			goto out;
 
 		/* Read header quadlet for the block to get the length. */
 		if (read_rom(device, generation, i, &rom[i]) != RCODE_COMPLETE)
-			return -1;
+			goto out;
 		end = i + (rom[i] >> 16) + 1;
 		i++;
-		if (end > ARRAY_SIZE(rom))
+		if (end > READ_BIB_ROM_SIZE)
 			/*
 			 * This block extends outside standard config
 			 * area (and the array we're reading it
 			 * into).  That's broken, so ignore this
 			 * device.
 			 */
-			return -1;
+			goto out;
 
 		/*
 		 * Now read in the block.  If this is a directory
@@ -507,9 +517,9 @@ static int read_bus_info_block(struct fw
 		while (i < end) {
 			if (read_rom(device, generation, i, &rom[i]) !=
 			    RCODE_COMPLETE)
-				return -1;
+				goto out;
 			if ((key >> 30) == 3 && (rom[i] >> 30) > 1 &&
-			    sp < ARRAY_SIZE(stack))
+			    sp < READ_BIB_STACK_SIZE)
 				stack[sp++] = i + rom[i];
 			i++;
 		}
@@ -519,11 +529,14 @@ static int read_bus_info_block(struct fw
 
 	device->config_rom = kmalloc(length * 4, GFP_KERNEL);
 	if (device->config_rom == NULL)
-		return -1;
+		goto out;
 	memcpy(device->config_rom, rom, length * 4);
 	device->config_rom_length = length;
+	ret = 0;
+ out:
+	kfree(rom);
 
-	return 0;
+	return ret;
 }
 
 static void fw_unit_release(struct device *dev)

-- 
Stefan Richter
-=====-==--- --== ---=-
http://arcgraph.de/sr/

