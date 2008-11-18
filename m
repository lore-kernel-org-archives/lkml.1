Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbYKRH60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbYKRH60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYKRH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:56:23 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:65016 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYKRH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:56:20 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62690619"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Yi Li <yi.li@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] Blackfin SPI Driver: implement spi_lock_bus(), spi_unlock_bus() in blackfin spi controller driver.
Date: Tue, 18 Nov 2008 15:57:47 +0800
Message-Id: <1226995067-4484-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226995067-4484-1-git-send-email-cooloney@kernel.org>
References: <1226995067-4484-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |   81 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 0e3102a..28dd0fe 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -45,6 +45,8 @@ MODULE_LICENSE("GPL");
 #define QUEUE_RUNNING	0
 #define QUEUE_STOPPED	1
 
+#define BFIN_SPI_LOCK 1
+
 struct driver_data {
 	/* Driver model hookup */
 	struct platform_device *pdev;
@@ -68,7 +70,10 @@ struct driver_data {
 	struct list_head queue;
 	int busy;
 	int run;
-
+#ifdef BFIN_SPI_LOCK
+	/* SPI bus is lock by a slave for exclusive access */
+	int locked;
+#endif
 	/* Message Transfer pump */
 	struct tasklet_struct pump_transfers;
 
@@ -932,6 +937,10 @@ static void pump_messages(struct work_struct *work)
 {
 	struct driver_data *drv_data;
 	unsigned long flags;
+#ifdef BFIN_SPI_LOCK
+	int locked_cs = -1;
+	struct spi_message *next_msg = NULL, *msg = NULL;
+#endif
 
 	drv_data = container_of(work, struct driver_data, pump_messages);
 
@@ -950,10 +959,35 @@ static void pump_messages(struct work_struct *work)
 		return;
 	}
 
+#ifdef BFIN_SPI_LOCK
+	/* Extract head of queue */
+	next_msg = list_entry(drv_data->queue.next,
+		struct spi_message, queue);
+
+	if (drv_data->locked)
+		locked_cs = drv_data->locked;
+
+	/* Someone has locked the bus */
+	if (drv_data->locked && next_msg->spi->chip_select != locked_cs) {
+		list_for_each_entry(msg, &drv_data->queue, queue) {
+			if (msg->spi->chip_select == locked_cs) {
+				next_msg = msg;
+				break;
+			}
+		}
+		/* Do nothing even if there are messages for other devices */
+		if (next_msg->spi->chip_select != locked_cs) {
+			drv_data->busy = 0;
+			spin_unlock_irqrestore(&drv_data->lock, flags);
+			return;
+		}
+	}
+	drv_data->cur_msg = next_msg;
+#else
 	/* Extract head of queue */
 	drv_data->cur_msg = list_entry(drv_data->queue.next,
-				       struct spi_message, queue);
-
+		struct spi_message, queue);
+#endif
 	/* Setup the SSP using the per chip configuration */
 	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
 	restore_state(drv_data);
@@ -982,6 +1016,39 @@ static void pump_messages(struct work_struct *work)
 }
 
 /*
+ * lock the spi bus for exclusive access
+ */
+static int lock_bus(struct spi_device *spi)
+{
+#ifdef BFIN_SPI_LOCK
+	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+	unsigned long flags;
+
+	spin_lock_irqsave(&drv_data->lock, flags);
+	if (drv_data->locked) {
+		spin_unlock_irqrestore(&drv_data->lock, flags);
+		return -ENOLCK;
+	}
+	drv_data->locked = spi->chip_select;
+	spin_unlock_irqrestore(&drv_data->lock, flags);
+#endif
+	return 0;
+}
+
+static int unlock_bus(struct spi_device *spi)
+{
+#ifdef BFIN_SPI_LOCK
+	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
+	unsigned long flags;
+
+	spin_lock_irqsave(&drv_data->lock, flags);
+	drv_data->locked = 0;
+	spin_unlock_irqrestore(&drv_data->lock, flags);
+#endif
+	return 0;
+}
+
+/*
  * got a msg to transfer, queue it in drv_data->queue.
  * And kick off message pumper
  */
@@ -1188,6 +1255,9 @@ static inline int init_queue(struct driver_data *drv_data)
 	INIT_LIST_HEAD(&drv_data->queue);
 	spin_lock_init(&drv_data->lock);
 
+#ifdef BFIN_SPI_LOCK
+	drv_data->locked = 0;
+#endif
 	drv_data->run = QUEUE_STOPPED;
 	drv_data->busy = 0;
 
@@ -1235,6 +1305,9 @@ static inline int stop_queue(struct driver_data *drv_data)
 
 	spin_lock_irqsave(&drv_data->lock, flags);
 
+#ifdef BFIN_SPI_LOCK
+	drv_data->locked = 0;
+#endif
 	/*
 	 * This is a bit lame, but is optimized for the common execution path.
 	 * A wait_queue on the drv_data->busy could be used, but then the common
@@ -1298,6 +1371,8 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
 	master->cleanup = cleanup;
 	master->setup = setup;
 	master->transfer = transfer;
+	master->lock_bus = lock_bus;
+	master->unlock_bus = unlock_bus;
 
 	/* Find and map our resources */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.5.6.3
