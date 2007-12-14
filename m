Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXLNXRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXLNXRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXLNXQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:16:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:34664 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbXLNXQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y9XgPKZPF984bvrwWc8BXRc2swAAQcBRnS5aLDLK5vRtK9OdgOocnT2WhCzs3wkURD00NDLJwGD79Ga+5wdjD9NUF2Y1YchkvB8GBhjtUIziFiUyJH6QBKN2swNAGSl7QlfPNEAs0IZDqs/HwBH4e4qcOg4ZUM66AxSwOiJuNRo=
Subject: [PATCH] x86: Unify cosmetic kprobes{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 15:16:47 -0800
Message-Id: <1197674207.898.72.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces some temporary ifdefs and changes some cosmetic differences.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   48 +++++++++++++++++++++++++++--------------
 arch/x86/kernel/kprobes_64.c |   34 ++++++++++++++++++++++-------
 2 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index f4ba584..2a8acd6 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -234,7 +234,7 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t opcode)
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
-	/* insn: must be on special executable page on i386. */
+	/* insn: must be on special executable page on x86_32|64. */
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)
 		return -ENOMEM;
@@ -373,13 +373,21 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 static __always_inline void clear_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
+#ifdef CONFIG_X86_32
 		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
+#else
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+#endif
 }
 
 static __always_inline void restore_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
+#ifdef CONFIG_X86_32
 		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
