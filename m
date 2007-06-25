Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXFYIIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXFYIIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXFYIID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:08:03 -0400
Received: from [157.181.1.138] ([157.181.1.138]:34355 "EHLO mx3.mail.elte.hu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbXFYIH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:07:58 -0400
Date: Mon, 25 Jun 2007 10:05:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
Message-ID: <20070625080521.GA24333@elte.hu>
References: <20070605093349.GA24956@elte.hu> <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625065956.GA31725@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, restoring nmi.c to the v2.6.21 state does not fix the 
> nmi_watchdog=2 hang. I'll do a bisection run.

and after spending an hour on 15 bisection steps:

 git-bisect start
 git-bisect good d1be341dba5521506d9e6dccfd66179080705bea
 git-bisect bad a06381fec77bf88ec6c5eb6324457cb04e9ffd69
 git-bisect bad 794543a236074f49a8af89ef08ef6a753e4777e5
 git-bisect good 24a77daf3d80bddcece044e6dc3675e427eef3f3
 git-bisect bad ea62ccd00fd0b6720b033adfc9984f31130ce195
 git-bisect good 7e20ef030dde0e52dd5a57220ee82fa9facbea4e
 git-bisect bad f19cccf366a07e05703c90038704a3a5ffcb0607
 git-bisect good 0d08e0d3a97cce22ebf80b54785e00d9b94e1add
 git-bisect bad 856f44ff4af6e57fdc39a8b2bec498c88438bd27
 git-bisect bad f8822f42019eceed19cc6c0f985a489e17796ed8
 git-bisect good 1c3d99c11c47c8a1a9ed6a46555dbf6520683c52
 git-bisect good b239fb2501117bf3aeb4dd6926edd855be92333d
 git-bisect good 98de032b681d8a7532d44dfc66aa5c0c1c755a9d
 git-bisect good 42c24fa22e86365055fc931d833f26165e687c19

the winner is ...

 f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
 commit f8822f42019eceed19cc6c0f985a489e17796ed8
 Author: Jeremy Fitzhardinge <jeremy@goop.org>
 Date:   Wed May 2 19:27:14 2007 +0200

    [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to make them patchable

... our wonderful paravirt subsystem, honed to eternal perfection by the 
testing-machine x86_64 tree.

reverting -git-curr's paravirt.c, paravirt.h, smp.c and tlbflush.h to 
before the bad commit makes the NMI watchdog work again. Patch against 
-rc6 is below.

	Ingo

------------------------>
Subject: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
From: Ingo Molnar <mingo@elte.hu>

nmi_watchdog=2 hangs on i386:

 Calling initcall 0xc06cc620: check_nmi_watchdog+0x0/0x1f0()
 Testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
 CPU#1: NMI appears to be stuck (0->0)!
 initcall 0xc06cc620: check_nmi_watchdog+0x0/0x1f0() returned -1.
 initcall 0xc06cc620 ran for 27 msecs: check_nmi_watchdog+0x0/0x1f0()
 initcall at 0xc06cc620: check_nmi_watchdog+0x0/0x1f0(): returned with
 error code -1
 Calling initcall 0xc06ccbb0: io_apic_bug_finalize+0x0/0x20()
 initcall 0xc06ccbb0: io_apic_bug_finalize+0x0/0x20() returned 0.
 initcall 0xc06ccbb0 ran for 0 msecs: io_apic_bug_finalize+0x0/0x20()
 Calling initcall 0xc06ccd00: balanced_irq_init+0x0/0x1e0()
 Starting balanced_irq
 [hard hang]

bisected it down to:

 git-bisect start
 git-bisect good d1be341dba5521506d9e6dccfd66179080705bea
 git-bisect bad a06381fec77bf88ec6c5eb6324457cb04e9ffd69
 git-bisect bad 794543a236074f49a8af89ef08ef6a753e4777e5
 git-bisect good 24a77daf3d80bddcece044e6dc3675e427eef3f3
 git-bisect bad ea62ccd00fd0b6720b033adfc9984f31130ce195
 git-bisect good 7e20ef030dde0e52dd5a57220ee82fa9facbea4e
 git-bisect bad f19cccf366a07e05703c90038704a3a5ffcb0607
 git-bisect good 0d08e0d3a97cce22ebf80b54785e00d9b94e1add
 git-bisect bad 856f44ff4af6e57fdc39a8b2bec498c88438bd27
 git-bisect bad f8822f42019eceed19cc6c0f985a489e17796ed8
 git-bisect good 1c3d99c11c47c8a1a9ed6a46555dbf6520683c52
 git-bisect good b239fb2501117bf3aeb4dd6926edd855be92333d
 git-bisect good 98de032b681d8a7532d44dfc66aa5c0c1c755a9d
 git-bisect good 42c24fa22e86365055fc931d833f26165e687c19

 f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
 commit f8822f42019eceed19cc6c0f985a489e17796ed8
 Author: Jeremy Fitzhardinge <jeremy@goop.org>
 Date:   Wed May 2 19:27:14 2007 +0200

    [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to make them patchable

this patch reverts the code back to the last known booting version.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/paravirt.c |  174 ++--------
 arch/i386/kernel/smp.c      |   93 +++--
 include/asm-i386/paravirt.h |  718 +++++++++-----------------------------------
 include/asm-i386/tlbflush.h |   21 -
 4 files changed, 245 insertions(+), 761 deletions(-)

Index: linux-2.6-git/arch/i386/kernel/paravirt.c
===================================================================
--- linux-2.6-git.orig/arch/i386/kernel/paravirt.c
+++ linux-2.6-git/arch/i386/kernel/paravirt.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/efi.h>
 #include <linux/bcd.h>
-#include <linux/highmem.h>
+#include <linux/start_kernel.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
@@ -54,142 +54,40 @@ char *memory_setup(void)
 #define DEF_NATIVE(name, code)					\
 	extern const char start_##name[], end_##name[];		\
 	asm("start_" #name ": " code "; end_" #name ":")
-
-DEF_NATIVE(irq_disable, "cli");
-DEF_NATIVE(irq_enable, "sti");
-DEF_NATIVE(restore_fl, "push %eax; popf");
-DEF_NATIVE(save_fl, "pushf; pop %eax");
+DEF_NATIVE(cli, "cli");
+DEF_NATIVE(sti, "sti");
+DEF_NATIVE(popf, "push %eax; popf");
+DEF_NATIVE(pushf, "pushf; pop %eax");
 DEF_NATIVE(iret, "iret");
-DEF_NATIVE(irq_enable_sysexit, "sti; sysexit");
-DEF_NATIVE(read_cr2, "mov %cr2, %eax");
-DEF_NATIVE(write_cr3, "mov %eax, %cr3");
-DEF_NATIVE(read_cr3, "mov %cr3, %eax");
-DEF_NATIVE(clts, "clts");
-DEF_NATIVE(read_tsc, "rdtsc");
-
-DEF_NATIVE(ud2a, "ud2a");
-
-static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
-{
-	const unsigned char *start, *end;
-	unsigned ret;
-
-	switch(type) {
-#define SITE(x)	case PARAVIRT_PATCH(x):	start = start_##x; end = end_##x; goto patch_site
-		SITE(irq_disable);
-		SITE(irq_enable);
-		SITE(restore_fl);
-		SITE(save_fl);
-		SITE(iret);
-		SITE(irq_enable_sysexit);
-		SITE(read_cr2);
-		SITE(read_cr3);
-		SITE(write_cr3);
-		SITE(clts);
-		SITE(read_tsc);
-#undef SITE
-
-	patch_site:
-		ret = paravirt_patch_insns(insns, len, start, end);
-		break;
-
-	case PARAVIRT_PATCH(make_pgd):
-	case PARAVIRT_PATCH(make_pte):
-	case PARAVIRT_PATCH(pgd_val):
-	case PARAVIRT_PATCH(pte_val):
-#ifdef CONFIG_X86_PAE
-	case PARAVIRT_PATCH(make_pmd):
-	case PARAVIRT_PATCH(pmd_val):
-#endif
-		/* These functions end up returning exactly what
-		   they're passed, in the same registers. */
-		ret = paravirt_patch_nop();
-		break;
-
-	default:
-		ret = paravirt_patch_default(type, clobbers, insns, len);
-		break;
-	}
-
-	return ret;
-}
+DEF_NATIVE(sti_sysexit, "sti; sysexit");
 
-unsigned paravirt_patch_nop(void)
+static const struct native_insns
 {
-	return 0;
-}
-
-unsigned paravirt_patch_ignore(unsigned len)
-{
-	return len;
-}
-
-unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
-			     void *site, u16 site_clobbers,
-			     unsigned len)
-{
-	unsigned char *call = site;
-	unsigned long delta = (unsigned long)target - (unsigned long)(call+5);
-
-	if (tgt_clobbers & ~site_clobbers)
-		return len;	/* target would clobber too much for this site */
-	if (len < 5)
-		return len;	/* call too long for patch site */
-
-	*call++ = 0xe8;		/* call */
-	*(unsigned long *)call = delta;
-
-	return 5;
-}
+	const char *start, *end;
+} native_insns[] = {
+	[PARAVIRT_PATCH(irq_disable)] = { start_cli, end_cli },
+	[PARAVIRT_PATCH(irq_enable)] = { start_sti, end_sti },
+	[PARAVIRT_PATCH(restore_fl)] = { start_popf, end_popf },
+	[PARAVIRT_PATCH(save_fl)] = { start_pushf, end_pushf },
+	[PARAVIRT_PATCH(iret)] = { start_iret, end_iret },
+	[PARAVIRT_PATCH(irq_enable_sysexit)] = { start_sti_sysexit, end_sti_sysexit },
+};
 
-unsigned paravirt_patch_jmp(void *target, void *site, unsigned len)
+static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
 {
-	unsigned char *jmp = site;
-	unsigned long delta = (unsigned long)target - (unsigned long)(jmp+5);
-
-	if (len < 5)
-		return len;	/* call too long for patch site */
-
-	*jmp++ = 0xe9;		/* jmp */
-	*(unsigned long *)jmp = delta;
+	unsigned int insn_len;
 
-	return 5;
-}
+	/* Don't touch it if we don't have a replacement */
+	if (type >= ARRAY_SIZE(native_insns) || !native_insns[type].start)
+		return len;
 
-unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len)
-{
-	void *opfunc = *((void **)&paravirt_ops + type);
-	unsigned ret;
+	insn_len = native_insns[type].end - native_insns[type].start;
 
-	if (opfunc == NULL)
-		/* If there's no function, patch it with a ud2a (BUG) */
-		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
-	else if (opfunc == paravirt_nop)
-		/* If the operation is a nop, then nop the callsite */
-		ret = paravirt_patch_nop();
-	else if (type == PARAVIRT_PATCH(iret) ||
-		 type == PARAVIRT_PATCH(irq_enable_sysexit))
-		/* If operation requires a jmp, then jmp */
-		ret = paravirt_patch_jmp(opfunc, site, len);
-	else
-		/* Otherwise call the function; assume target could
-		   clobber any caller-save reg */
-		ret = paravirt_patch_call(opfunc, CLBR_ANY,
-					  site, clobbers, len);
-
-	return ret;
-}
-
-unsigned paravirt_patch_insns(void *site, unsigned len,
-			      const char *start, const char *end)
-{
-	unsigned insn_len = end - start;
-
-	if (insn_len > len || start == NULL)
-		insn_len = len;
-	else
-		memcpy(site, start, insn_len);
+	/* Similarly if we can't fit replacement. */
+	if (len < insn_len)
+		return len;
 
+	memcpy(insns, native_insns[type].start, insn_len);
 	return insn_len;
 }
 
@@ -212,7 +110,7 @@ static void native_flush_tlb_global(void
 	__native_flush_tlb_global();
 }
 
-static void native_flush_tlb_single(unsigned long addr)
+static void native_flush_tlb_single(u32 addr)
 {
 	__native_flush_tlb_single(addr);
 }
@@ -291,7 +189,6 @@ struct paravirt_ops paravirt_ops = {
 	.apic_read = native_apic_read,
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
-	.startup_ipi_hook = paravirt_nop,
 #endif
 	.set_lazy_mode = paravirt_nop,
 
@@ -301,7 +198,8 @@ struct paravirt_ops paravirt_ops = {
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
-	.flush_tlb_others = native_flush_tlb_others,
+
+	.map_pt_hook = paravirt_nop,
 
 	.alloc_pt = paravirt_nop,
 	.alloc_pd = paravirt_nop,
@@ -315,9 +213,7 @@ struct paravirt_ops paravirt_ops = {
 	.pte_update = paravirt_nop,
 	.pte_update_defer = paravirt_nop,
 
-#ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = kmap_atomic,
-#endif
+	.ptep_get_and_clear = native_ptep_get_and_clear,
 
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
@@ -342,6 +238,14 @@ struct paravirt_ops paravirt_ops = {
 	.dup_mmap = paravirt_nop,
 	.exit_mmap = paravirt_nop,
 	.activate_mm = paravirt_nop,
+
+	.startup_ipi_hook = paravirt_nop,
 };
 
-EXPORT_SYMBOL(paravirt_ops);
+/*
+ * NOTE: CONFIG_PARAVIRT is experimental and the paravirt_ops
+ * semantics are subject to change. Hence we only do this
+ * internal-only export of this, until it gets sorted out and
+ * all lowlevel CPU ops used by modules are separately exported.
+ */
+EXPORT_SYMBOL_GPL(paravirt_ops);
Index: linux-2.6-git/arch/i386/kernel/smp.c
===================================================================
--- linux-2.6-git.orig/arch/i386/kernel/smp.c
+++ linux-2.6-git/arch/i386/kernel/smp.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/cache.h>
@@ -164,20 +165,20 @@ void fastcall send_IPI_self(int vector)
 }
 
 /*
- * This is used to send an IPI with no shorthand notation (the destination is
- * specified in bits 56 to 63 of the ICR).
+ * This is only used on smaller machines.
  */
-static inline void __send_IPI_dest_field(unsigned long mask, int vector)
+void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
 {
+	unsigned long mask = cpus_addr(cpumask)[0];
 	unsigned long cfg;
+	unsigned long flags;
 
+	local_irq_save(flags);
+	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
 	/*
 	 * Wait for idle.
 	 */
-	if (unlikely(vector == NMI_VECTOR))
-		safe_apic_wait_icr_idle();
-	else
-		apic_wait_icr_idle();
+	apic_wait_icr_idle();
 		
 	/*
 	 * prepare target chip field
@@ -194,25 +195,13 @@ static inline void __send_IPI_dest_field
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
 	apic_write_around(APIC_ICR, cfg);
-}
 
-/*
- * This is only used on smaller machines.
- */
-void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
-{
-	unsigned long mask = cpus_addr(cpumask)[0];
-	unsigned long flags;
-
-	local_irq_save(flags);
-	WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
-	__send_IPI_dest_field(mask, vector);
 	local_irq_restore(flags);
 }
 
 void send_IPI_mask_sequence(cpumask_t mask, int vector)
 {
-	unsigned long flags;
+	unsigned long cfg, flags;
 	unsigned int query_cpu;
 
 	/*
@@ -222,10 +211,30 @@ void send_IPI_mask_sequence(cpumask_t ma
 	 */ 
 
 	local_irq_save(flags);
+
 	for (query_cpu = 0; query_cpu < NR_CPUS; ++query_cpu) {
 		if (cpu_isset(query_cpu, mask)) {
-			__send_IPI_dest_field(cpu_to_logical_apicid(query_cpu),
-					      vector);
+		
+			/*
+			 * Wait for idle.
+			 */
+			apic_wait_icr_idle();
+		
+			/*
+			 * prepare target chip field
+			 */
+			cfg = __prepare_ICR2(cpu_to_logical_apicid(query_cpu));
+			apic_write_around(APIC_ICR2, cfg);
+		
+			/*
+			 * program the ICR 
+			 */
+			cfg = __prepare_ICR(0, vector);
+			
+			/*
+			 * Send the IPI. The write to APIC_ICR fires this off.
+			 */
+			apic_write_around(APIC_ICR, cfg);
 		}
 	}
 	local_irq_restore(flags);
@@ -247,6 +256,7 @@ static cpumask_t flush_cpumask;
 static struct mm_struct * flush_mm;
 static unsigned long flush_va;
 static DEFINE_SPINLOCK(tlbstate_lock);
+#define FLUSH_ALL	0xffffffff
 
 /*
  * We cannot call mmdrop() because we are in interrupt context, 
@@ -328,7 +338,7 @@ fastcall void smp_invalidate_interrupt(s
 		 
 	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
 		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (flush_va == TLB_FLUSH_ALL)
+			if (flush_va == FLUSH_ALL)
 				local_flush_tlb();
 			else
 				__flush_tlb_one(flush_va);
@@ -343,11 +353,9 @@ out:
 	put_cpu_no_resched();
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
+static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+						unsigned long va)
 {
-	cpumask_t cpumask = *cpumaskp;
-
 	/*
 	 * A couple of (to be removed) sanity checks:
 	 *
@@ -358,12 +366,10 @@ void native_flush_tlb_others(const cpuma
 	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
 	BUG_ON(!mm);
 
-#ifdef CONFIG_HOTPLUG_CPU
 	/* If a CPU which we ran on has gone down, OK. */
 	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (unlikely(cpus_empty(cpumask)))
+	if (cpus_empty(cpumask))
 		return;
-#endif
 
 	/*
 	 * i'm not happy about this global shared spinlock in the
@@ -374,7 +380,17 @@ void native_flush_tlb_others(const cpuma
 	
 	flush_mm = mm;
 	flush_va = va;
-	cpus_or(flush_cpumask, cpumask, flush_cpumask);
+#if NR_CPUS <= BITS_PER_LONG
+	atomic_set_mask(cpumask, &flush_cpumask);
+#else
+	{
+		int k;
+		unsigned long *flush_mask = (unsigned long *)&flush_cpumask;
+		unsigned long *cpu_mask = (unsigned long *)&cpumask;
+		for (k = 0; k < BITS_TO_LONGS(NR_CPUS); ++k)
+			atomic_set_mask(cpu_mask[k], &flush_mask[k]);
+	}
+#endif
 	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
@@ -401,7 +417,7 @@ void flush_tlb_current_task(void)
 
 	local_flush_tlb();
 	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 	preempt_enable();
 }
 
@@ -420,7 +436,7 @@ void flush_tlb_mm (struct mm_struct * mm
 			leave_mm(smp_processor_id());
 	}
 	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -467,7 +483,7 @@ void flush_tlb_all(void)
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
  */
-static void native_smp_send_reschedule(int cpu)
+void native_smp_send_reschedule(int cpu)
 {
 	WARN_ON(cpu_is_offline(cpu));
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
@@ -546,10 +562,9 @@ static void __smp_call_function(void (*f
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-static int
-native_smp_call_function_mask(cpumask_t mask,
-			      void (*func)(void *), void *info,
-			      int wait)
+int native_smp_call_function_mask(cpumask_t mask,
+				  void (*func)(void *), void *info,
+				  int wait)
 {
 	struct call_data_struct data;
 	cpumask_t allbutself;
@@ -617,7 +632,7 @@ static void stop_this_cpu (void * dummy)
  * this function calls the 'stop' function on all other CPUs in the system.
  */
 
-static void native_smp_send_stop(void)
+void native_smp_send_stop(void)
 {
 	/* Don't deadlock on the call lock in panic */
 	int nolock = !spin_trylock(&call_lock);
Index: linux-2.6-git/include/asm-i386/paravirt.h
===================================================================
--- linux-2.6-git.orig/include/asm-i386/paravirt.h
+++ linux-2.6-git/include/asm-i386/paravirt.h
@@ -15,24 +15,12 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
-#include <linux/cpumask.h>
-#include <asm/kmap_types.h>
 
-struct page;
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
-
-/* Lazy mode for batching updates / context switch */
-enum paravirt_lazy_mode {
-	PARAVIRT_LAZY_NONE = 0,
-	PARAVIRT_LAZY_MMU = 1,
-	PARAVIRT_LAZY_CPU = 2,
-	PARAVIRT_LAZY_FLUSH = 3,
-};
-
 struct paravirt_ops
 {
 	unsigned int kernel_rpl;
@@ -49,33 +37,22 @@ struct paravirt_ops
 	 */
 	unsigned (*patch)(u8 type, u16 clobber, void *firstinsn, unsigned len);
 
-	/* Basic arch-specific setup */
 	void (*arch_setup)(void);
 	char *(*memory_setup)(void);
 	void (*init_IRQ)(void);
-	void (*time_init)(void);
 
-	/*
-	 * Called before/after init_mm pagetable setup. setup_start
-	 * may reset %cr3, and may pre-install parts of the pagetable;
-	 * pagetable setup is expected to preserve any existing
-	 * mapping.
-	 */
 	void (*pagetable_setup_start)(pgd_t *pgd_base);
 	void (*pagetable_setup_done)(pgd_t *pgd_base);
 
-	/* Print a banner to identify the environment */
 	void (*banner)(void);
 
-	/* Set and set time of day */
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long);
+	void (*time_init)(void);
 
-	/* cpuid emulation, mostly so that caps bits can be disabled */
 	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
 		      unsigned int *ecx, unsigned int *edx);
 
-	/* hooks for various privileged instructions */
 	unsigned long (*get_debugreg)(int regno);
 	void (*set_debugreg)(int regno, unsigned long value);
 
@@ -94,23 +71,15 @@ struct paravirt_ops
 	unsigned long (*read_cr4)(void);
 	void (*write_cr4)(unsigned long);
 
-	/*
-	 * Get/set interrupt state.  save_fl and restore_fl are only
-	 * expected to use X86_EFLAGS_IF; all other bits
-	 * returned from save_fl are undefined, and may be ignored by
-	 * restore_fl.
-	 */
 	unsigned long (*save_fl)(void);
 	void (*restore_fl)(unsigned long);
 	void (*irq_disable)(void);
 	void (*irq_enable)(void);
 	void (*safe_halt)(void);
 	void (*halt)(void);
-
 	void (*wbinvd)(void);
 
-	/* MSR, PMC and TSR operations.
-	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
+	/* err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
 	u64 (*read_msr)(unsigned int msr, int *err);
 	int (*write_msr)(unsigned int msr, u64 val);
 
@@ -119,7 +88,6 @@ struct paravirt_ops
  	u64 (*get_scheduled_cycles)(void);
 	unsigned long (*get_cpu_khz)(void);
 
-	/* Segment descriptor handling */
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct Xgt_desc_struct *);
 	void (*load_idt)(const struct Xgt_desc_struct *);
@@ -137,12 +105,9 @@ struct paravirt_ops
 	void (*load_esp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
+
 	void (*io_delay)(void);
 
-	/*
-	 * Hooks for intercepting the creation/use/destruction of an
-	 * mm_struct.
-	 */
 	void (*activate_mm)(struct mm_struct *prev,
 			    struct mm_struct *next);
 	void (*dup_mmap)(struct mm_struct *oldmm,
@@ -150,47 +115,32 @@ struct paravirt_ops
 	void (*exit_mmap)(struct mm_struct *mm);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	/*
-	 * Direct APIC operations, principally for VMI.  Ideally
-	 * these shouldn't be in this interface.
-	 */
 	void (*apic_write)(unsigned long reg, unsigned long v);
 	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
 	unsigned long (*apic_read)(unsigned long reg);
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
-
-	void (*startup_ipi_hook)(int phys_apicid,
-				 unsigned long start_eip,
-				 unsigned long start_esp);
 #endif
 
-	/* TLB operations */
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
-	void (*flush_tlb_single)(unsigned long addr);
-	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
-				 unsigned long va);
+	void (*flush_tlb_single)(u32 addr);
+
+	void (*map_pt_hook)(int type, pte_t *va, u32 pfn);
 
-	/* Hooks for allocating/releasing pagetable pages */
 	void (*alloc_pt)(u32 pfn);
 	void (*alloc_pd)(u32 pfn);
 	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
 	void (*release_pt)(u32 pfn);
 	void (*release_pd)(u32 pfn);
 
-	/* Pagetable manipulation functions */
 	void (*set_pte)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr,
-			   pte_t *ptep, pte_t pteval);
+	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pteval);
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
 	void (*pte_update)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-	void (*pte_update_defer)(struct mm_struct *mm,
-				 unsigned long addr, pte_t *ptep);
+	void (*pte_update_defer)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 
-#ifdef CONFIG_HIGHPTE
-	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
-#endif
+ 	pte_t (*ptep_get_and_clear)(pte_t *ptep);
 
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
@@ -214,14 +164,20 @@ struct paravirt_ops
 	pgd_t (*make_pgd)(unsigned long pgd);
 #endif
 
-	/* Set deferred update mode, used for batching operations. */
-	void (*set_lazy_mode)(enum paravirt_lazy_mode mode);
+	void (*set_lazy_mode)(int mode);
 
 	/* These two are jmp to, not actually called. */
 	void (*irq_enable_sysexit)(void);
 	void (*iret)(void);
+
+	void (*startup_ipi_hook)(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
 };
 
+/* Mark a paravirt probe function. */
+#define paravirt_probe(fn)						\
+ static asmlinkage void (*__paravirtprobe_##fn)(void) __attribute_used__ \
+		__attribute__((__section__(".paravirtprobe"))) = fn
+
 extern struct paravirt_ops paravirt_ops;
 
 #define PARAVIRT_PATCH(x)					\
@@ -232,10 +188,8 @@ extern struct paravirt_ops paravirt_ops;
 #define paravirt_clobber(clobber)		\
 	[paravirt_clobber] "i" (clobber)
 
-/*
- * Generate some code, and mark it as patchable by the
- * apply_paravirt() alternate instruction patcher.
- */
+#define PARAVIRT_CALL	"call *paravirt_ops+%c[paravirt_typenum]*4;"
+
 #define _paravirt_alt(insn_string, type, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\
 	".pushsection .parainstructions,\"a\"\n"	\
@@ -245,181 +199,26 @@ extern struct paravirt_ops paravirt_ops;
 	"  .short " clobber "\n"			\
 	".popsection\n"
 
-/* Generate patchable code, with the default asm parameters. */
-#define paravirt_alt(insn_string)					\
+#define paravirt_alt(insn_string)				\
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
-unsigned paravirt_patch_nop(void);
-unsigned paravirt_patch_ignore(unsigned len);
-unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
-			     void *site, u16 site_clobbers,
-			     unsigned len);
-unsigned paravirt_patch_jmp(void *target, void *site, unsigned len);
-unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len);
-
-unsigned paravirt_patch_insns(void *site, unsigned len,
-			      const char *start, const char *end);
-
-
-/*
- * This generates an indirect call based on the operation type number.
- * The type number, computed in PARAVIRT_PATCH, is derived from the
- * offset into the paravirt_ops structure, and can therefore be freely
- * converted back into a structure offset.
- */
-#define PARAVIRT_CALL	"call *(paravirt_ops+%c[paravirt_typenum]*4);"
-
-/*
- * These macros are intended to wrap calls into a paravirt_ops
- * operation, so that they can be later identified and patched at
- * runtime.
- *
- * Normally, a call to a pv_op function is a simple indirect call:
- * (paravirt_ops.operations)(args...).
- *
- * Unfortunately, this is a relatively slow operation for modern CPUs,
- * because it cannot necessarily determine what the destination
- * address is.  In this case, the address is a runtime constant, so at
- * the very least we can patch the call to e a simple direct call, or
- * ideally, patch an inline implementation into the callsite.  (Direct
- * calls are essentially free, because the call and return addresses
- * are completely predictable.)
- *
- * These macros rely on the standard gcc "regparm(3)" calling
- * convention, in which the first three arguments are placed in %eax,
- * %edx, %ecx (in that order), and the remaining arguments are placed
- * on the stack.  All caller-save registers (eax,edx,ecx) are expected
- * to be modified (either clobbered or used for return values).
- *
- * The call instruction itself is marked by placing its start address
- * and size into the .parainstructions section, so that
- * apply_paravirt() in arch/i386/kernel/alternative.c can do the
- * appropriate patching under the control of the backend paravirt_ops
- * implementation.
- *
- * Unfortunately there's no way to get gcc to generate the args setup
- * for the call, and then allow the call itself to be generated by an
- * inline asm.  Because of this, we must do the complete arg setup and
- * return value handling from within these macros.  This is fairly
- * cumbersome.
- *
- * There are 5 sets of PVOP_* macros for dealing with 0-4 arguments.
- * It could be extended to more arguments, but there would be little
- * to be gained from that.  For each number of arguments, there are
- * the two VCALL and CALL variants for void and non-void functions.
- *
- * When there is a return value, the invoker of the macro must specify
- * the return type.  The macro then uses sizeof() on that type to
- * determine whether its a 32 or 64 bit value, and places the return
- * in the right register(s) (just %eax for 32-bit, and %edx:%eax for
- * 64-bit).
- *
- * 64-bit arguments are passed as a pair of adjacent 32-bit arguments
- * in low,high order.
- *
- * Small structures are passed and returned in registers.  The macro
- * calling convention can't directly deal with this, so the wrapper
- * functions must do this.
- *
- * These PVOP_* macros are only defined within this header.  This
- * means that all uses must be wrapped in inline functions.  This also
- * makes sure the incoming and outgoing types are always correct.
- */
-#define __PVOP_CALL(rettype, op, pre, post, ...)			\
-	({								\
-		rettype __ret;						\
-		unsigned long __eax, __edx, __ecx;			\
-		if (sizeof(rettype) > sizeof(unsigned long)) {		\
-			asm volatile(pre				\
-				     paravirt_alt(PARAVIRT_CALL)	\
-				     post				\
-				     : "=a" (__eax), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : paravirt_type(op),		\
-				       paravirt_clobber(CLBR_ANY),	\
-				       ##__VA_ARGS__			\
-				     : "memory", "cc");			\
-			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
-		} else {						\
-			asm volatile(pre				\
-				     paravirt_alt(PARAVIRT_CALL)	\
-				     post				\
-				     : "=a" (__eax), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : paravirt_type(op),		\
-				       paravirt_clobber(CLBR_ANY),	\
-				       ##__VA_ARGS__			\
-				     : "memory", "cc");			\
-			__ret = (rettype)__eax;				\
-		}							\
-		__ret;							\
-	})
-#define __PVOP_VCALL(op, pre, post, ...)				\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(pre					\
-			     paravirt_alt(PARAVIRT_CALL)		\
-			     post					\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : paravirt_type(op),			\
-			       paravirt_clobber(CLBR_ANY),		\
-			       ##__VA_ARGS__				\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL0(rettype, op)						\
-	__PVOP_CALL(rettype, op, "", "")
-#define PVOP_VCALL0(op)							\
-	__PVOP_VCALL(op, "", "")
-
-#define PVOP_CALL1(rettype, op, arg1)					\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)))
-#define PVOP_VCALL1(op, arg1)						\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)))
-
-#define PVOP_CALL2(rettype, op, arg1, arg2)				\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
-#define PVOP_VCALL2(op, arg1, arg2)					\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
-
-#define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)),		\
-		    "1"((u32)(arg2)), "2"((u32)(arg3)))
-#define PVOP_VCALL3(op, arg1, arg2, arg3)				\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1"((u32)(arg2)),	\
-		     "2"((u32)(arg3)))
-
-#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
-	__PVOP_CALL(rettype, op,					\
-		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
-		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
-		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
-#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
-	__PVOP_VCALL(op,						\
-		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
-		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
-		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
-
-static inline int paravirt_enabled(void)
-{
-	return paravirt_ops.paravirt_enabled;
-}
+#define paravirt_enabled() (paravirt_ops.paravirt_enabled)
 
 static inline void load_esp0(struct tss_struct *tss,
 			     struct thread_struct *thread)
 {
-	PVOP_VCALL2(load_esp0, tss, thread);
+	paravirt_ops.load_esp0(tss, thread);
 }
 
 #define ARCH_SETUP			paravirt_ops.arch_setup();
 static inline unsigned long get_wallclock(void)
 {
-	return PVOP_CALL0(unsigned long, get_wallclock);
+	return paravirt_ops.get_wallclock();
 }
 
 static inline int set_wallclock(unsigned long nowtime)
 {
-	return PVOP_CALL1(int, set_wallclock, nowtime);
+	return paravirt_ops.set_wallclock(nowtime);
 }
 
 static inline void (*choose_time_init(void))(void)
@@ -431,203 +230,127 @@ static inline void (*choose_time_init(vo
 static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
 			   unsigned int *ecx, unsigned int *edx)
 {
-	PVOP_VCALL4(cpuid, eax, ebx, ecx, edx);
+	paravirt_ops.cpuid(eax, ebx, ecx, edx);
 }
 
 /*
  * These special macros can be used to get or set a debugging register
  */
-static inline unsigned long paravirt_get_debugreg(int reg)
-{
-	return PVOP_CALL1(unsigned long, get_debugreg, reg);
-}
-#define get_debugreg(var, reg) var = paravirt_get_debugreg(reg)
-static inline void set_debugreg(unsigned long val, int reg)
-{
-	PVOP_VCALL2(set_debugreg, reg, val);
-}
+#define get_debugreg(var, reg) var = paravirt_ops.get_debugreg(reg)
+#define set_debugreg(val, reg) paravirt_ops.set_debugreg(reg, val)
 
-static inline void clts(void)
-{
-	PVOP_VCALL0(clts);
-}
-
-static inline unsigned long read_cr0(void)
-{
-	return PVOP_CALL0(unsigned long, read_cr0);
-}
-
-static inline void write_cr0(unsigned long x)
-{
-	PVOP_VCALL1(write_cr0, x);
-}
-
-static inline unsigned long read_cr2(void)
-{
-	return PVOP_CALL0(unsigned long, read_cr2);
-}
+#define clts() paravirt_ops.clts()
 
-static inline void write_cr2(unsigned long x)
-{
-	PVOP_VCALL1(write_cr2, x);
-}
+#define read_cr0() paravirt_ops.read_cr0()
+#define write_cr0(x) paravirt_ops.write_cr0(x)
 
-static inline unsigned long read_cr3(void)
-{
-	return PVOP_CALL0(unsigned long, read_cr3);
-}
+#define read_cr2() paravirt_ops.read_cr2()
+#define write_cr2(x) paravirt_ops.write_cr2(x)
 
-static inline void write_cr3(unsigned long x)
-{
-	PVOP_VCALL1(write_cr3, x);
-}
+#define read_cr3() paravirt_ops.read_cr3()
+#define write_cr3(x) paravirt_ops.write_cr3(x)
 
-static inline unsigned long read_cr4(void)
-{
-	return PVOP_CALL0(unsigned long, read_cr4);
-}
-static inline unsigned long read_cr4_safe(void)
-{
-	return PVOP_CALL0(unsigned long, read_cr4_safe);
-}
+#define read_cr4() paravirt_ops.read_cr4()
+#define read_cr4_safe(x) paravirt_ops.read_cr4_safe()
+#define write_cr4(x) paravirt_ops.write_cr4(x)
 
-static inline void write_cr4(unsigned long x)
-{
-	PVOP_VCALL1(write_cr4, x);
-}
+#define raw_ptep_get_and_clear(xp)	(paravirt_ops.ptep_get_and_clear(xp))
 
 static inline void raw_safe_halt(void)
 {
-	PVOP_VCALL0(safe_halt);
+	paravirt_ops.safe_halt();
 }
 
 static inline void halt(void)
 {
-	PVOP_VCALL0(safe_halt);
-}
-
-static inline void wbinvd(void)
-{
-	PVOP_VCALL0(wbinvd);
+	paravirt_ops.safe_halt();
 }
+#define wbinvd() paravirt_ops.wbinvd()
 
 #define get_kernel_rpl()  (paravirt_ops.kernel_rpl)
 
-static inline u64 paravirt_read_msr(unsigned msr, int *err)
-{
-	return PVOP_CALL2(u64, read_msr, msr, err);
-}
-static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
-{
-	return PVOP_CALL3(int, write_msr, msr, low, high);
-}
-
 /* These should all do BUG_ON(_err), but our headers are too tangled. */
-#define rdmsr(msr,val1,val2) do {		\
-	int _err;				\
-	u64 _l = paravirt_read_msr(msr, &_err);	\
-	val1 = (u32)_l;				\
-	val2 = _l >> 32;			\
+#define rdmsr(msr,val1,val2) do {				\
+	int _err;						\
+	u64 _l = paravirt_ops.read_msr(msr,&_err);		\
+	val1 = (u32)_l;						\
+	val2 = _l >> 32;					\
 } while(0)
 
-#define wrmsr(msr,val1,val2) do {		\
-	paravirt_write_msr(msr, val1, val2);	\
+#define wrmsr(msr,val1,val2) do {				\
+	u64 _l = ((u64)(val2) << 32) | (val1);			\
+	paravirt_ops.write_msr((msr), _l);			\
 } while(0)
 
-#define rdmsrl(msr,val) do {			\
-	int _err;				\
-	val = paravirt_read_msr(msr, &_err);	\
+#define rdmsrl(msr,val) do {					\
+	int _err;						\
+	val = paravirt_ops.read_msr((msr),&_err);		\
 } while(0)
 
-#define wrmsrl(msr,val)		((void)paravirt_write_msr(msr, val, 0))
-#define wrmsr_safe(msr,a,b)	paravirt_write_msr(msr, a, b)
+#define wrmsrl(msr,val) (paravirt_ops.write_msr((msr),(val)))
+#define wrmsr_safe(msr,a,b) ({					\
+	u64 _l = ((u64)(b) << 32) | (a);			\
+	paravirt_ops.write_msr((msr),_l);			\
+})
 
 /* rdmsr with exception handling */
-#define rdmsr_safe(msr,a,b) ({			\
-	int _err;				\
-	u64 _l = paravirt_read_msr(msr, &_err);	\
-	(*a) = (u32)_l;				\
-	(*b) = _l >> 32;			\
+#define rdmsr_safe(msr,a,b) ({					\
+	int _err;						\
+	u64 _l = paravirt_ops.read_msr(msr,&_err);		\
+	(*a) = (u32)_l;						\
+	(*b) = _l >> 32;					\
 	_err; })
 
