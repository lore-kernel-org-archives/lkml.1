Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYAAUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYAAUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYAAUTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:19:43 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:34808 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYAAUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SNuriSSu8Lnca2qE8b+UVOr/Ouj3DBXdz+HpPjaOADY8kFaZdSkSLR8EncMCDlZUBIeXvjBD/YD4ENnCmEs7viiaFTntFPgzuk1h64MzHcGwOmsWuVE/KIi4wCsjF8U+VkGzWrdfVZQ8U9gpt+ZUmEzDGrRa4SOl9yCedm/+39U=
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
In-Reply-To: <477A971A.8030006@gmail.com>
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>
	 <20080101153558.GJ4434@elte.hu>  <477A971A.8030006@gmail.com>
Content-Type: text/plain
Date: Tue, 01 Jan 2008 12:19:37 -0800
Message-Id: <1199218777.6323.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few nitpicks.  I need to look closer at the reenter_kprobe
changes, but it looks like this should lead to clearer flow than
before.  The whole !p/kprobe_running() differences were pretty
twisty before.

On Wed, 2008-01-02 at 01:10 +0530, Abhishek Sagar wrote:
> Thanks for pointing me to the right tree. I have made some code re-arrangements in this one.
> 
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> Signed-off-by: Quentin Barnes <qbarnes@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index a72e02b..45adc8e 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -441,6 +441,26 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
>  	/* Replace the return addr with trampoline addr */
>  	*sara = (unsigned long) &kretprobe_trampoline;
>  }
> +
> +#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
> +static __always_inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
> +{
> +	if (p->ainsn.boostable == 1 && !p->post_handler) {
> +		/* Boost up -- we can execute copied instructions directly */
> +		reset_current_kprobe();
> +		regs->ip = (unsigned long)p->ainsn.insn;
> +		preempt_enable_no_resched();
> +		return 0;
> +	}
> +	return 1;
> +}
> +#else
> +static __always_inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
> +{
> +	return 1;
> +}
> +#endif
> +
In the kernel __always_inline == inline, also I think it's nicer to only
have one function declaration, and then ifdef the body of the function.

Something like:

static inline int setup_boost(struct kprobe *p, struct pt_regs *regs)
{
#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
	if (p->ainsn.boostable == 1 && !p->post_handler) {
		/* Boost up -- we can execute copied instructions directly */
		reset_current_kprobe();
		regs->ip = (unsigned long)p->ainsn.insn;
		preempt_enable_no_resched();
		return 0;
	}
#endif
	return 1;
}

