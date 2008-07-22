Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbYGVFsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbYGVFsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYGVF1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:27:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:54221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452AbYGVF1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:27:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 78/79] sparc64: fix up bus_id changes in sparc core code
Date: Mon, 21 Jul 2008 22:19:42 -0700
Message-Id: <1216703983-21448-78-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts all instances of bus_id in the sparc core kernel to use
either dev_set_name(), or dev_name() depending on the need.

This is done in anticipation of removing the bus_id field from struct
driver.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc64/kernel/ebus.c      |    4 ++--
 arch/sparc64/kernel/of_device.c |    4 ++--
 arch/sparc64/kernel/pci.c       |    2 +-
 arch/sparc64/kernel/vio.c       |   16 +++++++---------
 drivers/sbus/sbus.c             |    6 +++---
 5 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/sparc64/kernel/ebus.c b/arch/sparc64/kernel/ebus.c
index c49d038..4d58d7c 100644
--- a/arch/sparc64/kernel/ebus.c
+++ b/arch/sparc64/kernel/ebus.c
@@ -401,7 +401,7 @@ static void __init fill_ebus_device(struct device_node *dp, struct linux_ebus_de
 	dev->ofdev.node = dp;
 	dev->ofdev.dev.parent = &dev->bus->ofdev.dev;
 	dev->ofdev.dev.bus = &ebus_bus_type;
-	sprintf(dev->ofdev.dev.bus_id, "ebus[%08x]", dp->node);
+	dev_set_name(&dev->ofdev.dev, "ebus[%08x]", dp->node);
 
 	/* Register with core */
 	if (of_device_register(&dev->ofdev) != 0)
@@ -501,7 +501,7 @@ void __init ebus_init(void)
 		ebus->ofdev.node = dp;
 		ebus->ofdev.dev.parent = &pdev->dev;
 		ebus->ofdev.dev.bus = &ebus_bus_type;
-		sprintf(ebus->ofdev.dev.bus_id, "ebus%d", num_ebus);
+		dev_set_name(&ebus->ofdev.dev, "ebus%d", num_ebus);
 
 		/* Register with core */
 		if (of_device_register(&ebus->ofdev) != 0)
diff --git a/arch/sparc64/kernel/of_device.c b/arch/sparc64/kernel/of_device.c
index d569f60..4fd48ab 100644
--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -797,9 +797,9 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 	op->dev.parent = parent;
 	op->dev.bus = &of_platform_bus_type;
 	if (!parent)
-		strcpy(op->dev.bus_id, "root");
+		dev_set_name(&op->dev, "root");
 	else
-		sprintf(op->dev.bus_id, "%08x", dp->node);
+		dev_set_name(&op->dev, "%08x", dp->node);
 
 	if (of_device_register(op)) {
 		printk("%s: Could not register of device.\n",
diff --git a/arch/sparc64/kernel/pci.c b/arch/sparc64/kernel/pci.c
index d00a365..5509619 100644
--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -408,7 +408,7 @@ struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	dev->class = class >> 8;
 	dev->revision = class & 0xff;
 
-	sprintf(dev->dev.bus_id, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+	dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(bus),
 		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
 	if (ofpci_verbose)
diff --git a/arch/sparc64/kernel/vio.c b/arch/sparc64/kernel/vio.c
index ecbb8b6..a490077 100644
--- a/arch/sparc64/kernel/vio.c
+++ b/arch/sparc64/kernel/vio.c
@@ -260,16 +260,14 @@ static struct vio_dev *vio_create_one(struct mdesc_handle *hp, u64 mp,
 	vio_fill_channel_info(hp, mp, vdev);
 
 	if (!id) {
-		snprintf(vdev->dev.bus_id, BUS_ID_SIZE, "%s",
-			 bus_id_name);
+		dev_set_name(&vdev->dev, "%s", bus_id_name);
 		vdev->dev_no = ~(u64)0;
 	} else if (!cfg_handle) {
-		snprintf(vdev->dev.bus_id, BUS_ID_SIZE, "%s-%lu",
-			 bus_id_name, *id);
+		dev_set_name(&vdev->dev, "%s-%lu", bus_id_name, *id);
 		vdev->dev_no = *id;
 	} else {
-		snprintf(vdev->dev.bus_id, BUS_ID_SIZE, "%s-%lu-%lu",
-			 bus_id_name, *cfg_handle, *id);
+		dev_set_name(&vdev->dev, "%s-%lu-%lu", bus_id_name,
+			     *cfg_handle, *id);
 		vdev->dev_no = *cfg_handle;
 	}
 
@@ -292,12 +290,12 @@ static struct vio_dev *vio_create_one(struct mdesc_handle *hp, u64 mp,
 	}
 	vdev->dp = dp;
 
-	printk(KERN_INFO "VIO: Adding device %s\n", vdev->dev.bus_id);
+	printk(KERN_INFO "VIO: Adding device %s\n", dev_name(&vdev->dev));
 
 	err = device_register(&vdev->dev);
 	if (err) {
 		printk(KERN_ERR "VIO: Could not register device %s, err=%d\n",
-		       vdev->dev.bus_id, err);
+		       dev_name(&vdev->dev), err);
 		kfree(vdev);
 		return NULL;
 	}
@@ -330,7 +328,7 @@ static void vio_remove(struct mdesc_handle *hp, u64 node)
 	dev = device_find_child(&root_vdev->dev, (void *) node,
 				vio_md_node_match);
 	if (dev) {
-		printk(KERN_INFO "VIO: Removing device %s\n", dev->bus_id);
+		printk(KERN_INFO "VIO: Removing device %s\n", dev_name(dev));
 
 		device_unregister(dev);
 	}
diff --git a/drivers/sbus/sbus.c b/drivers/sbus/sbus.c
index c37d7c2..73a86d0 100644
--- a/drivers/sbus/sbus.c
+++ b/drivers/sbus/sbus.c
@@ -78,7 +78,7 @@ static void __init fill_sbus_device(struct device_node *dp, struct sbus_dev *sde
 	else
 		sdev->ofdev.dev.parent = &sdev->bus->ofdev.dev;
 	sdev->ofdev.dev.bus = &sbus_bus_type;
-	sprintf(sdev->ofdev.dev.bus_id, "sbus[%08x]", dp->node);
+	dev_set_name(&sdev->ofdev.dev, "sbus[%08x]", dp->node);
 
 	if (of_device_register(&sdev->ofdev) != 0)
 		printk(KERN_DEBUG "sbus: device registration error for %s!\n",
@@ -257,11 +257,11 @@ static void __init build_one_sbus(struct device_node *dp, int num_sbus)
 	sbus->ofdev.node = dp;
 	sbus->ofdev.dev.parent = NULL;
 	sbus->ofdev.dev.bus = &sbus_bus_type;
-	sprintf(sbus->ofdev.dev.bus_id, "sbus%d", num_sbus);
+	dev_set_name(&sbus->ofdev.dev, "sbus%d", num_sbus);
 
 	if (of_device_register(&sbus->ofdev) != 0)
 		printk(KERN_DEBUG "sbus: device registration error for %s!\n",
-		       sbus->ofdev.dev.bus_id);
+		       dev_name(&sbus->ofdev.dev));
 
 	dev_dp = dp->child;
 	while (dev_dp) {
-- 
1.5.6.3

