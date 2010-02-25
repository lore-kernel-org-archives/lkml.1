Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432Ab0BYTbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:31:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:33951 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400Ab0BYTb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:31:28 -0500
Date: Thu, 25 Feb 2010 19:29:47 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, andersk@ksplice.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org,
       compudj@krystal.dyndns.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jkenisto@us.ibm.com,
       andi@firstfloor.org, tabbott@ksplice.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, andersk@ksplice.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org,
       compudj@krystal.dyndns.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jkenisto@us.ibm.com,
       andi@firstfloor.org, tabbott@ksplice.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133446.6725.78994.stgit@localhost6.localdomain6>
References: <20100225133446.6725.78994.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes/x86: Support kprobes jump optimization on x86
Message-ID: <tip-c0f7ac3a9edde786bc129d37627953a8b8abefdf@git.kernel.org>
Git-Commit-ID: c0f7ac3a9edde786bc129d37627953a8b8abefdf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:29:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0f7ac3a9edde786bc129d37627953a8b8abefdf
Gitweb:     http://git.kernel.org/tip/c0f7ac3a9edde786bc129d37627953a8b8abefdf
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:34:46 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:26 +0100

kprobes/x86: Support kprobes jump optimization on x86

Introduce x86 arch-specific optimization code, which supports
both of x86-32 and x86-64.

This code also supports safety checking, which decodes whole of
a function in which probe is inserted, and checks following
conditions before optimization:
 - The optimized instructions which will be replaced by a jump instruction
   don't straddle the function boundary.
 - There is no indirect jump instruction, because it will jumps into
   the address range which is replaced by jump operand.
 - There is no jump/loop instruction which jumps into the address range
   which is replaced by jump operand.
 - Don't optimize kprobes if it is in functions into which fixup code will
   jumps.

This uses text_poke_multibyte() which doesn't support modifying
code on NMI/MCE handler. However, since kprobes itself doesn't
support NMI/MCE code probing, it's not a problem.

Changes in v9:
 - Use *_text_reserved() for checking the probe can be optimized.
 - Verify jump address range is in 2G range when preparing slot.
 - Backup original code when switching optimized buffer, instead of
   preparing buffer, because there can be int3 of other probes in
   preparing phase.
 - Check kprobe is disabled in arch_check_optimized_kprobe().
 - Strictly check indirect jump opcodes (ff /4, ff /5).

Changes in v6:
 - Split stop_machine-based jump patching code.
 - Update comments and coding style.

Changes in v5:
 - Introduce stop_machine-based jump replacing.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133446.6725.78994.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/kprobes.h |   29 +++
 arch/x86/kernel/kprobes.c      |  433 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 441 insertions(+), 22 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cbcbfde..e6f5a98 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -31,6 +31,7 @@ config X86
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
 	select HAVE_KRETPROBES
+	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index eaec8ea..4ffa345 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -33,6 +33,9 @@ struct kprobe;
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
 #define RELATIVEJUMP_OPCODE 0xe9
+#define RELATIVEJUMP_SIZE 5
+#define RELATIVECALL_OPCODE 0xe8
+#define RELATIVE_ADDR_SIZE 4
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
@@ -44,6 +47,17 @@ typedef u8 kprobe_opcode_t;
 
 #define flush_insn_slot(p)	do { } while (0)
 
+/* optinsn template addresses */
+extern kprobe_opcode_t optprobe_template_entry;
+extern kprobe_opcode_t optprobe_template_val;
+extern kprobe_opcode_t optprobe_template_call;
+extern kprobe_opcode_t optprobe_template_end;
+#define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
+#define MAX_OPTINSN_SIZE 				\
+	(((unsigned long)&optprobe_template_end -	\
+	  (unsigned long)&optprobe_template_entry) +	\
+	 MAX_OPTIMIZED_LENGTH + RELATIVEJUMP_SIZE)
+
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
@@ -64,6 +78,21 @@ struct arch_specific_insn {
 	int boostable;
 };
 
