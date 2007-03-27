Return-Path: <linux-kernel-owner+w=401wt.eu-S933885AbXC0BC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbXC0BC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933880AbXC0BC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:02:59 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35476 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933888AbXC0BCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:02:47 -0400
Date: Tue, 27 Mar 2007 03:02:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove the broken PCI_MULTITHREAD_PROBE option
Message-ID: <20070327010251.GX16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the PCI_MULTITHREAD_PROBE option that had already 
been marked as broken.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 Documentation/pci.txt    |    4 ---
 drivers/base/dd.c        |   41 ++-------------------------------------
 drivers/pci/Kconfig      |   25 -----------------------
 drivers/pci/pci-driver.c |   15 --------------
 include/linux/device.h   |    1 
 5 files changed, 3 insertions(+), 83 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/pci/Kconfig.old	2007-03-26 21:14:09.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/pci/Kconfig	2007-03-26 21:14:17.000000000 +0200
@@ -17,31 +17,6 @@
 
 	   If you don't know what to do here, say N.
 
-config PCI_MULTITHREAD_PROBE
-	bool "PCI Multi-threaded probe (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL && BROKEN
-	help
-	  Say Y here if you want the PCI core to spawn a new thread for
-	  every PCI device that is probed.  This can cause a huge
-	  speedup in boot times on multiprocessor machines, and even a
-	  smaller speedup on single processor machines.
-
-	  But it can also cause lots of bad things to happen.  A number
-	  of PCI drivers cannot properly handle running in this way,
-	  some will just not work properly at all, while others might
-	  decide to blow up power supplies with a huge load all at once,
-	  so use this option at your own risk.
-
-	  It is very unwise to use this option if you are not using a
-	  boot process that can handle devices being created in any
-	  order.  A program that can create persistent block and network
-	  device names (like udev) is a good idea if you wish to use
-	  this option.
-
-	  Again, use this option at your own risk, you have been warned!
-
-	  When in doubt, say N.
-
 config PCI_DEBUG
 	bool "PCI Debugging"
 	depends on PCI && DEBUG_KERNEL
--- linux-2.6.21-rc4-mm1/Documentation/pci.txt.old	2007-03-26 21:33:53.000000000 +0200
+++ linux-2.6.21-rc4-mm1/Documentation/pci.txt	2007-03-26 21:34:01.000000000 +0200
@@ -124,10 +124,6 @@
 
 	err_handler	See Documentation/pci-error-recovery.txt
 
-	multithread_probe	Enable multi-threaded probe/scan. Driver must
-			provide its own locking/syncronization for init
-			operations if this is enabled.
-
 
 The ID table is an array of struct pci_device_id entries ending with an
 all-zero entry.  Each entry consists of:
--- linux-2.6.21-rc4-mm1/include/linux/device.h.old	2007-03-26 21:33:30.000000000 +0200
+++ linux-2.6.21-rc4-mm1/include/linux/device.h	2007-03-26 21:33:39.000000000 +0200
@@ -80,7 +80,6 @@
 	int (*resume)(struct device * dev);
 
 	unsigned int drivers_autoprobe:1;
-	unsigned int multithread_probe:1;
 };
 
 extern int __must_check bus_register(struct bus_type * bus);
--- linux-2.6.21-rc4-mm1/drivers/pci/pci-driver.c.old	2007-03-26 21:29:05.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/pci/pci-driver.c	2007-03-26 21:31:00.000000000 +0200
@@ -14,20 +14,6 @@
 #include "pci.h"
 
 /*
- *  Registration of PCI drivers and handling of hot-pluggable devices.
- */
-
-/* multithreaded probe logic */
-static int pci_multithread_probe =
-#ifdef CONFIG_PCI_MULTITHREAD_PROBE
-	1;
-#else
-	0;
-#endif
-__module_param_call("", pci_multithread_probe, param_set_bool, param_get_bool, &pci_multithread_probe, 0644);
-
-
-/*
  * Dynamic device IDs are disabled for !CONFIG_HOTPLUG
  */
 
@@ -569,7 +555,6 @@
 
 static int __init pci_driver_init(void)
 {
-	pci_bus_type.multithread_probe = pci_multithread_probe;
 	return bus_register(&pci_bus_type);
 }
 
--- linux-2.6.21-rc4-mm1/drivers/base/dd.c.old	2007-03-26 21:35:00.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/base/dd.c	2007-03-26 21:38:58.000000000 +0200
@@ -226,12 +226,10 @@
  *
  *	Walk the list of drivers that the bus has and call
  *	driver_probe_device() for each pair. If a compatible
- *	pair is found, break out and return. If the bus specifies
- *	multithreaded probing, walking the list of drivers is done
- *	on a probing thread.
+ *	pair is found, break out and return.
  *
  *	Returns 1 if the device was bound to a driver;
- *	0 if no matching device was found or multithreaded probing is done;
+ *	0 if no matching device was found;
  *	-ENODEV if the device is not registered.
  *
  *	When called for a USB interface, @dev->parent->sem must be held.
@@ -239,7 +237,6 @@
 int device_attach(struct device * dev)
 {
 	int ret = 0;
-	struct task_struct *probe_task = ERR_PTR(-ENOMEM);
 
 	down(&dev->sem);
 	if (dev->driver) {
@@ -251,12 +248,7 @@
 			ret = 0;
 		}
 	} else {
-		if (dev->bus->multithread_probe)
-			probe_task = kthread_run(device_probe_drivers, dev,
-						 "probe-%s", dev->bus_id);
-		if(IS_ERR(probe_task))
-			ret = bus_for_each_drv(dev->bus, NULL, dev,
-					       __device_attach);
+		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
 	}
 	up(&dev->sem);
 	return ret;
@@ -383,33 +375,6 @@
 	}
 }
 
-#ifdef CONFIG_PCI_MULTITHREAD_PROBE
-static int __init wait_for_probes(void)
-{
-	DEFINE_WAIT(wait);
-
-	printk(KERN_INFO "%s: waiting for %d threads\n", __FUNCTION__,
-			atomic_read(&probe_count));
-	if (!atomic_read(&probe_count))
-		return 0;
-	while (atomic_read(&probe_count)) {
-		prepare_to_wait(&probe_waitqueue, &wait, TASK_UNINTERRUPTIBLE);
-		if (atomic_read(&probe_count))
-			schedule();
-	}
-	finish_wait(&probe_waitqueue, &wait);
-	return 0;
-}
-
-core_initcall_sync(wait_for_probes);
-postcore_initcall_sync(wait_for_probes);
-arch_initcall_sync(wait_for_probes);
-subsys_initcall_sync(wait_for_probes);
-fs_initcall_sync(wait_for_probes);
-device_initcall_sync(wait_for_probes);
-late_initcall_sync(wait_for_probes);
-#endif
-
 EXPORT_SYMBOL_GPL(device_bind_driver);
 EXPORT_SYMBOL_GPL(device_release_driver);
 EXPORT_SYMBOL_GPL(device_attach);

