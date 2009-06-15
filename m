Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZFOI2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZFOI2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbZFOI2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:28:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53653 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704AbZFOI2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:28:44 -0400
Message-ID: <4A360636.50705@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:28:38 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/16] x86, mce: rename
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename files that are no longer 64bit specific:
	mce_amd_64.c	=> mce_amd.c
	mce_intel_64.c	=> mce_intel.c

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/Makefile       |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |  703 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |  703 -----------------------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |  225 +++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |  225 ---------
 5 files changed, 930 insertions(+), 930 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce_amd.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_amd_64.c
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel.c
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel_64.c

diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index 659564e..188a1ca 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -3,8 +3,8 @@ obj-y				=  mce.o
 obj-$(CONFIG_X86_NEW_MCE)	+= mce-severity.o
 obj-$(CONFIG_X86_OLD_MCE)	+= k7.o p4.o p6.o
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
-obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o
-obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
+obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
+obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
 obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
new file mode 100644
index 0000000..ddae216
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -0,0 +1,703 @@
+/*
+ *  (c) 2005, 2006 Advanced Micro Devices, Inc.
+ *  Your use of this code is subject to the terms and conditions of the
+ *  GNU general public license version 2. See "COPYING" or
+ *  http://www.gnu.org/licenses/gpl.html
+ *
+ *  Written by Jacob Shin - AMD, Inc.
+ *
+ *  Support : jacob.shin@amd.com
+ *
+ *  April 2006
+ *     - added support for AMD Family 0x10 processors
+ *
+ *  All MC4_MISCi registers are shared between multi-cores
+ */
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/kobject.h>
+#include <linux/percpu.h>
+#include <linux/sysdev.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+
+#include <asm/apic.h>
+#include <asm/idle.h>
+#include <asm/mce.h>
+#include <asm/msr.h>
+
+#define PFX               "mce_threshold: "
+#define VERSION           "version 1.1.1"
+#define NR_BANKS          6
+#define NR_BLOCKS         9
+#define THRESHOLD_MAX     0xFFF
+#define INT_TYPE_APIC     0x00020000
+#define MASK_VALID_HI     0x80000000
+#define MASK_CNTP_HI      0x40000000
+#define MASK_LOCKED_HI    0x20000000
+#define MASK_LVTOFF_HI    0x00F00000
+#define MASK_COUNT_EN_HI  0x00080000
+#define MASK_INT_TYPE_HI  0x00060000
+#define MASK_OVERFLOW_HI  0x00010000
+#define MASK_ERR_COUNT_HI 0x00000FFF
+#define MASK_BLKPTR_LO    0xFF000000
+#define MCG_XBLK_ADDR     0xC0000400
+
+struct threshold_block {
+	unsigned int		block;
+	unsigned int		bank;
+	unsigned int		cpu;
+	u32			address;
+	u16			interrupt_enable;
+	u16			threshold_limit;
+	struct kobject		kobj;
+	struct list_head	miscj;
+};
+
+/* defaults used early on boot */
+static struct threshold_block threshold_defaults = {
+	.interrupt_enable	= 0,
+	.threshold_limit	= THRESHOLD_MAX,
+};
+
+struct threshold_bank {
+	struct kobject		*kobj;
+	struct threshold_block	*blocks;
+	cpumask_var_t		cpus;
+};
+static DEFINE_PER_CPU(struct threshold_bank *, threshold_banks[NR_BANKS]);
+
+#ifdef CONFIG_SMP
+static unsigned char shared_bank[NR_BANKS] = {
+	0, 0, 0, 0, 1
+};
+#endif
+
+static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
+
+static void amd_threshold_interrupt(void);
+
+/*
+ * CPU Initialization
+ */
+
+struct thresh_restart {
+	struct threshold_block	*b;
+	int			reset;
+	u16			old_limit;
+};
+
+/* must be called with correct cpu affinity */
+/* Called via smp_call_function_single() */
+static void threshold_restart_bank(void *_tr)
+{
+	struct thresh_restart *tr = _tr;
+	u32 mci_misc_hi, mci_misc_lo;
+
+	rdmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+
+	if (tr->b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
+		tr->reset = 1;	/* limit cannot be lower than err count */
+
+	if (tr->reset) {		/* reset err count and overflow bit */
+		mci_misc_hi =
+		    (mci_misc_hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
+		    (THRESHOLD_MAX - tr->b->threshold_limit);
+	} else if (tr->old_limit) {	/* change limit w/o reset */
+		int new_count = (mci_misc_hi & THRESHOLD_MAX) +
+		    (tr->old_limit - tr->b->threshold_limit);
+
+		mci_misc_hi = (mci_misc_hi & ~MASK_ERR_COUNT_HI) |
+		    (new_count & THRESHOLD_MAX);
+	}
+
+	tr->b->interrupt_enable ?
+	    (mci_misc_hi = (mci_misc_hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
+	    (mci_misc_hi &= ~MASK_INT_TYPE_HI);
+
+	mci_misc_hi |= MASK_COUNT_EN_HI;
+	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
+}
+
+/* cpu init entry point, called from mce.c with preempt off */
+void mce_amd_feature_init(struct cpuinfo_x86 *c)
+{
+	unsigned int cpu = smp_processor_id();
+	u32 low = 0, high = 0, address = 0;
+	unsigned int bank, block;
+	struct thresh_restart tr;
+	u8 lvt_off;
+
+	for (bank = 0; bank < NR_BANKS; ++bank) {
+		for (block = 0; block < NR_BLOCKS; ++block) {
+			if (block == 0)
+				address = MSR_IA32_MC0_MISC + bank * 4;
+			else if (block == 1) {
+				address = (low & MASK_BLKPTR_LO) >> 21;
+				if (!address)
+					break;
+				address += MCG_XBLK_ADDR;
+			} else
+				++address;
+
+			if (rdmsr_safe(address, &low, &high))
+				break;
+
+			if (!(high & MASK_VALID_HI)) {
+				if (block)
+					continue;
+				else
+					break;
+			}
+
+			if (!(high & MASK_CNTP_HI)  ||
+			     (high & MASK_LOCKED_HI))
+				continue;
+
+			if (!block)
+				per_cpu(bank_map, cpu) |= (1 << bank);
+#ifdef CONFIG_SMP
+			if (shared_bank[bank] && c->cpu_core_id)
+				break;
+#endif
+			lvt_off = setup_APIC_eilvt_mce(THRESHOLD_APIC_VECTOR,
+						       APIC_EILVT_MSG_FIX, 0);
+
+			high &= ~MASK_LVTOFF_HI;
+			high |= lvt_off << 20;
+			wrmsr(address, low, high);
+
+			threshold_defaults.address = address;
+			tr.b = &threshold_defaults;
+			tr.reset = 0;
+			tr.old_limit = 0;
+			threshold_restart_bank(&tr);
+
+			mce_threshold_vector = amd_threshold_interrupt;
+		}
+	}
+}
+
+/*
+ * APIC Interrupt Handler
+ */
+
+/*
+ * threshold interrupt handler will service THRESHOLD_APIC_VECTOR.
+ * the interrupt goes off when error_count reaches threshold_limit.
+ * the handler will simply log mcelog w/ software defined bank number.
+ */
+static void amd_threshold_interrupt(void)
+{
+	u32 low = 0, high = 0, address = 0;
+	unsigned int bank, block;
+	struct mce m;
+
+	mce_setup(&m);
+
+	/* assume first bank caused it */
+	for (bank = 0; bank < NR_BANKS; ++bank) {
+		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
+			continue;
+		for (block = 0; block < NR_BLOCKS; ++block) {
+			if (block == 0) {
+				address = MSR_IA32_MC0_MISC + bank * 4;
+			} else if (block == 1) {
+				address = (low & MASK_BLKPTR_LO) >> 21;
+				if (!address)
+					break;
+				address += MCG_XBLK_ADDR;
+			} else {
+				++address;
+			}
+
+			if (rdmsr_safe(address, &low, &high))
+				break;
+
+			if (!(high & MASK_VALID_HI)) {
+				if (block)
+					continue;
+				else
+					break;
+			}
+
+			if (!(high & MASK_CNTP_HI)  ||
+			     (high & MASK_LOCKED_HI))
+				continue;
+
+			/*
+			 * Log the machine check that caused the threshold
+			 * event.
+			 */
+			machine_check_poll(MCP_TIMESTAMP,
+					&__get_cpu_var(mce_poll_banks));
+
+			if (high & MASK_OVERFLOW_HI) {
+				rdmsrl(address, m.misc);
+				rdmsrl(MSR_IA32_MC0_STATUS + bank * 4,
+				       m.status);
+				m.bank = K8_MCE_THRESHOLD_BASE
+				       + bank * NR_BLOCKS
+				       + block;
+				mce_log(&m);
+				return;
+			}
+		}
+	}
+}
+
+/*
+ * Sysfs Interface
+ */
+
+struct threshold_attr {
+	struct attribute attr;
+	ssize_t (*show) (struct threshold_block *, char *);
+	ssize_t (*store) (struct threshold_block *, const char *, size_t count);
+};
+
+#define SHOW_FIELDS(name)						\
+static ssize_t show_ ## name(struct threshold_block *b, char *buf)	\
+{									\
+	return sprintf(buf, "%lx\n", (unsigned long) b->name);		\
+}
+SHOW_FIELDS(interrupt_enable)
+SHOW_FIELDS(threshold_limit)
+
+static ssize_t
+store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
+{
+	struct thresh_restart tr;
+	unsigned long new;
+
+	if (strict_strtoul(buf, 0, &new) < 0)
+		return -EINVAL;
+
+	b->interrupt_enable = !!new;
+
+	tr.b		= b;
+	tr.reset	= 0;
+	tr.old_limit	= 0;
+
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
+
+	return size;
+}
+
+static ssize_t
+store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
+{
+	struct thresh_restart tr;
+	unsigned long new;
+
+	if (strict_strtoul(buf, 0, &new) < 0)
+		return -EINVAL;
+
+	if (new > THRESHOLD_MAX)
+		new = THRESHOLD_MAX;
+	if (new < 1)
+		new = 1;
+
+	tr.old_limit = b->threshold_limit;
+	b->threshold_limit = new;
+	tr.b = b;
+	tr.reset = 0;
+
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
+
+	return size;
+}
+
+struct threshold_block_cross_cpu {
+	struct threshold_block	*tb;
+	long			retval;
+};
+
+static void local_error_count_handler(void *_tbcc)
+{
+	struct threshold_block_cross_cpu *tbcc = _tbcc;
+	struct threshold_block *b = tbcc->tb;
+	u32 low, high;
+
+	rdmsr(b->address, low, high);
+	tbcc->retval = (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
+}
+
+static ssize_t show_error_count(struct threshold_block *b, char *buf)
+{
+	struct threshold_block_cross_cpu tbcc = { .tb = b, };
+
+	smp_call_function_single(b->cpu, local_error_count_handler, &tbcc, 1);
+	return sprintf(buf, "%lx\n", tbcc.retval);
+}
+
+static ssize_t store_error_count(struct threshold_block *b,
+				 const char *buf, size_t count)
+{
+	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
+
+	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
+	return 1;
+}
+
+#define RW_ATTR(val)							\
+static struct threshold_attr val = {					\
+	.attr	= {.name = __stringify(val), .mode = 0644 },		\
+	.show	= show_## val,						\
+	.store	= store_## val,						\
+};
+
+RW_ATTR(interrupt_enable);
+RW_ATTR(threshold_limit);
+RW_ATTR(error_count);
+
+static struct attribute *default_attrs[] = {
+	&interrupt_enable.attr,
+	&threshold_limit.attr,
+	&error_count.attr,
+	NULL
+};
+
+#define to_block(k)	container_of(k, struct threshold_block, kobj)
+#define to_attr(a)	container_of(a, struct threshold_attr, attr)
+
+static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	struct threshold_block *b = to_block(kobj);
+	struct threshold_attr *a = to_attr(attr);
+	ssize_t ret;
+
+	ret = a->show ? a->show(b, buf) : -EIO;
+
+	return ret;
+}
+
+static ssize_t store(struct kobject *kobj, struct attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct threshold_block *b = to_block(kobj);
+	struct threshold_attr *a = to_attr(attr);
+	ssize_t ret;
+
+	ret = a->store ? a->store(b, buf, count) : -EIO;
+
+	return ret;
+}
+
+static struct sysfs_ops threshold_ops = {
+	.show			= show,
+	.store			= store,
+};
+
+static struct kobj_type threshold_ktype = {
+	.sysfs_ops		= &threshold_ops,
+	.default_attrs		= default_attrs,
+};
+
+static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
+					       unsigned int bank,
+					       unsigned int block,
+					       u32 address)
+{
+	struct threshold_block *b = NULL;
+	u32 low, high;
+	int err;
+
+	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
+		return 0;
+
+	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
+		return 0;
+
+	if (!(high & MASK_VALID_HI)) {
+		if (block)
+			goto recurse;
+		else
+			return 0;
+	}
+
+	if (!(high & MASK_CNTP_HI)  ||
+	     (high & MASK_LOCKED_HI))
+		goto recurse;
+
+	b = kzalloc(sizeof(struct threshold_block), GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	b->block		= block;
+	b->bank			= bank;
+	b->cpu			= cpu;
+	b->address		= address;
+	b->interrupt_enable	= 0;
+	b->threshold_limit	= THRESHOLD_MAX;
+
+	INIT_LIST_HEAD(&b->miscj);
+
+	if (per_cpu(threshold_banks, cpu)[bank]->blocks) {
+		list_add(&b->miscj,
+			 &per_cpu(threshold_banks, cpu)[bank]->blocks->miscj);
+	} else {
+		per_cpu(threshold_banks, cpu)[bank]->blocks = b;
+	}
+
+	err = kobject_init_and_add(&b->kobj, &threshold_ktype,
+				   per_cpu(threshold_banks, cpu)[bank]->kobj,
+				   "misc%i", block);
+	if (err)
+		goto out_free;
+recurse:
+	if (!block) {
+		address = (low & MASK_BLKPTR_LO) >> 21;
+		if (!address)
+			return 0;
+		address += MCG_XBLK_ADDR;
+	} else {
+		++address;
+	}
+
+	err = allocate_threshold_blocks(cpu, bank, ++block, address);
+	if (err)
+		goto out_free;
+
+	if (b)
+		kobject_uevent(&b->kobj, KOBJ_ADD);
+
+	return err;
+
+out_free:
+	if (b) {
+		kobject_put(&b->kobj);
+		kfree(b);
+	}
+	return err;
+}
+
+static __cpuinit long
+local_allocate_threshold_blocks(int cpu, unsigned int bank)
+{
+	return allocate_threshold_blocks(cpu, bank, 0,
+					 MSR_IA32_MC0_MISC + bank * 4);
+}
+
+/* symlinks sibling shared banks to first core.  first core owns dir/files. */
+static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
+{
+	int i, err = 0;
+	struct threshold_bank *b = NULL;
+	char name[32];
+
+	sprintf(name, "threshold_bank%i", bank);
+
+#ifdef CONFIG_SMP
+	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
+		i = cpumask_first(cpu_core_mask(cpu));
+
+		/* first core not up yet */
+		if (cpu_data(i).cpu_core_id)
+			goto out;
+
+		/* already linked */
+		if (per_cpu(threshold_banks, cpu)[bank])
+			goto out;
+
+		b = per_cpu(threshold_banks, i)[bank];
+
+		if (!b)
+			goto out;
+
+		err = sysfs_create_link(&per_cpu(mce_dev, cpu).kobj,
+					b->kobj, name);
+		if (err)
+			goto out;
+
+		cpumask_copy(b->cpus, cpu_core_mask(cpu));
+		per_cpu(threshold_banks, cpu)[bank] = b;
+
+		goto out;
+	}
+#endif
+
+	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
+	if (!b) {
+		err = -ENOMEM;
+		goto out;
+	}
+	if (!alloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
+		kfree(b);
+		err = -ENOMEM;
+		goto out;
+	}
+
+	b->kobj = kobject_create_and_add(name, &per_cpu(mce_dev, cpu).kobj);
+	if (!b->kobj)
+		goto out_free;
+
+#ifndef CONFIG_SMP
+	cpumask_setall(b->cpus);
+#else
+	cpumask_copy(b->cpus, cpu_core_mask(cpu));
+#endif
+
+	per_cpu(threshold_banks, cpu)[bank] = b;
+
+	err = local_allocate_threshold_blocks(cpu, bank);
+	if (err)
+		goto out_free;
+
+	for_each_cpu(i, b->cpus) {
+		if (i == cpu)
+			continue;
+
+		err = sysfs_create_link(&per_cpu(mce_dev, i).kobj,
+					b->kobj, name);
+		if (err)
+			goto out;
+
+		per_cpu(threshold_banks, i)[bank] = b;
+	}
+
+	goto out;
+
+out_free:
+	per_cpu(threshold_banks, cpu)[bank] = NULL;
+	free_cpumask_var(b->cpus);
+	kfree(b);
+out:
+	return err;
+}
+
+/* create dir/files for all valid threshold banks */
+static __cpuinit int threshold_create_device(unsigned int cpu)
+{
+	unsigned int bank;
+	int err = 0;
+
+	for (bank = 0; bank < NR_BANKS; ++bank) {
+		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
+			continue;
+		err = threshold_create_bank(cpu, bank);
+		if (err)
+			goto out;
+	}
+out:
+	return err;
+}
+
+/*
+ * let's be hotplug friendly.
+ * in case of multiple core processors, the first core always takes ownership
+ *   of shared sysfs dir/files, and rest of the cores will be symlinked to it.
+ */
+
+static void deallocate_threshold_block(unsigned int cpu,
+						 unsigned int bank)
+{
+	struct threshold_block *pos = NULL;
+	struct threshold_block *tmp = NULL;
+	struct threshold_bank *head = per_cpu(threshold_banks, cpu)[bank];
+
+	if (!head)
+		return;
+
+	list_for_each_entry_safe(pos, tmp, &head->blocks->miscj, miscj) {
+		kobject_put(&pos->kobj);
+		list_del(&pos->miscj);
+		kfree(pos);
+	}
+
+	kfree(per_cpu(threshold_banks, cpu)[bank]->blocks);
+	per_cpu(threshold_banks, cpu)[bank]->blocks = NULL;
+}
+
+static void threshold_remove_bank(unsigned int cpu, int bank)
+{
+	struct threshold_bank *b;
+	char name[32];
+	int i = 0;
+
+	b = per_cpu(threshold_banks, cpu)[bank];
+	if (!b)
+		return;
+	if (!b->blocks)
+		goto free_out;
+
+	sprintf(name, "threshold_bank%i", bank);
+
+#ifdef CONFIG_SMP
+	/* sibling symlink */
+	if (shared_bank[bank] && b->blocks->cpu != cpu) {
+		sysfs_remove_link(&per_cpu(mce_dev, cpu).kobj, name);
+		per_cpu(threshold_banks, cpu)[bank] = NULL;
+
+		return;
+	}
+#endif
+
+	/* remove all sibling symlinks before unregistering */
+	for_each_cpu(i, b->cpus) {
+		if (i == cpu)
+			continue;
+
+		sysfs_remove_link(&per_cpu(mce_dev, i).kobj, name);
+		per_cpu(threshold_banks, i)[bank] = NULL;
+	}
+
+	deallocate_threshold_block(cpu, bank);
+
+free_out:
+	kobject_del(b->kobj);
+	kobject_put(b->kobj);
+	free_cpumask_var(b->cpus);
+	kfree(b);
+	per_cpu(threshold_banks, cpu)[bank] = NULL;
+}
+
+static void threshold_remove_device(unsigned int cpu)
+{
+	unsigned int bank;
+
+	for (bank = 0; bank < NR_BANKS; ++bank) {
+		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
+			continue;
+		threshold_remove_bank(cpu, bank);
+	}
+}
+
+/* get notified when a cpu comes on/off */
+static void __cpuinit
+amd_64_threshold_cpu_callback(unsigned long action, unsigned int cpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		threshold_create_device(cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		threshold_remove_device(cpu);
+		break;
+	default:
+		break;
+	}
+}
+
+static __init int threshold_init_device(void)
+{
+	unsigned lcpu = 0;
+
+	/* to hit CPUs online before the notifier is up */
+	for_each_online_cpu(lcpu) {
+		int err = threshold_create_device(lcpu);
+
+		if (err)
+			return err;
+	}
+	threshold_cpu_callback = amd_64_threshold_cpu_callback;
+
+	return 0;
+}
+device_initcall(threshold_init_device);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
deleted file mode 100644
index ddae216..0000000
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ /dev/null
@@ -1,703 +0,0 @@
-/*
- *  (c) 2005, 2006 Advanced Micro Devices, Inc.
- *  Your use of this code is subject to the terms and conditions of the
- *  GNU general public license version 2. See "COPYING" or
- *  http://www.gnu.org/licenses/gpl.html
- *
- *  Written by Jacob Shin - AMD, Inc.
- *
- *  Support : jacob.shin@amd.com
- *
- *  April 2006
- *     - added support for AMD Family 0x10 processors
- *
- *  All MC4_MISCi registers are shared between multi-cores
- */
-#include <linux/interrupt.h>
-#include <linux/notifier.h>
-#include <linux/kobject.h>
-#include <linux/percpu.h>
-#include <linux/sysdev.h>
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/sysfs.h>
-#include <linux/init.h>
-#include <linux/cpu.h>
-#include <linux/smp.h>
-
-#include <asm/apic.h>
-#include <asm/idle.h>
-#include <asm/mce.h>
-#include <asm/msr.h>
-
-#define PFX               "mce_threshold: "
-#define VERSION           "version 1.1.1"
-#define NR_BANKS          6
-#define NR_BLOCKS         9
-#define THRESHOLD_MAX     0xFFF
-#define INT_TYPE_APIC     0x00020000
-#define MASK_VALID_HI     0x80000000
-#define MASK_CNTP_HI      0x40000000
-#define MASK_LOCKED_HI    0x20000000
-#define MASK_LVTOFF_HI    0x00F00000
-#define MASK_COUNT_EN_HI  0x00080000
-#define MASK_INT_TYPE_HI  0x00060000
-#define MASK_OVERFLOW_HI  0x00010000
-#define MASK_ERR_COUNT_HI 0x00000FFF
-#define MASK_BLKPTR_LO    0xFF000000
-#define MCG_XBLK_ADDR     0xC0000400
-
-struct threshold_block {
-	unsigned int		block;
-	unsigned int		bank;
-	unsigned int		cpu;
-	u32			address;
-	u16			interrupt_enable;
-	u16			threshold_limit;
-	struct kobject		kobj;
-	struct list_head	miscj;
-};
-
-/* defaults used early on boot */
-static struct threshold_block threshold_defaults = {
-	.interrupt_enable	= 0,
-	.threshold_limit	= THRESHOLD_MAX,
-};
-
-struct threshold_bank {
-	struct kobject		*kobj;
-	struct threshold_block	*blocks;
-	cpumask_var_t		cpus;
-};
-static DEFINE_PER_CPU(struct threshold_bank *, threshold_banks[NR_BANKS]);
-
-#ifdef CONFIG_SMP
-static unsigned char shared_bank[NR_BANKS] = {
-	0, 0, 0, 0, 1
-};
-#endif
-
-static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
-
-static void amd_threshold_interrupt(void);
-
-/*
- * CPU Initialization
- */
-
-struct thresh_restart {
-	struct threshold_block	*b;
-	int			reset;
-	u16			old_limit;
-};
-
-/* must be called with correct cpu affinity */
-/* Called via smp_call_function_single() */
-static void threshold_restart_bank(void *_tr)
-{
-	struct thresh_restart *tr = _tr;
-	u32 mci_misc_hi, mci_misc_lo;
-
-	rdmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
-
-	if (tr->b->threshold_limit < (mci_misc_hi & THRESHOLD_MAX))
-		tr->reset = 1;	/* limit cannot be lower than err count */
-
-	if (tr->reset) {		/* reset err count and overflow bit */
-		mci_misc_hi =
-		    (mci_misc_hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
-		    (THRESHOLD_MAX - tr->b->threshold_limit);
-	} else if (tr->old_limit) {	/* change limit w/o reset */
-		int new_count = (mci_misc_hi & THRESHOLD_MAX) +
-		    (tr->old_limit - tr->b->threshold_limit);
-
-		mci_misc_hi = (mci_misc_hi & ~MASK_ERR_COUNT_HI) |
-		    (new_count & THRESHOLD_MAX);
-	}
-
-	tr->b->interrupt_enable ?
-	    (mci_misc_hi = (mci_misc_hi & ~MASK_INT_TYPE_HI) | INT_TYPE_APIC) :
-	    (mci_misc_hi &= ~MASK_INT_TYPE_HI);
-
-	mci_misc_hi |= MASK_COUNT_EN_HI;
-	wrmsr(tr->b->address, mci_misc_lo, mci_misc_hi);
-}
-
-/* cpu init entry point, called from mce.c with preempt off */
-void mce_amd_feature_init(struct cpuinfo_x86 *c)
-{
-	unsigned int cpu = smp_processor_id();
-	u32 low = 0, high = 0, address = 0;
-	unsigned int bank, block;
-	struct thresh_restart tr;
-	u8 lvt_off;
-
-	for (bank = 0; bank < NR_BANKS; ++bank) {
-		for (block = 0; block < NR_BLOCKS; ++block) {
-			if (block == 0)
-				address = MSR_IA32_MC0_MISC + bank * 4;
-			else if (block == 1) {
-				address = (low & MASK_BLKPTR_LO) >> 21;
-				if (!address)
-					break;
-				address += MCG_XBLK_ADDR;
-			} else
-				++address;
-
-			if (rdmsr_safe(address, &low, &high))
-				break;
-
-			if (!(high & MASK_VALID_HI)) {
-				if (block)
-					continue;
-				else
-					break;
-			}
-
-			if (!(high & MASK_CNTP_HI)  ||
-			     (high & MASK_LOCKED_HI))
-				continue;
-
-			if (!block)
-				per_cpu(bank_map, cpu) |= (1 << bank);
-#ifdef CONFIG_SMP
-			if (shared_bank[bank] && c->cpu_core_id)
-				break;
-#endif
-			lvt_off = setup_APIC_eilvt_mce(THRESHOLD_APIC_VECTOR,
-						       APIC_EILVT_MSG_FIX, 0);
-
-			high &= ~MASK_LVTOFF_HI;
-			high |= lvt_off << 20;
-			wrmsr(address, low, high);
-
-			threshold_defaults.address = address;
-			tr.b = &threshold_defaults;
-			tr.reset = 0;
-			tr.old_limit = 0;
-			threshold_restart_bank(&tr);
-
-			mce_threshold_vector = amd_threshold_interrupt;
-		}
-	}
-}
-
-/*
- * APIC Interrupt Handler
- */
-
-/*
- * threshold interrupt handler will service THRESHOLD_APIC_VECTOR.
- * the interrupt goes off when error_count reaches threshold_limit.
- * the handler will simply log mcelog w/ software defined bank number.
- */
-static void amd_threshold_interrupt(void)
-{
-	u32 low = 0, high = 0, address = 0;
-	unsigned int bank, block;
-	struct mce m;
-
-	mce_setup(&m);
-
-	/* assume first bank caused it */
-	for (bank = 0; bank < NR_BANKS; ++bank) {
-		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
-			continue;
-		for (block = 0; block < NR_BLOCKS; ++block) {
-			if (block == 0) {
-				address = MSR_IA32_MC0_MISC + bank * 4;
-			} else if (block == 1) {
-				address = (low & MASK_BLKPTR_LO) >> 21;
-				if (!address)
-					break;
-				address += MCG_XBLK_ADDR;
-			} else {
-				++address;
-			}
-
-			if (rdmsr_safe(address, &low, &high))
-				break;
-
-			if (!(high & MASK_VALID_HI)) {
-				if (block)
-					continue;
-				else
-					break;
-			}
-
-			if (!(high & MASK_CNTP_HI)  ||
-			     (high & MASK_LOCKED_HI))
-				continue;
-
-			/*
-			 * Log the machine check that caused the threshold
-			 * event.
-			 */
-			machine_check_poll(MCP_TIMESTAMP,
-					&__get_cpu_var(mce_poll_banks));
-
-			if (high & MASK_OVERFLOW_HI) {
-				rdmsrl(address, m.misc);
-				rdmsrl(MSR_IA32_MC0_STATUS + bank * 4,
-				       m.status);
-				m.bank = K8_MCE_THRESHOLD_BASE
-				       + bank * NR_BLOCKS
-				       + block;
-				mce_log(&m);
-				return;
-			}
-		}
-	}
-}
-
-/*
- * Sysfs Interface
- */
-
-struct threshold_attr {
-	struct attribute attr;
-	ssize_t (*show) (struct threshold_block *, char *);
-	ssize_t (*store) (struct threshold_block *, const char *, size_t count);
-};
-
-#define SHOW_FIELDS(name)						\
-static ssize_t show_ ## name(struct threshold_block *b, char *buf)	\
-{									\
-	return sprintf(buf, "%lx\n", (unsigned long) b->name);		\
-}
-SHOW_FIELDS(interrupt_enable)
-SHOW_FIELDS(threshold_limit)
-
-static ssize_t
-store_interrupt_enable(struct threshold_block *b, const char *buf, size_t size)
-{
-	struct thresh_restart tr;
-	unsigned long new;
-
-	if (strict_strtoul(buf, 0, &new) < 0)
-		return -EINVAL;
-
-	b->interrupt_enable = !!new;
-
-	tr.b		= b;
-	tr.reset	= 0;
-	tr.old_limit	= 0;
-
-	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
-
-	return size;
-}
-
-static ssize_t
-store_threshold_limit(struct threshold_block *b, const char *buf, size_t size)
-{
-	struct thresh_restart tr;
-	unsigned long new;
-
-	if (strict_strtoul(buf, 0, &new) < 0)
-		return -EINVAL;
-
-	if (new > THRESHOLD_MAX)
-		new = THRESHOLD_MAX;
-	if (new < 1)
-		new = 1;
-
-	tr.old_limit = b->threshold_limit;
-	b->threshold_limit = new;
-	tr.b = b;
-	tr.reset = 0;
-
-	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
-
-	return size;
-}
-
-struct threshold_block_cross_cpu {
-	struct threshold_block	*tb;
-	long			retval;
-};
-
-static void local_error_count_handler(void *_tbcc)
-{
-	struct threshold_block_cross_cpu *tbcc = _tbcc;
-	struct threshold_block *b = tbcc->tb;
-	u32 low, high;
-
-	rdmsr(b->address, low, high);
-	tbcc->retval = (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit);
-}
-
-static ssize_t show_error_count(struct threshold_block *b, char *buf)
-{
-	struct threshold_block_cross_cpu tbcc = { .tb = b, };
-
-	smp_call_function_single(b->cpu, local_error_count_handler, &tbcc, 1);
-	return sprintf(buf, "%lx\n", tbcc.retval);
-}
-
-static ssize_t store_error_count(struct threshold_block *b,
-				 const char *buf, size_t count)
-{
-	struct thresh_restart tr = { .b = b, .reset = 1, .old_limit = 0 };
-
-	smp_call_function_single(b->cpu, threshold_restart_bank, &tr, 1);
-	return 1;
-}
-
-#define RW_ATTR(val)							\
-static struct threshold_attr val = {					\
-	.attr	= {.name = __stringify(val), .mode = 0644 },		\
-	.show	= show_## val,						\
-	.store	= store_## val,						\
-};
-
-RW_ATTR(interrupt_enable);
-RW_ATTR(threshold_limit);
-RW_ATTR(error_count);
-
-static struct attribute *default_attrs[] = {
-	&interrupt_enable.attr,
-	&threshold_limit.attr,
-	&error_count.attr,
-	NULL
-};
-
-#define to_block(k)	container_of(k, struct threshold_block, kobj)
-#define to_attr(a)	container_of(a, struct threshold_attr, attr)
-
-static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
-{
-	struct threshold_block *b = to_block(kobj);
-	struct threshold_attr *a = to_attr(attr);
-	ssize_t ret;
-
-	ret = a->show ? a->show(b, buf) : -EIO;
-
-	return ret;
-}
-
-static ssize_t store(struct kobject *kobj, struct attribute *attr,
-		     const char *buf, size_t count)
-{
-	struct threshold_block *b = to_block(kobj);
-	struct threshold_attr *a = to_attr(attr);
-	ssize_t ret;
-
-	ret = a->store ? a->store(b, buf, count) : -EIO;
-
-	return ret;
-}
-
-static struct sysfs_ops threshold_ops = {
-	.show			= show,
-	.store			= store,
-};
-
-static struct kobj_type threshold_ktype = {
-	.sysfs_ops		= &threshold_ops,
-	.default_attrs		= default_attrs,
-};
-
-static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
-					       unsigned int bank,
-					       unsigned int block,
-					       u32 address)
-{
-	struct threshold_block *b = NULL;
-	u32 low, high;
-	int err;
-
-	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
-		return 0;
-
-	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
-		return 0;
-
-	if (!(high & MASK_VALID_HI)) {
-		if (block)
-			goto recurse;
-		else
-			return 0;
-	}
-
-	if (!(high & MASK_CNTP_HI)  ||
-	     (high & MASK_LOCKED_HI))
-		goto recurse;
-
-	b = kzalloc(sizeof(struct threshold_block), GFP_KERNEL);
-	if (!b)
-		return -ENOMEM;
-
-	b->block		= block;
-	b->bank			= bank;
-	b->cpu			= cpu;
-	b->address		= address;
-	b->interrupt_enable	= 0;
-	b->threshold_limit	= THRESHOLD_MAX;
-
-	INIT_LIST_HEAD(&b->miscj);
-
-	if (per_cpu(threshold_banks, cpu)[bank]->blocks) {
-		list_add(&b->miscj,
-			 &per_cpu(threshold_banks, cpu)[bank]->blocks->miscj);
-	} else {
-		per_cpu(threshold_banks, cpu)[bank]->blocks = b;
-	}
-
-	err = kobject_init_and_add(&b->kobj, &threshold_ktype,
-				   per_cpu(threshold_banks, cpu)[bank]->kobj,
-				   "misc%i", block);
-	if (err)
-		goto out_free;
-recurse:
-	if (!block) {
-		address = (low & MASK_BLKPTR_LO) >> 21;
-		if (!address)
-			return 0;
-		address += MCG_XBLK_ADDR;
-	} else {
-		++address;
-	}
-
-	err = allocate_threshold_blocks(cpu, bank, ++block, address);
-	if (err)
-		goto out_free;
-
-	if (b)
-		kobject_uevent(&b->kobj, KOBJ_ADD);
-
-	return err;
-
-out_free:
-	if (b) {
-		kobject_put(&b->kobj);
-		kfree(b);
-	}
-	return err;
-}
-
-static __cpuinit long
-local_allocate_threshold_blocks(int cpu, unsigned int bank)
-{
-	return allocate_threshold_blocks(cpu, bank, 0,
-					 MSR_IA32_MC0_MISC + bank * 4);
-}
-
-/* symlinks sibling shared banks to first core.  first core owns dir/files. */
-static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
-{
-	int i, err = 0;
-	struct threshold_bank *b = NULL;
-	char name[32];
-
-	sprintf(name, "threshold_bank%i", bank);
-
-#ifdef CONFIG_SMP
-	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(cpu_core_mask(cpu));
-
-		/* first core not up yet */
-		if (cpu_data(i).cpu_core_id)
-			goto out;
-
-		/* already linked */
-		if (per_cpu(threshold_banks, cpu)[bank])
-			goto out;
-
-		b = per_cpu(threshold_banks, i)[bank];
-
-		if (!b)
-			goto out;
-
-		err = sysfs_create_link(&per_cpu(mce_dev, cpu).kobj,
-					b->kobj, name);
-		if (err)
-			goto out;
-
-		cpumask_copy(b->cpus, cpu_core_mask(cpu));
-		per_cpu(threshold_banks, cpu)[bank] = b;
-
-		goto out;
-	}
-#endif
-
-	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
-	if (!b) {
-		err = -ENOMEM;
-		goto out;
-	}
-	if (!alloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
-		kfree(b);
-		err = -ENOMEM;
-		goto out;
-	}
-
-	b->kobj = kobject_create_and_add(name, &per_cpu(mce_dev, cpu).kobj);
-	if (!b->kobj)
-		goto out_free;
-
-#ifndef CONFIG_SMP
-	cpumask_setall(b->cpus);
-#else
-	cpumask_copy(b->cpus, cpu_core_mask(cpu));
-#endif
-
-	per_cpu(threshold_banks, cpu)[bank] = b;
-
-	err = local_allocate_threshold_blocks(cpu, bank);
-	if (err)
-		goto out_free;
-
-	for_each_cpu(i, b->cpus) {
-		if (i == cpu)
-			continue;
-
-		err = sysfs_create_link(&per_cpu(mce_dev, i).kobj,
-					b->kobj, name);
-		if (err)
-			goto out;
-
-		per_cpu(threshold_banks, i)[bank] = b;
-	}
-
-	goto out;
-
-out_free:
-	per_cpu(threshold_banks, cpu)[bank] = NULL;
-	free_cpumask_var(b->cpus);
-	kfree(b);
-out:
-	return err;
-}
-
-/* create dir/files for all valid threshold banks */
-static __cpuinit int threshold_create_device(unsigned int cpu)
-{
-	unsigned int bank;
-	int err = 0;
-
-	for (bank = 0; bank < NR_BANKS; ++bank) {
-		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
-			continue;
-		err = threshold_create_bank(cpu, bank);
-		if (err)
-			goto out;
-	}
-out:
-	return err;
-}
-
-/*
- * let's be hotplug friendly.
- * in case of multiple core processors, the first core always takes ownership
- *   of shared sysfs dir/files, and rest of the cores will be symlinked to it.
- */
-
-static void deallocate_threshold_block(unsigned int cpu,
-						 unsigned int bank)
-{
-	struct threshold_block *pos = NULL;
-	struct threshold_block *tmp = NULL;
-	struct threshold_bank *head = per_cpu(threshold_banks, cpu)[bank];
-
-	if (!head)
-		return;
-
-	list_for_each_entry_safe(pos, tmp, &head->blocks->miscj, miscj) {
-		kobject_put(&pos->kobj);
-		list_del(&pos->miscj);
-		kfree(pos);
-	}
-
-	kfree(per_cpu(threshold_banks, cpu)[bank]->blocks);
-	per_cpu(threshold_banks, cpu)[bank]->blocks = NULL;
-}
-
-static void threshold_remove_bank(unsigned int cpu, int bank)
-{
-	struct threshold_bank *b;
-	char name[32];
-	int i = 0;
-
-	b = per_cpu(threshold_banks, cpu)[bank];
-	if (!b)
-		return;
-	if (!b->blocks)
-		goto free_out;
-
-	sprintf(name, "threshold_bank%i", bank);
-
-#ifdef CONFIG_SMP
-	/* sibling symlink */
-	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		sysfs_remove_link(&per_cpu(mce_dev, cpu).kobj, name);
-		per_cpu(threshold_banks, cpu)[bank] = NULL;
-
-		return;
-	}
-#endif
-
-	/* remove all sibling symlinks before unregistering */
-	for_each_cpu(i, b->cpus) {
-		if (i == cpu)
-			continue;
-
-		sysfs_remove_link(&per_cpu(mce_dev, i).kobj, name);
-		per_cpu(threshold_banks, i)[bank] = NULL;
-	}
-
-	deallocate_threshold_block(cpu, bank);
-
-free_out:
-	kobject_del(b->kobj);
-	kobject_put(b->kobj);
-	free_cpumask_var(b->cpus);
-	kfree(b);
-	per_cpu(threshold_banks, cpu)[bank] = NULL;
-}
-
-static void threshold_remove_device(unsigned int cpu)
-{
-	unsigned int bank;
-
-	for (bank = 0; bank < NR_BANKS; ++bank) {
-		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
-			continue;
-		threshold_remove_bank(cpu, bank);
-	}
-}
-
-/* get notified when a cpu comes on/off */
-static void __cpuinit
-amd_64_threshold_cpu_callback(unsigned long action, unsigned int cpu)
-{
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		threshold_create_device(cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		threshold_remove_device(cpu);
-		break;
-	default:
-		break;
-	}
-}
-
-static __init int threshold_init_device(void)
-{
-	unsigned lcpu = 0;
-
-	/* to hit CPUs online before the notifier is up */
-	for_each_online_cpu(lcpu) {
-		int err = threshold_create_device(lcpu);
-
-		if (err)
-			return err;
-	}
-	threshold_cpu_callback = amd_64_threshold_cpu_callback;
-
-	return 0;
-}
-device_initcall(threshold_init_device);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
new file mode 100644
index 0000000..663a88e
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -0,0 +1,225 @@
+/*
+ * Intel specific MCE features.
+ * Copyright 2004 Zwane Mwaikambo <zwane@linuxpower.ca>
+ * Copyright (C) 2008, 2009 Intel Corporation
+ * Author: Andi Kleen
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/percpu.h>
+#include <asm/processor.h>
+#include <asm/msr.h>
+#include <asm/mce.h>
+
+/*
+ * Support for Intel Correct Machine Check Interrupts. This allows
+ * the CPU to raise an interrupt when a corrected machine check happened.
+ * Normally we pick those up using a regular polling timer.
+ * Also supports reliable discovery of shared banks.
+ */
+
+static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
+
+/*
+ * cmci_discover_lock protects against parallel discovery attempts
+ * which could race against each other.
+ */
+static DEFINE_SPINLOCK(cmci_discover_lock);
+
+#define CMCI_THRESHOLD 1
+
+static int cmci_supported(int *banks)
+{
+	u64 cap;
+
+	if (mce_cmci_disabled || mce_ignore_ce)
+		return 0;
+
+	/*
+	 * Vendor check is not strictly needed, but the initial
+	 * initialization is vendor keyed and this
+	 * makes sure none of the backdoors are entered otherwise.
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+	if (!cpu_has_apic || lapic_get_maxlvt() < 6)
+		return 0;
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	*banks = min_t(unsigned, MAX_NR_BANKS, cap & 0xff);
+	return !!(cap & MCG_CMCI_P);
+}
+
+/*
+ * The interrupt handler. This is called on every event.
+ * Just call the poller directly to log any events.
+ * This could in theory increase the threshold under high load,
+ * but doesn't for now.
+ */
+static void intel_threshold_interrupt(void)
+{
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	mce_notify_irq();
+}
+
+static void print_update(char *type, int *hdr, int num)
+{
+	if (*hdr == 0)
+		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
+	*hdr = 1;
+	printk(KERN_CONT " %s:%d", type, num);
+}
+
+/*
+ * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
+ * on this CPU. Use the algorithm recommended in the SDM to discover shared
+ * banks.
+ */
+static void cmci_discover(int banks, int boot)
+{
+	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
+	unsigned long flags;
+	int hdr = 0;
+	int i;
+
+	spin_lock_irqsave(&cmci_discover_lock, flags);
+	for (i = 0; i < banks; i++) {
+		u64 val;
+
+		if (test_bit(i, owned))
+			continue;
+
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+
+		/* Already owned by someone else? */
+		if (val & CMCI_EN) {
+			if (test_and_clear_bit(i, owned) || boot)
+				print_update("SHD", &hdr, i);
+			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			continue;
+		}
+
+		val |= CMCI_EN | CMCI_THRESHOLD;
+		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+
+		/* Did the enable bit stick? -- the bank supports CMCI */
+		if (val & CMCI_EN) {
+			if (!test_and_set_bit(i, owned) || boot)
+				print_update("CMCI", &hdr, i);
+			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+		} else {
+			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
+		}
+	}
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	if (hdr)
+		printk(KERN_CONT "\n");
+}
+
+/*
+ * Just in case we missed an event during initialization check
+ * all the CMCI owned banks.
+ */
+void cmci_recheck(void)
+{
+	unsigned long flags;
+	int banks;
+
+	if (!mce_available(&current_cpu_data) || !cmci_supported(&banks))
+		return;
+	local_irq_save(flags);
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	local_irq_restore(flags);
+}
+
+/*
+ * Disable CMCI on this CPU for all banks it owns when it goes down.
+ * This allows other CPUs to claim the banks on rediscovery.
+ */
+void cmci_clear(void)
+{
+	unsigned long flags;
+	int i;
+	int banks;
+	u64 val;
+
+	if (!cmci_supported(&banks))
+		return;
+	spin_lock_irqsave(&cmci_discover_lock, flags);
+	for (i = 0; i < banks; i++) {
+		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
+			continue;
+		/* Disable CMCI */
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
+		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		__clear_bit(i, __get_cpu_var(mce_banks_owned));
+	}
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+}
+
+/*
+ * After a CPU went down cycle through all the others and rediscover
+ * Must run in process context.
+ */
+void cmci_rediscover(int dying)
+{
+	int banks;
+	int cpu;
+	cpumask_var_t old;
+
+	if (!cmci_supported(&banks))
+		return;
+	if (!alloc_cpumask_var(&old, GFP_KERNEL))
+		return;
+	cpumask_copy(old, &current->cpus_allowed);
+
+	for_each_online_cpu(cpu) {
+		if (cpu == dying)
+			continue;
+		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
+			continue;
+		/* Recheck banks in case CPUs don't all have the same */
+		if (cmci_supported(&banks))
+			cmci_discover(banks, 0);
+	}
+
+	set_cpus_allowed_ptr(current, old);
+	free_cpumask_var(old);
+}
+
+/*
+ * Reenable CMCI on this CPU in case a CPU down failed.
+ */
+void cmci_reenable(void)
+{
+	int banks;
+	if (cmci_supported(&banks))
+		cmci_discover(banks, 0);
+}
+
+static void intel_init_cmci(void)
+{
+	int banks;
+
+	if (!cmci_supported(&banks))
+		return;
+
+	mce_threshold_vector = intel_threshold_interrupt;
+	cmci_discover(banks, 1);
+	/*
+	 * For CPU #0 this runs with still disabled APIC, but that's
+	 * ok because only the vector is set up. We still do another
+	 * check for the banks later for CPU #0 just to make sure
+	 * to not miss any events.
+	 */
+	apic_write(APIC_LVTCMCI, THRESHOLD_APIC_VECTOR|APIC_DM_FIXED);
+	cmci_recheck();
+}
+
+void mce_intel_feature_init(struct cpuinfo_x86 *c)
+{
+	intel_init_thermal(c);
+	intel_init_cmci();
+}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
deleted file mode 100644
index 663a88e..0000000
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * Intel specific MCE features.
- * Copyright 2004 Zwane Mwaikambo <zwane@linuxpower.ca>
- * Copyright (C) 2008, 2009 Intel Corporation
- * Author: Andi Kleen
- */
-
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/percpu.h>
-#include <asm/processor.h>
-#include <asm/msr.h>
-#include <asm/mce.h>
-
-/*
- * Support for Intel Correct Machine Check Interrupts. This allows
- * the CPU to raise an interrupt when a corrected machine check happened.
- * Normally we pick those up using a regular polling timer.
- * Also supports reliable discovery of shared banks.
- */
-
-static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
-
-/*
- * cmci_discover_lock protects against parallel discovery attempts
- * which could race against each other.
- */
-static DEFINE_SPINLOCK(cmci_discover_lock);
-
-#define CMCI_THRESHOLD 1
-
-static int cmci_supported(int *banks)
-{
-	u64 cap;
-
-	if (mce_cmci_disabled || mce_ignore_ce)
-		return 0;
-
-	/*
-	 * Vendor check is not strictly needed, but the initial
-	 * initialization is vendor keyed and this
-	 * makes sure none of the backdoors are entered otherwise.
-	 */
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
-		return 0;
-	if (!cpu_has_apic || lapic_get_maxlvt() < 6)
-		return 0;
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-	*banks = min_t(unsigned, MAX_NR_BANKS, cap & 0xff);
-	return !!(cap & MCG_CMCI_P);
-}
-
-/*
- * The interrupt handler. This is called on every event.
- * Just call the poller directly to log any events.
- * This could in theory increase the threshold under high load,
- * but doesn't for now.
- */
-static void intel_threshold_interrupt(void)
-{
-	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
-	mce_notify_irq();
-}
-
-static void print_update(char *type, int *hdr, int num)
-{
-	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
-	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
-}
-
-/*
- * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
- * on this CPU. Use the algorithm recommended in the SDM to discover shared
- * banks.
- */
-static void cmci_discover(int banks, int boot)
-{
-	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
-	unsigned long flags;
-	int hdr = 0;
-	int i;
-
-	spin_lock_irqsave(&cmci_discover_lock, flags);
-	for (i = 0; i < banks; i++) {
-		u64 val;
-
-		if (test_bit(i, owned))
-			continue;
-
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
-
-		/* Already owned by someone else? */
-		if (val & CMCI_EN) {
-			if (test_and_clear_bit(i, owned) || boot)
-				print_update("SHD", &hdr, i);
-			__clear_bit(i, __get_cpu_var(mce_poll_banks));
-			continue;
-		}
-
-		val |= CMCI_EN | CMCI_THRESHOLD;
-		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
-
-		/* Did the enable bit stick? -- the bank supports CMCI */
-		if (val & CMCI_EN) {
-			if (!test_and_set_bit(i, owned) || boot)
-				print_update("CMCI", &hdr, i);
-			__clear_bit(i, __get_cpu_var(mce_poll_banks));
-		} else {
-			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
-		}
-	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
-	if (hdr)
-		printk(KERN_CONT "\n");
-}
-
-/*
- * Just in case we missed an event during initialization check
- * all the CMCI owned banks.
- */
-void cmci_recheck(void)
-{
-	unsigned long flags;
-	int banks;
-
-	if (!mce_available(&current_cpu_data) || !cmci_supported(&banks))
-		return;
-	local_irq_save(flags);
-	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
-	local_irq_restore(flags);
-}
-
-/*
- * Disable CMCI on this CPU for all banks it owns when it goes down.
- * This allows other CPUs to claim the banks on rediscovery.
- */
-void cmci_clear(void)
-{
-	unsigned long flags;
-	int i;
-	int banks;
-	u64 val;
-
-	if (!cmci_supported(&banks))
-		return;
-	spin_lock_irqsave(&cmci_discover_lock, flags);
-	for (i = 0; i < banks; i++) {
-		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
-			continue;
-		/* Disable CMCI */
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
-		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
-		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
-		__clear_bit(i, __get_cpu_var(mce_banks_owned));
-	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
-}
-
-/*
- * After a CPU went down cycle through all the others and rediscover
- * Must run in process context.
- */
-void cmci_rediscover(int dying)
-{
-	int banks;
-	int cpu;
-	cpumask_var_t old;
-
-	if (!cmci_supported(&banks))
-		return;
-	if (!alloc_cpumask_var(&old, GFP_KERNEL))
-		return;
-	cpumask_copy(old, &current->cpus_allowed);
-
-	for_each_online_cpu(cpu) {
-		if (cpu == dying)
-			continue;
-		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
-			continue;
-		/* Recheck banks in case CPUs don't all have the same */
-		if (cmci_supported(&banks))
-			cmci_discover(banks, 0);
-	}
-
-	set_cpus_allowed_ptr(current, old);
-	free_cpumask_var(old);
-}
-
-/*
- * Reenable CMCI on this CPU in case a CPU down failed.
- */
-void cmci_reenable(void)
-{
-	int banks;
-	if (cmci_supported(&banks))
-		cmci_discover(banks, 0);
-}
-
-static void intel_init_cmci(void)
-{
-	int banks;
-
-	if (!cmci_supported(&banks))
-		return;
-
-	mce_threshold_vector = intel_threshold_interrupt;
-	cmci_discover(banks, 1);
-	/*
-	 * For CPU #0 this runs with still disabled APIC, but that's
-	 * ok because only the vector is set up. We still do another
-	 * check for the banks later for CPU #0 just to make sure
-	 * to not miss any events.
-	 */
-	apic_write(APIC_LVTCMCI, THRESHOLD_APIC_VECTOR|APIC_DM_FIXED);
-	cmci_recheck();
-}
-
-void mce_intel_feature_init(struct cpuinfo_x86 *c)
-{
-	intel_init_thermal(c);
-	intel_init_cmci();
-}
-- 
1.6.3


