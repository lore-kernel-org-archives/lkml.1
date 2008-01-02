Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYABSK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYABSK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYABSKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:10:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYABSKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:10:47 -0500
Message-ID: <477BD366.1060504@redhat.com>
Date: Wed, 02 Jan 2008 13:09:42 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com> <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>
In-Reply-To: <477A971A.8030006@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhishek,

Thank you for good work.

Abhishek Sagar wrote:
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

I think setup_singlestep() in your first patch is better, because it avoided
code duplication(*).

> +
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

Why would you modify it?

>  		 * the instruction of the new probe.
>  		 */
>  		arch_disarm_kprobe(p);
>  		regs->ip = (unsigned long)p->addr;
>  		reset_current_kprobe();
> -		return 1;
> +		preempt_enable_no_resched();

I think preepmt_enable here is good idea.

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

If my thought is correct, we don't need to use swich-case here,
Because there are only 2 cases, KPROBE_HIT_SSDONE (x86-64 only)
or others.
As a result, this function just setups re-entrance.

> +	default:
> +		/* impossible cases */
> +		BUG();

I think no need to check that here.

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

I think this block changing would better be separated from this patch,
because it changes code flow logically.

>  
> -	/*
> -	 * We don't want to be preempted for the entire
> -	 * duration of kprobe processing
> -	 */
>  	preempt_disable();
>  	kcb = get_kprobe_ctlblk();
> -
> +	cur = kprobe_running();

I think you don't need "cur", because kprobe_running() is called
just once on each path.

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

(*) duplication 1

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

(*) duplication 2

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

I think this is a bit ugly...
Why would you avoid using mutiple "return"s in this function?
I think you can remove "ret" from this function.

>  	return ret;
>  }
>  
> 

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

