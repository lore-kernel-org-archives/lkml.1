Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbYETPr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbYETPr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761944AbYETPrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:47:17 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:59303 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602AbYETPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:47:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAF2PMkhR8DYR/2dsb2JhbACBVaxY
Date: Tue, 20 May 2008 17:47:11 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3, RFC] watchdog dev BKL pushdown
Message-ID: <20080520154711.GD2724@infomag.infomag.iguana.be>
References: <13762.1211142411@vena.lwn.net> <200805200114.24819.arnd@arndb.de> <20080520062056.GA5292@infradead.org> <200805201030.14092.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805201030.14092.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> > Actually I'd prefer to fix this for real.  This single open stuff aswell
> > as same set of ioctls are duplicated all over the watchdog drivers.  We'd
> > be much better off introducing a simple watchdog layer that handles this
> > plus proper locking and convert drivers over to it gradually.
> 
> I fully agree, I thought the same thing when I did the patches. I remember
> that Wim had a git tree doing this, which is still active at
> http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-experimental.git;a=commitdiff;h=732c54027e6c866f98857c4a6d1c6c466459dcd5
> 
> Unfortunately, it hasn't seen much activitity over the last two years, and
> the number of watchdog drivers seems to have exploded: I count 67 of them,
> including some outside of drivers/watchdog.
> 
> Wim, was there anything preventing you from integrating the generic
> watchdog layer back then?

check the linux-2.6-watchdog-mm tree. You'll see the patches sitting there
as the uniform watchdog driver. They are thus also in the -mm tree.
I'll need to change it also to an unlocked_ioctl (and add documentation!)
but I'll attach the core code below (This does not seem to be the latest code,
because I know there was a request to change the alloc_watchdogdev code so that
it could also allocate a private data-area/space).
But it gives you an idea where I was going to. Second step would then be to add
a sysfs interface so that we can start handling mutiple devices.

Greetings,
Wim.

>From a223c170e5e7e63e5dd55f56837318db6ad0807f Mon Sep 17 00:00:00 2001
From: Wim Van Sebroeck <wim@iguana.be>
Date: Sun, 19 Aug 2007 19:44:24 +0000
Subject: [PATCH] [WATCHDOG] Uniform Watchdog Device Driver

The Uniform Watchdog Device Driver is a frame-work
that contains the common code for all watchdog-driver's.
It also introduces a watchdog device structure and the
operations that go with it.

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/Kconfig              |    2 +
 drivers/watchdog/Makefile             |    2 +
 drivers/watchdog/core/Kconfig         |   34 +++
 drivers/watchdog/core/Makefile        |   11 +
 drivers/watchdog/core/watchdog_core.c |  187 +++++++++++++
 drivers/watchdog/core/watchdog_dev.c  |  463 +++++++++++++++++++++++++++++++++
 include/linux/watchdog.h              |   49 ++++
 7 files changed, 748 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/core/Kconfig
 create mode 100644 drivers/watchdog/core/Makefile
 create mode 100644 drivers/watchdog/core/watchdog_core.c
 create mode 100644 drivers/watchdog/core/watchdog_dev.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 37bddc1..a458e87 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -37,6 +37,8 @@ config WATCHDOG_NOWAYOUT
 	  get killed. If you say Y here, the watchdog cannot be stopped once
 	  it has been started.
 
+source "drivers/watchdog/core/Kconfig"
+
 #
 # General Watchdog drivers
 #
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 389f8b1..b61c103 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the WatchDog device drivers.
 #
 
+obj-$(CONFIG_WATCHDOG)	+= core/
+
 # Only one watchdog can succeed. We probe the ISA/PCI/USB based
 # watchdog-cards first, then the architecture specific watchdog
 # drivers and then the architecture independant "softdog" driver.
