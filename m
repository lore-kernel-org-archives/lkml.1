Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbXKBCjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbXKBCjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 22:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbXKBCil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 22:38:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:28878 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbXKBCij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 22:38:39 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="55424473:sNHT299324053"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/4] Blackfin SPI driver:  move hard coded pin_req to board file
Date: Fri,  2 Nov 2007 10:38:31 +0800
Message-Id: <1193971112-7744-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
References: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some sort of bloaty code, try to get these pin_req arrays built at compile-time

 - move this static things to the blackfin board file
 - add pin_req array to struct bfin5xx_spi_master
 - tested on BF537/BF548 with SPI flash

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c          |   28 +++++++---------------------
 include/asm-blackfin/bfin5xx_spi.h |    1 +
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index a6f6d5f..f466fa0 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -80,6 +80,9 @@ struct driver_data {
 	/* Regs base of SPI controller */
 	void __iomem *regs_base;
 
+	/* Pin request list */
+	u16 *pin_req;
+
 	/* BFIN hookup */
 	struct bfin5xx_spi_master *master_info;
 
@@ -1245,25 +1248,6 @@ static inline int destroy_queue(struct driver_data *drv_data)
 	return 0;
 }
 
-static int setup_pin_mux(int action, int bus_num)
-{
-
-	u16 pin_req[3][4] = {
-		{P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
-		{P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0},
-		{P_SPI2_SCK, P_SPI2_MISO, P_SPI2_MOSI, 0},
-	};
-
-	if (action) {
-		if (peripheral_request_list(pin_req[bus_num], DRV_NAME))
-			return -EFAULT;
-	} else {
-		peripheral_free_list(pin_req[bus_num]);
-	}
-
-	return 0;
-}
-
 static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1286,6 +1270,7 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 	drv_data->master = master;
 	drv_data->master_info = platform_info;
 	drv_data->pdev = pdev;
+	drv_data->pin_req = platform_info->pin_req;
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
@@ -1336,7 +1321,8 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		goto out_error_queue_alloc;
 	}
 
-	if (setup_pin_mux(1, master->bus_num)) {
+	status = peripheral_request_list(drv_data->pin_req, DRV_NAME);
+	if (status != 0) {
 		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
 		goto out_error;
 	}
@@ -1384,7 +1370,7 @@ static int __devexit bfin5xx_spi_remove(struct platform_device *pdev)
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
-	setup_pin_mux(0, drv_data->master->bus_num);
+	peripheral_free_list(drv_data->pin_req);
 
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
diff --git a/include/asm-blackfin/bfin5xx_spi.h b/include/asm-blackfin/bfin5xx_spi.h
index d4485b3..1a0b57f 100644
--- a/include/asm-blackfin/bfin5xx_spi.h
+++ b/include/asm-blackfin/bfin5xx_spi.h
@@ -152,6 +152,7 @@
 struct bfin5xx_spi_master {
 	u16 num_chipselect;
 	u8 enable_dma;
+	u16 pin_req[4];
 };
 
 /* spi_board_info.controller_data for SPI slave devices,
-- 
1.5.3.4
