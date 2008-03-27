Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYCZK2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYCZK2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757970AbYCZK2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:28:33 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:59263 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbYCZK2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:28:32 -0400
X-IronPort-AV: E=Sophos;i="4.25,557,1199682000"; 
   d="scan'208";a="65082955"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: Vitja Makarov <vitja.makarov@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/3] Blackfin SPI Driver: Fix peripheral pins initialization bug in SPI probe
Date: Wed, 26 Mar 2008 18:28:31 -0700
Message-Id: <1206581312-25869-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitja Makarov <vitja.makarov@gmail.com>

Fix bug in SPI probe: first initialize peripheral pins,
and just after register spi master device. This fixes
problems with SPI drivers built-in kernel.

Singed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index c93c9d6..a4bf3af 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1294,6 +1294,12 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		goto out_error_queue_alloc;
 	}
 
+	status = peripheral_request_list(drv_data->pin_req, DRV_NAME);
+	if (status != 0) {
+		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
+		goto out_error_queue_alloc;
+	}
+
 	/* Register with the SPI framework */
 	platform_set_drvdata(pdev, drv_data);
 	status = spi_register_master(master);
@@ -1302,12 +1308,6 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 		goto out_error_queue_alloc;
 	}
 
-	status = peripheral_request_list(drv_data->pin_req, DRV_NAME);
-	if (status != 0) {
-		dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
-		goto out_error;
-	}
-
 	dev_info(dev, "%s, Version %s, regs_base@%p, dma channel@%d\n",
 		DRV_DESC, DRV_VERSION, drv_data->regs_base,
 		drv_data->dma_channel);
-- 
1.5.4.3
