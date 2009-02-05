Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbZBEQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbZBEQyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbZBEQxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:53:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:27469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbZBEQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HylMZWr8Ur/Tpkkwk3bPVTnVpGPQiqpkTBOFY3BImEUEGVC+noMu7A9ILecSBjz21q
         sItlNBcB+t0nct0b/6x4Sp+RE6IUjQ4A82Tolk6VY4JiP9nJnwHu4y3pDpPQE0GxavrE
         a6QfpANFiTnocbH0eSgJTUVHyPOpcfWsEvReQ=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/6] mfd: DS1WM: convert to use MFD core
Date: Thu,  5 Feb 2009 17:53:35 +0100
Message-Id: <1233852820-28549-2-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the DS1WM driver into an MFD cell. It also
calculates the bus_shift parameter from the memory resource size.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/w1/masters/ds1wm.c |   31 ++++++++++++++++++++-----------
 include/linux/ds1wm.h      |   12 ------------
 include/linux/mfd/ds1wm.h  |    5 +++++
 3 files changed, 25 insertions(+), 23 deletions(-)
 delete mode 100644 include/linux/ds1wm.h
 create mode 100644 include/linux/mfd/ds1wm.h

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 29e144f..f1e6b3d 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -19,7 +19,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/delay.h>
-#include <linux/ds1wm.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/ds1wm.h>
 
 #include <asm/io.h>
 
@@ -89,7 +90,7 @@ struct ds1wm_data {
 	void		__iomem *map;
 	int		bus_shift; /* # of shifts to calc register offsets */
 	struct platform_device *pdev;
-	struct ds1wm_platform_data *pdata;
+	struct mfd_cell	*cell;
 	int		irq;
 	int		active_high;
 	struct clk	*clk;
@@ -217,8 +218,8 @@ static void ds1wm_up(struct ds1wm_data *ds1wm_data)
 {
 	int gclk, divisor;
 
-	if (ds1wm_data->pdata->enable)
-		ds1wm_data->pdata->enable(ds1wm_data->pdev);
+	if (ds1wm_data->cell->enable)
+		ds1wm_data->cell->enable(ds1wm_data->pdev);
 
 	gclk = clk_get_rate(ds1wm_data->clk);
 	clk_enable(ds1wm_data->clk);
@@ -244,8 +245,8 @@ static void ds1wm_down(struct ds1wm_data *ds1wm_data)
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 			     ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0);
 
-	if (ds1wm_data->pdata->disable)
-		ds1wm_data->pdata->disable(ds1wm_data->pdev);
+	if (ds1wm_data->cell->disable)
+		ds1wm_data->cell->disable(ds1wm_data->pdev);
 
 	clk_disable(ds1wm_data->clk);
 }
@@ -330,13 +331,18 @@ static struct w1_bus_master ds1wm_master = {
 static int ds1wm_probe(struct platform_device *pdev)
 {
 	struct ds1wm_data *ds1wm_data;
-	struct ds1wm_platform_data *plat;
+	struct ds1wm_driver_data *plat;
 	struct resource *res;
+	struct mfd_cell *cell;
 	int ret;
 
 	if (!pdev)
 		return -ENODEV;
 
+	cell = pdev->dev.platform_data;
+	if (!cell)
+		return -ENODEV;
+
 	ds1wm_data = kzalloc(sizeof(*ds1wm_data), GFP_KERNEL);
 	if (!ds1wm_data)
 		return -ENOMEM;
@@ -348,15 +354,18 @@ static int ds1wm_probe(struct platform_device *pdev)
 		ret = -ENXIO;
 		goto err0;
 	}
-	ds1wm_data->map = ioremap(res->start, res->end - res->start + 1);
+	ds1wm_data->map = ioremap(res->start, resource_size(res));
 	if (!ds1wm_data->map) {
 		ret = -ENOMEM;
 		goto err0;
 	}
-	plat = pdev->dev.platform_data;
-	ds1wm_data->bus_shift = plat->bus_shift;
+	plat = cell->driver_data;
+
+	/* calculate bus shift from mem resource */
+	ds1wm_data->bus_shift = resource_size(res) >> 3;
+
 	ds1wm_data->pdev = pdev;
-	ds1wm_data->pdata = plat;
+	ds1wm_data->cell = cell;
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
diff --git a/include/linux/ds1wm.h b/include/linux/ds1wm.h
deleted file mode 100644
index d3c65e4..0000000
--- a/include/linux/ds1wm.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* platform data for the DS1WM driver */
-
-struct ds1wm_platform_data {
-	int bus_shift;	    /* number of shifts needed to calculate the
-			     * offset between DS1WM registers;
-			     * e.g. on h5xxx and h2200 this is 2
-			     * (registers aligned to 4-byte boundaries),
-			     * while on hx4700 this is 1 */
-	int active_high;
-	void (*enable)(struct platform_device *pdev);
-	void (*disable)(struct platform_device *pdev);
-};
diff --git a/include/linux/mfd/ds1wm.h b/include/linux/mfd/ds1wm.h
new file mode 100644
index 0000000..d4898ba
--- /dev/null
+++ b/include/linux/mfd/ds1wm.h
@@ -0,0 +1,5 @@
+/* MFD cell driver data for the DS1WM driver */
+
+struct ds1wm_driver_data {
+	int active_high;
+};
-- 
1.5.6.5