+#define rdtsc(low,high) do {					\
+	u64 _l = paravirt_ops.read_tsc();			\
+	low = (u32)_l;						\
+	high = _l >> 32;					\
+} while(0)
 
-static inline u64 paravirt_read_tsc(void)
-{
-	return PVOP_CALL0(u64, read_tsc);
-}
-
-#define rdtscl(low) do {			\
-	u64 _l = paravirt_read_tsc();		\
-	low = (int)_l;				\
+#define rdtscl(low) do {					\
+	u64 _l = paravirt_ops.read_tsc();			\
+	low = (int)_l;						\
 } while(0)
 
-#define rdtscll(val) (val = paravirt_read_tsc())
+#define rdtscll(val) (val = paravirt_ops.read_tsc())
 
 #define get_scheduled_cycles(val) (val = paravirt_ops.get_scheduled_cycles())
 #define calculate_cpu_khz() (paravirt_ops.get_cpu_khz())
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
-static inline unsigned long long paravirt_read_pmc(int counter)
-{
-	return PVOP_CALL1(u64, read_pmc, counter);
-}
-
-#define rdpmc(counter,low,high) do {		\
-	u64 _l = paravirt_read_pmc(counter);	\
-	low = (u32)_l;				\
-	high = _l >> 32;			\
+#define rdpmc(counter,low,high) do {				\
+	u64 _l = paravirt_ops.read_pmc();			\
+	low = (u32)_l;						\
+	high = _l >> 32;					\
 } while(0)
 
