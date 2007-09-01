Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXIAKeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXIAKeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXIAKdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:33:22 -0400
Received: from mx1.suse.de ([195.135.220.2]:56513 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbXIAKdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:33:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] i386: per-CPU double fault TSS and stack
Date: Sat, 1 Sep 2007 12:33:12 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <46D42DC7.76E4.0078.0@novell.com>
In-Reply-To: <46D42DC7.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011233.12256.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Can you cc the next version to Linus please? He's probably best qualified
to review the i386 double fault handler because he wrote it originally.
I must admit the code always scared me a bit.

> +#ifdef CONFIG_HOTPLUG_CPU
> +static void *noinline __init_refok
> +#else
> +static inline void *__init
> +#endif

I really wonder if there isn't a cleaner way to do that :-( These init reference checks
are starting to become a major annoyance.

> +do_alloc_bootmem(unsigned long size, unsigned long align, unsigned long goal)
> +{
> +	return __alloc_bootmem(size, align, goal);
> +}
> +
>  /*
>   * cpu_init() initializes state that is per-CPU. Some data is already
>   * initialized (naturally) in the bootstrap process, such as the GDT
> @@ -659,6 +669,9 @@ void switch_to_new_gdt(void)
>  void __cpuinit cpu_init(void)
>  {
>  	int cpu = smp_processor_id();
> +#if N_EXCEPTION_TSS
> +	unsigned i;
> +#endif

Would it be that bad to have the TSS even around without CONFIG_DOUBLEFAULT?

In fact I would prefer to just eliminate CONFIG_DOUBLEFAULT (imho 
it always a bad idea because the amount of code it saves is miniscule) instead of 
adding such a ifdef maze.




> -#ifdef CONFIG_DOUBLEFAULT
> -	/* Set up doublefault TSS pointer in the GDT */
> -	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
> +#if N_EXCEPTION_TSS
> +#if EXCEPTION_STACK_ORDER > THREAD_ORDER
> +#error Assertion failed: EXCEPTION_STACK_ORDER <= THREAD_ORDER
> +#endif

BUILD_BUG_ON would look nicer


> +
> +		/* Set up exception handling stacks */
> +#ifdef CONFIG_SMP
> +		if (cpu) {

If you move the code after the gs pda setup you could use smp_processor_id() and
avoid the ifdefs (on UP it expands to 0 so the optimizer would do it cleanly)


> +				BUG_ON(page_count(page));
> +				init_page_count(page);
> +				free_pages(stack, j);
> +				stack += (PAGE_SIZE << j);

In 2.4-aa I added a alloc_pages_exact() for this. I don't think such games should
be played outside page_alloc.c. I would recommend to readd alloc_pages_exact()
and then use it.


> -#define DOUBLEFAULT_STACKSIZE (1024)
> -static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
> -#define STACK_START (unsigned long)(doublefault_stack+DOUBLEFAULT_STACKSIZE)
> +extern unsigned long max_low_pfn;

No externs in .c

> +#define ptr_ok(x, l) ((x) >= PAGE_OFFSET \
> +                      && (x) + (l) <= PAGE_OFFSET + max_low_pfn * PAGE_SIZE - 1)
>  
> -#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + MAXMEM)
> +#define THREAD_INFO_FROM(x) ((struct thread_info *)((x) & ~(THREAD_SIZE - 1)))
>  
> -static void doublefault_fn(void)
> +register const struct i386_hw_tss *self __asm__("ebx");

Can't you just move that to a proper argument register in assembler code?


-Andi