diff --git a/drivers/watchdog/core/Kconfig b/drivers/watchdog/core/Kconfig
new file mode 100644
index 0000000..a9a23a9
--- /dev/null
+++ b/drivers/watchdog/core/Kconfig
@@ -0,0 +1,34 @@
+#
+# Watchdog device driver core
+#
+
+if WATCHDOG
+
+config WATCHDOG_CORE
+	tristate "Uniform Watchdog Device Driver"
+	depends on EXPERIMENTAL
+	default m
+	---help---
+	  Say Y here if you want to use the new uniform watchdog device
+	  driver. This driver provides a framework for all watchdog
+	  device drivers and gives them the /dev/watchdog interface (and
+	  later also the sysfs interface).
+
+	  At this moment we have no watchdog device drivers using this new
+	  framework.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called watchdog_core.
+
+config WATCHDOG_DEBUG_CORE
+	bool "Uniform Watchdog Device Driver debugging output"
+	depends on WATCHDOG_CORE
+	default n
+	---help---
+	  Say Y here if you want the Uniform Watchdog Device Driver to
+	  produce debugging information. Select this if you are having a
+	  problem with the uniform watchdog device driver and want to see
+	  more of what is really happening.
+
+endif # WATCHDOG
+
diff --git a/drivers/watchdog/core/Makefile b/drivers/watchdog/core/Makefile
new file mode 100644
index 0000000..7554d35
--- /dev/null
+++ b/drivers/watchdog/core/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for the Watchdog Device Drivers generic core.
+#
+
+# The Generic Watchdog Driver
+obj-$(CONFIG_WATCHDOG_CORE)		+= watchdog_core.o watchdog_dev.o
+
diff --git a/drivers/watchdog/core/watchdog_core.c b/drivers/watchdog/core/watchdog_core.c
new file mode 100644
index 0000000..133dc11
--- /dev/null
+++ b/drivers/watchdog/core/watchdog_core.c
@@ -0,0 +1,187 @@
+/*
+ *	watchdog.c
+ *
+ *	(c) Copyright 2007 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This code is generic code that can be shared by all the
+ *	watchdog drivers.
+ *
+ *	Based on source code of the following authors:
+ *	  Alan Cox <alan@redhat.com>,
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Wim Van Sebroeck nor Iguana vzw. admit liability nor
+ *	provide warranty for any of this software. This material is
+ *	provided "AS-IS" and at no charge.
+ */
+
+#include <linux/module.h>	/* For module related things/EXPORT_SYMBOL/... */
+#include <linux/types.h>	/* For standard types */
+#include <linux/errno.h>	/* For the -ENODEV/... values */
+#include <linux/kernel.h>	/* For printk/panic/... */
+#include <linux/mm.h>		/* For memory allocations ... */
+#include <linux/watchdog.h>	/* For watchdog specific items */
+#include <linux/init.h>		/* For __init/__exit/... */
+
+/*
+ *	Version information
+ */
+#define DRV_VERSION	"0.01"
+#define DRV_NAME	"watchdog_core"
+#define PFX DRV_NAME	": "
+
+/*
+ *	External functions/procedures
+ */
+extern int watchdog_dev_register(struct watchdog_device *, struct device *);
+extern int watchdog_dev_unregister(struct watchdog_device *);
+
+/**
+ *	alloc_watchdogdev - allocates a watchdog device
+ *
+ *	Creates a new watchdog device structure.
+ *	Returns the new structure, or NULL if an error occured.
+ */
+struct watchdog_device *alloc_watchdogdev(void)
+{
+	int alloc_size = sizeof(struct watchdog_device);
+	void *p;
+	struct watchdog_device *dev;
+
+	/* allocate memory for our device and initialize it */
+	p = kzalloc(alloc_size, GFP_KERNEL);
+	if (!p) {
+		printk(KERN_ERR PFX "Unable to allocate watchdog device\n");
+		return NULL;
+	}
+	dev = (struct watchdog_device *) p;
+
+	return dev;
+}
+EXPORT_SYMBOL(alloc_watchdogdev);
+
+/**
+ *	free_watchdogdev - free watchdog device
+ *	@dev: watchdog device
+ *
+ *	This function does the last stage of destroying an allocated
+ *	watchdog device.
+ */
+int free_watchdogdev(struct watchdog_device *dev)
+{
+	if (!((dev->watchdog_state == WATCHDOG_UNINITIALIZED) ||
+	      (dev->watchdog_state == WATCHDOG_UNREGISTERED))) {
+		printk(KERN_ERR PFX "Unable to destroy a watchdog device that is still in use\n");
+		return -1;
+	}
+
+	kfree(dev);
+	return 0;
+}
+EXPORT_SYMBOL(free_watchdogdev);
+
+/**
+ *	register_watchdogdevice - register a watchdog device
+ *	@dev: watchdog device
+ *	@parent: parent device for the watchdog class device
+ *
+ *	This function registers a watchdog device in the kernel so
+ *	that it can be accessed from userspace.
+ */
+int register_watchdogdevice(struct watchdog_device *dev, struct device *parent)
+{
+	int ret;
+
+	if (dev == NULL ||
+	    dev->watchdog_ops == NULL)
+		return -ENODATA;
+
+	if (dev->watchdog_ops->start == NULL ||
+	    dev->watchdog_ops->stop == NULL ||
+	    dev->watchdog_ops->keepalive == NULL)
+		return -ENODATA;
+
+	if (!((dev->watchdog_state == WATCHDOG_UNINITIALIZED) ||
+	      (dev->watchdog_state == WATCHDOG_UNREGISTERED))) {
+		printk(KERN_ERR PFX "Unable to register a watchdog device that is allready in use\n");
+		return -1;
+	}
+
+	dev->options |= WDIOF_MAGICCLOSE;
+	if (dev->watchdog_ops->set_heartbeat) {
+		dev->options |= WDIOF_SETTIMEOUT;
+	} else {
+		dev->options &= ~WDIOF_SETTIMEOUT;
+	}
+
+	ret = watchdog_dev_register(dev, parent);
+	if (ret) {
+		printk(KERN_ERR PFX "error registering /dev/watchdog (err=%d)",
+			ret);
+		return ret;
+	}
+
+	dev->watchdog_state = WATCHDOG_REGISTERED;
+	return 0;
+}
+EXPORT_SYMBOL(register_watchdogdevice);
+
+/**
+ *	unregister_watchdogdevice - unregister a watchdog device
+ *	@dev: watchdog device
+ *
+ *	This function unregisters a watchdog device from the kernel.
+ */
+int unregister_watchdogdevice(struct watchdog_device *dev)
+{
+	int ret;
+
+	if (dev == NULL)
+		return -ENODATA;
+
+	if ((dev->watchdog_state == WATCHDOG_UNINITIALIZED) ||
+	    (dev->watchdog_state == WATCHDOG_UNREGISTERED)) {
+		printk(KERN_ERR PFX "Unable to unregister a watchdog device that has not been registered\n");
+		return -ENODEV;
+	}
+
+	ret = watchdog_dev_unregister(dev);
+	if (ret) {
+		printk(KERN_ERR PFX "error unregistering /dev/watchdog (err=%d)",
+			ret);
+		return ret;
+	}
+
+	dev->watchdog_state = WATCHDOG_UNREGISTERED;
+	return 0;
+}
+EXPORT_SYMBOL(unregister_watchdogdevice);
+
+static int __init watchdog_init(void)
+{
+	printk(KERN_INFO "Uniform watchdog device driver v%s loaded\n",
+		DRV_VERSION);
+	return 0;
+}
+
+static void __exit watchdog_exit(void)
+{
+	printk(KERN_INFO "Uniform watchdog device driver unloaded\n");
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
+
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("Uniform Watchdog Device Driver");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("watchdog");
+
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
new file mode 100644
index 0000000..37520cd
--- /dev/null
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -0,0 +1,463 @@
+/*
+ *	watchdog_dev.c
+ *
+ *	(c) Copyright 2007 Wim Van Sebroeck <wim@iguana.be>.
+ *
+ *	This source code is part of the generic code that can be used
+ *	by all the watchdog drivers.
+ *
+ *	This part of the generic code takes care of the following
+ *	misc device: /dev/watchdog.
+ *
+ *	Based on source code of the following authors:
+ *	  Alan Cox <alan@redhat.com>,
+ *	  Matt Domsch <Matt_Domsch@dell.com>,
+ *	  Rob Radez <rob@osinvestor.com>,
+ *	  Rusty Lynch <rusty@linux.co.intel.com>
+ *	  Satyam Sharma <satyam@infradead.org>
+ *	  Randy Dunlap <randy.dunlap@oracle.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither Wim Van Sebroeck nor Iguana vzw. admit liability nor
+ *	provide warranty for any of this software. This material is
+ *	provided "AS-IS" and at no charge.
+ */
+
+#include <linux/module.h>	/* For module related things/EXPORT_SYMBOL/... */
+#include <linux/types.h>	/* For standard types (like size_t) */
+#include <linux/errno.h>	/* For the -ENODEV/... values */
+#include <linux/kernel.h>	/* For printk/panic/... */
+#include <linux/fs.h>		/* For file operations */
+#include <linux/watchdog.h>	/* For watchdog specific items */
+#include <linux/miscdevice.h>	/* For handling misc devices */
+#include <linux/mutex.h>	/* For mutex locking */
+#include <linux/init.h>		/* For __init/__exit/... */
+#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+
+#ifdef CONFIG_WATCHDOG_DEBUG_CORE
+#define trace(format, args...) \
+	printk(KERN_INFO "%s(" format ")\n", __FUNCTION__ , ## args)
+#define dbg(format, arg...) \
+	printk(KERN_DEBUG "%s: " format "\n", __FUNCTION__, ## arg)
+#else
+#define trace(format, arg...) do { } while (0)
+#define dbg(format, arg...) do { } while (0)
+#endif
+
+/*
+ *	Version information
+ */
+#define DRV_VERSION	"0.01"
+#define DRV_NAME	"watchdog_dev"
+#define PFX DRV_NAME	": "
+
+/*
+ *	Locally used variables
+ */
+
+static struct watchdog_device *watchdogdev;	/* the watchdog device behind /dev/watchdog */
+static unsigned long watchdog_dev_open;		/* wether or not /dev/watchdog has been opened */
+static char received_magic_char;		/* wether or not we received the magic char */
+static DEFINE_MUTEX(watchdog_register_mtx);	/* prevent races between register & unregister */
+
+/*
+ *	/dev/watchdog operations
+ */
+
+/*
+ *	watchdog_write: writes to the watchdog.
+ *	@file: file from VFS
+ *	@data: user address of data
+ *	@len: length of data
+ *	@ppos: pointer to the file offset
+ *
+ *	A write to a watchdog device is defined as a keepalive signal.
+ *	Writing the magic 'V' sequence allows the next close to turn
+ *	off the watchdog (if 'nowayout' is not set).
+ */
+
+static ssize_t watchdog_write(struct file *file, const char __user *data,
+				size_t len, loff_t *ppos)
+{
+	trace("%p, %p, %zu, %p", file, data, len, ppos);
+
+	if (!watchdogdev ||
+	    !watchdogdev->watchdog_ops ||
+	    !watchdogdev->watchdog_ops->keepalive)
+		return -ENODEV;
+
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!watchdogdev->nowayout) {
+			size_t i;
+
+			/* note: just in case someone wrote the magic character
+			 * five months ago... */
+			received_magic_char = 0;
+
+			/* scan to see wether or not we got the magic character */
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V') {
+					received_magic_char = 42;
+					dbg("received the magic character\n");
+				}
+			}
+		}
+
+		/* someone wrote to us, so we sent the watchdog a keepalive signal if
+		 * the watchdog is active */
+		if (watchdogdev->watchdog_state == WATCHDOG_STARTED)
+			watchdogdev->watchdog_ops->keepalive(watchdogdev);
+	}
+	return len;
+}
+
+/*
+ *	watchdog_ioctl: handle the different ioctl's for the watchdog device.
+ *	@inode: inode of the device
+ *	@file: file handle to the device
+ *	@cmd: watchdog command
+ *	@arg: argument pointer
+ *
+ *	The watchdog API defines a common set of functions for all watchdogs
+ *	according to their available features.
+ */
+
+static int watchdog_ioctl(struct inode *inode, struct file *file,
+				unsigned int cmd, unsigned long arg)
+{
+	int status;
+	int err;
+	int new_options;
+	int new_heartbeat;
+	int time_left;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static struct watchdog_info ident = {
+		.options =		0,
+		.firmware_version =	0,
+		.identity =		"Watchdog Device",
+	};
+
+	trace("%p, %p, %u, %li", inode, file, cmd, arg);
+
+	if (!watchdogdev || !watchdogdev->watchdog_ops)
+		return -ENODEV;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+	{
+		ident.options = watchdogdev->options;
+		ident.firmware_version = watchdogdev->firmware;
+
+		strncpy(ident.identity, watchdogdev->name, 31);
+		ident.identity[32] = 0;
+
+		return copy_to_user(argp, &ident,
+			sizeof(ident)) ? -EFAULT : 0;
+	}
+
+	case WDIOC_GETSTATUS:
+	{
+		status = 0;
+
+		if (watchdogdev->watchdog_ops->get_status &&
+		    watchdogdev->watchdog_ops->get_status(watchdogdev, &status))
+			return -EFAULT;
+
+		return put_user(status, p);
+	}
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(watchdogdev->bootstatus, p);
+
+	case WDIOC_KEEPALIVE:
+	{
+		if (!watchdogdev->watchdog_ops->keepalive)
+			return -EFAULT;
+
+		/* We only sent a keepalive when the watchdog is active */
+		if (watchdogdev->watchdog_state == WATCHDOG_STARTED)
+			watchdogdev->watchdog_ops->keepalive(watchdogdev);
+
+		return 0;
+	}
+
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(new_options, p))
+			return -EFAULT;
+
+		if (!watchdogdev->watchdog_ops->start ||
+		    !watchdogdev->watchdog_ops->stop)
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD) {
+			/* only try to stop the watchdog if it's allready running */
+			if (watchdogdev->watchdog_state == WATCHDOG_STARTED) {
+				err =  watchdogdev->watchdog_ops->stop(watchdogdev);
+				if (err == 0) {
+					watchdogdev->watchdog_state = WATCHDOG_STOPPED;
+				} else {
+					printk(KERN_CRIT PFX "WDIOS_DISABLECARD not successfull! (err=%d)",
+						err);
+					return -EFAULT;
+				}
+			}
+		}
+
+		if (new_options & WDIOS_ENABLECARD) {
+			/* if the watchdog is not allready running, try to start it */
+			if (watchdogdev->watchdog_state != WATCHDOG_STARTED) {
+				err = watchdogdev->watchdog_ops->start(watchdogdev);
+				if (err == 0) {
+					watchdogdev->watchdog_state = WATCHDOG_STARTED;
+				} else {
+					printk(KERN_CRIT PFX "WDIOS_ENABLECARD not successfull! (err=%d)",
+						err);
+					return -EFAULT;
+				}
+			}
+		}
+
+		return 0;
+	}
+
+	case WDIOC_SETTIMEOUT:
+	{
+		if (!watchdogdev->watchdog_ops->set_heartbeat)
+			return -ENOTTY;
+
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+
+		if (watchdogdev->watchdog_ops->set_heartbeat(watchdogdev, new_heartbeat))
+			return -EFAULT;
+
+		/* If the watchdog is active then we sent a keepalive to make sure
+		 * that the watchdog keep's running (and if possible takes the new
+		 * heartbeat) */
+		if (watchdogdev->watchdog_ops->keepalive &&
+		    (watchdogdev->watchdog_state == WATCHDOG_STARTED))
+			watchdogdev->watchdog_ops->keepalive(watchdogdev);
+		/* Fall */
+	}
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(watchdogdev->heartbeat, p);
+
+	case WDIOC_GETTIMELEFT:
+	{
+		if (!watchdogdev->watchdog_ops->get_timeleft)
+			return -ENOTTY;
+
+		if (watchdogdev->watchdog_ops->get_timeleft(watchdogdev, &time_left))
+			return -EFAULT;
+
+		return put_user(time_left, p);
+	}
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+/*
+ *	watchdog_open: open the /dev/watchdog device.
+ *	@inode: inode of device
+ *	@file: file handle to device
+ *
+ *	When the /dev/watchdog device get's opened, we start the watchdog
+ *	and feed it with his first keepalive signal. Watch out: the
+ *	/dev/watchdog device is single open, so make sure it can only be
+ *	opened once.
+ */
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	trace("%p, %p", inode, file);
+
+	/* only open if we have a valid watchdog device */
+	if (!watchdogdev ||
+	    !watchdogdev->watchdog_ops ||
+	    !watchdogdev->watchdog_ops->start ||
+	    !watchdogdev->watchdog_ops->stop ||
+	    !watchdogdev->watchdog_ops->keepalive)
+		return -EBUSY;
+
+	/* the watchdog is single open! */
+	if (test_and_set_bit(0, &watchdog_dev_open))
+		return -EBUSY;
+
+	/* if the watchdog is not allready running, try to start it */
+	if (watchdogdev->watchdog_state != WATCHDOG_STARTED) {
+		if (watchdogdev->watchdog_ops->start(watchdogdev) == 0)
+			watchdogdev->watchdog_state = WATCHDOG_STARTED;
+	}
+
+	/* if the watchdog started, then feed the watchdog it's first keepalive signal */
+	if (watchdogdev->watchdog_state == WATCHDOG_STARTED)
+		watchdogdev->watchdog_ops->keepalive(watchdogdev);
+
+	return nonseekable_open(inode, file);
+}
+
+/*
+ *      watchdog_release: release the /dev/watchdog device.
+ *      @inode: inode of device
+ *      @file: file handle to device
+ *
+ *	This is the code for when /dev/watchdog get's closed. We will only
+ *	stop the watchdog when we have received the magic char, else the
+ *	watchdog will keep running.
+ */
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	int err;
+
+	trace("%p, %p", inode, file);
+	dbg("received_magic_char=%d", received_magic_char);
+
+	if (watchdogdev && (watchdogdev->watchdog_state == WATCHDOG_STARTED)) {
+		/* Only stop a watchdog if it actually started */
+		if (received_magic_char == 42) {
+			/* we received the magic char -> we can stop the watchdog */
+			if (watchdogdev->watchdog_ops && watchdogdev->watchdog_ops->stop) {
+				err =  watchdogdev->watchdog_ops->stop(watchdogdev);
+				if (err == 0) {
+					watchdogdev->watchdog_state = WATCHDOG_STOPPED;
+				} else {
+					printk(KERN_CRIT PFX "Watchdog didn't stop successfull! (err=%d)",
+						err);
+				}
+			} else {
+				printk(KERN_CRIT PFX "Unable to stop watchdog!");
+			}
+		} else {
+			/* If we didn't receive the magic char, then we will close
+			 * /dev/watchdog but the watchdog keeps running... */
+			printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!");
+			if (watchdogdev->watchdog_ops && watchdogdev->watchdog_ops->keepalive) {
+				watchdogdev->watchdog_ops->keepalive(watchdogdev);
+			}
+		}
+	}
+
+	received_magic_char = 0;
+
+	/* make sure that /dev/watchdog can be re-opened */
+	clear_bit(0, &watchdog_dev_open);
+
+	return 0;
+}
+
+/*
+ *	/dev/watchdog kernel interfaces
+ */
+
+static struct file_operations watchdog_fops = {
+	.owner =	THIS_MODULE,
+	.llseek =	no_llseek,
+	.write =	watchdog_write,
+	.ioctl =	watchdog_ioctl,
+	.open =		watchdog_open,
+	.release =	watchdog_release,
+};
+
+static struct miscdevice watchdog_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&watchdog_fops,
+};
+
+/*
+ *	/dev/watchdog register and unregister functions
+ */
+
+/*
+ *	watchdog_dev_register:
+ *
+ *	Register a watchdog device as /dev/watchdog. /dev/watchdog
+ *	is actually a miscdevice and thus we set it up like that.
+ */
+
+int watchdog_dev_register(struct watchdog_device *wdd, struct device *parent)
+{
+	int err = -EBUSY;
+
+	trace("%p %p", wdd, parent);
+
+	mutex_lock(&watchdog_register_mtx);
+
+	if (watchdogdev) {
+		printk(KERN_ERR PFX "another watchdog device is allready registered as /dev/watchdog\n");
+		goto out;
+	}
+
+	watchdog_miscdev.parent = parent;
+
+	dbg("Register a new /dev/watchdog device\n");
+	err = misc_register(&watchdog_miscdev);
+	if (err != 0) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			watchdog_miscdev.minor, err);
+		goto out;
+	}
+
+	watchdogdev = wdd;
+
+out:
+	mutex_unlock(&watchdog_register_mtx);
+	return err;
+}
+EXPORT_SYMBOL(watchdog_dev_register);
+
+/*
+ *	watchdog_dev_unregister:
+ *
+ *	Deregister the /dev/watchdog device.
+ */
+
+int watchdog_dev_unregister(struct watchdog_device *wdd)
+{
+	trace("%p", wdd);
+
+	mutex_lock(&watchdog_register_mtx);
+
+	if (!watchdogdev) {
+		printk(KERN_ERR PFX "there is no watchdog registered\n");
+		mutex_unlock(&watchdog_register_mtx);
+		return -1;
+	}
+
+	if (!wdd) {
+		printk(KERN_ERR PFX "cannot unregister non-existing watchdog-driver\n");
+		mutex_unlock(&watchdog_register_mtx);
+		return -2;
+	}
+
+	if (watchdogdev != wdd) {
+		printk(KERN_ERR PFX "another watchdog device is running\n");
+		mutex_unlock(&watchdog_register_mtx);
+		return -3;
+	}
+
+	dbg("Unregister /dev/watchdog device\n");
+	misc_deregister(&watchdog_miscdev);
+	watchdogdev = NULL;
+	mutex_unlock(&watchdog_register_mtx);
+	return 0;
+}
+EXPORT_SYMBOL(watchdog_dev_unregister);
+
+MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
+MODULE_DESCRIPTION("Generic /dev/watchdog Code");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 011bcfe..4f57bf4 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -53,12 +53,61 @@ struct watchdog_info {
 
 #ifdef __KERNEL__
 
+#include <linux/device.h>
+
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 #define WATCHDOG_NOWAYOUT	1
 #else
 #define WATCHDOG_NOWAYOUT	0
 #endif
 
+struct watchdog_ops;
+struct watchdog_device;
+
+struct watchdog_ops {
+	/* mandatory routines */
+		/* operation = start watchdog */
+		int	(*start)(struct watchdog_device *);
+		/* operation = stop watchdog */
+		int	(*stop)(struct watchdog_device *);
+		/* operation = send keepalive ping */
+		int	(*keepalive)(struct watchdog_device *);
+	/* optional routines */
+		/* operation = set watchdog's heartbeat */
+		int	(*set_heartbeat)(struct watchdog_device *, int);
+		/* operation = get the watchdog's status */
+		int	(*get_status)(struct watchdog_device *, int *);
+		/* operation = get the time left before reboot */
+		int	(*get_timeleft)(struct watchdog_device *, int *);
+};
+
+struct watchdog_device {
+	unsigned char name[32];			/* The watchdog's 'identity' */
+	unsigned long options;			/* The supported capabilities/options */
+	unsigned long firmware;			/* The Watchdog's Firmware version */
+	int nowayout;				/* The nowayout setting for this watchdog */
+	int heartbeat;				/* The watchdog's heartbeat */
+	int bootstatus;				/* The watchdog's bootstatus */
+	struct watchdog_ops *watchdog_ops;	/* link to watchdog_ops */
+
+	/* watchdog status (register/unregister) state machine */
+	enum { WATCHDOG_UNINITIALIZED = 0,
+	       WATCHDOG_REGISTERED,		/* completed register_watchdogdevice */
+	       WATCHDOG_STARTED,		/* watchdog device started */
+	       WATCHDOG_STOPPED,		/* watchdog device stopped */
+	       WATCHDOG_UNREGISTERED,		/* completed unregister_watchdogdevice */
+	} watchdog_state;
+
+	/* From here on everything is device dependent */
+	void	*private;
+};
+
+/* drivers/watchdog/watchdog_core.c */
+extern struct watchdog_device *alloc_watchdogdev(void);
+extern int register_watchdogdevice(struct watchdog_device *, struct device *);
+extern int unregister_watchdogdevice(struct watchdog_device *);
+extern int free_watchdogdev(struct watchdog_device *);
+
 #endif	/* __KERNEL__ */
 
 #endif  /* ifndef _LINUX_WATCHDOG_H */
-- 
1.5.3.4

