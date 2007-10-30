Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbXJ3JTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbXJ3JTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXJ3JSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:18:17 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:20154 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXJ3JSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:18:13 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="42689503:sNHT28846510"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 02/14] Blackfin SPI driver: use new GPIO API and add error handling
Date: Tue, 30 Oct 2007 17:17:53 +0800
Message-Id: <1193735885-8202-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/spi/spi_bfin5xx.c                 |   29 +++++++++++++++++++++++------
 include/asm-blackfin/mach-bf533/portmux.h |    2 +-
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 621a3eb..eeaa65d 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1165,6 +1165,22 @@ static inline int destroy_queue(struct driver_data *drv_data)
 	return 0;
 }
 
+static int setup_pin_mux(int action)
+{
+
+	u16 pin_req[] = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0};
+
+	if (action) {
+		if (peripheral_request_list(pin_req, DRV_NAME)) {
+			return -EFAULT;
+		}
+	} else {
+		peripheral_free_list(pin_req);
+	}
+
+	return 0;
+}
+
 static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1182,12 +1198,9 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
-		 peripheral_request(P_SPI0_MISO, DRV_NAME) ||
-		 peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
-
+	if (setup_pin_mux(1)) {
 		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
-		goto out_error_queue_alloc;
+		goto out_error;
 	}
 
 	drv_data = spi_master_get_devdata(master);
@@ -1223,9 +1236,11 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "controller probe successfully\n");
 	return status;
 
-      out_error_queue_alloc:
+out_error_queue_alloc:
 	destroy_queue(drv_data);
+out_error:
 	spi_master_put(master);
+
 	return status;
 }
 
@@ -1255,6 +1270,8 @@ static int __devexit bfin5xx_spi_remove(struct platform_device *pdev)
 	/* Disconnect from the SPI framework */
 	spi_unregister_master(drv_data->master);
 
+	setup_pin_mux(0);
+
 	/* Prevent double remove */
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/include/asm-blackfin/mach-bf533/portmux.h b/include/asm-blackfin/mach-bf533/portmux.h
index b88d7a0..137f488 100644
--- a/include/asm-blackfin/mach-bf533/portmux.h
+++ b/include/asm-blackfin/mach-bf533/portmux.h
@@ -42,7 +42,7 @@
 #define P_SPORT0_DRPRI	(P_DONTCARE)
 
 #define P_SPI0_MOSI	(P_DONTCARE)
-#define P_SPI0_MIS0	(P_DONTCARE)
+#define P_SPI0_MISO	(P_DONTCARE)
 #define P_SPI0_SCK	(P_DONTCARE)
 #define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(GPIO_PF7))
 #define P_SPI0_SSEL6	(P_DEFINED | P_IDENT(GPIO_PF6))
-- 
1.5.3.4
