Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYKXTXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYKXTXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYKXTXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:23:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:36819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYKXTXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:23:45 -0500
Message-ID: <492AFEF9.609@kernel.org>
Date: Mon, 24 Nov 2008 11:22:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] irq: sparseirq enabling
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu>
In-Reply-To: <20081124144007.GA30725@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> +/*
>> + * Protect the sparse_irqs_free freelist:
>> + */
>> +static DEFINE_SPINLOCK(sparse_irq_lock);
>> +LIST_HEAD(sparse_irqs_head);
>> +
>> +/*
>> + * The sparse irqs are in a hash-table as well, for fast lookup:
>> + */
>> +#define SPARSEIRQHASH_BITS          (13 - 1)
>> +#define SPARSEIRQHASH_SIZE          (1UL << SPARSEIRQHASH_BITS)
>> +#define __sparseirqhashfn(key)      hash_long((unsigned long)key, SPARSEIRQHASH_BITS)
>> +#define sparseirqhashentry(key)     (sparseirqhash_table + __sparseirqhashfn((key)))
>> +
>> +static struct list_head sparseirqhash_table[SPARSEIRQHASH_SIZE];
>> +
> 
>> +struct irq_desc *irq_to_desc(unsigned int irq)
>> +{
>> +	struct irq_desc *desc;
>> +	struct list_head *hash_head;
>> +
>> +	hash_head = sparseirqhashentry(irq);
>> +
>> +	/*
>> +	 * We can walk the hash lockfree, because the hash only
>> +	 * grows, and we are careful when adding entries to the end:
>> +	 */
>> +	list_for_each_entry(desc, hash_head, hash_entry) {
>> +		if (desc->irq == irq)
>> +			return desc;
>> +	}
>> +
>> +	return NULL;
>> +}
> 
> I have talked to Thomas about the current design of sparseirq, and the 
> current code looks pretty good already, but we'd like to suggest one 
> more refinement to the hashing scheme:
> 
> Please simplify it by using a sparse pointers static array instead of 
> a full hash. I.e. do it as a:
> 
>        struct irq_desc *irq_desc_ptrs[NR_IRQS] __read_mostly;
> 
> This can scale up just fine to 4096 CPUs without measurable impact to 
> the kernel image size on x86 distro kernels.
> 
> Data structure rules:
> 
> 1) allocation: an entry would be allocated at IRQ number creation time 
>    - never at any other time. Pure access to the desc returns NULL - 
>    it's atomic and lockless.
> 
> 2) freeing: we never free them. If a system allocates an irq_desc[], 
>    it signals that it uses it. This makes all access lockless.
> 
> 3) lookup: irq_to_desc() just does a simple irq_desc_ptrs[irq]
>    dereference (inlined) - no locking or hash lookup needed. Since 
>    irq_desc_ptrs[] is accessed __read_mostly, this will scale really 
>    well even on NUMA.
> 
> 4) iterators: we still keep NR_IRQS as a limit for the
>    irq_desc_ptrs[] array - but it would never be used directly by any 
>    iteration loop, in generic code.
> 
> 5) bootup, pre-kmalloc irq_desc access: on x86 we should preallocate a 
>    pool of ~32 irq_desc entries for allocation use. This can be a
>    simple static array of struct irq_desc that is fed into the
>    first 32 legacy irq_desc[] slots or so. No bootmem-alloc and
>    no after_bootmem flaggery needed. All SMP init and secondary CPU 
>    irq desc allocation happens after kmalloc is active already - 
>    cleaning up the allocation path.
> 
> 6) limits on x86: please scale NR_IRQS to this rule:
>                max(32*MAX_IO_APICS, 8*NR_CPUS)
> 
>    That gives a minimum of 4096 IRQs on 64-bit systems. On even larger 
>    systems, we scale linearly up to 32K IRQs on 4K CPUs. That should 
>    be more than enough (and it can be increased if really needed).
> 
> Please keep all the irq_desc[] abstraction APIs and cleanups you did 
> so far - they are great. In the far future we can still make irq_desc 
> a full hash if needed - but right now we'll be just fine with such a 
> simpler scheme as well, and scale fine up to 16K CPUs or so.
> 
> This should simplify quite a few things in the sparseirq code.

ok, will change to that. 

1. nr_irqs will be legacy number or GSI numbers. MSI will start to use irq nr from nr_irqs
2. or MSI still to use irq from NR_IRQS - 1, and ... go smaller?

YH
