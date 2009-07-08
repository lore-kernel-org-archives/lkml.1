Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbZGHWdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbZGHWdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbZGHWbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47052 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401AbZGHWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:45 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [6/8] x86: mce: Move per bank data in a single datastructure
Message-Id: <20090708223143.34FE71D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This addresses one of the leftover review comments.

Move the per bank data into a single structure. This avoids
several separate variables and also separate allocation of sysfs objects.

I didn't move the CMCI ownership information so far because
that would have needed some non trivial changes in the algorithms.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   14 +++
 arch/x86/kernel/cpu/mcheck/mce.c          |  109 ++++++++++++++----------------
 2 files changed, 67 insertions(+), 56 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c
@@ -64,7 +64,6 @@ DEFINE_PER_CPU(unsigned, mce_exception_c
  */
 static int			tolerant		__read_mostly = 1;
 static int			banks			__read_mostly;
-static u64			*bank			__read_mostly;
 static int			rip_msr			__read_mostly;
 static int			mce_bootlog		__read_mostly = -1;
 static int			monarch_timeout		__read_mostly = -1;
@@ -74,13 +73,13 @@ int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
 
+struct mce_bank                *mce_banks		__read_mostly;
+
 /* User mode helper program triggered by machine check event */
 static unsigned long		mce_need_notify;
 static char			mce_helper[128];
 static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
-static unsigned long		dont_init_banks;
-
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
@@ -91,11 +90,6 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_ban
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
 
-static inline int skip_bank_init(int i)
-{
-	return i < BITS_PER_LONG && test_bit(i, &dont_init_banks);
-}
-
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
 /* Do initial initialization of a struct mce */
@@ -482,7 +476,7 @@ void machine_check_poll(enum mcp_flags f
 
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	for (i = 0; i < banks; i++) {
-		if (!bank[i] || !test_bit(i, *b))
+		if (!mce_banks[i].ctl || !test_bit(i, *b))
 			continue;
 
 		m.misc = 0;
@@ -903,7 +897,7 @@ void do_machine_check(struct pt_regs *re
 	order = mce_start(&no_way_out);
 	for (i = 0; i < banks; i++) {
 		__clear_bit(i, toclear);
-		if (!bank[i])
+		if (!mce_banks[i].ctl)
 			continue;
 
 		m.misc = 0;
@@ -1146,6 +1140,21 @@ int mce_notify_irq(void)
 }
 EXPORT_SYMBOL_GPL(mce_notify_irq);
 
+static int mce_banks_init(void)
+{
+	int i;
+
+	mce_banks = kzalloc(banks * sizeof(struct mce_bank), GFP_KERNEL);
+	if (!mce_banks)
+		return -ENOMEM;
+	for (i = 0; i < banks; i++) {
+		struct mce_bank *b = &mce_banks[i];
+		b->ctl = -1ULL;
+		b->init = 1;
+	}
+	return 0;
+}
+
 /*
  * Initialize Machine Checks for a CPU.
  */
@@ -1169,11 +1178,10 @@ static int mce_cap_init(void)
 	/* Don't support asymmetric configurations today */
 	WARN_ON(banks != 0 && b != banks);
 	banks = b;
-	if (!bank) {
-		bank = kmalloc(banks * sizeof(u64), GFP_KERNEL);
-		if (!bank)
-			return -ENOMEM;
-		memset(bank, 0xff, banks * sizeof(u64));
+	if (!mce_banks) {
+		int err = mce_banks_init();
+		if (err)
+			return err;
 	}
 
 	/* Use accurate RIP reporting if available. */
@@ -1205,9 +1213,10 @@ static void mce_init(void)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
-		if (skip_bank_init(i))
+		struct mce_bank *b = &mce_banks[i];
+		if (!b->init)
 			continue;
-		wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
+		wrmsrl(MSR_IA32_MC0_CTL+4*i, b->ctl);
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 }
@@ -1223,7 +1232,7 @@ static void mce_cpu_quirks(struct cpuinf
 			 * trips off incorrectly with the IOMMU & 3ware
 			 * & Cerberus:
 			 */
-			clear_bit(10, (unsigned long *)&bank[4]);
+			clear_bit(10, (unsigned long *)&mce_banks[4].ctl);
 		}
 		if (c->x86 <= 17 && mce_bootlog < 0) {
 			/*
@@ -1237,7 +1246,7 @@ static void mce_cpu_quirks(struct cpuinf
 		 * by default.
 		 */
 		 if (c->x86 == 6 && banks > 0)
-			bank[0] = 0;
+			mce_banks[0].ctl = 0;
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
@@ -1250,8 +1259,8 @@ static void mce_cpu_quirks(struct cpuinf
 		 * valid event later, merely don't write CTL0.
 		 */
 
-		if (c->x86 == 6 && c->x86_model < 0x1A)
-			__set_bit(0, &dont_init_banks);
+		if (c->x86 == 6 && c->x86_model < 0x1A && banks > 0)
+			mce_banks[0].init = 0;
 
 		/*
 		 * All newer Intel systems support MCE broadcasting. Enable
@@ -1578,7 +1587,8 @@ static int mce_disable(void)
 	int i;
 
 	for (i = 0; i < banks; i++) {
-		if (!skip_bank_init(i))
+		struct mce_bank *b = &mce_banks[i];
+		if (b->init)
 			wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
 	}
 	return 0;
@@ -1654,14 +1664,15 @@ DEFINE_PER_CPU(struct sys_device, mce_de
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
-static struct sysdev_attribute *bank_attrs;
+static inline struct mce_bank *attr_to_bank(struct sysdev_attribute *attr)
+{
+	return container_of(attr, struct mce_bank, attr);
+}
 
 static ssize_t show_bank(struct sys_device *s, struct sysdev_attribute *attr,
 			 char *buf)
 {
-	u64 b = bank[attr - bank_attrs];
-
-	return sprintf(buf, "%llx\n", b);
+	return sprintf(buf, "%llx\n", attr_to_bank(attr)->ctl);
 }
 
 static ssize_t set_bank(struct sys_device *s, struct sysdev_attribute *attr,
@@ -1672,7 +1683,7 @@ static ssize_t set_bank(struct sys_devic
 	if (strict_strtoull(buf, 0, &new) < 0)
 		return -EINVAL;
 
-	bank[attr - bank_attrs] = new;
+	attr_to_bank(attr)->ctl = new;
 	mce_restart();
 
 	return size;
@@ -1816,7 +1827,7 @@ static __cpuinit int mce_create_device(u
 	}
 	for (j = 0; j < banks; j++) {
 		err = sysdev_create_file(&per_cpu(mce_dev, cpu),
-					&bank_attrs[j]);
+					&mce_banks[j].attr);
 		if (err)
 			goto error2;
 	}
@@ -1825,10 +1836,10 @@ static __cpuinit int mce_create_device(u
 	return 0;
 error2:
 	while (--j >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &bank_attrs[j]);
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[i].attr);
 
 	sysdev_unregister(&per_cpu(mce_dev, cpu));
 
@@ -1846,7 +1857,7 @@ static __cpuinit void mce_remove_device(
 		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
 
 	for (i = 0; i < banks; i++)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &bank_attrs[i]);
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[i].attr);
 
 	sysdev_unregister(&per_cpu(mce_dev, cpu));
 	cpumask_clear_cpu(cpu, mce_dev_initialized);
@@ -1863,7 +1874,8 @@ static void mce_disable_cpu(void *h)
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_clear();
 	for (i = 0; i < banks; i++) {
-		if (!skip_bank_init(i))
+		struct mce_bank *b = &mce_banks[i];
+		if (b->init)
 			wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
 	}
 }
@@ -1879,8 +1891,9 @@ static void mce_reenable_cpu(void *h)
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_reenable();
 	for (i = 0; i < banks; i++) {
-		if (!skip_bank_init(i))
-			wrmsrl(MSR_IA32_MC0_CTL + i*4, bank[i]);
+		struct mce_bank *b = &mce_banks[i];
+		if (b->init)
+			wrmsrl(MSR_IA32_MC0_CTL + i*4, b->ctl);
 	}
 }
 
@@ -1928,35 +1941,21 @@ static struct notifier_block mce_cpu_not
 	.notifier_call = mce_cpu_callback,
 };
 
-static __init int mce_init_banks(void)
+static __init void mce_init_banks(void)
 {
 	int i;
 
-	bank_attrs = kzalloc(sizeof(struct sysdev_attribute) * banks,
-				GFP_KERNEL);
-	if (!bank_attrs)
-		return -ENOMEM;
-
 	for (i = 0; i < banks; i++) {
-		struct sysdev_attribute *a = &bank_attrs[i];
+		struct mce_bank *b = &mce_banks[i];
+		struct sysdev_attribute *a = &b->attr;
 
-		a->attr.name	= kasprintf(GFP_KERNEL, "bank%d", i);
-		if (!a->attr.name)
-			goto nomem;
+		a->attr.name	= b->attrname;
+		snprintf(b->attrname, ATTR_LEN, "bank%d", i);
 
 		a->attr.mode	= 0644;
 		a->show		= show_bank;
 		a->store	= set_bank;
 	}
-	return 0;
-
-nomem:
-	while (--i >= 0)
-		kfree(bank_attrs[i].attr.name);
-	kfree(bank_attrs);
-	bank_attrs = NULL;
-
-	return -ENOMEM;
 }
 
 static __init int mce_init_device(void)
@@ -1969,9 +1968,7 @@ static __init int mce_init_device(void)
 
 	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
 
-	err = mce_init_banks();
-	if (err)
-		return err;
+	mce_init_banks();
 
 	err = sysdev_class_register(&mce_sysclass);
 	if (err)
Index: linux/arch/x86/kernel/cpu/mcheck/mce-internal.h
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ linux/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -1,3 +1,4 @@
+#include <linux/sysdev.h>
 #include <asm/mce.h>
 
 enum severity_level {
@@ -10,6 +11,19 @@ enum severity_level {
 	MCE_PANIC_SEVERITY,
 };
 
+#define ATTR_LEN		16
+
+/* One object for each MCE bank, shared by all CPUs */
+struct mce_bank {
+	u64			ctl;			/* subevents to enable */
+	unsigned char init;				/* initialise bank? */
+	struct sysdev_attribute attr;			/* sysdev attribute */
+	char			attrname[ATTR_LEN];	/* attribute name */
+};
+
 int mce_severity(struct mce *a, int tolerant, char **msg);
 
 extern int mce_ser;
+
+extern struct mce_bank *mce_banks;
+