+struct arch_optimized_insn {
+	/* copy of the original instructions */
+	kprobe_opcode_t copied_insn[RELATIVE_ADDR_SIZE];
+	/* detour code buffer */
+	kprobe_opcode_t *insn;
+	/* the size of instructions copied to detour code buffer */
+	size_t size;
+};
+
+/* Return true (!0) if optinsn is prepared for optimization. */
+static inline int arch_prepared_optinsn(struct arch_optimized_insn *optinsn)
+{
+	return optinsn->size;
+}
+
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 4ae95be..b43bbae 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/ftrace.h>
 
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
@@ -106,16 +107,22 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
-/* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-static void __kprobes set_jmp_op(void *from, void *to)
+static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
 {
-	struct __arch_jmp_op {
-		char op;
+	struct __arch_relative_insn {
+		u8 op;
 		s32 raddr;
-	} __attribute__((packed)) * jop;
-	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
-	jop->op = RELATIVEJUMP_OPCODE;
+	} __attribute__((packed)) *insn;
+
+	insn = (struct __arch_relative_insn *)from;
+	insn->raddr = (s32)((long)(to) - ((long)(from) + 5));
+	insn->op = op;
+}
+
+/* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
+static void __kprobes synthesize_reljump(void *from, void *to)
+{
+	__synthesize_relative_insn(from, to, RELATIVEJUMP_OPCODE);
 }
 
 /*
@@ -202,7 +209,7 @@ static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
 	/*
 	 *  Basically, kp->ainsn.insn has an original instruction.
 	 *  However, RIP-relative instruction can not do single-stepping
-	 *  at different place, fix_riprel() tweaks the displacement of
+	 *  at different place, __copy_instruction() tweaks the displacement of
 	 *  that instruction. In that case, we can't recover the instruction
 	 *  from the kp->ainsn.insn.
 	 *
@@ -284,21 +291,37 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 }
 
 /*
- * Adjust the displacement if the instruction uses the %rip-relative
- * addressing mode.
+ * Copy an instruction and adjust the displacement if the instruction
+ * uses the %rip-relative addressing mode.
  * If it does, Return the address of the 32-bit displacement word.
  * If not, return null.
  * Only applicable to 64-bit x86.
  */
-static void __kprobes fix_riprel(struct kprobe *p)
+static int __kprobes __copy_instruction(u8 *dest, u8 *src, int recover)
 {
-#ifdef CONFIG_X86_64
 	struct insn insn;
-	kernel_insn_init(&insn, p->ainsn.insn);
+	int ret;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
 
+	kernel_insn_init(&insn, src);
+	if (recover) {
+		insn_get_opcode(&insn);
+		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf,
+							 (unsigned long)src);
+			if (ret)
+				return 0;
+			kernel_insn_init(&insn, buf);
+		}
+	}
+	insn_get_length(&insn);
+	memcpy(dest, insn.kaddr, insn.length);
+
+#ifdef CONFIG_X86_64
 	if (insn_rip_relative(&insn)) {
 		s64 newdisp;
 		u8 *disp;
+		kernel_insn_init(&insn, dest);
 		insn_get_displacement(&insn);
 		/*
 		 * The copied instruction uses the %rip-relative addressing
@@ -312,20 +335,23 @@ static void __kprobes fix_riprel(struct kprobe *p)
 		 * extension of the original signed 32-bit displacement would
 		 * have given.
 		 */
-		newdisp = (u8 *) p->addr + (s64) insn.displacement.value -
-			  (u8 *) p->ainsn.insn;
+		newdisp = (u8 *) src + (s64) insn.displacement.value -
+			  (u8 *) dest;
 		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
-		disp = (u8 *) p->ainsn.insn + insn_offset_displacement(&insn);
+		disp = (u8 *) dest + insn_offset_displacement(&insn);
 		*(s32 *) disp = (s32) newdisp;
 	}
 #endif
+	return insn.length;
 }
 
 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-
-	fix_riprel(p);
+	/*
+	 * Copy an instruction without recovering int3, because it will be
+	 * put by another subsystem.
+	 */
+	__copy_instruction(p->ainsn.insn, p->addr, 0);
 
 	if (can_boost(p->addr))
 		p->ainsn.boostable = 0;
