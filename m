Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbYIIEOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbYIIEOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYIIEI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:08:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42590 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbYIIEIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:08:17 -0400
From: Jarod Wilson <jwilson@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jwilson@redhat.com>, Jarod Wilson <jarod@redhat.com>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: [PATCH 01/18] lirc core device driver infrastructure
Date: Tue,  9 Sep 2008 00:05:46 -0400
Message-Id: <1220933164-10160-2-git-send-email-jwilson@redhat.com>
In-Reply-To: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Add Kconfig and Makefile bits
-Add device driver interface and headers

The initial Kconfig and Makefile bits were done by Mario Limonciello for
the Ubuntu kernel, but have been tweaked a bit since then. Any errors are
probably my doing.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Janne Grunau <j@jannau.net>
CC: Christoph Bartelmus <lirc@bartelmus.de>
CC: Mario Limonciello <superm1@ubuntu.com>
---
 MAINTAINERS                   |    9 +
 drivers/input/Kconfig         |    2 +
 drivers/input/Makefile        |    2 +
 drivers/input/lirc/Kconfig    |   21 +
 drivers/input/lirc/Makefile   |    8 +
 drivers/input/lirc/lirc.h     |  103 ++++++
 drivers/input/lirc/lirc_dev.c |  809 +++++++++++++++++++++++++++++++++++++++++
 drivers/input/lirc/lirc_dev.h |  262 +++++++++++++
 8 files changed, 1216 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/lirc/Kconfig
 create mode 100644 drivers/input/lirc/Makefile
 create mode 100644 drivers/input/lirc/lirc.h
 create mode 100644 drivers/input/lirc/lirc_dev.c
 create mode 100644 drivers/input/lirc/lirc_dev.h

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 5f9d860..2ba0904 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -170,6 +170,8 @@ source "drivers/input/tablet/Kconfig"
 
 source "drivers/input/touchscreen/Kconfig"
 
