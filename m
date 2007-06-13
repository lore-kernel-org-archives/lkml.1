Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbXFMNkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbXFMNkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbXFMNiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:38:16 -0400
Received: from gsimpson.gotadsl.co.uk ([84.12.90.178]:50873 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758450AbXFMNiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:38:15 -0400
Message-Id: <20070613131200.369210477@localhost>
References: <20070613130953.983863758@localhost>
Date: Wed, 13 Jun 2007 14:09:59 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [patch 6/6] SM501 MFD driver updates
Content-Disposition: inline; filename=simtec-drivers-mfd-sm501-idcheck.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SM501: Check SM501 ID register on initialisation

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
