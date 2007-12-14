Return-Path: <linux-kernel-owner+w=401wt.eu-S935148AbXLNWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148AbXLNWlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934668AbXLNWhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:37:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:30581 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934757AbXLNWhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:37:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u3RUJ2hHg7cNWCS7go6Z7x2WDDOBLyT7GmWrZevzjPbf8pzrdpKQ0dhTP2qSPCXaQdklvE/0PEu3urGLhEitSwbBqhDQdRmtpcnXgRhu3RwlYC0Lj5i8BFd74JmYFdSrcqe6OppR6YoWskEmXV/l+V50Y/j99rzGAdSpJyP5YOc=
Subject: [PATCH] x86: Further reduce kprobes_{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 14:37:56 -0800
Message-Id: <1197671876.898.67.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add X86_32 only static function to X86_64 file and add static
X86_64 functions to X86_32 file.  Produces compile warnings
about defined but not used functions for now, will deal with
these in final unified file.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   85 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/kprobes_64.c |   61 ++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 3e45b51..cebc077 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -37,13 +37,14 @@
 #include <asm/alternative.h>
 
 void jprobe_return_end(void);
+static void __kprobes arch_copy_kprobe(struct kprobe *p);
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = {
 	{"__switch_to", }, /* This function switches only current task, but
-			     doesn't switch kernel stack.*/
+			      doesn't switch kernel stack.*/
 	{NULL, NULL}	/* Terminator */
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
@@ -156,7 +157,7 @@ twobyte_has_modrm[256 / sizeof(unsigned long)] = {
 #undef RF
 
 /* insert a jmp code */
-static __always_inline void set_jmp_op(void *from, void *to)
+static inline void set_jmp_op(void *from, void *to)
 {
 	struct __arch_jmp_op {
 		char op;
@@ -170,7 +171,7 @@ static __always_inline void set_jmp_op(void *from, void *to)
 /*
  * returns non-zero if opcodes can be boosted.
  */
-static __always_inline int can_boost(kprobe_opcode_t *opcodes)
+static inline int can_boost(kprobe_opcode_t *opcodes)
 {
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
@@ -248,6 +249,84 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	return 0;
 }
 
+/*
+ * Determine if the instruction uses the %rip-relative addressing mode.
+ * If it does, return the address of the 32-bit displacement word.
+ * If not, return null.
+ */
+static s32 __kprobes *is_riprel(u8 *insn)
+{
+	int need_modrm;
+
+	/* Skip legacy instruction prefixes.  */
+	while (1) {
+		switch (*insn) {
+		case 0x66:
+		case 0x67:
+		case 0x2e:
+		case 0x3e:
+		case 0x26:
+		case 0x64:
+		case 0x65:
+		case 0x36:
+		case 0xf0:
+		case 0xf3:
+		case 0xf2:
+			++insn;
+			continue;
+		}
+		break;
+	}
+
+	/* Skip REX instruction prefix.  */
+	if ((*insn & 0xf0) == 0x40)
+		++insn;
+
+	if (*insn == 0x0f) {	/* Two-byte opcode.  */
+		++insn;
+		need_modrm = test_bit(*insn, twobyte_has_modrm);
+	} else {		/* One-byte opcode.  */
+		need_modrm = test_bit(*insn, onebyte_has_modrm);
+	}
+
+	if (need_modrm) {
+		u8 modrm = *++insn;
+		if ((modrm & 0xc7) == 0x05) { /* %rip+disp32 addressing mode */
+			/* Displacement follows ModRM byte.  */
+			return (s32 *) ++insn;
+		}
+	}
+
+	/* No %rip-relative addressing mode here.  */
+	return NULL;
+}
+
+static void __kprobes arch_copy_kprobe(struct kprobe *p)
+{
+	s32 *ripdisp;
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
+	ripdisp = is_riprel(p->ainsn.insn);
+	if (ripdisp) {
+		/*
+		 * The copied instruction uses the %rip-relative
+		 * addressing mode.  Adjust the displacement for the
+		 * difference between the original location of this
+		 * instruction and the location of the copy that will
+		 * actually be run.  The tricky bit here is making sure
+		 * that the sign extension happens correctly in this
+		 * calculation, since we need a signed 32-bit result to
+		 * be sign-extended to 64 bits when it's added to the
+		 * %rip value and yield the same 64-bit result that the
+		 * sign-extension of the original signed 32-bit
+		 * displacement would have given.
+		 */
+		s64 disp = (u8 *) p->addr + *ripdisp - (u8 *) p->ainsn.insn;
+		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
+		*ripdisp = disp;
+	}
+	p->opcode = *p->addr;
+}
+
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
 	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 54b2279..6f62a4a 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -162,6 +162,67 @@ twobyte_has_modrm[256 / sizeof(unsigned long)] = {
 #undef R4
 #undef RF
 
+/* insert a jmp code */
+static inline void set_jmp_op(void *from, void *to)
+{
+	struct __arch_jmp_op {
+		char op;
+		long raddr;
+	} __attribute__((packed)) *jop;
+	jop = (struct __arch_jmp_op *)from;
+	jop->raddr = (long)(to) - ((long)(from) + 5);
+	jop->op = RELATIVEJUMP_INSTRUCTION;
+}
+
+/*
+ * returns non-zero if opcodes can be boosted.
+ */
+static inline int can_boost(kprobe_opcode_t *opcodes)
+{
+	kprobe_opcode_t opcode;
+	kprobe_opcode_t *orig_opcodes = opcodes;
+retry:
+	if (opcodes - orig_opcodes > MAX_INSN_SIZE)
+		return 0;
+	opcode = *(opcodes++);
+
+	/* 2nd-byte opcode */
+	if (opcode == 0x0f) {
+		if (opcodes - orig_opcodes > MAX_INSN_SIZE)
+			return 0;
+		return test_bit(*opcodes, twobyte_is_boostable);
+	}
+
+	switch (opcode & 0xf0) {
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
+		/* clear and set flags can be boost */
+		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
+	default:
+		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
+			goto retry; /* prefixes */
+		/* can't boost CS override and call */
+		return (opcode != 0x2e && opcode != 0x9a);
+	}
+}
+
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
-- 
1.5.4.rc0.1083.gf568



