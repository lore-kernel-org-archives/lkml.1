Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZAKCAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZAKCAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZAKCAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:00:31 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40760 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751732AbZAKCAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:00:30 -0500
Message-ID: <496952B1.5070303@sgi.com>
Date: Sat, 10 Jan 2009 18:00:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] irq: initialize nr_irqs based on nr_cpu_ids
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.900264000@polaris-admin.engr.sgi.com> <20090110225010.GD17917@elte.hu>
In-Reply-To: <20090110225010.GD17917@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Impact: Reduce memory usage.
>>
>> This is the second half of the changes to make the irq_desc_ptrs be
>> variable sized based on nr_cpu_ids.  The algorithm is the same as the
>> setting of NR_IRQS except use nr_cpu_ids instead of NR_CPUS.  This is
>> only when CONFIG_SPARSE_IRQS=y.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  kernel/irq/handle.c |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> Files linux-2.6-for-ingo.orig/kernel/irq/.handle.c.swp and linux-2.6-for-ingo/kernel/irq/.handle.c.swp differ
>> --- linux-2.6-for-ingo.orig/kernel/irq/handle.c
>> +++ linux-2.6-for-ingo/kernel/irq/handle.c
>> @@ -133,6 +133,11 @@ int __init early_irq_init(void)
>>  	int legacy_count;
>>  	int i;
>>  
>> +	/* initialize nr_irqs based on nr_cpu_ids */
>> + 	nr_irqs =  (8 * nr_cpu_ids) > (32 * MAX_IO_APICS) ?
>> + 			NR_VECTORS + (8 * nr_cpu_ids) :
>> + 			NR_VECTORS + (32 * MAX_IO_APICS);
>> +
> 
> this will break non-x86. Please move this to the x86 early-irq-init 
> function instead, and also sync it up with the current NR_IRQS sizing 
> macro.
> 
> I.e. do not duplicate the numbers but introduce some sort of 
> max_nr_irqs(nr_cpus) define that is used to initialize NR_IRQS and also 
> used later on to narrow down nr_irqs later on.

The way it is laid out is:

kernel/softirq.c:

	int __init __weak early_irq_init(void)
	{
        	return 0;
	}

kernel/irq/handle.c:

	#ifdef CONFIG_SPARSE_IRQ
	:
	struct irq_desc **irq_desc_ptrs __read_mostly;
	:
	int __init early_irq_init(void)
	{
		:
		nr_irqs = ...

	#else
	:
	struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
	:
	int __init early_irq_init(void)
	{
		<don't set nr_irqs>

So I don't see an x86 specific early_irq_init.

Since NR_IRQS is defined in a lot of different ways (in different places),
I think I'll have to do something like;

arch/x86/include/asm/irq_vectors.h:
	
	#define max_nr_irqs(nr_cpus)	\

include/linux/irqnr.h:

	#ifndef max_nr_irqs
	#define max_nr_irqs(unused)	NR_IRQS
	#endif

Would that work for you?

Thanks,
Mike

