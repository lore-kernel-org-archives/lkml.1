Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbZDGPSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbZDGPSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbZDGPIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48880 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801AbZDGPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:13 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [27/28] MCE: Add basic error injection infrastructure
Message-Id: <20090407150810.BE3561D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow user programs to write mce records into /dev/mcelog. When they do 
that a fake machine check is triggered to test the machine check code.

This uses the MCE MSR wrappers added earlier.

The implementation is straight forward. There is a struct mce record
per CPU and the MCE MSR accesses get data from there if there is valid
data injected there. This allows to test the machine check code
relatively realistically because only the lowest layer of hardware
access is intercepted.

The test suite and injector are available at 
git://git.kernel.org/pub/scm/utils/cpu/mce/mce-test.git
git://git.kernel.org/pub/scm/utils/cpu/mce/mce-inject.git

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig                        |    8 +
 arch/x86/include/asm/mce.h              |    4 
 arch/x86/kernel/cpu/mcheck/Makefile     |    1 
 arch/x86/kernel/cpu/mcheck/mce-inject.c |  129 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_64.c     |   39 +++++++++
 5 files changed, 180 insertions(+), 1 deletion(-)
Index: linux/arch/x86/kernel/cpu/mcheck/mce-inject.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/cpu/mcheck/mce-inject.c	2009-04-07 16:43:05.000000000 +0200
@@ -0,0 +1,129 @@
+/*
+ * Machine check injection support.
+ * Copyright 2008 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Authors:
+ * Andi Kleen
+ * Ying Huang
+ */
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/fs.h>
+#include <linux/smp.h>
+#include <asm/uaccess.h>
+#include <asm/mce.h>
+
+/* Update fake mce registers on current CPU. */
+static void inject_mce(struct mce *m)
+{
+	struct mce *i = &per_cpu(injectm, m->extcpu);
+
+	/* Make sure noone reads partially written injectm */
+	i->finished = 0;
+	mb();
+	m->finished = 0;
+	/* First set the fields after finished */
+	i->extcpu = m->extcpu;
+	mb();
+	/* Now write record in order, finished last (except above) */
+	memcpy(i, m, sizeof(struct mce));
+	/* Finally activate it */
+	mb();
+	i->finished = 1;
+}
+
+struct delayed_mce {
+	struct timer_list timer;
+	struct mce m;
+};
+
+/* Inject mce on current CPU */
+static void raise_mce(unsigned long data)
+{
+	struct delayed_mce *dm = (struct delayed_mce *)data;
+	struct mce *m = &dm->m;
+	int cpu = m->extcpu;
+
+	inject_mce(m);
+	if (m->status & MCI_STATUS_UC) {
+		struct pt_regs regs;
+		memset(&regs, 0, sizeof(struct pt_regs));
+		regs.ip = m->ip;
+		regs.cs = m->cs;
+		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
+		do_machine_check(&regs, 0);
+		printk(KERN_INFO "MCE exception done on CPU %d\n", cpu);
+	} else {
+		mce_banks_t b;
+		memset(&b, 0xff, sizeof(mce_banks_t));
+		printk(KERN_INFO "Starting machine check poll CPU %d\n", cpu);
+		machine_check_poll(0, &b);
+		mce_notify_user();
+		printk(KERN_INFO "Finished machine check poll on CPU %d\n",
+		       cpu);
+	}
+	kfree(dm);
+}
+
+/* Error injection interface */
+static ssize_t mce_write(struct file *filp, const char __user *ubuf,
+			 size_t usize, loff_t *off)
+{
+	struct delayed_mce *dm;
+	struct mce m;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	/*
+	 * There are some cases where real MSR reads could slip
+	 * through.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_MCE) || !boot_cpu_has(X86_FEATURE_MCA))
+		return -EIO;
+
+	if ((unsigned long)usize > sizeof(struct mce))
+		usize = sizeof(struct mce);
+	if (copy_from_user(&m, ubuf, usize))
+		return -EFAULT;
+
+	if (m.cpu && !m.extcpu)
+		m.extcpu = m.cpu;
+
+	if (m.extcpu >= NR_CPUS || !cpu_online(m.extcpu))
+		return -EINVAL;
+
+	dm = kmalloc(sizeof(struct delayed_mce), GFP_KERNEL);
+	if (!dm)
+		return -ENOMEM;
+
+	/*
+	 * Need to give user space some time to set everything up,
+	 * so do it a jiffie or two later everywhere.
+	 * Should we use a hrtimer here for better synchronization?
+	 */
+	memcpy(&dm->m, &m, sizeof(struct mce));
+	setup_timer(&dm->timer, raise_mce, (unsigned long)dm);
+	dm->timer.expires = jiffies + 2;
+	add_timer_on(&dm->timer, m.extcpu);
+	return usize;
+}
+
+static int inject_init(void)
+{
+	printk(KERN_INFO "Machine check injector initialized\n");
+	mce_chrdev_ops.write = mce_write;
+	return 0;
+}
+
+module_init(inject_init);
+/* Cannot tolerate unloading currently because we cannot
+ * guarantee all openers of mce_chrdev will get a reference to us.
+ */
+MODULE_LICENSE("GPL");
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:08.000000000 +0200
@@ -156,6 +156,10 @@
 
 #endif /* !CONFIG_X86_32 */
 