+source "drivers/input/lirc/Kconfig"
+
 source "drivers/input/misc/Kconfig"
 
 endif
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 98c4f9a..4dcb852 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -25,3 +25,5 @@ obj-$(CONFIG_INPUT_MISC)	+= misc/
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
 
 obj-$(CONFIG_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
+
+obj-$(CONFIG_INPUT_LIRC)	+= lirc/
diff --git a/drivers/input/lirc/Kconfig b/drivers/input/lirc/Kconfig
new file mode 100644
index 0000000..2a04d9b
--- /dev/null
+++ b/drivers/input/lirc/Kconfig
@@ -0,0 +1,21 @@
+#
+# LIRC driver(s) configuration
+#
+menuconfig INPUT_LIRC
+	bool "Linux Infrared Remote Control IR receiver/transmitter drivers"
+	default n
+	help
+	  Say Y here, and all supported Linux Infrared Remote Control IR and
+	  RF receiver and transmitter drivers will be displayed. When paired
+	  with a remote control and the lirc daemon, the receiver drivers
+	  allow control of your Linux system via remote control.
+
+if INPUT_LIRC
+
+config LIRC_DEV
+	tristate "LIRC device loadable module support"
+	default n
+	help
+	  LIRC device loadable module support, required for most LIRC drivers
+
+endif
diff --git a/drivers/input/lirc/Makefile b/drivers/input/lirc/Makefile
new file mode 100644
index 0000000..cdb4c45
--- /dev/null
+++ b/drivers/input/lirc/Makefile
@@ -0,0 +1,8 @@
+# Makefile for the lirc drivers.
+#
+
+# Each configuration option enables a list of files.
+
+EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER -I$(src)
+
+obj-$(CONFIG_LIRC_DEV)		+= lirc_dev.o
diff --git a/drivers/input/lirc/lirc.h b/drivers/input/lirc/lirc.h
new file mode 100644
index 0000000..dcdb6e8
--- /dev/null
+++ b/drivers/input/lirc/lirc.h
@@ -0,0 +1,103 @@
+/*
+ * lirc.h - linux infrared remote control header file
+ * last modified 2007/09/27
+ */
+
+#ifndef _LINUX_LIRC_H
+#define _LINUX_LIRC_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define PULSE_BIT  0x01000000
+#define PULSE_MASK 0x00FFFFFF
+
+/*
+ * lirc compatible hardware features
+ */
+
+
+#define LIRC_MODE2SEND(x) (x)
+#define LIRC_SEND2MODE(x) (x)
+#define LIRC_MODE2REC(x) ((x) << 16)
+#define LIRC_REC2MODE(x) ((x) >> 16)
+
+#define LIRC_MODE_RAW                  0x00000001
+#define LIRC_MODE_PULSE                0x00000002
+#define LIRC_MODE_MODE2                0x00000004
+#define LIRC_MODE_CODE                 0x00000008
+#define LIRC_MODE_LIRCCODE             0x00000010
+#define LIRC_MODE_STRING               0x00000020
+
+
+#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
+#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
+#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_CODE             LIRC_MODE2SEND(LIRC_MODE_CODE)
+#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
+#define LIRC_CAN_SEND_STRING           LIRC_MODE2SEND(LIRC_MODE_STRING)
+
+#define LIRC_CAN_SEND_MASK             0x0000003f
+
+#define LIRC_CAN_SET_SEND_CARRIER      0x00000100
+#define LIRC_CAN_SET_SEND_DUTY_CYCLE   0x00000200
+#define LIRC_CAN_SET_TRANSMITTER_MASK  0x00000400
+
+#define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
+#define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
+#define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
+#define LIRC_CAN_REC_CODE              LIRC_MODE2REC(LIRC_MODE_CODE)
+#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
+#define LIRC_CAN_REC_STRING            LIRC_MODE2REC(LIRC_MODE_STRING)
+
+#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
+
+#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
+#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
+
+#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
+#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
+#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
+
+#define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
+#define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
+
+#define LIRC_CAN_NOTIFY_DECODE            0x01000000
+
+/*
+ * IOCTL commands for lirc driver
+ */
+
+#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
+
+#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
+#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
+#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
+#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
+#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
+#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, __u32)
+#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
+
+/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
+#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
+
+#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
+#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
+/* Note: these can reset the according pulse_width */
+#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
+#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
+#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
+#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, __u32)
+#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
+
+/* to set a range use
+   LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE with the
+   lower bound first and later
+   LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper bound */
+
+#define LIRC_SET_REC_DUTY_CYCLE_RANGE  _IOW('i', 0x0000001e, __u32)
+#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
+
+#define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
+
+#endif
diff --git a/drivers/input/lirc/lirc_dev.c b/drivers/input/lirc/lirc_dev.c
new file mode 100644
index 0000000..c8f325c
--- /dev/null
+++ b/drivers/input/lirc/lirc_dev.c
@@ -0,0 +1,809 @@
+/*
+ * LIRC base driver
+ *
+ * (L) by Artur Lipowski <alipowski@interia.pl>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/version.h>
+
+#include <linux/autoconf.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/ioctl.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/smp_lock.h>
+#include <linux/completion.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+#include <linux/semaphore.h>
+#define __KERNEL_SYSCALLS__
+#include <linux/unistd.h>
+#include <linux/kthread.h>
+
+/* SysFS header */
+#include <linux/device.h>
+
+#include "lirc.h"
+#include "lirc_dev.h"
+
+static int debug;
+#define dprintk(fmt, args...)					\
+	do {							\
+		if (debug)					\
+			printk(KERN_DEBUG fmt, ## args);	\
+	} while (0)
+
+#define IRCTL_DEV_NAME    "BaseRemoteCtl"
+#define SUCCESS           0
+#define NOPLUG            -1
+#define LOGHEAD           "lirc_dev (%s[%d]): "
+
+struct irctl {
+	struct lirc_plugin p;
+	int attached;
+	int open;
+
+	struct mutex buffer_lock;
+	struct lirc_buffer *buf;
+
+	struct task_struct *task;
+	long jiffies_to_wait;
+
+};
+
+static DEFINE_MUTEX(plugin_lock);
+
+static struct irctl irctls[MAX_IRCTL_DEVICES];
+static struct file_operations fops;
+
+/* Only used for sysfs but defined to void otherwise */
+static struct class *lirc_class;
+
+/*  helper function
+ *  initializes the irctl structure
+ */
+static inline void init_irctl(struct irctl *ir)
+{
+	memset(&ir->p, 0, sizeof(struct lirc_plugin));
+	mutex_init(&ir->buffer_lock);
+	ir->p.minor = NOPLUG;
+
+	ir->task = NULL;
+	ir->jiffies_to_wait = 0;
+
+	ir->open = 0;
+	ir->attached = 0;
+}
+
+static void cleanup(struct irctl *ir)
+{
+	dprintk(LOGHEAD "cleaning up\n", ir->p.name, ir->p.minor);
+
+	device_destroy(lirc_class, MKDEV(IRCTL_DEV_MAJOR, ir->p.minor));
+
+	if (ir->buf != ir->p.rbuf) {
+		lirc_buffer_free(ir->buf);
+		kfree(ir->buf);
+	}
+	ir->buf = NULL;
+
+	init_irctl(ir);
+}
+
+/*  helper function
+ *  reads key codes from plugin and puts them into buffer
+ *  buffer free space is checked and locking performed
+ *  returns 0 on success
+ */
+static inline int add_to_buf(struct irctl *ir)
+{
+	if (lirc_buffer_full(ir->buf)) {
+		dprintk(LOGHEAD "buffer overflow\n",
+			ir->p.name, ir->p.minor);
+		return -EOVERFLOW;
+	}
+
+	if (ir->p.add_to_buf) {
+		int res = -ENODATA;
+		int got_data = 0;
+
+		/* service the device as long as it is returning
+		 * data and we have space
+		 */
+		while (!lirc_buffer_full(ir->buf)) {
+			res = ir->p.add_to_buf(ir->p.data, ir->buf);
+			if (res == SUCCESS)
+				got_data++;
+			else
+				break;
+		}
+
+		if (res == -ENODEV)
+			kthread_stop(ir->task);
+
+		return got_data ? SUCCESS : res;
+	}
+
+	return SUCCESS;
+}
+
+/* main function of the polling thread
+ */
+static int lirc_thread(void *irctl)
+{
+	struct irctl *ir = irctl;
+
+	/* This thread doesn't need any user-level access,
+	 * so get rid of all our resources
+	 */
+
+	dprintk(LOGHEAD "poll thread started\n", ir->p.name, ir->p.minor);
+
+	do {
+		if (ir->open) {
+			if (ir->jiffies_to_wait) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule_timeout(ir->jiffies_to_wait);
+			} else {
+				interruptible_sleep_on(
+					ir->p.get_queue(ir->p.data));
+			}
+			if (kthread_should_stop())
+				break;
+			if (!add_to_buf(ir))
+				wake_up_interruptible(&ir->buf->wait_poll);
+		} else {
+			/* if device not opened so we can sleep half a second */
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(HZ/2);
+		}
+	} while (!kthread_should_stop());
+
+	dprintk(LOGHEAD "poll thread ended\n", ir->p.name, ir->p.minor);
+
+	return 0;
+}
+
+int lirc_register_plugin(struct lirc_plugin *p)
+{
+	struct irctl *ir;
+	int minor;
+	int bytes_in_key;
+	int err;
+	DECLARE_COMPLETION(tn);
+
+	if (!p) {
+		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+		       "plugin pointer must be not NULL!\n");
+		err = -EBADRQC;
+		goto out;
+	}
+
+	if (MAX_IRCTL_DEVICES <= p->minor) {
+		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+		       "\"minor\" must be between 0 and %d (%d)!\n",
+		       MAX_IRCTL_DEVICES-1, p->minor);
+		err = -EBADRQC;
+		goto out;
+	}
+
+	if (1 > p->code_length || (BUFLEN * 8) < p->code_length) {
+		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+		       "code length in bits for minor (%d) "
+		       "must be less than %d!\n",
+		       p->minor, BUFLEN * 8);
+		err = -EBADRQC;
+		goto out;
+	}
+
+	printk(KERN_INFO "lirc_dev: lirc_register_plugin: sample_rate: %d\n",
+		p->sample_rate);
+	if (p->sample_rate) {
+		if (2 > p->sample_rate || HZ < p->sample_rate) {
+			printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+			       "sample_rate must be between 2 and %d!\n", HZ);
+			err = -EBADRQC;
+			goto out;
+		}
+		if (!p->add_to_buf) {
+			printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+			       "add_to_buf cannot be NULL when "
+			       "sample_rate is set\n");
+			err = -EBADRQC;
+			goto out;
+		}
+	} else if (!(p->fops && p->fops->read)
+		   && !p->get_queue && !p->rbuf) {
+		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+		       "fops->read, get_queue and rbuf "
+		       "cannot all be NULL!\n");
+		err = -EBADRQC;
+		goto out;
+	} else if (!p->get_queue && !p->rbuf) {
+		if (!(p->fops && p->fops->read && p->fops->poll)
+		    || (!p->fops->ioctl && !p->ioctl)) {
+			printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+			       "neither read, poll nor ioctl can be NULL!\n");
+			err = -EBADRQC;
+			goto out;
+		}
+	}
+
+	if (p->owner == NULL) {
+		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+				    "no module owner registered\n");
+		err = -EBADRQC;
+		goto out;
+	}
+
+	mutex_lock(&plugin_lock);
+
+	minor = p->minor;
+
+	if (0 > minor) {
+		/* find first free slot for plugin */
+		for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
+			if (irctls[minor].p.minor == NOPLUG)
+				break;
+		if (MAX_IRCTL_DEVICES == minor) {
+			printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+			       "no free slots for plugins!\n");
+			err = -ENOMEM;
+			goto out_lock;
+		}
+	} else if (irctls[minor].p.minor != NOPLUG) {
+		printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+		       "minor (%d) just registered!\n", minor);
+		err = -EBUSY;
+		goto out_lock;
+	}
+
+	ir = &irctls[minor];
+
+	if (p->sample_rate) {
+		ir->jiffies_to_wait = HZ / p->sample_rate;
+	} else {
+		/* it means - wait for external event in task queue */
+		ir->jiffies_to_wait = 0;
+	}
+
+	/* some safety check 8-) */
+	p->name[sizeof(p->name)-1] = '\0';
+
+	bytes_in_key = p->code_length/8 + (p->code_length%8 ? 1 : 0);
+
+	if (p->rbuf) {
+		ir->buf = p->rbuf;
+	} else {
+		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+		if (!ir->buf) {
+			err = -ENOMEM;
+			goto out_lock;
+		}
+		if (lirc_buffer_init(ir->buf, bytes_in_key,
+				     BUFLEN/bytes_in_key) != 0) {
+			kfree(ir->buf);
+			err = -ENOMEM;
+			goto out_lock;
+		}
+	}
+
+	if (p->features == 0)
+		p->features = (p->code_length > 8) ?
+			LIRC_CAN_REC_LIRCCODE : LIRC_CAN_REC_CODE;
+
+	ir->p = *p;
+	ir->p.minor = minor;
+
+	device_create(lirc_class, ir->p.dev,
+		      MKDEV(IRCTL_DEV_MAJOR, ir->p.minor), NULL,
+		      "lirc%u", ir->p.minor);
+
+	if (p->sample_rate || p->get_queue) {
+		/* try to fire up polling thread */
+		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
+		if (IS_ERR(ir->task)) {
+			printk(KERN_ERR "lirc_dev: lirc_register_plugin: "
+			       "cannot run poll thread for minor = %d\n",
+			       p->minor);
+			err = -ECHILD;
+			goto out_sysfs;
+		}
+	}
+	ir->attached = 1;
+	mutex_unlock(&plugin_lock);
+
+/*
+ * Recent kernels should handle this autmatically by increasing/decreasing
+ * use count when a dependant module is loaded/unloaded.
+ */
+	dprintk("lirc_dev: plugin %s registered at minor number = %d\n",
+		ir->p.name, ir->p.minor);
+	p->minor = minor;
+	return minor;
+
+out_sysfs:
+	device_destroy(lirc_class, MKDEV(IRCTL_DEV_MAJOR, ir->p.minor));
+out_lock:
+	mutex_unlock(&plugin_lock);
+out:
+	return err;
+}
+EXPORT_SYMBOL(lirc_register_plugin);
+
+int lirc_unregister_plugin(int minor)
+{
+	struct irctl *ir;
+	DECLARE_COMPLETION(tn);
+	DECLARE_COMPLETION(tn2);
+
+	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
+		printk(KERN_ERR "lirc_dev: lirc_unregister_plugin: "
+		       "\"minor\" must be between 0 and %d!\n",
+		       MAX_IRCTL_DEVICES-1);
+		return -EBADRQC;
+	}
+
+	ir = &irctls[minor];
+
+	mutex_lock(&plugin_lock);
+
+	if (ir->p.minor != minor) {
+		printk(KERN_ERR "lirc_dev: lirc_unregister_plugin: "
+		       "minor (%d) device not registered!", minor);
+		mutex_unlock(&plugin_lock);
+		return -ENOENT;
+	}
+
+	/* end up polling thread */
+	if (ir->task) {
+		wake_up_process(ir->task);
+		kthread_stop(ir->task);
+	}
+
+	dprintk("lirc_dev: plugin %s unregistered from minor number = %d\n",
+		ir->p.name, ir->p.minor);
+
+	ir->attached = 0;
+	if (ir->open) {
+		dprintk(LOGHEAD "releasing opened plugin\n",
+			ir->p.name, ir->p.minor);
+		wake_up_interruptible(&ir->buf->wait_poll);
+		mutex_lock(&ir->buffer_lock);
+		ir->p.set_use_dec(ir->p.data);
+		module_put(ir->p.owner);
+		mutex_unlock(&ir->buffer_lock);
+	} else
+		cleanup(ir);
+	mutex_unlock(&plugin_lock);
+
+/*
+ * Recent kernels should handle this autmatically by increasing/decreasing
+ * use count when a dependant module is loaded/unloaded.
+ */
+
+	return SUCCESS;
+}
+EXPORT_SYMBOL(lirc_unregister_plugin);
+
+/*
+ *
+ */
+static int irctl_open(struct inode *inode, struct file *file)
+{
+	struct irctl *ir;
+	int retval;
+
+	if (MINOR(inode->i_rdev) >= MAX_IRCTL_DEVICES) {
+		dprintk("lirc_dev [%d]: open result = -ENODEV\n",
+			MINOR(inode->i_rdev));
+		return -ENODEV;
+	}
+
+	ir = &irctls[MINOR(inode->i_rdev)];
+
+	dprintk(LOGHEAD "open called\n", ir->p.name, ir->p.minor);
+
+	/* if the plugin has an open function use it instead */
+	if (ir->p.fops && ir->p.fops->open)
+		return ir->p.fops->open(inode, file);
+
+	if (mutex_lock_interruptible(&plugin_lock))
+		return -ERESTARTSYS;
+
+	if (ir->p.minor == NOPLUG) {
+		mutex_unlock(&plugin_lock);
+		dprintk(LOGHEAD "open result = -ENODEV\n",
+			ir->p.name, ir->p.minor);
+		return -ENODEV;
+	}
+
+	if (ir->open) {
+		mutex_unlock(&plugin_lock);
+		dprintk(LOGHEAD "open result = -EBUSY\n",
+			ir->p.name, ir->p.minor);
+		return -EBUSY;
+	}
+
+	/* there is no need for locking here because ir->open is 0
+	 * and lirc_thread isn't using buffer
+	 * plugins which use irq's should allocate them on set_use_inc,
+	 * so there should be no problem with those either.
+	 */
+	ir->buf->head = ir->buf->tail;
+	ir->buf->fill = 0;
+
+	if (ir->p.owner != NULL && try_module_get(ir->p.owner)) {
+		++ir->open;
+		retval = ir->p.set_use_inc(ir->p.data);
+
+		if (retval != SUCCESS) {
+			module_put(ir->p.owner);
+			--ir->open;
+		}
+	} else {
+		if (ir->p.owner == NULL)
+			dprintk(LOGHEAD "no module owner!!!\n",
+				ir->p.name, ir->p.minor);
+
+		retval = -ENODEV;
+	}
+
+	dprintk(LOGHEAD "open result = %d\n", ir->p.name, ir->p.minor, retval);
+	mutex_unlock(&plugin_lock);
+
+	return retval;
+}
+
+/*
+ *
+ */
+static int irctl_close(struct inode *inode, struct file *file)
+{
+	struct irctl *ir = &irctls[MINOR(inode->i_rdev)];
+
+	dprintk(LOGHEAD "close called\n", ir->p.name, ir->p.minor);
+
+	/* if the plugin has a close function use it instead */
+	if (ir->p.fops && ir->p.fops->release)
+		return ir->p.fops->release(inode, file);
+
+	if (mutex_lock_interruptible(&plugin_lock))
+		return -ERESTARTSYS;
+
+	--ir->open;
+	if (ir->attached) {
+		ir->p.set_use_dec(ir->p.data);
+		module_put(ir->p.owner);
+	} else {
+		cleanup(ir);
+	}
+
+	mutex_unlock(&plugin_lock);
+
+	return SUCCESS;
+}
+
+/*
+ *
+ */
+static unsigned int irctl_poll(struct file *file, poll_table *wait)
+{
+	struct irctl *ir = &irctls[MINOR(file->f_dentry->d_inode->i_rdev)];
+	unsigned int ret;
+
+	dprintk(LOGHEAD "poll called\n", ir->p.name, ir->p.minor);
+
+	/* if the plugin has a poll function use it instead */
+	if (ir->p.fops && ir->p.fops->poll)
+		return ir->p.fops->poll(file, wait);
+
+	mutex_lock(&ir->buffer_lock);
+	if (!ir->attached) {
+		mutex_unlock(&ir->buffer_lock);
+		return POLLERR;
+	}
+
+	poll_wait(file, &ir->buf->wait_poll, wait);
+
+	dprintk(LOGHEAD "poll result = %s\n",
+		ir->p.name, ir->p.minor,
+		lirc_buffer_empty(ir->buf) ? "0" : "POLLIN|POLLRDNORM");
+
+	ret = lirc_buffer_empty(ir->buf) ? 0 : (POLLIN|POLLRDNORM);
+
+	mutex_unlock(&ir->buffer_lock);
+	return ret;
+}
+
+/*
+ *
+ */
+static int irctl_ioctl(struct inode *inode, struct file *file,
+		       unsigned int cmd, unsigned long arg)
+{
+	unsigned long mode;
+	int result;
+	struct irctl *ir = &irctls[MINOR(inode->i_rdev)];
+
+	dprintk(LOGHEAD "ioctl called (0x%x)\n",
+		ir->p.name, ir->p.minor, cmd);
+
+	/* if the plugin has a ioctl function use it instead */
+	if (ir->p.fops && ir->p.fops->ioctl)
+		return ir->p.fops->ioctl(inode, file, cmd, arg);
+
+	if (ir->p.minor == NOPLUG || !ir->attached) {
+		dprintk(LOGHEAD "ioctl result = -ENODEV\n",
+			ir->p.name, ir->p.minor);
+		return -ENODEV;
+	}
+
+	/* Give the plugin a chance to handle the ioctl */
+	if (ir->p.ioctl) {
+		result = ir->p.ioctl(inode, file, cmd, arg);
+		if (result != -ENOIOCTLCMD)
+			return result;
+	}
+	/* The plugin can't handle cmd */
+	result = SUCCESS;
+
+	switch (cmd) {
+	case LIRC_GET_FEATURES:
+		result = put_user(ir->p.features, (unsigned long *)arg);
+		break;
+	case LIRC_GET_REC_MODE:
+		if (!(ir->p.features&LIRC_CAN_REC_MASK))
+			return -ENOSYS;
+
+		result = put_user(LIRC_REC2MODE
+				  (ir->p.features&LIRC_CAN_REC_MASK),
+				  (unsigned long *)arg);
+		break;
+	case LIRC_SET_REC_MODE:
+		if (!(ir->p.features&LIRC_CAN_REC_MASK))
+			return -ENOSYS;
+
+		result = get_user(mode, (unsigned long *)arg);
+		if (!result && !(LIRC_MODE2REC(mode) & ir->p.features))
+			result = -EINVAL;
+		/*
+		 * FIXME: We should actually set the mode somehow but
+		 * for now, lirc_serial doesn't support mode changing either
+		 */
+		break;
+	case LIRC_GET_LENGTH:
+		result = put_user((unsigned long)ir->p.code_length,
+				  (unsigned long *)arg);
+		break;
+	default:
+		result = -ENOIOCTLCMD;
+	}
+
+	dprintk(LOGHEAD "ioctl result = %d\n",
+		ir->p.name, ir->p.minor, result);
+
+	return result;
+}
+
+/*
+ *
+ */
+static ssize_t irctl_read(struct file *file,
+			  char *buffer,
+			  size_t length,
+			  loff_t *ppos)
+{
+	struct irctl *ir = &irctls[MINOR(file->f_dentry->d_inode->i_rdev)];
+	unsigned char buf[ir->buf->chunk_size];
+	int ret = 0, written = 0;
+	DECLARE_WAITQUEUE(wait, current);
+
+	dprintk(LOGHEAD "read called\n", ir->p.name, ir->p.minor);
+
+	/* if the plugin has a specific read function use it instead */
+	if (ir->p.fops && ir->p.fops->read)
+		return ir->p.fops->read(file, buffer, length, ppos);
+
+	if (mutex_lock_interruptible(&ir->buffer_lock))
+		return -ERESTARTSYS;
+	if (!ir->attached) {
+		mutex_unlock(&ir->buffer_lock);
+		return -ENODEV;
+	}
+
+	if (length % ir->buf->chunk_size) {
+		dprintk(LOGHEAD "read result = -EINVAL\n",
+			ir->p.name, ir->p.minor);
+		mutex_unlock(&ir->buffer_lock);
+		return -EINVAL;
+	}
+
+	/*
+	 * we add ourselves to the task queue before buffer check
+	 * to avoid losing scan code (in case when queue is awaken somewhere
+	 * beetwen while condition checking and scheduling)
+	 */
+	add_wait_queue(&ir->buf->wait_poll, &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	/*
+	 * while we did't provide 'length' bytes, device is opened in blocking
+	 * mode and 'copy_to_user' is happy, wait for data.
+	 */
+	while (written < length && ret == 0) {
+		if (lirc_buffer_empty(ir->buf)) {
+			/* According to the read(2) man page, 'written' can be
+			 * returned as less than 'length', instead of blocking
+			 * again, returning -EWOULDBLOCK, or returning
+			 * -ERESTARTSYS */
+			if (written)
+				break;
+			if (file->f_flags & O_NONBLOCK) {
+				ret = -EWOULDBLOCK;
+				break;
+			}
+			if (signal_pending(current)) {
+				ret = -ERESTARTSYS;
+				break;
+			}
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (!ir->attached) {
+				ret = -ENODEV;
+				break;
+			}
+		} else {
+			lirc_buffer_read_1(ir->buf, buf);
+			ret = copy_to_user((void *)buffer+written, buf,
+					   ir->buf->chunk_size);
+			written += ir->buf->chunk_size;
+		}
+	}
+
+	remove_wait_queue(&ir->buf->wait_poll, &wait);
+	set_current_state(TASK_RUNNING);
+	mutex_unlock(&ir->buffer_lock);
+
+	dprintk(LOGHEAD "read result = %s (%d)\n",
+		ir->p.name, ir->p.minor, ret ? "-EFAULT" : "OK", ret);
+
+	return ret ? ret : written;
+}
+
+
+void *lirc_get_pdata(struct file *file)
+{
+	void *data = NULL;
+
+	if (file && file->f_dentry && file->f_dentry->d_inode &&
+	    file->f_dentry->d_inode->i_rdev) {
+		struct irctl *ir;
+		ir = &irctls[MINOR(file->f_dentry->d_inode->i_rdev)];
+		data = ir->p.data;
+	}
+
+	return data;
+}
+EXPORT_SYMBOL(lirc_get_pdata);
+
+
+static ssize_t irctl_write(struct file *file, const char *buffer,
+			   size_t length, loff_t *ppos)
+{
+	struct irctl *ir = &irctls[MINOR(file->f_dentry->d_inode->i_rdev)];
+
+	dprintk(LOGHEAD "write called\n", ir->p.name, ir->p.minor);
+
+	/* if the plugin has a specific read function use it instead */
+	if (ir->p.fops && ir->p.fops->write)
+		return ir->p.fops->write(file, buffer, length, ppos);
+
+	if (!ir->attached)
+		return -ENODEV;
+
+	return -EINVAL;
+}
+
+
+static struct file_operations fops = {
+	.read		= irctl_read,
+	.write		= irctl_write,
+	.poll		= irctl_poll,
+	.ioctl		= irctl_ioctl,
+	.open		= irctl_open,
+	.release	= irctl_close
+};
+
+
+static int lirc_dev_init(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_IRCTL_DEVICES; ++i)
+		init_irctl(&irctls[i]);
+
+	if (register_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME, &fops)) {
+		printk(KERN_ERR "lirc_dev: register_chrdev failed\n");
+		goto out;
+	}
+
+	lirc_class = class_create(THIS_MODULE, "lirc");
+	if (IS_ERR(lirc_class)) {
+		printk(KERN_ERR "lirc_dev: class_create failed\n");
+		goto out_unregister;
+	}
+
+	printk(KERN_INFO "lirc_dev: IR Remote Control driver registered, "
+	       "major %d \n", IRCTL_DEV_MAJOR);
+
+	return SUCCESS;
+
+out_unregister:
+	/* unregister_chrdev returns void now */
+	unregister_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME);
+out:
+	return -1;
+}
+
+/* ---------------------------------------------------------------------- */
+
+#ifdef MODULE
+
+/*
+ *
+ */
+int init_module(void)
+{
+	return lirc_dev_init();
+}
+
+/*
+ *
+ */
+void cleanup_module(void)
+{
+	/* unregister_chrdev returns void now */
+	unregister_chrdev(IRCTL_DEV_MAJOR, IRCTL_DEV_NAME);
+	class_destroy(lirc_class);
+	dprintk("lirc_dev: module unloaded\n");
+}
+
+MODULE_DESCRIPTION("LIRC base driver module");
+MODULE_AUTHOR("Artur Lipowski");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(IRCTL_DEV_MAJOR);
+
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Enable debugging messages");
+
+#else /* not a MODULE */
+subsys_initcall(lirc_dev_init);
+
+#endif /* MODULE */
+
+/*
+ * Overrides for Emacs so that we follow Linus's tabbing style.
+ * ---------------------------------------------------------------------------
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */
diff --git a/drivers/input/lirc/lirc_dev.h b/drivers/input/lirc/lirc_dev.h
new file mode 100644
index 0000000..920dd43
--- /dev/null
+++ b/drivers/input/lirc/lirc_dev.h
@@ -0,0 +1,262 @@
+/*
+ * LIRC base driver
+ *
+ * (L) by Artur Lipowski <alipowski@interia.pl>
+ *        This code is licensed under GNU GPL
+ *
+ */
+
+#ifndef _LINUX_LIRC_DEV_H
+#define _LINUX_LIRC_DEV_H
+
+#define MAX_IRCTL_DEVICES 4
+#define BUFLEN            16
+
+/* #define LIRC_BUFF_POWER_OF_2 */
+#ifdef LIRC_BUFF_POWER_OF_2
+#define mod(n, div) ((n) & ((div) - 1))
+#else
+#define mod(n, div) ((n) % (div))
+#endif
+#include <linux/slab.h>
+#include <linux/fs.h>
+
+struct lirc_buffer {
+	wait_queue_head_t wait_poll;
+	spinlock_t lock;
+
+	unsigned char *data;
+	unsigned int chunk_size;
+	unsigned int size; /* in chunks */
+	unsigned int fill; /* in chunks */
+	int head, tail;    /* in chunks */
+	/* Using chunks instead of bytes pretends to simplify boundary checking
+	 * And should allow for some performance fine tunning later */
+};
+static inline void _lirc_buffer_clear(struct lirc_buffer *buf)
+{
+	buf->head = 0;
+	buf->tail = 0;
+	buf->fill = 0;
+}
+static inline int lirc_buffer_init(struct lirc_buffer *buf,
+				    unsigned int chunk_size,
+				    unsigned int size)
+{
+	/* Adjusting size to the next power of 2 would allow for
+	 * inconditional LIRC_BUFF_POWER_OF_2 optimization */
+	init_waitqueue_head(&buf->wait_poll);
+	spin_lock_init(&buf->lock);
+	_lirc_buffer_clear(buf);
+	buf->chunk_size = chunk_size;
+	buf->size = size;
+	buf->data = kmalloc(size*chunk_size, GFP_KERNEL);
+	if (buf->data == NULL)
+		return -1;
+	memset(buf->data, 0, size*chunk_size);
+	return 0;
+}
+static inline void lirc_buffer_free(struct lirc_buffer *buf)
+{
+	kfree(buf->data);
+	buf->data = NULL;
+	buf->head = 0;
+	buf->tail = 0;
+	buf->fill = 0;
+	buf->chunk_size = 0;
+	buf->size = 0;
+}
+static inline int  lirc_buffer_full(struct lirc_buffer *buf)
+{
+	return buf->fill >= buf->size;
+}
+static inline int  lirc_buffer_empty(struct lirc_buffer *buf)
+{
+	return !(buf->fill);
+}
+static inline int  lirc_buffer_available(struct lirc_buffer *buf)
+{
+    return buf->size - buf->fill;
+}
+static inline void lirc_buffer_lock(struct lirc_buffer *buf,
+				    unsigned long *flags)
+{
+	spin_lock_irqsave(&buf->lock, *flags);
+}
+static inline void lirc_buffer_unlock(struct lirc_buffer *buf,
+				      unsigned long *flags)
+{
+	spin_unlock_irqrestore(&buf->lock, *flags);
+}
+static inline void lirc_buffer_clear(struct lirc_buffer *buf)
+{
+	unsigned long flags;
+	lirc_buffer_lock(buf, &flags);
+	_lirc_buffer_clear(buf);
+	lirc_buffer_unlock(buf, &flags);
+}
+static inline void _lirc_buffer_remove_1(struct lirc_buffer *buf)
+{
+	buf->head = mod(buf->head+1, buf->size);
+	buf->fill -= 1;
+}
+static inline void lirc_buffer_remove_1(struct lirc_buffer *buf)
+{
+	unsigned long flags;
+	lirc_buffer_lock(buf, &flags);
+	_lirc_buffer_remove_1(buf);
+	lirc_buffer_unlock(buf, &flags);
+}
+static inline void _lirc_buffer_read_1(struct lirc_buffer *buf,
+				     unsigned char *dest)
+{
+	memcpy(dest, &buf->data[buf->head*buf->chunk_size], buf->chunk_size);
+	buf->head = mod(buf->head+1, buf->size);
+	buf->fill -= 1;
+}
+static inline void lirc_buffer_read_1(struct lirc_buffer *buf,
+				      unsigned char *dest)
+{
+	unsigned long flags;
+	lirc_buffer_lock(buf, &flags);
+	_lirc_buffer_read_1(buf, dest);
+	lirc_buffer_unlock(buf, &flags);
+}
+static inline void _lirc_buffer_write_1(struct lirc_buffer *buf,
+				      unsigned char *orig)
+{
+	memcpy(&buf->data[buf->tail*buf->chunk_size], orig, buf->chunk_size);
+	buf->tail = mod(buf->tail+1, buf->size);
+	buf->fill++;
+}
+static inline void lirc_buffer_write_1(struct lirc_buffer *buf,
+				       unsigned char *orig)
+{
+	unsigned long flags;
+	lirc_buffer_lock(buf, &flags);
+	_lirc_buffer_write_1(buf, orig);
+	lirc_buffer_unlock(buf, &flags);
+}
+static inline void _lirc_buffer_write_n(struct lirc_buffer *buf,
+					unsigned char *orig, int count)
+{
+	memcpy(&buf->data[buf->tail * buf->chunk_size], orig,
+	       count * buf->chunk_size);
+	buf->tail = mod(buf->tail + count, buf->size);
+	buf->fill += count;
+}
+static inline void lirc_buffer_write_n(struct lirc_buffer *buf,
+				       unsigned char *orig, int count)
+{
+	unsigned long flags;
+	int space1;
+
+	lirc_buffer_lock(buf, &flags);
+	if (buf->head > buf->tail)
+		space1 = buf->head - buf->tail;
+	else
+		space1 = buf->size - buf->tail;
+
+	if (count > space1) {
+		_lirc_buffer_write_n(buf, orig, space1);
+		_lirc_buffer_write_n(buf, orig+(space1*buf->chunk_size),
+				     count-space1);
+	} else {
+		_lirc_buffer_write_n(buf, orig, count);
+	}
+	lirc_buffer_unlock(buf, &flags);
+}
+
+struct lirc_plugin {
+	char name[40];
+	int minor;
+	int code_length;
+	int sample_rate;
+	unsigned long features;
+	void *data;
+	int (*add_to_buf) (void *data, struct lirc_buffer *buf);
+	wait_queue_head_t* (*get_queue) (void *data);
+	struct lirc_buffer *rbuf;
+	int (*set_use_inc) (void *data);
+	void (*set_use_dec) (void *data);
+	int (*ioctl) (struct inode *, struct file *, unsigned int,
+		      unsigned long);
+	struct file_operations *fops;
+	struct device *dev;
+	struct module *owner;
+};
+/* name:
+ * this string will be used for logs
+ *
+ * minor:
+ * indicates minor device (/dev/lirc) number for registered plugin
+ * if caller fills it with negative value, then the first free minor
+ * number will be used (if available)
+ *
+ * code_length:
+ * length of the remote control key code expressed in bits
+ *
+ * sample_rate:
+ * sample_rate equal to 0 means that no polling will be performed and
+ * add_to_buf will be triggered by external events (through task queue
+ * returned by get_queue)
+ *
+ * data:
+ * it may point to any plugin data and this pointer will be passed to
+ * all callback functions
+ *
+ * add_to_buf:
+ * add_to_buf will be called after specified period of the time or
+ * triggered by the external event, this behavior depends on value of
+ * the sample_rate this function will be called in user context. This
+ * routine should return 0 if data was added to the buffer and
+ * -ENODATA if none was available. This should add some number of bits
+ * evenly divisible by code_length to the buffer
+ *
+ * get_queue:
+ * this callback should return a pointer to the task queue which will
+ * be used for external event waiting
+ *
+ * rbuf:
+ * if not NULL, it will be used as a read buffer, you will have to
+ * write to the buffer by other means, like irq's (see also
+ * lirc_serial.c).
+ *
+ * set_use_inc:
+ * set_use_inc will be called after device is opened
+ *
+ * set_use_dec:
+ * set_use_dec will be called after device is closed
+ *
+ * ioctl:
+ * Some ioctl's can be directly handled by lirc_dev but will be
+ * forwared here if not NULL and only handled if it returns
+ * -ENOIOCTLCMD (see also lirc_serial.c).
+ *
+ * fops:
+ * file_operations for drivers which don't fit the current plugin model.
+ *
+ * owner:
+ * the module owning this struct
+ *
+ */
+
+
+/* following functions can be called ONLY from user context
+ *
+ * returns negative value on error or minor number
+ * of the registered device if success
+ * contens of the structure pointed by p is copied
+ */
+extern int lirc_register_plugin(struct lirc_plugin *p);
+
+/* returns negative value on error or 0 if success
+*/
+extern int lirc_unregister_plugin(int minor);
+
+/* Returns the private data stored in the lirc_plugin
+ * associated with the given device file pointer.
+ */
+void *lirc_get_pdata(struct file *file);
+
+#endif
diff --git a/MAINTAINERS b/MAINTAINERS
index af27945..f3f7f03 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2580,6 +2580,15 @@ W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 
+LINUX INFRARED REMOTE CONTROL DRIVERS (LIRC)
+P:	Jarod Wilson
+M:	jarod@redhat.com
+P:	Christoph Bartelmus
+M:	lirc@bartelmus.de
+W:	http://www.lirc.org/
+L:	lirc-list@lists.sourceforge.net
+S:	Maintained
+
 LLC (802.2)
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
-- 
1.6.0.1

