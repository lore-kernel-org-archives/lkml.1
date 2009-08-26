Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZHZKAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZHZKAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZHZKAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:00:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:41837 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641AbZHZKAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:00:50 -0400
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1251223399.13451.5.camel@penberg-laptop>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
	 <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>
	 <4A94161A.2020609@nets.rwth-aachen.de>
	 <1251219129.4852.1.camel@penberg-laptop>
	 <4A94242E.30309@nets.rwth-aachen.de>
	 <1251223399.13451.5.camel@penberg-laptop>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 19:59:49 +1000
Message-Id: <1251280789.1379.68.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks for testing! Ingo, what do you think of the following patch?
> AFAICT, x86-32 is the only architecture playing with traps in mem_init()
> so this should be the safest fix for 2.6.31.

PowerPC trap_init() is a nop, so Ack.

Cheers,
Ben.

> 			Pekka
> 
> >From b739e3c3baa6312664b4ea676bdf73df27fcecbc Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Tue, 25 Aug 2009 20:55:25 +0300
> Subject: [PATCH] x86: Move WP bit testing to trap_init()
> 
> Commit 83b519e8b9572c319c8e0c615ee5dd7272856090 ("slab: setup allocators
> earlier in the boot sequence") moved trap_init() earlier in the boot
> sequence to avoid a hard crash with 32-bit x86 in mem_init().
> 
> Unfortunately the change broke Xen so make trap_init() later and move
> the WP bit test from mem_init() to trap_init().
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/kernel/traps.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/mm/init_32.c   |   56 ----------------------------------------------
>  init/main.c             |    2 +-
>  3 files changed, 58 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 5204332..2084408 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -906,6 +906,60 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
>  		return;
>  	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
>  }
> +
> +static noinline int do_test_wp_bit(void);
> +
> +/*
> + * Test if the WP bit works in supervisor mode. It isn't supported on 386's
> + * and also on some strange 486's. All 586+'s are OK. This used to involve
> + * black magic jumps to work around some nasty CPU bugs, but fortunately the
> + * switch to using exceptions got rid of all that.
> + */
> +static void __init test_wp_bit(void)
> +{
> +	printk(KERN_INFO
> +  "Checking if this processor honours the WP bit even in supervisor mode...");
> +
> +	/* Any page-aligned address will do, the test is non-destructive */
> +	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_READONLY);
> +	boot_cpu_data.wp_works_ok = do_test_wp_bit();
> +	clear_fixmap(FIX_WP_TEST);
> +
> +	if (!boot_cpu_data.wp_works_ok) {
> +		printk(KERN_CONT "No.\n");
> +#ifdef CONFIG_X86_WP_WORKS_OK
> +		panic(
> +  "This kernel doesn't support CPU's with broken WP. Recompile it for a 386!");
> +#endif
> +	} else {
> +		printk(KERN_CONT "Ok.\n");
> +	}
> +}
> +
> +/*
> + * This function cannot be __init, since exceptions don't work in that
> + * section.  Put this after the callers, so that it cannot be inlined.
> + */
> +static noinline int do_test_wp_bit(void)
> +{
> +	char tmp_reg;
> +	int flag;
> +
> +	__asm__ __volatile__(
> +		"	movb %0, %1	\n"
> +		"1:	movb %1, %0	\n"
> +		"	xorl %2, %2	\n"
> +		"2:			\n"
> +		_ASM_EXTABLE(1b,2b)
> +		:"=m" (*(char *)fix_to_virt(FIX_WP_TEST)),
> +		 "=q" (tmp_reg),
> +		 "=r" (flag)
> +		:"2" (1)
> +		:"memory");
> +
> +	return flag;
> +}
> +
>  #endif
>  
>  void __init trap_init(void)
> @@ -982,5 +1036,8 @@ void __init trap_init(void)
>  
>  #ifdef CONFIG_X86_32
>  	x86_quirk_trap_init();
> +
> +	if (boot_cpu_data.wp_works_ok < 0)
> +		test_wp_bit();
>  #endif
>  }
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 3cd7711..e22bb8a 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -54,8 +54,6 @@
>  
>  unsigned long highstart_pfn, highend_pfn;
>  
> -static noinline int do_test_wp_bit(void);
> -
>  bool __read_mostly __vmalloc_start_set = false;
>  
>  static __init void *alloc_low_page(void)
> @@ -830,33 +828,6 @@ void __init paging_init(void)
>  	zone_sizes_init();
>  }
>  
> -/*
> - * Test if the WP bit works in supervisor mode. It isn't supported on 386's
> - * and also on some strange 486's. All 586+'s are OK. This used to involve
> - * black magic jumps to work around some nasty CPU bugs, but fortunately the
> - * switch to using exceptions got rid of all that.
> - */
> -static void __init test_wp_bit(void)
> -{
> -	printk(KERN_INFO
> -  "Checking if this processor honours the WP bit even in supervisor mode...");
> -
> -	/* Any page-aligned address will do, the test is non-destructive */
> -	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_READONLY);
> -	boot_cpu_data.wp_works_ok = do_test_wp_bit();
> -	clear_fixmap(FIX_WP_TEST);
> -
> -	if (!boot_cpu_data.wp_works_ok) {
> -		printk(KERN_CONT "No.\n");
> -#ifdef CONFIG_X86_WP_WORKS_OK
> -		panic(
> -  "This kernel doesn't support CPU's with broken WP. Recompile it for a 386!");
> -#endif
> -	} else {
> -		printk(KERN_CONT "Ok.\n");
> -	}
> -}
> -
>  static struct kcore_list kcore_mem, kcore_vmalloc;
>  
>  void __init mem_init(void)
> @@ -956,9 +927,6 @@ void __init mem_init(void)
>  	BUG_ON(VMALLOC_START				>= VMALLOC_END);
>  	BUG_ON((unsigned long)high_memory		> VMALLOC_START);
>  
> -	if (boot_cpu_data.wp_works_ok < 0)
> -		test_wp_bit();
> -
>  	save_pg_dir();
>  	zap_low_mappings(true);
>  }
> @@ -975,30 +943,6 @@ int arch_add_memory(int nid, u64 start, u64 size)
>  }
>  #endif
>  
> -/*
> - * This function cannot be __init, since exceptions don't work in that
> - * section.  Put this after the callers, so that it cannot be inlined.
> - */
> -static noinline int do_test_wp_bit(void)
> -{
> -	char tmp_reg;
> -	int flag;
> -
> -	__asm__ __volatile__(
> -		"	movb %0, %1	\n"
> -		"1:	movb %1, %0	\n"
> -		"	xorl %2, %2	\n"
> -		"2:			\n"
> -		_ASM_EXTABLE(1b,2b)
> -		:"=m" (*(char *)fix_to_virt(FIX_WP_TEST)),
> -		 "=q" (tmp_reg),
> -		 "=r" (flag)
> -		:"2" (1)
> -		:"memory");
> -
> -	return flag;
> -}
> -
>  #ifdef CONFIG_DEBUG_RODATA
>  const int rodata_test_data = 0xC3;
>  EXPORT_SYMBOL_GPL(rodata_test_data);
> diff --git a/init/main.c b/init/main.c
> index 2d9d6bd..5c4dacb 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -603,7 +603,6 @@ asmlinkage void __init start_kernel(void)
>  	pidhash_init();
>  	vfs_caches_init_early();
>  	sort_main_extable();
> -	trap_init();
>  	mm_init();
>  	/*
>  	 * Set up the scheduler prior starting any interrupts (such as the
> @@ -621,6 +620,7 @@ asmlinkage void __init start_kernel(void)
>  				"enabled *very* early, fixing it\n");
>  		local_irq_disable();
>  	}
> +	trap_init();
>  	rcu_init();
>  	/* init some links before init_ISA_irqs() */
>  	early_irq_init();

