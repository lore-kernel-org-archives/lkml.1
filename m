Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbZDFVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbZDFVno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbZDFVnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:43:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45858 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759595AbZDFVnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:43:20 -0400
Message-ID: <49DA778E.7060603@redhat.com>
Date: Mon, 06 Apr 2009 17:43:42 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>
Subject: [RFC][PROTO][PATCH -tip 6/7] kprobes: x86: support kprobes jump optimization
 on x86
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce x86 arch-specific optimization code, which supports both of
x86-32 and x86-64.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 arch/x86/Kconfig               |    1
 arch/x86/include/asm/kprobes.h |   25 +++-
 arch/x86/kernel/kprobes.c      |  280 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 290 insertions(+), 16 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eebd3ad..feca11f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -29,6 +29,7 @@ config X86
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_KRETPROBES
+	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 4fe681d..492458a 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -32,7 +32,10 @@ struct kprobe;

 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
-#define RELATIVEJUMP_INSTRUCTION 0xe9
+#define RELATIVEJUMP_OPCODE 0xe9
+#define RELATIVECALL_OPCODE 0xe8
+#define RELATIVE_ADDR_SIZE 4
+#define RELATIVE_JUMP_SIZE (sizeof(kprobe_opcode_t) + RELATIVE_ADDR_SIZE)
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
+	 MAX_OPTIMIZED_LENGTH + RELATIVE_JUMP_SIZE)
+
 extern const int kretprobe_blacklist_size;

 void arch_remove_kprobe(struct kprobe *p);
@@ -64,6 +78,15 @@ struct arch_specific_insn {
 	int boostable;
 };

+struct arch_optimized_insn {
+	/* copy of the original instructions */
+	kprobe_opcode_t copied_insn[RELATIVE_ADDR_SIZE];
+	/* detour code buffer */
+	kprobe_opcode_t *insn;
+	/* length of copied instructions */
+	int length;
+};
+
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index fcce435..5635e02 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -161,16 +161,36 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);

-/* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-static void __kprobes set_jmp_op(void *from, void *to)
+/*
+ * On pentium series, Unsynchronized cross-modifying code
+ * operations can cause unexpected instruction execution results.
+ * So after code modified, we should synchronize it on each processor.
+ */
+static void __local_serialize_cpu(void *info)
 {
-	struct __arch_jmp_op {
-		char op;
+	sync_core();
+}
+
+void arch_serialize_cpus(void)
+{
+	on_each_cpu(__local_serialize_cpu, NULL, 1);
+}
+
+static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
+{
+	struct __arch_relative_insn {
+		u8 op;
 		s32 raddr;
-	} __attribute__((packed)) * jop;
-	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
-	jop->op = RELATIVEJUMP_INSTRUCTION;
+	} __attribute__((packed)) *insn;
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
@@ -326,10 +346,10 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
  * If not, return null.
  * Only applicable to 64-bit x86.
  */
-static void __kprobes fix_riprel(struct kprobe *p)
+static void __kprobes fix_riprel(unsigned long ssol, unsigned long orig)
 {
 #ifdef CONFIG_X86_64
-	u8 *insn = p->ainsn.insn;
+	u8 *insn = (u8 *)ssol;
 	s64 disp;
 	int need_modrm;

@@ -386,8 +406,8 @@ static void __kprobes fix_riprel(struct kprobe *p)
 			 * sign-extension of the original signed 32-bit
 			 * displacement would have given.
 			 */
-			disp = (u8 *) p->addr + *((s32 *) insn) -
-			       (u8 *) p->ainsn.insn;
+			disp = (u8 *) orig + *((s32 *) insn) -
+			       (u8 *) ssol;
 			BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
 			*(s32 *)insn = (s32) disp;
 		}
@@ -399,7 +419,7 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
 	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));

-	fix_riprel(p);
+	fix_riprel((unsigned long)p->ainsn.insn, (unsigned long)p->addr);

 	if (can_boost(p->addr))
 		p->ainsn.boostable = 0;
