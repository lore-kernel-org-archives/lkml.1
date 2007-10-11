Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbXJKKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbXJKKN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXJKKK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:10:56 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23115 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbXJKKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:10:50 -0400
X-IronPort-AV: i="4.21,259,1188792000"; 
   d="scan'208"; a="53762407:sNHT27402746"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/9] Blackfin SPI driver: use new GPIO API and add error handling
Date: Thu, 11 Oct 2007 18:10:33 +0800
Message-Id: <1192097441-24962-2-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
References: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
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
index 2992ada..8041b89 100644
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