-static inline void load_TR_desc(void)
-{
-	PVOP_VCALL0(load_tr_desc);
-}
-static inline void load_gdt(const struct Xgt_desc_struct *dtr)
-{
-	PVOP_VCALL1(load_gdt, dtr);
-}
-static inline void load_idt(const struct Xgt_desc_struct *dtr)
-{
-	PVOP_VCALL1(load_idt, dtr);
-}
-static inline void set_ldt(const void *addr, unsigned entries)
-{
-	PVOP_VCALL2(set_ldt, addr, entries);
-}
-static inline void store_gdt(struct Xgt_desc_struct *dtr)
-{
-	PVOP_VCALL1(store_gdt, dtr);
-}
-static inline void store_idt(struct Xgt_desc_struct *dtr)
-{
-	PVOP_VCALL1(store_idt, dtr);
-}
-static inline unsigned long paravirt_store_tr(void)
-{
-	return PVOP_CALL0(unsigned long, store_tr);
-}
-#define store_tr(tr)	((tr) = paravirt_store_tr())
-static inline void load_TLS(struct thread_struct *t, unsigned cpu)
-{
-	PVOP_VCALL2(load_tls, t, cpu);
-}
-static inline void write_ldt_entry(void *dt, int entry, u32 low, u32 high)
-{
-	PVOP_VCALL4(write_ldt_entry, dt, entry, low, high);
-}
-static inline void write_gdt_entry(void *dt, int entry, u32 low, u32 high)
-{
-	PVOP_VCALL4(write_gdt_entry, dt, entry, low, high);
-}
-static inline void write_idt_entry(void *dt, int entry, u32 low, u32 high)
-{
-	PVOP_VCALL4(write_idt_entry, dt, entry, low, high);
-}
-static inline void set_iopl_mask(unsigned mask)
-{
-	PVOP_VCALL1(set_iopl_mask, mask);
-}
+#define load_TR_desc() (paravirt_ops.load_tr_desc())
+#define load_gdt(dtr) (paravirt_ops.load_gdt(dtr))
+#define load_idt(dtr) (paravirt_ops.load_idt(dtr))
+#define set_ldt(addr, entries) (paravirt_ops.set_ldt((addr), (entries)))
+#define store_gdt(dtr) (paravirt_ops.store_gdt(dtr))
+#define store_idt(dtr) (paravirt_ops.store_idt(dtr))
+#define store_tr(tr) ((tr) = paravirt_ops.store_tr())
+#define load_TLS(t,cpu) (paravirt_ops.load_tls((t),(cpu)))
+#define write_ldt_entry(dt, entry, low, high)				\
+	(paravirt_ops.write_ldt_entry((dt), (entry), (low), (high)))
+#define write_gdt_entry(dt, entry, low, high)				\
+	(paravirt_ops.write_gdt_entry((dt), (entry), (low), (high)))
+#define write_idt_entry(dt, entry, low, high)				\
+	(paravirt_ops.write_idt_entry((dt), (entry), (low), (high)))
+#define set_iopl_mask(mask) (paravirt_ops.set_iopl_mask(mask))
+
+#define __pte(x)	paravirt_ops.make_pte(x)
+#define __pgd(x)	paravirt_ops.make_pgd(x)
+
+#define pte_val(x)	paravirt_ops.pte_val(x)
+#define pgd_val(x)	paravirt_ops.pgd_val(x)
+
+#ifdef CONFIG_X86_PAE
+#define __pmd(x)	paravirt_ops.make_pmd(x)
+#define pmd_val(x)	paravirt_ops.pmd_val(x)
+#endif
 
 /* The paravirtualized I/O functions */
 static inline void slow_down_io(void) {
@@ -645,27 +368,27 @@ static inline void slow_down_io(void) {
  */
 static inline void apic_write(unsigned long reg, unsigned long v)
 {
-	PVOP_VCALL2(apic_write, reg, v);
+	paravirt_ops.apic_write(reg,v);
 }
 
 static inline void apic_write_atomic(unsigned long reg, unsigned long v)
 {
-	PVOP_VCALL2(apic_write_atomic, reg, v);
+	paravirt_ops.apic_write_atomic(reg,v);
 }
 
 static inline unsigned long apic_read(unsigned long reg)
 {
-	return PVOP_CALL1(unsigned long, apic_read, reg);
+	return paravirt_ops.apic_read(reg);
 }
 
 static inline void setup_boot_clock(void)
 {
-	PVOP_VCALL0(setup_boot_clock);
+	paravirt_ops.setup_boot_clock();
 }
 
 static inline void setup_secondary_clock(void)
 {
-	PVOP_VCALL0(setup_secondary_clock);
+	paravirt_ops.setup_secondary_clock();
 }
 #endif
 
@@ -685,239 +408,109 @@ static inline void paravirt_pagetable_se
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 				    unsigned long start_esp)
 {
-	PVOP_VCALL3(startup_ipi_hook, phys_apicid, start_eip, start_esp);
+	return paravirt_ops.startup_ipi_hook(phys_apicid, start_eip, start_esp);
 }
 #endif
 
 static inline void paravirt_activate_mm(struct mm_struct *prev,
 					struct mm_struct *next)
 {
-	PVOP_VCALL2(activate_mm, prev, next);
+	paravirt_ops.activate_mm(prev, next);
 }
 
 static inline void arch_dup_mmap(struct mm_struct *oldmm,
 				 struct mm_struct *mm)
 {
-	PVOP_VCALL2(dup_mmap, oldmm, mm);
+	paravirt_ops.dup_mmap(oldmm, mm);
 }
 
 static inline void arch_exit_mmap(struct mm_struct *mm)
 {
-	PVOP_VCALL1(exit_mmap, mm);
+	paravirt_ops.exit_mmap(mm);
 }
 
-static inline void __flush_tlb(void)
-{
-	PVOP_VCALL0(flush_tlb_user);
-}
-static inline void __flush_tlb_global(void)
-{
-	PVOP_VCALL0(flush_tlb_kernel);
-}
-static inline void __flush_tlb_single(unsigned long addr)
-{
-	PVOP_VCALL1(flush_tlb_single, addr);
-}
-
-static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
-				    unsigned long va)
-{
-	PVOP_VCALL3(flush_tlb_others, &cpumask, mm, va);
-}
+#define __flush_tlb() paravirt_ops.flush_tlb_user()
+#define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
+#define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
 
