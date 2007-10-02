Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbXJBWoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbXJBWoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXJBWnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:43:55 -0400
Received: from gw.goop.org ([64.81.55.164]:33067 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbXJBWnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:43:53 -0400
Message-ID: <4702C9A7.8020608@goop.org>
Date: Tue, 02 Oct 2007 15:43:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@qumranet.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH RFC] paravirt: cleanup lazy mode handling
References: <470186C4.5080208@goop.org>	 <1191288858.6979.20.camel@localhost.localdomain>	 <4701E552.3070501@goop.org> <1191311584.17826.4.camel@localhost.localdomain>
In-Reply-To: <1191311584.17826.4.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> No, they're helpers.  eg:
>
> static void lguest_exit_lazy(enum paravirt_lazy_mode mode)
> {
> paravirt_exit_lazy(mode);
> lguest_flush_hcalls();
> }
>   

OK, how does this sit with you?

Subject: paravirt: clean up lazy mode handling

Currently, the set_lazy_mode pv_op is overloaded with 5 functions:
 1. enter lazy cpu mode
 2. leave lazy cpu mode
 3. enter lazy mmu mode
 4. leave lazy mmu mode
 5. flush pending batched operations

This complicates each paravirt backend, since it needs to deal with
all the possible state transitions, handling flushing, etc. In
particular, flushing is quite distinct from the other 4 functions, and
seems to just cause complication.

This patch removes the set_lazy_mode operation, and adds "enter" and
"leave" lazy mode operations on mmu_ops and cpu_ops.  All the logic
associated with enter and leaving lazy states is now in common code
(basically BUG_ONs to make sure that no mode is current when entering
a lazy mode, and make sure that the mode is current when leaving).
Also, flush is handled in a common way, by simply leaving and
re-entering the lazy mode.

The result is that the Xen and VMI lazy mode implementations are much
simpler; as would lguest's be.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zach Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Anthony Liguory <aliguori@us.ibm.com>
Cc: "Glauber de Oliveira Costa" <glommer@gmail.com>
Cc: "Nakajima, Jun" <jun.nakajima@intel.com>

---
 arch/i386/kernel/paravirt.c |   58 +++++++++++++++++++++++++++++++++++++++----
 arch/i386/kernel/vmi.c      |   45 +++++++++++++++++++--------------
 arch/i386/xen/enlighten.c   |   44 ++++++++++----------------------
 arch/i386/xen/mmu.c         |    2 -
 arch/i386/xen/multicalls.h  |    2 -
 arch/i386/xen/xen-ops.h     |    7 -----
 include/asm-i386/paravirt.h |   52 ++++++++++++++++++++++++--------------
 7 files changed, 128 insertions(+), 82 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -265,6 +265,49 @@ int paravirt_disable_iospace(void)
 	}
 
 	return ret;
