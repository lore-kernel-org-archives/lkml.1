Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbZINUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbZINUSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933540AbZINUSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:18:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54072 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933498AbZINUIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 31/72] Blackfin: bf533-stamp: add resources for mmc_spi card
Date: Mon, 14 Sep 2009 16:07:35 -0400
Message-Id: <1252958896-25150-32-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf533/boards/stamp.c |   40 +++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 42d4c9f..e6548a6 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -35,6 +35,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <linux/spi/mmc_spi.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
@@ -223,6 +224,34 @@ static struct bfin5xx_spi_chip spidev_chip_info = {
 };
 #endif
 
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+#define MMC_SPI_CARD_DETECT_INT IRQ_PF5
+static int bfin_mmc_spi_init(struct device *dev,
+	irqreturn_t (*detect_int)(int, void *), void *data)
+{
+	return request_irq(MMC_SPI_CARD_DETECT_INT, detect_int,
+		IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+		"mmc-spi-detect", data);
+}
+
+static void bfin_mmc_spi_exit(struct device *dev, void *data)
+{
+	free_irq(MMC_SPI_CARD_DETECT_INT, data);
+}
+
+static struct mmc_spi_platform_data bfin_mmc_spi_pdata = {
+	.init = bfin_mmc_spi_init,
+	.exit = bfin_mmc_spi_exit,
+	.detect_delay = 100, /* msecs */
+};
+
+static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 8,
+	.pio_interrupt = 0,
+};
+#endif
+
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 	{
@@ -286,6 +315,17 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 		.controller_data = &spidev_chip_info,
 	},
 #endif
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+	{
+		.modalias = "mmc_spi",
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 4,
+		.platform_data = &bfin_mmc_spi_pdata,
+		.controller_data = &mmc_spi_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
 };
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
-- 
1.6.4.2