@@ -895,8 +915,8 @@ static void __kprobes resume_execution(struct kprobe *p,
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
@@ -1117,6 +1137,236 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
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
+			RESTORE_REGS_STRING
+			"	popfq\n"
+			/* Skip rsp */
+			"	addq $8, %rsp\n"
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
+/* optimized kprobe call back function: called from optinsn */
+static void optimized_callback(struct optimized_kprobe *op,
+				struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	preempt_disable();
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(&op->kp);
+	} else {
+		/* save skipped registers */
+#ifdef CONFIG_X86_64
+		regs->cs = __KERNEL_CS;
+#else
+		regs->cs = __KERNEL_CS | get_kernel_rpl();
+		regs->gs = 0;
+#endif
+		regs->ip = (unsigned long)op->kp.addr;
+		regs->orig_ax = ~0UL;
+
+		__get_cpu_var(current_kprobe) = &op->kp;
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		aggr_pre_handler(&op->kp, regs);
+		__get_cpu_var(current_kprobe) = NULL;
+	}
+	preempt_enable_no_resched();
+}
+
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
+static int __kprobes prepare_copied_insn(u8 *buf, struct optimized_kprobe *op)
+{
+	struct insn insn;
+	int len = 0;
+	while (len < RELATIVE_JUMP_SIZE) {
+		if (!can_boost(buf + len))
+			return -EINVAL;
+		fix_riprel((unsigned long)buf + len,
+			   (unsigned long)op->kp.addr);
+		insn_init(&insn, buf + len, 0);
+		insn_get_length(&insn);
+		len += insn.length;
+	}
+	return len;
+}
+
+int arch_optimized_kprobe_address(struct optimized_kprobe *op,
+				  unsigned long addr)
+{
+	return ((addr > (unsigned long)op->kp.addr) &&
+		(addr < (unsigned long)op->kp.addr + op->optinsn.length));
+}
+
+/*
+ * Copy post processing instructions
+ * Target instructions MUST be relocatable.
+ */
+int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+{
+	u8 *buf;
+	int ret, i;
+
+	op->optinsn.insn = get_optinsn_slot();
+	if (!op->optinsn.insn)
+		return -ENOMEM;
+
+	buf = (u8 *)op->optinsn.insn;
+
+	/* copy arch-dep-instance from template */
+	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
+
+	/* set probe information */
+	synthesize_set_arg1(buf + TMPL_MOVE_IDX, (unsigned long)op);
+
+	/* set probe function call */
+	synthesize_relcall(buf + TMPL_CALL_IDX, optimized_callback);
+
+	/* copy instructions into the out-of-line buffer */
+	memcpy(buf + TMPL_END_IDX, op->kp.addr, MAX_OPTIMIZED_LENGTH);
+
+	/* overwrite int3 */
+	memcpy(buf + TMPL_END_IDX, &op->kp.opcode, INT3_SIZE);
+
+	/* backup instructions which will be replaced by jump address */
+	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
+	       RELATIVE_ADDR_SIZE);
+
+	ret = prepare_copied_insn(buf + TMPL_END_IDX, op);
+	if (ret < 0)
+		goto error;
+
+	op->optinsn.length = ret;
+	/* check whether there is another kprobes */
+	for (i = 1; i < op->optinsn.length; i++)
+		if (get_kprobe(op->kp.addr + i)) {
+			ret = -EEXIST;
+			goto error;
+		}
+
+	/* set returning jmp instruction at the tail of out-of-line buffer */
+	synthesize_reljump(buf + TMPL_END_IDX + op->optinsn.length,
+			   (u8 *)op->kp.addr + op->optinsn.length);
+
+	flush_icache_range((unsigned long) buf,
+			   (unsigned long) buf + TMPL_END_IDX +
+			   op->optinsn.length + RELATIVE_JUMP_SIZE);
+	return 0;
+error:
+	free_optinsn_slot(op->optinsn.insn, 0);
+	return ret;
+}
+
+void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+{
+	if (op->optinsn.insn)
+		free_optinsn_slot(op->optinsn.insn, 0);
+}
+
+int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
+{
+	kprobe_opcode_t opcode = RELATIVEJUMP_OPCODE;
+	long rel = (long)(op->optinsn.insn) -
+		   ((long)(op->kp.addr) + RELATIVE_JUMP_SIZE);
+	/* TODO: check safety */
+
+	/* insert the destination address only */
+	text_poke((void *)((char *)op->kp.addr + INT3_SIZE), &rel,
+		   RELATIVE_ADDR_SIZE);
+	arch_serialize_cpus();
+
+	/* overwrite breakpoint to reljump */
+	text_poke(op->kp.addr, &opcode, sizeof(kprobe_opcode_t));
+	arch_serialize_cpus();
+	return 0;
+}
+
+void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	/* change (the 1st byte of) jump to int3. */
+	arch_arm_kprobe(&op->kp);
+	arch_serialize_cpus();
+	/*
+	 * recover the instructions covered by the destination address.
+	 * the int3 will be removed by arch_disarm_kprobe()
+	 */
+	text_poke((void *)((long)op->kp.addr + INT3_SIZE),
+		  (void *)op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+}
+
+/* djprobe handler : switch to a bypass code */
+int __kprobes arch_detour_optimized_kprobe(struct optimized_kprobe *op,
+					   struct pt_regs *regs)
+{
+	regs->ip = (unsigned long)op->optinsn.insn;
+	reset_current_kprobe();
+	preempt_enable_no_resched();
+	return 1;		/* already prepared */
+}
+#endif
+
 int __init arch_init_kprobes(void)
 {
 	return 0;
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

