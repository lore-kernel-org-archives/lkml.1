Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbYGVFsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbYGVFsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbYGVF1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:27:12 -0400
Received: from mail.suse.de ([195.135.220.2]:54239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462AbYGVF1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:27:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 79/79] arm: bus_id -> dev_name() and dev_set_name() conversions
Date: Mon, 21 Jul 2008 22:19:43 -0700
Message-Id: <1216703983-21448-79-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/common/locomo.c         |    2 +-
 arch/arm/common/sa1111.c         |    7 +++----
 arch/arm/common/scoop.c          |    2 +-
 arch/arm/kernel/ecard.c          |    2 +-
 arch/arm/mach-integrator/impd1.c |    4 +---
 arch/arm/mach-integrator/lm.c    |    6 ++++--
 arch/arm/plat-omap/mailbox.c     |    2 +-
 drivers/net/arm/at91_ether.c     |    2 +-
 drivers/net/arm/ep93xx_eth.c     |    2 +-
 drivers/net/arm/etherh.c         |    6 +++---
 10 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index d973c98..c3c3a33 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -543,7 +543,6 @@ locomo_init_one_child(struct locomo *lchip, struct locomo_dev_info *info)
 		goto out;
 	}
 
-	strncpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id));
 	/*
 	 * If the parent device has a DMA mask associated with it,
 	 * propagate it down to the children.
@@ -553,6 +552,7 @@ locomo_init_one_child(struct locomo *lchip, struct locomo_dev_info *info)
 		dev->dev.dma_mask = &dev->dma_mask;
 	}
 
+	dev_set_name(&dev->dev, "%s", info->name);
 	dev->devid	 = info->devid;
 	dev->dev.parent  = lchip->dev;
 	dev->dev.bus     = &locomo_bus_type;
diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index 2048ae0..c8e8f0e 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -550,9 +550,7 @@ sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
 		goto out;
 	}
 
-	snprintf(dev->dev.bus_id, sizeof(dev->dev.bus_id),
-		 "%4.4lx", info->offset);
-
+	dev_set_name(&dev->dev, "%4.4lx", info->offset);
 	dev->devid	 = info->devid;
 	dev->dev.parent  = sachip->dev;
 	dev->dev.bus     = &sa1111_bus_type;
@@ -560,7 +558,7 @@ sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
 	dev->dev.coherent_dma_mask = sachip->dev->coherent_dma_mask;
 	dev->res.start   = sachip->phys + info->offset;
 	dev->res.end     = dev->res.start + 511;
-	dev->res.name    = dev->dev.bus_id;
+	dev->res.name    = dev_name(&dev->dev);
 	dev->res.flags   = IORESOURCE_MEM;
 	dev->mapbase     = sachip->base + info->offset;
 	dev->skpcr_mask  = info->skpcr_mask;
@@ -570,6 +568,7 @@ sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
 	if (ret) {
 		printk("SA1111: failed to allocate resource for %s\n",
 			dev->res.name);
+		dev_set_name(&dev->dev, NULL);
 		kfree(dev);
 		goto out;
 	}
diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index bc299b0..ae39553 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -247,7 +247,7 @@ static int __devinit scoop_probe(struct platform_device *pdev)
 	devptr->gpio.base = -1;
 
 	if (inf->gpio_base != 0) {
-		devptr->gpio.label = pdev->dev.bus_id;
+		devptr->gpio.label = dev_name(&pdev->dev);
 		devptr->gpio.base = inf->gpio_base;
 		devptr->gpio.ngpio = 12; /* PA11 = 0, PA12 = 1, etc. up to PA22 = 11 */
 		devptr->gpio.set = scoop_gpio_set;
diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index 2de425f..f5cfdab 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -783,7 +783,7 @@ static void ecard_proc_init(void)
 
 #define ec_set_resource(ec,nr,st,sz)				\
 	do {							\
-		(ec)->resource[nr].name = ec->dev.bus_id;	\
+		(ec)->resource[nr].name = dev_name(&ec->dev);	\
 		(ec)->resource[nr].start = st;			\
 		(ec)->resource[nr].end = (st) + (sz) - 1;	\
 		(ec)->resource[nr].flags = IORESOURCE_MEM;	\
diff --git a/arch/arm/mach-integrator/impd1.c b/arch/arm/mach-integrator/impd1.c
index 619d05e..5a1588c 100644
--- a/arch/arm/mach-integrator/impd1.c
+++ b/arch/arm/mach-integrator/impd1.c
@@ -393,9 +393,7 @@ static int impd1_probe(struct lm_device *dev)
 		if (!d)
 			continue;
 
-		snprintf(d->dev.bus_id, sizeof(d->dev.bus_id),
-			 "lm%x:%5.5lx", dev->id, idev->offset >> 12);
-
+		dev_set_name(&d->dev, "lm%x:%5.5lx", dev->id, idev->offset >> 12);
 		d->dev.parent	= &dev->dev;
 		d->res.start	= dev->resource.start + idev->offset;
 		d->res.end	= d->res.start + SZ_4K - 1;
diff --git a/arch/arm/mach-integrator/lm.c b/arch/arm/mach-integrator/lm.c
index 622cdc4..f939c50 100644
--- a/arch/arm/mach-integrator/lm.c
+++ b/arch/arm/mach-integrator/lm.c
@@ -81,8 +81,10 @@ int lm_device_register(struct lm_device *dev)
 	dev->dev.release = lm_device_release;
 	dev->dev.bus = &lm_bustype;
 
-	snprintf(dev->dev.bus_id, sizeof(dev->dev.bus_id), "lm%d", dev->id);
-	dev->resource.name = dev->dev.bus_id;
+	ret = dev_set_name(&dev->dev, "lm%d", dev->id);
+	if (ret)
+		return ret;
+	dev->resource.name = dev_name(&dev->dev);
 
 	ret = request_resource(&iomem_resource, &dev->resource);
 	if (ret == 0) {
diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 848fdca..ff1413e 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -334,7 +334,7 @@ static int omap_mbox_init(struct omap_mbox *mbox)
 	}
 
 	mbox->dev.class = &omap_mbox_class;
-	strlcpy(mbox->dev.bus_id, mbox->name, BUS_ID_SIZE);
+	dev_set_name(&mbox->dev, "%s", mbox->name);
 	dev_set_drvdata(&mbox->dev, mbox);
 
 	ret = device_register(&mbox->dev);
diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
index 1e39e78..71f7cec 100644
--- a/drivers/net/arm/at91_ether.c
+++ b/drivers/net/arm/at91_ether.c
@@ -677,7 +677,7 @@ static void at91ether_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
 	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev->dev.parent->bus_id, sizeof(info->bus_info));
+	strlcpy(info->bus_info, dev_name(dev->dev.parent), sizeof(info->bus_info));
 }
 
 static const struct ethtool_ops at91ether_ethtool_ops = {
diff --git a/drivers/net/arm/ep93xx_eth.c b/drivers/net/arm/ep93xx_eth.c
index ecd8fc6..7a14980 100644
--- a/drivers/net/arm/ep93xx_eth.c
+++ b/drivers/net/arm/ep93xx_eth.c
@@ -848,7 +848,7 @@ static int ep93xx_eth_probe(struct platform_device *pdev)
 
 	ep->res = request_mem_region(pdev->resource[0].start,
 			pdev->resource[0].end - pdev->resource[0].start + 1,
-			pdev->dev.bus_id);
+			dev_name(&pdev->dev));
 	if (ep->res == NULL) {
 		dev_err(&pdev->dev, "Could not reserve memory region\n");
 		err = -ENOMEM;
diff --git a/drivers/net/arm/etherh.c b/drivers/net/arm/etherh.c
index e9d15ec..5c5f1e4 100644
--- a/drivers/net/arm/etherh.c
+++ b/drivers/net/arm/etherh.c
@@ -535,7 +535,7 @@ static int __init etherh_addr(char *addr, struct expansion_card *ec)
 	
 	if (!ecard_readchunk(&cd, ec, 0xf5, 0)) {
 		printk(KERN_ERR "%s: unable to read podule description string\n",
-		       ec->dev.bus_id);
+		       dev_name(&ec->dev));
 		goto no_addr;
 	}
 
@@ -554,7 +554,7 @@ static int __init etherh_addr(char *addr, struct expansion_card *ec)
 	}
 
 	printk(KERN_ERR "%s: unable to parse MAC address: %s\n",
-	       ec->dev.bus_id, cd.d.string);
+	       dev_name(&ec->dev), cd.d.string);
 
  no_addr:
 	return -ENODEV;
@@ -585,7 +585,7 @@ static void etherh_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *i
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
 	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, dev->dev.parent->bus_id,
+	strlcpy(info->bus_info, dev_name(dev->dev.parent),
 		sizeof(info->bus_info));
 }
 
-- 
1.5.6.3

