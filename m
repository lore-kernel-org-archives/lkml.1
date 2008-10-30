Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYJ3TOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYJ3TOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYJ3TNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:13:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:27851 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbYJ3TNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:13:51 -0400
Subject: virtio: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 20:10:22 +0100
Message-Id: <1225393822.21973.39.camel@nga.site>
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
Subject: virtio: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 5b78fd0..018c070 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -176,7 +176,7 @@ int register_virtio_device(struct virtio_device *dev)
 
 	/* Assign a unique device index and hence name. */
 	dev->index = dev_index++;
-	sprintf(dev->dev.bus_id, "virtio%u", dev->index);
+	dev_set_name(&dev->dev, "virtio%u", dev->index);
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c7dc37c..fbdd219 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -75,7 +75,7 @@ MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
  * would make more sense for virtio to not insist on having it's own device. */
 static struct device virtio_pci_root = {
 	.parent		= NULL,
-	.bus_id		= "virtio-pci",
+	.init_name	= "virtio-pci",
 };
 
 /* Convert a generic virtio device to our structure */
@@ -357,7 +357,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 
 	/* register a handler for the queue with the PCI device's interrupt */
 	err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
-			  vp_dev->vdev.dev.bus_id, vp_dev);
+			  dev_name(&vp_dev->vdev.dev), vp_dev);
 	if (err)
 		goto out_set_drvdata;
 

