Return-Path: <linux-kernel-owner+w=401wt.eu-S1945992AbXEAWBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945992AbXEAWBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946012AbXEAWBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:01:08 -0400
Received: from dns1.vpop.net ([216.193.240.2]:60733 "EHLO mail.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945992AbXEAWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:01:07 -0400
From: Matt Reimer <mreimer@vpop.net>
To: linux-kernel@vger.kernel.org
Cc: Matt Reimer <mreimer@vpop.net>
Subject: [PATCH 1/2] ds1wm: simplify platform_data
Date: Tue,  1 May 2007 15:00:55 -0700
Message-Id: <1178056856620-git-send-email-mreimer@vpop.net>
X-Mailer: git-send-email 1.5.1.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify ds1wm's platform_data by using IORESOURCE_IRQ_* flags rather
than the platform_data field active_high.

Signed-off-by: Matt Reimer <mreimer@vpop.net>
---
 drivers/w1/masters/ds1wm.c |   11 +++++++----
 include/linux/ds1wm.h      |    1 -
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index c3ea34d..8b08609 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -90,6 +90,7 @@ struct ds1wm_data {
 	struct platform_device *pdev;
 	struct ds1wm_platform_data *pdata;
 	int		irq;
+	int		active_high;
 	struct clk	*clk;
 	int		slave_present;
 	void		*reset_complete;
@@ -141,7 +142,7 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 	ds1wm_data->reset_complete = &reset_done;
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, DS1WM_INTEN_EPD |
-		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
+		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
 
 	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_1W_RESET);
 
@@ -163,7 +164,7 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
-		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
+		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
 
 	if (!ds1wm_data->slave_present) {
                 dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
@@ -356,9 +357,11 @@ static int ds1wm_probe(struct platform_device *pdev)
 		goto err1;
 	}
 	ds1wm_data->irq = res->start;
+	ds1wm_data->active_high = (res->flags & IORESOURCE_IRQ_HIGHEDGE) ?
+		1 : 0;
 
-	set_irq_type(ds1wm_data->irq, res->flags & IORESOURCE_IRQ_LOWEDGE ?
-			IRQ_TYPE_EDGE_FALLING : IRQ_TYPE_EDGE_RISING);
+	set_irq_type(ds1wm_data->irq, ds1wm_data->active_high ?
+			IRQ_TYPE_EDGE_RISING : IRQ_TYPE_EDGE_FALLING);
 
 	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
 			  "ds1wm", ds1wm_data);
diff --git a/include/linux/ds1wm.h b/include/linux/ds1wm.h
index feeb64d..31f6e3c 100644
--- a/include/linux/ds1wm.h
+++ b/include/linux/ds1wm.h
@@ -6,7 +6,6 @@ struct ds1wm_platform_data {
 			     * e.g. on h5xxx and h2200 this is 2
 			     * (registers aligned to 4-byte boundaries),
 			     * while on hx4700 this is 1 */
-	int active_high;    /* interrupt polarity, passed to DS1WM as IAS bit */
 	void (*enable)(struct platform_device *pdev);
 	void (*disable)(struct platform_device *pdev);
 };
-- 
1.5.1.1

