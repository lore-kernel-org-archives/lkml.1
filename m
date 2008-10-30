Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYJ3OwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYJ3OwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbYJ3Ov7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:51:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:37676 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbYJ3Ov6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:51:58 -0400
Subject: ssb: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 15:51:57 +0100
Message-Id: <1225378317.21973.1.camel@nga.site>
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
Subject: ssb: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Michael Buesch <mb@bu3sch.de>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 0ffabf5..65a1ed9 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -226,7 +226,7 @@ int ssb_devices_freeze(struct ssb_bus *bus)
 		err = drv->suspend(dev, state);
 		if (err) {
 			ssb_printk(KERN_ERR PFX "Failed to freeze device %s\n",
-				   dev->dev->bus_id);
+				   dev_name(dev->dev));
 			goto err_unwind;
 		}
 	}
@@ -269,7 +269,7 @@ int ssb_devices_thaw(struct ssb_bus *bus)
 		err = drv->resume(dev);
 		if (err) {
 			ssb_printk(KERN_ERR PFX "Failed to thaw device %s\n",
-				   dev->dev->bus_id);
+				   dev_name(dev->dev));
 		}
 	}
 
@@ -454,8 +454,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
 
 		dev->release = ssb_release_dev;
 		dev->bus = &ssb_bustype;
-		snprintf(dev->bus_id, sizeof(dev->bus_id),
-			 "ssb%u:%d", bus->busnumber, dev_idx);
+		dev_set_name(dev, "ssb%u:%d", bus->busnumber, dev_idx);
 
 		switch (bus->bustype) {
 		case SSB_BUSTYPE_PCI:
@@ -480,7 +479,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
 		if (err) {
 			ssb_printk(KERN_ERR PFX
 				   "Could not register %s\n",
-				   dev->bus_id);
+				   dev_name(dev));
 			/* Set dev to NULL to not unregister
 			 * dev on error unwinding. */
 			sdev->dev = NULL;
@@ -796,7 +795,7 @@ int ssb_bus_pcibus_register(struct ssb_bus *bus,
 	err = ssb_bus_register(bus, ssb_pci_get_invariants, 0);
 	if (!err) {
 		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "PCI device %s\n", host_pci->dev.bus_id);
+			   "PCI device %s\n", dev_name(&host_pci->dev));
 	}
 
 	return err;
diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrapper.c
index e82db4a..26737a0 100644
--- a/drivers/ssb/pcihost_wrapper.c
+++ b/drivers/ssb/pcihost_wrapper.c
@@ -65,7 +65,7 @@ static int ssb_pcihost_probe(struct pci_dev *dev,
 	err = pci_enable_device(dev);
 	if (err)
 		goto err_kfree_ssb;
-	name = dev->dev.bus_id;
+	name = dev_name(&dev->dev);
 	if (dev->driver && dev->driver->name)
 		name = dev->driver->name;
 	err = pci_request_regions(dev, name);


