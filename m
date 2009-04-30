Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbZD3AI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbZD3AI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZD3AIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:08:47 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:45923 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZD3AIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:08:46 -0400
X-IronPort-AV: E=Sophos;i="4.40,269,1238976000"; 
   d="scan'208";a="160394543"
Date: Wed, 29 Apr 2009 17:08:45 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org
Subject: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
	devices, v4
Message-ID: <20090430000845.GA3281@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds synchronization infrastructure between asynchronous device
discovery and code that uses possibly asynchronous discovered devices at
boot time. It provides the framework to fix race conditions, such as for
the console, that have arisen as a result of quite successful work that has
been done to reduce boot times.

History
v4	Update documentation and move to its own file. Change names of
	functions to remove leading "bus_". Move functions into
	drivers/base/bootdev.c. Fix NETCONSOLE handling. Add function to
	be called from subsystems to wakeup waiters.
v3	Modify bus_bootdev_type_found to avoid superfluous wakeups.
v2      Remove global wait_queue for buses in favor of using the per-boot
	device type wait_queues. Correct wait condition in bus_wait_for_bootdev
	so that the done function will be called even if devices are still
	being discovered. Added bus_bootdev_type_found.
v1	Original release

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 Documentation/driver-model/bootdev.txt |  115 +++++++++++++++++++
 drivers/base/Makefile                  |    3 +-
 drivers/base/base.h                    |    1 +
 drivers/base/bootdev.c                 |  189 ++++++++++++++++++++++++++++++++
 drivers/base/init.c                    |    1 +
 include/linux/device.h                 |   31 +++++
 6 files changed, 339 insertions(+), 1 deletions(-)

