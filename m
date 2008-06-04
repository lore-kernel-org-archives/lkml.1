Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYFDQMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYFDQMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYFDQM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:12:28 -0400
Received: from www.tglx.de ([62.245.132.106]:55664 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYFDQM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:12:26 -0400
Date: Wed, 4 Jun 2008 18:12:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 updates for 2.6.26
Message-ID: <alpine.LFD.1.10.0806041809310.3235@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull x86 fixes for 2.6.26 from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	tglx

----------
Andrew Morton (1):
      x86: section mismatch fix

Hugh Dickins (1):
      x86: fix bad pmd ffff810000207xxx(9090909090909090)

Ingo Molnar (2):
      x86: disable preemption in native_smp_prepare_cpus
      x86: ioremap fix failing nesting check

Kevin Winchester (1):
      x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest

Pavel Machek (1):
      suspend-vs-iommu: prevent suspend if we could not resume

Steven Rostedt (1):
      x86: enable preemption in delay

Suresh Siddha (2):
      x86: fix broken math-emu with lazy allocation of fpu area
      x86, fpu: fix CONFIG_PREEMPT=y corruption of application's FPU stack

Venki Pallipadi (1):
      x86: fix Xorg crash with xf86MapVidMem error

Yinghai Lu (1):
      x86: fix APIC warning on 32bit v2

 arch/x86/kernel/acpi/boot.c   |   16 +++++++++++-
 arch/x86/kernel/i387.c        |   44 +++++++++++++++++++++++------------
 arch/x86/kernel/pci-gart_64.c |   31 ++++++++++++++++++++++++-
 arch/x86/kernel/process_32.c  |    5 +++-
 arch/x86/kernel/process_64.c  |    5 +++-
 arch/x86/kernel/smpboot.c     |    5 +++-
 arch/x86/lib/delay_32.c       |   31 +++++++++++++++++++++---
 arch/x86/lib/delay_64.c       |   30 +++++++++++++++++++++---
 arch/x86/math-emu/fpu_entry.c |   13 ++++++----
 arch/x86/mm/init_64.c         |    6 ++--
 arch/x86/mm/ioremap.c         |    5 ++-
 arch/x86/mm/pat.c             |   51 ++++++++++++++++++++---------------------
 include/asm-x86/i387.h        |    2 +
 13 files changed, 179 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c49ebcc..33c5216 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -242,12 +242,19 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
 
 static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
+	unsigned int ver = 0;
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
 	}
 
-	generic_processor_info(id, 0);
+#ifdef CONFIG_X86_32
+	if (boot_cpu_physical_apicid != -1U)
+		ver = apic_version[boot_cpu_physical_apicid];
+#endif
+
+	generic_processor_info(id, ver);
 }
 
 static int __init
