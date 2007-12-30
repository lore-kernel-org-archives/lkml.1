Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXL3IIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXL3IIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 03:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXL3IIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 03:08:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbXL3IId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 03:08:33 -0500
Message-ID: <477751D1.8080909@redhat.com>
Date: Sun, 30 Dec 2007 03:07:45 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198807702.6323.37.camel@brick>
In-Reply-To: <1198807702.6323.37.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Harvey,

Thank you for your great works!

Harvey Harrison wrote:
> Make the control flow of kprobe_handler more obvious.
> 
> Collapse the separate if blocks/gotos with if/else blocks
> this unifies the duplication of the check for a breakpoint
> instruction race with another cpu.

I agree it is good to unify the duplications of
breakpoint checking and get_kprobe() calling.

> 
> Create two jump targets:
> 	preempt_out: re-enables preemption before returning ret
> 	out: only returns ret

However, I'm not sure we should change "no_kprobe".
That label is commonly used in arch/*/kernel/kprobes.c.

And also, I prefer "return 1" to "{ret = 1; goto out;}"
for simplicity.
Or, how about initializing "ret" as 1 instead of 0?

Ananth, Jim,
I'd like to hear your comments on it.

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Masami, noticed a small bug in the previous version in the !p
> case when the breakpoint was the kernel's.  Please review this
> version.
> 
>  arch/x86/kernel/kprobes.c |   60 +++++++++++++++++++++------------------------
>  1 files changed, 28 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 4e33329..f8c7ac1 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -480,32 +480,28 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  	preempt_disable();
>  	kcb = get_kprobe_ctlblk();
>  
> -	/* Check we're not actually recursing */
> -	if (kprobe_running()) {
> -		p = get_kprobe(addr);
> -		if (p) {
> +	p = get_kprobe(addr);
> +	if (p) {
> +		/* Check we're not actually recursing */
> +		if (kprobe_running()) {
>  			ret = reenter_kprobe(p, regs, kcb);
>  			if (kcb->kprobe_status == KPROBE_REENTER)
> -				return 1;
> +			{
> +				ret = 1;
> +				goto out;

I think "return 1" is better.

> +			}
> +			goto preempt_out;
>  		} else {
> -			if (*addr != BREAKPOINT_INSTRUCTION) {
> -			/* The breakpoint instruction was removed by
> -			 * another cpu right after we hit, no further
> -			 * handling of this interrupt is appropriate
> -			 */
> -				regs->ip = (unsigned long)addr;
> +			set_current_kprobe(p, regs, kcb);
> +			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> +			if (p->pre_handler && p->pre_handler(p, regs))
> +			{
> +				/* handler set things up, skip ss setup */
>  				ret = 1;
> -				goto no_kprobe;
> +				goto out;

Ditto.

>  			}
> -			p = __get_cpu_var(current_kprobe);
> -			if (p->break_handler && p->break_handler(p, regs))
> -				goto ss_probe;
>  		}
> -		goto no_kprobe;
> -	}
> -
> -	p = get_kprobe(addr);
> -	if (!p) {
> +	} else {

I think you'd better move "!p" block forward, because
this block means "relatively rare" cases. (sure, I know jprobe uses this block.)

>  		if (*addr != BREAKPOINT_INSTRUCTION) {
>  			/*
>  			 * The breakpoint instruction was removed right
> @@ -518,34 +514,34 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  			 */
>  			regs->ip = (unsigned long)addr;
>  			ret = 1;
> +			goto preempt_out;
> +		}
> +		if (kprobe_running()) {
> +			p = __get_cpu_var(current_kprobe);
> +			if (p->break_handler && p->break_handler(p, regs))
> +				goto ss_probe;
>  		}
>  		/* Not one of ours: let kernel handle it */
> -		goto no_kprobe;
> +		goto preempt_out;
>  	}
>  
> -	set_current_kprobe(p, regs, kcb);
> -	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
> -
> -	if (p->pre_handler && p->pre_handler(p, regs))
> -		/* handler has already set things up, so skip ss setup */
> -		return 1;
> -
>  ss_probe:
> +	ret = 1;
>  #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
>  	if (p->ainsn.boostable == 1 && !p->post_handler) {
>  		/* Boost up -- we can execute copied instructions directly */
>  		reset_current_kprobe();
>  		regs->ip = (unsigned long)p->ainsn.insn;
> -		preempt_enable_no_resched();
> -		return 1;
> +		goto preempt_out;
>  	}
>  #endif
>  	prepare_singlestep(p, regs);
>  	kcb->kprobe_status = KPROBE_HIT_SS;
> -	return 1;
> +	goto out;

I think "return 1" is better.

>  
> -no_kprobe:
> +preempt_out:
>  	preempt_enable_no_resched();
> +out:
>  	return ret;
>  }
>  

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

