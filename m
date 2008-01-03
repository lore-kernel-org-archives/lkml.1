Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYACSRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYACSRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 13:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYACSRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 13:17:34 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:14410 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYACSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 13:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=aB/HhHq9iM+GXusF/6YMVQhUcBm0nuT0WQLMg6wAsKnWdJnO2wRwCYdSVVNcsI6os2Y5o0s8OdrqxfXNgWv4eHMfy2DGk6XfZXty9Q0ThxxE1GJ7br4HQhF9KyVJs/AP+fIXaRq39nzF12lmQ3otvYtOzTah4PQLuEQodNW43jg=
Message-ID: <477D2595.4060102@gmail.com>
Date: Thu, 03 Jan 2008 23:42:37 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>	 <477BD366.1060504@redhat.com> <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com> <477C08A0.503@redhat.com>
In-Reply-To: <477C08A0.503@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>>> As a result, this function just setups re-entrance.
>> As you've also pointed out in your previous reply, this case is
>> peculiar and therefore I believe it should be marked as a BUG(). I've
>> left the original case, if (kcb->kprobe_status==KPROBE_HIT_SS) &&
>> (*p->ainsn.insn == BREAKPOINT_INSTRUCTION), untouched and is handled
>> as it was before. However, if (kcb->kprobe_status==KPROBE_HIT_SS) &&
>> !(*p->ainsn.insn == BREAKPOINT_INSTRUCTION), then instead of
>> incrementing nmissed count like before, it should cry out a BUG. This
>> is not an ordinary recursive probe handling case which should update
>> the nmissed count.
> 
> Hmm, I can not agree, because it is possible to insert a kprobe
> into kprobe's instruction buffer. If it should be a bug, we must
> check it when registering the kprobe.
> (And also, in *p->ainsn.insn == BREAKPOINT_INSTRUCTION case, I doubt
> that the kernel can handle this "orphaned" breakpoint, because the
> breakpoint address has been changed.)
> 
> Anyway, if you would like to change the logic, please separate it from
> cleanup patch.

Okay. For now, I've restored the original behavior.
 
>>>> -out:
>>>> +     if (!ret)
>>>> +             preempt_enable_no_resched();
>>> I think this is a bit ugly...
>>> Why would you avoid using mutiple "return"s in this function?
>>> I think you can remove "ret" from this function.
>> Hmm...there the are no deeply nested if-elses nor overlapping paths
>> which need to be avoided. All the nested checks unroll cleanly too.
> 
> Oh, I just mentioned about this "if (!ret)" condition.
> Could you try to remove this "ret" variable?
> I think some "ret=1" could be replaced by "return 1" easily.

Done. You should find the desired changed in this patch.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
Signed-off-by: Quentin Barnes <qbarnes@gmail.com>
---

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index a72e02b..06f8d08 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -441,6 +441,34 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
+
+static void __kprobes recursive_singlestep(struct kprobe *p,
+					   struct pt_regs *regs,
+					   struct kprobe_ctlblk *kcb)
+{
+	save_previous_kprobe(kcb);
+	set_current_kprobe(p, regs, kcb);
+	kprobes_inc_nmissed_count(p);
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_REENTER;
+}
+
+static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
+				       struct kprobe_ctlblk *kcb)
+{
+#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+	if (p->ainsn.boostable == 1 && !p->post_handler) {
+		/* Boost up -- we can execute copied instructions directly */
+		reset_current_kprobe();
+		regs->ip = (unsigned long)p->ainsn.insn;
+		preempt_enable_no_resched();
+		return;
+	}
+#endif
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+}
+
 /*
  * We have reentered the kprobe_handler(), since another probe was hit while
  * within the handler. We save the original kprobes variables and just single
@@ -449,13 +477,9 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 				    struct kprobe_ctlblk *kcb)
 {
-	if (kcb->kprobe_status == KPROBE_HIT_SS &&
-	    *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-		regs->flags &= ~X86_EFLAGS_TF;
-		regs->flags |= kcb->kprobe_saved_flags;
-		return 0;
+	switch (kcb->kprobe_status) {
+	case KPROBE_HIT_SSDONE:
 #ifdef CONFIG_X86_64
-	} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 		/* TODO: Provide re-entrancy from post_kprobes_handler() and
 		 * avoid exception stack corruption while single-stepping on
 		 * the instruction of the new probe.
@@ -463,14 +487,26 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
 		arch_disarm_kprobe(p);
 		regs->ip = (unsigned long)p->addr;
 		reset_current_kprobe();
-		return 1;
+		preempt_enable_no_resched();
+		break;
 #endif
+	case KPROBE_HIT_ACTIVE:
+		recursive_singlestep(p, regs, kcb);
+		break;
+	case KPROBE_HIT_SS:
+		if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+			regs->flags &= ~TF_MASK;
+			regs->flags |= kcb->kprobe_saved_flags;
+			return 0;
+		} else {
+			recursive_singlestep(p, regs, kcb);
+		}
+		break;
+	default:
+		/* impossible cases */
+		WARN_ON(1);
 	}
-	save_previous_kprobe(kcb);
-	set_current_kprobe(p, regs, kcb);
-	kprobes_inc_nmissed_count(p);
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_REENTER;
+
 	return 1;
 }
 
@@ -480,83 +516,66 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
  */
 static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
-	struct kprobe *p;
-	int ret = 0;
 	kprobe_opcode_t *addr;
+	struct kprobe *p;
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
 
 	/*
 	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
+	 * duration of kprobe processing. We conditionally
+	 * re-enable preemption at the end of this function,
+	 * and also in reenter_kprobe() and setup_singlestep().
 	 */
 	preempt_disable();
-	kcb = get_kprobe_ctlblk();
 
+	kcb = get_kprobe_ctlblk();
 	p = get_kprobe(addr);
+
 	if (p) {
-		/* Check we're not actually recursing */
 		if (kprobe_running()) {
-			ret = reenter_kprobe(p, regs, kcb);
-			if (kcb->kprobe_status == KPROBE_REENTER)
-			{
-				ret = 1;
-				goto out;
-			}
-			goto preempt_out;
+			if (reenter_kprobe(p, regs, kcb))
+				return 1;
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
-			ret = 1;
-			goto preempt_out;
+			if (!p->pre_handler || !p->pre_handler(p, regs))
+				setup_singlestep(p, regs, kcb);
+			return 1;
 		}
-		if (kprobe_running()) {
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs))
-				goto ss_probe;
+	} else if (kprobe_running()) {
+		p = __get_cpu_var(current_kprobe);
+		if (p->break_handler && p->break_handler(p, regs)) {
+			setup_singlestep(p, regs, kcb);
+			return 1;
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
 	preempt_enable_no_resched();
-out:
-	return ret;
+	return 0;
 }
 
 /*


