Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZAJXIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZAJXIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAJXIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:08:12 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36497 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbZAJXIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:08:12 -0500
Message-ID: <49692A50.7010402@sgi.com>
Date: Sat, 10 Jan 2009 15:08:00 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kstat: modify kstat_irqs_legacy to be variable	sized
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223819.033438000@polaris-admin.engr.sgi.com> <20090110225229.GE17917@elte.hu>
In-Reply-To: <20090110225229.GE17917@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Impact: reduce memory usage.
>>
>> Allocate kstat_irqs_legacy based on nr_cpu_ids to deal with this
>> memory usage bump when NR_CPUS bumped from 128 to 4096:
>>
>>      8192   +253952    262144 +3100%  kstat_irqs_legacy(.bss)
>>
>> This is only when CONFIG_SPARSE_IRQS=y.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  kernel/irq/handle.c |    9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> --- linux-2.6-for-ingo.orig/kernel/irq/handle.c
>> +++ linux-2.6-for-ingo/kernel/irq/handle.c
>> @@ -124,8 +124,7 @@ static struct irq_desc irq_desc_legacy[N
>>  	}
>>  };
>>  
>> -/* FIXME: use bootmem alloc ...*/
>> -static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
>> +static unsigned int *kstat_irqs_legacy;
>>  
>>  int __init early_irq_init(void)
>>  {
>> @@ -146,9 +145,13 @@ int __init early_irq_init(void)
>>  	/* allocate irq_desc_ptrs array based on nr_irqs */
>>  	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
>>  
>> +	/* allocate based on nr_cpu_ids */
>> +	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
>> +					  sizeof(int));
>> +
>>  	for (i = 0; i < legacy_count; i++) {
>>  		desc[i].irq = i;
>> -		desc[i].kstat_irqs = kstat_irqs_legacy[i];
>> +		desc[i].kstat_irqs = kstat_irqs_legacy + i * NR_IRQS_LEGACY;
>>  		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
>>  		init_alloc_desc_masks(&desc[i], 0, true);
>>  		irq_desc_ptrs[i] = desc + i;
> 
> btw., while at it - dont we want to upgrade this to a 'long' (in a 
> separate commit)? Having more than 4 billion irqs after bootup is easily 
> possible.
> 
> 	Ingo

Yes, I can do that.  There are two places where it allocated, both for
legacy and dynamically added desc's.

You want basically this, yes?

--- linux-2.6-for-ingo.orig/include/linux/irq.h
+++ linux-2.6-for-ingo/include/linux/irq.h
@@ -162,7 +162,7 @@ struct irq_desc {
        unsigned int            irq;
 #ifdef CONFIG_SPARSE_IRQ
        struct timer_rand_state *timer_rand_state;
-       unsigned int            *kstat_irqs;
+       unsigned long           *kstat_irqs;
 # ifdef CONFIG_INTR_REMAP
        struct irq_2_iommu      *irq_2_iommu;
 # endif


Thanks,
Mike
