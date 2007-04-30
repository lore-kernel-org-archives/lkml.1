Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXD3K3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXD3K3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXD3K3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:51175 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbXD3K1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:47 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, rusty@rustcorp.com.au, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [13/40] i386: Document asm-i386/paravirt.h
Message-Id: <20070430102746.94B14151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Clean things up, and broadly document:
 - the paravirt_ops functions themselves
 - the patching mechanism

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
 
---
 include/asm-i386/paravirt.h |  131 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 121 insertions(+), 10 deletions(-)

===================================================================
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -21,6 +21,14 @@ struct Xgt_desc_struct;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
+
+/* Lazy mode for batching updates / context switch */
+enum paravirt_lazy_mode {
+	PARAVIRT_LAZY_NONE = 0,
+	PARAVIRT_LAZY_MMU = 1,
+	PARAVIRT_LAZY_CPU = 2,
+};
+
 struct paravirt_ops
 {
 	unsigned int kernel_rpl;
@@ -37,22 +45,33 @@ struct paravirt_ops
 	 */
 	unsigned (*patch)(u8 type, u16 clobber, void *firstinsn, unsigned len);
 
+	/* Basic arch-specific setup */
 	void (*arch_setup)(void);
 	char *(*memory_setup)(void);
 	void (*init_IRQ)(void);
+	void (*time_init)(void);
 
+	/*
+	 * Called before/after init_mm pagetable setup. setup_start
+	 * may reset %cr3, and may pre-install parts of the pagetable;
+	 * pagetable setup is expected to preserve any existing
+	 * mapping.
+	 */
 	void (*pagetable_setup_start)(pgd_t *pgd_base);
 	void (*pagetable_setup_done)(pgd_t *pgd_base);
 
+	/* Print a banner to identify the environment */
 	void (*banner)(void);
 
+	/* Set and set time of day */
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long);
-	void (*time_init)(void);
 
+	/* cpuid emulation, mostly so that caps bits can be disabled */
 	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
 		      unsigned int *ecx, unsigned int *edx);
 
+	/* hooks for various privileged instructions */
 	unsigned long (*get_debugreg)(int regno);
 	void (*set_debugreg)(int regno, unsigned long value);
 
@@ -71,15 +90,23 @@ struct paravirt_ops
 	unsigned long (*read_cr4)(void);
 	void (*write_cr4)(unsigned long);
 
+	/*
+	 * Get/set interrupt state.  save_fl and restore_fl are only
+	 * expected to use X86_EFLAGS_IF; all other bits
+	 * returned from save_fl are undefined, and may be ignored by
+	 * restore_fl.
+	 */
 	unsigned long (*save_fl)(void);
 	void (*restore_fl)(unsigned long);
 	void (*irq_disable)(void);
 	void (*irq_enable)(void);
 	void (*safe_halt)(void);
 	void (*halt)(void);
+
 	void (*wbinvd)(void);
 
-	/* err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
+	/* MSR, PMC and TSR operations.
+	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
 	u64 (*read_msr)(unsigned int msr, int *err);
 	int (*write_msr)(unsigned int msr, u64 val);
 
@@ -88,6 +115,7 @@ struct paravirt_ops
  	u64 (*get_scheduled_cycles)(void);
 	unsigned long (*get_cpu_khz)(void);
 
+	/* Segment descriptor handling */
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct Xgt_desc_struct *);
 	void (*load_idt)(const struct Xgt_desc_struct *);
@@ -105,9 +133,12 @@ struct paravirt_ops
 	void (*load_esp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
-
 	void (*io_delay)(void);
 
+	/*
+	 * Hooks for intercepting the creation/use/destruction of an
+	 * mm_struct.
+	 */
 	void (*activate_mm)(struct mm_struct *prev,
 			    struct mm_struct *next);
 	void (*dup_mmap)(struct mm_struct *oldmm,
@@ -115,30 +146,43 @@ struct paravirt_ops
 	void (*exit_mmap)(struct mm_struct *mm);
 
 #ifdef CONFIG_X86_LOCAL_APIC
+	/*
+	 * Direct APIC operations, principally for VMI.  Ideally
+	 * these shouldn't be in this interface.
+	 */
 	void (*apic_write)(unsigned long reg, unsigned long v);
 	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
 	unsigned long (*apic_read)(unsigned long reg);
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
+
+	void (*startup_ipi_hook)(int phys_apicid,
+				 unsigned long start_eip,
+				 unsigned long start_esp);
 #endif
 
+	/* TLB operations */
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(unsigned long addr);
 
 	void (*map_pt_hook)(int type, pte_t *va, u32 pfn);
 
+	/* Hooks for allocating/releasing pagetable pages */
 	void (*alloc_pt)(u32 pfn);
 	void (*alloc_pd)(u32 pfn);
 	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
 	void (*release_pt)(u32 pfn);
 	void (*release_pd)(u32 pfn);
 
+	/* Pagetable manipulation functions */
 	void (*set_pte)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pteval);
+	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pteval);
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
 	void (*pte_update)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-	void (*pte_update_defer)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+	void (*pte_update_defer)(struct mm_struct *mm,
+				 unsigned long addr, pte_t *ptep);
 
  	pte_t (*ptep_get_and_clear)(pte_t *ptep);
 
