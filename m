Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXE3Vpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXE3Vpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXE3Vpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:45:33 -0400
Received: from waste.org ([66.93.16.53]:60146 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbXE3Vpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:45:31 -0400
Date: Wed, 30 May 2007 16:44:33 -0500
From: Matt Mackall <mpm@selenic.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070530214433.GI11166@waste.org>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530140229.811672406@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:00:34AM -0400, Mathieu Desnoyers wrote:
> Use conditional calls with lower d-cache hit in optimized version as a
> condition for scheduler profiling call.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> ---
>  kernel/profile.c |    4 ++++
>  kernel/sched.c   |    4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/kernel/profile.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/profile.c	2007-05-30 08:42:29.000000000 -0400
> +++ linux-2.6-lttng/kernel/profile.c	2007-05-30 08:45:22.000000000 -0400
> @@ -23,6 +23,7 @@
>  #include <linux/profile.h>
>  #include <linux/highmem.h>
>  #include <linux/mutex.h>
> +#include <linux/condcall.h>
>  #include <asm/sections.h>
>  #include <asm/semaphore.h>
>  #include <asm/irq_regs.h>
> @@ -92,6 +93,8 @@
>  		printk(KERN_INFO "kernel profiling enabled (shift: %ld)\n",
>  			prof_shift);
>  	}
> +	if (prof_on)
> +		BUG_ON(cond_call_arm("profile_on"));
>  	return 1;
>  }
>  __setup("profile=", profile_setup);
> @@ -556,6 +559,7 @@
>  	return 0;
>  out_cleanup:
>  	prof_on = 0;
> +	cond_call_disarm("profile_on");
>  	smp_mb();
>  	on_each_cpu(profile_nop, NULL, 0, 1);
>  	for_each_online_cpu(cpu) {
> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2007-05-30 08:43:02.000000000 -0400
> +++ linux-2.6-lttng/kernel/sched.c	2007-05-30 08:45:22.000000000 -0400
> @@ -59,6 +59,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/delayacct.h>
>  #include <linux/reciprocal_div.h>
> +#include <linux/condcall.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/unistd.h>
> @@ -2990,7 +2991,8 @@
>  			print_irqtrace_events(prev);
>  		dump_stack();
>  	}
> -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> +	cond_call(profile_on,
> +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));

I think we could do better here pretty trivially. profile hit still
has an if (unlikely(prof_on == TYPE)). Shouldn't we just have a
cond_call type for "sched_profiling" and cond_call profile_hits(type,
ip, 1) directly?

-- 
Mathematics is the supreme nostalgia of our time.
