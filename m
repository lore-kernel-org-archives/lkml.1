Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab0BMWmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:42:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:34361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab0BMWmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:42:09 -0500
Message-ID: <4B772A54.1000000@kernel.org>
Date: Sat, 13 Feb 2010 14:40:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical
 flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org> <m1ljexpcjp.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljexpcjp.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 04:04 AM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On 02/12/2010 07:44 PM, Eric W. Biederman wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>
>>>> ---------spareirq radix tree related ----------------
>>>> 94007e8: irq: remove not need bootmem code
>>>> 4b0d3fa: radix: move radix init early
>>>> 56af1a9: sparseirq: change irq_desc_ptrs to static
>>>> b236235: sparseirq: use radix_tree instead of ptrs array
>>>> 5918787: x86: remove arch_probe_nr_irqs
>>>>
>>>> so could reduce nr_irqs limitation for bunch ixgbe...
>>>>
>>>> ---------------x86 logical flat related -----------
>>>> f5954c4: use nr_cpus= to set nr_cpu_ids early
>>>> 7b8d6a9: x86: use num_processors for possible cpus
>>>> d79d1de: x86: make 32bit apic flat to physflat switch like 64bit
>>>
>>> Thanks for keeping this work alive.
>>>
>>> I just skimmed through do_IRQ and I happened to notice that
>>> we have an unnecessary inefficiency that using a radix tree for
>>> irq_to_desc will magnify.
>>>
>>> handle_irq should take an struct irq_desc * instead of a unsigned int irq.
>>>
>>> and the per cpu vector_irq array should become a per cpu vector_desc array.
>>>
>>> As soon as irq_to_desc is more than &irq_desc[irq] this saves us work
>>> and cache line misses  at the cost of a simple code cleanup.
>>>
>>
>> please check
>>
>> Subject: [PATCH] x86: use vector_desc instead of vector_irq
>>
>> Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
>> of handle_irq.
>> use vector_desc to reduce the calling of irq_to_desc.
>>
>> next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>  
>>  #ifdef CONFIG_X86_LOCAL_APIC
>> Index: linux-2.6/arch/x86/lguest/boot.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/lguest/boot.c
>> +++ linux-2.6/arch/x86/lguest/boot.c
>> @@ -819,7 +819,7 @@ static void __init lguest_init_IRQ(void)
>>  
>>  	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
>>  		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
>> -		__get_cpu_var(vector_irq)[i] = i - FIRST_EXTERNAL_VECTOR;
>> +		__get_cpu_var(vector_desc)[i] = irq_to_desc(i - FIRST_EXTERNAL_VECTOR);
>>  		if (i != SYSCALL_VECTOR)
>>  			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
>>  	}
> 
> YH It appears that irq_to_desc_alloc_node has not been called yet
> so the setting of vector_desc needs to move to lguest_setup_irq.

lguest is using sparseirq?

YH
