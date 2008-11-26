Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbYKZIR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbYKZIR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKZIRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:17:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYKZIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:17:50 -0500
Date: Wed, 26 Nov 2008 09:17:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] irq: sparseirq enabling v2
Message-ID: <20081126081724.GK26036@elte.hu>
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492D02A4.4030206@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> impact: new feature sparseirq
> > 
> >> v2: use pointer array instead of hash
> > 
> > ok, this looks pretty good!
> > 
> > A few details:
> > 
> >> +#ifdef CONFIG_SPARSE_IRQ
> >> +#define set_ioapic_affinity_irq set_ioapic_affinity_irq_desc
> >> +#else
> >> +static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
> >> +{
> >> +	struct irq_desc *desc;
> >> +
> >> +	desc = irq_to_desc(irq);
> >> +
> >> +	set_ioapic_affinity_irq_desc(desc, mask);
> >> +}
> >> +#endif
> > 
> > i think this distinction can now go away?.
> 
> i may miss sth in your previous mail. you said we may put full hash 
> back later, so need keep those change to avoid lookup costs later.

full hash as in no NR_IRQS limit?

I dont think that's a good idea even in the far future: we can always 
make NR_IRQS large enough, and turn the current array-of-pointers into 
array-of-arrays-of-pointers scheme or an outright hash - but without 
losing the fundamental abstraction that it's a 0..NR_IRQS array (just 
accessed abstractly).

> also if we need move_irq_desc between node?

i'm not sure i understand. Do you mean we should deallocate and 
reallocate the irq_desc to another node?

> >> +#ifdef CONFIG_SPARSE_IRQ
> >> +	irq_want = nr_irqs;
> >> +#else
> >> +	irq_want = NR_IRQS - 1;
> >> +#endif
> > 
> > ditto. I think we dont want 'nr_irqs' anymore - just remain with 
> > NR_IRQS, right?
> > 
>
> nr_irqs is the total GSI number when sparseirq is used. so MSI irq 
> will start from that. ...

ah, okay. I think we should renumber MSIs to the scheme Thomas 
suggested, independently of CONFIG_SPARSE_IRQ.

CONFIG_SPARSE_IRQ should _only_ impact the irq_desc[] data structure: 
it turns from a flat C array of irq_desc into an array of irq_desc 
pointers.

No other semantic changes. Possibly all hidden away completely in the 
irq-desc-array accessors.

> > Plus in a few more places.
> > 
> > Please look at _every_ #ifdef or #if in your patch in a .c file 
> > and ask the question: can we somehow in some way eliminate it and 
> > convert it to some nice inline somewhere or eliminate it via some 
> > other trick?
> 
> will

thanks!

	Ingo
