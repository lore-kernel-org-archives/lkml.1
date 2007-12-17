Return-Path: <linux-kernel-owner+w=401wt.eu-S935414AbXLQQOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414AbXLQQOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXLQQO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:14:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXLQQOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:14:25 -0500
Message-ID: <47669EC1.9060605@redhat.com>
Date: Mon, 17 Dec 2007 11:07:29 -0500
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
Subject: [-mm][PATCH 4/6] return probe-booster for x86-64
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kretprobe-booster to kprobes_64.c.

- Changes are based on x86-32.
- Rewrite register saving/restoring code

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/kernel/kprobes_64.c |   92 ++++++++++++++++++++++++++++++-------------
 1 file changed, 65 insertions(+), 27 deletions(-)

Index: 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/kernel/kprobes_64.c
+++ 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
@@ -28,6 +28,8 @@
  *		Fixed to handle %rip-relative addressing mode correctly.
  * 2005-May     Rusty Lynch <rusty.lynch@intel.com>
  *              Added function return probes functionality
+ * 2007-Dec	Masami Hiramatsu <mhiramat@redhat.com> added kprobe-booster
+ * 		and kretprobe-booster for x86-64
  */

 #include <linux/kprobes.h>
@@ -507,21 +509,65 @@ no_kprobe:
 }

 /*
- * For function-return probes, init_kprobes() establishes a probepoint
- * here. When a retprobed function returns, this probe is hit and
- * trampoline_probe_handler() runs, calling the kretprobe's handler.
+ * When a retprobed function returns, this code saves registers and
+ * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
- void kretprobe_trampoline_holder(void)
+ void __kprobes kretprobe_trampoline_holder(void)
  {
  	asm volatile (  ".global kretprobe_trampoline\n"
- 			"kretprobe_trampoline: \n"
- 			"nop\n");
+			"kretprobe_trampoline: \n"
+			/* We don't bother saving the ss register */
+			"	pushq %rsp\n"
+			"	pushfq\n"
+			/*
+			 * Skip cs, ip, orig_ax.
+			 * trampoline_handler() will plug in these values
+			 */
+			"	subq $24, %rsp\n"
+			"	pushq %rdi\n"
+			"	pushq %rsi\n"
+			"	pushq %rdx\n"
+			"	pushq %rcx\n"
+			"	pushq %rax\n"
+			"	pushq %r8\n"
+			"	pushq %r9\n"
+			"	pushq %r10\n"
+			"	pushq %r11\n"
+			"	pushq %rbx\n"
+			"	pushq %rbp\n"
+			"	pushq %r12\n"
+			"	pushq %r13\n"
+			"	pushq %r14\n"
+			"	pushq %r15\n"
+			"	movq %rsp, %rdi\n"
+			"	call trampoline_handler\n"
+			/* Replace saved sp with true return address. */
+			"	movq %rax, 152(%rsp)\n"
+			"	popq %r15\n"
+			"	popq %r14\n"
+			"	popq %r13\n"
+			"	popq %r12\n"
+			"	popq %rbp\n"
+			"	popq %rbx\n"
+			"	popq %r11\n"
+			"	popq %r10\n"
+			"	popq %r9\n"
+			"	popq %r8\n"
+			"	popq %rax\n"
+			"	popq %rcx\n"
+			"	popq %rdx\n"
+			"	popq %rsi\n"
+			"	popq %rdi\n"
+			/* Skip orig_ax, ip, cs */
+			"	addq $24, %rsp\n"
+			"	popfq\n"
+			"	ret\n");
  }

 /*
- * Called when we hit the probe point at kretprobe_trampoline
+ * Called from kretprobe_trampoline
  */
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+fastcall void * __kprobes trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -532,6 +578,10 @@ int __kprobes trampoline_probe_handler(s
 	INIT_HLIST_HEAD(&empty_rp);
 	spin_lock_irqsave(&kretprobe_lock, flags);
 	head = kretprobe_inst_table_head(current);
+	/* fixup rt_regs */
+	regs->cs = __KERNEL_CS;
+	regs->ip = trampoline_address;
+	regs->orig_ax = 0xffffffffffffffff;

 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -551,8 +601,12 @@ int __kprobes trampoline_probe_handler(s
 			/* another task is sharing our hash bucket */
 			continue;

-		if (ri->rp && ri->rp->handler)
+		if (ri->rp && ri->rp->handler) {
+			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
 			ri->rp->handler(ri, regs);
+			__get_cpu_var(current_kprobe) = NULL;
+		}

 		orig_ret_address = (unsigned long)ri->ret_addr;
 		recycle_rp_inst(ri, &empty_rp);
@@ -567,22 +621,14 @@ int __kprobes trampoline_probe_handler(s
 	}

 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-	regs->ip = orig_ret_address;

-	reset_current_kprobe();
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	preempt_enable_no_resched();

 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
+	return (void *)orig_ret_address;
 }

 /*
@@ -881,20 +927,12 @@ int __kprobes longjmp_break_handler(stru
 	return 0;
 }

-static struct kprobe trampoline_p = {
-	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
-	.pre_handler = trampoline_probe_handler
-};
-
 int __init arch_init_kprobes(void)
 {
-	return register_kprobe(&trampoline_p);
+	return 0;
 }

 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
-	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
-		return 1;
-
 	return 0;
 }
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


