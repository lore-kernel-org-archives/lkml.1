Return-Path: <linux-kernel-owner+w=401wt.eu-S935700AbXLQQO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935700AbXLQQO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934089AbXLQQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:14:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935345AbXLQQOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:14:36 -0500
Message-ID: <47669ED0.2040900@redhat.com>
Date: Mon, 17 Dec 2007 11:07:44 -0500
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
Subject: [-mm][PATCH 5/6] prepare kprobes code for x86 unification
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanup kprobes code on x86 for unification.
This patch is based on Arjan's previous work.

- Remove spurious whitespace changes
- Add harmless includes
- Make the 32/64 files more identical
 - Generalize structure fields' and local variable name.
 - Wrap accessing to stack address by macros.
 - Modify bitmap making macro.
 - Merge fixup code into is_riprel() and change its name to fix_riprel().
 - Set MAX_INSN_SIZE to 16 on both arch.
 - Use u32 for bitmaps on both architectures.
 - Clarify some comments.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/kernel/kprobes_32.c |  321 ++++++++++++++++++++-------------
 arch/x86/kernel/kprobes_64.c |  409 ++++++++++++++++++++++---------------------
 arch/x86/mm/fault_32.c       |    1
 arch/x86/mm/fault_64.c       |    1
 include/asm-x86/kprobes_32.h |   32 ++-
 include/asm-x86/kprobes_64.h |   30 +--
 6 files changed, 447 insertions(+), 347 deletions(-)

Index: 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_32.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/kernel/kprobes_32.c
+++ 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_32.c
@@ -29,10 +29,15 @@

 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/preempt.h>
+#include <linux/module.h>
 #include <linux/kdebug.h>
+
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
+#include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>

