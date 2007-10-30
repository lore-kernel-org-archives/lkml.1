Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbXJ3JWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbXJ3JWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbXJ3JS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:18:26 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:42181 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbXJ3JSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:18:16 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="55175273:sNHT44739541"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Cameron Barfield <cbarfield@cyberdata.net>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 13/14] Blackfin SPI driver: Move cs_chg_udelay to cs_deactive to fix bug when some SPI LCD driver needs delay after cs_deactive
Date: Tue, 30 Oct 2007 17:18:04 +0800
Message-Id: <1193735885-8202-14-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug reported by Cameron Barfield <cbarfield@cyberdata.net>
https://blackfin.uclinux.org/gf/project/uclinux-dist/forum/?action=ForumBrowse&forum_id=39&_forum_action=ForumMessageBrowse&thread_id=23630&feedback=Message%20replied.

Cc: Cameron Barfield <cbarfield@cyberdata.net>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c          |   24 +++++++++---------------
 include/asm-blackfin/bfin5xx_spi.h |    2 +-
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 41282bf..0b22932 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -132,7 +132,7 @@ struct chip_data {
 	u8 enable_dma;
 	u8 bits_per_word;	/* 8 or 16 */
 	u8 cs_change_per_word;
-	u8 cs_chg_udelay;
+	u16 cs_chg_udelay;	/* Some devices require > 255usec delay */
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -211,6 +211,10 @@ static void cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 	flag |= (chip->flag << 8);
 
 	write_FLAG(drv_data, flag);
+
+	/* Move delay here for consistency */
+	if (chip->cs_chg_udelay)
+		udelay(chip->cs_chg_udelay);
 }
 
 #define MAX_SPI_SSEL	7
@@ -307,10 +311,9 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
 }
@@ -359,9 +362,6 @@ static void u8_cs_chg_reader(struct driver_data *drv_data)
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
-
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		cs_active(drv_data, chip);
@@ -412,10 +412,9 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
@@ -452,10 +451,9 @@ static void u16_cs_chg_writer(struct driver_data *drv_data)
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
 			continue;
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
 }
@@ -504,9 +502,6 @@ static void u16_cs_chg_reader(struct driver_data *drv_data)
 	while (drv_data->rx < drv_data->rx_end - 2) {
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
-
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		cs_active(drv_data, chip);
@@ -557,10 +552,9 @@ static void u16_cs_chg_duplex(struct driver_data *drv_data)
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
diff --git a/include/asm-blackfin/bfin5xx_spi.h b/include/asm-blackfin/bfin5xx_spi.h
index f617d87..d4485b3 100644
--- a/include/asm-blackfin/bfin5xx_spi.h
+++ b/include/asm-blackfin/bfin5xx_spi.h
@@ -162,7 +162,7 @@ struct bfin5xx_spi_chip {
 	u8 enable_dma;
 	u8 bits_per_word;
 	u8 cs_change_per_word;
-	u8 cs_chg_udelay;
+	u16 cs_chg_udelay; /* Some devices require 16-bit delays */
 };
 
 #endif /* _SPI_CHANNEL_H_ */
-- 
1.5.3.4
