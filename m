Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbXHVRWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbXHVRWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765676AbXHVRU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:20:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765508AbXHVRUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:20:54 -0400
Message-Id: <20070822170732.371327244@arndb.de>
References: <20070822170124.764128591@arndb.de>
User-Agent: quilt/0.45-1
Date: Wed, 22 Aug 2007 19:01:27 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, Maximilian <maxim@de.ibm.com>,
       Arnd Bergmann <arnd.bergmann@de.ibm.com>
Subject: [patch 3/5] Axonram module modification for latest firmware API changes
Content-Disposition: inline; filename=35766.diff
X-Provags-ID: V01U2FsdGVkX1/NL/RiSTHcDvrFIkqJ4E+SNd6ZQxcB6y4zDSc
 HiCSMUyRckagf9YaamO7XFwj/HfAxeXvGRtbl7pPME7tqEmi3c
 cyiR0+ba60+EIkIXvrlzw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Shchetynin <maxim@de.ibm.com>

Firmware would not deliver two interrupt numbers in device-tree any more
but only one, for correctable ECC, because uncorrectable ECC from now
handles firmware itself.
Changes in the axonram module are necessary because in the old version, if
it is not allowed to fetch the second interrupt number from device-tree,
it interpretes this as an error case and exits.

Signed-off-by: Maximilian <maxim@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
---

Index: linux-2.6/arch/powerpc/sysdev/axonram.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/axonram.c
+++ linux-2.6/arch/powerpc/sysdev/axonram.c
@@ -59,8 +59,7 @@
 struct axon_ram_bank {
 	struct of_device	*device;
 	struct gendisk		*disk;
-	unsigned int		irq_correctable;
-	unsigned int		irq_uncorrectable;
+	unsigned int		irq_id;
 	unsigned long		ph_addr;
 	unsigned long		io_addr;
 	unsigned long		size;
@@ -93,16 +92,9 @@ axon_ram_irq_handler(int irq, void *dev)
 
 	BUG_ON(!bank);
 
-	if (irq == bank->irq_correctable) {
-		dev_err(&device->dev, "Correctable memory error occured\n");
-		bank->ecc_counter++;
-		return IRQ_HANDLED;
-	} else if (irq == bank->irq_uncorrectable) {
-		dev_err(&device->dev, "Uncorrectable memory error occured\n");
-		panic("Critical ECC error on %s", device->node->full_name);
-	}
-
-	return IRQ_NONE;
+	dev_err(&device->dev, "Correctable memory error occured\n");
+	bank->ecc_counter++;
+	return IRQ_HANDLED;
 }
 
 /**
@@ -259,28 +251,18 @@ axon_ram_probe(struct of_device *device,
 	blk_queue_hardsect_size(bank->disk->queue, AXON_RAM_SECTOR_SIZE);
 	add_disk(bank->disk);
 
-	bank->irq_correctable = irq_of_parse_and_map(device->node, 0);
-	bank->irq_uncorrectable = irq_of_parse_and_map(device->node, 1);
-	if ((bank->irq_correctable <= 0) || (bank->irq_uncorrectable <= 0)) {
+	bank->irq_id = irq_of_parse_and_map(device->node, 0);
+	if (bank->irq_id == NO_IRQ) {
 		dev_err(&device->dev, "Cannot access ECC interrupt ID\n");
 		rc = -EFAULT;
 		goto failed;
 	}
 
-	rc = request_irq(bank->irq_correctable, axon_ram_irq_handler,
-			AXON_RAM_IRQ_FLAGS, bank->disk->disk_name, device);
-	if (rc != 0) {
-		dev_err(&device->dev, "Cannot register ECC interrupt handler\n");
-		bank->irq_correctable = bank->irq_uncorrectable = 0;
-		rc = -EFAULT;
-		goto failed;
-	}
-
-	rc = request_irq(bank->irq_uncorrectable, axon_ram_irq_handler,
+	rc = request_irq(bank->irq_id, axon_ram_irq_handler,
 			AXON_RAM_IRQ_FLAGS, bank->disk->disk_name, device);
 	if (rc != 0) {
 		dev_err(&device->dev, "Cannot register ECC interrupt handler\n");
-		bank->irq_uncorrectable = 0;
+		bank->irq_id = NO_IRQ;
 		rc = -EFAULT;
 		goto failed;
 	}
@@ -296,10 +278,8 @@ axon_ram_probe(struct of_device *device,
 
 failed:
 	if (bank != NULL) {
-		if (bank->irq_uncorrectable > 0)
-			free_irq(bank->irq_uncorrectable, device);
-		if (bank->irq_correctable > 0)
-			free_irq(bank->irq_correctable, device);
+		if (bank->irq_id != NO_IRQ)
+			free_irq(bank->irq_id, device);
 		if (bank->disk != NULL) {
 			if (bank->disk->queue != NULL)
 				blk_cleanup_queue(bank->disk->queue);
@@ -329,8 +309,7 @@ axon_ram_remove(struct of_device *device
 	BUG_ON(!bank || !bank->disk);
 
 	device_remove_file(&device->dev, &dev_attr_ecc);
-	free_irq(bank->irq_uncorrectable, device);
-	free_irq(bank->irq_correctable, device);
+	free_irq(bank->irq_id, device);
 	blk_cleanup_queue(bank->disk->queue);
 	unregister_blkdev(bank->disk->major, bank->disk->disk_name);
 	del_gendisk(bank->disk);

--

