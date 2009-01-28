Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZA1Wnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZA1Wnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZA1Wmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:42:40 -0500
Received: from gw.goop.org ([64.81.55.164]:52548 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637AbZA1Wmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:42:38 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 7] x86/paravirt: add register-saving thunks to reduce
	caller register pressure
X-Mercurial-Node: 7d4a052c499dbfe5e816ce1b3af34ce2f754166d
Message-Id: <7d4a052c499dbfe5e816.1233182105@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
References: <patchbomb.1233182100@abulafia.goop.org>
Date: Wed, 28 Jan 2009 14:35:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the problems with inserting a pile of C calls where previously
there were none is that the register pressure is greatly increased.
The C calling convention says that the caller must expect a certain
set of registers may be trashed by the callee, and that the callee can
use those registers without restriction.  This includes the function
argument registers, and several others.

This patch seeks to alleviate this pressure by introducing wrapper
thunks that will do the register saving/restoring, so that the
callsite doesn't need to worry about it, but the callee function can
be conventional compiler-generated code.  In many cases (particularly
performance-sensitive cases) the callee will be in assembler anyway,
and need not use the compiler's calling convention.

Standard calling convention is:
	 arguments	    return	scratch
x86-32	 eax edx ecx	    eax		?
x86-64	 rdi rsi rdx rcx    rax		r8 r9 r10 r11

The thunk preserves all argument and scratch registers.  The return
register is not preserved, and is available as a scratch register for
unwrapped callee code (and of course the return value).

Wrapped function pointers are themselves wrapped in a struct
paravirt_callee_save structure, in order to get some warning from the
compiler when functions with mismatched calling conventions are used.

The most common paravirt ops, both statically and dynamically, are
interrupt enable/disable/save/restore, so handle them first.  This is
particularly easy since their calls are handled specially anyway.

XXX Deal with VMI.  What's their calling convention?

---
 arch/x86/include/asm/paravirt.h |  126 ++++++++++++++++++++++++++++++---------
 arch/x86/kernel/paravirt.c      |    8 +-
 arch/x86/kernel/vsmp_64.c       |   12 ++-
 arch/x86/lguest/boot.c          |   13 ++--
 arch/x86/xen/enlighten.c        |    8 +-
 arch/x86/xen/irq.c              |   14 +++-
 6 files changed, 132 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -17,6 +17,10 @@
 #ifdef CONFIG_X86_32
 /* CLBR_ANY should match all regs platform has. For i386, that's just it */
 #define CLBR_ANY  ((1 << 4) - 1)
+
+#define CLBR_ARG_REGS	(CLBR_EAX | CLBR_EDX | CLBR_ECX)
+#define CLBR_RET_REG	(CLBR_EAX)
+#define CLBR_SCRATCH	(0)
 #else
 #define CLBR_RAX  CLBR_EAX
 #define CLBR_RCX  CLBR_ECX
@@ -27,16 +31,19 @@
 #define CLBR_R9   (1 << 6)
 #define CLBR_R10  (1 << 7)
 #define CLBR_R11  (1 << 8)
+
 #define CLBR_ANY  ((1 << 9) - 1)
 
 #define CLBR_ARG_REGS	(CLBR_RDI | CLBR_RSI | CLBR_RDX | \
 			 CLBR_RCX | CLBR_R8 | CLBR_R9)
-#define CLBR_RET_REG	(CLBR_RAX | CLBR_RDX)
+#define CLBR_RET_REG	(CLBR_RAX)
 #define CLBR_SCRATCH	(CLBR_R10 | CLBR_R11)
 
 #include <asm/desc_defs.h>
 #endif /* X86_64 */
 
+#define CLBR_CALLEE_SAVE ((CLBR_ARG_REGS | CLBR_SCRATCH) & ~CLBR_RET_REG)
+
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/cpumask.h>
@@ -50,6 +57,14 @@
 struct mm_struct;
 struct desc_struct;
 