diff --git a/Documentation/driver-model/bootdev.txt b/Documentation/driver-model/bootdev.txt
new file mode 100644
index 0000000..c633603
--- /dev/null
+++ b/Documentation/driver-model/bootdev.txt
@@ -0,0 +1,115 @@
+Boot Device Discovery Synchronization
+=====================================
+Boot devices are those devices that must be used or configured during the
+boot process. They may be explicitly specified as kernel command line
+parameters, such as console=ttyUSB0,115200, or implicitly specified, such as
+ip=dhcp.
+
+Earlier versions of the Linux kernel used a single-threaded approach to
+boot initialization. This took a number of seconds, which meant that
+devices were generally set up before being used or configured. Modern
+kernels use a multithreaded approach, which requires synchronization between
+code that probes and initializes boot devices, and code that uses and
+configures them.  Support of fine-grained boot concurrency requires
+distinguishing between types of boot devices, so that devices can be used as
+soon as they are initialized.
+
+There are several types of boot devices:
+-	consoles
+-	network devices
+-	block devices
+
+There is a distinction between the hardware type and the boot device type.
+From the hardware view, most any serial device can be used as a console,
+but console support is generally configured separately. For example, USB
+serial devices should be considered console boot devices only if the
+kernel is configured to support this usage. This is done by enabling the
+CONFIG_USB_SERIAL_CONSOLE option. If this option is disabled, the USB bus
+driver should not report that it has found any console devices.
+
+The sequence for buses with asynchronously-discoverable boot devices is:
+1.	As each possible boot devices is discovered, call bootdev_found.
+2.	Optionally, if the device type wasn't known at the time
+	bootdev_found was called but is determined later, call
+	bootdev_type_found when the type is found.
+3.	As initialization is complete for each device, call
+	bootdev_probe_done.
+
+Per-Device Functions
+--------------------
+Functions used to indicate the status of asynchronous device discovery on
+a device-by-device basis are:
+
+bootdev_found(int bootdev_mask)
+	This function must be called each time a possible boot device device
+	is found.  It is passed a bit mask created by ORing any of the
+	following flags that apply to the device found:
+		BOOTDEV_CONSOLE_MASK
+		BOOTDEV_NETDEV_MASK
+		BOOTDEV_BLOCK_MASK
+	There is no need to call this function for a given device if it is
+	known that it cannot be used as a boot device. If it is not
+	possible to determine whether a device is usable as a boot device,
+	or the specific type of a boot device, the argument BOOTDEV_ANY_MASK
+	should be passed.  This should be used only when necessary, as it
+	reduces the level of boot-time concurrency.
+
+bootdev_type_found(int bootdev_mask, enum bootdev_type type)
+	If the type of a boot device could not be found, but was determined
+	later, this function can be used to indicate the device type. It
+	is passed the mask that was originally passed to bootdev_found.
+	Note that, if a device for which bootdev_found is called is
+	subsequently determine not to be a possible boot device, this function
+	should not be called. Instead, bootdev_probe_done should be
+	called.
+
+bootdev_probe_done(int bootdev_mask)
+	This function indicates that initialization is complete for a device
+	which may be one of the boot device types indicated by bootdev_mask.
+	Note that calling this function does not imply that device
+	initialization has been successful; if bootdev_found is called for a
+	device, bootdev_probe_done must be called even if an error occurred.
+
+Some rules about correct usage:
+o	Each call to bootdev_found *must* be matched by a call to
+	bootdev_probe_done.
+o	The function bootdev_type_found may be used only once for a given
+	device and must be called between the calls to bootdev_found and
+	bootdev_probe_done for that device.
+o	If bootdev_type_found is called:
+	-	The value of bootdev_mask must be the same as that passed to
+		bootdev_found.
+	-	The bit corresponding to the type argument must have been set
+		in the bootdev_mask argument of bootdev_found.
+	-	The value of bootdev_mask in the call to bootdev_probe_done
+		must consist only of the bit corresponding to the argument
+		type passed to bootdev_type_found.
+o	If bootdev_type_found is not called, the value of bootdev_mask
+	passed to bootdev_found and bootdev_probe_done for a given
+	device must be identical.
+
+Subsystem Functions
+-------------------
+Boot devices are registered with the appropriate subsystem as they are found
+Each subsystem determines when the boot devices is manages are ready for use.
+
+bootdev_wait(enum bootdev_type type, bool (*done)(void))
+	Wait until one of two conditions is met:
+	o	All possible boot devices of the given type have been probed
+	o	The "done" function returns true
+
+	The type is one of:
+		BOOTDEV_CONSOLE
+		BOOTDEV_NETDEV
+		BOOTDEV_BLOCK
+	The "done" function is subsystem-dependent and returns true if all
+	boot devices required for that subsystem to continue booting have
+	been registered. Registration is indicated through use of the
+	bootdev_registered function. If done always returns false,
+	bootdev_wait will not return until all possible boot devices of the
+	given type have been probed.
+
+bootdev_registered(enum bootdev_type type)
+	Called by each software subsystem that handles boot devices of a given
+	type. For example, register_console would call this function with
+	a type of BOOTDEV_CONSOLE.
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index b5b8ba5..67eb834 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -3,7 +3,8 @@
 obj-y			:= core.o sys.o bus.o dd.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