@@ -164,13 +208,12 @@ struct paravirt_ops
 	pgd_t (*make_pgd)(unsigned long pgd);
 #endif
 
-	void (*set_lazy_mode)(int mode);
+	/* Set deferred update mode, used for batching operations. */
+	void (*set_lazy_mode)(enum paravirt_lazy_mode mode);
 
 	/* These two are jmp to, not actually called. */
 	void (*irq_enable_sysexit)(void);
 	void (*iret)(void);
-
-	void (*startup_ipi_hook)(int phys_apicid, unsigned long start_eip, unsigned long start_esp);
 };
 
 /* Mark a paravirt probe function. */
@@ -188,8 +231,10 @@ extern struct paravirt_ops paravirt_ops;
 #define paravirt_clobber(clobber)		\
 	[paravirt_clobber] "i" (clobber)
 
-#define PARAVIRT_CALL	"call *(paravirt_ops+%c[paravirt_typenum]*4);"
-
+/*
+ * Generate some code, and mark it as patchable by the
+ * apply_paravirt() alternate instruction patcher.
+ */
 #define _paravirt_alt(insn_string, type, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\
 	".pushsection .parainstructions,\"a\"\n"	\
@@ -199,9 +244,74 @@ extern struct paravirt_ops paravirt_ops;
 	"  .short " clobber "\n"			\
 	".popsection\n"
 
+/* Generate patchable code, with the default asm parameters. */
 #define paravirt_alt(insn_string)					\
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
+/*
+ * This generates an indirect call based on the operation type number.
+ * The type number, computed in PARAVIRT_PATCH, is derived from the
+ * offset into the paravirt_ops structure, and can therefore be freely
+ * converted back into a structure offset.
+ */
+#define PARAVIRT_CALL	"call *(paravirt_ops+%c[paravirt_typenum]*4);"
+
+/*
+ * These macros are intended to wrap calls into a paravirt_ops
+ * operation, so that they can be later identified and patched at
+ * runtime.
+ *
+ * Normally, a call to a pv_op function is a simple indirect call:
+ * (paravirt_ops.operations)(args...).
+ *
+ * Unfortunately, this is a relatively slow operation for modern CPUs,
+ * because it cannot necessarily determine what the destination
+ * address is.  In this case, the address is a runtime constant, so at
+ * the very least we can patch the call to e a simple direct call, or
+ * ideally, patch an inline implementation into the callsite.  (Direct
+ * calls are essentially free, because the call and return addresses
+ * are completely predictable.)
+ *
+ * These macros rely on the standard gcc "regparm(3)" calling
+ * convention, in which the first three arguments are placed in %eax,
+ * %edx, %ecx (in that order), and the remaining arguments are placed
+ * on the stack.  All caller-save registers (eax,edx,ecx) are expected
+ * to be modified (either clobbered or used for return values).
+ *
+ * The call instruction itself is marked by placing its start address
+ * and size into the .parainstructions section, so that
+ * apply_paravirt() in arch/i386/kernel/alternative.c can do the
+ * appropriate patching under the control of the backend paravirt_ops
+ * implementation.
+ *
+ * Unfortunately there's no way to get gcc to generate the args setup
+ * for the call, and then allow the call itself to be generated by an
+ * inline asm.  Because of this, we must do the complete arg setup and
+ * return value handling from within these macros.  This is fairly
+ * cumbersome.
+ *
+ * There are 5 sets of PVOP_* macros for dealing with 0-4 arguments.
+ * It could be extended to more arguments, but there would be little
+ * to be gained from that.  For each number of arguments, there are
+ * the two VCALL and CALL variants for void and non-void functions.
+ *
+ * When there is a return value, the invoker of the macro must specify
+ * the return type.  The macro then uses sizeof() on that type to
+ * determine whether its a 32 or 64 bit value, and places the return
+ * in the right register(s) (just %eax for 32-bit, and %edx:%eax for
+ * 64-bit).
+ *
+ * 64-bit arguments are passed as a pair of adjacent 32-bit arguments
+ * in low,high order.
+ *
+ * Small structures are passed and returned in registers.  The macro
+ * calling convention can't directly deal with this, so the wrapper
+ * functions must do this.
+ *
+ * These PVOP_* macros are only defined within this header.  This
+ * means that all uses must be wrapped in inline functions.  This also
+ * makes sure the incoming and outgoing types are always correct.
+ */
 #define PVOP_CALL0(__rettype, __op)					\
 	({								\
 		__rettype __ret;					\
@@ -1026,6 +1136,7 @@ static inline unsigned long __raw_local_
 	[paravirt_sti_type] "i" (PARAVIRT_PATCH(irq_enable)),		\
 	paravirt_clobber(CLBR_EAX)
 
+/* Make sure as little as possible of this mess escapes. */
 #undef PARAVIRT_CALL
 #undef PVOP_VCALL0
 #undef PVOP_CALL0
