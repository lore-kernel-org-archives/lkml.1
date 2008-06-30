Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYF3Xxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYF3Xxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYF3XxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:53:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:29435 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbYF3XxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:53:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,729,1204531200"; 
   d="scan'208";a="347303416"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/5 V2] MMC: wbsd.c fix shadowing of 'dma' variable
Date: Tue,  1 Jul 2008 02:53:01 +0300
Message-Id: <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix warning :shadowing dma variable
and made use of module_param_named instead of module_param

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/host/wbsd.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 67e5a9b..9dffe5f 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -68,16 +68,16 @@ static const int unlock_codes[] = { 0x83, 0x87 };
 
 static const int valid_ids[] = {
 	0x7112,
-	};
+};
 
 #ifdef CONFIG_PNP
-static unsigned int nopnp = 0;
+static unsigned int param_nopnp = 0;
 #else
-static const unsigned int nopnp = 1;
+static const unsigned int param_nopnp = 1;
 #endif
-static unsigned int io = 0x248;
-static unsigned int irq = 6;
-static int dma = 2;
+static unsigned int param_io = 0x248;
+static unsigned int param_irq = 6;
+static int param_dma = 2;
 
 /*
  * Basic functions
@@ -1765,7 +1765,7 @@ static void __devexit wbsd_shutdown(struct device *dev, int pnp)
 static int __devinit wbsd_probe(struct platform_device *dev)
 {
 	/* Use the module parameters for resources */
-	return wbsd_init(&dev->dev, io, irq, dma, 0);
+	return wbsd_init(&dev->dev, param_io, param_irq, param_dma, 0);
 }
 
 static int __devexit wbsd_remove(struct platform_device *dev)
@@ -1979,14 +1979,14 @@ static int __init wbsd_drv_init(void)
 
 #ifdef CONFIG_PNP
 
-	if (!nopnp) {
+	if (!param_nopnp) {
 		result = pnp_register_driver(&wbsd_pnp_driver);
 		if (result < 0)
 			return result;
 	}
 #endif /* CONFIG_PNP */
 
-	if (nopnp) {
+	if (param_nopnp) {
 		result = platform_driver_register(&wbsd_driver);
 		if (result < 0)
 			return result;
@@ -2012,12 +2012,12 @@ static void __exit wbsd_drv_exit(void)
 {
 #ifdef CONFIG_PNP
 
-	if (!nopnp)
+	if (!param_nopnp)
 		pnp_unregister_driver(&wbsd_pnp_driver);
 
 #endif /* CONFIG_PNP */
 
-	if (nopnp) {
+	if (param_nopnp) {
 		platform_device_unregister(wbsd_device);
 
 		platform_driver_unregister(&wbsd_driver);
@@ -2029,15 +2029,11 @@ static void __exit wbsd_drv_exit(void)
 module_init(wbsd_drv_init);
 module_exit(wbsd_drv_exit);
 #ifdef CONFIG_PNP
-module_param(nopnp, uint, 0444);
+module_param_named(nopnp, param_nopnp, uint, 0444);
 #endif
-module_param(io, uint, 0444);
-module_param(irq, uint, 0444);
-module_param(dma, int, 0444);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Pierre Ossman <drzeus@drzeus.cx>");
-MODULE_DESCRIPTION("Winbond W83L51xD SD/MMC card interface driver");
+module_param_named(io, param_io, uint, 0444);
+module_param_named(irq, param_irq, uint, 0444);
+module_param_named(dma, param_dma, int, 0444);
 
 #ifdef CONFIG_PNP
 MODULE_PARM_DESC(nopnp, "Scan for device instead of relying on PNP. (default 0)");
@@ -2045,3 +2041,8 @@ MODULE_PARM_DESC(nopnp, "Scan for device instead of relying on PNP. (default 0)"
 MODULE_PARM_DESC(io, "I/O base to allocate. Must be 8 byte aligned. (default 0x248)");
 MODULE_PARM_DESC(irq, "IRQ to allocate. (default 6)");
 MODULE_PARM_DESC(dma, "DMA channel to allocate. -1 for no DMA. (default 2)");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pierre Ossman <drzeus@drzeus.cx>");
+MODULE_DESCRIPTION("Winbond W83L51xD SD/MMC card interface driver");
+
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

