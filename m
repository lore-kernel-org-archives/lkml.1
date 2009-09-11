Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZIKMop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZIKMop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 08:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZIKMom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 08:44:42 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48340 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751481AbZIKMok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:44:40 -0400
Date: Thu, 10 Sep 2009 20:03:01 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add memory mapped RTC driver for UV
Message-ID: <20090911010301.GA11698@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver memory maps the UV Hub RTC.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 drivers/char/Kconfig      |    8 +
 drivers/char/Makefile     |    1 
 drivers/char/uv_mmtimer.c |  214 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 223 insertions(+)

Index: linux/drivers/char/Kconfig
===================================================================
--- linux.orig/drivers/char/Kconfig	2009-09-10 12:38:30.000000000 -0500
+++ linux/drivers/char/Kconfig	2009-09-10 12:40:12.000000000 -0500
@@ -1087,6 +1087,14 @@ config MMTIMER
 	  The mmtimer device allows direct userspace access to the
 	  Altix system timer.
 
+config UV_MMTIMER
+	tristate "UV_MMTIMER Memory mapped RTC for SGI UV"
+	depends on X86_UV
+	default m
+	help
+	  The uv_mmtimer device allows direct userspace access to the
+	  UV system timer.
+
 source "drivers/char/tpm/Kconfig"
 
 config TELCLOCK
Index: linux/drivers/char/Makefile
===================================================================
--- linux.orig/drivers/char/Makefile	2009-09-10 12:38:30.000000000 -0500
+++ linux/drivers/char/Makefile	2009-09-10 12:40:12.000000000 -0500
@@ -58,6 +58,7 @@ obj-$(CONFIG_RAW_DRIVER)	+= raw.o
 obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
 obj-$(CONFIG_MSPEC)		+= mspec.o
 obj-$(CONFIG_MMTIMER)		+= mmtimer.o
+obj-$(CONFIG_UV_MMTIMER)	+= uv_mmtimer.o
 obj-$(CONFIG_VIOTAPE)		+= viotape.o
 obj-$(CONFIG_HVCS)		+= hvcs.o
 obj-$(CONFIG_IBM_BSR)		+= bsr.o