+/*
+ * Wrapper type for pointers to code which uses the non-standard
+ * calling convention.  See PV_CALL_SAVE_REGS_THUNK below.
+ */
+struct paravirt_callee_save {
+	void *func;
+};
+
 /* general info */
 struct pv_info {
 	unsigned int kernel_rpl;
@@ -199,11 +214,15 @@
 	 * expected to use X86_EFLAGS_IF; all other bits
 	 * returned from save_fl are undefined, and may be ignored by
 	 * restore_fl.
+	 *
+	 * NOTE: These functions callers expect the callee to preserve
+	 * more registers than the standard C calling convention.
 	 */
-	unsigned long (*save_fl)(void);
-	void (*restore_fl)(unsigned long);
-	void (*irq_disable)(void);
-	void (*irq_enable)(void);
+	struct paravirt_callee_save save_fl;
+	struct paravirt_callee_save restore_fl;
+	struct paravirt_callee_save irq_disable;
+	struct paravirt_callee_save irq_enable;
+
 	void (*safe_halt)(void);
 	void (*halt)(void);
 
@@ -1435,12 +1454,37 @@
 	__parainstructions_end[];
 
 #ifdef CONFIG_X86_32
-#define PV_SAVE_REGS "pushl %%ecx; pushl %%edx;"
-#define PV_RESTORE_REGS "popl %%edx; popl %%ecx"
+#define PV_SAVE_REGS "pushl %ecx; pushl %edx;"
+#define PV_RESTORE_REGS "popl %edx; popl %ecx;"
+
+/* save and restore all caller-save registers, except return value */
+#define PV_SAVE_ALL_CALLER_REGS PV_SAVE_REGS
+#define PV_RESTORE_ALL_CALLER_REGS PV_RESTORE_REGS
+
 #define PV_FLAGS_ARG "0"
 #define PV_EXTRA_CLOBBERS
 #define PV_VEXTRA_CLOBBERS
 #else
+/* save and restore all caller-save registers, except return value */
+#define PV_SAVE_ALL_CALLER_REGS						\
+	"push %rcx;"							\
+	"push %rdx;"							\
+	"push %rsi;"							\
+	"push %rdi;"							\
+	"push %r8;"							\
+	"push %r9;"							\
+	"push %r10;"							\
+	"push %r11;"
+#define PV_RESTORE_ALL_CALLER_REGS					\
+	"pop %r11;"							\
+	"pop %r10;"							\
+	"pop %r9;"							\
+	"pop %r8;"							\
+	"pop %rdi;"							\
+	"pop %rsi;"							\
+	"pop %rdx;"							\
+	"pop %rcx;"
+
 /* We save some registers, but all of them, that's too much. We clobber all
  * caller saved registers but the argument parameter */
 #define PV_SAVE_REGS "pushq %%rdi;"
@@ -1450,52 +1494,76 @@
 #define PV_FLAGS_ARG "D"
 #endif
 
+/*
+ * Generate a thunk around a function which saves all caller-save
+ * registers except for the return value.  This allows C functions to
+ * be called from assembler code where fewer than normal registers are
+ * available.  It may also help code generation around calls from C
+ * code if the common case doesn't use many registers.
+ *
+ * When a callee is wrapped in a thunk, the caller can assume that all
+ * arg regs and all scratch registers are preserved across the
+ * call. The return value in rax/eax will not be saved, even for void
+ * functions.
+ */
+#define PV_CALLEE_SAVE_REGS_THUNK(func)					\
+	extern typeof(func) __raw_callee_save_##func;			\
+	static void *__##func##__ __used = func;			\
+									\
+	asm(".pushsection .text;"					\
+	    "__raw_callee_save_" #func ": "				\
+	    PV_SAVE_ALL_CALLER_REGS					\
+	    "call " #func ";"						\
+	    PV_RESTORE_ALL_CALLER_REGS					\
+	    "ret;"							\
+	    ".popsection")
+
+/* Get a reference to a callee-save function */
+#define PV_CALLEE_SAVE(func)						\
+	((struct paravirt_callee_save) { __raw_callee_save_##func })
+
+/* Promise that "func" already uses the right calling convention */
+#define __PV_IS_CALLEE_SAVE(func)			\
+	((struct paravirt_callee_save) { func })
+
 static inline unsigned long __raw_local_save_flags(void)
 {
 	unsigned long f;
 
-	asm volatile(paravirt_alt(PV_SAVE_REGS
-				  PARAVIRT_CALL
-				  PV_RESTORE_REGS)
+	asm volatile(paravirt_alt(PARAVIRT_CALL)
 		     : "=a"(f)
 		     : paravirt_type(pv_irq_ops.save_fl),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc" PV_VEXTRA_CLOBBERS);
+		     : "memory", "cc");
 	return f;
 }
 
 static inline void raw_local_irq_restore(unsigned long f)
 {
-	asm volatile(paravirt_alt(PV_SAVE_REGS
-				  PARAVIRT_CALL
-				  PV_RESTORE_REGS)
+	asm volatile(paravirt_alt(PARAVIRT_CALL)
 		     : "=a"(f)
 		     : PV_FLAGS_ARG(f),
 		       paravirt_type(pv_irq_ops.restore_fl),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc" PV_EXTRA_CLOBBERS);
+		     : "memory", "cc");
 }
 
 static inline void raw_local_irq_disable(void)
 {
-	asm volatile(paravirt_alt(PV_SAVE_REGS
-				  PARAVIRT_CALL
-				  PV_RESTORE_REGS)
+	asm volatile(paravirt_alt(PARAVIRT_CALL)
 		     :
 		     : paravirt_type(pv_irq_ops.irq_disable),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc" PV_EXTRA_CLOBBERS);
+		     : "memory", "eax", "cc");
 }
 
 static inline void raw_local_irq_enable(void)
 {
-	asm volatile(paravirt_alt(PV_SAVE_REGS
-				  PARAVIRT_CALL
-				  PV_RESTORE_REGS)
+	asm volatile(paravirt_alt(PARAVIRT_CALL)
 		     :
 		     : paravirt_type(pv_irq_ops.irq_enable),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc" PV_EXTRA_CLOBBERS);
+		     : "memory", "eax", "cc");
 }
 
 static inline unsigned long __raw_local_irq_save(void)
@@ -1539,9 +1607,9 @@
 
 
 #define COND_PUSH(set, mask, reg)			\
-	.if ((~set) & mask); push %reg; .endif
+	.if ((~(set)) & mask); push %reg; .endif
 #define COND_POP(set, mask, reg)			\
-	.if ((~set) & mask); pop %reg; .endif
+	.if ((~(set)) & mask); pop %reg; .endif
 
 #ifdef CONFIG_X86_64
 
@@ -1592,15 +1660,15 @@
 
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
-		  PV_SAVE_REGS(clobbers);				\
+		  PV_SAVE_REGS(clobbers | CLBR_CALLEE_SAVE);		\
 		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_disable);	\
-		  PV_RESTORE_REGS(clobbers);)
+		  PV_RESTORE_REGS(clobbers | CLBR_CALLEE_SAVE);)
 
 #define ENABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_enable), clobbers,	\
-		  PV_SAVE_REGS(clobbers);				\
+		  PV_SAVE_REGS(clobbers | CLBR_CALLEE_SAVE);		\
 		  call PARA_INDIRECT(pv_irq_ops+PV_IRQ_irq_enable);	\
-		  PV_RESTORE_REGS(clobbers);)
+		  PV_RESTORE_REGS(clobbers | CLBR_CALLEE_SAVE);)
 
 #define USERGS_SYSRET32							\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_usergs_sysret32),	\
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -310,10 +310,10 @@
 
 struct pv_irq_ops pv_irq_ops = {
 	.init_IRQ = native_init_IRQ,
-	.save_fl = native_save_fl,
-	.restore_fl = native_restore_fl,
-	.irq_disable = native_irq_disable,
-	.irq_enable = native_irq_enable,
+	.save_fl = __PV_IS_CALLEE_SAVE(native_save_fl),
+	.restore_fl = __PV_IS_CALLEE_SAVE(native_restore_fl),
+	.irq_disable = __PV_IS_CALLEE_SAVE(native_irq_disable),
+	.irq_enable = __PV_IS_CALLEE_SAVE(native_irq_enable),
 	.safe_halt = native_safe_halt,
 	.halt = native_halt,
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -37,6 +37,7 @@
 		flags &= ~X86_EFLAGS_IF;
 	return flags;
 }
+PV_CALLEE_SAVE_REGS_THUNK(vsmp_save_fl);
 
 static void vsmp_restore_fl(unsigned long flags)
 {
@@ -46,6 +47,7 @@
 		flags |= X86_EFLAGS_AC;
 	native_restore_fl(flags);
 }
+PV_CALLEE_SAVE_REGS_THUNK(vsmp_restore_fl);
 
 static void vsmp_irq_disable(void)
 {
@@ -53,6 +55,7 @@
 
 	native_restore_fl((flags & ~X86_EFLAGS_IF) | X86_EFLAGS_AC);
 }
+PV_CALLEE_SAVE_REGS_THUNK(vsmp_irq_disable);
 
 static void vsmp_irq_enable(void)
 {
@@ -60,6 +63,7 @@
 
 	native_restore_fl((flags | X86_EFLAGS_IF) & (~X86_EFLAGS_AC));
 }
+PV_CALLEE_SAVE_REGS_THUNK(vsmp_irq_enable);
 
 static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 				  unsigned long addr, unsigned len)
@@ -90,10 +94,10 @@
 	       cap, ctl);
 	if (cap & ctl & (1 << 4)) {
 		/* Setup irq ops and turn on vSMP  IRQ fastpath handling */
-		pv_irq_ops.irq_disable = vsmp_irq_disable;
-		pv_irq_ops.irq_enable  = vsmp_irq_enable;
-		pv_irq_ops.save_fl  = vsmp_save_fl;
-		pv_irq_ops.restore_fl  = vsmp_restore_fl;
+		pv_irq_ops.irq_disable = PV_CALLEE_SAVE(vsmp_irq_disable);
+		pv_irq_ops.irq_enable  = PV_CALLEE_SAVE(vsmp_irq_enable);
+		pv_irq_ops.save_fl  = PV_CALLEE_SAVE(vsmp_save_fl);
+		pv_irq_ops.restore_fl  = PV_CALLEE_SAVE(vsmp_restore_fl);
 		pv_init_ops.patch = vsmp_patch;
 
 		ctl &= ~(1 << 4);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -173,24 +173,29 @@
 {
 	return lguest_data.irq_enabled;
 }
+PV_CALLEE_SAVE_REGS_THUNK(save_fl);
 
 /* restore_flags() just sets the flags back to the value given. */
 static void restore_fl(unsigned long flags)
 {
 	lguest_data.irq_enabled = flags;
 }
+PV_CALLEE_SAVE_REGS_THUNK(restore_fl);
 
 /* Interrupts go off... */
 static void irq_disable(void)
 {
 	lguest_data.irq_enabled = 0;
 }
+PV_CALLEE_SAVE_REGS_THUNK(irq_disable);
 
 /* Interrupts go on... */
 static void irq_enable(void)
 {
 	lguest_data.irq_enabled = X86_EFLAGS_IF;
 }
+PV_CALLEE_SAVE_REGS_THUNK(irq_enable);
+
 /*:*/
 /*M:003 Note that we don't check for outstanding interrupts when we re-enable
  * them (or when we unmask an interrupt).  This seems to work for the moment,
@@ -984,10 +989,10 @@
 
 	/* interrupt-related operations */
 	pv_irq_ops.init_IRQ = lguest_init_IRQ;
-	pv_irq_ops.save_fl = save_fl;
-	pv_irq_ops.restore_fl = restore_fl;
-	pv_irq_ops.irq_disable = irq_disable;
-	pv_irq_ops.irq_enable = irq_enable;
+	pv_irq_ops.save_fl = PV_CALLEE_SAVE(save_fl);
+	pv_irq_ops.restore_fl = PV_CALLEE_SAVE(restore_fl);
+	pv_irq_ops.irq_disable = PV_CALLEE_SAVE(irq_disable);
+	pv_irq_ops.irq_enable = PV_CALLEE_SAVE(irq_enable);
 	pv_irq_ops.safe_halt = lguest_safe_halt;
 
 	/* init-time operations */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -676,10 +676,10 @@
 	if (have_vcpu_info_placement) {
 		printk(KERN_INFO "Xen: using vcpu_info placement\n");
 
-		pv_irq_ops.save_fl = xen_save_fl_direct;
-		pv_irq_ops.restore_fl = xen_restore_fl_direct;
-		pv_irq_ops.irq_disable = xen_irq_disable_direct;
-		pv_irq_ops.irq_enable = xen_irq_enable_direct;
+		pv_irq_ops.save_fl = __PV_IS_CALLEE_SAVE(xen_save_fl_direct);
+		pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(xen_restore_fl_direct);
+		pv_irq_ops.irq_disable = __PV_IS_CALLEE_SAVE(xen_irq_disable_direct);
+		pv_irq_ops.irq_enable = __PV_IS_CALLEE_SAVE(xen_irq_enable_direct);
 		pv_mmu_ops.read_cr2 = xen_read_cr2_direct;
 	}
 }
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -50,6 +50,7 @@
 	*/
 	return (-flags) & X86_EFLAGS_IF;
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_save_fl);
 
 static void xen_restore_fl(unsigned long flags)
 {
@@ -76,6 +77,7 @@
 			xen_force_evtchn_callback();
 	}
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_restore_fl);
 
 static void xen_irq_disable(void)
 {
@@ -86,6 +88,7 @@
 	percpu_read(xen_vcpu)->evtchn_upcall_mask = 1;
 	preempt_enable_no_resched();
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_irq_disable);
 
 static void xen_irq_enable(void)
 {
@@ -106,6 +109,7 @@
 	if (unlikely(vcpu->evtchn_upcall_pending))
 		xen_force_evtchn_callback();
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_irq_enable);
 
 static void xen_safe_halt(void)
 {
@@ -124,10 +128,12 @@
 
 static const struct pv_irq_ops xen_irq_ops __initdata = {
 	.init_IRQ = __xen_init_IRQ,
-	.save_fl = xen_save_fl,
-	.restore_fl = xen_restore_fl,
-	.irq_disable = xen_irq_disable,
-	.irq_enable = xen_irq_enable,
+
+	.save_fl = PV_CALLEE_SAVE(xen_save_fl),
+	.restore_fl = PV_CALLEE_SAVE(xen_restore_fl),
+	.irq_disable = PV_CALLEE_SAVE(xen_irq_disable),
+	.irq_enable = PV_CALLEE_SAVE(xen_irq_enable),
+
 	.safe_halt = xen_safe_halt,
 	.halt = xen_halt,
 #ifdef CONFIG_X86_64


