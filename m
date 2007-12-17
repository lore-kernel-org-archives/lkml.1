Return-Path: <linux-kernel-owner+w=401wt.eu-S1765196AbXLQV1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765196AbXLQV1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932209AbXLQV1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:27:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:22412 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763998AbXLQV1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:27:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ixdk0k5qOERH1gq3pQbnmHf8eOTHBjdiuHfKkVapA5tYIfCTvQN2e/Bvb38v7DycD5dUrtCJlj67UXi9VZOGVUhMRwMQow8ftsFFWGufDAPPUuubFxZKKu5cwMVGz3+Qpsvh+sgoTQ6lBLi+AdbNlS9oQ32tjW1bk4pygWNVsqY=
Subject: [PATCH 3/4] x86: add kprobe-booster to X86_64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 13:27:03 -0800
Message-Id: <1197926823.23402.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on X86_32, mostly by un-ifdeffing code.

Based on patch from Masami Hiramatsu <mhiramat@redhat.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes.c |   57 +++++++++++++++++++++++----------------------
 include/asm-x86/kprobes.h |   12 +++++----
 2 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 64c702c..47bae2c 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -151,15 +151,17 @@ twobyte_has_modrm[256 / (sizeof(unsigned long) * 8)] = {
 #undef R4
 #undef RF
 
-/* insert a jmp code */
+/*
+ * Insert a jump instruction at address 'from' which jumps to address 'to' */
 static inline void set_jmp_op(void *from, void *to)
 {
 	struct __arch_jmp_op {
 		char op;
-		long raddr;
-	} __attribute__((packed)) *jop;
+		s32 raddr;
+	} __attribute__((packed)) * jop;
 	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (long)(to) - ((long)(from) + 5);
+
+	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
 	jop->op = RELATIVEJUMP_INSTRUCTION;
 }
 
@@ -183,6 +185,9 @@ retry:
 	}
 
 	switch (opcode & 0xf0) {
+#ifdef X86_64
+	case 0x40:
+		goto retry; /* REX prefix is boostable */
 	case 0x60:
 		if (0x63 < opcode && opcode < 0x67)
 			goto retry; /* prefixes */
@@ -202,7 +207,7 @@ retry:
 	case 0xf0:
 		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
 			goto retry; /* lock/rep(ne) prefix */
-		/* clear and set flags can be boost */
+		/* clear and set flags are boostable */
 		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
 	default:
 		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
@@ -221,6 +226,10 @@ static s32 __kprobes *is_riprel(u8 *insn)
 {
 	int need_modrm;
 
+#ifdef CONFIG_X86_32
+	return NULL;
+#endif
+
 	/* Skip legacy instruction prefixes.  */
 	while (1) {
 		switch (*insn) {
@@ -266,18 +275,10 @@ static s32 __kprobes *is_riprel(u8 *insn)
 
 static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
-#ifdef CONFIG_X86_32
-	memcpy(p->ainsn.insn, p->addr,
-	       (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
-	if (can_boost(p->addr)) {
-		p->ainsn.boostable = 0;
-	} else {
-		p->ainsn.boostable = -1;
-	}
-#else
 	s32 *ripdisp;
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
+	memcpy(p->ainsn.insn, p->addr,
+	       MAX_INSN_SIZE + sizeof(kprobe_opcode_t));
+
 	ripdisp = is_riprel(p->ainsn.insn);
 	if (ripdisp) {
 		/*
@@ -297,8 +298,13 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
 		*ripdisp = disp;
 	}
+
 	p->opcode = *p->addr;
-#endif
+	if (can_boost(p->addr)) {
+		p->ainsn.boostable = 0;
+	} else {
+		p->ainsn.boostable = -1;
+	}
 }
 
 /*
@@ -343,11 +349,7 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
 	mutex_lock(&kprobe_mutex);
-#ifdef CONFIG_X86_32
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-#else
-	free_insn_slot(p->ainsn.insn, 0);
-#endif
 	mutex_unlock(&kprobe_mutex);
 }
 
@@ -544,7 +546,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		return 1;
 
 ss_probe:
-#if defined(CONFIG_X86_32) && (!defined(CONFIG_PREEMPT) || defined(CONFIG_PM))
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
 	if (p->ainsn.boostable == 1 && !p->post_handler){
 		/* Boost up -- we can execute copied instructions directly */
 		reset_current_kprobe();
@@ -722,6 +724,11 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
  * that is atop the stack is the address following the copied instruction.
  * We need to make it the address following the original instruction.
  *
+ * If this is the first time we've single-stepped the instruction at
+ * this probepoint, and the instruction is boostable, boost it: add a
+ * jump instruction after the copied instruction, that jumps to the next
+ * instruction after the probepoint.
+ *
  * This function also checks instruction size for preparing direct execution.
  */
 static void __kprobes resume_execution(struct kprobe *p,
@@ -754,10 +761,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 	case 0xcb:
 	case 0xcf:
 	case 0xea:		/* jmp absolute -- ip is correct */
-#ifdef CONFIG_X86_32
 		/* ip is already adjusted, no more changes required */
 		p->ainsn.boostable = 1;
-#endif
 		goto no_change;
 	case 0xe8:		/* call relative - Fix return addr */
 		*tos = orig_ip + (*tos - copy_ip);
@@ -777,10 +782,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
 			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
 			/* ip is correct. */
-#ifdef CONFIG_X86_32
 			/* And this is boostable */
 			p->ainsn.boostable = 1;
-#endif
 			goto no_change;
 		}
 		break;
@@ -788,7 +791,6 @@ static void __kprobes resume_execution(struct kprobe *p,
 		break;
 	}
 
-#ifdef CONFIG_X86_32
 	if (p->ainsn.boostable == 0) {
 		if ((regs->ip > copy_ip) &&
 		    (regs->ip - copy_ip) + 5 < (MAX_INSN_SIZE + 1)) {
@@ -803,7 +805,6 @@ static void __kprobes resume_execution(struct kprobe *p,
 			p->ainsn.boostable = -1;
 		}
 	}
-#endif
 	regs->ip = orig_ip + (regs->ip - copy_ip);
 
 no_change:
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index 7319c62..f9a4fd2 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -58,13 +58,15 @@ void kretprobe_trampoline(void);
 struct arch_specific_insn {
 	/* copy of the original instruction */
 	kprobe_opcode_t *insn;
-#ifdef CONFIG_X86_32
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
-	int boostable;
-#endif
+	 int boostable;
 };
 
 struct prev_kprobe {
-- 
1.5.4.rc0.1083.gf568