+DECLARE_PER_CPU(struct mce, injectm);
+extern struct file_operations mce_chrdev_ops;
+extern int mce_notify_user(void);
+
 #ifdef CONFIG_X86_MCE
 extern void mcheck_init(struct cpuinfo_x86 *c);
 #else
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig	2009-04-07 16:09:50.000000000 +0200
+++ linux/arch/x86/Kconfig	2009-04-07 16:43:04.000000000 +0200
@@ -795,6 +795,14 @@
 	bool
 	default y
 
+config X86_MCE_INJECT
+	depends on X86_64
+	tristate "Machine check injector support"
+	help
+	  Provide support for injecting machine checks for testing purposes.
+	  If you don't know what a machine check is and you don't do kernel
+	  QA it is safe to say n.
+
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
 	depends on X86_32 && X86_MCE
Index: linux/arch/x86/kernel/cpu/mcheck/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/Makefile	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/Makefile	2009-04-07 16:09:59.000000000 +0200
@@ -5,4 +5,5 @@
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
+obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
 obj-$(CONFIG_X86_64)		+= mce-severity.o
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:08.000000000 +0200
@@ -97,6 +97,9 @@
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
+DEFINE_PER_CPU(struct mce, injectm);
+EXPORT_PER_CPU_SYMBOL_GPL(injectm);
+
 /*
  * Lockless MCE logging infrastructure.
  * This avoids deadlocks on printk locks without having to break locks. Also
@@ -226,16 +229,46 @@
 	panic(msg);
 }
 
+/* Support code for software error injection */
+
+static int msr_to_offset(u32 msr)
+{
+	unsigned bank = __get_cpu_var(injectm.bank);
+	if (msr == rip_msr)
+		return offsetof(struct mce, ip);
+	if (msr == MSR_IA32_MC0_STATUS + bank*4)
+		return offsetof(struct mce, status);
+	if (msr == MSR_IA32_MC0_ADDR + bank*4)
+		return offsetof(struct mce, addr);
+	if (msr == MSR_IA32_MC0_MISC + bank*4)
+		return offsetof(struct mce, misc);
+	if (msr == MSR_IA32_MCG_STATUS)
+		return offsetof(struct mce, mcgstatus);
+	return -1;
+}
+
 /* MSR access wrappers used for error injection */
 static u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
+	if (__get_cpu_var(injectm).finished) {
+		int offset = msr_to_offset(msr);
+		if (offset < 0)
+			return 0;
+		return *(u64 *)((char *)&__get_cpu_var(injectm) + offset);
+	}
 	rdmsrl(msr, v);
 	return v;
 }
 
 static void mce_wrmsrl(u32 msr, u64 v)
 {
+	if (__get_cpu_var(injectm).finished) {
+		int offset = msr_to_offset(msr);
+		if (offset >= 0)
+			*(u64 *)((char *)&__get_cpu_var(injectm) + offset) = v;
+		return;
+	}
 	wrmsrl(msr, v);
 }
 
@@ -372,6 +405,7 @@
 
 	sync_core();
 }
+EXPORT_SYMBOL_GPL(machine_check_poll);
 
 /*
  * Do a quick check if any of the events requires a panic.
@@ -825,6 +859,7 @@
 	atomic_dec(&mce_entry);
 	sync_core();
 }
+EXPORT_SYMBOL_GPL(do_machine_check);
 
 #ifdef CONFIG_X86_MCE_INTEL
 /***
@@ -924,6 +959,7 @@
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mce_notify_user);
 
 /*
  * Initialize Machine Checks for a CPU.
@@ -1210,13 +1246,14 @@
 	}
 }
 
-static const struct file_operations mce_chrdev_ops = {
+struct file_operations mce_chrdev_ops = {
 	.open = mce_open,
 	.release = mce_release,
 	.read = mce_read,
 	.poll = mce_poll,
 	.unlocked_ioctl = mce_ioctl,
 };
+EXPORT_SYMBOL_GPL(mce_chrdev_ops);
 
 static struct miscdevice mce_log_device = {
 	MISC_MCELOG_MINOR,