-			   attribute_container.o transport_class.o
+			   attribute_container.o transport_class.o \
+			   bootdev.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_ISA)	+= isa.o
diff --git a/drivers/base/base.h b/drivers/base/base.h
index b528145..acf516f 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -90,6 +90,7 @@ struct device_private {
 	container_of(obj, struct device_private, knode_bus)
 
 /* initialisation functions */
+extern int bootdevs_init(void);
 extern int devices_init(void);
 extern int buses_init(void);
 extern int classes_init(void);
diff --git a/drivers/base/bootdev.c b/drivers/base/bootdev.c
new file mode 100644
index 0000000..fa6a12a
--- /dev/null
+++ b/drivers/base/bootdev.c
@@ -0,0 +1,189 @@
+/*
+ *			bootdev.c
+ *
+ * Primitives to synchronize boot device discovery and initialization with
+ * their boot-time use.
+ *
+ * Copyright (C) 2009  Scientific-Atlanta, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Author: David VomLehn
+ */
+
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/device.h>
+#include <linux/sched.h>
+#include <linux/async.h>
+
+/*
+ * Information about how many boot devices have been found, but for which
+ * probing activity is not yet complete, by type, along with wait queues on
+ * which a wake up will be done as the probing completes.
+ */
+static struct {
+	atomic_t		pending;
+	wait_queue_head_t	wq;
+} bootdev_info[BOOTDEV_NUM];
+
+__init int bootdevs_init(void)
+{
+	int	i;
+
+	for (i = 0; i < ARRAY_SIZE(bootdev_info); i++) {
+		atomic_set(&bootdev_info[i].pending, 0);
+		init_waitqueue_head(&bootdev_info[i].wq);
+	}
+
+	return 0;
+}
+
+/*
+ * Adds a console bit to the mask of boot devices if network consoles are used
+ * @mask:	Starting mask
+ *
+ * Returns mask with the %BOOTDEV_CONSOLE bit set if network consoles are
+ * configured into the system, since, from the boot device standpoint,
+ * a network device might be used as a console.
+ */
+#ifdef CONFIG_NETCONSOLE
+static int bootdev_add_netconsole(int bootdev_mask)
+{
+	return (bootdev_mask & BOOTDEV_NETDEV_MASK) ?
+		bootdev_mask | BOOTDEV_CONSOLE : bootdev_mask;
+}
+#else
+static int bootdev_add_netconsole(int bootdev_mask)
+{
+	return bootdev_mask;
+}
+#endif
+
+/**
+ * bootdev_found - called when a new device is discovered on a bus.
+ * @bootdev_mask:	Mask for possible devices
+ *
+ * The bootdev_mask allows a caller to specify a restricted set of boot
+ * devices that might be probed. For example, if the bus is USB, it may be
+ * the case that %CONFIG_USB_SERIAL_CONSOLE is not defined. The call to this
+ * function might then omit %BOOTDEV_CONSOLE from the mask. When we go to
+ * wait for console devices, we won't wait for USB probing to complete. If
+ * a given bus type has no way to determine the type of device being probed,
+ * it can simply pass %BOOTDEV_ALL_MASK, but finer granularity will generally
+ * result in faster boot times.
+ */
+void bootdev_found(int bootdev_mask)
+{
+	int	i;
+
+	bootdev_mask = bootdev_add_netconsole(bootdev_mask);
+
+	for (i = 0; i < ARRAY_SIZE(bootdev_info); i++) {
+		if (bootdev_mask & (1 << i))
+			atomic_inc(&bootdev_info[i].pending);
+	}
+}
+
+/**
+ * bootdev_type_found - called upon determining the type of a boot device
+ * @old_mask:	Mask used in the call to bootdev_found
+ * @type:	Type of the boot device
+ *
+ * If bootdev_found() was called but the type of the boot device was not
+ * yet available, this function can be called when the type is available.
+ * It allows waiters for boot devices of types other than the given @type
+ * to proceed.
+ */
+void bootdev_type_found(int old_mask, enum bootdev_type type)
+{
+	int	i;
+
+	old_mask = bootdev_add_netconsole(old_mask);
+
+	for (i = 0; i < ARRAY_SIZE(bootdev_info); i++) {
+		/* If this is one of the types we are dropping and we reduce
+		 * the pending count for that type of boot device to zero,
+		 * we need to wake up any waiters for that device. Otherwise,
+		 * we still have other devices being waited on and the wakeup
+		 * would be superfluous. */
+		if (i != type && (old_mask & (1 << i))) {
+			if (atomic_dec_return(&bootdev_info[i].pending) == 0)
+				wake_up_all(&bootdev_info[i].wq);
+		}
+	}
+}
+
+/**
+ * bootdev_probe_done - indicate probing is complete for a device on a bus
+ * @bootdev_mask:	Mask for possible devices
+ *
+ * The definition of probing complete for a given device is that the driver
+ * for that device must have been able to register its presence with its
+ * associated subsystem. So, devices supporting consoles must have called
+ * register_console(), networking device must have called register_netdevice(),
+ * etc.
+ */
+void bootdev_probe_done(int bootdev_mask)
+{
+	int	i;
+
+	bootdev_mask = bootdev_add_netconsole(bootdev_mask);
+
+	for (i = 0; i < ARRAY_SIZE(bootdev_info); i++) {
+		/* Decrement the count of pending probes and, if we reach
+		 * zero, wake up all waiters. */
+		if (bootdev_mask & (1 << i)) {
+			if (atomic_dec_return(&bootdev_info[i].pending) == 0)
+				wake_up_all(&bootdev_info[i].wq);
+		}
+	}
+}
+
+/**
+ * bootdev_wait - wait until desired boot devices are registered or probing done
+ * @type:	Type of boot device to wait for
+ * @done:	Pointer to function that determines whether all boot devices
+ *		have been acquired.
+ *
+ * This function exits if all devices of the given @type have been probed or
+ * the passed function indicates that all the expected boot devices have been
+ * acquired. Say, for example the kernel command line specifies the name of
+ * a boot device to use. The @done function can check to see whether that
+ * device has been registered and, if so, return true. This function will
+ * return even though probing has not completed on some devices, which allows
+ * faster boot times.
+ */
+void bootdev_wait(enum bootdev_type type, bool (*done)(void))
+{
+	/* Wait until bootdev_probe_done has been called for all of the devices
+	 * of the type for which we are waiting, or for some minimal set of
+	 * those devices to be ready. This last condition is defined by the
+	 * caller through the implementation of the callback function. */
+	wait_event(bootdev_info[type].wq,
+		done() || atomic_read(&bootdev_info[type].pending) == 0);
+}
+
+/**
+ * bootdev_registered - indicate boot device registration by its subsystem
+ * @type:	Type of boot device
+ *
+ * This will wake up all threads waiting on a given boot device @type so that
+ * they can see if they are ready to continue.
+ */
+void bootdev_registered(enum bootdev_type type)
+{
+	wake_up_all(&bootdev_info[type].wq);
+}
diff --git a/drivers/base/init.c b/drivers/base/init.c
index 7bd9b6a..694b0cb 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -21,6 +21,7 @@ void __init driver_init(void)
 {
 	/* These are the core pieces */
 	devices_init();
+	bootdevs_init();
 	buses_init();
 	classes_init();
 	firmware_init();
diff --git a/include/linux/device.h b/include/linux/device.h
index 6a69caa..39b6086 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -94,6 +94,37 @@ int __must_check bus_for_each_drv(struct bus_type *bus,
 void bus_sort_breadthfirst(struct bus_type *bus,
 			   int (*compare)(const struct device *a,
 					  const struct device *b));
+
+/*
+ * Definitions for synchronizing discovery of asynchronously-discoverable
+ * devices with their use as boot devices.
+ */
+/*
+ * Define boot device types. These are not the same as the device classes
+ * supported by various buses, but are tied to support of specific Linux kernel
+ * devices. For example, USB knows about serial devices, but a serial device
+ * is only a BOOTDEV_CONSOLE if CONFIG_USB_SERIAL_CONSOLE is defined.
+ */
+#define	BOOTDEV_CONSOLE_MASK	(1 << BOOTDEV_CONSOLE)
+#define	BOOTDEV_NETDEV_MASK	(1 << BOOTDEV_NETDEV)
+#define BOOTDEV_BLOCK_MASK	(1 << BOOTDEV_BLOCK)
+#define	BOOTDEV_ANY_MASK	((1 << BOOTDEV_NUM) - 1)
+
+enum bootdev_type {
+	BOOTDEV_CONSOLE,		/* Device usable as a console */
+	BOOTDEV_NETDEV,			/* Autoconfigurable network device */
+	BOOTDEV_BLOCK,			/* Block device for boot filesystem */
+	BOOTDEV_NUM			/* Number of boot devices */
+};
+
+extern void bootdev_start_search(void);
+extern void bootdev_found_all(void);
+extern void bootdev_found(int bootdev_mask);
+extern void bootdev_type_found(int bootdev_mask, enum bootdev_type);
+extern void bootdev_probe_done(int bootdev_mask);
+extern void bootdev_registered(enum bootdev_type type);
+extern void bootdev_wait(enum bootdev_type type, bool (*done)(void));
+
 /*
  * Bus notifiers: Get notified of addition/removal of devices
  * and binding/unbinding of drivers to devices.
