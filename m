Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZBINoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZBINoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZBINlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:41:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:37882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbZBINk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:59 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>, Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH 10/11] x86: make lazy %gs optional on x86_32
Date: Mon,  9 Feb 2009 22:39:57 +0900
Message-Id: <1234186798-16820-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: pt_regs changed, lazy gs handling made optional, add slight
        overhead to SAVE_ALL, simplifies error_code path a bit

On x86_32, %gs hasn't been used by kernel and handled lazily.  pt_regs
doesn't have place for it and gs is saved/loaded only when necessary.
In preparation for stack protector support, this patch makes lazy %gs
handling optional by doing the followings.

* Add CONFIG_X86_32_LAZY_GS and place for gs in pt_regs.

* Save and restore %gs along with other registers in entry_32.S unless
  LAZY_GS.  Note that this unfortunately adds "pushl $0" on SAVE_ALL
  even when LAZY_GS.  However, it adds no overhead to common exit path
  and simplifies entry path with error code.

* Define different user_gs accessors depending on LAZY_GS and add
  lazy_save_gs() and lazy_load_gs() which are noop if !LAZY_GS.  The
  lazy_*_gs() ops are used to save, load and clear %gs lazily.

* Define ELF_CORE_COPY_KERNEL_REGS() which always read %gs directly.

xen and lguest changes need to be verified.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/Kconfig                   |    4 +
 arch/x86/include/asm/elf.h         |   15 ++++-
 arch/x86/include/asm/mmu_context.h |    2 +-
 arch/x86/include/asm/ptrace.h      |    4 +-
 arch/x86/include/asm/system.h      |   12 +++-
 arch/x86/kernel/asm-offsets_32.c   |    1 +
 arch/x86/kernel/entry_32.S         |  132 ++++++++++++++++++++++++++++++-----
 arch/x86/kernel/process_32.c       |    4 +-
 arch/x86/kernel/ptrace.c           |    5 +-
 arch/x86/lguest/boot.c             |    2 +-
 arch/x86/xen/enlighten.c           |   17 +++--
 11 files changed, 158 insertions(+), 40 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f9b3fde..e91093a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -196,6 +196,10 @@ config X86_TRAMPOLINE
 	depends on SMP || (64BIT && ACPI_SLEEP)
 	default y
 
+config X86_32_LAZY_GS
+	def_bool y
+	depends on X86_32
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 39b0aac..83c1bc8 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -112,7 +112,7 @@ extern unsigned int vdso_enabled;
  * now struct_user_regs, they are different)
  */
 
