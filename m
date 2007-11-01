Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXKAROr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXKAROr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXKAROh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:14:37 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:54537 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXKAROf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:14:35 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: PNP: request ioport and iomem resources used by active devices
Date: Thu, 1 Nov 2007 11:13:05 -0600
User-Agent: KMail/1.9.6
Cc: Adam Belay <ambx1@neo.rr.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011113.05820.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[1] Posting as RFC (one positive response): http://lkml.org/lkml/2007/10/29/412
[2] This should go after rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
    because the RTC driver was one that requested more resources than it needs and fails
    if PNP reports a smaller region.


Reserve resources used by active PNP devices to prevent those resources
from being assigned to other devices.

This can be turned off with the "pnp=no_reservations" flag.  If you need to
use it, please report it, because it indicates a potential problem, like a
driver that requests more resources than it needs.

This is similar to request_standard_resources().  That function requests
resources for a compiled-in list of standard PC devices such as DMA
controllers, PICs, timers, and keyboard, and marks them "busy."  This
patch requests resources for devices that are actually present but does
not mark them "busy."

Sometimes the built-in standard resources are larger than what PNP reports,
or they combine things that PNP reports separately, which makes things look
a little strange, e.g.,

    0000-001f : dma1		<-- built-in resource includes 2 controllers
      0000-000f : 00:02		<-- PNP reports only one DMA controller
    0020-0021 : pic1
    002e-002f : 00:06
    0040-0043 : timer0
    0050-0053 : timer1
    0060-006f : keyboard	<-- built-in resource groups several things
      0060-0060 : 00:04		<-- PNP reports 8042 controller data register
      0061-0061 : 00:03		<-- PNP reports AT-style speaker
      0064-0064 : 00:04		<-- PNP reports 8042 controller status register
    0070-0073 : 00:06
      0070-0071 : rtc

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/Documentation/kernel-parameters.txt
===================================================================
--- w.orig/Documentation/kernel-parameters.txt	2007-11-01 11:09:32.000000000 -0600
+++ w/Documentation/kernel-parameters.txt	2007-11-01 11:09:41.000000000 -0600
@@ -1405,6 +1405,14 @@
 			Format: { parport<nr> | timid | 0 }
 			See also Documentation/parport.txt.
 
+	pnp=		[PNP] PNP subsystem options:
+		no_reservations	Don't reserve resources used by PNP devices
+				This is for working around problems where a
+				driver uses a PNP device without using the PNP
+				core.  Typical symptom is that the driver can't
+				reserve the resources it needs.  Please report
+				these issues.
+
 	pnpacpi=	[ACPI]
 			{ off }
 
Index: w/drivers/pnp/base.h
===================================================================
--- w.orig/drivers/pnp/base.h	2007-11-01 11:08:28.000000000 -0600
+++ w/drivers/pnp/base.h	2007-11-01 11:09:41.000000000 -0600
@@ -5,6 +5,8 @@
 void pnp_free_option(struct pnp_option *option);
 int __pnp_add_device(struct pnp_dev *dev);
 void __pnp_remove_device(struct pnp_dev *dev);
+int pnp_request_resources(struct pnp_dev *dev);
+int pnp_release_resources(struct pnp_dev *dev);
 
 int pnp_check_port(struct pnp_dev * dev, int idx);
 int pnp_check_mem(struct pnp_dev * dev, int idx);
Index: w/drivers/pnp/core.c
===================================================================
--- w.orig/drivers/pnp/core.c	2007-11-01 11:08:28.000000000 -0600
+++ w/drivers/pnp/core.c	2007-11-01 11:09:41.000000000 -0600
@@ -124,6 +124,9 @@
 	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
 	spin_unlock(&pnp_lock);
 
+	if (dev->active)
+		pnp_request_resources(dev);
+
 	ret = device_register(&dev->dev);
 	if (ret)
 		return ret;
Index: w/drivers/pnp/manager.c
===================================================================
--- w.orig/drivers/pnp/manager.c	2007-11-01 11:09:38.000000000 -0600
+++ w/drivers/pnp/manager.c	2007-11-01 11:09:41.000000000 -0600
@@ -391,9 +391,11 @@
 
 	if (!pnp_can_configure(dev))
 		return -ENODEV;
+
 	bak = pnp_alloc(sizeof(struct pnp_resource_table));
 	if (!bak)
 		return -ENOMEM;
+
 	*bak = dev->res;
 
 	down(&pnp_res_mutex);
@@ -463,7 +465,7 @@
  * pnp_start_dev - low-level start of the PnP device
  * @dev: pointer to the desired device
  *
