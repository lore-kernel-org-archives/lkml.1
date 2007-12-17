Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbXLQQJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbXLQQJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934307AbXLQQIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:08:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934289AbXLQQIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:08:36 -0500
Message-ID: <47669EB9.7000006@redhat.com>
Date: Mon, 17 Dec 2007 11:07:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [-mm][PATCH 3/6] kprobe-booster for x86-64
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kprobe-booster to kprobes_64.c.

- Changes are based on x86-32.
- Add REX prefix checking code.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/kernel/kprobes_64.c |  142 ++++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/kprobes_64.h |   10 +++
 2 files changed, 149 insertions(+), 3 deletions(-)

Index: 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/kernel/kprobes_64.c
+++ 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
@@ -55,6 +55,105 @@ struct kretprobe_blackpoint kretprobe_bl
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);

+/* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
+static __always_inline void set_jmp_op(void *from, void *to)
+{
+	struct __arch_jmp_op {
+		char op;
+		s32 raddr;
+	} __attribute__((packed)) * jop;
+	jop = (struct __arch_jmp_op *)from;
+	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
+	jop->op = RELATIVEJUMP_INSTRUCTION;
+}
+
+/*
+ * returns non-zero if opcode is boostable
+ * RIP relative instructions are adjusted at copying time
+ */
+static __always_inline int can_boost(kprobe_opcode_t *opcodes)
+{
+#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 64))
+	/*
+	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
+	 * Groups, and some special opcodes can not boost.
+	 */
+	static const unsigned long twobyte_is_boostable[256 / 64] = {
+		/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+		/*      ----------------------------------------------        */
+		W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0)|/* 00 */
+		W(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 10 */
+		W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 20 */
+		W(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),/* 30 */
+		W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)|/* 40 */
+		W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 50 */
+		W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1)|/* 60 */
+		W(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1),/* 70 */
+		W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 80 */
+		W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)|/* 90 */
+		W(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1)|/* a0 */
+		W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1),/* b0 */
+		W(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1)|/* c0 */
+		W(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1)|/* d0 */
+		W(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1)|/* e0 */
+		W(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0) /* f0 */
+		/*      -----------------------------------------------       */
+		/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	};
+#undef W
+	kprobe_opcode_t opcode;
+	kprobe_opcode_t *orig_opcodes = opcodes;
+
+retry:
+	if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+		return 0;
+	opcode = *(opcodes++);
+
+	/* 2nd-byte opcode */
+	if (opcode == 0x0f) {
+		if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+			return 0;
+		return test_bit(*opcodes, twobyte_is_boostable);
+	}
+
+	switch (opcode & 0xf0) {
+	case 0x40:
+		goto retry; /* REX prefix is boostable */
+	case 0x60:
+		if (0x63 < opcode && opcode < 0x67)
+			goto retry; /* prefixes */
+		/* can't boost Address-size override and bound */
+		return (opcode != 0x62 && opcode != 0x67);
+	case 0x70:
+		return 0; /* can't boost conditional jump */
+	case 0xc0:
+		/* can't boost software-interruptions */
+		return (0xc1 < opcode && opcode < 0xcc) || opcode == 0xcf;
+	case 0xd0:
+		/* can boost AA* and XLAT */
+		return (opcode == 0xd4 || opcode == 0xd5 || opcode == 0xd7);
+	case 0xe0:
+		/* can boost in/out and absolute jmps */
+		return ((opcode & 0x04) || opcode == 0xea);
+	case 0xf0:
+		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
+			goto retry; /* lock/rep(ne) prefix */
+		/* clear and set flags are boostable */
+		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
+	default:
+		/* segment override prefixes are boostable */
+		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
+			goto retry; /* prefixes */
+		/* CS override prefix and call are not boostable */
+		return (opcode != 0x2e && opcode != 0x9a);
+	}
+}
+
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
@@ -86,7 +185,7 @@ int __kprobes arch_prepare_kprobe(struct

 /*
  * Determine if the instruction uses the %rip-relative addressing mode.
- * If it does, return the address of the 32-bit displacement word.
+ * If it does, Return the address of the 32-bit displacement word.
  * If not, return null.
  */
 static s32 __kprobes *is_riprel(u8 *insn)
@@ -210,6 +309,11 @@ static void __kprobes arch_copy_kprobe(s
 		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
 		*ripdisp = disp;
 	}
+	if (can_boost(p->addr)) {
+		p->ainsn.boostable = 0;
+	} else {
+		p->ainsn.boostable = -1;
+	}
 	p->opcode = *p->addr;
 }