-#define ELF_CORE_COPY_REGS(pr_reg, regs)	\
+#define ELF_CORE_COPY_REGS_COMMON(pr_reg, regs)	\
 do {						\
 	pr_reg[0] = regs->bx;			\
 	pr_reg[1] = regs->cx;			\
@@ -124,7 +124,6 @@ do {						\
 	pr_reg[7] = regs->ds & 0xffff;		\
 	pr_reg[8] = regs->es & 0xffff;		\
 	pr_reg[9] = regs->fs & 0xffff;		\
-	pr_reg[10] = get_user_gs(regs);		\
 	pr_reg[11] = regs->orig_ax;		\
 	pr_reg[12] = regs->ip;			\
 	pr_reg[13] = regs->cs & 0xffff;		\
@@ -133,6 +132,18 @@ do {						\
 	pr_reg[16] = regs->ss & 0xffff;		\
 } while (0);
 
+#define ELF_CORE_COPY_REGS(pr_reg, regs)	\
+do {						\
+	ELF_CORE_COPY_REGS_COMMON(pr_reg, regs);\
+	pr_reg[10] = get_user_gs(regs);		\
+} while (0);
+
+#define ELF_CORE_COPY_KERNEL_REGS(pr_reg, regs)	\
+do {						\
+	ELF_CORE_COPY_REGS_COMMON(pr_reg, regs);\
+	savesegment(gs, pr_reg[10]);		\
+} while (0);
+
 #define ELF_PLATFORM	(utsname()->machine)
 #define set_personality_64bit()	do { } while (0)
 
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 4955165..f923203 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -79,7 +79,7 @@ do {						\
 #ifdef CONFIG_X86_32
 #define deactivate_mm(tsk, mm)			\
 do {						\
-	set_user_gs(task_pt_regs(tsk), 0);	\
+	lazy_load_gs(0);			\
 } while (0)
 #else
 #define deactivate_mm(tsk, mm)			\
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 6d34d95..e304b66 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -28,7 +28,7 @@ struct pt_regs {
 	int  xds;
 	int  xes;
 	int  xfs;
-	/* int  gs; */
+	int  xgs;
 	long orig_eax;
 	long eip;
 	int  xcs;
@@ -50,7 +50,7 @@ struct pt_regs {
 	unsigned long ds;
 	unsigned long es;
 	unsigned long fs;
-	/* int  gs; */
+	unsigned long gs;
 	unsigned long orig_ax;
 	unsigned long ip;
 	unsigned long cs;
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 72082d3..e658bbe 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -186,10 +186,20 @@ extern void native_load_gs_index(unsigned);
  * x86_32 user gs accessors.
  */
 #ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_32_LAZY_GS
 #define get_user_gs(regs)	(u16)({unsigned long v; savesegment(gs, v); v;})
 #define set_user_gs(regs, v)	loadsegment(gs, (unsigned long)(v))
 #define task_user_gs(tsk)	((tsk)->thread.gs)
-#endif
+#define lazy_save_gs(v)		savesegment(gs, (v))
+#define lazy_load_gs(v)		loadsegment(gs, (v))
+#else	/* X86_32_LAZY_GS */
+#define get_user_gs(regs)	(u16)((regs)->gs)
+#define set_user_gs(regs, v)	do { (regs)->gs = (v); } while (0)
+#define task_user_gs(tsk)	(task_pt_regs(tsk)->gs)
+#define lazy_save_gs(v)		do { } while (0)
+#define lazy_load_gs(v)		do { } while (0)
+#endif	/* X86_32_LAZY_GS */
+#endif	/* X86_32 */
 
 static inline unsigned long get_limit(unsigned long segment)
 {
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index ee4df08..fbf2f33 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -75,6 +75,7 @@ void foo(void)
 	OFFSET(PT_DS,  pt_regs, ds);
 	OFFSET(PT_ES,  pt_regs, es);
 	OFFSET(PT_FS,  pt_regs, fs);
+	OFFSET(PT_GS,  pt_regs, gs);
 	OFFSET(PT_ORIG_EAX, pt_regs, orig_ax);
 	OFFSET(PT_EIP, pt_regs, ip);
 	OFFSET(PT_CS,  pt_regs, cs);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 224739c..d3be889 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -30,12 +30,13 @@
  *	1C(%esp) - %ds
  *	20(%esp) - %es
  *	24(%esp) - %fs
- *	28(%esp) - orig_eax
- *	2C(%esp) - %eip
- *	30(%esp) - %cs
- *	34(%esp) - %eflags
- *	38(%esp) - %oldesp
- *	3C(%esp) - %oldss
+ *	28(%esp) - %gs		saved iff !CONFIG_X86_32_LAZY_GS
+ *	2C(%esp) - orig_eax
+ *	30(%esp) - %eip
+ *	34(%esp) - %cs
+ *	38(%esp) - %eflags
+ *	3C(%esp) - %oldesp
+ *	40(%esp) - %oldss
  *
  * "current" is in register %ebx during any slow entries.
  */
@@ -101,8 +102,99 @@
 #define resume_userspace_sig	resume_userspace
 #endif
 
+/*
+ * User gs save/restore
+ *
+ * %gs is used for userland TLS and kernel only uses it for stack
+ * canary which is required to be at %gs:20 by gcc.  Read the comment
+ * at the top of stackprotector.h for more info.
+ *
+ * Local labels 98 and 99 are used.
+ */
+#ifdef CONFIG_X86_32_LAZY_GS
+
+ /* unfortunately push/pop can't be no-op */
+.macro PUSH_GS
+	pushl $0
+	CFI_ADJUST_CFA_OFFSET 4
+.endm
+.macro POP_GS pop=0
+	addl $(4 + \pop), %esp
+	CFI_ADJUST_CFA_OFFSET -(4 + \pop)
+.endm
+.macro POP_GS_EX
+.endm
+
+ /* all the rest are no-op */
+.macro PTGS_TO_GS
+.endm
+.macro PTGS_TO_GS_EX
+.endm
+.macro GS_TO_REG reg
+.endm
+.macro REG_TO_PTGS reg
+.endm
+.macro SET_KERNEL_GS reg
+.endm
+
+#else	/* CONFIG_X86_32_LAZY_GS */
+
+.macro PUSH_GS
+	pushl %gs
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET gs, 0*/
+.endm
+
+.macro POP_GS pop=0
+98:	popl %gs
+	CFI_ADJUST_CFA_OFFSET -4
+	/*CFI_RESTORE gs*/
+  .if \pop <> 0
+	add $\pop, %esp
+	CFI_ADJUST_CFA_OFFSET -\pop
+  .endif
+.endm
+.macro POP_GS_EX
+.pushsection .fixup, "ax"
+99:	movl $0, (%esp)
+	jmp 98b
+.section __ex_table, "a"
+	.align 4
+	.long 98b, 99b
+.popsection
+.endm
+
+.macro PTGS_TO_GS
+98:	mov PT_GS(%esp), %gs
+.endm
+.macro PTGS_TO_GS_EX
+.pushsection .fixup, "ax"
+99:	movl $0, PT_GS(%esp)
+	jmp 98b
+.section __ex_table, "a"
+	.align 4
+	.long 98b, 99b
+.popsection
+.endm
+
+.macro GS_TO_REG reg
+	movl %gs, \reg
+	/*CFI_REGISTER gs, \reg*/
+.endm
+.macro REG_TO_PTGS reg
+	movl \reg, PT_GS(%esp)
+	/*CFI_REL_OFFSET gs, PT_GS*/
+.endm
+.macro SET_KERNEL_GS reg
+	xorl \reg, \reg
+	movl \reg, %gs
+.endm
+
+#endif	/* CONFIG_X86_32_LAZY_GS */
+
 .macro SAVE_ALL
 	cld
+	PUSH_GS
 	pushl %fs
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET fs, 0;*/
@@ -138,6 +230,7 @@
 	movl %edx, %es
 	movl $(__KERNEL_PERCPU), %edx
 	movl %edx, %fs
+	SET_KERNEL_GS %edx
 .endm
 
 .macro RESTORE_INT_REGS
@@ -164,7 +257,7 @@
 	CFI_RESTORE eax
 .endm
 
-.macro RESTORE_REGS
+.macro RESTORE_REGS pop=0
 	RESTORE_INT_REGS
 1:	popl %ds
 	CFI_ADJUST_CFA_OFFSET -4
@@ -175,6 +268,7 @@
 3:	popl %fs
 	CFI_ADJUST_CFA_OFFSET -4
 	/*CFI_RESTORE fs;*/
+	POP_GS \pop
 .pushsection .fixup, "ax"
 4:	movl $0, (%esp)
 	jmp 1b
@@ -188,6 +282,7 @@
 	.long 2b, 5b
 	.long 3b, 6b
 .popsection
+	POP_GS_EX
 .endm
 
 .macro RING0_INT_FRAME
@@ -368,6 +463,7 @@ sysenter_exit:
 	xorl %ebp,%ebp
 	TRACE_IRQS_ON
 1:	mov  PT_FS(%esp), %fs
+	PTGS_TO_GS
 	ENABLE_INTERRUPTS_SYSEXIT
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -416,6 +512,7 @@ sysexit_audit:
 	.align 4
 	.long 1b,2b
 .popsection
+	PTGS_TO_GS_EX
 ENDPROC(ia32_sysenter_target)
 
 	# system call handler stub
@@ -458,8 +555,7 @@ restore_all:
 restore_nocheck:
 	TRACE_IRQS_IRET
 restore_nocheck_notrace:
-	RESTORE_REGS
-	addl $4, %esp			# skip orig_eax/error_code
+	RESTORE_REGS 4			# skip orig_eax/error_code
 	CFI_ADJUST_CFA_OFFSET -4
 irq_return:
 	INTERRUPT_RETURN
@@ -1078,7 +1174,10 @@ ENTRY(page_fault)
 	CFI_ADJUST_CFA_OFFSET 4
 	ALIGN
 error_code:
-	/* the function address is in %fs's slot on the stack */
+	/* the function address is in %gs's slot on the stack */
+	pushl %fs
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET fs, 0*/
 	pushl %es
 	CFI_ADJUST_CFA_OFFSET 4
 	/*CFI_REL_OFFSET es, 0*/
@@ -1107,20 +1206,15 @@ error_code:
 	CFI_ADJUST_CFA_OFFSET 4
 	CFI_REL_OFFSET ebx, 0
 	cld
-	pushl %fs
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET fs, 0*/
 	movl $(__KERNEL_PERCPU), %ecx
 	movl %ecx, %fs
 	UNWIND_ESPFIX_STACK
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	/*CFI_REGISTER es, ecx*/
-	movl PT_FS(%esp), %edi		# get the function address
+	GS_TO_REG %ecx
+	movl PT_GS(%esp), %edi		# get the function address
 	movl PT_ORIG_EAX(%esp), %edx	# get the error code
 	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
-	mov  %ecx, PT_FS(%esp)
-	/*CFI_REL_OFFSET fs, ES*/
+	REG_TO_PTGS %ecx
+	SET_KERNEL_GS %ecx
 	movl $(__USER_DS), %ecx
 	movl %ecx, %ds
 	movl %ecx, %es
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 317d956..461d0a7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -537,7 +537,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * used %fs or %gs (it does not today), or if the kernel is
 	 * running inside of a hypervisor layer.
 	 */
-	savesegment(gs, prev->gs);
+	lazy_save_gs(prev->gs);
 
 	/*
 	 * Load the per-thread Thread-Local Storage descriptor.
@@ -583,7 +583,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * Restore %gs if needed (which is common)
 	 */
 	if (prev->gs | next->gs)
-		loadsegment(gs, next->gs);
+		lazy_load_gs(next->gs);
 
 	percpu_write(current_task, next_p);
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 508b6b5..7ec39ab 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -75,10 +75,7 @@ static inline bool invalid_selector(u16 value)
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
 	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
-	regno >>= 2;
-	if (regno > FS)
-		--regno;
-	return &regs->bx + regno;
+	return &regs->bx + (regno >> 2);
 }
 
 static u16 get_segment_reg(struct task_struct *task, unsigned long offset)
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 19e33b6..da2e314 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -283,7 +283,7 @@ static void lguest_load_tls(struct thread_struct *t, unsigned int cpu)
 	/* There's one problem which normal hardware doesn't have: the Host
 	 * can't handle us removing entries we're currently using.  So we clear
 	 * the GS register here: if it's needed it'll be reloaded anyway. */
-	loadsegment(gs, 0);
+	lazy_load_gs(0);
 	lazy_hcall(LHCALL_LOAD_TLS, __pa(&t->tls_array), cpu, 0);
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 3723034..95ff6a0 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -323,13 +323,14 @@ static void load_TLS_descriptor(struct thread_struct *t,
 static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
 {
 	/*
-	 * XXX sleazy hack: If we're being called in a lazy-cpu zone,
-	 * it means we're in a context switch, and %gs has just been
-	 * saved.  This means we can zero it out to prevent faults on
-	 * exit from the hypervisor if the next process has no %gs.
-	 * Either way, it has been saved, and the new value will get
-	 * loaded properly.  This will go away as soon as Xen has been
-	 * modified to not save/restore %gs for normal hypercalls.
+	 * XXX sleazy hack: If we're being called in a lazy-cpu zone
+	 * and lazy gs handling is enabled, it means we're in a
+	 * context switch, and %gs has just been saved.  This means we
+	 * can zero it out to prevent faults on exit from the
+	 * hypervisor if the next process has no %gs.  Either way, it
+	 * has been saved, and the new value will get loaded properly.
+	 * This will go away as soon as Xen has been modified to not
+	 * save/restore %gs for normal hypercalls.
 	 *
 	 * On x86_64, this hack is not used for %gs, because gs points
 	 * to KERNEL_GS_BASE (and uses it for PDA references), so we
@@ -341,7 +342,7 @@ static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
 	 */
 	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU) {
 #ifdef CONFIG_X86_32
-		loadsegment(gs, 0);
+		lazy_load_gs(0);
 #else
 		loadsegment(fs, 0);
 #endif
-- 
1.6.0.2

