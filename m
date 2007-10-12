Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbXJLDGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbXJLDGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXJLDFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:05:18 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36798 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbXJLDFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:05:12 -0400
X-IronPort-AV: i="4.21,263,1188792000"; 
   d="scan'208"; a="41596815:sNHT33432035"
From: Bryan Wu <bryan.wu@analog.com>
To: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 01/10] Blackfin SPI driver: Initial supporting BF54x in SPI driver
Date: Fri, 12 Oct 2007 11:04:55 +0800
Message-Id: <1192158304-8277-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - support BF54x SPI0
 - clean up some code
 - will support multiports in the future

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c                       |  130 +++++++++++------------
 include/asm-blackfin/mach-bf548/defBF54x_base.h |   17 +++
 2 files changed, 80 insertions(+), 67 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index f540ed7..2992ada 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1,17 +1,20 @@
 /*
- * File:         drivers/spi/bfin5xx_spi.c
- * Based on:     N/A
- * Author:       Luke Yang (Analog Devices Inc.)
+ * File:	drivers/spi/bfin5xx_spi.c
+ * Maintainer:
+ * 		Bryan Wu <bryan.wu@analog.com>
+ * Original Author:
+ * 		Luke Yang (Analog Devices Inc.)
  *
- * Created:      March. 10th 2006
- * Description:  SPI controller driver for Blackfin 5xx
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ * Created:	March. 10th 2006
+ * Description:	SPI controller driver for Blackfin BF5xx
+ * Bugs:	Enter bugs at http://blackfin.uclinux.org/
  *
  * Modified:
  *	March 10, 2006  bfin5xx_spi.c Created. (Luke Yang)
  *      August 7, 2006  added full duplex mode (Axel Weiss & Luke Yang)
+ *      July  17, 2007  add support for BF54x SPI0 controller (Bryan Wu)
  *
- * Copyright 2004-2006 Analog Devices Inc.
+ * Copyright 2004-2007 Analog Devices Inc.
  *
  * This program is free software ;  you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -31,28 +34,27 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/io.h>
 #include <linux/ioport.h>
+#include <linux/irq.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
-#include <linux/errno.h>
-#include <linux/delay.h>
 
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/delay.h>
 #include <asm/dma.h>
-
+#include <asm/portmux.h>
 #include <asm/bfin5xx_spi.h>
 
-MODULE_AUTHOR("Luke Yang");
-MODULE_DESCRIPTION("Blackfin 5xx SPI Contoller");
+MODULE_AUTHOR("Bryan Wu, Luke Yang");
+MODULE_DESCRIPTION("Blackfin BF5xx SPI Contoller Driver");
 MODULE_LICENSE("GPL");
 
+#define DRV_NAME	"bfin-spi-master"
 #define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
 
 #define DEFINE_SPI_REG(reg, off) \
@@ -125,6 +127,7 @@ struct chip_data {
 	u16 flag;
 
 	u8 chip_select_num;
+	u8 chip_select_requested;
 	u8 n_bytes;
 	u8 width;		/* 0 or 1 */
 	u8 enable_dma;
@@ -189,53 +192,37 @@ static void restore_state(struct driver_data *drv_data)
 	bfin_spi_disable(drv_data);
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
-#if defined(CONFIG_BF534) || defined(CONFIG_BF536) || defined(CONFIG_BF537)
-	dev_dbg(&drv_data->pdev->dev, 
-		"chip select number is %d\n", chip->chip_select_num);
-	
-	switch (chip->chip_select_num) {
-	case 1:
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3c00);
-		SSYNC();
-		break;
-
-	case 2:
-	case 3:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJSE_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
-		SSYNC();
-		break;
-
-	case 4:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS4E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3840);
-		SSYNC();
-		break;
+	if (!chip->chip_select_requested) {
 
-	case 5:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS5E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3820);
-		SSYNC();
-		break;
+		dev_dbg(&drv_data->pdev->dev,
+		"chip select number is %d\n", chip->chip_select_num);
 
-	case 6:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS6E_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3810);
-		SSYNC();
-		break;
+		switch (chip->chip_select_num) {
+		case 1:
+			peripheral_request(P_SPI0_SSEL1, DRV_NAME);
+			break;
+		case 2:
+			peripheral_request(P_SPI0_SSEL2, DRV_NAME);
+			break;
+		case 3:
+			peripheral_request(P_SPI0_SSEL3, DRV_NAME);
+			break;
+		case 4:
+			peripheral_request(P_SPI0_SSEL4, DRV_NAME);
+			break;
+		case 5:
+			peripheral_request(P_SPI0_SSEL5, DRV_NAME);
+			break;
+		case 6:
+			peripheral_request(P_SPI0_SSEL6, DRV_NAME);
+			break;
+		case 7:
+			peripheral_request(P_SPI0_SSEL7, DRV_NAME);
+			break;
+		}
 
-	case 7:
-		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJCE_SPI);
-		SSYNC();
-		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
-		SSYNC();
-		break;
+		chip->chip_select_requested = 1;
 	}
