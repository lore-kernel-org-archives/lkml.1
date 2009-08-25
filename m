Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZHYTeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZHYTeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZHYTeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:34:21 -0400
Received: from claw.goop.org ([74.207.240.146]:59243 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbZHYTeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:34:20 -0400
Message-ID: <4A943CBD.60808@goop.org>
Date: Tue, 25 Aug 2009 12:34:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi>
In-Reply-To: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 12:16, Pekka Enberg wrote:
> Commit 83b519e8b9572c319c8e0c615ee5dd7272856090 ("slab: setup allocators
> earlier in the boot sequence") changed the boot sequence to call
> mem_init() early. Unfortunately Xen is not prepared to handle the WP test at
> that point so we need to make the test run later.
>
> This patch fixes the Xen boot failures reported by Arnd Hannemann.
>   

I don't think this is the real fix, and it seems a bit ugly.  I'm OK
with it as a workaround, but I think it will end up getting reverted if
applied.

    J

> Reported-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> Tested-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/Kconfig      |    5 +++++
>  arch/x86/mm/init_32.c |   10 +++++++---
>  include/linux/mm.h    |    8 ++++++++
>  init/main.c           |    1 +
>  4 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 13ffa5d..b6ff185 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -50,6 +50,7 @@ config X86
>  	select HAVE_KERNEL_BZIP2
>  	select HAVE_KERNEL_LZMA
>  	select HAVE_ARCH_KMEMCHECK
> +	select HAVE_ARCH_MEM_INIT_LATE if X86_32
>  
>  config OUTPUT_FORMAT
>  	string
> @@ -86,6 +87,10 @@ config STACKTRACE_SUPPORT
>  config HAVE_LATENCYTOP_SUPPORT
>  	def_bool y
>  
> +config HAVE_ARCH_MEM_INIT_LATE
> +	def_bool y
> +	depends on X86_32
> +
>  config FAST_CMPXCHG_LOCAL
>  	bool
>  	default y
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 3cd7711..488ed4b 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -956,13 +956,17 @@ void __init mem_init(void)
>  	BUG_ON(VMALLOC_START				>= VMALLOC_END);
>  	BUG_ON((unsigned long)high_memory		> VMALLOC_START);
>  
> -	if (boot_cpu_data.wp_works_ok < 0)
> -		test_wp_bit();
> -
>  	save_pg_dir();
>  	zap_low_mappings(true);
>  }
>  
> +void __init mem_init_late(void)
> +{
> +	/* Interrupts are enabled at this point. */
> +	if (boot_cpu_data.wp_works_ok < 0)
> +		test_wp_bit();
> +}
> +
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  int arch_add_memory(int nid, u64 start, u64 size)
>  {
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9a72cc7..eefcfbe 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1052,6 +1052,14 @@ extern void si_meminfo(struct sysinfo * val);
>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>  extern int after_bootmem;
>  
> +#ifdef CONFIG_HAVE_ARCH_MEM_INIT_LATE
> +extern void mem_init_late(void);
> +#else
> +static inline void mem_init_late(void)
> +{
> +}
> +#endif
> +
>  #ifdef CONFIG_NUMA
>  extern void setup_per_cpu_pageset(void);
>  #else
> diff --git a/init/main.c b/init/main.c
> index 2d9d6bd..45d8dbd 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -643,6 +643,7 @@ asmlinkage void __init start_kernel(void)
>  	set_gfp_allowed_mask(__GFP_BITS_MASK);
>  
>  	kmem_cache_init_late();
> +	mem_init_late();
>  
>  	/*
>  	 * HACK ALERT! This is early. We're enabling the console before
>   

