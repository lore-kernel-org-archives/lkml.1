Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676Ab0ARVUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0ARVUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573Ab0ARVUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:20:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:3986 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab0ARVUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:20:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,298,1262592000"; 
   d="scan'208";a="484964737"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Add Linux Driver for Intel Langwell Watchdog
Date: Mon, 18 Jan 2010 13:24:19 -0800
Message-Id: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a Linux device driver for the Intel Langwell
Watchdog device found on the Intel Mobile Internet device.

The purpose of the watchdog driver is to force a system reboot
in the event that a critical system process either terminates or
gets currupted so that it cannot perform its required duties.

This patch is referenced off the linux-next repository as pulled
on Sunday, January 17, 2010

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Date: January 17, 2010
---
 drivers/watchdog/Kconfig             |    7 +
 drivers/watchdog/Makefile            |    1 +
 drivers/watchdog/langwell_watchdog.c |  551 ++++++++++++++++++++++++++++++++++
 drivers/watchdog/langwell_watchdog.h |   60 ++++
 4 files changed, 619 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/langwell_watchdog.c
 create mode 100644 drivers/watchdog/langwell_watchdog.h

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 088f32f..4902157 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -448,6 +448,13 @@ config IBMASR
 	  To compile this driver as a module, choose M here: the
 	  module will be called ibmasr.
 
+config LANGWELL_WATCHDOG
+	tristate "Intel Langwell Watchdog for Mobil Platforms"
+	depends on WATCHDOG
+	help
+	  This driver is for the Intel Mobile Platform. If
+	  in doubt, set it to N.
+
 config WAFER_WDT
 	tristate "ICP Single Board Computer Watchdog Timer"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 475c611..67f936f 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_W83877F_WDT) += w83877f_wdt.o
 obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
+obj-$(CONFIG_LANGWELL_WATCHDOG) += langwell_watchdog.o
 
 # M32R Architecture
 
