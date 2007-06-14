Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbXFNKDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbXFNKDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbXFNKBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:01:42 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63409 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXFNKBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:01:38 -0400
Message-Id: <20070614100136.507335084@fluff.org.uk>
References: <20070614100109.192172553@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 11:01:15 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch 6/6] SM501: Check SM501 ID register on initialisation
Content-Disposition: inline; filename=simtec-drivers-mfd-sm501-idcheck.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When binding the driver, check the ID register for a valid
identity, in case the SM501 is not functioning correctly.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.21-quilt8/drivers/mfd/sm501.c
===================================================================
--- linux-2.6.21-quilt8.orig/drivers/mfd/sm501.c	2007-06-13 11:33:55.000000000 +0100
+++ linux-2.6.21-quilt8/drivers/mfd/sm501.c	2007-06-13 12:59:31.000000000 +0100
@@ -883,6 +883,7 @@ static int sm501_init_dev(struct sm501_d
 {
 	resource_size_t mem_avail;
 	unsigned long dramctrl;
+	unsigned long devid;
 	int ret;
 
 	mutex_init(&sm->clock_lock);
@@ -890,13 +891,18 @@ static int sm501_init_dev(struct sm501_d
 
 	INIT_LIST_HEAD(&sm->devices);
 
-	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
+	devid = readl(sm->regs + SM501_DEVICEID);
 
+	if ((devid & SM501_DEVICEID_IDMASK) != SM501_DEVICEID_SM501) {
+		dev_err(sm->dev, "incorrect device id %08lx\n", devid);
+		return -EINVAL;
+	}
+
+	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
 	mem_avail = sm501_mem_local[(dramctrl >> 13) & 0x7];
 
-	dev_info(sm->dev, "SM501 At %p: Version %08x, %ld Mb, IRQ %d\n",
-		 sm->regs, readl(sm->regs + SM501_DEVICEID),
-		 (unsigned long)mem_avail >> 20, sm->irq);
+	dev_info(sm->dev, "SM501 At %p: Version %08lx, %ld Mb, IRQ %d\n",
+		 sm->regs, devid, (unsigned long)mem_avail >> 20, sm->irq);
 
 	sm501_dump_gate(sm);
 
Index: linux-2.6.21-quilt8/include/linux/sm501-regs.h
===================================================================
--- linux-2.6.21-quilt8.orig/include/linux/sm501-regs.h	2007-06-13 11:33:55.000000000 +0100
+++ linux-2.6.21-quilt8/include/linux/sm501-regs.h	2007-06-13 11:33:56.000000000 +0100
@@ -109,6 +109,9 @@
 #define SM501_DEVICEID			(0x000060)
 /* 0x050100A0 */
 
+#define SM501_DEVICEID_SM501		(0x05010000)
+#define SM501_DEVICEID_IDMASK		(0xffff0000)
+
 #define SM501_PLLCLOCK_COUNT		(0x000064)
 #define SM501_MISC_TIMING		(0x000068)
 #define SM501_CURRENT_SDRAM_CLOCK	(0x00006C)

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
