Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYACChu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYACChu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 21:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYACChk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 21:37:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbYACChk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 21:37:40 -0500
Message-ID: <477C4A42.1010701@redhat.com>
Date: Wed, 02 Jan 2008 21:36:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, qbarnes <qbarnes@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: [PATCH] x86: Use is_kprobe_fault to better match usage
References: <1199322323.6323.76.camel@brick>
In-Reply-To: <1199322323.6323.76.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> Currently the notify_page_fault helper is used to test it the page
> fault was caused by a kprobe causing an early return from do_page_fault.
> 
> Change the name of the helper to is_kprobe_fault to match the usage and
> remove the preempt_disable/enable pair around kprobe_running() with an
> explicit test for preemption.  The idea for this comes from a patch
> by Quentin Barnes to kprobes.c

Sure, that's right.
However, since other architectures also have notify_page_fault(),
I think all of those code might better be changed same time for
maintainability.

Thanks,

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Ingo, this may not be functionally equivalent, feel free to yank it out
> if there is any trouble, but from what I've seen it should be OK.
> 
> Did you ever find a good kprobes test?
> 
>  arch/x86/mm/fault_32.c |   30 ++++++++++++++----------------
>  arch/x86/mm/fault_64.c |   30 ++++++++++++++----------------
>  2 files changed, 28 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
> index 051a4ec..5c48cc2 100644
> --- a/arch/x86/mm/fault_32.c
> +++ b/arch/x86/mm/fault_32.c
> @@ -12,6 +12,7 @@
>  #include <linux/mman.h>
>  #include <linux/mm.h>
>  #include <linux/smp.h>
> +#include <linux/hardirq.h>
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/tty.h>
> @@ -42,23 +43,20 @@
>  #define PF_RSVD	(1<<3)
>  #define PF_INSTR	(1<<4)
>  
> -static inline int notify_page_fault(struct pt_regs *regs)
> +static inline int is_kprobe_fault(struct pt_regs *regs)
>  {
> -#ifdef CONFIG_KPROBES
>  	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode_vm(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 14))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -#else
> -	return 0;
> +#ifdef CONFIG_KPROBES
> +	/*
> +	 * If it is a kprobe fault we can not be premptible so return before
> +	 * calling kprobe_running() as it will assert on smp_processor_id if
> +	 * preemption is enabled.
> +	 */
> +	if (!user_mode_vm(regs) && !preemptible() && kprobe_running() &&
> +	    kprobe_fault_handler(regs, 14))
> +		ret = 1;
>  #endif
> +	return ret;
>  }
>  
>  #ifdef CONFIG_X86_32
> @@ -428,7 +426,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  				return;
>  		}
>  #endif
> -		if (notify_page_fault(regs))
> +		if (is_kprobe_fault(regs))
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> @@ -437,7 +435,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		goto bad_area_nosemaphore;
>  	}
>  
> -	if (notify_page_fault(regs))
> +	if (is_kprobe_fault(regs))
>  		return;
>  
>  	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
> diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
> index 97b92b6..09008e5 100644
> --- a/arch/x86/mm/fault_64.c
> +++ b/arch/x86/mm/fault_64.c
> @@ -13,6 +13,7 @@
>  #include <linux/mman.h>
>  #include <linux/mm.h>
>  #include <linux/smp.h>
> +#include <linux/hardirq.h>
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/tty.h>
> @@ -45,23 +46,20 @@
>  #define PF_RSVD	(1<<3)
>  #define PF_INSTR	(1<<4)
>  
> -static inline int notify_page_fault(struct pt_regs *regs)
> +static inline int is_kprobe_fault(struct pt_regs *regs)
>  {
> -#ifdef CONFIG_KPROBES
>  	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 14))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -#else
> -	return 0;
> +#ifdef CONFIG_KPROBES
> +	/*
> +	 * If it is a kprobe fault we can not be premptible so return before
> +	 * calling kprobe_running() as it will assert on smp_processor_id if
> +	 * preemption is enabled.
> +	 */
> +	if (!user_mode_vm(regs) && !preemptible() && kprobe_running() &&
> +	    kprobe_fault_handler(regs, 14))
> +		ret = 1;
>  #endif
> +	return ret;
>  }
>  
>  #ifdef CONFIG_X86_32
> @@ -478,7 +476,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  				return;
>  		}
>  #endif
> -		if (notify_page_fault(regs))
> +		if (is_kprobe_fault(regs))
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> @@ -487,7 +485,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  		goto bad_area_nosemaphore;
>  	}
>  
> -	if (notify_page_fault(regs))
> +	if (is_kprobe_fault(regs))
>  		return;
>  
>  	if (likely(regs->flags & X86_EFLAGS_IF))

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

