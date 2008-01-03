Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYACHF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYACHF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYACHFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:05:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42975 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYACHFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:05:49 -0500
Date: Thu, 3 Jan 2008 12:35:26 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kprobes: Introduce is_kprobe_fault()
Message-ID: <20080103070526.GA7690@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1199333115.6323.104.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199333115.6323.104.camel@brick>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 08:05:14PM -0800, Harvey Harrison wrote:

Thanks for the cleanup...

...

> diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
> index a2273d4..f2e909b 100644
> --- a/arch/x86/mm/fault_32.c
> +++ b/arch/x86/mm/fault_32.c
> @@ -33,28 +33,6 @@
> 
>  extern void die(const char *,struct pt_regs *,long);
> 
> -#ifdef CONFIG_KPROBES
> -static inline int notify_page_fault(struct pt_regs *regs)
> -{
> -	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode_vm(regs)) {
		^^^^^^^^^^^
For x86_32, this check is important. See commit
6444541671bd821b950dbaafee70d65188198aa6 (Never allow int3 traps
from V8086 mode to enter the kprobes handler) for precise reason why its
user_mode_vm() and not user_mode() for x86_32.

You'll need to make room for this check in the generic macro below...

> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 14))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -}
> -#else
> -static inline int notify_page_fault(struct pt_regs *regs)
> -{
> -	return 0;
> -}
> -#endif
> -
>  /*
>   * Return EIP plus the CS segment base.  The segment limit is also
>   * adjusted, clamped to the kernel/user address space (whichever is
> @@ -331,7 +309,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
>  	if (unlikely(address >= TASK_SIZE)) {
>  		if (!(error_code & 0x0000000d) && vmalloc_fault(address) >= 0)
>  			return;
> -		if (notify_page_fault(regs))
> +		if (is_kprobe_fault(regs, 14))
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> @@ -340,7 +318,7 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
>  		goto bad_area_nosemaphore;
>  	}
> 
> -	if (notify_page_fault(regs))
> +	if (is_kprobe_fault(regs, 14))
>  		return;
> 
>  	/* It's safe to allow irq's after cr2 has been saved and the vmalloc

...

> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 8189158..65c1ffb 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -36,6 +36,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
>  #include <linux/mutex.h>
> +#include <linux/hardirq.h>
> 
>  #ifdef CONFIG_KPROBES
>  #include <asm/kprobes.h>
> @@ -203,6 +204,20 @@ static inline struct kprobe *kprobe_running(void)
>  	return (__get_cpu_var(current_kprobe));
>  }
> 
> +/*
> + * If it is a kprobe pagefault we can not be premptible so return before
> + * calling kprobe_running() as it will assert on smp_processor_id if
> + * preemption is enabled.
> + */
> +static inline int is_kprobe_fault(struct pt_regs *regs, int trapnr)
> +{
> +	if (!user_mode(regs) && !preemptible() && kprobe_running() &&
> +	    kprobe_fault_handler(regs, trapnr))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
>  static inline void reset_current_kprobe(void)
>  {
>  	__get_cpu_var(current_kprobe) = NULL;
> @@ -237,6 +252,10 @@ static inline struct kprobe *kprobe_running(void)
>  {
>  	return NULL;
>  }
> +static inline int is_kprobe_fault(struct pt_regs *regs, int trapnr)
> +{
> +	return 0;
> +}
>  static inline int register_kprobe(struct kprobe *p)
>  {
>  	return -ENOSYS;

Ananth