-static inline void paravirt_alloc_pt(unsigned pfn)
-{
-	PVOP_VCALL1(alloc_pt, pfn);
-}
-static inline void paravirt_release_pt(unsigned pfn)
-{
-	PVOP_VCALL1(release_pt, pfn);
-}
+#define paravirt_map_pt_hook(type, va, pfn) paravirt_ops.map_pt_hook(type, va, pfn)
 
-static inline void paravirt_alloc_pd(unsigned pfn)
-{
-	PVOP_VCALL1(alloc_pd, pfn);
-}
+#define paravirt_alloc_pt(pfn) paravirt_ops.alloc_pt(pfn)
+#define paravirt_release_pt(pfn) paravirt_ops.release_pt(pfn)
 
-static inline void paravirt_alloc_pd_clone(unsigned pfn, unsigned clonepfn,
-					   unsigned start, unsigned count)
-{
-	PVOP_VCALL4(alloc_pd_clone, pfn, clonepfn, start, count);
-}
-static inline void paravirt_release_pd(unsigned pfn)
-{
-	PVOP_VCALL1(release_pd, pfn);
-}
-
-#ifdef CONFIG_HIGHPTE
-static inline void *kmap_atomic_pte(struct page *page, enum km_type type)
-{
-	unsigned long ret;
-	ret = PVOP_CALL2(unsigned long, kmap_atomic_pte, page, type);
-	return (void *)ret;
-}
-#endif
-
-static inline void pte_update(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep)
-{
-	PVOP_VCALL3(pte_update, mm, addr, ptep);
-}
-
-static inline void pte_update_defer(struct mm_struct *mm, unsigned long addr,
-				    pte_t *ptep)
-{
-	PVOP_VCALL3(pte_update_defer, mm, addr, ptep);
-}
-
-#ifdef CONFIG_X86_PAE
-static inline pte_t __pte(unsigned long long val)
-{
-	unsigned long long ret = PVOP_CALL2(unsigned long long, make_pte,
-					    val, val >> 32);
-	return (pte_t) { ret, ret >> 32 };
-}
-
-static inline pmd_t __pmd(unsigned long long val)
-{
-	return (pmd_t) { PVOP_CALL2(unsigned long long, make_pmd, val, val >> 32) };
-}
-
-static inline pgd_t __pgd(unsigned long long val)
-{
-	return (pgd_t) { PVOP_CALL2(unsigned long long, make_pgd, val, val >> 32) };
-}
-
-static inline unsigned long long pte_val(pte_t x)
-{
-	return PVOP_CALL2(unsigned long long, pte_val, x.pte_low, x.pte_high);
-}
-
-static inline unsigned long long pmd_val(pmd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pmd_val, x.pmd, x.pmd >> 32);
-}
-
-static inline unsigned long long pgd_val(pgd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pgd_val, x.pgd, x.pgd >> 32);
-}
+#define paravirt_alloc_pd(pfn) paravirt_ops.alloc_pd(pfn)
+#define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) \
+	paravirt_ops.alloc_pd_clone(pfn, clonepfn, start, count)
+#define paravirt_release_pd(pfn) paravirt_ops.release_pd(pfn)
 
 static inline void set_pte(pte_t *ptep, pte_t pteval)
 {
-	PVOP_VCALL3(set_pte, ptep, pteval.pte_low, pteval.pte_high);
+	paravirt_ops.set_pte(ptep, pteval);
 }
 
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pteval)
 {
-	/* 5 arg words */
 	paravirt_ops.set_pte_at(mm, addr, ptep, pteval);
 }
 
