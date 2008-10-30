Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYJ3BUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYJ3BUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYJ3BUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:20:02 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:34301 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYJ3BUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:20:00 -0400
Subject: mmc: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:20:00 +0100
Message-Id: <1225329600.5970.72.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: mmc: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Pierre Ossman <drzeus@drzeus.cx>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 0d9b2d6..f210a8e 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -216,8 +216,7 @@ int mmc_add_card(struct mmc_card *card)
 	int ret;
 	const char *type;
 
-	snprintf(card->dev.bus_id, sizeof(card->dev.bus_id),
-		 "%s:%04x", mmc_hostname(card->host), card->rca);
+	dev_set_name(&card->dev, "%s:%04x", mmc_hostname(card->host), card->rca);
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 6da80fd..5e945e6 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -73,8 +73,7 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	if (err)
 		goto free;
 
-	snprintf(host->class_dev.bus_id, BUS_ID_SIZE,
-		 "mmc%d", host->index);
+	dev_set_name(&host->class_dev, "mmc%d", host->index);
 
 	host->parent = dev;
 	host->class_dev.parent = dev;
@@ -121,7 +120,7 @@ int mmc_add_host(struct mmc_host *host)
 	WARN_ON((host->caps & MMC_CAP_SDIO_IRQ) &&
 		!host->ops->enable_sdio_irq);
 
-	led_trigger_register_simple(host->class_dev.bus_id, &host->led);
+	led_trigger_register_simple(dev_name(&host->class_dev), &host->led);
 
 	err = device_add(&host->class_dev);
 	if (err)
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 233d0f9..46284b5 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -239,8 +239,7 @@ int sdio_add_func(struct sdio_func *func)
 {
 	int ret;
 
-	snprintf(func->dev.bus_id, sizeof(func->dev.bus_id),
-		 "%s:%d", mmc_card_id(func->card), func->num);
+	dev_set_name(&func->dev, "%s:%d", mmc_card_id(func->card), func->num);
 
 	ret = device_add(&func->dev);
 	if (ret == 0)
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 07faf54..ad00e16 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1348,7 +1348,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 		goto fail_add_host;
 
 	dev_info(&spi->dev, "SD/MMC host %s%s%s%s%s\n",
-			mmc->class_dev.bus_id,
+			dev_name(&mmc->class_dev),
 			host->dma_dev ? "" : ", no DMA",
 			(host->pdata && host->pdata->get_ro)
 				? "" : ", no WP",
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 30f64b1..4d010a9 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1733,7 +1733,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	mmc_add_host(mmc);
 
 	printk(KERN_INFO "%s: SDHCI controller on %s [%s] using %s%s\n",
-		mmc_hostname(mmc), host->hw_name, mmc_dev(mmc)->bus_id,
+		mmc_hostname(mmc), host->hw_name, dev_name(mmc_dev(mmc)),
 		(host->flags & SDHCI_USE_ADMA)?"A":"",
 		(host->flags & SDHCI_USE_DMA)?"DMA":"PIO");
 
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 1384484..82554dd 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -632,7 +632,7 @@ static void tifm_sd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	if (host->req) {
 		printk(KERN_ERR "%s : unfinished request detected\n",
-		       sock->dev.bus_id);
+		       dev_name(&sock->dev));
 		mrq->cmd->error = -ETIMEDOUT;
 		goto err_out;
 	}
@@ -672,7 +672,7 @@ static void tifm_sd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 					    ? PCI_DMA_TODEVICE
 					    : PCI_DMA_FROMDEVICE)) {
 				printk(KERN_ERR "%s : scatterlist map failed\n",
-				       sock->dev.bus_id);
+				       dev_name(&sock->dev));
 				mrq->cmd->error = -ENOMEM;
 				goto err_out;
 			}
@@ -684,7 +684,7 @@ static void tifm_sd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 						   : PCI_DMA_FROMDEVICE);
 			if (host->sg_len < 1) {
 				printk(KERN_ERR "%s : scatterlist map failed\n",
-				       sock->dev.bus_id);
+				       dev_name(&sock->dev));
 				tifm_unmap_sg(sock, &host->bounce_buf, 1,
 					      r_data->flags & MMC_DATA_WRITE
 					      ? PCI_DMA_TODEVICE
@@ -748,7 +748,7 @@ static void tifm_sd_end_cmd(unsigned long data)
 
 	if (!mrq) {
 		printk(KERN_ERR " %s : no request to complete?\n",
-		       sock->dev.bus_id);
+		       dev_name(&sock->dev));
 		spin_unlock_irqrestore(&sock->lock, flags);
 		return;
 	}
@@ -789,7 +789,7 @@ static void tifm_sd_abort(unsigned long data)
 	printk(KERN_ERR
 	       "%s : card failed to respond for a long period of time "
 	       "(%x, %x)\n",
-	       host->dev->dev.bus_id, host->req->cmd->opcode, host->cmd_flags);
+	       dev_name(&host->dev->dev), host->req->cmd->opcode, host->cmd_flags);
 
 	tifm_eject(host->dev);
 }
@@ -906,7 +906,7 @@ static int tifm_sd_initialize_host(struct tifm_sd *host)
 
 	if (rc) {
 		printk(KERN_ERR "%s : controller failed to reset\n",
-		       sock->dev.bus_id);
+		       dev_name(&sock->dev));
 		return -ENODEV;
 	}
 
@@ -933,7 +933,7 @@ static int tifm_sd_initialize_host(struct tifm_sd *host)
 	if (rc) {
 		printk(KERN_ERR
 		       "%s : card not ready - probe failed on initialization\n",
-		       sock->dev.bus_id);
+		       dev_name(&sock->dev));
 		return -ENODEV;
 	}
 
@@ -954,7 +954,7 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 	if (!(TIFM_SOCK_STATE_OCCUPIED
 	      & readl(sock->addr + SOCK_PRESENT_STATE))) {
 		printk(KERN_WARNING "%s : card gone, unexpectedly\n",
-		       sock->dev.bus_id);
+		       dev_name(&sock->dev));
 		return rc;
 	}
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index ee6e822..403aa50 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -130,7 +130,7 @@ struct mmc_card {
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 
 #define mmc_card_name(c)	((c)->cid.prod_name)
-#define mmc_card_id(c)		((c)->dev.bus_id)
+#define mmc_card_id(c)		(dev_name(&(c)->dev))
 
 #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
 #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index bde891f..f842f23 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -176,7 +176,7 @@ static inline void *mmc_priv(struct mmc_host *host)
 
 #define mmc_dev(x)	((x)->parent)
 #define mmc_classdev(x)	(&(x)->class_dev)
-#define mmc_hostname(x)	((x)->class_dev.bus_id)
+#define mmc_hostname(x)	(dev_name(&(x)->class_dev))
 
 extern int mmc_suspend_host(struct mmc_host *, pm_message_t);
 extern int mmc_resume_host(struct mmc_host *);
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 07bee4a..451bdfc 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -63,7 +63,7 @@ struct sdio_func {
 
 #define sdio_func_set_present(f) ((f)->state |= SDIO_STATE_PRESENT)
 
-#define sdio_func_id(f)		((f)->dev.bus_id)
+#define sdio_func_id(f)		(dev_name(&(f)->dev))
 
 #define sdio_get_drvdata(f)	dev_get_drvdata(&(f)->dev)
 #define sdio_set_drvdata(f,d)	dev_set_drvdata(&(f)->dev, d)


