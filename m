Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbXHGM5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbXHGM5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933718AbXHGM5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:57:08 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:59650 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934214AbXHGM5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:57:06 -0400
Message-ID: <46B86BDF.8050700@csr.com>
Date: Tue, 07 Aug 2007 13:55:59 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: [patch 4/4] sdio: disable CD resistor
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com> <20070806220145.66b97559@poseidon.drzeus.cx> <46B86ADB.90000@csr.com>
In-Reply-To: <46B86ADB.90000@csr.com>
Content-Type: multipart/mixed;
 boundary="------------060204000303010706000208"
X-OriginalArrivalTime: 07 Aug 2007 12:56:04.0964 (UTC) FILETIME=[509F2240:01C7D8F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060204000303010706000208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------060204000303010706000208
Content-Type: text/x-patch;
 name="sdio-disable-cd-resistor.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-disable-cd-resistor.patch"

sdio: disable CD resistor

Disable the card detect resistor to ensure all data lines are equally loaded.
Not doing this can have a negative impact on buses with marginal signal
quality.

Signed-off-by: David Vrabel <david.vrabel@csr.com
---
Index: mmc/drivers/mmc/core/sdio.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio.c	2007-08-07 07:27:31.000000000 +0100
+++ mmc/drivers/mmc/core/sdio.c	2007-08-07 07:30:58.000000000 +0100
@@ -148,10 +148,25 @@
 	return ret;
 }
 
+static int sdio_modify_cccr(struct mmc_card *card, unsigned reg,
+	u8 val, u8 mask)
+{
+	u8 old;
+	int ret;
+
+	ret = mmc_io_rw_direct(card, 0, 0, reg, 0, &old);
+	if (ret)
+		return ret;
+
+	val = (old & ~mask) | val;
+
+	ret = mmc_io_rw_direct(card, 1, 0, reg, val, NULL);
+	return ret;
+}
+
 static int sdio_enable_wide(struct mmc_card *card)
 {
 	int ret;
-	u8 ctrl;
 
 	if (!(card->host->caps & MMC_CAP_4_BIT_DATA))
 		return 0;
@@ -159,13 +174,8 @@
 	if (card->cccr.low_speed && !card->cccr.wide_bus)
 		return 0;
 
-	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_IF, 0, &ctrl);
-	if (ret)
-		return ret;
-
-	ctrl |= SDIO_BUS_WIDTH_4BIT;
-
-	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
+	ret = sdio_modify_cccr(card, SDIO_CCCR_IF, SDIO_BUS_WIDTH_4BIT,
+		SDIO_BUS_WIDTH_MASK);
 	if (ret)
 		return ret;
 
@@ -334,6 +344,15 @@
 	mmc_set_clock(host, card->cis.max_dtr);
 
 	/*
+	 * Disable Card Detect resistor on DAT3 so all data lines are
+	 * loaded the same.
+	 */
+	err = sdio_modify_cccr(card, SDIO_CCCR_IF, SDIO_BUS_CD_DISABLE,
+		SDIO_BUS_CD_DISABLE);
+	if (err)
+		goto remove;
+
+	/*
 	 * Switch to wider bus (if supported).
 	 */
 	err = sdio_enable_wide(card);
Index: mmc/include/linux/mmc/sdio.h
===================================================================
--- mmc.orig/include/linux/mmc/sdio.h	2007-08-07 07:27:30.000000000 +0100
+++ mmc/include/linux/mmc/sdio.h	2007-08-07 07:27:31.000000000 +0100
@@ -94,6 +94,7 @@
 
 #define  SDIO_BUS_WIDTH_1BIT	0x00
 #define  SDIO_BUS_WIDTH_4BIT	0x02
+#define  SDIO_BUS_WIDTH_MASK	0x03
 
 #define  SDIO_BUS_CD_DISABLE     0x80	/* disable pull-up on DAT3 (pin 1) */
 

--------------060204000303010706000208--
