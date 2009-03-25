Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZCYRQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZCYRQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZCYRQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:16:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47334 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbZCYRQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:16:30 -0400
Date: Wed, 25 Mar 2009 18:16:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
Message-ID: <20090325171619.GC14250@elte.hu>
References: <20090325113021.781490788@chello.nl> <20090325113317.104545398@chello.nl> <20090325121811.GC11571@elte.hu> <1237984033.7972.865.camel@twins> <20090325123514.GB28639@elte.hu> <1237984864.7972.896.camel@twins> <20090325125407.GA32744@elte.hu> <1237985832.7972.930.camel@twins> <1237992774.7972.1178.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237992774.7972.1178.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-03-25 at 13:57 +0100, Peter Zijlstra wrote:
> > On Wed, 2009-03-25 at 13:54 +0100, Ingo Molnar wrote:
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > On Wed, 2009-03-25 at 13:35 +0100, Ingo Molnar wrote:
> > > > 
> > > > > > Also, when mixing streams (events,mmap) is a single: you missed 
> > > > > > 'n' events still good?
> > > > > 
> > > > > How would such mixing work? Multiple counters streaming into the 
> > > > > same mmap area?
> > > > 
> > > > No basically having overflow events and mmap-vma changed events in 
> > > > a single output stream.
> > > 
> > > ah, and i missed the impact of variable size records - that too 
> > > makes it somewhat impractical to emit overflow records in situ. (the 
> > > kernel does not really know the precise start of the previous 
> > > record, typically.)
> > 
> > Alternatively, we could simply not emit new events until the read
> > position increases,. that's much simpler.
> > 
> > Still don't like mapping the stuff writable though..
> 
> This is what it would look like I suppose...
> 
> Any thoughts?
> 
> Not-signed-off-by: me

(you dont like it?)

