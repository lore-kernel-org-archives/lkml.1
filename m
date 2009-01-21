Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZAUJcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZAUJcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZAUJbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:31:52 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:52883 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZAUJbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:31:51 -0500
Message-ID: <4976EB66.2010301@gawab.com>
Date: Wed, 21 Jan 2009 01:31:18 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #12505] 2.6.29-rc1 Firefox crashing on page load
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.C4F.Q9QdJB@chimera> <49756F3E.6050304@gawab.com> <20090120074312.GD16426@elte.hu> <20090120081650.GA29725@elte.hu> <20090120083700.GA5277@elte.hu>
In-Reply-To: <20090120083700.GA5277@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>> (added Cc:s)
>>>       
>>> Justin, does it work if you apply the patch below instead of the revert?
>>>       
>> hm, that patch wont build because the protect_asmlinkage macro is rather 
>> limited - it cannot deal with structure parameters.
>>
>> We might be better off with a revert here, and a comment added that points 
>> out the problem.
>>     
>
> Below is the revert+document commit that i have queued up.
>
> Justin, could you try the tip/master tree (which has this fix included):
>
>   http://people.redhat.com/mingo/tip.git/README
>
> does Firefox still work fine?
>
> 	Ingo
>
> ------------->
> >From 779c9b9f8cb87cdfbd299ee7beb62e50ce139a92 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 20 Jan 2009 09:31:49 +0100
> Subject: [PATCH] Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"
>
> This reverts commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191.
>
> Justin Madru bisected this commit, it was causing weird Firefox
> crashes.
>
> The reason is that GCC mis-optimizes (re-uses) the on-stack parameters of
> the calling frame, which corrupts the syscall return pt_regs state and
> thus corrupts user-space register state.
>
> So we go back to the slightly less clean but more optimization-safe
> method of getting to pt_regs. Also add a comment to explain this.
>
> Resolves: http://bugzilla.kernel.org/show_bug.cgi?id=12505
>
> Reported-and-bisected-by: Justin Madru <jdm64@gawab.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/syscalls.h |    2 +-
>  arch/x86/kernel/signal.c        |   11 +++++++++--
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
> index 9c6797c..c0b0bda 100644
> --- a/arch/x86/include/asm/syscalls.h
> +++ b/arch/x86/include/asm/syscalls.h
> @@ -40,7 +40,7 @@ asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
>  			     struct old_sigaction __user *);
>  asmlinkage int sys_sigaltstack(unsigned long);
>  asmlinkage unsigned long sys_sigreturn(unsigned long);
> -asmlinkage int sys_rt_sigreturn(struct pt_regs);
> +asmlinkage int sys_rt_sigreturn(unsigned long);
>  
>  /* kernel/ioport.c */
>  asmlinkage long sys_iopl(unsigned long);
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index 89bb766..df0587f 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -632,9 +632,16 @@ badframe:
>  }
>  
>  #ifdef CONFIG_X86_32
> -asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
> +/*
> + * Note: do not pass in pt_regs directly as with tail-call optimization
> + * GCC will incorrectly stomp on the caller's frame and corrupt user-space
> + * register state:
> + */
> +asmlinkage int sys_rt_sigreturn(unsigned long __unused)
>  {
> -	return do_rt_sigreturn(&regs);
> +	struct pt_regs *regs = (struct pt_regs *)&__unused;
> +
> +	return do_rt_sigreturn(regs);
>  }
>  #else /* !CONFIG_X86_32 */
>  asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
>
>   
Ok, I officially tested tip/master and firefox is happy it can talk to 
friends with google talk ;-)
Although.... I don't use google talk.... it just seems to be this 
mandatory tab I can't get rid of
on my google page that caused a regression to be noticed so that the 
kernel could be improved!

Justin Madru
