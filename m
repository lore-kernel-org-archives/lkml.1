Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbXEaOId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbXEaOId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXEaOI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:08:26 -0400
Received: from mx1.suse.de ([195.135.220.2]:43243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbXEaOIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:08:25 -0400
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 19/22] 2.6.22-rc3 perfmon2 : modified x86_64 files
References: <200705291348.l4TDmYaf019853@frankl.hpl.hp.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 17:05:04 +0200
In-Reply-To: <200705291348.l4TDmYaf019853@frankl.hpl.hp.com>
Message-ID: <p73ejkxc9un.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@frankl.hpl.hp.com> writes:

> @@ -557,6 +561,10 @@ static inline void __switch_to_xtra(stru
>  		 */
>  		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
>  	}
> +
> +	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW)
> +	    || test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
> +		pfm_ctxsw(prev_p, next_p);
>  }

I thought we had agreed earlier to put this into single "all uncommon
bits" check first?

>  
>  /*
> @@ -661,7 +669,7 @@ __switch_to(struct task_struct *prev_p, 
>  	 * Now maybe reload the debug registers and handle I/O bitmaps
>  	 */
>  	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW))
> -	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
> +  	    || (task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW))

Similar.

>  		__switch_to_xtra(prev_p, next_p, tss);
>  
>  	/* If the task has used fpu the last 5 timeslices, just do a full
> diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/setup64.c linux-2.6.22/arch/x86_64/kernel/setup64.c
> --- linux-2.6.22.base/arch/x86_64/kernel/setup64.c	2007-05-29 03:17:16.000000000 -0700
> +++ linux-2.6.22/arch/x86_64/kernel/setup64.c	2007-05-29 03:24:14.000000000 -0700
> @@ -11,6 +11,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/bitops.h>
>  #include <linux/module.h>
> +#include <linux/perfmon.h>
>  #include <asm/bootsetup.h>
>  #include <asm/pda.h>
>  #include <asm/pgtable.h>
> @@ -283,4 +284,6 @@ void __cpuinit cpu_init (void)
>  	fpu_init(); 
>  
>  	raw_local_save_flags(kernel_eflags);
> +
> + 	pfm_init_percpu();

Just use a cpu notifier instead. No need to add everybody's per cpu init code here.


>  }
> diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/signal.c linux-2.6.22/arch/x86_64/kernel/signal.c
> --- linux-2.6.22.base/arch/x86_64/kernel/signal.c	2007-05-29 03:17:16.000000000 -0700
> +++ linux-2.6.22/arch/x86_64/kernel/signal.c	2007-05-29 03:24:14.000000000 -0700
> @@ -21,6 +21,7 @@
>  #include <linux/stddef.h>
>  #include <linux/personality.h>
>  #include <linux/compiler.h>
> +#include <linux/perfmon.h>
>  #include <asm/ucontext.h>
>  #include <asm/uaccess.h>
>  #include <asm/i387.h>
> @@ -472,6 +473,10 @@ do_notify_resume(struct pt_regs *regs, v
>  		clear_thread_flag(TIF_SINGLESTEP);
>  	}
>  
> +	/* process perfmon asynchronous work (e.g. block thread or reset) */
> +	if (thread_info_flags & _TIF_PERFMON_WORK)
> +		pfm_handle_work(regs);
> +
>  	/* deal with pending signal delivery */
>  	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
>  		do_signal(regs);
> diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/smpboot.c linux-2.6.22/arch/x86_64/kernel/smpboot.c
> --- linux-2.6.22.base/arch/x86_64/kernel/smpboot.c	2007-05-29 03:17:16.000000000 -0700
> +++ linux-2.6.22/arch/x86_64/kernel/smpboot.c	2007-05-29 03:24:14.000000000 -0700
> @@ -49,6 +49,7 @@
>  #include <linux/mc146818rtc.h>
>  #include <linux/smp.h>
>  #include <linux/kdebug.h>
> +#include <linux/perfmon.h>
>  
>  #include <asm/mtrr.h>
>  #include <asm/pgalloc.h>
> @@ -1043,6 +1044,7 @@ int __cpu_disable(void)
>  	spin_unlock(&vector_lock);
>  	remove_cpu_from_maps();
>  	fixup_irqs(cpu_online_map);
> +	pfm_cpu_disable();

Also cpu notifier.



No compat syscalls? 

-Andi