> 
> 
>  /*
>   * We have reentered the kprobe_handler(), since another probe was hit while
>   * within the handler. We save the original kprobes variables and just single
> @@ -449,29 +469,47 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
>  static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
>  				    struct kprobe_ctlblk *kcb)
>  {
> -	if (kcb->kprobe_status == KPROBE_HIT_SS &&
> -	    *p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> -		regs->flags &= ~X86_EFLAGS_TF;
> -		regs->flags |= kcb->kprobe_saved_flags;
> -		return 0;
> +	int ret = 0;
> +
> +	switch (kcb->kprobe_status) {
> +	case KPROBE_HIT_SSDONE:
>  #ifdef CONFIG_X86_64
> -	} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
> -		/* TODO: Provide re-entrancy from post_kprobes_handler() and
> -		 * avoid exception stack corruption while single-stepping on
> +		/* TODO: Provide re-entrancy from
> +		 * post_kprobes_handler() and avoid exception
> +		 * stack corruption while single-stepping on
>  		 * the instruction of the new probe.
>  		 */
>  		arch_disarm_kprobe(p);
>  		regs->ip = (unsigned long)p->addr;
>  		reset_current_kprobe();
> -		return 1;
> +		preempt_enable_no_resched();
> +		ret = 1;
> +		break;
>  #endif
> +	case KPROBE_HIT_ACTIVE:
> +		/* a probe has been hit inside a
> +		 * user handler */
> +		save_previous_kprobe(kcb);
> +		set_current_kprobe(p, regs, kcb);
> +		kprobes_inc_nmissed_count(p);
> +		prepare_singlestep(p, regs);
> +		kcb->kprobe_status = KPROBE_REENTER;
> +		ret = 1;
> +		break;
> +	case KPROBE_HIT_SS:
> +		if (*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
> +			regs->flags &= ~TF_MASK;
> +			regs->flags |= kcb->kprobe_saved_flags;
> +		} else {
> +			/* BUG? */
> +		}
> +		break;
> +	default:
> +		/* impossible cases */
> +		BUG();
>  	}
> -	save_previous_kprobe(kcb);
> -	set_current_kprobe(p, regs, kcb);
> -	kprobes_inc_nmissed_count(p);
> -	prepare_singlestep(p, regs);
> -	kcb->kprobe_status = KPROBE_REENTER;
> -	return 1;
> +
> +	return ret;
>  }
>  
>  /*
> @@ -480,82 +518,67 @@ static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
>   */
>  static int __kprobes kprobe_handler(struct pt_regs *regs)
>  {
> -	struct kprobe *p;
>  	int ret = 0;
>  	kprobe_opcode_t *addr;
> +	struct kprobe *p, *cur;
>  	struct kprobe_ctlblk *kcb;
>  
>  	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
> +	if (*addr != BREAKPOINT_INSTRUCTION) {
> +		/*
> +		 * The breakpoint instruction was removed right
> +		 * after we hit it.  Another cpu has removed
> +		 * either a probepoint or a debugger breakpoint
> +		 * at this address.  In either case, no further
> +		 * handling of this interrupt is appropriate.
> +		 * Back up over the (now missing) int3 and run
> +		 * the original instruction.
> +		 */
> +		regs->ip = (unsigned long)addr;
> +		return 1;
> +	}

This return is fine I guess, but after the preempt_disable() I like
the goto approach as it will be easier to see what paths enable
preemption again and which don't....bonus points if we can move this
to the caller or make sure we reenable in all cases before returning
and pull in the code in the caller that does this for us.

But I guess your approach of using ret to test whether we need to
reenable preemption or not would work as a signal to the caller that
they need to reenable preemption.

>  
> -	/*
> -	 * We don't want to be preempted for the entire
> -	 * duration of kprobe processing
> -	 */
>  	preempt_disable();
>  	kcb = get_kprobe_ctlblk();
> -
> +	cur = kprobe_running();
>  	p = get_kprobe(addr);
> +
>  	if (p) {
> -		/* Check we're not actually recursing */
> -		if (kprobe_running()) {
> +		if (cur) {
>  			ret = reenter_kprobe(p, regs, kcb);
> -			if (kcb->kprobe_status == KPROBE_REENTER)
> -			{
> -				ret = 1;
> -				goto out;
> -			}
> -			goto preempt_out;
>  		} else {
>  			set_current_kprobe(p, regs, kcb);
>  			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> -			if (p->pre_handler && p->pre_handler(p, regs))
> -			{
> -				/* handler set things up, skip ss setup */
> -				ret = 1;
> -				goto out;
> -			}
> -		}
> -	} else {
> -		if (*addr != BREAKPOINT_INSTRUCTION) {
> +
>  			/*
> -			 * The breakpoint instruction was removed right
> -			 * after we hit it.  Another cpu has removed
> -			 * either a probepoint or a debugger breakpoint
> -			 * at this address.  In either case, no further
> -			 * handling of this interrupt is appropriate.
> -			 * Back up over the (now missing) int3 and run
> -			 * the original instruction.
> +			 * If we have no pre-handler or it returned 0, we
> +			 * continue with normal processing.  If we have a
> +			 * pre-handler and it returned non-zero, it prepped
> +			 * for calling the break_handler below on re-entry
> +			 * for jprobe processing, so get out doing nothing
> +			 * more here.
>  			 */
> -			regs->ip = (unsigned long)addr;
> +			if (!p->pre_handler || !p->pre_handler(p, regs)) {
> +				if (setup_boost(p, regs)) {
> +					prepare_singlestep(p, regs);
> +					kcb->kprobe_status = KPROBE_HIT_SS;
> +				}
> +			}
>  			ret = 1;
> -			goto preempt_out;
>  		}
> -		if (kprobe_running()) {
> -			p = __get_cpu_var(current_kprobe);
> -			if (p->break_handler && p->break_handler(p, regs))
> -				goto ss_probe;
> +	} else if (cur) {
> +		p = __get_cpu_var(current_kprobe);
> +		if (p->break_handler && p->break_handler(p, regs)) {
> +			if (setup_boost(p, regs)) {
> +				prepare_singlestep(p, regs);
> +				kcb->kprobe_status = KPROBE_HIT_SS;
> +			}
> +			ret = 1;
>  		}
> -		/* Not one of ours: let kernel handle it */
> -		goto preempt_out;
> -	}
> +	} /* else: not a kprobe fault; let the kernel handle it */
>  
> -ss_probe:
> -	ret = 1;
> -#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
> -	if (p->ainsn.boostable == 1 && !p->post_handler) {
> -		/* Boost up -- we can execute copied instructions directly */
> -		reset_current_kprobe();
> -		regs->ip = (unsigned long)p->ainsn.insn;
> -		goto preempt_out;
> -	}
> -#endif
> -	prepare_singlestep(p, regs);
> -	kcb->kprobe_status = KPROBE_HIT_SS;
> -	goto out;
> -
> -preempt_out:
> -	preempt_enable_no_resched();
> -out:
> +	if (!ret)
> +		preempt_enable_no_resched();
>  	return ret;
>  }
>  

Cheers,

Harvey