> ---
>  include/linux/perf_counter.h |    4 ++
>  kernel/perf_counter.c        |   67 +++++++++++++++++++++++++++++++++++++----
>  2 files changed, 64 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 6bf67ce..d5a599c 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -165,6 +165,8 @@ struct perf_counter_mmap_page {
>  	__s64	offset;			/* add to hardware counter value */
>  
>  	__u32   data_head;		/* head in the data section */
> +	__u32	data_tail;		/* user-space written tail */
> +	__u32	overflow;		/* number of lost events */

small detail: i'd suggest to always pad things up to 64 bits. In 
case someone adds a new field with u64.

>  };
>  
>  struct perf_event_header {
> @@ -269,8 +271,10 @@ struct file;
>  struct perf_mmap_data {
>  	struct rcu_head			rcu_head;
>  	int				nr_pages;
> +	int				writable;
>  	atomic_t			wakeup;
>  	atomic_t			head;
> +	atomic_t			overflow;
>  	struct perf_counter_mmap_page   *user_page;
>  	void 				*data_pages[0];
>  };
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 3b862a7..1f5c515 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -1330,6 +1330,7 @@ static void __perf_counter_update_userpage(struct perf_counter *counter,
>  		userpg->offset -= atomic64_read(&counter->hw.prev_count);
>  
>  	userpg->data_head = atomic_read(&data->head);
> +	userpg->overflow = atomic_read(&data->overflow);
>  	smp_wmb();
>  	++userpg->lock;
>  	preempt_enable();
> @@ -1375,6 +1376,28 @@ unlock:
>  	return ret;
>  }
>  
> +static int perf_mmap_mkwrite(struct vm_area_struct *vma, struct page *page)
> +{
> +	int ret = -EINVAL;
> +
> +	rcu_read_lock();
> +	data = rcu_dereference(counter->data);
> +	if (!data)
> +		goto unlock;
> +
> +	/*
> +	 * Only allow writes to the control page.
> +	 */
> +	if (page != virt_to_page(data->user_page))
> +		goto unlock;
> +
> +	ret = 0;
> +unlock:
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +

I guess this:

	rcu_read_lock();
	data = rcu_dereference(counter->data);

	/*
	 * Only allow writes to the control page.
	 */
	if (data && (page == virt_to_page(data->user_page))
		ret = 0;

	rcu_read_unlock();

is more compact?

>  static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
>  {
>  	struct perf_mmap_data *data;
> @@ -1463,6 +1486,7 @@ static struct vm_operations_struct perf_mmap_vmops = {
>  	.open = perf_mmap_open,
>  	.close = perf_mmap_close,
>  	.fault = perf_mmap_fault,
> +	.page_mkwrite = perf_mmap_mkwrite,
>  };

(nit: this structure should align vertically)

>  
>  static int perf_mmap(struct file *file, struct vm_area_struct *vma)
> @@ -1473,7 +1497,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  	unsigned long locked, lock_limit;
>  	int ret = 0;
>  
> -	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
> +	if (!(vma->vm_flags & VM_SHARED))
>  		return -EINVAL;
>  
>  	vma_size = vma->vm_end - vma->vm_start;
> @@ -1503,16 +1527,19 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  
>  	mutex_lock(&counter->mmap_mutex);
>  	if (atomic_inc_not_zero(&counter->mmap_count))
> -		goto out;
> +		goto unlock;
>  
>  	WARN_ON(counter->data);
>  	ret = perf_mmap_data_alloc(counter, nr_pages);
> -	if (!ret)
> -		atomic_set(&counter->mmap_count, 1);
> -out:
> +	if (ret)
> +		goto unlock;
> +
> +	atomic_set(&counter->mmap_count, 1);
> +	if (vma->vm_flags & VM_WRITE)
> +		counter->data->writable = 1;
> +unlock:
>  	mutex_unlock(&counter->mmap_mutex);
>  
> -	vma->vm_flags &= ~VM_MAYWRITE;

does ->vm_fflags have VM_MAYWRITE by default?

>  	vma->vm_flags |= VM_RESERVED;
>  	vma->vm_ops = &perf_mmap_vmops;
>  
> @@ -1540,6 +1567,28 @@ struct perf_output_handle {
>  	int			wakeup;
>  };
>  
> +static int perf_output_overflow(struct perf_mmap_data *data,
> +				unsigned int offset, unsigned int head)
> +{
> +	unsigned int tail;
> +	unsigned int mask;
> +
> +	if (!data->writable)
> +		return 0;

so mmap()-ing it readonly turns off overflow detection 
automatically? That's a nice touch i think - user-space can avoid 
this overhead, if it does not care about overflows.

> +	mask = (data->nr_pages << PAGE_SHIFT) - 1;

btw., we could have a data->mask.

> +	smp_rmb();
> +	tail = ACCESS_ONCE(data->user_page->data_tail);
> +
> +	offset = (offset - tail) & mask;
> +	head   = (head   - tail) & mask;
> +
> +	if ((int)(head - offset) < 0)
> +		return 1;
> +
> +	return 0;

I guess it should use bool and return true/false.

> +}
> +
>  static int perf_output_begin(struct perf_output_handle *handle,
>  			     struct perf_counter *counter, unsigned int size)
>  {
> @@ -1552,11 +1601,13 @@ static int perf_output_begin(struct perf_output_handle *handle,
>  		goto out;
>  
>  	if (!data->nr_pages)
> -		goto out;
> +		goto fail;
>  
>  	do {
>  		offset = head = atomic_read(&data->head);
>  		head += size;
> +		if (unlikely(perf_output_overflow(data, offset, head)))
> +			goto fail;
>  	} while (atomic_cmpxchg(&data->head, offset, head) != offset);
>  
>  	handle->counter	= counter;
> @@ -1567,6 +1618,8 @@ static int perf_output_begin(struct perf_output_handle *handle,
>  
>  	return 0;
>  
> +fail:
> +	atomic_inc(&data->overflow);

data->user_page->overflow should be increased too - so that 
user-space can see it.

And do we really need data->overflow?

	Ingo