Index: linux/drivers/char/uv_mmtimer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/char/uv_mmtimer.c	2009-09-10 14:09:35.000000000 -0500
@@ -0,0 +1,214 @@
+/*
+ * Timer device implementation for SGI UV platform.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2009 Silicon Graphics, Inc.  All rights reserved.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/ioctl.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/mmtimer.h>
+#include <linux/miscdevice.h>
+#include <linux/posix-timers.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/math64.h>
+#include <linux/smp_lock.h>
+
+#include <asm/genapic.h>
+#include <asm/uv/uv_hub.h>
+#include <asm/uv/bios.h>
+#include <asm/uv/uv.h>
+
+MODULE_AUTHOR("Dimitri Sivanich <sivanich@sgi.com>");
+MODULE_DESCRIPTION("SGI UV Memory Mapped RTC Timer");
+MODULE_LICENSE("GPL");
+
+/* name of the device, usually in /dev */
+#define UV_MMTIMER_NAME "mmtimer"
+#define UV_MMTIMER_DESC "SGI UV Memory Mapped RTC Timer"
+#define UV_MMTIMER_VERSION "1.0"
+
+static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg);
+static int uv_mmtimer_mmap(struct file *file, struct vm_area_struct *vma);
+
+/*
+ * Period in femtoseconds (10^-15 s)
+ */
+static unsigned long uv_mmtimer_femtoperiod;
+
+static const struct file_operations uv_mmtimer_fops = {
+	.owner = THIS_MODULE,
+	.mmap =	uv_mmtimer_mmap,
+	.unlocked_ioctl = uv_mmtimer_ioctl,
+};
+
+/**
+ * uv_mmtimer_ioctl - ioctl interface for /dev/uv_mmtimer
+ * @file: file structure for the device
+ * @cmd: command to execute
+ * @arg: optional argument to command
+ *
+ * Executes the command specified by @cmd.  Returns 0 for success, < 0 for
+ * failure.
+ *
+ * Valid commands:
+ *
+ * %MMTIMER_GETOFFSET - Should return the offset (relative to the start
+ * of the page where the registers are mapped) for the counter in question.
+ *
+ * %MMTIMER_GETRES - Returns the resolution of the clock in femto (10^-15)
+ * seconds
+ *
+ * %MMTIMER_GETFREQ - Copies the frequency of the clock in Hz to the address
+ * specified by @arg
+ *
+ * %MMTIMER_GETBITS - Returns the number of bits in the clock's counter
+ *
+ * %MMTIMER_MMAPAVAIL - Returns 1 if registers can be mmap'd into userspace
+ *
+ * %MMTIMER_GETCOUNTER - Gets the current value in the counter and places it
+ * in the address specified by @arg.
+ */
+static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case MMTIMER_GETOFFSET:	/* offset of the counter */
+		/*
+		 * UV RTC register is on it's own page
+		 */
+		if (PAGE_SIZE <= (1 << 16))
+			ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
+				/ 8;
+		else
+			ret = -ENOSYS;
+		break;
+
+	case MMTIMER_GETRES: /* resolution of the clock in 10^-15 s */
+		if (copy_to_user((unsigned long __user *)arg,
+				&uv_mmtimer_femtoperiod, sizeof(unsigned long)))
+			ret = -EFAULT;
+		break;
+
+	case MMTIMER_GETFREQ: /* frequency in Hz */
+		if (copy_to_user((unsigned long __user *)arg,
+				&sn_rtc_cycles_per_second,
+				sizeof(unsigned long)))
+			ret = -EFAULT;
+		break;
+
+	case MMTIMER_GETBITS: /* number of bits in the clock */
+		ret = hweight64(UVH_RTC_REAL_TIME_CLOCK_MASK);
+		break;
+
+	case MMTIMER_MMAPAVAIL: /* can we mmap the clock into userspace? */
+		ret = (PAGE_SIZE <= (1 << 16)) ? 1 : 0;
+		break;
+
+	case MMTIMER_GETCOUNTER:
+		if (copy_to_user((unsigned long __user *)arg,
+				(unsigned long *)uv_local_mmr_address(UVH_RTC),
+				sizeof(unsigned long)))
+			ret = -EFAULT;
+		break;
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+	return ret;
+}
+
+/**
+ * uv_mmtimer_mmap - maps the clock's registers into userspace
+ * @file: file structure for the device
+ * @vma: VMA to map the registers into
+ *
+ * Calls remap_pfn_range() to map the clock's registers into
+ * the calling process' address space.
+ */
+static int uv_mmtimer_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long uv_mmtimer_addr;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+
+	if (vma->vm_flags & VM_WRITE)
+		return -EPERM;
+
+	if (PAGE_SIZE > (1 << 16))
+		return -ENOSYS;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	uv_mmtimer_addr = UV_LOCAL_MMR_BASE | UVH_RTC;
+	uv_mmtimer_addr &= ~(PAGE_SIZE - 1);
+	uv_mmtimer_addr &= 0xfffffffffffffffUL;
+
+	if (remap_pfn_range(vma, vma->vm_start, uv_mmtimer_addr >> PAGE_SHIFT,
+					PAGE_SIZE, vma->vm_page_prot)) {
+		printk(KERN_ERR "remap_pfn_range failed in uv_mmtimer_mmap\n");
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static struct miscdevice uv_mmtimer_miscdev = {
+	MISC_DYNAMIC_MINOR,
+	UV_MMTIMER_NAME,
+	&uv_mmtimer_fops
+};
+
+
+/**
+ * uv_mmtimer_init - device initialization routine
+ *
+ * Does initial setup for the uv_mmtimer device.
+ */
+static int __init uv_mmtimer_init(void)
+{
+	if (!is_uv_system())
+		return 0;
+
+	/*
+	 * Sanity check the cycles/sec variable
+	 */
+	if (sn_rtc_cycles_per_second < 100000) {
+		printk(KERN_ERR "%s: unable to determine clock frequency\n",
+		       UV_MMTIMER_NAME);
+		return -1;
+	}
+
+	uv_mmtimer_femtoperiod = ((unsigned long)1E15 +
+				sn_rtc_cycles_per_second / 2) /
+				sn_rtc_cycles_per_second;
+
+	if (misc_register(&uv_mmtimer_miscdev)) {
+		printk(KERN_ERR "%s: failed to register device\n",
+		       UV_MMTIMER_NAME);
+		return -1;
+	}
+
+	printk(KERN_INFO "%s: v%s, %ld MHz\n", UV_MMTIMER_DESC,
+		UV_MMTIMER_VERSION,
+		sn_rtc_cycles_per_second/(unsigned long)1E6);
+
+	return 0;
+}
+
+module_init(uv_mmtimer_init);