-static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL3(set_pte_atomic, ptep, pteval.pte_low, pteval.pte_high);
-}
-
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
-{
-	/* 5 arg words */
-	paravirt_ops.set_pte_present(mm, addr, ptep, pte);
-}
-
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
-	PVOP_VCALL3(set_pmd, pmdp, pmdval.pmd, pmdval.pmd >> 32);
+	paravirt_ops.set_pmd(pmdp, pmdval);
 }
 
-static inline void set_pud(pud_t *pudp, pud_t pudval)
+static inline void pte_update(struct mm_struct *mm, u32 addr, pte_t *ptep)
 {
-	PVOP_VCALL3(set_pud, pudp, pudval.pgd.pgd, pudval.pgd.pgd >> 32);
+	paravirt_ops.pte_update(mm, addr, ptep);
 }
 
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline void pte_update_defer(struct mm_struct *mm, u32 addr, pte_t *ptep)
 {
-	PVOP_VCALL3(pte_clear, mm, addr, ptep);
+	paravirt_ops.pte_update_defer(mm, addr, ptep);
 }
 
-static inline void pmd_clear(pmd_t *pmdp)
-{
-	PVOP_VCALL1(pmd_clear, pmdp);
-}
-
-#else  /* !CONFIG_X86_PAE */
-
-static inline pte_t __pte(unsigned long val)
-{
-	return (pte_t) { PVOP_CALL1(unsigned long, make_pte, val) };
-}
-
-static inline pgd_t __pgd(unsigned long val)
+#ifdef CONFIG_X86_PAE
+static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
-	return (pgd_t) { PVOP_CALL1(unsigned long, make_pgd, val) };
+	paravirt_ops.set_pte_atomic(ptep, pteval);
 }
 
