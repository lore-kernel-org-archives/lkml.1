Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbZAFW1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbZAFW1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbZAFWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:00 -0500
Received: from kroah.org ([198.145.64.141]:51291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755665AbZAFWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/60] macintosh: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:58 -0800
Message-Id: <1231279939-32728-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/macintosh/macio_asic.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index ec9e5f3..6e149f4 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -33,7 +33,7 @@
 
 #undef DEBUG
 
-#define MAX_NODE_NAME_SIZE (BUS_ID_SIZE - 12)
+#define MAX_NODE_NAME_SIZE (20 - 12)
 
 static struct macio_chip      *macio_on_hold;
 
@@ -240,7 +240,7 @@ static void macio_create_fixup_irq(struct macio_dev *dev, int index,
 	if (irq != NO_IRQ) {
 		dev->interrupt[index].start = irq;
 		dev->interrupt[index].flags = IORESOURCE_IRQ;
-		dev->interrupt[index].name = dev->ofdev.dev.bus_id;
+		dev->interrupt[index].name = dev_name(&dev->ofdev.dev);
 	}
 	if (dev->n_interrupts <= index)
 		dev->n_interrupts = index + 1;
@@ -303,7 +303,7 @@ static void macio_setup_interrupts(struct macio_dev *dev)
 			break;
 		res->start = irq;
 		res->flags = IORESOURCE_IRQ;
-		res->name = dev->ofdev.dev.bus_id;
+		res->name = dev_name(&dev->ofdev.dev);
 		if (macio_resource_quirks(np, res, i - 1)) {
 			memset(res, 0, sizeof(struct resource));
 			continue;
@@ -325,7 +325,7 @@ static void macio_setup_resources(struct macio_dev *dev,
 		if (index >= MACIO_DEV_COUNT_RESOURCES)
 			break;
 		*res = r;
-		res->name = dev->ofdev.dev.bus_id;
+		res->name = dev_name(&dev->ofdev.dev);
 
 		if (macio_resource_quirks(np, res, index)) {
 			memset(res, 0, sizeof(struct resource));
@@ -338,7 +338,7 @@ static void macio_setup_resources(struct macio_dev *dev,
 		if (insert_resource(parent_res, res)) {
 			printk(KERN_WARNING "Can't request resource "
 			       "%d for MacIO device %s\n",
-			       index, dev->ofdev.dev.bus_id);
+			       index, dev_name(&dev->ofdev.dev));
 		}
 	}
 	dev->n_resources = index;
@@ -385,8 +385,8 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 
 	/* MacIO itself has a different reg, we use it's PCI base */
 	if (np == chip->of_node) {
-		sprintf(dev->ofdev.dev.bus_id, "%1d.%08x:%.*s",
-			chip->lbus.index,
+		dev_set_name(&dev->ofdev.dev, "%1d.%08x:%.*s",
+			     chip->lbus.index,
 #ifdef CONFIG_PCI
 			(unsigned int)pci_resource_start(chip->lbus.pdev, 0),
 #else
@@ -395,9 +395,9 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 			MAX_NODE_NAME_SIZE, np->name);
 	} else {
 		reg = of_get_property(np, "reg", NULL);
-		sprintf(dev->ofdev.dev.bus_id, "%1d.%08x:%.*s",
-			chip->lbus.index,
-			reg ? *reg : 0, MAX_NODE_NAME_SIZE, np->name);
+		dev_set_name(&dev->ofdev.dev, "%1d.%08x:%.*s",
+			     chip->lbus.index,
+			     reg ? *reg : 0, MAX_NODE_NAME_SIZE, np->name);
 	}
 
 	/* Setup interrupts & resources */
@@ -408,7 +408,7 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 	/* Register with core */
 	if (of_device_register(&dev->ofdev) != 0) {
 		printk(KERN_DEBUG"macio: device registration error for %s!\n",
-		       dev->ofdev.dev.bus_id);
+		       dev_name(&dev->ofdev.dev));
 		kfree(dev);
 		return NULL;
 	}
@@ -558,7 +558,7 @@ err_out:
 		resource_no,
 		macio_resource_len(dev, resource_no),
 		macio_resource_start(dev, resource_no),
-		dev->ofdev.dev.bus_id);
+		dev_name(&dev->ofdev.dev));
 	return -EBUSY;
 }
 
-- 
1.6.0.4

