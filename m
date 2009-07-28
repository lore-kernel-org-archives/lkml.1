Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZG1Kjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZG1Kjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZG1Kjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:39:51 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32115 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbZG1Kjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:39:49 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:39:34 +0300
Message-Id: <20090728103934.2371.96819.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 8/32] mmc: check status after MMC SWITCH command
X-OriginalArrivalTime: 28 Jul 2009 10:39:05.0548 (UTC) FILETIME=[A14D88C0:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 98c0aabb4c04bcdf7d166c0fb7e2c859e33f8c70 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Wed, 3 Jun 2009 12:22:29 +0300
Subject: [PATCH] mmc: check status after MMC SWITCH command

According to the standard, the SWITCH command should
be followed by a SEND_STATUS command to check for
errors.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/core/mmc.c     |   24 ++++++++++++++++++------
 drivers/mmc/core/mmc_ops.c |   23 +++++++++++++++++++++++
 include/linux/mmc/mmc.h    |    1 +
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 8e2e3d2..f87cc0b 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -416,12 +416,17 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		(host->caps & MMC_CAP_MMC_HIGHSPEED)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 			EXT_CSD_HS_TIMING, 1);
-		if (err)
+		if (err && err != -EBADMSG)
 			goto free_card;
 
-		mmc_card_set_highspeed(card);
-
-		mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
+		if (err) {
+			printk(KERN_WARNING "%s: switch to highspeed failed\n",
+			       mmc_hostname(card->host));
+			err = 0;
+		} else {
+			mmc_card_set_highspeed(card);
+			mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
+		}
 	}
 
 	/*
@@ -456,10 +461,17 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 				 EXT_CSD_BUS_WIDTH, ext_csd_bit);
 
-		if (err)
+		if (err && err != -EBADMSG)
 			goto free_card;
 
-		mmc_set_bus_width(card->host, bus_width);
+		if (err) {
+			printk(KERN_WARNING "%s: switch to bus width %d "
+			       "failed\n", mmc_hostname(card->host),
+			       1 << bus_width);
+			err = 0;
+		} else {
+			mmc_set_bus_width(card->host, bus_width);
+		}
 	}
 
 	if (!oldcard)
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 355c604..d2cb5c6 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -390,6 +390,7 @@ int mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value)
 {
 	int err;
 	struct mmc_command cmd;
+	u32 status;
 
 	BUG_ON(!card);
 	BUG_ON(!card->host);
@@ -407,6 +408,28 @@ int mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value)
 	if (err)
 		return err;
 
+	/* Must check status to be sure of no errors */
+	do {
+		err = mmc_send_status(card, &status);
+		if (err)
+			return err;
+		if (card->host->caps & MMC_CAP_WAIT_WHILE_BUSY)
+			break;
+		if (mmc_host_is_spi(card->host))
+			break;
+	} while (R1_CURRENT_STATE(status) == 7);
+
+	if (mmc_host_is_spi(card->host)) {
+		if (status & R1_SPI_ILLEGAL_COMMAND)
+			return -EBADMSG;
+	} else {
+		if (status & 0xFDFFA000)
+			printk(KERN_WARNING "%s: unexpected status %#x after "
+			       "switch", mmc_hostname(card->host), status);
+		if (status & R1_SWITCH_ERROR)
+			return -EBADMSG;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index b2b4095..c02c8db 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -128,6 +128,7 @@
 #define R1_STATUS(x)            (x & 0xFFFFE000)
 #define R1_CURRENT_STATE(x)	((x & 0x00001E00) >> 9)	/* sx, b (4 bits) */
 #define R1_READY_FOR_DATA	(1 << 8)	/* sx, a */
+#define R1_SWITCH_ERROR		(1 << 7)	/* sx, c */
 #define R1_APP_CMD		(1 << 5)	/* sr, c */
 
 /*
-- 
1.5.6.3

