Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZBEKHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZBEKHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZBEKFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:05:48 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:26486 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbZBEKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:05:45 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82351964"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/5] Blackfin SPI Driver: Add GPIO controlled SPI Slave Select support
Date: Thu,  5 Feb 2009 18:07:32 +0800
Message-Id: <1233828453-13311-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

This patch adds support for GPIO controlled SPI Chip Selects.
To make use of this feature, set chip_select = 0 and add a proper
cs_gpio to your controller_data.

struct spi_board_info
        .chip_select = 0

struct bfin5xx_spi_chip
        .cs_gpio = GPIO_P###

There are various SPI devices that require SPI MODE_0,
and need to have the Chip Selects asserted during the entire transfer.
Consider using SPI_MODE_3 (SPI_CPHA | SPI_CPOL) if your device allows
it.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/include/asm/bfin5xx_spi.h |    1 +
 drivers/spi/spi_bfin5xx.c               |   40 ++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin5xx_spi.h b/arch/blackfin/include/asm/bfin5xx_spi.h
index e1bb164..da8b9ca 100644
--- a/arch/blackfin/include/asm/bfin5xx_spi.h
+++ b/arch/blackfin/include/asm/bfin5xx_spi.h
@@ -124,6 +124,7 @@ struct bfin5xx_spi_chip {
 	u8 bits_per_word;
 	u8 cs_change_per_word;
 	u16 cs_chg_udelay; /* Some devices require 16-bit delays */
+	u32 cs_gpio;
 };
 
 #endif /* _SPI_CHANNEL_H_ */
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index b6098b5..5089afe 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -114,6 +114,7 @@ struct chip_data {
 	u8 bits_per_word;	/* 8 or 16 */
 	u8 cs_change_per_word;
 	u16 cs_chg_udelay;	/* Some devices require > 255usec delay */
+	u32 cs_gpio;
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -180,22 +181,30 @@ static int bfin_spi_flush(struct driver_data *drv_data)
 /* Chip select operation functions for cs_change flag */
 static void bfin_spi_cs_active(struct driver_data *drv_data, struct chip_data *chip)
 {
-	u16 flag = read_FLAG(drv_data);
+	if (likely(chip->chip_select_num)) {
+		u16 flag = read_FLAG(drv_data);
 
-	flag |= chip->flag;
-	flag &= ~(chip->flag << 8);
+		flag |= chip->flag;
+		flag &= ~(chip->flag << 8);
 
-	write_FLAG(drv_data, flag);
+		write_FLAG(drv_data, flag);
+	} else {
+		gpio_set_value(chip->cs_gpio, 0);
+	}
 }
 
 static void bfin_spi_cs_deactive(struct driver_data *drv_data, struct chip_data *chip)
 {
-	u16 flag = read_FLAG(drv_data);
+	if (likely(chip->chip_select_num)) {
+		u16 flag = read_FLAG(drv_data);
 
-	flag &= ~chip->flag;
-	flag |= (chip->flag << 8);
+		flag &= ~chip->flag;
+		flag |= (chip->flag << 8);
 
-	write_FLAG(drv_data, flag);
+		write_FLAG(drv_data, flag);
+	} else {
+		gpio_set_value(chip->cs_gpio, 1);
+	}
 
 	/* Move delay here for consistency */
 	if (chip->cs_chg_udelay)
@@ -1098,6 +1107,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 	struct bfin5xx_spi_chip *chip_info = NULL;
 	struct chip_data *chip;
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+	int ret;
 
 	/* Abort device setup if requested features are not supported */
 	if (spi->mode & ~(SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST)) {
@@ -1143,6 +1153,7 @@ static int bfin_spi_setup(struct spi_device *spi)
 		chip->bits_per_word = chip_info->bits_per_word;
 		chip->cs_change_per_word = chip_info->cs_change_per_word;
 		chip->cs_chg_udelay = chip_info->cs_chg_udelay;
+		chip->cs_gpio = chip_info->cs_gpio;
 	}
 
 	/* translate common spi framework into our register */
@@ -1183,6 +1194,16 @@ static int bfin_spi_setup(struct spi_device *spi)
 	chip->flag = 1 << (spi->chip_select);
 	chip->chip_select_num = spi->chip_select;
 
+	if (chip->chip_select_num == 0) {
+		ret = gpio_request(chip->cs_gpio, spi->modalias);
+		if (ret) {
+			if (drv_data->dma_requested)
+				free_dma(drv_data->dma_channel);
+			return ret;
+		}
+		gpio_direction_output(chip->cs_gpio, 1);
+	}
+
 	switch (chip->bits_per_word) {
 	case 8:
 		chip->n_bytes = 1;
@@ -1248,6 +1269,9 @@ static void bfin_spi_cleanup(struct spi_device *spi)
 		peripheral_free(ssel[spi->master->bus_num]
 					[chip->chip_select_num-1]);
 
+	if (chip->chip_select_num == 0)
+		gpio_free(chip->cs_gpio);
+
 	kfree(chip);
 }
 
-- 
1.5.6.3