diff --git a/drivers/watchdog/langwell_watchdog.c b/drivers/watchdog/langwell_watchdog.c
new file mode 100644
index 0000000..050b036
--- /dev/null
+++ b/drivers/watchdog/langwell_watchdog.c
@@ -0,0 +1,551 @@
+/*
+ *      Langwell 0.2:  An Intel Langwell IOH Based Watchdog Device
+ *
+ *      Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#include <linux/compiler.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/sfi.h>
+#include <linux/types.h>
+#include <asm/irq.h>
+#include <asm/atomic.h>
+
+/* See arch/x86/kernel/ipc_mrst.c */
+#include <asm/ipc_defs.h>
+#include <linux/sftbl.h>
+/* #include <asm/mrst.h> */
+
+#include "langwell_watchdog.h"
+
+
+static DECLARE_WAIT_QUEUE_HEAD(read_wq);
+
+static int flag;
+static int timer_margin = DEFAULT_SOFT_TO_HARD_MARGIN;
+module_param(timer_margin, int, 0);
+
+MODULE_PARM_DESC(timer_margin,
+		"Watchdog timer margin"
+		"Time between interrupt and resetting the system"
+		"The range is from 1 to 160"
+		"This is the time for all keep alives to arrive");
+
+static int timer_set = DEFAULT_TIME;
+module_param(timer_set, int, 0);
+
+MODULE_PARM_DESC(timer_set,
+		"Default Watchdog timer setting"
+		"Complete cycle time"
+		"The range is from 1 to 170"
+		"This is the time for all keep alives to arrive");
+
+/* driver will force boot on closure of device file */
+static int force_boot = 1;
+
+module_param(force_boot, int, 0);
+MODULE_PARM_DESC(force_boot,
+		 "A value of 1 means that the driver will reboot"
+		 "the system if the /dev/watchdog device is closed"
+		 );
+
+/* there is only one device in the system now; this can be made into
+ * an array in the future if we have more than one device */
+
+static struct langwell_watchdog_dev watchdog_device;
+
+/* This is used to force reboot if anyone tries to close this device */
+static void watchdog_fire(void)
+{
+	module_put(THIS_MODULE);
+
+	if (force_boot) {
+		printk(KERN_CRIT PFX "Initiating system reboot.\n");
+		emergency_restart();
+		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
+	}
+
+	else {
+		printk(KERN_CRIT PFX "Reboot would have happend\n");
+		printk(KERN_CRIT PFX "You now have force_boot set to 0\n");
+		printk(KERN_CRIT PFX "I am not rebooting\n");
+	}
+}
+
+/*
+ *      Langwell operations
+ */
+
+/* timer interrupt handler */
+irqreturn_t watchdog_timer_interrupt(int irq, void *dev_id)
+{
+	int int_status;
+	int_status = ioread32(watchdog_device.timer_interrupt_status_addr);
+
+	pr_debug("Watchdog timer -  irq 7 interrupt received\n");
+
+	if (int_status != 0)
+		return IRQ_NONE;
+
+	/* is the driver open; if not, then this is spurious */
+	if (watchdog_device.timer_started == 0)
+		return IRQ_HANDLED;
+
+	pr_debug("Watchdog timer -  watchdog interrupt received\n");
+
+	/* wake up read to send data to user (reminder for keep alive */
+	flag = 1;
+
+	wake_up_interruptible(&read_wq);
+
+	pr_debug("Watchdog timer - interrupt wakes up read_wq\n");
+
+	return IRQ_HANDLED;
+}
+
+static int langwell_keepalive(void)
+{
+
+	pr_debug("Watchdog timer - langwell keep alive \n");
+	/* read eoi register - clears interrupt */
+	ioread32(watchdog_device.timer_clear_interrupt_addr);
+
+	return 0;
+}
+
+static int langwell_stop(void)
+{
+	pr_debug("Watchdog timer - langwell stop\n");
+
+	iowrite32(0, watchdog_device.timer_control_addr);
+	return 0;
+}
+
+static int langwell_set_heartbeat(u32 t)
+{
+	struct watchdog_reg_data reg_data;
+
+	watchdog_device.timer_set = t;
+	watchdog_device.threshold =
+	  timer_margin * watchdog_device.mtmr_ptr->freq;
+	watchdog_device.soft_threshold =
+	  (watchdog_device.timer_set - timer_margin)
+	  * watchdog_device.mtmr_ptr->freq;
+
+	pr_debug("Watchdog timer - timer_margin is %x (hex) seconds\n",
+	  timer_margin);
+
+	pr_debug("Watchdog timer - following are in clock cycles\n");
+
+	pr_debug("Watchdog timer - there are %x (hex) clock cycles\n",
+	  watchdog_device.mtmr_ptr->freq);
+
+	pr_debug("Watchdog timer - per second\n");
+
+	pr_debug("Watchdog timer - thres is %x (hex) and warm is %x (hex)\n",
+	  watchdog_device.threshold, watchdog_device.soft_threshold);
+
+	pr_debug("Watchdog timer - setting timer_set is %x (hex) seconds\n",
+	  watchdog_device.timer_set);
+
+	/* temporarily disable the timer */
+	iowrite32(0x00000002, watchdog_device.timer_control_addr);
+
+	/* send the threshold and soft_threshold via IPC to the Lincroft */
+	reg_data.payload1 = watchdog_device.soft_threshold;
+	reg_data.payload2 = watchdog_device.threshold;
+	ipc_set_watchdog(&reg_data);
+
+	pr_debug("Watchdog timer - setting timer to %x (hex)\n",
+	  watchdog_device.soft_threshold);
+
+	/* set the timer to the soft threshold */
+	iowrite32(watchdog_device.soft_threshold,
+	  watchdog_device.timer_load_count_addr);
+
+	/* read the timer to verify that it has been set */
+	pr_debug("Watchdog timer - watchdog - timer value is %x (hex)\n",
+	  ioread32(watchdog_device.timer_current_value_addr));
+
+	/* allow the timer to run */
+	iowrite32(0x00000003, watchdog_device.timer_control_addr);
+
+	watchdog_device.timer_started = 1;
+
+	return 0;
+}
+
+/*
+ * /dev/watchdog handling
+ */
+static int langwell_open(struct inode *inode, struct file *file)
+{
+	/* Miscdevice structure pointer already saved in private_data */
+
+	struct watchdog_reg_data reg_data;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (test_and_set_bit(0, &watchdog_device.driver_open))
+		return -ENOTTY;
+
+	/* make sure that the timer set value is within boundaries */
+	if ((timer_set < MIN_TIME_CYCLE) ||
+	  (timer_set > MAX_TIME - MIN_TIME_CYCLE)) {
+		pr_debug("Watchdog timer - timer open; timer value %x (hex)"
+		  "is out of range from %x to %x (hex)\n",
+		  timer_set, MIN_TIME_CYCLE, MAX_TIME - MIN_TIME_CYCLE);
+		return -EINVAL;
+	}
+
+	/* make sure that the timer margin value is within boundaries */
+	if ((timer_margin < MIN_TIME_CYCLE) ||
+	  (timer_margin > MAX_TIME - timer_set)) {
+		pr_debug("Watchdog timer - timer open; "
+		  "timer margin value %x is out of range from %x to %x (hex)\n",
+		  timer_margin, MIN_TIME_CYCLE, MAX_TIME - timer_set);
+		return -EINVAL;
+	}
+
+	/* now set the watchpoints (using the IPC) */
+
+	watchdog_device.timer_set = timer_set;
+	watchdog_device.threshold =
+	  timer_margin * watchdog_device.mtmr_ptr->freq;
+	watchdog_device.soft_threshold =
+	  (watchdog_device.timer_set - timer_margin)
+	  * watchdog_device.mtmr_ptr->freq;
+
+	pr_debug("Watchdog timer - threshold is %x and soft to %x (hex)\n",
+	  watchdog_device.threshold, watchdog_device.soft_threshold);
+
+	pr_debug("Watchdog timer - setting heartbeat timer_set is %x (hex)\n",
+	  watchdog_device.timer_set);
+
+	/* temporarily disable the timer */
+	iowrite32(0x00000002, watchdog_device.timer_control_addr);
+
+	/* send the threshold and soft_threshold via IPC to the Lincroft */
+	reg_data.payload1 = watchdog_device.soft_threshold;
+	reg_data.payload2 = watchdog_device.threshold;
+	ipc_set_watchdog(&reg_data);
+
+	pr_debug("Watchdog timer - setting timer to %x (hex)\n",
+	  watchdog_device.soft_threshold);
+
+	/* set the timer to the soft threshold */
+	iowrite32(watchdog_device.soft_threshold,
+	  watchdog_device.timer_load_count_addr);
+
+	/* read the timer to verify that it has been set */
+	pr_debug("Watchdog timer - watchdog - timer value is %x (hex)\n",
+	  ioread32(watchdog_device.timer_current_value_addr));
+
+	/* allow the timer to run */
+	iowrite32(0x00000003, watchdog_device.timer_control_addr);
+
+	watchdog_device.timer_started = 1;
+
+	return nonseekable_open(inode, file);
+}
+
+static int langwell_release(struct inode *inode, struct file *file)
+{
+	/*
+	 * This watchdog may not be closed! Reboot immediately.
+	 */
+	printk(KERN_CRIT PFX
+	       "Unexpected close, firing off the watchdog!\n");
+
+	clear_bit(0, &watchdog_device.driver_open);
+
+	/* Reboot system (if force_boot is set) */
+	watchdog_fire();
+
+	/* We should never reach this point.  */
+	return 0;
+}
+
+static ssize_t langwell_write(struct file *file,
+			      char const *data,
+			      size_t len,
+			      loff_t *ppos)
+{
+	pr_debug("Langwell Watchdog - write; calling keepalive\n");
+
+	langwell_keepalive();
+
+	return len;
+}
+
+static ssize_t langwell_read(struct file *file,
+			     char __user *user_data,
+			     size_t len,
+			     loff_t *user_ppos)
+{
+	int result;
+	u8 buf = 0;
+
+	pr_debug("Langwell Watchdog - read function called;"
+	 " wait for interrupt\n");
+
+	/* we wait for the next interrupt; if more than one */
+	/* interrupt has occurered since the last read, we */
+	/* dont care. The data is not critical. We will do */
+	/* a copy to user each time we get and interrupt */
+	/* It is up to the Watchdog daemon to be ready to */
+	/* do the read (shich signifies that the driver is */
+	/* awaiting a keep alive and that a limited time */
+	/* is available for the keep alive before the system */
+	/* is rebooted by the timer */
+	wait_event_interruptible(read_wq, flag != 0);
+	flag = 0;
+
+	pr_debug("Langwell Watchdog read - interrupt received\n");
+
+	/* Please note that the content of the data is irrelevent */
+	/* All that matters is that the read is available to the user */
+	result = copy_to_user(user_data, (void *)&buf, 1);
+
+	if (result != 0)
+		return -EFAULT;
+	else
+		return 1;
+
+}
+
+static long langwell_ioctl(struct file *file,
+			   unsigned int cmd,
+			   unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	u32 __user *p = argp;
+	u32 new_margin;
+
+	static const struct watchdog_info ident = {
+		.options =          WDIOF_SETTIMEOUT
+				    | WDIOF_KEEPALIVEPING,
+		.firmware_version = 0,  /* @todo Get from SCU via
+						 ipc_get_scu_fw_version()? */
+		.identity =         "Langwell IOH Watchdog"  /* len < 32 */
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp,
+				    &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+	pr_debug("Watchdog timer - watchdog - timer current value is %x\n",
+	  ioread32(watchdog_device.timer_current_value_addr));
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		langwell_keepalive();
+
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+
+		if ((new_margin < 0) || (new_margin > MAX_TIME)) {
+			pr_debug("Watchdog timer - value out of range\n"
+			  "Value submitted is %d is out of range of %d"
+			  " and %d\n", new_margin, MIN_TIME_CYCLE, MAX_TIME);
+			return -EINVAL;
+		}
+
+		pr_debug("Langwell Watchdog - set time out timer is %d\n",
+		  new_margin);
+		if (langwell_set_heartbeat(new_margin))
+			return -EINVAL;
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(watchdog_device.soft_threshold, p);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+/*
+ *      Notifier for system down
+ */
+static int langwell_notify_sys(struct notifier_block *this,
+			       unsigned long code,
+			       void *another_unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		/* Turn off the watchdog timer. */
+		langwell_stop();
+	return NOTIFY_DONE;
+}
+
+/*
+ *      Kernel Interfaces
+ */
+static const struct file_operations langwell_fops = {
+	.owner          = THIS_MODULE,
+	.llseek         = no_llseek,
+	.write          = langwell_write,
+	.read		= langwell_read,
+	.unlocked_ioctl = langwell_ioctl,
+	.open           = langwell_open,
+	.release        = langwell_release,
+};
+
+static int __init watchdog_init(void)
+{
+	int ret;
+	u32 __iomem *tmp_addr;
+
+	watchdog_device.mtmr_ptr = sfi_get_mtmr(sfi_mtimer_num-1);
+
+	/* make sure the timer exists */
+	if (watchdog_device.mtmr_ptr->phy_addr == 0) {
+		pr_debug("Watchdog timer - langwell watchdog - timer %d does"
+		  " not valid physical memory\n", sfi_mtimer_num);
+		return -ENODEV;
+	}
+
+	pr_debug("Watchdog timer timer sfi_mtimer_num is %d\n",
+	  sfi_mtimer_num);
+	pr_debug("Watchdog timer timer phy_addr is %08x\n",
+	  (unsigned int)watchdog_device.mtmr_ptr->phy_addr);
+	pr_debug("Watchdog timer timer IRQ is %d\n",
+	  watchdog_device.mtmr_ptr->irq);
+	pr_debug("Watchdog timer timer freq is %d\n",
+	  watchdog_device.mtmr_ptr->freq);
+
+	if (watchdog_device.mtmr_ptr->irq == 0) {
+		pr_debug("Watchdog timer - timer %d invalid irq\n",
+		  sfi_mtimer_num);
+		return -ENODEV;
+	}
+
+	tmp_addr = ioremap_nocache(watchdog_device.mtmr_ptr->phy_addr, 20);
+
+	if (tmp_addr == NULL) {
+		pr_debug("Watchdog timer timer unable to ioremap\n");
+		return -ENOMEM;
+	}
+
+	watchdog_device.timer_load_count_addr = tmp_addr++;
+	watchdog_device.timer_current_value_addr = tmp_addr++;
+	watchdog_device.timer_control_addr = tmp_addr++;
+	watchdog_device.timer_clear_interrupt_addr = tmp_addr++;
+	watchdog_device.timer_interrupt_status_addr = tmp_addr++;
+
+	pr_debug("Watchdog timer base logical_addr is %08x\n",
+	  (unsigned int)tmp_addr);
+	pr_debug("Watchdog timer - watchdog - timer load count is %08x\n",
+	  ioread32(watchdog_device.timer_load_count_addr));
+	pr_debug("Watchdog timer - watchdog - timer current value is %08x\n",
+	  ioread32(watchdog_device.timer_current_value_addr));
+	pr_debug("Watchdog timer - watchdog - timer control is %08x\n",
+	  ioread32(watchdog_device.timer_control_addr));
+
+	watchdog_device.langwell_notifier.notifier_call =
+	  langwell_notify_sys;
+
+	ret = register_reboot_notifier(&watchdog_device.langwell_notifier);
+	if (ret) {
+		printk(KERN_ERR PFX
+		  "Watchdog timer - cannot register notifier %d)\n", ret);
+		goto register_reboot_error;
+	}
+
+	watchdog_device.miscdev.minor = WATCHDOG_MINOR,
+	watchdog_device.miscdev.name = "watchdog",
+	watchdog_device.miscdev.fops = &langwell_fops,
+
+	ret = misc_register(&watchdog_device.miscdev);
+	if (ret) {
+		printk(KERN_ERR PFX
+		       "Watchdog timer - cannot register miscdev %d err =%d\n",
+		       WATCHDOG_MINOR,
+		       ret);
+		goto misc_register_error;
+	}
+
+	ret = request_irq((unsigned int)watchdog_device.mtmr_ptr->irq,
+	  watchdog_timer_interrupt,
+	  IRQF_SHARED, "watchdog", &watchdog_device.timer_load_count_addr);
+	if (ret) {
+		printk(KERN_ERR "Watchdog timer - error requesting irq\n");
+		printk(KERN_ERR "Watchdog timer - error value returned is %d\n",
+		  ret);
+		goto request_irq_error;
+	}
+
+	return 0;
+
+/* error cleanup */
+
+request_irq_error:
+
+	misc_deregister(&watchdog_device.miscdev);
+
+misc_register_error:
+
+	unregister_reboot_notifier(&watchdog_device.langwell_notifier);
+
+register_reboot_error:
+
+	iounmap(watchdog_device.timer_load_count_addr);
+	return ret;
+}
+
+static void __exit watchdog_exit(void)
+{
+
+	misc_deregister(&watchdog_device.miscdev);
+	unregister_reboot_notifier(&watchdog_device.langwell_notifier);
+	/* disable the timer */
+	iowrite32(0x00000002, watchdog_device.timer_control_addr);
+	iounmap(watchdog_device.timer_load_count_addr);
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Langwell Watchdog Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_VERSION(WDT_VER);
+
diff --git a/drivers/watchdog/langwell_watchdog.h b/drivers/watchdog/langwell_watchdog.h
new file mode 100644
index 0000000..fa4280d
--- /dev/null
+++ b/drivers/watchdog/langwell_watchdog.h
@@ -0,0 +1,60 @@
+/*
+ *      Langwell 0.2:  An Intel Langwell IOH Based Watchdog Device
+ *
+ *      Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#ifndef __LANGWELL_WATCHDOG_H
+#define __LANGWELL_WATCHDOG_H
+
+#define PFX "Langwell: "
+#define WDT_VER "0.2"
+
+/* minimum time between interrupts */
+#define MIN_TIME_CYCLE 1
+
+/* Time from warning to reboot is 2 seconds */
+#define DEFAULT_SOFT_TO_HARD_MARGIN 2
+
+#define MAX_TIME 170
+
+#define DEFAULT_TIME 5
+
+#define MAX_SOFT_TO_HARD_MARGIN (MAX_TIME-MIN_TIME_CYCLE)
+
+struct langwell_watchdog_dev {
+	unsigned long driver_open;
+	u32 timer_started;
+	u32 timer_set;
+	u32 threshold;
+	u32 soft_threshold;
+	u32 __iomem *timer_load_count_addr;
+	u32 __iomem *timer_current_value_addr;
+	u32 __iomem *timer_control_addr;
+	u32 __iomem *timer_clear_interrupt_addr;
+	u32 __iomem *timer_interrupt_status_addr;
+	struct sfi_mtimer_entry *mtmr_ptr;
+	struct notifier_block langwell_notifier;
+	struct miscdevice miscdev;
+};
+
+extern int sfi_mtimer_num;
+
+/* extern struct sfi_timer_table_entry *sfi_get_mtmr(int hint); */
+#endif /* __LANGWELL_WATCHDOG_H */
-- 
1.6.0.6

