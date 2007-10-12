Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbXJLDKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbXJLDKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbXJLDFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:05:41 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:44167 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbXJLDFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:05:13 -0400
X-IronPort-AV: i="4.21,263,1188792000"; 
   d="scan'208"; a="41596820:sNHT40478326"
From: Bryan Wu <bryan.wu@analog.com>
To: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 07/10] Blackfin SPI driver: Add SPI master controller platform device 1
Date: Fri, 12 Oct 2007 11:05:01 +0800
Message-Id: <1192158304-8277-8-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c |   52 ++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 891d263..ecfb7c5 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -209,17 +209,26 @@ static void cs_deactive(struct chip_data *chip)
 	write_FLAG(flag);
 }
 
-#define MAX_SPI0_SSEL	7
+#define MAX_SPI_SSEL	7
 
 /* stop controller and re-config current chip*/
 static int restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
 	int ret = 0;
-	u16 ssel[MAX_SPI0_SSEL] = {P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
-					P_SPI0_SSEL4, P_SPI0_SSEL5,
-					P_SPI0_SSEL6, P_SPI0_SSEL7,};
-
+	u16 ssel[3][MAX_SPI_SSEL] = {
+		{P_SPI0_SSEL1, P_SPI0_SSEL2, P_SPI0_SSEL3,
+		P_SPI0_SSEL4, P_SPI0_SSEL5,
+		P_SPI0_SSEL6, P_SPI0_SSEL7},
+
+		{P_SPI1_SSEL1, P_SPI1_SSEL2, P_SPI1_SSEL3,
+		P_SPI1_SSEL4, P_SPI1_SSEL5,
+		P_SPI1_SSEL6, P_SPI1_SSEL7},
+
+		{P_SPI2_SSEL1, P_SPI2_SSEL2, P_SPI2_SSEL3,
+		P_SPI2_SSEL4, P_SPI2_SSEL5,
+		P_SPI2_SSEL6, P_SPI2_SSEL7},
+	};
 	/* Clear status and disable clock */
 	write_STAT(BIT_STAT_CLR);
 	bfin_spi_disable(drv_data);
@@ -234,9 +243,9 @@ static int restore_state(struct driver_data *drv_data)
 		int i = chip->chip_select_num;
 
 		dev_dbg(&drv_data->pdev->dev, "chip select number is %d\n", i);
-
-		if ((i > 0) && (i <= MAX_SPI0_SSEL))
-			ret = peripheral_request(ssel[i-1], DRV_NAME);
+		if ((i > 0) && (i <= MAX_SPI_SSEL))
+			ret = peripheral_request(
+				ssel[drv_data->master->bus_num][i-1], DRV_NAME);
 
 		chip->chip_select_requested = 1;
 	}
@@ -329,7 +338,6 @@ static void u8_reader(struct driver_data *drv_data)
 	write_TDBR(0xFFFF);
 
 	dummy_read();
-
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		while (!(read_STAT() & BIT_STAT_RXS))
 			continue;
@@ -640,7 +648,6 @@ static void pump_transfers(unsigned long data)
 	message = drv_data->cur_msg;
 	transfer = drv_data->cur_transfer;
 	chip = drv_data->cur_chip;
-
 	/*
 	 * if msg is error or done, report it back using complete() callback
 	 */
@@ -1202,17 +1209,20 @@ static inline int destroy_queue(struct driver_data *drv_data)
 	return 0;
 }
 
-static int setup_pin_mux(int action)
+static int setup_pin_mux(int action, int bus_num)
 {
 
-	u16 pin_req[] = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0};
+	u16 pin_req[3][4] = {
+		{P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
+		{P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0},
+		{P_SPI2_SCK, P_SPI2_MISO, P_SPI2_MOSI, 0},
+	};
 
 	if (action) {
-		if (peripheral_request_list(pin_req, DRV_NAME)) {
+		if (peripheral_request_list(pin_req[bus_num], DRV_NAME))
 			return -EFAULT;
-		}
 	} else {
-		peripheral_free_list(pin_req);
+		peripheral_free_list(pin_req[bus_num]);
 	}
 
 	return 0;
@@ -1236,11 +1246,6 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (setup_pin_mux(1)) {
-		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
-		goto out_error;
-	}
-
 	drv_data = spi_master_get_devdata(master);
 	drv_data->master = master;
 	drv_data->master_info = platform_info;
@@ -1295,6 +1300,11 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		goto out_error_queue_alloc;
 	}
 
+	if (setup_pin_mux(1, master->bus_num)) {
+		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
+		goto out_error;
+	}
+
 	dev_info(dev, "%s, Version %s, regs_base @ 0x%08x\n",
 		DRV_DESC, DRV_VERSION, spi_regs_base);
 	return status;
@@ -1337,7 +1347,7 @@ static int __devexit bfin5xx_spi_remove(struct platform_device *pdev)
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
-	setup_pin_mux(0);
+	setup_pin_mux(0, drv_data->master->bus_num);
 
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
-- 
1.5.3.4