- * assumes that resources have already been allocated
+ * assumes that resources have already been assigned to the device
  */
 int pnp_start_dev(struct pnp_dev *dev)
 {
@@ -472,6 +474,9 @@
 		return -EINVAL;
 	}
 
+	if (pnp_request_resources(dev))
+		dev_err(&dev->dev, "could not allocate resources\n");
+
 	if (dev->protocol->set(dev, &dev->res) < 0) {
 		dev_err(&dev->dev, "activation failed\n");
 		return -EIO;
@@ -484,8 +489,6 @@
 /**
  * pnp_stop_dev - low-level disable of the PnP device
  * @dev: pointer to the desired device
- *
- * does not free resources
  */
 int pnp_stop_dev(struct pnp_dev *dev)
 {
@@ -493,11 +496,14 @@
 		dev_dbg(&dev->dev, "disabling not supported\n");
 		return -EINVAL;
 	}
+
 	if (dev->protocol->disable(dev) < 0) {
 		dev_err(&dev->dev, "disable failed\n");
 		return -EIO;
 	}
 
+	pnp_release_resources(dev);
+
 	dev_info(&dev->dev, "disabled\n");
 	return 0;
 }
Index: w/drivers/pnp/resource.c
===================================================================
--- w.orig/drivers/pnp/resource.c	2007-11-01 11:08:28.000000000 -0600
+++ w/drivers/pnp/resource.c	2007-11-01 11:09:41.000000000 -0600
@@ -23,6 +23,7 @@
 static int pnp_reserve_dma[8] = {[0 ... 7] = -1 };	/* reserve (don't use) some DMA */
 static int pnp_reserve_io[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some I/O region */
 static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some memory region */
+static int pnp_no_reservations;
 
 /*
  * option registration
@@ -459,6 +460,98 @@
 #endif
 }
 
+int pnp_request_resources(struct pnp_dev *dev)
+{
+	int i, ret;
+	struct resource *res;
+
+	if (pnp_no_reservations) {
+		dev_warn(&dev->dev, "not reserving active resources because "
+			"\"pnp=no_reservations\"\n");
+		for (i = 0; i < PNP_MAX_PORT; i++) {
+			if (pnp_port_valid(dev, i)) {
+				res = &dev->res.port_resource[i];
+				dev_warn(&dev->dev, "  ports 0x%llx-0x%llx\n",
+					(unsigned long long) res->start,
+					(unsigned long long) res->end);
+			}
+		}
+		for (i = 0; i < PNP_MAX_MEM; i++) {
+			if (pnp_mem_valid(dev, i)) {
+				res = &dev->res.mem_resource[i];
+				dev_warn(&dev->dev, "  MMIO 0x%llx-0x%llx\n",
+					(unsigned long long) res->start,
+					(unsigned long long) res->end);
+			}
+		}
+		return 0;
+	}
+
+	/*
+	 * We use insert_resource() rather than request_resource() because
+	 * request_standard_resources() has already requested some standard
+	 * areas that are described by PNP.
+	 */
+	for (i = 0; i < PNP_MAX_PORT; i++) {
+		if (pnp_port_valid(dev, i)) {
+			res = &dev->res.port_resource[i];
+			res->name = dev->dev.bus_id;
+			ret = insert_resource(&ioport_resource, res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't allocate I/O ports at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		if (pnp_mem_valid(dev, i)) {
+			res = &dev->res.mem_resource[i];
+			res->name = dev->dev.bus_id;
+			ret = insert_resource(&iomem_resource, res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't allocate MMIO space at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	return 0;
+}
+
+int pnp_release_resources(struct pnp_dev *dev)
+{
+	int i, ret;
+	struct resource *res;
+
+	if (pnp_no_reservations)
+		return 0;
+
+	for (i = 0; i < PNP_MAX_PORT; i++) {
+		if (pnp_port_valid(dev, i)) {
+			res = &dev->res.port_resource[i];
+			ret = release_resource(res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't release I/O ports at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	for (i = 0; i < PNP_MAX_MEM; i++) {
+		if (pnp_mem_valid(dev, i)) {
+			res = &dev->res.mem_resource[i];
+			ret = release_resource(res);
+			if (ret)
+				dev_warn(&dev->dev,
+					"can't release MMIO space at 0x%llx\n",
+					(unsigned long long) res->start);
+		}
+	}
+
+	return 0;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
@@ -510,3 +603,13 @@
 }
 
 __setup("pnp_reserve_mem=", pnp_setup_reserve_mem);
+
+static int __init pnp_setup(char *str)
+{
+	if (!strcmp(str, "no_reservations"))
+		pnp_no_reservations = 1;
+
+	return 1;
+}
+
+__setup("pnp=", pnp_setup);
