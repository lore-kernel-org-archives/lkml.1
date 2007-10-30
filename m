Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbXJ3JU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbXJ3JU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXJ3JSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:18:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:15274 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbXJ3JSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:18:15 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="55175268:sNHT26794747"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 08/14] Blackfin SPI driver: Move GPIO config to setup and cleanup
Date: Tue, 30 Oct 2007 17:17:59 +0800
Message-Id: <1193735885-8202-9-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   52 +++++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 3bd8359..7f95797 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -136,7 +136,6 @@ struct chip_data {
 	u16 flag;
 
 	u8 chip_select_num;
-	u8 chip_select_requested;
 	u8 n_bytes;
 	u8 width;		/* 0 or 1 */
 	u8 enable_dma;
@@ -216,19 +215,7 @@ static int restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 	int ret = 0;
-	u16 ssel[3][MAX_SPI_SSEL] = {
-		{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
-		P_SPI0_SSEL4, P_SPI0_SSEL5,
-		P_SPI0_SSEL6, P_SPI0_SSEL7},
-
-		{P_SPI1_SSEL1, P_SPI1_SSEL2, P_SPI1_SSEL3,
-		P_SPI1_SSEL4, P_SPI1_SSEL5,
-		P_SPI1_SSEL6, P_SPI1_SSEL7},
-
-		{P_SPI2_SSEL1, P_SPI2_SSEL2, P_SPI2_SSEL3,
-		P_SPI2_SSEL4, P_SPI2_SSEL5,
-		P_SPI2_SSEL6, P_SPI2_SSEL7},
-	};
+
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
@@ -239,17 +226,6 @@ static int restore_state(struct driver_data *drv_data)
 	write_BAUD(chip->baud);
 	cs_active(chip);
 
-	if (!chip->chip_select_requested) {
-		int i = chip->chip_select_num;
-
-		dev_dbg(&drv_data->pdev->dev, "chip select number is %d\n", i);
-		if ((i > 0) && (i <= MAX_SPI_SSEL))
-			ret = peripheral_request(
-				ssel[drv_data->master->bus_num][i-1], DRV_NAME);
-
-		chip->chip_select_requested = 1;
-	}
-
 	if (ret)
 		dev_dbg(&drv_data->pdev->dev,
 			": request chip select number %d failed\n",
@@ -981,6 +957,22 @@ static int transfer(struct spi_device *spi, struct spi_message *msg)
 	return 0;
 }
 
+#define MAX_SPI_SSEL	7
+
+static u16 ssel[3][MAX_SPI_SSEL] = {
+	{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
+	P_SPI0_SSEL4, P_SPI0_SSEL5,
+	P_SPI0_SSEL6, P_SPI0_SSEL7},
+
+	{P_SPI1_SSEL1, P_SPI1_SSEL2, P_SPI1_SSEL3,
+	P_SPI1_SSEL4, P_SPI1_SSEL5,
+	P_SPI1_SSEL6, P_SPI1_SSEL7},
+
+	{P_SPI2_SSEL1, P_SPI2_SSEL2, P_SPI2_SSEL3,
+	P_SPI2_SSEL4, P_SPI2_SSEL5,
+	P_SPI2_SSEL6, P_SPI2_SSEL7},
+};
+
 /* first setup for new devices */
 static int setup(struct spi_device *spi)
 {
@@ -1109,6 +1101,12 @@ static int setup(struct spi_device *spi)
 
 	spi_set_ctldata(spi, chip);
 
+	dev_dbg(&spi->dev, "chip select number is %d\n", chip->chip_select_num);
+	if ((chip->chip_select_num > 0)
+		&& (chip->chip_select_num <= spi->master->num_chipselect))
+		peripheral_request(ssel[spi->master->bus_num]
+			[chip->chip_select_num-1], DRV_NAME);
+
 	return 0;
 }
 
@@ -1120,6 +1118,10 @@ static void cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata(spi);
 
+	if ((chip->chip_select_num > 0)
+		&& (chip->chip_select_num <= spi->master->num_chipselect))
+		peripheral_free(ssel[spi->master->bus_num][chip->chip_select_num-1]);
+
 	kfree(chip);
 }
 
-- 
1.5.3.4
