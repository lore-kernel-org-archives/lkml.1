Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0BRAyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:54:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36014 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0BRAyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:54:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 18 Feb 2010 01:54:00 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] firewire: core: increase stack size of config ROM reader
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.040d1f77b4f1ddb4@s5r6.in-berlin.de>
Message-ID: <tkrat.41cd283579a10140@s5r6.in-berlin.de>
References: <tkrat.206fe651745e1dd7@s5r6.in-berlin.de>
 <tkrat.040d1f77b4f1ddb4@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stack size of 16 was artificially chosen and may be too small in
extreme cases.  A device won't be accessible then.

Since it doesn't really matter to the slab allocator whether we ask for
1088 bytes or 2048 bytes of scratch memory, just allocate 2048 bytes for
the sum of temporary config ROM image and stack, and we will never ever
overflow the stack (because there simply can't be more stack items than
ROM entries).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc8/drivers/firewire/core-device.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/core-device.c
+++ linux-2.6.33-rc8/drivers/firewire/core-device.c
@@ -493,7 +493,6 @@ static int read_rom(struct fw_device *de
 }
 
 #define READ_BIB_ROM_SIZE	256
-#define READ_BIB_STACK_SIZE	16
 
 /*
  * Read the bus info block, perform a speed probe, and read all of the rest of
@@ -510,7 +509,7 @@ static int read_bus_info_block(struct fw
 	int i, end, length, ret = -1;
 
 	rom = kmalloc(sizeof(*rom) * READ_BIB_ROM_SIZE +
-		      sizeof(*stack) * READ_BIB_STACK_SIZE, GFP_KERNEL);
+		      sizeof(*stack) * READ_BIB_ROM_SIZE, GFP_KERNEL);
 	if (rom == NULL)
 		return -ENOMEM;
 
@@ -612,8 +611,7 @@ static int read_bus_info_block(struct fw
 			    RCODE_COMPLETE)
 				goto out;
 
-			if ((key >> 30) != 3 || (rom[i] >> 30) < 2 ||
-			    sp >= READ_BIB_STACK_SIZE)
+			if ((key >> 30) != 3 || (rom[i] >> 30) < 2)
 				continue;
 			/*
 			 * Offset points outside the ROM.  May be a firmware

-- 
Stefan Richter
-=====-==-=- --=- =--=-
http://arcgraph.de/sr/