@@ -767,8 +774,13 @@ static void __init acpi_register_lapic_address(unsigned long address)
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
-	if (boot_cpu_physical_apicid == -1U)
+	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = GET_APIC_ID(read_apic_id());
+#ifdef CONFIG_X86_32
+		apic_version[boot_cpu_physical_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
+#endif
+	}
 }
 
 static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index e03cc95..eb9ddd8 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -56,6 +56,11 @@ void __cpuinit mxcsr_feature_mask_init(void)
 
 void __init init_thread_xstate(void)
 {
+	if (!HAVE_HWFP) {
+		xstate_size = sizeof(struct i387_soft_struct);
+		return;
+	}
+
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -94,7 +99,7 @@ void __cpuinit fpu_init(void)
 int init_fpu(struct task_struct *tsk)
 {
 	if (tsk_used_math(tsk)) {
-		if (tsk == current)
+		if (HAVE_HWFP && tsk == current)
 			unlazy_fpu(tsk);
 		return 0;
 	}
@@ -109,6 +114,15 @@ int init_fpu(struct task_struct *tsk)
 			return -ENOMEM;
 	}
 
+#ifdef CONFIG_X86_32
+	if (!HAVE_HWFP) {
+		memset(tsk->thread.xstate, 0, xstate_size);
+		finit();
+		set_stopped_child_used_math(tsk);
+		return 0;
+	}
+#endif
+
 	if (cpu_has_fxsr) {
 		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
 
@@ -330,13 +344,13 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	if (!HAVE_HWFP)
-		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
-
 	ret = init_fpu(target);
 	if (ret)
 		return ret;
 
+	if (!HAVE_HWFP)
+		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 					   &target->thread.xstate->fsave, 0,
@@ -360,15 +374,15 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	if (!HAVE_HWFP)
-		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
-
 	ret = init_fpu(target);
 	if (ret)
 		return ret;
 
 	set_stopped_child_used_math(target);
 
+	if (!HAVE_HWFP)
+		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 					  &target->thread.xstate->fsave, 0, -1);
@@ -474,18 +488,18 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 {
 	int err;
+	struct task_struct *tsk = current;
 
-	if (HAVE_HWFP) {
-		struct task_struct *tsk = current;
-
+	if (HAVE_HWFP)
 		clear_fpu(tsk);
 
-		if (!used_math()) {
-			err = init_fpu(tsk);
-			if (err)
-				return err;
-		}
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
 
+	if (HAVE_HWFP) {
 		if (cpu_has_fxsr)
 			err = restore_i387_fxsave(buf);
 		else
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index c07455d..aa8ec92 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -26,6 +26,7 @@
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <linux/sysdev.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
@@ -548,6 +549,28 @@ static __init unsigned read_aperture(struct pci_dev *dev, u32 *size)
 	return aper_base;
 }
 
+static int gart_resume(struct sys_device *dev)
+{
+	return 0;
+}
+
+static int gart_suspend(struct sys_device *dev, pm_message_t state)
+{
+	return -EINVAL;
+}
+
+static struct sysdev_class gart_sysdev_class = {
+	.name = "gart",
+	.suspend = gart_suspend,
+	.resume = gart_resume,
+
+};
+
+static struct sys_device device_gart = {
+	.id	= 0,
+	.cls	= &gart_sysdev_class,
+};
+
 /*
  * Private Northbridge GATT initialization in case we cannot use the
  * AGP driver for some reason.
@@ -558,7 +581,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	unsigned aper_base, new_aper_base;
 	struct pci_dev *dev;
 	void *gatt;
-	int i;
+	int i, error;
 
 	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
 	aper_size = aper_base = info->aper_size = 0;
@@ -606,6 +629,12 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 		pci_write_config_dword(dev, 0x90, ctl);
 	}
+
+	error = sysdev_class_register(&gart_sysdev_class);
+	if (!error)
+		error = sysdev_register(&device_gart);
+	if (error)
+		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
 	flush_gart();
 
 	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f8476df..6d54833 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -649,8 +649,11 @@ struct task_struct * __switch_to(struct task_struct *prev_p, struct task_struct
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * tsk_used_math() checks prevent calling math_state_restore(),
+	 * which can sleep in the case of !tsk_used_math()
 	 */
-	if (next_p->fpu_counter > 5)
+	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
 
 	/*
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e2319f3..ac54ff5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -658,8 +658,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * tsk_used_math() checks prevent calling math_state_restore(),
+	 * which can sleep in the case of !tsk_used_math()
 	 */
-	if (next_p->fpu_counter>5)
+	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
 	return prev_p;
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3898849..56078d6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1190,6 +1190,7 @@ static void __init smp_cpu_index_default(void)
  */
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
+	preempt_disable();
 	nmi_watchdog_default();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
@@ -1206,7 +1207,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
 		disable_smp();
-		return;
+		goto out;
 	}
 
 	preempt_disable();
@@ -1246,6 +1247,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	printk(KERN_INFO "CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
 	setup_boot_clock();
+out:
+	preempt_enable();
 }
 /*
  * Early setup to make printk work.
diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
index 4535e6d..d710f2d 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay_32.c
@@ -44,13 +44,36 @@ static void delay_loop(unsigned long loops)
 static void delay_tsc(unsigned long loops)
 {
 	unsigned long bclock, now;
+	int cpu;
 
-	preempt_disable();		/* TSC's are per-cpu */
+	preempt_disable();
+	cpu = smp_processor_id();
 	rdtscl(bclock);
-	do {
-		rep_nop();
+	for (;;) {
 		rdtscl(now);
-	} while ((now-bclock) < loops);
+		if ((now - bclock) >= loops)
+			break;
+
+		/* Allow RT tasks to run */
+		preempt_enable();
+		rep_nop();
+		preempt_disable();
+
+		/*
+		 * It is possible that we moved to another CPU, and
+		 * since TSC's are per-cpu we need to calculate
+		 * that. The delay must guarantee that we wait "at
+		 * least" the amount of time. Being moved to another
+		 * CPU could make the wait longer but we just need to
+		 * make sure we waited long enough. Rebalance the
+		 * counter for this CPU.
+		 */
+		if (unlikely(cpu != smp_processor_id())) {
+			loops -= (now - bclock);
+			cpu = smp_processor_id();
+			rdtscl(bclock);
+		}
+	}
 	preempt_enable();
 }
 
diff --git a/arch/x86/lib/delay_64.c b/arch/x86/lib/delay_64.c
index bbc6105..4c441be 100644
--- a/arch/x86/lib/delay_64.c
+++ b/arch/x86/lib/delay_64.c
@@ -31,14 +31,36 @@ int __devinit read_current_timer(unsigned long *timer_value)
 void __delay(unsigned long loops)
 {
 	unsigned bclock, now;
+	int cpu;
 
-	preempt_disable();		/* TSC's are pre-cpu */
+	preempt_disable();
+	cpu = smp_processor_id();
 	rdtscl(bclock);
-	do {
-		rep_nop(); 
+	for (;;) {
 		rdtscl(now);
+		if ((now - bclock) >= loops)
+			break;
+
+		/* Allow RT tasks to run */
+		preempt_enable();
+		rep_nop();
+		preempt_disable();
+
+		/*
+		 * It is possible that we moved to another CPU, and
+		 * since TSC's are per-cpu we need to calculate
+		 * that. The delay must guarantee that we wait "at
+		 * least" the amount of time. Being moved to another
+		 * CPU could make the wait longer but we just need to
+		 * make sure we waited long enough. Rebalance the
+		 * counter for this CPU.
+		 */
+		if (unlikely(cpu != smp_processor_id())) {
+			loops -= (now - bclock);
+			cpu = smp_processor_id();
+			rdtscl(bclock);
+		}
 	}
-	while ((now-bclock) < loops);
 	preempt_enable();
 }
 EXPORT_SYMBOL(__delay);
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 6e38d87..c7b06fe 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -30,6 +30,7 @@
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/user.h>
+#include <asm/i387.h>
 
 #include "fpu_system.h"
 #include "fpu_emu.h"
@@ -146,6 +147,13 @@ asmlinkage void math_emulate(long arg)
 	unsigned long code_limit = 0;	/* Initialized to stop compiler warnings */
 	struct desc_struct code_descriptor;
 
+	if (!used_math()) {
+		if (init_fpu(current)) {
+			do_group_exit(SIGKILL);
+			return;
+		}
+	}
+
 #ifdef RE_ENTRANT_CHECKING
 	if (emulating) {
 		printk("ERROR: wm-FPU-emu is not RE-ENTRANT!\n");
@@ -153,11 +161,6 @@ asmlinkage void math_emulate(long arg)
 	RE_ENTRANT_CHECK_ON;
 #endif /* RE_ENTRANT_CHECKING */
 
-	if (!used_math()) {
-		finit();
-		set_used_math();
-	}
-
 	SETUP_DATA_AREA(arg);
 
 	FPU_ORIG_EIP = FPU_EIP;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 32ba13b..156e6d7 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -206,7 +206,7 @@ void __init cleanup_highmap(void)
 	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
 
 	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
-		if (!pmd_present(*pmd))
+		if (pmd_none(*pmd))
 			continue;
 		if (vaddr < (unsigned long) _text || vaddr > end)
 			set_pmd(pmd, __pmd(0));
@@ -506,7 +506,7 @@ early_param("memtest", parse_memtest);
 
 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	unsigned long t_start, t_size;
+	u64 t_start, t_size;
 	unsigned pattern;
 
 	if (!memtest_pattern)
@@ -525,7 +525,7 @@ static void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
+			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
 				t_start, t_start + t_size, pattern);
 
 			memtest(t_start, t_size, pattern);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 71bb315..2b2bb3f 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -593,10 +593,11 @@ void __init early_iounmap(void *addr, unsigned long size)
 	unsigned long offset;
 	unsigned int nrpages;
 	enum fixed_addresses idx;
-	unsigned int nesting;
+	int nesting;
 
 	nesting = --early_ioremap_nested;
-	WARN_ON(nesting < 0);
+	if (WARN_ON(nesting < 0))
+		return;
 
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index de3a998..06b7a1c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -34,7 +34,7 @@ void __cpuinit pat_disable(char *reason)
 	printk(KERN_INFO "%s\n", reason);
 }
 
-static int nopat(char *str)
+static int __init nopat(char *str)
 {
 	pat_disable("PAT support disabled.");
 	return 0;
@@ -151,32 +151,33 @@ static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
 	unsigned long pat_type;
 	u8 mtrr_type;
 
-	mtrr_type = mtrr_type_lookup(start, end);
-	if (mtrr_type == 0xFF) {		/* MTRR not enabled */
-		*ret_prot = prot;
-		return 0;
-	}
-	if (mtrr_type == 0xFE) {		/* MTRR match error */
-		*ret_prot = _PAGE_CACHE_UC;
-		return -1;
-	}
-	if (mtrr_type != MTRR_TYPE_UNCACHABLE &&
-	    mtrr_type != MTRR_TYPE_WRBACK &&
-	    mtrr_type != MTRR_TYPE_WRCOMB) {	/* MTRR type unhandled */
-		*ret_prot = _PAGE_CACHE_UC;
-		return -1;
-	}
-
 	pat_type = prot & _PAGE_CACHE_MASK;
 	prot &= (~_PAGE_CACHE_MASK);
 
-	/* Currently doing intersection by hand. Optimize it later. */
+	/*
+	 * We return the PAT request directly for types where PAT takes
+	 * precedence with respect to MTRR and for UC_MINUS.
+	 * Consistency checks with other PAT requests is done later
+	 * while going through memtype list.
+	 */
 	if (pat_type == _PAGE_CACHE_WC) {
 		*ret_prot = prot | _PAGE_CACHE_WC;
+		return 0;
 	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
 		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
-	} else if (pat_type == _PAGE_CACHE_UC ||
-	           mtrr_type == MTRR_TYPE_UNCACHABLE) {
+		return 0;
+	} else if (pat_type == _PAGE_CACHE_UC) {
+		*ret_prot = prot | _PAGE_CACHE_UC;
+		return 0;
+	}
+
+	/*
+	 * Look for MTRR hint to get the effective type in case where PAT
+	 * request is for WB.
+	 */
+	mtrr_type = mtrr_type_lookup(start, end);
+
+	if (mtrr_type == MTRR_TYPE_UNCACHABLE) {
 		*ret_prot = prot | _PAGE_CACHE_UC;
 	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
 		*ret_prot = prot | _PAGE_CACHE_WC;
@@ -233,14 +234,12 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	if (req_type == -1) {
 		/*
-		 * Special case where caller wants to inherit from mtrr or
-		 * existing pat mapping, defaulting to UC_MINUS in case of
-		 * no match.
+		 * Call mtrr_lookup to get the type hint. This is an
+		 * optimization for /dev/mem mmap'ers into WB memory (BIOS
+		 * tools and ACPI tools). Use WB request for WB memory and use
+		 * UC_MINUS otherwise.
 		 */
 		u8 mtrr_type = mtrr_type_lookup(start, end);
-		if (mtrr_type == 0xFE) { /* MTRR match error */
-			err = -1;
-		}
 
 		if (mtrr_type == MTRR_TYPE_WRBACK) {
 			req_type = _PAGE_CACHE_WB;
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 6b722d3..37672f7 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -193,6 +193,8 @@ static inline int restore_i387(struct _fpstate __user *buf)
 
 #else  /* CONFIG_X86_32 */
 
+extern void finit(void);
+
 static inline void tolerant_fwait(void)
 {
 	asm volatile("fnclex ; fwait");
