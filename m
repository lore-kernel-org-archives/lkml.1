Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXICKee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXICKee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXICKeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:34:24 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34260
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbXICKeO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:34:14 -0400
Message-Id: <46DBFF65.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 03 Sep 2007 11:34:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: per-CPU double fault TSS and stack
References: <46D42DC7.76E4.0078.0@novell.com>
 <200709011233.12256.ak@suse.de>
In-Reply-To: <200709011233.12256.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 01.09.07 12:33 >>>
>
>Can you cc the next version to Linus please? He's probably best qualified
>to review the i386 double fault handler because he wrote it originally.
>I must admit the code always scared me a bit.

Will do.

>> +#ifdef CONFIG_HOTPLUG_CPU
>> +static void *noinline __init_refok
>> +#else
>> +static inline void *__init
>> +#endif
>
>I really wonder if there isn't a cleaner way to do that :-( These init reference checks
>are starting to become a major annoyance.

They just aren't flexible enough. And no, I can't think of a better way here.

>> +#if N_EXCEPTION_TSS
>> +	unsigned i;
>> +#endif
>
>Would it be that bad to have the TSS even around without CONFIG_DOUBLEFAULT?

It costs 4.xx k space per CPU - perhaps a constraint for embedded?

>In fact I would prefer to just eliminate CONFIG_DOUBLEFAULT (imho 
>it always a bad idea because the amount of code it saves is miniscule) instead of 
>adding such a ifdef maze.

It's configurable for embedded only anyway, and I think there's some value
in allowing it to be configured off for that environment.

>> -#ifdef CONFIG_DOUBLEFAULT
>> -	/* Set up doublefault TSS pointer in the GDT */
>> -	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
>> +#if N_EXCEPTION_TSS
>> +#if EXCEPTION_STACK_ORDER > THREAD_ORDER
>> +#error Assertion failed: EXCEPTION_STACK_ORDER <= THREAD_ORDER
>> +#endif
>
>BUILD_BUG_ON would look nicer

Agreed, will change (this code dates back to pre-BUILD_BUG_ON days).

>> +
>> +		/* Set up exception handling stacks */
>> +#ifdef CONFIG_SMP
>> +		if (cpu) {
>
>If you move the code after the gs pda setup you could use smp_processor_id() and
>avoid the ifdefs (on UP it expands to 0 so the optimizer would do it cleanly)

I'll check if that's feasible.

>> +				BUG_ON(page_count(page));
>> +				init_page_count(page);
>> +				free_pages(stack, j);
>> +				stack += (PAGE_SIZE << j);
>
>In 2.4-aa I added a alloc_pages_exact() for this. I don't think such games should
>be played outside page_alloc.c. I would recommend to readd alloc_pages_exact()
>and then use it.

Will need to track that patch down.

>> -#define DOUBLEFAULT_STACKSIZE (1024)
>> -static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
>> -#define STACK_START (unsigned long)(doublefault_stack+DOUBLEFAULT_STACKSIZE)
>> +extern unsigned long max_low_pfn;
>
>No externs in .c

The question is - is it acceptable to declare max_low_pfn in any header?

>> +#define ptr_ok(x, l) ((x) >= PAGE_OFFSET \
>> +                      && (x) + (l) <= PAGE_OFFSET + max_low_pfn * PAGE_SIZE - 1)
>>  
>> -#define ptr_ok(x) ((x) > PAGE_OFFSET && (x) < PAGE_OFFSET + MAXMEM)
>> +#define THREAD_INFO_FROM(x) ((struct thread_info *)((x) & ~(THREAD_SIZE - 1)))
>>  
>> -static void doublefault_fn(void)
>> +register const struct i386_hw_tss *self __asm__("ebx");
>
>Can't you just move that to a proper argument register in assembler code?

That should be possible, though I can't see anything wrong with the approach
I used.

Jan