@@ -417,9 +443,20 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
+#ifdef CONFIG_OPTPROBES
+static int  __kprobes setup_detour_execution(struct kprobe *p,
+					     struct pt_regs *regs,
+					     int reenter);
+#else
+#define setup_detour_execution(p, regs, reenter) (0)
+#endif
+
 static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
 				       struct kprobe_ctlblk *kcb, int reenter)
 {
+	if (setup_detour_execution(p, regs, reenter))
+		return;
+
 #if !defined(CONFIG_PREEMPT)
 	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
@@ -815,8 +852,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 			 * These instructions can be executed directly if it
 			 * jumps back to correct address.
 			 */
-			set_jmp_op((void *)regs->ip,
-				   (void *)orig_ip + (regs->ip - copy_ip));
+			synthesize_reljump((void *)regs->ip,
+				(void *)orig_ip + (regs->ip - copy_ip));
 			p->ainsn.boostable = 1;
 		} else {
 			p->ainsn.boostable = -1;
@@ -1043,6 +1080,358 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
+
+#ifdef CONFIG_OPTPROBES
+
+/* Insert a call instruction at address 'from', which calls address 'to'.*/
+static void __kprobes synthesize_relcall(void *from, void *to)
+{
+	__synthesize_relative_insn(from, to, RELATIVECALL_OPCODE);
+}
+
+/* Insert a move instruction which sets a pointer to eax/rdi (1st arg). */
+static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr,
+					  unsigned long val)
+{
+#ifdef CONFIG_X86_64
+	*addr++ = 0x48;
+	*addr++ = 0xbf;
+#else
+	*addr++ = 0xb8;
+#endif
+	*(unsigned long *)addr = val;
+}
+
+void __kprobes kprobes_optinsn_template_holder(void)
+{
+	asm volatile (
+			".global optprobe_template_entry\n"
+			"optprobe_template_entry: \n"
+#ifdef CONFIG_X86_64
+			/* We don't bother saving the ss register */
+			"	pushq %rsp\n"
+			"	pushfq\n"
+			SAVE_REGS_STRING
+			"	movq %rsp, %rsi\n"
+			".global optprobe_template_val\n"
+			"optprobe_template_val: \n"
+			ASM_NOP5
+			ASM_NOP5
+			".global optprobe_template_call\n"
+			"optprobe_template_call: \n"
+			ASM_NOP5
+			/* Move flags to rsp */
+			"	movq 144(%rsp), %rdx\n"
+			"	movq %rdx, 152(%rsp)\n"
+			RESTORE_REGS_STRING
+			/* Skip flags entry */
+			"	addq $8, %rsp\n"
+			"	popfq\n"
+#else /* CONFIG_X86_32 */
+			"	pushf\n"
+			SAVE_REGS_STRING
+			"	movl %esp, %edx\n"
+			".global optprobe_template_val\n"
+			"optprobe_template_val: \n"
+			ASM_NOP5
+			".global optprobe_template_call\n"
+			"optprobe_template_call: \n"
+			ASM_NOP5
+			RESTORE_REGS_STRING
+			"	addl $4, %esp\n"	/* skip cs */
+			"	popf\n"
+#endif
+			".global optprobe_template_end\n"
+			"optprobe_template_end: \n");
+}
+
+#define TMPL_MOVE_IDX \
+	((long)&optprobe_template_val - (long)&optprobe_template_entry)
+#define TMPL_CALL_IDX \
+	((long)&optprobe_template_call - (long)&optprobe_template_entry)
+#define TMPL_END_IDX \
+	((long)&optprobe_template_end - (long)&optprobe_template_entry)
+
+#define INT3_SIZE sizeof(kprobe_opcode_t)
+
+/* Optimized kprobe call back function: called from optinsn */
+static void __kprobes optimized_callback(struct optimized_kprobe *op,
+					 struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	preempt_disable();
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(&op->kp);
+	} else {
+		/* Save skipped registers */
+#ifdef CONFIG_X86_64
+		regs->cs = __KERNEL_CS;
+#else
+		regs->cs = __KERNEL_CS | get_kernel_rpl();
+		regs->gs = 0;
+#endif
+		regs->ip = (unsigned long)op->kp.addr + INT3_SIZE;
+		regs->orig_ax = ~0UL;
+
+		__get_cpu_var(current_kprobe) = &op->kp;
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		opt_pre_handler(&op->kp, regs);
+		__get_cpu_var(current_kprobe) = NULL;
+	}
+	preempt_enable_no_resched();
+}
+
+static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
+{
+	int len = 0, ret;
+
+	while (len < RELATIVEJUMP_SIZE) {
+		ret = __copy_instruction(dest + len, src + len, 1);
+		if (!ret || !can_boost(dest + len))
+			return -EINVAL;
+		len += ret;
+	}
+	/* Check whether the address range is reserved */
+	if (ftrace_text_reserved(src, src + len - 1) ||
+	    alternatives_text_reserved(src, src + len - 1))
+		return -EBUSY;
+
+	return len;
+}
+
+/* Check whether insn is indirect jump */
+static int __kprobes insn_is_indirect_jump(struct insn *insn)
+{
+	return ((insn->opcode.bytes[0] == 0xff &&
+		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
+		insn->opcode.bytes[0] == 0xea);	/* Segment based jump */
+}
+
+/* Check whether insn jumps into specified address range */
+static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
+{
+	unsigned long target = 0;
+
+	switch (insn->opcode.bytes[0]) {
+	case 0xe0:	/* loopne */
+	case 0xe1:	/* loope */
+	case 0xe2:	/* loop */
+	case 0xe3:	/* jcxz */
+	case 0xe9:	/* near relative jump */
+	case 0xeb:	/* short relative jump */
+		break;
+	case 0x0f:
+		if ((insn->opcode.bytes[1] & 0xf0) == 0x80) /* jcc near */
+			break;
+		return 0;
+	default:
+		if ((insn->opcode.bytes[0] & 0xf0) == 0x70) /* jcc short */
+			break;
+		return 0;
+	}
+	target = (unsigned long)insn->next_byte + insn->immediate.value;
+
+	return (start <= target && target <= start + len);
+}
+
+/* Decode whole function to ensure any instructions don't jump into target */
+static int __kprobes can_optimize(unsigned long paddr)
+{
+	int ret;
+	unsigned long addr, size = 0, offset = 0;
+	struct insn insn;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	/* Dummy buffers for lookup_symbol_attrs */
+	static char __dummy_buf[KSYM_NAME_LEN];
+
+	/* Lookup symbol including addr */
+	if (!kallsyms_lookup(paddr, &size, &offset, NULL, __dummy_buf))
+		return 0;
+
+	/* Check there is enough space for a relative jump. */
+	if (size - offset < RELATIVEJUMP_SIZE)
+		return 0;
+
+	/* Decode instructions */
+	addr = paddr - offset;
+	while (addr < paddr - offset + size) { /* Decode until function end */
+		if (search_exception_tables(addr))
+			/*
+			 * Since some fixup code will jumps into this function,
+			 * we can't optimize kprobe in this function.
+			 */
+			return 0;
+		kernel_insn_init(&insn, (void *)addr);
+		insn_get_opcode(&insn);
+		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf, addr);
+			if (ret)
+				return 0;
+			kernel_insn_init(&insn, buf);
+		}
+		insn_get_length(&insn);
+		/* Recover address */
+		insn.kaddr = (void *)addr;
+		insn.next_byte = (void *)(addr + insn.length);
+		/* Check any instructions don't jump into target */
+		if (insn_is_indirect_jump(&insn) ||
+		    insn_jump_into_range(&insn, paddr + INT3_SIZE,
+					 RELATIVE_ADDR_SIZE))
+			return 0;
+		addr += insn.length;
+	}
+
+	return 1;
+}
+
+/* Check optimized_kprobe can actually be optimized. */
+int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
+{
+	int i;
+	struct kprobe *p;
+
+	for (i = 1; i < op->optinsn.size; i++) {
+		p = get_kprobe(op->kp.addr + i);
+		if (p && !kprobe_disabled(p))
+			return -EEXIST;
+	}
+
+	return 0;
+}
+
+/* Check the addr is within the optimized instructions. */
+int __kprobes arch_within_optimized_kprobe(struct optimized_kprobe *op,
+					   unsigned long addr)
+{
+	return ((unsigned long)op->kp.addr <= addr &&
+		(unsigned long)op->kp.addr + op->optinsn.size > addr);
+}
+
+/* Free optimized instruction slot */
+static __kprobes
+void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
+{
+	if (op->optinsn.insn) {
+		free_optinsn_slot(op->optinsn.insn, dirty);
+		op->optinsn.insn = NULL;
+		op->optinsn.size = 0;
+	}
+}
+
+void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+{
+	__arch_remove_optimized_kprobe(op, 1);
+}
+
+/*
+ * Copy replacing target instructions
+ * Target instructions MUST be relocatable (checked inside)
+ */
+int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+{
+	u8 *buf;
+	int ret;
+	long rel;
+
+	if (!can_optimize((unsigned long)op->kp.addr))
+		return -EILSEQ;
+
+	op->optinsn.insn = get_optinsn_slot();
+	if (!op->optinsn.insn)
+		return -ENOMEM;
+
+	/*
+	 * Verify if the address gap is in 2GB range, because this uses
+	 * a relative jump.
+	 */
+	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
+	if (abs(rel) > 0x7fffffff)
+		return -ERANGE;
+
+	buf = (u8 *)op->optinsn.insn;
+
+	/* Copy instructions into the out-of-line buffer */
+	ret = copy_optimized_instructions(buf + TMPL_END_IDX, op->kp.addr);
+	if (ret < 0) {
+		__arch_remove_optimized_kprobe(op, 0);
+		return ret;
+	}
+	op->optinsn.size = ret;
+
+	/* Copy arch-dep-instance from template */
+	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
+
+	/* Set probe information */
+	synthesize_set_arg1(buf + TMPL_MOVE_IDX, (unsigned long)op);
+
+	/* Set probe function call */
+	synthesize_relcall(buf + TMPL_CALL_IDX, optimized_callback);
+
+	/* Set returning jmp instruction at the tail of out-of-line buffer */
+	synthesize_reljump(buf + TMPL_END_IDX + op->optinsn.size,
+			   (u8 *)op->kp.addr + op->optinsn.size);
+
+	flush_icache_range((unsigned long) buf,
+			   (unsigned long) buf + TMPL_END_IDX +
+			   op->optinsn.size + RELATIVEJUMP_SIZE);
+	return 0;
+}
+
+/* Replace a breakpoint (int3) with a relative jump.  */
+int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
+{
+	unsigned char jmp_code[RELATIVEJUMP_SIZE];
+	s32 rel = (s32)((long)op->optinsn.insn -
+			((long)op->kp.addr + RELATIVEJUMP_SIZE));
+
+	/* Backup instructions which will be replaced by jump address */
+	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
+	       RELATIVE_ADDR_SIZE);
+
+	jmp_code[0] = RELATIVEJUMP_OPCODE;
+	*(s32 *)(&jmp_code[1]) = rel;
+
+	/*
+	 * text_poke_smp doesn't support NMI/MCE code modifying.
+	 * However, since kprobes itself also doesn't support NMI/MCE
+	 * code probing, it's not a problem.
+	 */
+	text_poke_smp(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE);
+	return 0;
+}
+
+/* Replace a relative jump with a breakpoint (int3).  */
+void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	u8 buf[RELATIVEJUMP_SIZE];
+
+	/* Set int3 to first byte for kprobes */
+	buf[0] = BREAKPOINT_INSTRUCTION;
+	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
+}
+
+static int  __kprobes setup_detour_execution(struct kprobe *p,
+					     struct pt_regs *regs,
+					     int reenter)
+{
+	struct optimized_kprobe *op;
+
+	if (p->flags & KPROBE_FLAG_OPTIMIZED) {
+		/* This kprobe is really able to run optimized path. */
+		op = container_of(p, struct optimized_kprobe, kp);
+		/* Detour through copied instructions */
+		regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
+		if (!reenter)
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+#endif
+
 int __init arch_init_kprobes(void)
 {
 	return 0;
