Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbXBJDCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbXBJDCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 22:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXBJDCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 22:02:38 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:37616 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbXBJDCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 22:02:37 -0500
Subject: [PATCH] Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <45CD24F6.8090107@shaw.ca>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	 <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no>
	 <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no>  <45CD24F6.8090107@shaw.ca>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 14:02:34 +1100
Message-Id: <1171076554.10170.5.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-02-09 at 19:50 -0600, Robert Hancock wrote:
> It also kind of bothers me that if a driver has no suspend/resume 
> functions, and you suspend and resume the system, we don't complain 
> about it even though there's a very good chance that device is not going 
> to function properly. How about something in dmesg like:
> 
> Warning: driver for device XXXX has no suspend or resume support.
> Device may not function properly after resume.
> 
> so that users know who to complain to. Maybe there are some devices that 
> truly don't need any handling for suspend, but if so I suspect the 
> number of those is small enough that adding empty functions would be a 
> good-enough solution.

Here's my current version of a patch to do this, if anyone wants to try
it out. It dumps stack with the warning to make it easier to see what
the source of the message is:

 drivers/base/core.c       |   25 +++++++++++++++++++++++++
 drivers/pci/pci-driver.c  |    6 ++++++
 drivers/usb/core/driver.c |    5 +++++
 include/linux/device.h    |    1 +
 4 files changed, 37 insertions(+)
diff -ruNp 920-report-no-pm-support.patch-old/drivers/base/core.c 920-report-no-pm-support.patch-new/drivers/base/core.c
--- 920-report-no-pm-support.patch-old/drivers/base/core.c	2007-02-06 14:48:31.000000000 +1100
+++ 920-report-no-pm-support.patch-new/drivers/base/core.c	2007-02-10 13:36:33.000000000 +1100
@@ -552,6 +552,30 @@ int device_add(struct device *dev)
 				class_intf->add_dev(dev, class_intf);
 		up(&dev->class->sem);
 	}
+
+#ifdef CONFIG_PM
+	{
+	int nosusp = 0, nores = 0;
+
+	if (!((dev->class && dev->class->suspend) ||
+	      (dev->bus && (dev->bus->suspend || dev->bus->suspend_late))))
+		nosusp = 1;
+
+	if (!((dev->class && dev->class->resume) ||
+	      (dev->bus && (dev->bus->resume || dev->bus->resume_early))))
+		nores = 1;
+
+	if ((nosusp || nores) && !dev->pm_safe) {
+		printk("Device driver %s lacks bus and class support for "
+				"being %s.\n",
+			kobject_name(&dev->kobj),
+			nosusp ? (nores ? "suspended or resumed" :
+				"resumed") : "suspended");
+		dump_stack();
+	}
+	}
+#endif
+
  Done:
  	kfree(class_name);
 	put_device(dev);
@@ -851,6 +875,7 @@ struct device *device_create(struct clas
 	dev->class = class;
 	dev->parent = parent;
 	dev->release = device_create_release;
+	dev->pm_safe = 1;
 
 	va_start(args, fmt);
 	vsnprintf(dev->bus_id, BUS_ID_SIZE, fmt, args);
diff -ruNp 920-report-no-pm-support.patch-old/drivers/pci/pci-driver.c 920-report-no-pm-support.patch-new/drivers/pci/pci-driver.c
--- 920-report-no-pm-support.patch-old/drivers/pci/pci-driver.c	2007-02-06 14:48:44.000000000 +1100
+++ 920-report-no-pm-support.patch-new/drivers/pci/pci-driver.c	2007-02-10 14:00:39.000000000 +1100
@@ -449,6 +449,12 @@ int __pci_register_driver(struct pci_dri
 	if (error)
 		driver_unregister(&drv->driver);
 
+	if (!drv->suspend || !drv->resume)
+		printk("PCI driver %s lacks driver specific %s support.\n",
+				drv->name,
+				!drv->suspend ? (drv->resume ? "suspend" :
+					"suspend and resume") :	"resume");
+
 	return error;
 }
 
diff -ruNp 920-report-no-pm-support.patch-old/drivers/usb/core/driver.c 920-report-no-pm-support.patch-new/drivers/usb/core/driver.c
--- 920-report-no-pm-support.patch-old/drivers/usb/core/driver.c	2007-02-06 14:48:47.000000000 +1100
+++ 920-report-no-pm-support.patch-new/drivers/usb/core/driver.c	2007-02-10 12:32:57.000000000 +1100
@@ -709,6 +709,11 @@ int usb_register_device_driver(struct us
 		pr_info("%s: registered new device driver %s\n",
 			usbcore_name, new_udriver->name);
 		usbfs_update_special();
+		if (!new_udriver->suspend || !new_udriver->resume)
+			printk("USB driver %s lacks %s support.\n",
+				new_udriver->name, !new_udriver->suspend ?
+				(new_udriver->resume ? "suspend" :
+				 "suspend and resume") : "resume");
 	} else {
 		printk(KERN_ERR "%s: error %d registering device "
 			"	driver %s\n",
diff -ruNp 920-report-no-pm-support.patch-old/include/linux/device.h 920-report-no-pm-support.patch-new/include/linux/device.h
--- 920-report-no-pm-support.patch-old/include/linux/device.h	2007-02-06 14:48:56.000000000 +1100
+++ 920-report-no-pm-support.patch-new/include/linux/device.h	2007-02-10 13:36:01.000000000 +1100
@@ -356,6 +356,7 @@ struct device {
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	unsigned		is_registered:1;
+	unsigned		pm_safe:1; /* No suspend/resume fns ok? */
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
 
 


My output:
nigel@nigel:~$ dmesg | grep lacks
[   15.113674] Device driver platform lacks bus and class support for being suspended or resumed.
[   15.131601] Device driver pci0000:00 lacks bus and class support for being suspended or resumed.
[   15.179802] Device driver pnp0 lacks bus and class support for being suspended or resumed.
[   15.972661] Device driver ide0 lacks bus and class support for being suspended or resumed.
[   17.829746] Device driver ide1 lacks bus and class support for being suspended or resumed.
[   17.830878] PCI driver ALI15x3_IDE lacks driver specific suspend and resume support.
[   17.830963] PCI driver PIIX_IDE lacks driver specific suspend and resume support.
[   17.878190] Device driver serio0 lacks bus and class support for being resumed.
[   17.878442] Device driver serio1 lacks bus and class support for being resumed.
[   17.878672] Device driver serio2 lacks bus and class support for being resumed.
[   18.555856] Device driver serio3 lacks bus and class support for being resumed.
[   18.558109] Device driver serio4 lacks bus and class support for being resumed.
[   78.487717] Device driver usbdev1.1_ep00 lacks bus and class support for being suspended or resumed.
[   78.595362] Device driver usbdev1.1_ep81 lacks bus and class support for being suspended or resumed.
[   78.657382] Device driver usbdev2.1_ep00 lacks bus and class support for being suspended or resumed.
[   78.765044] Device driver usbdev2.1_ep81 lacks bus and class support for being suspended or resumed.
[   78.795324] Device driver usbdev3.1_ep00 lacks bus and class support for being suspended or resumed.
[   78.904912] Device driver usbdev3.1_ep81 lacks bus and class support for being suspended or resumed.
[   78.936997] PCI driver ali15x3_smbus lacks driver specific suspend and resume support.
[   78.996318] PCI driver ali1535_smbus lacks driver specific suspend and resume support.


