Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYKZIDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYKZIDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYKZID0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:03:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:56370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYKZID0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:03:26 -0500
Message-ID: <492D02A4.4030206@kernel.org>
Date: Wed, 26 Nov 2008 00:02:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] irq: sparseirq enabling v2
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu>
In-Reply-To: <20081126074826.GI26036@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> impact: new feature sparseirq
> 
>> v2: use pointer array instead of hash
> 
> ok, this looks pretty good!
> 
> A few details:
> 
>> +#ifdef CONFIG_SPARSE_IRQ
>> +#define set_ioapic_affinity_irq set_ioapic_affinity_irq_desc
>> +#else
>> +static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
>> +{
>> +	struct irq_desc *desc;
>> +
>> +	desc = irq_to_desc(irq);
>> +
>> +	set_ioapic_affinity_irq_desc(desc, mask);
>> +}
>> +#endif
> 
> i think this distinction can now go away?.

i may miss sth in your previous mail. you said we may put full hash back later, so need keep those change to avoid lookup costs later.

also if we need move_irq_desc between node?

>

 ...

> 
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	for (new = irq_want; new < NR_IRQS; new++)
>> +#else
>> +	for (new = irq_want; new > 0; new--)
>> +#endif
> 
> this assymetry seems unnecessary too now i think.
> 
>> +#ifdef CONFIG_SPARSE_IRQ
>> +	irq_want = nr_irqs;
>> +#else
>> +	irq_want = NR_IRQS - 1;
>> +#endif
> 
> ditto. I think we dont want 'nr_irqs' anymore - just remain with 
> NR_IRQS, right?
> 
nr_irqs is the total GSI number when sparseirq is used. so MSI irq will start from that.
...
> 
> Plus in a few more places.
> 
> Please look at _every_ #ifdef or #if in your patch in a .c file and 
> ask the question: can we somehow in some way eliminate it and convert 
> it to some nice inline somewhere or eliminate it via some other trick?

will

YH
