Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbXLaNIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbXLaNIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXLaNIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:08:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:1264 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXLaNIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=phWN7SeLrqaqTYrUZ7Rh2vAUWEQTLglur2VcDruYVUBVG4d5rvDFfGmWyLLiCJ6rJ5FPC/x5LERCYMJlgh9Q69oT6QHIxDZY8SDIO0m0gmTrbqIPuNvuMk3y9CE4vHJBB8Cuj4UGfIStjfUw7cIjUQ3yA+kwwJU2YJSZfPRkB10=
Message-ID: <4778E8B0.6010400@gmail.com>
Date: Mon, 31 Dec 2007 18:33:44 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick>
In-Reply-To: <1198806265.6323.34.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Make the control flow of kprobe_handler more obvious.
> 
> Collapse the separate if blocks/gotos with if/else blocks
> this unifies the duplication of the check for a breakpoint
> instruction race with another cpu.

This is a patch derived from kprobe_handler of the ARM kprobes port. This further simplifies the current x86 kprobe_handler. The resulting definition is smaller, more readable, has no goto's and contains only a single call to get_kprobe.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
Signed-off-by: Quentin Barnes <qbarnes@gmail.com>
---

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 3a020f7..5a626fd 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -240,108 +240,110 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
+static __always_inline void setup_singlestep(struct kprobe *p,
+					     struct pt_regs *regs,
+					     struct kprobe_ctlblk *kcb)
+{
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+	if (p->ainsn.boostable == 1 && !p->post_handler) {
+		/* Boost up -- we can execute copied instructions directly */
+		reset_current_kprobe();
+		regs->eip = (unsigned long)p->ainsn.insn;
+		preempt_enable_no_resched();
+	} else {
+		prepare_singlestep(p, regs);
+		kcb->kprobe_status = KPROBE_HIT_SS;
+	}
+#else
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+#endif
+}
+
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled thorough out this function.
  */
 static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
-	struct kprobe *p;
 	int ret = 0;
 	kprobe_opcode_t *addr;
+	struct kprobe *p, *cur;
 	struct kprobe_ctlblk *kcb;
 
 	addr = (kprobe_opcode_t *)(regs->eip - sizeof(kprobe_opcode_t));
+	if (*addr != BREAKPOINT_INSTRUCTION) {
+		/*
+		 * The breakpoint instruction was removed right
+		 * after we hit it.  Another cpu has removed
+		 * either a probepoint or a debugger breakpoint
+		 * at this address.  In either case, no further
+		 * handling of this interrupt is appropriate.
+		 * Back up over the (now missing) int3 and run
+		 * the original instruction.
+		 */
+		regs->eip -= sizeof(kprobe_opcode_t);
+		return 1;
+	}
 
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
 	preempt_disable();
 	kcb = get_kprobe_ctlblk();
+	cur = kprobe_running();
+	p = get_kprobe(addr);
 
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->eflags &= ~TF_MASK;
-				regs->eflags |= kcb->kprobe_saved_eflags;
-				goto no_kprobe;
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
-		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-				regs->eip -= sizeof(kprobe_opcode_t);
+	if (p) {
+		if (cur) {
+			switch (kcb->kprobe_status) {
+			case KPROBE_HIT_ACTIVE:
+			case KPROBE_HIT_SSDONE:
+				/* a probe has been hit inside a
+				 * user handler */
+				save_previous_kprobe(kcb);
+				set_current_kprobe(p, regs, kcb);
+				kprobes_inc_nmissed_count(p);
+				prepare_singlestep(p, regs);
+				kcb->kprobe_status = KPROBE_REENTER;
 				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
+				break;
+			case KPROBE_HIT_SS:
+				if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+					regs->eflags &= ~TF_MASK;
+					regs->eflags |=
+						kcb->kprobe_saved_eflags;
+				} else {
+					/* BUG? */
+				}
+				break;
+			default:
+				/* impossible cases */
+				BUG();
 			}
-		}
-		goto no_kprobe;
-	}
+		} else {
+			set_current_kprobe(p, regs, kcb);
+			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
 			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 * Back up over the (now missing) int3 and run
-			 * the original instruction.
+			 * If we have no pre-handler or it returned 0, we
+			 * continue with normal processing.  If we have a
+			 * pre-handler and it returned non-zero, it prepped
+			 * for calling the break_handler below on re-entry
+			 * for jprobe processing, so get out doing nothing
+			 * more here.
 			 */
-			regs->eip -= sizeof(kprobe_opcode_t);
+			if (!p->pre_handler || !p->pre_handler(p, regs))
+				setup_singlestep(p, regs, kcb);
 			ret = 1;
 		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
+	} else if (cur) {
+		p = __get_cpu_var(current_kprobe);
+		if (p->break_handler && p->break_handler(p, regs)) {
+			setup_singlestep(p, regs, kcb);
+			ret = 1;
+		}
+	} /* else: not a kprobe fault; let the kernel handle it */
 