+}
+
+static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
+
+static inline void enter_lazy(enum paravirt_lazy_mode mode)
+{
+	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
+	BUG_ON(preemptible());
+
+	x86_write_percpu(paravirt_lazy_mode, mode);
+}
+
+void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
+{
+	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != mode);
+	BUG_ON(preemptible());
+
+	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
+}
+
+void paravirt_enter_lazy_mmu(void)
+{
+	enter_lazy(PARAVIRT_LAZY_MMU);
+}
+
+void paravirt_leave_lazy_mmu(void)
+{
+	paravirt_leave_lazy(PARAVIRT_LAZY_MMU);
+}
+
+void paravirt_enter_lazy_cpu(void)
+{
+	enter_lazy(PARAVIRT_LAZY_CPU);
+}
+
+void paravirt_leave_lazy_cpu(void)
+{
+	paravirt_leave_lazy(PARAVIRT_LAZY_CPU);
+}
+
+enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
+{
+	return x86_read_percpu(paravirt_lazy_mode);
 }
 
 struct paravirt_ops paravirt_ops = {
@@ -333,6 +376,11 @@ struct paravirt_ops paravirt_ops = {
 
 		 .set_iopl_mask = native_set_iopl_mask,
 		 .io_delay = native_io_delay,
+
+		 .lazy_mode = {
+			 .enter = paravirt_nop,
+			 .leave = paravirt_nop,
+		 },
 	 },
 
 	.pv_apic_ops = {
@@ -346,10 +394,6 @@ struct paravirt_ops paravirt_ops = {
 #endif
 	 },
 
-	.pv_misc_ops = {
-		 .set_lazy_mode = paravirt_nop,
-	 },
-
 	.pv_mmu_ops = {
 		 .pagetable_setup_start = native_pagetable_setup_start,
 		 .pagetable_setup_done = native_pagetable_setup_done,
@@ -400,6 +444,11 @@ struct paravirt_ops paravirt_ops = {
 		 .dup_mmap = paravirt_nop,
 		 .exit_mmap = paravirt_nop,
 		 .activate_mm = paravirt_nop,
+
+		 .lazy_mode = {
+			 .enter = paravirt_nop,
+			 .leave = paravirt_nop,
+		 },
 	 },
 };
 
@@ -417,7 +466,6 @@ static void __init __used pv_aliases(voi
 
 	substructure(pv_info);
 	substructure(pv_init_ops);
-	substructure(pv_misc_ops);
 	substructure(pv_time_ops);
 	substructure(pv_cpu_ops);
 	substructure(pv_irq_ops);
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -552,24 +552,22 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
-static void vmi_set_lazy_mode(enum paravirt_lazy_mode mode)
-{
-	static DEFINE_PER_CPU(enum paravirt_lazy_mode, lazy_mode);
-
-	if (!vmi_ops.set_lazy_mode)
-		return;
-
-	/* Modes should never nest or overlap */
-	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
-					     mode == PARAVIRT_LAZY_FLUSH));
-
-	if (mode == PARAVIRT_LAZY_FLUSH) {
-		vmi_ops.set_lazy_mode(0);
-		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
-	} else {
-		vmi_ops.set_lazy_mode(mode);
-		__get_cpu_var(lazy_mode) = mode;
-	}
+static void vmi_enter_lazy_cpu(void)
+{
+	paravirt_enter_lazy_cpu();
+	vmi_ops.set_lazy_mode(2);
+}
+
+static void vmi_enter_lazy_mmu(void)
+{
+	paravirt_enter_lazy_mmu();
+	vmi_ops.set_lazy_mode(1);
+}
+
+static void vmi_leave_lazy(void)
+{
+	paravirt_leave_lazy(paravirt_get_lazy_mode());
+	vmi_ops.set_lazy_mode(0);
 }
 
 static inline int __init check_vmi_rom(struct vrom_header *rom)
@@ -798,7 +796,16 @@ static inline int __init activate_vmi(vo
 	para_wrap(pv_cpu_ops.load_esp0, vmi_load_esp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(pv_cpu_ops.set_iopl_mask, SetIOPLMask);
 	para_fill(pv_cpu_ops.io_delay, IODelay);
-	para_wrap(pv_misc_ops.set_lazy_mode, vmi_set_lazy_mode, set_lazy_mode, SetLazyMode);
+
+	para_wrap(pv_cpu_ops.lazy_mode.enter, vmi_enter_lazy_cpu,
+		  set_lazy_mode, SetLazyMode);
+	para_wrap(pv_cpu_ops.lazy_mode.leave, vmi_leave_lazy,
+		  set_lazy_mode, SetLazyMode);
+
+	para_wrap(pv_mmu_ops.lazy_mode.enter, vmi_enter_lazy_mmu,
+		  set_lazy_mode, SetLazyMode);
+	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy,
+		  set_lazy_mode, SetLazyMode);
 
 	/* user and kernel flush are just handled with different flags to FlushTLB */
 	para_wrap(pv_mmu_ops.flush_tlb_user, vmi_flush_tlb_user, _flush_tlb, FlushTLB);
===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -51,8 +51,6 @@
 
 EXPORT_SYMBOL_GPL(hypercall_page);
 
-DEFINE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
-
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 DEFINE_PER_CPU(unsigned long, xen_cr3);
@@ -248,29 +246,10 @@ static void xen_halt(void)
 		xen_safe_halt();
 }
 
-static void xen_set_lazy_mode(enum paravirt_lazy_mode mode)
-{
-	BUG_ON(preemptible());
-
-	switch (mode) {
-	case PARAVIRT_LAZY_NONE:
-		BUG_ON(x86_read_percpu(xen_lazy_mode) == PARAVIRT_LAZY_NONE);
-		break;
-
-	case PARAVIRT_LAZY_MMU:
-	case PARAVIRT_LAZY_CPU:
-		BUG_ON(x86_read_percpu(xen_lazy_mode) != PARAVIRT_LAZY_NONE);
-		break;
-
-	case PARAVIRT_LAZY_FLUSH:
-		/* flush if necessary, but don't change state */
-		if (x86_read_percpu(xen_lazy_mode) != PARAVIRT_LAZY_NONE)
-			xen_mc_flush();
-		return;
-	}
-
+static void xen_leave_lazy(void)
+{
+	paravirt_leave_lazy(paravirt_get_lazy_mode());
 	xen_mc_flush();
-	x86_write_percpu(xen_lazy_mode, mode);
 }
 
 static unsigned long xen_store_tr(void)
@@ -357,7 +336,7 @@ static void xen_load_tls(struct thread_s
 	 * loaded properly.  This will go away as soon as Xen has been
 	 * modified to not save/restore %gs for normal hypercalls.
 	 */
-	if (xen_get_lazy_mode() == PARAVIRT_LAZY_CPU)
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU)
 		loadsegment(gs, 0);
 }
 
@@ -961,6 +940,11 @@ static const struct pv_cpu_ops xen_cpu_o
 
 	.set_iopl_mask = xen_set_iopl_mask,
 	.io_delay = xen_io_delay,
+
+	.lazy_mode = {
+		.enter = paravirt_enter_lazy_cpu,
+		.leave = xen_leave_lazy,
+	},
 };
 
 static const struct pv_irq_ops xen_irq_ops __initdata = {
@@ -1036,10 +1020,11 @@ static const struct pv_mmu_ops xen_mmu_o
 	.activate_mm = xen_activate_mm,
 	.dup_mmap = xen_dup_mmap,
 	.exit_mmap = xen_exit_mmap,
-};
-
-static const struct pv_misc_ops xen_misc_ops __initdata = {
-	.set_lazy_mode = xen_set_lazy_mode,
+
+	.lazy_mode = {
+		.enter = paravirt_enter_lazy_mmu,
+		.leave = xen_leave_lazy,
+	},
 };
 
 #ifdef CONFIG_SMP
@@ -1113,7 +1098,6 @@ asmlinkage void __init xen_start_kernel(
 	pv_irq_ops = xen_irq_ops;
 	pv_apic_ops = xen_apic_ops;
 	pv_mmu_ops = xen_mmu_ops;
-	pv_misc_ops = xen_misc_ops;
 
 	machine_ops = xen_machine_ops;
 
===================================================================
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -154,7 +154,7 @@ void xen_set_pte_at(struct mm_struct *mm
 		    pte_t *ptep, pte_t pteval)
 {
 	if (mm == current->mm || mm == &init_mm) {
-		if (xen_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
+		if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
 			struct multicall_space mcs;
 			mcs = xen_mc_entry(0);
 
===================================================================
--- a/arch/i386/xen/multicalls.h
+++ b/arch/i386/xen/multicalls.h
@@ -35,7 +35,7 @@ void xen_mc_flush(void);
 /* Issue a multicall if we're not in a lazy mode */
 static inline void xen_mc_issue(unsigned mode)
 {
-	if ((xen_get_lazy_mode() & mode) == 0)
+	if ((paravirt_get_lazy_mode() & mode) == 0)
 		xen_mc_flush();
 
 	/* restore flags saved in xen_mc_batch */
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -31,13 +31,6 @@ bool xen_vcpu_stolen(int vcpu);
 
 void xen_mark_init_mm_pinned(void);
 
-DECLARE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
-
-static inline unsigned xen_get_lazy_mode(void)
-{
-	return x86_read_percpu(xen_lazy_mode);
-}
-
 void __init xen_fill_possible_map(void);
 
 void __init xen_setup_vcpu_info_placement(void);
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -24,15 +24,6 @@ struct tss_struct;
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
 
 /* general info */
 struct pv_info {
@@ -64,9 +55,10 @@ struct pv_init_ops {
 };
 
 
-struct pv_misc_ops {
+struct pv_lazy_ops {
 	/* Set deferred update mode, used for batching operations. */
-	void (*set_lazy_mode)(enum paravirt_lazy_mode mode);
+	void (*enter)(void);
+	void (*leave)(void);
 };
 
 struct pv_time_ops {
@@ -131,6 +123,8 @@ struct pv_cpu_ops {
 	/* These two are jmp to, not actually called. */
 	void (*irq_enable_sysexit)(void);
 	void (*iret)(void);
+
+	struct pv_lazy_ops lazy_mode;
 };
 
 struct pv_irq_ops {
@@ -244,13 +238,14 @@ struct pv_mmu_ops {
 #ifdef CONFIG_HIGHPTE
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
 #endif
+
+	struct pv_lazy_ops lazy_mode;
 };
 
 struct paravirt_ops
 {
 	struct pv_info pv_info;
 	struct pv_init_ops pv_init_ops;
-	struct pv_misc_ops pv_misc_ops;
 	struct pv_time_ops pv_time_ops;
 	struct pv_cpu_ops pv_cpu_ops;
 	struct pv_irq_ops pv_irq_ops;
@@ -260,7 +255,6 @@ struct paravirt_ops
 
 extern struct pv_info pv_info;
 extern struct pv_init_ops pv_init_ops;
-extern struct pv_misc_ops pv_misc_ops;
 extern struct pv_time_ops pv_time_ops;
 extern struct pv_cpu_ops pv_cpu_ops;
 extern struct pv_irq_ops pv_irq_ops;
@@ -951,37 +945,57 @@ static inline void set_pmd(pmd_t *pmdp, 
 }
 #endif	/* CONFIG_X86_PAE */
 
+/* Lazy mode for batching updates / context switch */
+enum paravirt_lazy_mode {
+	PARAVIRT_LAZY_NONE,
+	PARAVIRT_LAZY_MMU,
+	PARAVIRT_LAZY_CPU,
+};
+
+enum paravirt_lazy_mode paravirt_get_lazy_mode(void);
+void paravirt_enter_lazy_cpu(void);
+void paravirt_leave_lazy_cpu(void);
+void paravirt_enter_lazy_mmu(void);
+void paravirt_leave_lazy_mmu(void);
+void paravirt_leave_lazy(enum paravirt_lazy_mode mode);
+
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 static inline void arch_enter_lazy_cpu_mode(void)
 {
-	PVOP_VCALL1(pv_misc_ops.set_lazy_mode, PARAVIRT_LAZY_CPU);
+	PVOP_VCALL0(pv_cpu_ops.lazy_mode.enter);
 }
 
 static inline void arch_leave_lazy_cpu_mode(void)
 {
-	PVOP_VCALL1(pv_misc_ops.set_lazy_mode, PARAVIRT_LAZY_NONE);
+	PVOP_VCALL0(pv_cpu_ops.lazy_mode.leave);
 }
 
 static inline void arch_flush_lazy_cpu_mode(void)
 {
-	PVOP_VCALL1(pv_misc_ops.set_lazy_mode, PARAVIRT_LAZY_FLUSH);
+	if (unlikely(paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU)) {
+		arch_leave_lazy_cpu_mode();
+		arch_enter_lazy_cpu_mode();
+	}
 }
 
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	PVOP_VCALL1(pv_misc_ops.set_lazy_mode, PARAVIRT_LAZY_MMU);
+	PVOP_VCALL0(pv_mmu_ops.lazy_mode.enter);
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	PVOP_VCALL1(pv_misc_ops.set_lazy_mode, PARAVIRT_LAZY_NONE);
+	PVOP_VCALL0(pv_mmu_ops.lazy_mode.leave);
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
-	PVOP_VCALL1(pv_misc_ops.set_lazy_mode, PARAVIRT_LAZY_FLUSH);
+	if (unlikely(paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU)) {
+		arch_leave_lazy_mmu_mode();
+		arch_enter_lazy_mmu_mode();
+	}
 }
 
 void _paravirt_nop(void);

