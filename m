Return-Path: <linux-kernel-owner+w=401wt.eu-S935718AbXLQVbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935718AbXLQVbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbXLQVbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:31:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:29182 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbXLQVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:31:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iaxFSJGdyPmD4VA4dvSCpRg0iTh4ZKNUZfwtoUUKYiWoXq60AhwfLujDuV5jT4VTnNfurOHkAmyrvQ8kqBfWwF9f3c/ykN9pecas/rIa63nk2M0CkWUcyX/Lxav4oxU7MQyaOnB1nCNSQZt/zhp3oQlvgDU2GAhtmkUU3BMna30=
Subject: [PATCH 4/4] This patch adds kretprobe-booster to X86_64
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
Date: Mon, 17 Dec 2007 13:31:14 -0800
Message-Id: <1197927074.23402.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Rewrite register saving/restoring code

Based on patch from Masami Hiramatsu <mhiramat@redhat.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry Ingo, I based my other 4/4 off the patch that had the one incorrect
ifdef around trampoline_probe_handler.  This is based on your fixed one.

Masami, I think you want to check your register restoration code in
trampoline_probe_handler vs X86_32, it's obvious in this patch in the
section:

X86_32:
regs->cs = __KERNEL_CS | get_kernel_rpl();

yours:
regs->cs = __KERNEL_CS;

 arch/x86/kernel/kprobes.c |  104 +++++++++++++++++++++++++--------------------
 1 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 47bae2c..37a34a8 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -565,9 +565,8 @@ no_kprobe:
 }
 
 /*
- * For function-return probes, init_kprobes() establishes a probepoint
- * here. When a retprobed function returns, this probe is hit and
- * trampoline_probe_handler() runs, calling the kretprobe's handler.
+ * When a retprobed function returns,this code saves registers and
+ * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
 void __kprobes kretprobe_trampoline_holder(void)
 {
@@ -608,19 +607,59 @@ void __kprobes kretprobe_trampoline_holder(void)
 #else
 	asm volatile (  ".global kretprobe_trampoline\n"
 			"kretprobe_trampoline: \n"
-			"nop\n");
+			/* We don't bother saving the ss register */
+			"       pushq %rsp\n"
+			"       pushfq\n"
+			/*
+			 * Skip cs, ip, orig_ax.
+			 * trampoline_handler() will plug in these values
+			 */
+			"       subq $24, %rsp\n"
+			"       pushq %rdi\n"
+			"       pushq %rsi\n"
+			"       pushq %rdx\n"
+			"       pushq %rcx\n"
+			"       pushq %rax\n"
+			"       pushq %r8\n"
+			"       pushq %r9\n"
+			"       pushq %r10\n"
+			"       pushq %r11\n"
+			"       pushq %rbx\n"
+			"       pushq %rbp\n"
+			"       pushq %r12\n"
+			"       pushq %r13\n"
+			"       pushq %r14\n"
+			"       pushq %r15\n"
+			"       movq %rsp, %rdi\n"
+			"       call trampoline_handler\n"
+			/* Replace saved sp with true return address. */
+			"       movq %rax, 152(%rsp)\n"
+			"       popq %r15\n"
+			"       popq %r14\n"
+			"       popq %r13\n"
+			"       popq %r12\n"
+			"       popq %rbp\n"
+			"       popq %rbx\n"
+			"       popq %r11\n"
+			"       popq %r10\n"
+			"       popq %r9\n"
+			"       popq %r8\n"
+			"       popq %rax\n"
+			"       popq %rcx\n"
+			"       popq %rdx\n"
+			"       popq %rsi\n"
+			"       popq %rdi\n"
+			/* Skip orig_ax, ip, cs */
+			"       addq $24, %rsp\n"
+			"       popfq\n"
+			"       ret\n");
 #endif
 }
 
 /*
- * X86_32 Called from kretprobe_trampoline
- * X86_64 Called when we hit the probe point at kretprobe_trampoline
+ * Called from kretprobe_trampoline
  */
-#ifdef CONFIG_X86_64
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
-#else
 void *__kprobes trampoline_handler(struct pt_regs *regs)
-#endif
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -636,6 +675,11 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 	regs->cs = __KERNEL_CS | get_kernel_rpl();
 	regs->ip = trampoline_address;
 	regs->orig_ax = 0xffffffff;
+#else
+	/* fixup rt regs */
+	regs->cs = __KERNEL_CS;
+	regs->ip = trampoline_address;
+	regs->orig_ax = 0xffffffffffffffff;
 #endif
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -654,17 +698,14 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
-#ifdef CONFIG_X86_32
+
 		if (ri->rp && ri->rp->handler) {
 			__get_cpu_var(current_kprobe) = &ri->rp->kp;
 			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
 			ri->rp->handler(ri, regs);
 			__get_cpu_var(current_kprobe) = NULL;
 		}
-#else
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-#endif
+
 		orig_ret_address = (unsigned long)ri->ret_addr;
 		recycle_rp_inst(ri, &empty_rp);
 
@@ -678,28 +719,14 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 	}
 
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-#ifdef CONFIG_X86_64
-	regs->ip = orig_ret_address;
-	reset_current_kprobe();
-#endif
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
-#ifdef CONFIG_X86_64
-	preempt_enable_no_resched();
-#endif
+
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
-#ifdef CONFIG_X86_32
+
 	return (void*)orig_ret_address;
-#else
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
-#endif
 }
 
 /*
@@ -1042,27 +1069,12 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
-static struct kprobe trampoline_p = {
-	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
-	.pre_handler = trampoline_probe_handler
-};
-#endif
-
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
-#ifdef CONFIG_X86_64
-	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
-		return 1;
-#endif
 	return 0;
 }
 
 int __init arch_init_kprobes(void)
 {
-#ifdef CONFIG_X86_64
-	return register_kprobe(&trampoline_p);
-#else
 	return 0;
-#endif
 }
-- 
1.5.4.rc0.1083.gf568