-static inline unsigned long pte_val(pte_t x)
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
 {
-	return PVOP_CALL1(unsigned long, pte_val, x.pte_low);
+	paravirt_ops.set_pte_present(mm, addr, ptep, pte);
 }
 
-static inline unsigned long pgd_val(pgd_t x)
+static inline void set_pud(pud_t *pudp, pud_t pudval)
 {
-	return PVOP_CALL1(unsigned long, pgd_val, x.pgd);
+	paravirt_ops.set_pud(pudp, pudval);
 }
 
-static inline void set_pte(pte_t *ptep, pte_t pteval)
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	PVOP_VCALL2(set_pte, ptep, pteval.pte_low);
+	paravirt_ops.pte_clear(mm, addr, ptep);
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
+static inline void pmd_clear(pmd_t *pmdp)
 {
-	PVOP_VCALL4(set_pte_at, mm, addr, ptep, pteval.pte_low);
+	paravirt_ops.pmd_clear(pmdp);
 }
+#endif
 
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL2(set_pmd, pmdp, pmdval.pud.pgd.pgd);
-}
-#endif	/* CONFIG_X86_PAE */
+/* Lazy mode for batching updates / context switch */
+#define PARAVIRT_LAZY_NONE 0
+#define PARAVIRT_LAZY_MMU  1
+#define PARAVIRT_LAZY_CPU  2
+#define PARAVIRT_LAZY_FLUSH 3
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-static inline void arch_enter_lazy_cpu_mode(void)
-{
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_CPU);
-}
-
-static inline void arch_leave_lazy_cpu_mode(void)
-{
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE);
-}
-
-static inline void arch_flush_lazy_cpu_mode(void)
-{
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
-}
-
+#define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
+#define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_flush_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-static inline void arch_enter_lazy_mmu_mode(void)
-{
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_MMU);
-}
-
-static inline void arch_leave_lazy_mmu_mode(void)
-{
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE);
-}
-
-static inline void arch_flush_lazy_mmu_mode(void)
-{
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
-}
+#define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
+#define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_flush_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
 void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
