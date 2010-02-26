Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935535Ab0BZIJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:09:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:44823 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935455Ab0BZIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:09:32 -0500
Message-ID: <4B878106.1090007@monstr.eu>
Date: Fri, 26 Feb 2010 09:06:30 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [RFC] microblaze: Support FRAME_POINTER for better backtrace
References: <1267128809-22749-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1267128809-22749-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> Add a FRAME_POINTER option and when it is enabled, use frame pointers
> to walk the stack during a backtrace dump. This eliminates printout of
> confusing "function calls" corresponding to stack values that look like they
> might be return addresses, but aren't.
> 
> This patch is dependent upon
>    [PATCH] microblaze: Begin stack dump with caller of dump_stack()

yes.

> 
> I'm not certain whether the MMU compiler generates frame pointers the same
> way as the noMMU compiler I am using. I'm also not sure what all the 
> ramifications of providing FRAME_POINTER are. It looks like tracing 
> functionality makes use of it. Need someone familiar with these areas
> to comment on the patch.

Firstly I was surprise that you create any frame pointer solution but
1. It is not frame pointer because Microblaze not use it
2. it is just one optimization which could help but IMHO not. Your patch 
expects that every stack frame size has 7/8 (doesn't matter right now) 
items but that's not correct expectation. (Do objdump from vmlinux and 
look at cpu_idle, prom_add_property and others) - that's why I think 
that your patch won't work.
3. The next question is, if we can expect that every function record has 
at least 7/8 items. If yes than look at my function below.
4. One more thing is that function still use kernel_text_address() which 
is silly because we are still not sure if the address there is correct 
or not. It is just checking and if we are using, it is just mean that 
there is any expectation which is not correct.

I did some testing several months/weeks ago and I tried to solve it in 
the same way as you. But found that it is based on any expectation which 
  is not correct.

I know that stack tracing is pain but I am not convinced that this is 
way how to solve it. :-(

Michal




> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
> --- a/arch/microblaze/Kconfig.debug	2010-02-25 13:52:30.000000000 -0600
> +++ b/arch/microblaze/Kconfig.debug	2010-02-25 13:52:49.000000000 -0600
> @@ -26,4 +26,11 @@ config DEBUG_BOOTMEM
>  	depends on DEBUG_KERNEL
>  	bool "Debug BOOTMEM initialization"
>  
> +config FRAME_POINTER
> +	bool "Use frame pointers"
> +	default n
> +	help
> +	  If you say N here, the resulting kernel will be slightly smaller and
> +	  faster. However, stack dumps will be much harder to interpret.
> +

depends on !MMU

>  endmenu
> diff -uprN a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
> --- a/arch/microblaze/kernel/traps.c	2010-02-25 13:50:00.000000000 -0600
> +++ b/arch/microblaze/kernel/traps.c	2010-02-25 13:51:11.000000000 -0600
> @@ -8,6 +8,7 @@
>   * for more details.
>   */
>  
> +#include <generated/autoconf.h>

why? I don't think that this is necessary.

>  #include <linux/kernel.h>
>  #include <linux/kallsyms.h>
>  #include <linux/module.h>
> @@ -44,7 +45,7 @@ void show_trace(struct task_struct *task
>  	printk(KERN_NOTICE "\n");
>  #endif
>  	while (!kstack_end(stack)) {
> -		addr = *stack++;
> +		addr = *stack;
>  		/*
>  		 * If the address is either in the text segment of the
>  		 * kernel, or in the region which contains vmalloc'ed
> @@ -55,6 +56,13 @@ void show_trace(struct task_struct *task
>  		 */
>  		if (kernel_text_address(addr))
>  			print_ip_sym(addr);
> +
> +#if defined(CONFIG_FRAME_POINTER)
> +		/* Fetch the caller's frame pointer */
> +		stack = (unsigned long *) stack[7];

If is calculation correct then some comments, why you use number 7, will 
be necessary.

> +#else
> +		stack++;
> +#endif
>  	}
>  	printk(KERN_NOTICE "\n");
>  
> 

Look at this code which should be better than yours.

   		if (kernel_text_address(addr)) {
   			print_ip_sym(addr);
			/* Fetch the caller's frame pointer */
			stack = (unsigned long *) stack[7];
		}
		stack++;

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
