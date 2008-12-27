Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYL0HPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYL0HPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 02:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYL0HPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 02:15:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:60269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYL0HPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 02:15:05 -0500
Message-ID: <4955D5C5.90407@kernel.org>
Date: Fri, 26 Dec 2008 23:14:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333	smp_call_function_mask
References: <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226152804.GB5100@linux.vnet.ibm.com> <20081226153318.GA4514@elte.hu> <20081226170452.GC5100@linux.vnet.ibm.com> <20081226181733.GA24439@elte.hu> <20081227071138.GA4530@linux.vnet.ibm.com>
In-Reply-To: <20081227071138.GA4530@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> * Ingo Molnar <mingo@elte.hu> [2008-12-26 19:17:34]:
> 
>> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>>> how about the patch below, does that work too? (after removing 
>>>> Yinghai's patch)
>>> Hi Ingo,
>>>
>>> 	Kernel crashes with the same trace, after the applying the patch.
>> okay, thanks - does the below cleaner variant of Yinghai's patch solve the 
>> problem too?
>>
>> 	Ingo
>>
>> -------------------->
>> From 9c93fc72ec95dc97d65b840978f9d605f4e5823a Mon Sep 17 00:00:00 2001
>> From: Yinghai Lu <yinghai@kernel.org>
>> Date: Fri, 26 Dec 2008 02:05:47 -0800
>> Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions
>>
>> Impact: fix panic on null pointer with sparseirq
>>
>> Some GCC versions seem to inline the weak global function,
>> when that function is empty.
>>
>> Work it around, by putting a barrier into the function.
>>
>> Signed-off-by: Yinghai <yinghai@kernel.org>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  init/main.c         |    9 +++++++++
>>  kernel/irq/handle.c |    3 ++-
>>  2 files changed, 11 insertions(+), 1 deletions(-)
>>
>> diff --git a/init/main.c b/init/main.c
>> index c1f999a..841d2b2 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -531,20 +531,29 @@ static void __init boot_cpu_init(void)
>>  	cpu_set(cpu, cpu_possible_map);
>>  }
>>
>> +/*
>> + * The barriers are needed to keep a GCC bug from optimizing
>> + * away these weak functions:
>> + */
>> +
>>  void __init __weak smp_setup_processor_id(void)
>>  {
>> +	barrier();
>>  }
>>
>>  void __init __weak thread_info_cache_init(void)
>>  {
>> +	barrier();
>>  }
>>
>>  void __init __weak arch_early_irq_init(void)
>>  {
>> +	barrier();
>>  }
>>
>>  void __init __weak early_irq_init(void)
>>  {
>> +	barrier();
>>  	arch_early_irq_init();
>>  }
>>
>> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
>> index 06b05a4..a6d16a4 100644
>> --- a/kernel/irq/handle.c
>> +++ b/kernel/irq/handle.c
>> @@ -86,8 +86,9 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>>  		desc->kstat_irqs = (unsigned int *)ptr;
>>  }
>>
>> -void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
>> +void __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
>>  {
>> +	barrier();
>>  }
>>
>>  static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
>> --
> 
> Hi Ingo,
> 
> 	Kernel still crashes after applying the patch,
> 
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> ACPI: Core revision 20080926
> Setting APIC routing to flat
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff8021f8fd>] add_pin_to_irq_cpu+0x14/0x73

that is interesting, barrier() doesn't work, we do need that printk?

YH
