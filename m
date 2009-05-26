Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbZEZXWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbZEZXWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbZEZXSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53175 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbZEZXSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:33 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/17] x86: MCE: Add basic error injection infrastructure
Date: Wed, 27 May 2009 01:18:16 +0200
Message-Id: <4f56437b3a2b2a622685574d12dfce9e1fb846ae.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <7121e96e33d1ed8d244d06c258897d02ae0980ce.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
 <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
 <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
 <91219e907da103fc39dba8d32aaa9f872f0e6cc1.1243377662.git.ak@linux.intel.com>
 <2bc54830cc9e63d090dc461db0bdf99fc3d3cd4a.1243377662.git.ak@linux.intel.com>
 <6dfa191bd595ff969fafb3603ba464254ca895a7.1243377662.git.ak@linux.intel.com>
 <ff5aa0b2473d839010ec97dc3dbae4e198c28db9.1243377662.git.ak@linux.intel.com>
 <17986790ae68ad7f93701894fd130cfd84f6adf5.1243377662.git.ak@linux.intel.com>
 <6d2add3cbbc275431bb41837f8c256fbbc473a46.1243377662.git.ak@linux.intel.com>
 <7121e96e33d1ed8d244d06c258897d02ae0980ce.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
 arch/x86/Kconfig                        |    8 ++
 arch/x86/include/asm/mce.h              |    3 +
 arch/x86/kernel/cpu/mcheck/Makefile     |    1 +
 arch/x86/kernel/cpu/mcheck/mce-inject.c |  126 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c        |   39 +++++++++-
 5 files changed, 176 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-inject.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a148e7a..e25b635 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -835,6 +835,14 @@ config X86_MCE_THRESHOLD
 	bool
 	default y
 
+config X86_MCE_INJECT
+	depends on X86_NEW_MCE
+	tristate "Machine check injector support"
+	---help---
+	  Provide support for injecting machine checks for testing purposes.
+	  If you don't know what a machine check is and you don't do kernel
+	  QA it is safe to say n.
+
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
 	depends on X86_OLD_MCE
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index ca79ee8..8ad67bf 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -141,6 +141,9 @@ extern void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 extern int mce_notify_user(void);
 
+DECLARE_PER_CPU(struct mce, injectm);
+extern struct file_operations mce_chrdev_ops;
+
 #ifdef CONFIG_X86_MCE
 extern void mcheck_init(struct cpuinfo_x86 *c);
 #else
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index 5f8b094..60ee182 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
+obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
new file mode 100644
index 0000000..58afac4
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -0,0 +1,126 @@
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
+	struct mce *i = &per_cpu(injectm, m->cpu);
+
+	/* Make sure noone reads partially written injectm */
+	i->finished = 0;
+	mb();
+	m->finished = 0;
+	/* First set the fields after finished */
+	i->cpu = m->cpu;
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
+	int cpu = m->cpu;
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
+	if (m.cpu >= NR_CPUS || !cpu_online(m.cpu))
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
+	add_timer_on(&dm->timer, m.cpu);
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 76962ff..87f8198 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -98,6 +98,9 @@ void mce_setup(struct mce *m)
 	rdtscll(m->tsc);
 }
 
+DEFINE_PER_CPU(struct mce, injectm);
+EXPORT_PER_CPU_SYMBOL_GPL(injectm);
+
 /*
  * Lockless MCE logging infrastructure.
  * This avoids deadlocks on printk locks without having to break locks. Also
@@ -194,16 +197,46 @@ static void mce_panic(char *msg, struct mce *backup, u64 start)
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
 
@@ -296,6 +329,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 	 * exceptions.
 	 */
 }
+EXPORT_SYMBOL_GPL(machine_check_poll);
 
 /*
  * The actual machine check handler. This only handles real
@@ -468,6 +502,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
  out2:
 	atomic_dec(&mce_entry);
 }
+EXPORT_SYMBOL_GPL(do_machine_check);
 
 #ifdef CONFIG_X86_MCE_INTEL
 /***
@@ -568,6 +603,7 @@ int mce_notify_user(void)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mce_notify_user);
 
 /*
  * Initialize Machine Checks for a CPU.
@@ -905,13 +941,14 @@ static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	}
 }
 
-static const struct file_operations mce_chrdev_ops = {
+struct file_operations mce_chrdev_ops = {
 	.open			= mce_open,
 	.release		= mce_release,
 	.read			= mce_read,
 	.poll			= mce_poll,
 	.unlocked_ioctl		= mce_ioctl,
 };
+EXPORT_SYMBOL_GPL(mce_chrdev_ops);
 
 static struct miscdevice mce_log_device = {
 	MISC_MCELOG_MINOR,
-- 
1.6.0.2

