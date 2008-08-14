Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbYHNJPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbYHNJPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYHNJPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:15:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbYHNJPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:15:43 -0400
Date: Thu, 14 Aug 2008 02:14:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86: pda_init: fix memory leak with CPU_HOTPLUG
Message-Id: <20080814021452.7c593e2d.akpm@linux-foundation.org>
In-Reply-To: <20080801143611.GK5466@alberich.amd.com>
References: <20080801143611.GK5466@alberich.amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 16:36:11 +0200 Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> pda->irqstackptr is allocated whenever a CPU is set online.
> But it is never freed (or did I miss something?).
> This results in a memory leak of 16 KByte for each CPU offline/online
> cycle.
> 
> Fix is to allocate pda->irqstackptr only once.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/cpu/common_64.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> The leak is not a big deal for normal CPU hotplug usage.
> But when doing lots of CPU offline/online-cycles during stress tests
> this becomes significant.
> 
> Patch is against Linus' git-tree (v2.6.27-rc1-157-gf164ca9).
> 
> 
> Regards,
> 
> Andreas
> 
> diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
> index dd6e3f1..c941397 100644
> --- a/arch/x86/kernel/cpu/common_64.c
> +++ b/arch/x86/kernel/cpu/common_64.c
> @@ -493,17 +493,20 @@ void pda_init(int cpu)
>  		/* others are initialized in smpboot.c */
>  		pda->pcurrent = &init_task;
>  		pda->irqstackptr = boot_cpu_stack;
> +		pda->irqstackptr += IRQSTACKSIZE - 64;
>  	} else {
> -		pda->irqstackptr = (char *)
> -			__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
> -		if (!pda->irqstackptr)
> -			panic("cannot allocate irqstack for cpu %d", cpu);
> +		if (!pda->irqstackptr) {
> +			pda->irqstackptr = (char *)
> +				__get_free_pages(GFP_ATOMIC, IRQSTACK_ORDER);
> +			if (!pda->irqstackptr)
> +				panic("cannot allocate irqstack for cpu %d",
> +				      cpu);
> +			pda->irqstackptr += IRQSTACKSIZE - 64;
> +		}
>  
>  		if (pda->nodenumber == 0 && cpu_to_node(cpu) != NUMA_NO_NODE)
>  			pda->nodenumber = cpu_to_node(cpu);
>  	}
> -
> -	pda->irqstackptr += IRQSTACKSIZE-64;
>  }
>  
>  char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +

It gives one the creeps seeing a trivially-triggerable panic() call in
a non-__init codepath.

And lo, one of pda_init's callers is __init and the other is __cpuinit.
So this function can at least be made __cpuinit().

But if we can still panic the kernel if a GFP_ATOMIC allocation fails
at cpu-hotplug time then that's still a problem.

cpu_init() has the same shortcoming.
