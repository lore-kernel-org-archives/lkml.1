Return-Path: <linux-kernel-owner+w=401wt.eu-S965378AbXDGGZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378AbXDGGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 02:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965373AbXDGGZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 02:25:14 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45953 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965371AbXDGGZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 02:25:11 -0400
Date: Fri, 6 Apr 2007 23:25:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: Avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
Message-Id: <20070406232500.3fd84c77.akpm@linux-foundation.org>
In-Reply-To: <20070406214150.GA3545@linux-os.sc.intel.com>
References: <20070406214150.GA3545@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 14:41:50 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> Subject: Avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
> 
> Avoid checking for cpu gone in mm hot path when
> CONFIG_HOTPLUG_CPU is not defined.
> 
> Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> 
> ---
>  arch/i386/kernel/smp.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: work/arch/i386/kernel/smp.c
> ===================================================================
> --- work.orig/arch/i386/kernel/smp.c
> +++ work/arch/i386/kernel/smp.c
> @@ -365,10 +365,12 @@ static void flush_tlb_others(cpumask_t c
>  	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
>  	BUG_ON(!mm);
>  
> +#ifdef CONFIG_HOTPLUG_CPU
>  	/* If a CPU which we ran on has gone down, OK. */
>  	cpus_and(cpumask, cpumask, cpu_online_map);
> -	if (cpus_empty(cpumask))
> +	if (unlikely(cpus_empty(cpumask)))
>  		return;
> +#endif
>  
>  	/*
>  	 * i'm not happy about this global shared spinlock in the

Fair enough.

The code you're touching in with the original CPU-hotplug-for-i386 patches.

x86_64 doesn't do it.  It handles tlb flushing differently anyway.  But I
suspect that x86_64 is just buggy, unless all callers of flush_tlb_others()
have taken care to disable preemption prior to their calculation of the
passed-in cpumask.

Shudder.  Gautham, this is code which we can cheerfully delete when we get
the freezer stuff done.  Fortunately, Anil's patch will make it nice and
easy to find again.