-ss_probe:
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
-	if (p->ainsn.boostable == 1 && !p->post_handler){
-		/* Boost up -- we can execute copied instructions directly */
-		reset_current_kprobe();
-		regs->eip = (unsigned long)p->ainsn.insn;
+	if (!ret)
 		preempt_enable_no_resched();
-		return 1;
-	}
-#endif
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
 	return ret;
 }
 
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 5df19a9..788114c 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -278,30 +278,47 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
-int __kprobes kprobe_handler(struct pt_regs *regs)
+static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
-	struct kprobe *p;
 	int ret = 0;
-	kprobe_opcode_t *addr = (kprobe_opcode_t *)(regs->rip - sizeof(kprobe_opcode_t));
+	kprobe_opcode_t *addr;
+	struct kprobe *p, *cur;
 	struct kprobe_ctlblk *kcb;
 
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
+	addr = (kprobe_opcode_t *)(regs->rip - sizeof(kprobe_opcode_t));
+	if (*addr != BREAKPOINT_INSTRUCTION) {
+		/*
+		 * The breakpoint instruction was removed right
+		 * after we hit it.  Another cpu has removed
+		 * either a probepoint or a debugger breakpoint
+		 * at this address.  In either case, no further
+		 * handling of this interrupt is appropriate.
+		 * Back up over the (now missing) int3 and run
+		 * the original instruction.
+		 */
+		regs->rip = (unsigned long)addr;
+		return 1;
+	}
+
 	preempt_disable();
 	kcb = get_kprobe_ctlblk();
+	cur = kprobe_running();
+	p = get_kprobe(addr);
 
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->eflags &= ~TF_MASK;
-				regs->eflags |= kcb->kprobe_saved_rflags;
-				goto no_kprobe;
-			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
+	if (p) {
+		if (cur) {
+			switch (kcb->kprobe_status) {
+			case KPROBE_HIT_ACTIVE:
+				/* a probe has been hit inside a
+				 * user handler */
+				save_previous_kprobe(kcb);
+				set_current_kprobe(p, regs, kcb);
+				kprobes_inc_nmissed_count(p);
+				prepare_singlestep(p, regs);
+				kcb->kprobe_status = KPROBE_REENTER;
+				ret = 1;
+				break;
+			case KPROBE_HIT_SSDONE:
 				/* TODO: Provide re-entrancy from
 				 * post_kprobes_handler() and avoid exception
 				 * stack corruption while single-stepping on
@@ -311,72 +328,49 @@ int __kprobes kprobe_handler(struct pt_regs *regs)
 				regs->rip = (unsigned long)p->addr;
 				reset_current_kprobe();
 				ret = 1;
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
-				return 1;
+				break;
+			case KPROBE_HIT_SS:
+				if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+					regs->eflags &= ~TF_MASK;
+					regs->eflags |=
+						kcb->kprobe_saved_eflags;
+				} else {
+					/* BUG? */
+				}
+				break;
+			default:
+				/* impossible cases */
+				BUG();
 			}
 		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-				regs->rip = (unsigned long)addr;
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		}
-		goto no_kprobe;
-	}
+			set_current_kprobe(p, regs, kcb);
+			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
 			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 * Back up over the (now missing) int3 and run
-			 * the original instruction.
+			 * If we have no pre-handler or it returned 0, we
+			 * continue with normal processing.  If we have a
+			 * pre-handler and it returned non-zero, it prepped
+			 * for calling the break_handler below on re-entry
+			 * for jprobe processing, so get out doing nothing
+			 * more here.
 			 */
-			regs->rip = (unsigned long)addr;
+			if (!p->pre_handler || !p->pre_handler(p, regs)) {
+				prepare_singlestep(p, regs);
+				kcb->kprobe_status = KPROBE_HIT_SS;
+			}
 			ret = 1;
 		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
+	} else if (cur) {
+		p = __get_cpu_var(current_kprobe);
+		if (p->break_handler && p->break_handler(p, regs)) {
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_HIT_SS;
+			ret = 1;
+		}
+	} /* else: not a kprobe fault; let the kernel handle it */
 
-no_kprobe:
-	preempt_enable_no_resched();
+	if (!ret)
+		preempt_enable_no_resched();
 	return ret;
 }
 

