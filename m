Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbZBEQzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbZBEQzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbZBEQyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:54:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:27469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZBEQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ERNqjoa8IyuCKVHFDOal5Npn5dLken7JLfidSakAbZXJ+eFRHUUtgGpX+SzHGoM0Ic
         Bf571RsPruuHoz+/JubGUTovO8YLXdfQVLt3XmnaVqLx0x7Vam7A++HR1gMTrbLIfKmR
         ijpbSCa3J11+NczuXIbiTT6TVfsZBO8fkT/rA=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 5/6] mfd: DS1WM: remove clock handling
Date: Thu,  5 Feb 2009 17:53:39 +0100
Message-Id: <1233852820-28549-6-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver requests a clock that usually is supplied by the MFD in which
the DS1WM is contained. Currently, it is impossible for a MFD to register
their clocks with the generic clock API due to different implementations
across architectures.
For now, this patch removes the clock handling from DS1WM altogether,
trusting that the MFD enable/disable functions will switch the clock if
needed. The clock rate is obtained from a new parameter in driver_data.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/w1/masters/ds1wm.c |   22 +++++-----------------
 include/linux/mfd/ds1wm.h  |    1 +
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index f1e6b3d..b982aa6 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -16,7 +16,6 @@
 #include <linux/irq.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
-#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
@@ -93,7 +92,6 @@ struct ds1wm_data {
 	struct mfd_cell	*cell;
 	int		irq;
 	int		active_high;
-	struct clk	*clk;
 	int		slave_present;
 	void		*reset_complete;
 	void		*read_complete;
@@ -216,17 +214,17 @@ static int ds1wm_find_divisor(int gclk)
 
 static void ds1wm_up(struct ds1wm_data *ds1wm_data)
 {
-	int gclk, divisor;
+	int divisor;
+	struct ds1wm_driver_data *plat = ds1wm_data->cell->driver_data;
 
 	if (ds1wm_data->cell->enable)
 		ds1wm_data->cell->enable(ds1wm_data->pdev);
 
-	gclk = clk_get_rate(ds1wm_data->clk);
-	clk_enable(ds1wm_data->clk);
-	divisor = ds1wm_find_divisor(gclk);
+	divisor = ds1wm_find_divisor(plat->clock_rate);
 	if (divisor == 0) {
 		dev_err(&ds1wm_data->pdev->dev,
-			"no suitable divisor for %dHz clock\n", gclk);
+			"no suitable divisor for %dHz clock\n",
+			plat->clock_rate);
 		return;
 	}
 	ds1wm_write_register(ds1wm_data, DS1WM_CLKDIV, divisor);
@@ -247,8 +245,6 @@ static void ds1wm_down(struct ds1wm_data *ds1wm_data)
 
 	if (ds1wm_data->cell->disable)
 		ds1wm_data->cell->disable(ds1wm_data->pdev);
-
-	clk_disable(ds1wm_data->clk);
 }
 
 /* --------------------------------------------------------------------- */
@@ -385,12 +381,6 @@ static int ds1wm_probe(struct platform_device *pdev)
 	if (ret)
 		goto err1;
 
-	ds1wm_data->clk = clk_get(&pdev->dev, "ds1wm");
-	if (IS_ERR(ds1wm_data->clk)) {
-		ret = PTR_ERR(ds1wm_data->clk);
-		goto err2;
-	}
-
 	ds1wm_up(ds1wm_data);
 
 	ds1wm_master.data = (void *)ds1wm_data;
@@ -403,7 +393,6 @@ static int ds1wm_probe(struct platform_device *pdev)
 
 err3:
 	ds1wm_down(ds1wm_data);
-	clk_put(ds1wm_data->clk);
 err2:
 	free_irq(ds1wm_data->irq, ds1wm_data);
 err1:
@@ -443,7 +432,6 @@ static int ds1wm_remove(struct platform_device *pdev)
 
 	w1_remove_master_device(&ds1wm_master);
 	ds1wm_down(ds1wm_data);
-	clk_put(ds1wm_data->clk);
 	free_irq(ds1wm_data->irq, ds1wm_data);
 	iounmap(ds1wm_data->map);
 	kfree(ds1wm_data);
diff --git a/include/linux/mfd/ds1wm.h b/include/linux/mfd/ds1wm.h
index d4898ba..be469a3 100644
--- a/include/linux/mfd/ds1wm.h
+++ b/include/linux/mfd/ds1wm.h
@@ -2,4 +2,5 @@
 
 struct ds1wm_driver_data {
 	int active_high;
+	int clock_rate;
 };
-- 
1.5.6.5