@@ -41,65 +46,121 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+/*
+ * "&regs->sp" looks wrong, but it's correct for x86_32.  x86_32 CPUs
+ * don't save the ss and esp registers if the CPU is already in kernel
+ * mode when it traps.  So for kprobes, regs->sp and regs->ss are not
+ * the [nonexistent] saved stack pointer and ss register, but rather
+ * the top 8 bytes of the pre-int3 stack.  So &regs->sp happens to
+ * point to the top of the pre-int3 stack.
+ */
+#define stack_addr(regs) ((unsigned long *)&regs->sp)
+
+#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+	/*
+	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
+	 * Groups, and some special opcodes can not boost.
+	 */
+static const u32 twobyte_is_boostable[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      ----------------------------------------------          */
+	W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 00 */
+	W(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 20 */
+	W(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 30 */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 50 */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) | /* 60 */
+	W(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) , /* 70 */
+	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* c0 */
+	W(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) , /* d0 */
+	W(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) | /* e0 */
+	W(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0)   /* f0 */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+static const u32 onebyte_has_modrm[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 20 */
+	W(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 30 */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 50 */
+	W(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) | /* 60 */
+	W(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 70 */
+	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
+	W(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 90 */
+	W(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* a0 */
+	W(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* b0 */
+	W(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* c0 */
+	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* e0 */
+	W(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1)   /* f0 */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+static const u32 twobyte_has_modrm[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) | /* 0f */
+	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) , /* 1f */
+	W(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 2f */
+	W(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 3f */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 4f */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 5f */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 6f */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) , /* 7f */
+	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 8f */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 9f */
+	W(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) | /* af */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) , /* bf */
+	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* cf */
+	W(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* df */
+	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* ef */
+	W(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* ff */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+#undef W
+
 struct kretprobe_blackpoint kretprobe_blacklist[] = {
 	{"__switch_to", }, /* This function switches only current task, but
-			     doesn't switch kernel stack.*/
+			      doesn't switch kernel stack.*/
 	{NULL, NULL}	/* Terminator */
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);

-/* insert a jmp code */
+/* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
 static __always_inline void set_jmp_op(void *from, void *to)
 {
 	struct __arch_jmp_op {
 		char op;
-		long raddr;
-	} __attribute__((packed)) *jop;
+		s32 raddr;
+	} __attribute__((packed)) * jop;
 	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (long)(to) - ((long)(from) + 5);
+	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
 	jop->op = RELATIVEJUMP_INSTRUCTION;
 }

 /*
- * returns non-zero if opcodes can be boosted.
+ * returns non-zero if opcode is boostable.
  */
 static __always_inline int can_boost(kprobe_opcode_t *opcodes)
 {
-#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 32))
-	/*
-	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
-	 * Groups, and some special opcodes can not be boost.
-	 */
-	static const unsigned long twobyte_is_boostable[256 / 32] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 0,0,1,1,0,0,1,0,1,1,0,0,0,0,0,0)| /* 00 */
-		W(0x10, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 10 */
-		W(0x20, 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0)| /* 20 */
-		W(0x30, 0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 30 */
-		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 40 */
-		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 50 */
-		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1)| /* 60 */
-		W(0x70, 0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1), /* 70 */
-		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 80 */
-		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1), /* 90 */
-		W(0xa0, 1,1,0,1,1,1,0,0,1,1,0,1,1,1,0,1)| /* a0 */
-		W(0xb0, 1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1), /* b0 */
-		W(0xc0, 1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1)| /* c0 */
-		W(0xd0, 0,1,1,1,0,1,0,0,1,1,0,1,1,1,0,1), /* d0 */
-		W(0xe0, 0,1,1,0,0,1,0,0,1,1,0,1,1,1,0,1)| /* e0 */
-		W(0xf0, 0,1,1,1,0,1,0,0,1,1,1,0,1,1,1,0)  /* f0 */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-#undef W
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
+
 retry:
 	if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
 		return 0;
@@ -109,7 +170,8 @@ retry:
 	if (opcode == 0x0f) {
 		if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
 			return 0;
-		return test_bit(*opcodes, twobyte_is_boostable);
+		return test_bit(*opcodes,
+				(unsigned long *)twobyte_is_boostable);
 	}

 	switch (opcode & 0xf0) {
@@ -132,12 +194,13 @@ retry:
 	case 0xf0:
 		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
 			goto retry; /* lock/rep(ne) prefix */
-		/* clear and set flags can be boost */
+		/* clear and set flags are boostable */
 		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
 	default:
+		/* segment override prefixes are boostable */
 		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
 			goto retry; /* prefixes */
-		/* can't boost CS override and call */
+		/* CS override prefix and call are not boostable */
 		return (opcode != 0x2e && opcode != 0x9a);
 	}
 }
@@ -145,9 +208,9 @@ retry:
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
-static int __kprobes is_IF_modifier(kprobe_opcode_t opcode)
+static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 {
-	switch (opcode) {
+	switch (*insn) {
 	case 0xfa:		/* cli */
 	case 0xfb:		/* sti */
 	case 0xcf:		/* iret/iretd */
@@ -157,20 +220,24 @@ static int __kprobes is_IF_modifier(kpro
 	return 0;
 }

+static void __kprobes arch_copy_kprobe(struct kprobe *p)
+{
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	if (can_boost(p->addr))
+		p->ainsn.boostable = 0;
+	else
+		p->ainsn.boostable = -1;
+
+	p->opcode = *p->addr;
+}
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
-	/* insn: must be on special executable page on i386. */
+	/* insn: must be on special executable page on x86. */
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)
 		return -ENOMEM;
-
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
-	if (can_boost(p->addr)) {
-		p->ainsn.boostable = 0;
-	} else {
-		p->ainsn.boostable = -1;
-	}
+	arch_copy_kprobe(p);
 	return 0;
 }

@@ -195,26 +262,26 @@ static void __kprobes save_previous_kpro
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_eflags = kcb->kprobe_old_eflags;
-	kcb->prev_kprobe.saved_eflags = kcb->kprobe_saved_eflags;
+	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
+	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }

 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
 	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_eflags = kcb->prev_kprobe.old_eflags;
-	kcb->kprobe_saved_eflags = kcb->prev_kprobe.saved_eflags;
+	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
+	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }

 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_eflags = kcb->kprobe_old_eflags
+	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (TF_MASK | IF_MASK));
-	if (is_IF_modifier(p->opcode))
-		kcb->kprobe_saved_eflags &= ~IF_MASK;
+	if (is_IF_modifier(p->ainsn.insn))
+		kcb->kprobe_saved_flags &= ~IF_MASK;
 }

 static __always_inline void clear_btf(void)
@@ -245,7 +312,7 @@ static void __kprobes prepare_singlestep
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	unsigned long *sara = (unsigned long *)&regs->sp;
+	unsigned long *sara = stack_addr(regs);

 	ri->ret_addr = (kprobe_opcode_t *) *sara;

@@ -280,7 +347,7 @@ static int __kprobes kprobe_handler(stru
 			if (kcb->kprobe_status == KPROBE_HIT_SS &&
 				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
 				regs->flags &= ~TF_MASK;
-				regs->flags |= kcb->kprobe_saved_eflags;
+				regs->flags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
 			}
 			/* We have reentered the kprobe_handler(), since
@@ -301,7 +368,7 @@ static int __kprobes kprobe_handler(stru
 			 * another cpu right after we hit, no further
 			 * handling of this interrupt is appropriate
 			 */
-				regs->ip -= sizeof(kprobe_opcode_t);
+				regs->ip = (unsigned long)addr;
 				ret = 1;
 				goto no_kprobe;
 			}
@@ -325,7 +392,7 @@ static int __kprobes kprobe_handler(stru
 			 * Back up over the (now missing) int3 and run
 			 * the original instruction.
 			 */
-			regs->ip -= sizeof(kprobe_opcode_t);
+			regs->ip = (unsigned long)addr;
 			ret = 1;
 		}
 		/* Not one of ours: let kernel handle it */
@@ -341,7 +408,7 @@ static int __kprobes kprobe_handler(stru

 ss_probe:
 #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
-	if (p->ainsn.boostable == 1 && !p->post_handler){
+	if (p->ainsn.boostable == 1 && !p->post_handler) {
 		/* Boost up -- we can execute copied instructions directly */
 		reset_current_kprobe();
 		regs->ip = (unsigned long)p->ainsn.insn;
@@ -359,16 +426,18 @@ no_kprobe:
 }

 /*
- * For function-return probes, init_kprobes() establishes a probepoint
- * here. When a retprobed function returns, this probe is hit and
- * trampoline_probe_handler() runs, calling the kretprobe's handler.
+ * When a retprobed function returns, this code saves registers and
+ * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
  void __kprobes kretprobe_trampoline_holder(void)
  {
 	asm volatile ( ".global kretprobe_trampoline\n"
 			"kretprobe_trampoline: \n"
 			"	pushf\n"
-			/* skip cs, ip, orig_ax */
+			/*
+			 * Skip cs, ip, orig_ax.
+			 * trampoline_handler() will plug in these values
+			 */
 			"	subl $12, %esp\n"
 			"	pushl %fs\n"
 			"	pushl %ds\n"
@@ -382,10 +451,10 @@ no_kprobe:
 			"	pushl %ebx\n"
 			"	movl %esp, %eax\n"
 			"	call trampoline_handler\n"
-			/* move flags to cs */
+			/* Move flags to cs */
 			"	movl 52(%esp), %edx\n"
 			"	movl %edx, 48(%esp)\n"
-			/* save true return address on flags */
+			/* Replace saved flags with true return address. */
 			"	movl %eax, 52(%esp)\n"
 			"	popl %ebx\n"
 			"	popl %ecx\n"
@@ -394,16 +463,16 @@ no_kprobe:
 			"	popl %edi\n"
 			"	popl %ebp\n"
 			"	popl %eax\n"
-			/* skip ip, orig_ax, es, ds, fs */
+			/* Skip ip, orig_ax, es, ds, fs */
 			"	addl $20, %esp\n"
 			"	popf\n"
 			"	ret\n");
-}
+ }

 /*
  * Called from kretprobe_trampoline
  */
-fastcall void *__kprobes trampoline_handler(struct pt_regs *regs)
+fastcall void * __kprobes trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -417,27 +486,27 @@ fastcall void *__kprobes trampoline_hand
 	/* fixup registers */
 	regs->cs = __KERNEL_CS | get_kernel_rpl();
 	regs->ip = trampoline_address;
-	regs->orig_ax = 0xffffffff;
+	regs->orig_ax = ~0UL;

 	/*
 	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
+	 * task either because multiple functions in the call path have
+	 * return probes installed on them, and/or more then one
 	 * return probe was registered for a target function.
 	 *
 	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
+	 *     - instances are always pushed into the head of the list
 	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
+	 *	 function, the (chronologically) first instance's ret_addr
+	 *	 will be the real return address, and all the rest will
+	 *	 point to kretprobe_trampoline.
 	 */
 	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;

-		if (ri->rp && ri->rp->handler){
+		if (ri->rp && ri->rp->handler) {
 			__get_cpu_var(current_kprobe) = &ri->rp->kp;
 			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
 			ri->rp->handler(ri, regs);
@@ -457,13 +526,14 @@ fastcall void *__kprobes trampoline_hand
 	}

 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
 	spin_unlock_irqrestore(&kretprobe_lock, flags);

 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
-	return (void*)orig_ret_address;
+	return (void *)orig_ret_address;
 }

 /*
@@ -488,48 +558,55 @@ fastcall void *__kprobes trampoline_hand
  * that is atop the stack is the address following the copied instruction.
  * We need to make it the address following the original instruction.
  *
- * This function also checks instruction size for preparing direct execution.
+ * If this is the first time we've single-stepped the instruction at
+ * this probepoint, and the instruction is boostable, boost it: add a
+ * jump instruction after the copied instruction, that jumps to the next
+ * instruction after the probepoint.
  */
 static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
-	unsigned long *tos = (unsigned long *)&regs->sp;
-	unsigned long copy_eip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_eip = (unsigned long)p->addr;
+	unsigned long *tos = stack_addr(regs);
+	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
+	unsigned long orig_ip = (unsigned long)p->addr;
+	kprobe_opcode_t *insn = p->ainsn.insn;

 	regs->flags &= ~TF_MASK;
-	switch (p->ainsn.insn[0]) {
-	case 0x9c:		/* pushfl */
+	switch (*insn) {
+	case 0x9c:	/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_eflags;
+		*tos |= kcb->kprobe_old_flags;
 		break;
-	case 0xc2:		/* iret/ret/lret */
+	case 0xc2:	/* iret/ret/lret */
 	case 0xc3:
 	case 0xca:
 	case 0xcb:
 	case 0xcf:
-	case 0xea:		/* jmp absolute -- ip is correct */
+	case 0xea:	/* jmp absolute -- ip is correct */
 		/* ip is already adjusted, no more changes required */
 		p->ainsn.boostable = 1;
 		goto no_change;
-	case 0xe8:		/* call relative - Fix return addr */
-		*tos = orig_eip + (*tos - copy_eip);
+	case 0xe8:	/* call relative - Fix return addr */
+		*tos = orig_ip + (*tos - copy_ip);
 		break;
-	case 0x9a:		/* call absolute -- same as call absolute, indirect */
-		*tos = orig_eip + (*tos - copy_eip);
+	case 0x9a:	/* call absolute -- same as call absolute, indirect */
+		*tos = orig_ip + (*tos - copy_ip);
 		goto no_change;
 	case 0xff:
-		if ((p->ainsn.insn[1] & 0x30) == 0x10) {
+		if ((insn[1] & 0x30) == 0x10) {
 			/*
 			 * call absolute, indirect
 			 * Fix return addr; ip is correct.
 			 * But this is not boostable
 			 */
-			*tos = orig_eip + (*tos - copy_eip);
+			*tos = orig_ip + (*tos - copy_ip);
 			goto no_change;
-		} else if (((p->ainsn.insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((p->ainsn.insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* ip is correct. And this is boostable */
+		} else if (((insn[1] & 0x31) == 0x20) ||
+			   ((insn[1] & 0x31) == 0x21)) {
+			/*
+			 * jmp near and far, absolute indirect
+			 * ip is correct. And this is boostable
+			 */
 			p->ainsn.boostable = 1;
 			goto no_change;
 		}
@@ -538,21 +615,21 @@ static void __kprobes resume_execution(s
 	}

 	if (p->ainsn.boostable == 0) {
-		if ((regs->ip > copy_eip) &&
-		    (regs->ip - copy_eip) + 5 < MAX_INSN_SIZE) {
+		if ((regs->ip > copy_ip) &&
+		    (regs->ip - copy_ip) + 5 < MAX_INSN_SIZE) {
 			/*
 			 * These instructions can be executed directly if it
 			 * jumps back to correct address.
 			 */
 			set_jmp_op((void *)regs->ip,
-				   (void *)orig_eip + (regs->ip - copy_eip));
+				   (void *)orig_ip + (regs->ip - copy_ip));
 			p->ainsn.boostable = 1;
 		} else {
 			p->ainsn.boostable = -1;
 		}
 	}

-	regs->ip = orig_eip + (regs->ip - copy_eip);
+	regs->ip += orig_ip - copy_ip;

 no_change:
 	restore_btf();
@@ -578,10 +655,10 @@ static int __kprobes post_kprobe_handler
 	}

 	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_eflags;
+	regs->flags |= kcb->kprobe_saved_flags;
 	trace_hardirqs_fixup_flags(regs->flags);

-	/*Restore back the original saved kprobes variables and continue. */
+	/* Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
 		restore_previous_kprobe(kcb);
 		goto out;
@@ -617,7 +694,7 @@ int __kprobes kprobe_fault_handler(struc
 		 * normal page fault.
 		 */
 		regs->ip = (unsigned long)cur->addr;
-		regs->flags |= kcb->kprobe_old_eflags;
+		regs->flags |= kcb->kprobe_old_flags;
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
 		else
@@ -628,7 +705,7 @@ int __kprobes kprobe_fault_handler(struc
 	case KPROBE_HIT_SSDONE:
 		/*
 		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
+		 * we can also use npre/npostfault count for accounting
 		 * these specific fault cases.
 		 */
 		kprobes_inc_nmissed_count(cur);
@@ -651,7 +728,7 @@ int __kprobes kprobe_fault_handler(struc
 			return 1;

 		/*
-		 * fixup_exception() could not handle it,
+		 * fixup routine could not handle it,
 		 * Let do_page_fault() fix it.
 		 */
 		break;
@@ -662,7 +739,7 @@ int __kprobes kprobe_fault_handler(struc
 }

 /*
- * Wrapper routine to for handling exceptions.
+ * Wrapper routine for handling exceptions.
  */
 int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
@@ -703,11 +780,11 @@ int __kprobes setjmp_pre_handler(struct
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();

 	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_esp = &regs->sp;
-	addr = (unsigned long)(kcb->jprobe_saved_esp);
+	kcb->jprobe_saved_sp = stack_addr(regs);
+	addr = (unsigned long)(kcb->jprobe_saved_sp);

 	/*
-	 * TBD: As Linus pointed out, gcc assumes that the callee
+	 * As Linus pointed out, gcc assumes that the callee
 	 * owns the argument space and could overwrite it, e.g.
 	 * tailcall optimization. So, to be absolutely safe
 	 * we also save and restore enough stack bytes to cover
@@ -730,21 +807,20 @@ void __kprobes jprobe_return(void)
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_esp):"memory");
+		      (kcb->jprobe_saved_sp):"memory");
 }

 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->ip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_esp);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);

 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if (&regs->sp != kcb->jprobe_saved_esp) {
+		if (stack_addr(regs) != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk("current sp %p does not match saved sp %p\n",
-			       &regs->sp, kcb->jprobe_saved_esp);
+			       stack_addr(regs), kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
@@ -752,20 +828,21 @@ int __kprobes longjmp_break_handler(stru
 			BUG();
 		}
 		*regs = kcb->jprobe_saved_regs;
-		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
-		       MIN_STACK_SIZE(stack_addr));
+		memcpy((kprobe_opcode_t *)(kcb->jprobe_saved_sp),
+		       kcb->jprobes_stack,
+		       MIN_STACK_SIZE(kcb->jprobe_saved_sp));
 		preempt_enable_no_resched();
 		return 1;
 	}
 	return 0;
 }

-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+int __init arch_init_kprobes(void)
 {
 	return 0;
 }

-int __init arch_init_kprobes(void)
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
 }
Index: 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/kernel/kprobes_64.c
+++ 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
@@ -40,16 +40,97 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>

+#include <asm/cacheflush.h>
+#include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>

 void jprobe_return_end(void);
-static void __kprobes arch_copy_kprobe(struct kprobe *p);

 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);

+#define stack_addr(regs) ((unsigned long *)regs->sp)
+
+#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+	/*
+	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
+	 * Groups, and some special opcodes can not boost.
+	 */
+static const u32 twobyte_is_boostable[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      ----------------------------------------------          */
+	W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 00 */
+	W(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 20 */
+	W(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 30 */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 50 */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) | /* 60 */
+	W(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) , /* 70 */
+	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* c0 */
+	W(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) , /* d0 */
+	W(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) | /* e0 */
+	W(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0)   /* f0 */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+static const u32 onebyte_has_modrm[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 20 */
+	W(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) , /* 30 */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 50 */
+	W(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) | /* 60 */
+	W(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 70 */
+	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
+	W(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 90 */
+	W(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* a0 */
+	W(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* b0 */
+	W(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* c0 */
+	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* e0 */
+	W(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1)   /* f0 */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+static const u32 twobyte_has_modrm[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      -----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) | /* 0f */
+	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) , /* 1f */
+	W(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 2f */
+	W(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 3f */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 4f */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 5f */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 6f */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) , /* 7f */
+	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 8f */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 9f */
+	W(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) | /* af */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) , /* bf */
+	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) | /* cf */
+	W(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* df */
+	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* ef */
+	W(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* ff */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+#undef W
+
 struct kretprobe_blackpoint kretprobe_blacklist[] = {
 	{"__switch_to", }, /* This function switches only current task, but
 			      doesn't switch kernel stack.*/
@@ -70,44 +151,11 @@ static __always_inline void set_jmp_op(v
 }

 /*
- * returns non-zero if opcode is boostable
+ * returns non-zero if opcode is boostable.
  * RIP relative instructions are adjusted at copying time
  */
 static __always_inline int can_boost(kprobe_opcode_t *opcodes)
 {
-#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 64))
-	/*
-	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
-	 * Groups, and some special opcodes can not boost.
-	 */
-	static const unsigned long twobyte_is_boostable[256 / 64] = {
-		/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-		/*      ----------------------------------------------        */
-		W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0)|/* 00 */
-		W(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 10 */
-		W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 20 */
-		W(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),/* 30 */
-		W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)|/* 40 */
-		W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 50 */
-		W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1)|/* 60 */
-		W(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1),/* 70 */
-		W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)|/* 80 */
-		W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)|/* 90 */
-		W(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1)|/* a0 */
-		W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1),/* b0 */
-		W(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1)|/* c0 */
-		W(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1)|/* d0 */
-		W(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1)|/* e0 */
-		W(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0) /* f0 */
-		/*      -----------------------------------------------       */
-		/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-	};
-#undef W
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;

@@ -120,7 +168,8 @@ retry:
 	if (opcode == 0x0f) {
 		if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
 			return 0;
-		return test_bit(*opcodes, twobyte_is_boostable);
+		return test_bit(*opcodes,
+				(unsigned long *)twobyte_is_boostable);
 	}

 	switch (opcode & 0xf0) {
@@ -169,80 +218,25 @@ static int __kprobes is_IF_modifier(kpro
 		return 1;
 	}

-	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
-		return 1;
-	return 0;
-}
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	/* insn: must be on special executable page on x86_64. */
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn) {
-		return -ENOMEM;
-	}
-	arch_copy_kprobe(p);
+	/*
+	 * on 64 bit x86, 0x40-0x4f are prefixes so we need to look
+	 * at the next byte instead.. but of course not recurse infinitely
+	 */
+	if (*insn  >= 0x40 && *insn <= 0x4f)
+		return is_IF_modifier(++insn);
 	return 0;
 }

 /*
- * Determine if the instruction uses the %rip-relative addressing mode.
+ * Adjust the displacement if the instruction uses the %rip-relative
+ * addressing mode.
  * If it does, Return the address of the 32-bit displacement word.
  * If not, return null.
  */
-static s32 __kprobes *is_riprel(u8 *insn)
+static void __kprobes fix_riprel(struct kprobe *p)
 {
-#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 64))
-	static const u64 onebyte_has_modrm[256 / 64] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 00 */
-		W(0x10, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 10 */
-		W(0x20, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 20 */
-		W(0x30, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0), /* 30 */
-		W(0x40, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 40 */
-		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 50 */
-		W(0x60, 0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0)| /* 60 */
-		W(0x70, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 70 */
-		W(0x80, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 80 */
-		W(0x90, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 90 */
-		W(0xa0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* a0 */
-		W(0xb0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* b0 */
-		W(0xc0, 1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0)| /* c0 */
-		W(0xd0, 1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1)| /* d0 */
-		W(0xe0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* e0 */
-		W(0xf0, 0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1)  /* f0 */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-	static const u64 twobyte_has_modrm[256 / 64] = {
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-		/*      -------------------------------         */
-		W(0x00, 1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1)| /* 0f */
-		W(0x10, 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0)| /* 1f */
-		W(0x20, 1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,1)| /* 2f */
-		W(0x30, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 3f */
-		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 4f */
-		W(0x50, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 5f */
-		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 6f */
-		W(0x70, 1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1), /* 7f */
-		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 8f */
-		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 9f */
-		W(0xa0, 0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1)| /* af */
-		W(0xb0, 1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1), /* bf */
-		W(0xc0, 1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0)| /* cf */
-		W(0xd0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* df */
-		W(0xe0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* ef */
-		W(0xf0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0)  /* ff */
-		/*      -------------------------------         */
-		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-#undef	W
+	u8 *insn = p->ainsn.insn;
+	s64 disp;
 	int need_modrm;

 	/* Skip legacy instruction prefixes.  */
@@ -271,54 +265,60 @@ static s32 __kprobes *is_riprel(u8 *insn

 	if (*insn == 0x0f) {	/* Two-byte opcode.  */
 		++insn;
-		need_modrm = test_bit(*insn, twobyte_has_modrm);
-	} else {		/* One-byte opcode.  */
-		need_modrm = test_bit(*insn, onebyte_has_modrm);
-	}
+		need_modrm = test_bit(*insn,
+				      (unsigned long *)twobyte_has_modrm);
+	} else			/* One-byte opcode.  */
+		need_modrm = test_bit(*insn,
+				      (unsigned long *)onebyte_has_modrm);

 	if (need_modrm) {
 		u8 modrm = *++insn;
 		if ((modrm & 0xc7) == 0x05) { /* %rip+disp32 addressing mode */
 			/* Displacement follows ModRM byte.  */
-			return (s32 *) ++insn;
+			++insn;
+			/*
+			 * The copied instruction uses the %rip-relative
+			 * addressing mode.  Adjust the displacement for the
+			 * difference between the original location of this
+			 * instruction and the location of the copy that will
+			 * actually be run.  The tricky bit here is making sure
+			 * that the sign extension happens correctly in this
+			 * calculation, since we need a signed 32-bit result to
+			 * be sign-extended to 64 bits when it's added to the
+			 * %rip value and yield the same 64-bit result that the
+			 * sign-extension of the original signed 32-bit
+			 * displacement would have given.
+			 */
+			disp = (u8 *) p->addr + *((s32 *) insn) -
+			       (u8 *) p->ainsn.insn;
+			BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
+			*(s32 *)insn = (s32) disp;
 		}
 	}
-
-	/* No %rip-relative addressing mode here.  */
-	return NULL;
 }

 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
-	s32 *ripdisp;
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
-	ripdisp = is_riprel(p->ainsn.insn);
-	if (ripdisp) {
-		/*
-		 * The copied instruction uses the %rip-relative
-		 * addressing mode.  Adjust the displacement for the
-		 * difference between the original location of this
-		 * instruction and the location of the copy that will
-		 * actually be run.  The tricky bit here is making sure
-		 * that the sign extension happens correctly in this
-		 * calculation, since we need a signed 32-bit result to
-		 * be sign-extended to 64 bits when it's added to the
-		 * %rip value and yield the same 64-bit result that the
-		 * sign-extension of the original signed 32-bit
-		 * displacement would have given.
-		 */
-		s64 disp = (u8 *) p->addr + *ripdisp - (u8 *) p->ainsn.insn;
-		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
-		*ripdisp = disp;
-	}
-	if (can_boost(p->addr)) {
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	fix_riprel(p);
+	if (can_boost(p->addr))
 		p->ainsn.boostable = 0;
-	} else {
+	else
 		p->ainsn.boostable = -1;
-	}
+
 	p->opcode = *p->addr;
 }

+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* insn: must be on special executable page on x86. */
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn)
+		return -ENOMEM;
+	arch_copy_kprobe(p);
+	return 0;
+}
+
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
 	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
@@ -340,26 +340,26 @@ static void __kprobes save_previous_kpro
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_rflags = kcb->kprobe_old_rflags;
-	kcb->prev_kprobe.saved_rflags = kcb->kprobe_saved_rflags;
+	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
+	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }

 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
 	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_rflags = kcb->prev_kprobe.old_rflags;
-	kcb->kprobe_saved_rflags = kcb->prev_kprobe.saved_rflags;
+	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
+	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }

 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_rflags = kcb->kprobe_old_rflags
+	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (TF_MASK | IF_MASK));
 	if (is_IF_modifier(p->ainsn.insn))
-		kcb->kprobe_saved_rflags &= ~IF_MASK;
+		kcb->kprobe_saved_flags &= ~IF_MASK;
 }

 static __always_inline void clear_btf(void)
@@ -390,20 +390,27 @@ static void __kprobes prepare_singlestep
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	unsigned long *sara = (unsigned long *)regs->sp;
+	unsigned long *sara = stack_addr(regs);

 	ri->ret_addr = (kprobe_opcode_t *) *sara;
+
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }

-int __kprobes kprobe_handler(struct pt_regs *regs)
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate and they
+ * remain disabled thorough out this function.
+ */
+static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *p;
 	int ret = 0;
-	kprobe_opcode_t *addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
+	kprobe_opcode_t *addr;
 	struct kprobe_ctlblk *kcb;

+	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
+
 	/*
 	 * We don't want to be preempted for the entire
 	 * duration of kprobe processing
@@ -418,7 +425,7 @@ int __kprobes kprobe_handler(struct pt_r
 			if (kcb->kprobe_status == KPROBE_HIT_SS &&
 				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
 				regs->flags &= ~TF_MASK;
-				regs->flags |= kcb->kprobe_saved_rflags;
+				regs->flags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
 			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 				/* TODO: Provide re-entrancy from
@@ -429,22 +436,20 @@ int __kprobes kprobe_handler(struct pt_r
 				arch_disarm_kprobe(p);
 				regs->ip = (unsigned long)p->addr;
 				reset_current_kprobe();
-				ret = 1;
-			} else {
-				/* We have reentered the kprobe_handler(), since
-				 * another probe was hit while within the
-				 * handler. We here save the original kprobe
-				 * variables and just single step on instruction
-				 * of the new probe without calling any user
-				 * handlers.
-				 */
-				save_previous_kprobe(kcb);
-				set_current_kprobe(p, regs, kcb);
-				kprobes_inc_nmissed_count(p);
-				prepare_singlestep(p, regs);
-				kcb->kprobe_status = KPROBE_REENTER;
 				return 1;
 			}
+			/* We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kprobes_inc_nmissed_count(p);
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
 		} else {
 			if (*addr != BREAKPOINT_INSTRUCTION) {
 			/* The breakpoint instruction was removed by
@@ -578,23 +583,23 @@ fastcall void * __kprobes trampoline_han
 	INIT_HLIST_HEAD(&empty_rp);
 	spin_lock_irqsave(&kretprobe_lock, flags);
 	head = kretprobe_inst_table_head(current);
-	/* fixup rt_regs */
+	/* fixup registers */
 	regs->cs = __KERNEL_CS;
 	regs->ip = trampoline_address;
-	regs->orig_ax = 0xffffffffffffffff;
+	regs->orig_ax = ~0UL;

 	/*
 	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
+	 * task either because multiple functions in the call path have
+	 * return probes installed on them, and/or more then one
 	 * return probe was registered for a target function.
 	 *
 	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
+	 *     - instances are always pushed into the head of the list
 	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
+	 *	 function, the (chronologically) first instance's ret_addr
+	 *	 will be the real return address, and all the rest will
+	 *	 point to kretprobe_trampoline.
 	 */
 	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
 		if (ri->task != current)
@@ -661,9 +666,9 @@ fastcall void * __kprobes trampoline_han
 static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
-	unsigned long *tos = (unsigned long *)regs->sp;
-	unsigned long copy_rip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_rip = (unsigned long)p->addr;
+	unsigned long *tos = stack_addr(regs);
+	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
+	unsigned long orig_ip = (unsigned long)p->addr;
 	kprobe_opcode_t *insn = p->ainsn.insn;

 	/*skip the REX prefix*/
@@ -674,7 +679,7 @@ static void __kprobes resume_execution(s
 	switch (*insn) {
 	case 0x9c:	/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_rflags;
+		*tos |= kcb->kprobe_old_flags;
 		break;
 	case 0xc2:	/* iret/ret/lret */
 	case 0xc3:
@@ -686,18 +691,23 @@ static void __kprobes resume_execution(s
 		p->ainsn.boostable = 1;
 		goto no_change;
 	case 0xe8:	/* call relative - Fix return addr */
-		*tos = orig_rip + (*tos - copy_rip);
+		*tos = orig_ip + (*tos - copy_ip);
 		break;
 	case 0xff:
 		if ((insn[1] & 0x30) == 0x10) {
-			/* call absolute, indirect */
-			/* Fix return addr; ip is correct. */
-			/* not boostable */
-			*tos = orig_rip + (*tos - copy_rip);
+			/*
+			 * call absolute, indirect
+			 * Fix return addr; ip is correct.
+			 * But this is not boostable
+			 */
+			*tos = orig_ip + (*tos - copy_ip);
 			goto no_change;
-		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* ip is correct. And this is boostable */
+		} else if (((insn[1] & 0x31) == 0x20) ||
+			   ((insn[1] & 0x31) == 0x21)) {
+			/*
+			 * jmp near and far, absolute indirect
+			 * ip is correct. And this is boostable
+			 */
 			p->ainsn.boostable = 1;
 			goto no_change;
 		}
@@ -706,21 +716,21 @@ static void __kprobes resume_execution(s
 	}

 	if (p->ainsn.boostable == 0) {
-		if ((regs->ip > copy_rip) &&
-		    (regs->ip - copy_rip) + 5 < MAX_INSN_SIZE) {
+		if ((regs->ip > copy_ip) &&
+		    (regs->ip - copy_ip) + 5 < MAX_INSN_SIZE) {
 			/*
 			 * These instructions can be executed directly if it
 			 * jumps back to correct address.
 			 */
 			set_jmp_op((void *)regs->ip,
-				   (void *)orig_rip + (regs->ip - copy_rip));
+				   (void *)orig_ip + (regs->ip - copy_ip));
 			p->ainsn.boostable = 1;
 		} else {
 			p->ainsn.boostable = -1;
 		}
 	}

-	regs->ip = orig_rip + (regs->ip - copy_rip);
+	regs->ip += orig_ip - copy_ip;

 no_change:
 	restore_btf();
@@ -728,7 +738,11 @@ no_change:
 	return;
 }

-int __kprobes post_kprobe_handler(struct pt_regs *regs)
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate and they
+ * remain disabled thoroughout this function.
+ */
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -742,10 +756,10 @@ int __kprobes post_kprobe_handler(struct
 	}

 	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_rflags;
+	regs->flags |= kcb->kprobe_saved_flags;
 	trace_hardirqs_fixup_flags(regs->flags);

-	/* Restore the original saved kprobes variables and continue. */
+	/* Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
 		restore_previous_kprobe(kcb);
 		goto out;
@@ -782,7 +796,7 @@ int __kprobes kprobe_fault_handler(struc
 		 * normal page fault.
 		 */
 		regs->ip = (unsigned long)cur->addr;
-		regs->flags |= kcb->kprobe_old_rflags;
+		regs->flags |= kcb->kprobe_old_flags;
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
 		else
@@ -793,7 +807,7 @@ int __kprobes kprobe_fault_handler(struc
 	case KPROBE_HIT_SSDONE:
 		/*
 		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
+		 * we can also use npre/npostfault count for accounting
 		 * these specific fault cases.
 		 */
 		kprobes_inc_nmissed_count(cur);
@@ -819,7 +833,7 @@ int __kprobes kprobe_fault_handler(struc
 		}

 		/*
-		 * fixup() could not handle it,
+		 * fixup routine could not handle it,
 		 * Let do_page_fault() fix it.
 		 */
 		break;
@@ -838,7 +852,7 @@ int __kprobes kprobe_exceptions_notify(s
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;

-	if (args->regs && user_mode(args->regs))
+	if (args->regs && user_mode_vm(args->regs))
 		return ret;

 	switch (val) {
@@ -871,8 +885,9 @@ int __kprobes setjmp_pre_handler(struct
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();

 	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_rsp = (long *) regs->sp;
-	addr = (unsigned long)(kcb->jprobe_saved_rsp);
+	kcb->jprobe_saved_sp = stack_addr(regs);
+	addr = (unsigned long)(kcb->jprobe_saved_sp);
+
 	/*
 	 * As Linus pointed out, gcc assumes that the callee
 	 * owns the argument space and could overwrite it, e.g.
@@ -897,21 +912,20 @@ void __kprobes jprobe_return(void)
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_rsp):"memory");
+		      (kcb->jprobe_saved_sp):"memory");
 }

 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->ip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_rsp);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);

 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if ((long *)regs->sp != kcb->jprobe_saved_rsp) {
+		if (stack_addr(regs) != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk("current sp %p does not match saved sp %p\n",
-			       (long *)regs->sp, kcb->jprobe_saved_rsp);
+			       stack_addr(regs), kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
@@ -919,8 +933,9 @@ int __kprobes longjmp_break_handler(stru
 			BUG();
 		}
 		*regs = kcb->jprobe_saved_regs;
-		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
-		       MIN_STACK_SIZE(stack_addr));
+		memcpy((kprobe_opcode_t *)(kcb->jprobe_saved_sp),
+		       kcb->jprobes_stack,
+		       MIN_STACK_SIZE(kcb->jprobe_saved_sp));
 		preempt_enable_no_resched();
 		return 1;
 	}
Index: 2.6.24-rc4-mm1/arch/x86/mm/fault_32.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/mm/fault_32.c
+++ 2.6.24-rc4-mm1/arch/x86/mm/fault_32.c
@@ -25,7 +25,6 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
-#include <linux/kprobes.h>

 #include <asm/system.h>
 #include <asm/desc.h>
Index: 2.6.24-rc4-mm1/arch/x86/mm/fault_64.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/mm/fault_64.c
+++ 2.6.24-rc4-mm1/arch/x86/mm/fault_64.c
@@ -25,7 +25,6 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
-#include <linux/kprobes.h>

 #include <asm/system.h>
 #include <asm/pgalloc.h>
Index: 2.6.24-rc4-mm1/include/asm-x86/kprobes_32.h
===================================================================
--- 2.6.24-rc4-mm1.orig/include/asm-x86/kprobes_32.h
+++ 2.6.24-rc4-mm1/include/asm-x86/kprobes_32.h
@@ -2,7 +2,6 @@
 #define _ASM_KPROBES_H
 /*
  *  Kernel Probes (KProbes)
- *  include/asm-i386/kprobes.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -23,14 +22,17 @@
  * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
  *		Probes initial implementation ( includes suggestions from
  *		Rusty Russell).
+ * 2004-Oct	Prasanna S Panchamukhi <prasanna@in.ibm.com> and Jim Keniston
+ *		kenistoj@us.ibm.com adopted from i386.
  */
 #include <linux/types.h>
 #include <linux/ptrace.h>
+#include <linux/percpu.h>

 #define  __ARCH_WANT_KPROBES_INSN_SLOT

-struct kprobe;
 struct pt_regs;
+struct kprobe;

 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
@@ -38,9 +40,11 @@ typedef u8 kprobe_opcode_t;
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR) (((MAX_STACK_SIZE) < \
-	(((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR))) \
+	(((unsigned long)current_thread_info()) + THREAD_SIZE \
+	 - (unsigned long)(ADDR))) \
 	? (MAX_STACK_SIZE) \
-	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
+	: (((unsigned long)current_thread_info()) + THREAD_SIZE \
+	   - (unsigned long)(ADDR)))

 #define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
@@ -55,8 +59,12 @@ struct arch_specific_insn {
 	/* copy of the original instruction */
 	kprobe_opcode_t *insn;
 	/*
-	 * If this flag is not 0, this kprobe can be boost when its
-	 * post_handler and break_handler is not set.
+	 * boostable = -1: This instruction type is not boostable.
+	 * boostable = 0: This instruction type is boostable.
+	 * boostable = 1: This instruction has been boosted: we have
+	 * added a relative jump after the instruction copy in insn,
+	 * so no single-step and fixup are needed (unless there's
+	 * a post_handler or break_handler).
 	 */
 	int boostable;
 };
@@ -64,16 +72,16 @@ struct arch_specific_insn {
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
-	unsigned long old_eflags;
-	unsigned long saved_eflags;
+	unsigned long old_flags;
+	unsigned long saved_flags;
 };

 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned long kprobe_status;
-	unsigned long kprobe_old_eflags;
-	unsigned long kprobe_saved_eflags;
-	unsigned long *jprobe_saved_esp;
+	unsigned long kprobe_old_flags;
+	unsigned long kprobe_saved_flags;
+	unsigned long *jprobe_saved_sp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
@@ -88,7 +96,7 @@ static inline void restore_interrupts(st
 		local_irq_enable();
 }

+extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
-extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 #endif				/* _ASM_KPROBES_H */
Index: 2.6.24-rc4-mm1/include/asm-x86/kprobes_64.h
===================================================================
--- 2.6.24-rc4-mm1.orig/include/asm-x86/kprobes_64.h
+++ 2.6.24-rc4-mm1/include/asm-x86/kprobes_64.h
@@ -2,7 +2,6 @@
 #define _ASM_KPROBES_H
 /*
  *  Kernel Probes (KProbes)
- *  include/asm-x86_64/kprobes.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -20,6 +19,9 @@
  *
  * Copyright (C) IBM Corporation, 2002, 2004
  *
+ * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
+ *		Probes initial implementation ( includes suggestions from
+ *		Rusty Russell).
  * 2004-Oct	Prasanna S Panchamukhi <prasanna@in.ibm.com> and Jim Keniston
  *		kenistoj@us.ibm.com adopted from i386.
  */
@@ -35,19 +37,22 @@ struct kprobe;
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
 #define RELATIVEJUMP_INSTRUCTION 0xe9
-#define MAX_INSN_SIZE 15
+#define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR) (((MAX_STACK_SIZE) < \
-	(((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR))) \
+	(((unsigned long)current_thread_info()) + THREAD_SIZE \
+	 - (unsigned long)(ADDR))) \
 	? (MAX_STACK_SIZE) \
-	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
+	: (((unsigned long)current_thread_info()) + THREAD_SIZE \
+	   - (unsigned long)(ADDR)))

 #define ARCH_SUPPORTS_KRETPROBES
+#define flush_insn_slot(p)	do { } while (0)
+
 extern const int kretprobe_blacklist_size;

+void arch_remove_kprobe(struct kprobe *p);
 void kretprobe_trampoline(void);
-extern void arch_remove_kprobe(struct kprobe *p);
-#define flush_insn_slot(p)	do { } while (0)

 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
@@ -67,16 +72,16 @@ struct arch_specific_insn {
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
-	unsigned long old_rflags;
-	unsigned long saved_rflags;
+	unsigned long old_flags;
+	unsigned long saved_flags;
 };

 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned long kprobe_status;
-	unsigned long kprobe_old_rflags;
-	unsigned long kprobe_saved_rflags;
-	unsigned long *jprobe_saved_rsp;
+	unsigned long kprobe_old_flags;
+	unsigned long kprobe_saved_flags;
+	unsigned long *jprobe_saved_sp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
@@ -91,10 +96,7 @@ static inline void restore_interrupts(st
 		local_irq_enable();
 }

-extern int post_kprobe_handler(struct pt_regs *regs);
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
-extern int kprobe_handler(struct pt_regs *regs);
-
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 #endif				/* _ASM_KPROBES_H */

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


