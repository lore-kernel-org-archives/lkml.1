Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZC1UNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZC1UNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 16:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZC1UNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 16:13:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:51342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZC1UNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 16:13:38 -0400
Message-ID: <49CE8499.6080003@kernel.org>
Date: Sat, 28 Mar 2009 13:12:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: remove wrong ifdef
References: <49CDAB27.7050602@kernel.org> <49CDAB6E.90006@kernel.org> <200903281937.48755.rusty@rustcorp.com.au>
In-Reply-To: <200903281937.48755.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 28 March 2009 15:15:34 Yinghai Lu wrote:
>> Impact: fix smp_affinity copying
>>
>> CPUMASKS_OFFSTACK is not defined anywhere.
>> and init_allocate_desc_masks called before it set affinity to all cpus...
>>
>> just remove those #idef to make them get copied
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  include/linux/irq.h |    4 ----
>>  1 file changed, 4 deletions(-)
>>
>> Index: linux-2.6/include/linux/irq.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/irq.h
>> +++ linux-2.6/include/linux/irq.h
>> @@ -468,20 +468,16 @@ static inline bool init_alloc_desc_masks
>>   * @new_desc:	pointer to new irq_desc struct
>>   *
>>   * Insures affinity and pending_masks are copied to new irq_desc.
>> - * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
>> - * irq_desc struct so the copy is redundant.
>>   */
>>  
>>  static inline void init_copy_desc_masks(struct irq_desc *old_desc,
>>  					struct irq_desc *new_desc)
>>  {
>> -#ifdef CONFIG_CPUMASKS_OFFSTACK
>>  	cpumask_copy(new_desc->affinity, old_desc->affinity);
>>  
>>  #ifdef CONFIG_GENERIC_PENDING_IRQ
>>  	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
>>  #endif
>> -#endif
>>  }
>>  
>>  #else /* !CONFIG_SMP */
> 
> Wow, that is supposed to be CONFIG_CPUMASK_OFFSTACK.
> 
> The reason it is there is that we already do the memcpy of old_desc: this
> extra copy is only needed if the cpumasks are external.  But perhaps it's
> an over-optimization.

please check 
[PATCH] irq: correct CPUMASKS_OFFSTACK typo -v2

because init_alloc_desc_masks will set desc->affinity to all cpus even CPUMASK_OFFSET is not set.

-v2 will seperate that function to alloc_desc_masks and init_desc_masks. 

YH