@@ -1009,20 +602,7 @@ static inline unsigned long __raw_local_
 	[paravirt_sti_type] "i" (PARAVIRT_PATCH(irq_enable)),		\
 	paravirt_clobber(CLBR_EAX)
 
-/* Make sure as little as possible of this mess escapes. */
 #undef PARAVIRT_CALL
-#undef __PVOP_CALL
-#undef __PVOP_VCALL
-#undef PVOP_VCALL0
-#undef PVOP_CALL0
-#undef PVOP_VCALL1
-#undef PVOP_CALL1
-#undef PVOP_VCALL2
-#undef PVOP_CALL2
-#undef PVOP_VCALL3
-#undef PVOP_CALL3
-#undef PVOP_VCALL4
-#undef PVOP_CALL4
 
 #else  /* __ASSEMBLY__ */
 
Index: linux-2.6-git/include/asm-i386/tlbflush.h
===================================================================
--- linux-2.6-git.orig/include/asm-i386/tlbflush.h
+++ linux-2.6-git/include/asm-i386/tlbflush.h
@@ -79,19 +79,15 @@
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
  *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
- *  - flush_tlb_others(cpumask, mm, va) flushes a TLBs on other cpus
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
  * and page-granular flushes are available only on i486 and up.
  */
 
-#define TLB_FLUSH_ALL	0xffffffff
-
+#define TLB_FLUSH_ALL  0xffffffff
 
 #ifndef CONFIG_SMP
 
-#include <linux/sched.h>
-
 #define flush_tlb() __flush_tlb()
 #define flush_tlb_all() __flush_tlb_all()
 #define local_flush_tlb() __flush_tlb()
@@ -116,12 +112,7 @@ static inline void flush_tlb_range(struc
 		__flush_tlb();
 }
 
-static inline void native_flush_tlb_others(const cpumask_t *cpumask,
-					   struct mm_struct *mm, unsigned long va)
-{
-}
-
-#else  /* SMP */
+#else
 
 #include <asm/smp.h>
 
@@ -140,9 +131,6 @@ static inline void flush_tlb_range(struc
 	flush_tlb_mm(vma->vm_mm);
 }
 
-void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
-			     unsigned long va);
-
 #define TLBSTATE_OK	1
 #define TLBSTATE_LAZY	2
 
@@ -153,11 +141,8 @@ struct tlb_state
 	char __cacheline_padding[L1_CACHE_BYTES-8];
 };
 DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
-#endif	/* SMP */
 
-#ifndef CONFIG_PARAVIRT
-#define flush_tlb_others(mask, mm, va)		\
-	native_flush_tlb_others(&mask, mm, va)
+
 #endif
 
 #define flush_tlb_kernel_range(start, end) flush_tlb_all()
