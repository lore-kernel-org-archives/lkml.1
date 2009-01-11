Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZAKRu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZAKRu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 12:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZAKRuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 12:50:20 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53818 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbZAKRuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 12:50:19 -0500
Message-ID: <496A314F.8070404@sgi.com>
Date: Sun, 11 Jan 2009 09:50:07 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kstat: modify kstat_irqs_legacy to be variable	sized
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223819.033438000@polaris-admin.engr.sgi.com> <86802c440901102301n5a7bb98ajd44a31ab32ddb726@mail.gmail.com> <20090111121732.GG27796@elte.hu>
In-Reply-To: <20090111121732.GG27796@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On Sat, Jan 10, 2009 at 2:38 PM, Mike Travis <travis@sgi.com> wrote:
>>> Impact: reduce memory usage.
>>>
>>> Allocate kstat_irqs_legacy based on nr_cpu_ids to deal with this
>>> memory usage bump when NR_CPUS bumped from 128 to 4096:
>>>
>>>     8192   +253952    262144 +3100%  kstat_irqs_legacy(.bss)
>>>
>>> This is only when CONFIG_SPARSE_IRQS=y.
>>>
>>> Signed-off-by: Mike Travis <travis@sgi.com>
>>> ---
>>>  kernel/irq/handle.c |    9 ++++++---
>>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> --- linux-2.6-for-ingo.orig/kernel/irq/handle.c
>>> +++ linux-2.6-for-ingo/kernel/irq/handle.c
>>> @@ -124,8 +124,7 @@ static struct irq_desc irq_desc_legacy[N
>>>        }
>>>  };
>>>
>>> -/* FIXME: use bootmem alloc ...*/
>>> -static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
>>> +static unsigned int *kstat_irqs_legacy;
>>>
>>>  int __init early_irq_init(void)
>>>  {
>>> @@ -146,9 +145,13 @@ int __init early_irq_init(void)
>>>        /* allocate irq_desc_ptrs array based on nr_irqs */
>>>        irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
>>>
>>> +       /* allocate based on nr_cpu_ids */
>>> +       kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
>>> +                                         sizeof(int));
>>> +
>>>        for (i = 0; i < legacy_count; i++) {
>>>                desc[i].irq = i;
>>> -               desc[i].kstat_irqs = kstat_irqs_legacy[i];
>>> +               desc[i].kstat_irqs = kstat_irqs_legacy + i * NR_IRQS_LEGACY;
>> here should be
>>
>> +               desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
> 
> indeed - i fixed this in tip/cpus4096.
> 
> 	Ingo

Ahh, I didn't see this.  Thanks Ingo!
