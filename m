Return-Path: <linux-kernel-owner+w=401wt.eu-S1763686AbZDHJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763686AbZDHJO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZDHJOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:14:19 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:3039 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655AbZDHJOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:14:18 -0400
From: Wolfgang =?iso-8859-15?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] mmc_spi: speedup for slow cards, less wear-out
Date: Wed, 8 Apr 2009 10:14:07 +0100
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904081114.07653.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

o Speedup for slow cards by transfering more data at once.
  This patch also reduces the amount of wear-out of the flash
  blocks because fewer partial blocks are written.  

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>

---

diff -uprN 2_6_29_rc7_patch1253467/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch1253467/drivers/mmc/host/mmc_spi.c	2009-04-07 17:19:21.000000000 +0200
+++ 2_6_29_rc7_patch_wearout_speedup/drivers/mmc/host/mmc_spi.c	2009-04-08 11:11:20.000000000 +0200
@@ -97,6 +97,14 @@
  */
 #define r1b_timeout		(HZ * 3)
 
+/* One of the critical speed parameters is the amount of data which may
+ * be transfered in one command. If this value is too low, the SD card
+ * controller has to do multiple partial block writes (argggh!). With
+ * today (2008) SD cards there is little speed gain if we transfer more
+ * than 64 KBytes at a time. So use this value until there is any indication
+ * that we should do more here.
+ */
+#define MMC_SPI_BLOCKSATONCE	128
 
 /****************************************************************************/
 
@@ -1366,6 +1374,10 @@ static int mmc_spi_probe(struct spi_devi
 
 	mmc->ops = &mmc_spi_ops;
 	mmc->max_blk_size = MMC_SPI_BLOCKSIZE;
+	mmc->max_hw_segs = MMC_SPI_BLOCKSATONCE;
+	mmc->max_phys_segs = MMC_SPI_BLOCKSATONCE;
+	mmc->max_req_size = MMC_SPI_BLOCKSATONCE * MMC_SPI_BLOCKSIZE;
+	mmc->max_blk_count = MMC_SPI_BLOCKSATONCE;
 
 	mmc->caps = MMC_CAP_SPI;
 
---
regards

i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
