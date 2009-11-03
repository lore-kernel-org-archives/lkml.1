Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZKCI3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZKCI3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZKCI3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:29:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZKCI3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:29:01 -0500
Date: Tue, 3 Nov 2009 09:28:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for
	threads
Message-ID: <20091103082843.GA27676@elte.hu>
References: <1257233486.22553.6.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257233486.22553.6.camel@wall-e>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefani Seibold <stefani@seibold.net> wrote:

> This patch fix two issues in the procfs stack information on X86_64
> linux. 
> 
> The 32 bit loader compat_do_execve did not store stack start (this was
> figured out by alexey).
> 
> The stack information on a X64_64 kernel always show 0 kbyte stack
> usage, because of a miss implemented KSTK_ESP macro which always return
> -1. The new implementation returns now the right value. 
> 
> The patch is against 2.6.32-rc5-git5.
> 
> Andrew would you so kind to apply this patch?
> 
> Greetings,
> Stefani
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  arch/x86/include/asm/processor.h |    8 +++++++-
>  arch/x86/kernel/process_64.c     |    8 ++++++++
>  fs/compat.c                      |    2 ++
>  3 files changed, 17 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.32-rc5/fs/compat.c	2009-10-16 02:41:50.000000000 +0200
> +++ linux-2.6.32-rc5.new/fs/compat.c	2009-11-02 09:00:52.871909633 +0100
> @@ -1532,6 +1532,8 @@
>  	if (retval < 0)
>  		goto out;
>  
> +	current->stack_start = current->mm->start_stack;
> +
>  	/* execve succeeded */
>  	current->fs->in_exec = 0;
>  	current->in_execve = 0;
> --- linux-2.6.32-rc5/arch/x86/include/asm/processor.h	2009-10-16 02:41:50.000000000 +0200
> +++ linux-2.6.32-rc5.new/arch/x86/include/asm/processor.h	2009-11-02 10:39:47.177909657 +0100
> @@ -1000,7 +1001,13 @@
>  #define thread_saved_pc(t)	(*(unsigned long *)((t)->thread.sp - 8))
>  
>  #define task_pt_regs(tsk)	((struct pt_regs *)(tsk)->thread.sp0 - 1)
> -#define KSTK_ESP(tsk)		-1 /* sorry. doesn't work for syscall. */
> +
> +#ifdef CONFIG_IA32_EMULATION
> +extern unsigned long KSTK_ESP(struct task_struct *task);
> +#else
> +#define KSTK_ESP(task)		((task)->thread.usersp)
> +#endif
> +
>  #endif /* CONFIG_X86_64 */
>  
>  extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
> --- linux-2.6.32-rc5/arch/x86/kernel/process_64.c	2009-10-16 02:41:50.000000000 +0200
> +++ linux-2.6.32-rc5.new/arch/x86/kernel/process_64.c	2009-11-02 10:48:23.614936810 +0100
> @@ -664,3 +669,11 @@
>  	return do_arch_prctl(current, code, addr);
>  }
>  
> +#ifdef CONFIG_IA32_EMULATION
> +unsigned long KSTK_ESP(struct task_struct *task)
> +{
> +	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
> +			(task_pt_regs(task)->sp) : \
> +			((task)->thread.usersp);
> +}
> +#endif

That's quite ugly. The KSTK_ESP() function should be unconditional and 
the #ifdef should be eliminated. If CONFIG_IA32_EMULATION is turned off 
(whichis rare) then TIF_IA32 wont be set so the function should work 
fine.

Thanks,

	Ingo