@@ -226,7 +330,7 @@ void __kprobes arch_disarm_kprobe(struct
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
 	mutex_lock(&kprobe_mutex);
-	free_insn_slot(p->ainsn.insn, 0);
+	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
 	mutex_unlock(&kprobe_mutex);
 }

@@ -384,6 +488,15 @@ int __kprobes kprobe_handler(struct pt_r
 		return 1;

 ss_probe:
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+	if (p->ainsn.boostable == 1 && !p->post_handler) {
+		/* Boost up -- we can execute copied instructions directly */
+		reset_current_kprobe();
+		regs->ip = (unsigned long)p->ainsn.insn;
+		preempt_enable_no_resched();
+		return 1;
+	}
+#endif
 	prepare_singlestep(p, regs);
 	kcb->kprobe_status = KPROBE_HIT_SS;
 	return 1;
@@ -493,6 +606,11 @@ int __kprobes trampoline_probe_handler(s
  * 2) If the single-stepped instruction was a call, the return address
  * that is atop the stack is the address following the copied instruction.
  * We need to make it the address following the original instruction.
+ *
+ * If this is the first time we've single-stepped the instruction at
+ * this probepoint, and the instruction is boostable, boost it: add a
+ * jump instruction after the copied instruction, that jumps to the next
+ * instruction after the probepoint.
  */
 static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
@@ -519,6 +637,7 @@ static void __kprobes resume_execution(s
 	case 0xcf:
 	case 0xea:	/* jmp absolute -- ip is correct */
 		/* ip is already adjusted, no more changes required */
+		p->ainsn.boostable = 1;
 		goto no_change;
 	case 0xe8:	/* call relative - Fix return addr */
 		*tos = orig_rip + (*tos - copy_rip);
@@ -527,17 +646,34 @@ static void __kprobes resume_execution(s
 		if ((insn[1] & 0x30) == 0x10) {
 			/* call absolute, indirect */
 			/* Fix return addr; ip is correct. */
+			/* not boostable */
 			*tos = orig_rip + (*tos - copy_rip);
 			goto no_change;
 		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
 			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* ip is correct. */
+			/* ip is correct. And this is boostable */
+			p->ainsn.boostable = 1;
 			goto no_change;
 		}
 	default:
 		break;
 	}

+	if (p->ainsn.boostable == 0) {
+		if ((regs->ip > copy_rip) &&
+		    (regs->ip - copy_rip) + 5 < MAX_INSN_SIZE) {
+			/*
+			 * These instructions can be executed directly if it
+			 * jumps back to correct address.
+			 */
+			set_jmp_op((void *)regs->ip,
+				   (void *)orig_rip + (regs->ip - copy_rip));
+			p->ainsn.boostable = 1;
+		} else {
+			p->ainsn.boostable = -1;
+		}
+	}
+
 	regs->ip = orig_rip + (regs->ip - copy_rip);

 no_change:
Index: 2.6.24-rc4-mm1/include/asm-x86/kprobes_64.h
===================================================================
--- 2.6.24-rc4-mm1.orig/include/asm-x86/kprobes_64.h
+++ 2.6.24-rc4-mm1/include/asm-x86/kprobes_64.h
@@ -34,6 +34,7 @@ struct kprobe;

 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
+#define RELATIVEJUMP_INSTRUCTION 0xe9
 #define MAX_INSN_SIZE 15
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR) (((MAX_STACK_SIZE) < \
@@ -52,6 +53,15 @@ extern void arch_remove_kprobe(struct kp
 struct arch_specific_insn {
 	/* copy of the original instruction */
 	kprobe_opcode_t *insn;
+	/*
+	 * boostable = -1: This instruction type is not boostable.
+	 * boostable = 0: This instruction type is boostable.
+	 * boostable = 1: This instruction has been boosted: we have
+	 * added a relative jump after the instruction copy in insn,
+	 * so no single-step and fixup are needed (unless there's
+	 * a post_handler or break_handler).
+	 */
+	int boostable;
 };

 struct prev_kprobe {

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


