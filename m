Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZCYVSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZCYVSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZCYVSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:18:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:47153 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZCYVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:18:11 -0400
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090325171619.GC14250@elte.hu>
References: <20090325113021.781490788@chello.nl>
	 <20090325113317.104545398@chello.nl> <20090325121811.GC11571@elte.hu>
	 <1237984033.7972.865.camel@twins> <20090325123514.GB28639@elte.hu>
	 <1237984864.7972.896.camel@twins> <20090325125407.GA32744@elte.hu>
	 <1237985832.7972.930.camel@twins> <1237992774.7972.1178.camel@twins>
	 <20090325171619.GC14250@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 22:18:02 +0100
Message-Id: <1238015882.3956.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 18:16 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2009-03-25 at 13:57 +0100, Peter Zijlstra wrote:
> > > On Wed, 2009-03-25 at 13:54 +0100, Ingo Molnar wrote:
> > > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > 
> > > > > On Wed, 2009-03-25 at 13:35 +0100, Ingo Molnar wrote:
> > > > > 
> > > > > > > Also, when mixing streams (events,mmap) is a single: you missed 
> > > > > > > 'n' events still good?
> > > > > > 
> > > > > > How would such mixing work? Multiple counters streaming into the 
> > > > > > same mmap area?
> > > > > 
> > > > > No basically having overflow events and mmap-vma changed events in 
> > > > > a single output stream.
> > > > 
> > > > ah, and i missed the impact of variable size records - that too 
> > > > makes it somewhat impractical to emit overflow records in situ. (the 
> > > > kernel does not really know the precise start of the previous 
> > > > record, typically.)
> > > 
> > > Alternatively, we could simply not emit new events until the read
> > > position increases,. that's much simpler.
> > > 
> > > Still don't like mapping the stuff writable though..
> > 
> > This is what it would look like I suppose...
> > 
> > Any thoughts?
> > 
> > Not-signed-off-by: me
> 
> (you dont like it?)

Yeah, I'm still unconvinced we need more than the 'we're loosing data'
bit we already have and don't really like the extra code this
introduces, although it isn't nearly as bad as I initially thought it
would be.

> > ---
> >  include/linux/perf_counter.h |    4 ++
> >  kernel/perf_counter.c        |   67 +++++++++++++++++++++++++++++++++++++----
> >  2 files changed, 64 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> > index 6bf67ce..d5a599c 100644
> > --- a/include/linux/perf_counter.h
> > +++ b/include/linux/perf_counter.h
> > @@ -165,6 +165,8 @@ struct perf_counter_mmap_page {
> >  	__s64	offset;			/* add to hardware counter value */
> >  
> >  	__u32   data_head;		/* head in the data section */
> > +	__u32	data_tail;		/* user-space written tail */
> > +	__u32	overflow;		/* number of lost events */
> 
> small detail: i'd suggest to always pad things up to 64 bits. In 
> case someone adds a new field with u64.

its not a packed struct, so at worst it will result in a hole which can
later be filled. but sure.

> >  };

> > +static int perf_mmap_mkwrite(struct vm_area_struct *vma, struct page *page)
> > +{
> > +	int ret = -EINVAL;
> > +
> > +	rcu_read_lock();
> > +	data = rcu_dereference(counter->data);
> > +	if (!data)
> > +		goto unlock;
> > +
> > +	/*
> > +	 * Only allow writes to the control page.
> > +	 */
> > +	if (page != virt_to_page(data->user_page))
> > +		goto unlock;
> > +
> > +	ret = 0;
> > +unlock:
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> 
> I guess this:
> 
> 	rcu_read_lock();
> 	data = rcu_dereference(counter->data);
> 
> 	/*
> 	 * Only allow writes to the control page.
> 	 */
> 	if (data && (page == virt_to_page(data->user_page))
> 		ret = 0;
> 
> 	rcu_read_unlock();
> 
> is more compact?

Ah, quite.

> >  
> > -	vma->vm_flags &= ~VM_MAYWRITE;
> 
> does ->vm_fflags have VM_MAYWRITE by default?

do_mmap_pgoff() has:

	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;

> > +static int perf_output_overflow(struct perf_mmap_data *data,
> > +				unsigned int offset, unsigned int head)
> > +{
> > +	unsigned int tail;
> > +	unsigned int mask;
> > +
> > +	if (!data->writable)
> > +		return 0;
> 
> so mmap()-ing it readonly turns off overflow detection 
> automatically? That's a nice touch i think - user-space can avoid 
> this overhead, if it does not care about overflows.

Yep.

> > +	mask = (data->nr_pages << PAGE_SHIFT) - 1;
> 
> btw., we could have a data->mask.

I thought about it, couldn't make up my mind about it, its only 2
trivial integer ops.

> > +	smp_rmb();
> > +	tail = ACCESS_ONCE(data->user_page->data_tail);
> > +
> > +	offset = (offset - tail) & mask;
> > +	head   = (head   - tail) & mask;
> > +
> > +	if ((int)(head - offset) < 0)
> > +		return 1;
> > +
> > +	return 0;
> 
> I guess it should use bool and return true/false.
> 
> > +}

Ah, right, we use this new-fangled C99 bool stuff these days ;-)


> > +fail:
> > +	atomic_inc(&data->overflow);
> 
> data->user_page->overflow should be increased too - so that 
> user-space can see it.

Hmm, right, it would need to do that wake-up bit..

> And do we really need data->overflow?

atomic_t isn't really a user exposed typed, the assignment in
update_userpage() seemed like the best solution