-#endif
 
 	/* Load the registers */
 	write_CTRL(chip->ctl_reg);
@@ -278,7 +265,7 @@ static void null_reader(struct driver_data *drv_data)
 
 static void u8_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr8-s is 0x%x\n", read_STAT());
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(*(u8 *) (drv_data->tx));
@@ -317,7 +304,7 @@ static void u8_cs_chg_writer(struct driver_data *drv_data)
 
 static void u8_reader(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr-8 is 0x%x\n", read_STAT());
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
@@ -404,7 +391,7 @@ static void u8_cs_chg_duplex(struct driver_data *drv_data)
 
 static void u16_writer(struct driver_data *drv_data)
 {
-	dev_dbg(&drv_data->pdev->dev, 
+	dev_dbg(&drv_data->pdev->dev,
 		"cr16 is 0x%x\n", read_STAT());
 
 	while (drv_data->tx < drv_data->tx_end) {
@@ -817,7 +804,7 @@ static void pump_transfers(unsigned long data)
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
-			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	
+			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_WRITE | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
 			dev_dbg(&drv_data->pdev->dev,
@@ -835,7 +822,7 @@ static void pump_transfers(unsigned long data)
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_WRITE | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO write: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
@@ -850,7 +837,7 @@ static void pump_transfers(unsigned long data)
 			cr = (read_CTRL() & (~BIT_CTL_TIMOD));
 			cr |= CFG_SPI_READ | (width << 8) |
 				(CFG_SPI_ENABLE << 14);
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO read: cr is 0x%x\n", cr);
 
 			write_CTRL(cr);
@@ -862,7 +849,7 @@ static void pump_transfers(unsigned long data)
 		}
 
 		if (!tranf_success) {
-			dev_dbg(&drv_data->pdev->dev, 
+			dev_dbg(&drv_data->pdev->dev,
 				"IO write error!\n");
 			message->state = ERROR_STATE;
 		} else {
@@ -917,8 +904,8 @@ static void pump_messages(struct work_struct *work)
 		"got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
    		drv_data->cur_chip->baud, drv_data->cur_chip->flag,
    		drv_data->cur_chip->ctl_reg);
-	
-	dev_dbg(&drv_data->pdev->dev, 
+
+	dev_dbg(&drv_data->pdev->dev,
 		"the first transfer len is %d\n",
 		drv_data->cur_transfer->len);
 
@@ -1194,6 +1181,15 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "can not alloc spi_master\n");
 		return -ENOMEM;
 	}
+
+	if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
+		 peripheral_request(P_SPI0_MISO, DRV_NAME) ||
+		 peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
+
+		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
+		goto out_error_queue_alloc;
+	}
+
 	drv_data = spi_master_get_devdata(master);
 	drv_data->master = master;
 	drv_data->master_info = platform_info;
diff --git a/include/asm-blackfin/mach-bf548/defBF54x_base.h b/include/asm-blackfin/mach-bf548/defBF54x_base.h
index 895ddd4..56f0a76 100644
--- a/include/asm-blackfin/mach-bf548/defBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/defBF54x_base.h
@@ -1637,8 +1637,25 @@
 #define                   RESTART  0x20       /* Work Unit Transitions */
 #define                    DI_SEL  0x40       /* Data Interrupt Timing Select */
 #define                     DI_EN  0x80       /* Data Interrupt Enable */
+
 #define                    NDSIZE  0xf00      /* Flex Descriptor Size */
+#define                  NDSIZE_0 0x0000      /* Next Descriptor Size = 0 (Stop/Autobuffer) */
+#define                  NDSIZE_1 0x0100      /* Next Descriptor Size = 1 */
+#define                  NDSIZE_2 0x0200      /* Next Descriptor Size = 2 */
+#define                  NDSIZE_3 0x0300      /* Next Descriptor Size = 3 */
+#define                  NDSIZE_4 0x0400      /* Next Descriptor Size = 4 */
+#define                  NDSIZE_5 0x0500      /* Next Descriptor Size = 5 */
+#define                  NDSIZE_6 0x0600      /* Next Descriptor Size = 6 */
+#define                  NDSIZE_7 0x0700      /* Next Descriptor Size = 7 */
+#define                  NDSIZE_8 0x0800      /* Next Descriptor Size = 8 */
+#define                  NDSIZE_9 0x0900      /* Next Descriptor Size = 9 */
+
 #define                   DMAFLOW  0xf000     /* Next Operation */
+#define              DMAFLOW_STOP  0x0000     /* Stop Mode */
+#define              DMAFLOW_AUTO  0x1000     /* Autobuffer Mode */
+#define             DMAFLOW_ARRAY  0x4000     /* Descriptor Array Mode */
+#define             DMAFLOW_SMALL  0x6000     /* Small Model Descriptor List Mode */
+#define             DMAFLOW_LARGE  0x7000     /* Large Model Descriptor List Mode */
 
 /* Bit masks for DMAx_IRQ_STATUS, MDMA_Sx_IRQ_STATUS, MDMA_Dx_IRQ_STATUS */
 
-- 
1.5.3.4
