Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXGET7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXGET7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbXGET71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:59:27 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:55091 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXGET70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:59:26 -0400
Date: Thu, 5 Jul 2007 15:54:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "S. P. Prasanna" <prasanna@in.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Ian McDonald <ian.mcdonald@jandi.co.nz>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch 3/3] Text Edit Lock - kprobes i386
Message-ID: <20070705195412.GA31780@Krystal>
References: <20070703163818.785635235@polymtl.ca> <20070703164031.888938670@polymtl.ca> <20070704085403.GA21207@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070704085403.GA21207@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:50:54 up 4 days, 14:33,  4 users,  load average: 1.02, 0.94, 0.88
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This suggestion looks more like a workaround to get rid of a bigger
issue.

If we do that, we have to use CONFIG_* exclusivity for either 
(ro-data protection) or (paravirt, kprobes, immediate values).

One big advantage of my patch is that we can remove weird exclusivity
cases involving paravirt and cpu hotplug, like this one:

-#ifndef CONFIG_KPROBES
-#ifdef CONFIG_HOTPLUG_CPU
-       /* It must still be possible to apply SMP alternatives. */
-       if (num_possible_cpus() <= 1)
-#endif
-       {
-               change_page_attr(virt_to_page(start),
-                                size >> PAGE_SHIFT, PAGE_KERNEL_RX);
-               printk("Write protecting the kernel text: %luk\n", size >> 10);
-               kernel_text_is_ro = 1;
-       }

Mathieu

* S. P. Prasanna (prasanna@in.ibm.com) wrote:
> On Tue, Jul 03, 2007 at 12:38:22PM -0400, Mathieu Desnoyers wrote:
> > Kprobes can use the text edit lock to insure mutual exclusion when edition the
> > code and make sure the pages are writable.
> 
> Linus suggested for splitting ro-data and ro-text; And allow ro-text
> only if kprobes is not configured.
> Please see the discussion thread, URL given below
> http://lkml.org/lkml/2007/6/20/436
> 
> This patch below allows to configure and mark the kernel text and
> kernel data as read-only separately. Also kernel text
> is configured read-only if kprobes is not configured.
> 
> Thanks
> Prasanna
> 
> This patch allows to configure and mark the kernel text and
> kernel data as read-only separately.
> 
> Signed-off-by: Prasanna S P. <prasanna@in.ibm.com>
> 
> 
>  arch/i386/Kconfig.debug |    8 ++++++++
>  arch/i386/mm/init.c     |   22 ++++++++++++++++------
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff -puN arch/i386/Kconfig.debug~mark-kernel-text-data-ro-seperately-i386 arch/i386/Kconfig.debug
> --- linux-2.6.22-rc6/arch/i386/Kconfig.debug~mark-kernel-text-data-ro-seperately-i386	2007-07-04 13:45:24.000000000 +0530
> +++ linux-2.6.22-rc6-prasanna/arch/i386/Kconfig.debug	2007-07-04 13:52:31.000000000 +0530
> @@ -56,6 +56,14 @@ config DEBUG_RODATA
>  	  portion of the kernel code won't be covered by a 2MB TLB anymore.
>  	  If in doubt, say "N".
>  
> +config DEBUG_ROTEXT
> +	bool "Write protect kernel text"
> +	depends on DEBUG_RODATA && !KPROBES
> +	help
> +	  Mark the kernel text as write-protected in the pagetables.
> +	  Only allow this if kprobes is not configured.
> +	  If in doubt, say "N".
> +
>  config 4KSTACKS
>  	bool "Use 4Kb for kernel stacks instead of 8Kb"
>  	depends on DEBUG_KERNEL
> diff -puN arch/i386/mm/init.c~mark-kernel-text-data-ro-seperately-i386 arch/i386/mm/init.c
> --- linux-2.6.22-rc6/arch/i386/mm/init.c~mark-kernel-text-data-ro-seperately-i386	2007-07-04 13:45:24.000000000 +0530
> +++ linux-2.6.22-rc6-prasanna/arch/i386/mm/init.c	2007-07-04 13:51:39.000000000 +0530
> @@ -792,14 +792,11 @@ static int noinline do_test_wp_bit(void)
>  	return flag;
>  }
>  
> -#ifdef CONFIG_DEBUG_RODATA
> -
> -void mark_rodata_ro(void)
> +static inline void mark_rwtext_ro(void)
>  {
>  	unsigned long start = PFN_ALIGN(_text);
>  	unsigned long size = PFN_ALIGN(_etext) - start;
>  
> -#ifndef CONFIG_KPROBES
>  #ifdef CONFIG_HOTPLUG_CPU
>  	/* It must still be possible to apply SMP alternatives. */
>  	if (num_possible_cpus() <= 1)
> @@ -809,9 +806,22 @@ void mark_rodata_ro(void)
>  		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
>  		printk("Write protecting the kernel text: %luk\n", size >> 10);
>  	}
> +
> +	/*
> +	 * global_flush_tlb() will be called after marking the data as readonly.
> +	 */
> +}
> +
> +#ifdef CONFIG_DEBUG_RODATA
> +
> +void mark_rodata_ro(void)
> +{
> +	unsigned long start = PFN_ALIGN(_etext);
> +	unsigned long size = (unsigned long)__end_rodata - start;
> +
> +#ifdef CONFIG_DEBUG_ROTEXT
> +	mark_rwtext_ro();
>  #endif
> -	start += size;
> -	size = (unsigned long)__end_rodata - start;
>  	change_page_attr(virt_to_page(start),
>  	                 size >> PAGE_SHIFT, PAGE_KERNEL_RO);
>  	printk("Write protecting the kernel read-only data: %luk\n",
> 
> _
> -- 
> Prasanna S.P.
> Linux Technology Center
> India Software Labs, IBM Bangalore
> Email: prasanna@in.ibm.com
> Ph: 91-80-41776329

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
