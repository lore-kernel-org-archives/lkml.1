Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYAATpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYAATpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 14:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYAATpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 14:45:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:24749 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYAATpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 14:45:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=nUDRrI/7oVI6+UwMiyoqPc9iu9cHKJy7AB8FuJk5Tq2Ko/sgqmhydThm0M+XEgPaJoi8kz5KI/DMF7CIZwwkLJpw2FTBwFc+fF8+jsiNswk51ZbzNHKDbLfednMGJ/4ll/fRHeLeulH+490kgjDs/X8Y9RxMeTGg447k2WR5MKU=
Message-ID: <477A971A.8030006@gmail.com>
Date: Wed, 02 Jan 2008 01:10:10 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com> <20080101153558.GJ4434@elte.hu>
In-Reply-To: <20080101153558.GJ4434@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, this patch does not apply to x86.git#mm, due to the fixes, 
> unifications and cleanups done there. Could you send a patch against -mm 
> or against x86.git? (see the tree-fetching instructions below) Thanks,
> 
> 	Ingo
> 
> --------------{ x86.git instructions }---------->
> 
>  git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
>  cd linux-2.6.git
>  git-branch x86
>  git-checkout x86
>  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
> 
> (do subsequent pulls via "git-pull --force", as we frequently rebase the
> git tree. NOTE: this might override your own local changes, so do this
> only if you dont mind about losing thse changes in that tree.)
> 

Thanks for pointing me to the right tree. I have made some code re-arrangements in this one.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
Signed-off-by: Quentin Barnes <qbarnes@gmail.com>
---

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index a72e02b..45adc8e 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -441,6 +441,26 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
+
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+static __always_inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
+{
+	if (p->ainsn.boostable == 1 && !p->post_handler) {
+		/* Boost up -- we can execute copied instructions directly */
+		reset_current_kprobe();
+		regs->ip = (unsigned long)p->ainsn.insn;
+		preempt_enable_no_resched();
+		return 0;
+	}
+	return 1;
+}
+#else
+static __always_inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
+{
+	return 1;
+}
+#endif
+
 /*
  * We have reentered the kprobe_handler(), since another probe was hit while
  * within the handler. We save the original kprobes variables and just single
@@ -449,29 +469,47 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 				    struct kprobe_ctlblk *kcb)
 {
-	if (kcb->kprobe_status == KPROBE_HIT_SS &&
-	    *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-		regs->flags &= ~X86_EFLAGS_TF;
-		regs->flags |= kcb->kprobe_saved_flags;
-		return 0;
+	int ret = 0;
+
+	switch (kcb->kprobe_status) {
+	case KPROBE_HIT_SSDONE:
 #ifdef CONFIG_X86_64
-	} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
-		/* TODO: Provide re-entrancy from post_kprobes_handler() and
-		 * avoid exception stack corruption while single-stepping on
+		/* TODO: Provide re-entrancy from
+		 * post_kprobes_handler() and avoid exception
+		 * stack corruption while single-stepping on
 		 * the instruction of the new probe.
 		 */
 		arch_disarm_kprobe(p);
 		regs->ip = (unsigned long)p->addr;
 		reset_current_kprobe();
-		return 1;
+		preempt_enable_no_resched();
+		ret = 1;
+		break;
 #endif
+	case KPROBE_HIT_ACTIVE:
+		/* a probe has been hit inside a
+		 * user handler */
+		save_previous_kprobe(kcb);
+		set_current_kprobe(p, regs, kcb);
+		kprobes_inc_nmissed_count(p);
+		prepare_singlestep(p, regs);
+		kcb->kprobe_status = KPROBE_REENTER;
+		ret = 1;
+		break;
+	case KPROBE_HIT_SS:
+		if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+			regs->flags &= ~TF_MASK;
+			regs->flags |= kcb->kprobe_saved_flags;
+		} else {
+			/* BUG? */
+		}
+		break;
+	default:
+		/* impossible cases */
+		BUG();
 	}
-	save_previous_kprobe(kcb);
-	set_current_kprobe(p, regs, kcb);
-	kprobes_inc_nmissed_count(p);
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_REENTER;
-	return 1;
+
+	return ret;
 }
 
 /*
@@ -480,82 +518,67 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
  */
 static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
-	struct kprobe *p;
 	int ret = 0;
 	kprobe_opcode_t *addr;
+	struct kprobe *p, *cur;
 	struct kprobe_ctlblk *kcb;
 
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
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
+		regs->ip = (unsigned long)addr;
+		return 1;
+	}
 
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
 	preempt_disable();
 	kcb = get_kprobe_ctlblk();
-
+	cur = kprobe_running();
 	p = get_kprobe(addr);
+
 	if (p) {
-		/* Check we're not actually recursing */
-		if (kprobe_running()) {
+		if (cur) {
 			ret = reenter_kprobe(p, regs, kcb);
-			if (kcb->kprobe_status == KPROBE_REENTER)
-			{
-				ret = 1;
-				goto out;
-			}
-			goto preempt_out;
 		} else {
 			set_current_kprobe(p, regs, kcb);
 			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-			if (p->pre_handler && p->pre_handler(p, regs))
-			{
-				/* handler set things up, skip ss setup */
-				ret = 1;
-				goto out;
-			}
-		}
-	} else {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
+
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
-			regs->ip = (unsigned long)addr;
+			if (!p->pre_handler || !p->pre_handler(p, regs)) {
+				if (setup_boost(p, regs)) {
+					prepare_singlestep(p, regs);
+					kcb->kprobe_status = KPROBE_HIT_SS;
+				}
+			}
 			ret = 1;
-			goto preempt_out;
 		}
-		if (kprobe_running()) {
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs))
-				goto ss_probe;
+	} else if (cur) {
+		p = __get_cpu_var(current_kprobe);
+		if (p->break_handler && p->break_handler(p, regs)) {
+			if (setup_boost(p, regs)) {
+				prepare_singlestep(p, regs);
+				kcb->kprobe_status = KPROBE_HIT_SS;
+			}
+			ret = 1;
 		}
-		/* Not one of ours: let kernel handle it */
-		goto preempt_out;
-	}
+	} /* else: not a kprobe fault; let the kernel handle it */
 
-ss_probe:
-	ret = 1;
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
-	if (p->ainsn.boostable == 1 && !p->post_handler) {
-		/* Boost up -- we can execute copied instructions directly */
-		reset_current_kprobe();
-		regs->ip = (unsigned long)p->ainsn.insn;
-		goto preempt_out;
-	}
-#endif
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	goto out;
-
-preempt_out:
-	preempt_enable_no_resched();
-out:
+	if (!ret)
+		preempt_enable_no_resched();
 	return ret;
 }
 

