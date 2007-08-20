Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbXHTW4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbXHTW4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761145AbXHTWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:53:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:53968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbXHTWxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:53:08 -0400
Message-Id: <20070820225131.546468000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:17 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, kay.sievers@vrfy.org
Subject: [patch 11/14] Convert from class_device to device for USB host
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=usb-host.patch

Convert from class_device to device for drivers/ide/usb/host.   Greg, not
sure if you're looking for a patch for this. Kay mentioned maybe it was to
be superceded by a diff mechanism.  Free free to drop if so. Thanks!

---
 drivers/usb/host/ehci-dbg.c |   34 +++++++++++++++++-----------------
 drivers/usb/host/ehci-hub.c |   23 +++++++++++++----------
 drivers/usb/host/ohci-dbg.c |   34 +++++++++++++++++-----------------
 3 files changed, 47 insertions(+), 44 deletions(-)

--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -442,7 +442,7 @@ done:
 }
 
 static ssize_t
-show_async (struct class_device *class_dev, char *buf)
+show_async (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_bus		*bus;
 	struct usb_hcd		*hcd;
@@ -454,7 +454,7 @@ show_async (struct class_device *class_d
 
 	*buf = 0;
 
-	bus = class_get_devdata(class_dev);
+	bus = dev_get_drvdata(dev);
 	hcd = bus_to_hcd(bus);
 	ehci = hcd_to_ehci (hcd);
 	next = buf;
@@ -479,12 +479,12 @@ show_async (struct class_device *class_d
 
 	return strlen (buf);
 }
-static CLASS_DEVICE_ATTR (async, S_IRUGO, show_async, NULL);
+static DEVICE_ATTR (async, S_IRUGO, show_async, NULL);
 
 #define DBG_SCHED_LIMIT 64
 
 static ssize_t
-show_periodic (struct class_device *class_dev, char *buf)
+show_periodic (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_bus		*bus;
 	struct usb_hcd		*hcd;
@@ -500,7 +500,7 @@ show_periodic (struct class_device *clas
 		return 0;
 	seen_count = 0;
 
-	bus = class_get_devdata(class_dev);
+	bus = dev_get_drvdata(dev);
 	hcd = bus_to_hcd(bus);
 	ehci = hcd_to_ehci (hcd);
 	next = buf;
@@ -623,12 +623,12 @@ show_periodic (struct class_device *clas
 
 	return PAGE_SIZE - size;
 }
-static CLASS_DEVICE_ATTR (periodic, S_IRUGO, show_periodic, NULL);
+static DEVICE_ATTR (periodic, S_IRUGO, show_periodic, NULL);
 
 #undef DBG_SCHED_LIMIT
 
 static ssize_t
-show_registers (struct class_device *class_dev, char *buf)
+show_registers (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_bus		*bus;
 	struct usb_hcd		*hcd;
@@ -639,7 +639,7 @@ show_registers (struct class_device *cla
 	static char		fmt [] = "%*s\n";
 	static char		label [] = "";
 
-	bus = class_get_devdata(class_dev);
+	bus = dev_get_drvdata(dev);
 	hcd = bus_to_hcd(bus);
 	ehci = hcd_to_ehci (hcd);
 	next = buf;
@@ -789,25 +789,25 @@ done:
 
 	return PAGE_SIZE - size;
 }
-static CLASS_DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
+static DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
 
 static inline void create_debug_files (struct ehci_hcd *ehci)
 {
-	struct class_device *cldev = ehci_to_hcd(ehci)->self.class_dev;
+	struct device *dev = ehci_to_hcd(ehci)->self.dev;
 	int retval;
 
-	retval = class_device_create_file(cldev, &class_device_attr_async);
-	retval = class_device_create_file(cldev, &class_device_attr_periodic);
-	retval = class_device_create_file(cldev, &class_device_attr_registers);
+	retval = device_create_file(cldev, &device_attr_async);
+	retval = device_create_file(cldev, &device_attr_periodic);
+	retval = device_create_file(cldev, &device_attr_registers);
 }
 
 static inline void remove_debug_files (struct ehci_hcd *ehci)
 {
-	struct class_device *cldev = ehci_to_hcd(ehci)->self.class_dev;
+	struct device *dev = ehci_to_hcd(ehci)->self.dev;
 
-	class_device_remove_file(cldev, &class_device_attr_async);
-	class_device_remove_file(cldev, &class_device_attr_periodic);
-	class_device_remove_file(cldev, &class_device_attr_registers);
+	device_remove_file(cldev, &device_attr_async);
+	device_remove_file(cldev, &device_attr_periodic);
+	device_remove_file(cldev, &device_attr_registers);
 }
 
 #endif /* STUB_DEBUG_FILES */
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -291,14 +291,16 @@ static int ehci_bus_resume (struct usb_h
 /*-------------------------------------------------------------------------*/
 
 /* Display the ports dedicated to the companion controller */
-static ssize_t show_companion(struct class_device *class_dev, char *buf)
+static ssize_t show_companion(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
 {
 	struct ehci_hcd		*ehci;
 	int			nports, index, n;
 	int			count = PAGE_SIZE;
 	char			*ptr = buf;
 
-	ehci = hcd_to_ehci(bus_to_hcd(class_get_devdata(class_dev)));
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
 	nports = HCS_N_PORTS(ehci->hcs_params);
 
 	for (index = 0; index < nports; ++index) {
@@ -316,15 +318,16 @@ static ssize_t show_companion(struct cla
  * Syntax is "[-]portnum", where a leading '-' sign means
  * return control of the port to the EHCI controller.
  */
-static ssize_t store_companion(struct class_device *class_dev,
-		const char *buf, size_t count)
+static ssize_t store_companion(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
 {
 	struct ehci_hcd		*ehci;
 	int			portnum, new_owner, try;
 	u32 __iomem		*status_reg;
 	u32			port_status;
 
-	ehci = hcd_to_ehci(bus_to_hcd(class_get_devdata(class_dev)));
+	ehci = hcd_to_ehci(bus_to_hcd(dev_get_drvdata(dev)));
 	new_owner = PORT_OWNER;		/* Owned by companion */
 	if (sscanf(buf, "%d", &portnum) != 1)
 		return -EINVAL;
@@ -364,7 +367,7 @@ static ssize_t store_companion(struct cl
 	}
 	return count;
 }
-static CLASS_DEVICE_ATTR(companion, 0644, show_companion, store_companion);
+static DEVICE_ATTR(companion, 0644, show_companion, store_companion);
 
 static inline void create_companion_file(struct ehci_hcd *ehci)
 {
@@ -372,16 +375,16 @@ static inline void create_companion_file
 
 	/* with integrated TT there is no companion! */
 	if (!ehci_is_TDI(ehci))
-		i = class_device_create_file(ehci_to_hcd(ehci)->self.class_dev,
-				&class_device_attr_companion);
+		i = device_create_file(ehci_to_hcd(ehci)->self.dev,
+				       &dev_attr_companion);
 }
 
 static inline void remove_companion_file(struct ehci_hcd *ehci)
 {
 	/* with integrated TT there is no companion! */
 	if (!ehci_is_TDI(ehci))
-		class_device_remove_file(ehci_to_hcd(ehci)->self.class_dev,
-				&class_device_attr_companion);
+		device_remove_file(ehci_to_hcd(ehci)->self.dev,
+				   &dev_attr_companion);
 }
 
 
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -468,7 +468,7 @@ show_list (struct ohci_hcd *ohci, char *
 }
 
 static ssize_t
-show_async (struct class_device *class_dev, char *buf)
+show_async (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_bus		*bus;
 	struct usb_hcd		*hcd;
@@ -476,7 +476,7 @@ show_async (struct class_device *class_d
 	size_t			temp;
 	unsigned long		flags;
 
-	bus = class_get_devdata(class_dev);
+	bus = dev_get_drvdata(dev);
 	hcd = bus_to_hcd(bus);
 	ohci = hcd_to_ohci(hcd);
 
@@ -488,13 +488,13 @@ show_async (struct class_device *class_d
 
 	return temp;
 }
-static CLASS_DEVICE_ATTR (async, S_IRUGO, show_async, NULL);
+static DEVICE_ATTR (async, S_IRUGO, show_async, NULL);
 
 
 #define DBG_SCHED_LIMIT 64
 
 static ssize_t
-show_periodic (struct class_device *class_dev, char *buf)
+show_periodic (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_bus		*bus;
 	struct usb_hcd		*hcd;
@@ -509,7 +509,7 @@ show_periodic (struct class_device *clas
 		return 0;
 	seen_count = 0;
 
-	bus = class_get_devdata(class_dev);
+	bus = dev_get_drvdata(dev);
 	hcd = bus_to_hcd(bus);
 	ohci = hcd_to_ohci(hcd);
 	next = buf;
@@ -589,13 +589,13 @@ show_periodic (struct class_device *clas
 
 	return PAGE_SIZE - size;
 }
-static CLASS_DEVICE_ATTR (periodic, S_IRUGO, show_periodic, NULL);
+static DEVICE_ATTR (periodic, S_IRUGO, show_periodic, NULL);
 
 
 #undef DBG_SCHED_LIMIT
 
 static ssize_t
-show_registers (struct class_device *class_dev, char *buf)
+show_registers (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_bus		*bus;
 	struct usb_hcd		*hcd;
@@ -606,7 +606,7 @@ show_registers (struct class_device *cla
 	char			*next;
 	u32			rdata;
 
-	bus = class_get_devdata(class_dev);
+	bus = dev_get_drvdata(dev);
 	hcd = bus_to_hcd(bus);
 	ohci = hcd_to_ohci(hcd);
 	regs = ohci->regs;
@@ -679,27 +679,27 @@ done:
 	spin_unlock_irqrestore (&ohci->lock, flags);
 	return PAGE_SIZE - size;
 }
-static CLASS_DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
+static DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
 
 
 static inline void create_debug_files (struct ohci_hcd *ohci)
 {
-	struct class_device *cldev = ohci_to_hcd(ohci)->self.class_dev;
+	struct device *dev = ohci_to_hcd(ohci)->self.dev;
 	int retval;
 
-	retval = class_device_create_file(cldev, &class_device_attr_async);
-	retval = class_device_create_file(cldev, &class_device_attr_periodic);
-	retval = class_device_create_file(cldev, &class_device_attr_registers);
+	retval = device_create_file(cldev, &device_attr_async);
+	retval = device_create_file(cldev, &device_attr_periodic);
+	retval = device_create_file(cldev, &device_attr_registers);
 	ohci_dbg (ohci, "created debug files\n");
 }
 
 static inline void remove_debug_files (struct ohci_hcd *ohci)
 {
-	struct class_device *cldev = ohci_to_hcd(ohci)->self.class_dev;
+	struct device *dev = ohci_to_hcd(ohci)->self.dev;
 
-	class_device_remove_file(cldev, &class_device_attr_async);
-	class_device_remove_file(cldev, &class_device_attr_periodic);
-	class_device_remove_file(cldev, &class_device_attr_registers);
+	device_remove_file(cldev, &device_attr_async);
+	device_remove_file(cldev, &device_attr_periodic);
+	device_remove_file(cldev, &device_attr_registers);
 }
 
 #endif

-- 