+#else
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
+#endif
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
@@ -554,7 +562,7 @@ no_kprobe:
 }
 
 /*
- * Called from kretprobe_trampoline
+ * Called when we hit the probe point at kretprobe_trampoline
  */
 void *__kprobes trampoline_handler(struct pt_regs *regs)
 {
@@ -647,8 +655,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
 	unsigned long *tos = (unsigned long *)&regs->sp;
-	unsigned long copy_eip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_eip = (unsigned long)p->addr;
+	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
+	unsigned long orig_ip = (unsigned long)p->addr;
 
 	regs->flags &= ~TF_MASK;
 	switch (p->ainsn.insn[0]) {
@@ -666,10 +674,10 @@ static void __kprobes resume_execution(struct kprobe *p,
 		p->ainsn.boostable = 1;
 		goto no_change;
 	case 0xe8:		/* call relative - Fix return addr */
-		*tos = orig_eip + (*tos - copy_eip);
+		*tos = orig_ip + (*tos - copy_ip);
 		break;
 	case 0x9a:		/* call absolute -- same as call absolute, indirect */
-		*tos = orig_eip + (*tos - copy_eip);
+		*tos = orig_ip + (*tos - copy_ip);
 		goto no_change;
 	case 0xff:
 		if ((p->ainsn.insn[1] & 0x30) == 0x10) {
@@ -678,7 +686,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 			 * Fix return addr; ip is correct.
 			 * But this is not boostable
 			 */
-			*tos = orig_eip + (*tos - copy_eip);
+			*tos = orig_ip + (*tos - copy_ip);
 			goto no_change;
 		} else if (((p->ainsn.insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
 			   ((p->ainsn.insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
@@ -691,26 +699,24 @@ static void __kprobes resume_execution(struct kprobe *p,
 	}
 
 	if (p->ainsn.boostable == 0) {
-		if ((regs->ip > copy_eip) &&
-		    (regs->ip - copy_eip) + 5 < (MAX_INSN_SIZE + 1)) {
+		if ((regs->ip > copy_ip) &&
+		    (regs->ip - copy_ip) + 5 < (MAX_INSN_SIZE + 1)) {
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
+	regs->ip = orig_ip + (regs->ip - copy_ip);
 
 no_change:
 	restore_btf();
-
-	return;
 }
 
 /*
@@ -734,7 +740,7 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 	regs->flags |= kcb->kprobe_saved_flags;
 	trace_hardirqs_fixup_flags(regs->flags);
 
-	/*Restore back the original saved kprobes variables and continue. */
+	/* Restore the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
 		restore_previous_kprobe(kcb);
 		goto out;
@@ -815,7 +821,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 }
 
 /*
- * Wrapper routine to for handling exceptions.
+ * Wrapper routine for handling exceptions.
  */
 int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
@@ -860,7 +866,7 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	addr = (unsigned long)(kcb->jprobe_saved_sp);
 
 	/*
-	 * TBD: As Linus pointed out, gcc assumes that the callee
+	 * As Linus pointed out, gcc assumes that the callee
 	 * owns the argument space and could overwrite it, e.g.
 	 * tailcall optimization. So, to be absolutely safe
 	 * we also save and restore enough stack bytes to cover
@@ -877,13 +883,21 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 void __kprobes jprobe_return(void)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
+#ifdef CONFIG_X86_32
 	asm volatile ("       xchgl   %%ebx,%%esp     \n"
 		      "       int3			\n"
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
 		      (kcb->jprobe_saved_sp):"memory");
+#else
+	asm volatile ("       xchg   %%rbx,%%rsp     \n"
+		      "       int3			\n"
+		      "       .globl jprobe_return_end	\n"
+		      "       jprobe_return_end:	\n"
+		      "       nop			\n"::"b"
+		      (kcb->jprobe_saved_sp):"memory");
+#endif
 }
 
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 13a92ef..5f02e75 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -243,7 +243,7 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
-	/* insn: must be on special executable page on x86_64. */
+	/* insn: must be on special executable page on x86_32|64. */
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn) {
 		return -ENOMEM;
@@ -376,13 +376,21 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 static __always_inline void clear_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
+#ifdef CONFIG_X86_32
+		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
+#else
 		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+#endif
 }
 
 static __always_inline void restore_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
+#ifdef CONFIG_X86_32
+		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
+#else
 		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
+#endif
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
@@ -412,9 +420,11 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
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
@@ -616,8 +626,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 {
 	unsigned long *tos = (unsigned long *)regs->sp;
 	unsigned long next_rip = 0;
-	unsigned long copy_rip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_rip = (unsigned long)p->addr;
+	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
+	unsigned long orig_ip = (unsigned long)p->addr;
 	kprobe_opcode_t *insn = p->ainsn.insn;
 
 	/*skip the REX prefix*/
@@ -637,14 +647,14 @@ static void __kprobes resume_execution(struct kprobe *p,
 		/* ip is already adjusted, no more changes required*/
 		return;
 	case 0xe8:		/* call relative - Fix return addr */
-		*tos = orig_rip + (*tos - copy_rip);
+		*tos = orig_ip + (*tos - copy_ip);
 		break;
 	case 0xff:
 		if ((insn[1] & 0x30) == 0x10) {
 			/* call absolute, indirect */
 			/* Fix return addr; ip is correct. */
 			next_rip = regs->ip;
-			*tos = orig_rip + (*tos - copy_rip);
+			*tos = orig_ip + (*tos - copy_ip);
 		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
 			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
 			/* ip is correct. */
@@ -662,7 +672,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 	if (next_rip) {
 		regs->ip = next_rip;
 	} else {
-		regs->ip = orig_rip + (regs->ip - copy_rip);
+		regs->ip = orig_ip + (regs->ip - copy_ip);
 	}
 
 	restore_btf();
@@ -831,13 +841,21 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 void __kprobes jprobe_return(void)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
+#ifdef CONFIG_X86_32
+	asm volatile ("       xchgl   %%ebx,%%esp     \n"
+		      "       int3			\n"
+		      "       .globl jprobe_return_end	\n"
+		      "       jprobe_return_end:	\n"
+		      "       nop			\n"::"b"
+		      (kcb->jprobe_saved_sp):"memory");
+#else
 	asm volatile ("       xchg   %%rbx,%%rsp     \n"
 		      "       int3			\n"
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
 		      (kcb->jprobe_saved_sp):"memory");
+#endif
 }
 
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-- 
1.5.4.rc0.1083.gf568



