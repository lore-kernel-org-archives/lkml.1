Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbXJZEBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbXJZEBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXJZEBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:01:12 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:50655 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXJZEBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:01:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI Operation Region resources
Date: Thu, 25 Oct 2007 21:59:10 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
References: <1193236319.4590.225.camel@queen.suse.de> <200710250906.23003.bjorn.helgaas@hp.com> <1193352907.3665.37.camel@fanta4.site>
In-Reply-To: <1193352907.3665.37.camel@fanta4.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252159.11594.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 4:55:07 pm Thomas Renninger wrote:
> On Thu, 2007-10-25 at 09:06 -0600, Bjorn Helgaas wrote:
> > Isn't the real problem that we have a bunch of drivers that use some of
> > the same resources, and if ACPI reserved all the right resources, all
> > those drivers would break?
>
> Yes, but:
> It is really impossible to register them just like that.
> I only tried on one machine I implemented on, Jean tested with more
> machines. Even there the resources did not only interfere, but overlap.
> The Operation Region declarations in ACPI don't belong to a real driver,
> but may be used in all kind of functions.

Can we reserve the resources when we register the opregion?  Or does
the opregion declaration just not tell us what resources it might use?

> E.g. the thermal driver can't know which operation regions it may use
> later, e.g. by invoking _THM which in turn invokes a couple of other
> functions where IO ports are addressed via operation regions.

I would think the opregion resources should be reserved in connection
with the opregion, not with drivers that use the opregion.

> Also the BIOS developers seem to choose the regions in a very dump way
> sometimes.
> Just some imaginary values, but I saw similar (overlapping):
>  - For a PNP device IO ports from 0x400-0x410 are reserved
>  - A operation region is declared from 0x399-0x401

If we know the resources the opregion can use, we can at least
reserve the union of those used by the opregion and by other
PNP devices.  A little messy to deal with overlapping areas, I
agree, but it should still be possible by shrinking the region
or allocating a port at a time or something.

> Also the current request_resource interface (not the interface but the
> callers), need to be polished up first.
> 1) E.g. PNPACPI needs to dynamically allocate its resources (as we
> already discussed, I hope to be able to send something soon. Already
> works, but this will also affect PNPBIOS and ISAPNP, a lot old code and
> this needs careful review/testing).

I have a patch for this (see below).  It is risky, and I'm nervous
about it.  But the alternative (leaving PNP devices active but not
reserving their resources, as we do today) is also risky.

If you have a similar patch in the works, I'd like to compare with mine.

> 2) I have no idea why e.g. i386/x86_64 kernel/setup.c code statically
> requests some ports below 0x100 and whether it can be ripped out or gets
> requested via the operation regions then in a sane way. I know they
> interfere on some systems with operation regions.

You mean the stuff in request_standard_resources()?  I think that's
legacy from before we had PNPBIOS and ACPI.  Theoretically, we should
be able to remove it if we have PNPBIOS or ACPI.  But I think that
would be too dangerous.

It should be safe to leave it -- it's OK if we reserve a little bit
too much.  The problem is if we reserve too little.

Bjorn


NOT FOR APPLICATION -- NOT FOR APPLICATION -- NOT FOR APPLICATION

PNP: request ioport and iomem resources used by active devices

For platform-type devices, PNP tells us what devices are present, whether
they're active, and what resources they consume.  To prevent conflicts, the
PNP core should request the resources used by active devices before we
assign resources to any other devices.

This overlaps with request_standard_resources(), which requests resources
for a built-in list of "standard PC devices" such as DMA controllers, PICs,
timers, keyboard, etc.  PNP tells us which devices are actually present on
a specific machine.

Sometimes the built-in standard resources are larger than what PNP reports,
or they combine things that PNP reports separately, which makes things look
a little funny:

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

This doesn't mark the resources busy; they should be marked busy when
a driver claims them.  But if driver attempts to claim a region larger
than what PNP reported, it will fail.

Index: w/drivers/pnp/core.c
===================================================================
--- w.orig/drivers/pnp/core.c	2007-10-23 10:45:32.000000000 -0600
+++ w/drivers/pnp/core.c	2007-10-23 16:07:28.000000000 -0600
@@ -124,6 +124,9 @@
 	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
 	spin_unlock(&pnp_lock);
 
+	if (dev->active)
+		pnp_request_resources(dev);
+
 	ret = device_register(&dev->dev);
 	if (ret)
 		return ret;
Index: w/drivers/pnp/resource.c
===================================================================
--- w.orig/drivers/pnp/resource.c	2007-10-23 10:45:32.000000000 -0600
+++ w/drivers/pnp/resource.c	2007-10-23 16:07:28.000000000 -0600
@@ -459,6 +459,73 @@
 #endif
 }
 
+int pnp_request_resources(struct pnp_dev *dev)
+{
+	int i, ret;
+	struct resource *res;
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
Index: w/drivers/pnp/base.h
===================================================================
--- w.orig/drivers/pnp/base.h	2007-10-23 10:45:32.000000000 -0600
+++ w/drivers/pnp/base.h	2007-10-23 16:07:28.000000000 -0600
@@ -5,6 +5,8 @@
 void pnp_free_option(struct pnp_option *option);
 int __pnp_add_device(struct pnp_dev *dev);
 void __pnp_remove_device(struct pnp_dev *dev);
+int pnp_request_resources(struct pnp_dev *dev);
+int pnp_release_resources(struct pnp_dev *dev);
 
 int pnp_check_port(struct pnp_dev * dev, int idx);
 int pnp_check_mem(struct pnp_dev * dev, int idx);
Index: w/drivers/pnp/manager.c
===================================================================
--- w.orig/drivers/pnp/manager.c	2007-10-23 16:00:54.000000000 -0600
+++ w/drivers/pnp/manager.c	2007-10-23 16:08:04.000000000 -0600
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
