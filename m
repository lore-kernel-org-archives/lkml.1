Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbZGWOhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbZGWOhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZGWOhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:37:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZGWOhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:37:46 -0400
Date: Thu, 23 Jul 2009 10:37:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH -tip] ring_buffer: redesign lockless algorithm
In-Reply-To: <4A686738.7020408@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907231036480.20997@gandalf.stny.rr.com>
References: <20090619151922.830665788@goodmis.org> <20090619152117.384751340@goodmis.org> <4A686738.7020408@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Jul 2009, Lai Jiangshan wrote:

> 
> The primary problem of current lockless ring_buffer is that:
> It's too complicated. And there are no more than 5 guys in
> the world understand it, I bet. It's not good for
> being maintained and introduces arguments easily.
> 
> The complication comes from that: we always set the LSB.
> This _heavy_ contract brings complication when we fight
> for interrupt and brings the second LSB which brings
> more complication when we fight for interrupt.
> 
> This new design kicks out this heavy contract and moves
> the most complication from write side to read side.
> It largely simplifies the codes.
> 
> The lockless code is almost totally rewritten except
> the code for writer interrupts writer. This new design
> includes just two tight functions.
> 
> rb_switch_head() is for read side, it includes 5 steps.
> rb_push_head() is for write side, it includes 4 steps.
> 
> These 9 steps are carefully designed for safely switching(may spin)
> the head page and pushing(no spin, lockless) head page forward.
> Full describe is in the code.

Hi Lai,

I'm always for simplifying code. I'll take a good look at this patch and 
even run it through the tests I ran my code under. I'll give my comments 
on it later.

Thanks,

-- Steve


> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  ring_buffer.c |  613 +++++++++++++++++-----------------------------------------
>  1 file changed, 184 insertions(+), 429 deletions(-)
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 51633d7..7d88fd9 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -434,6 +434,7 @@ struct ring_buffer_per_cpu {
>  	struct buffer_page		*tail_page;	/* write to tail */
>  	struct buffer_page		*commit_page;	/* committed pages */
>  	struct buffer_page		*reader_page;
> +	atomic_t			push_head;
>  	local_t				commit_overrun;
>  	local_t				overrun;
>  	local_t				entries;
> @@ -533,21 +534,14 @@ EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
>   * during this operation, the reader could end up with the tail.
>   *
>   * We use cmpxchg to help prevent this race. We also do something
> - * special with the page before head. We set the LSB to 1.
> + * special with the page before head. We set the LSB to 1 when
> + * we trying to replace the head page.
>   *
>   * When the writer must push the page forward, it will clear the
> - * bit that points to the head page, move the head, and then set
> - * the bit that points to the new head page.
> + * bit that points to the head page, move the head.
>   *
> - * We also don't want an interrupt coming in and moving the head
> - * page on another writer. Thus we use the second LSB to catch
> - * that too. Thus:
> - *
> - * head->list->prev->next        bit 1          bit 0
> - *                              -------        -------
> - * Normal page                     0              0
> - * Points to head page             0              1
> - * New head page                   1              0
> + * The LSB may be set to a false pointer. So we must use rb_list_head()
> + * to access to any next pointer in write side.
>   *
>   * Note we can not trust the prev pointer of the head page, because:
>   *
> @@ -580,15 +574,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
>   *  temporarially.
>   */
>  
> -#define RB_PAGE_NORMAL		0UL
> -#define RB_PAGE_HEAD		1UL
> -#define RB_PAGE_UPDATE		2UL
> -
> -
> -#define RB_FLAG_MASK		3UL
> -
> -/* PAGE_MOVED is not part of the mask */
> -#define RB_PAGE_MOVED		4UL
> +#define RB_PAGE_SWITCH_HEAD	1UL
> +#define RB_FLAG_MASK		(RB_PAGE_SWITCH_HEAD)
>  
>  /*
>   * rb_list_head - remove any bit
> @@ -601,28 +588,6 @@ static struct list_head *rb_list_head(struct list_head *list)
>  }
>  
>  /*
> - * rb_is_head_page - test if the give page is the head page
> - *
> - * Because the reader may move the head_page pointer, we can
> - * not trust what the head page is (it may be pointing to
> - * the reader page). But if the next page is a header page,
> - * its flags will be non zero.
> - */
> -static int inline
> -rb_is_head_page(struct ring_buffer_per_cpu *cpu_buffer,
> -		struct buffer_page *page, struct list_head *list)
> -{
> -	unsigned long val;
> -
> -	val = (unsigned long)list->next;
> -
> -	if ((val & ~RB_FLAG_MASK) != (unsigned long)&page->list)
> -		return RB_PAGE_MOVED;
> -
> -	return val & RB_FLAG_MASK;
> -}
> -
> -/*
>   * rb_is_reader_page
>   *
>   * The unique thing about the reader page, is that, if the
> @@ -636,108 +601,6 @@ static int rb_is_reader_page(struct buffer_page *page)
>  	return rb_list_head(list->next) != &page->list;
>  }
>  
> -/*
> - * rb_set_list_to_head - set a list_head to be pointing to head.
> - */
> -static void rb_set_list_to_head(struct ring_buffer_per_cpu *cpu_buffer,
> -				struct list_head *list)
> -{
> -	unsigned long *ptr;
> -
> -	ptr = (unsigned long *)&list->next;
> -	*ptr |= RB_PAGE_HEAD;
> -	*ptr &= ~RB_PAGE_UPDATE;
> -}
> -
> -/*
> - * rb_head_page_activate - sets up head page
> - */
> -static void rb_head_page_activate(struct ring_buffer_per_cpu *cpu_buffer)
> -{
> -	struct buffer_page *head;
> -
> -	head = cpu_buffer->head_page;
> -	if (!head)
> -		return;
> -
> -	/*
> -	 * Set the previous list pointer to have the HEAD flag.
> -	 */
> -	rb_set_list_to_head(cpu_buffer, head->list.prev);
> -}
> -
> -static void rb_list_head_clear(struct list_head *list)
> -{
> -	unsigned long *ptr = (unsigned long *)&list->next;
> -
> -	*ptr &= ~RB_FLAG_MASK;
> -}
> -
> -/*
> - * rb_head_page_dactivate - clears head page ptr (for free list)
> - */
> -static void
> -rb_head_page_deactivate(struct ring_buffer_per_cpu *cpu_buffer)
> -{
> -	struct list_head *hd;
> -
> -	/* Go through the whole list and clear any pointers found. */
> -	rb_list_head_clear(cpu_buffer->pages);
> -
> -	list_for_each(hd, cpu_buffer->pages)
> -		rb_list_head_clear(hd);
> -}
> -
> -static int rb_head_page_set(struct ring_buffer_per_cpu *cpu_buffer,
> -			    struct buffer_page *head,
> -			    struct buffer_page *prev,
> -			    int old_flag, int new_flag)
> -{
> -	struct list_head *list;
> -	unsigned long val = (unsigned long)&head->list;
> -	unsigned long ret;
> -
> -	list = &prev->list;
> -
> -	val &= ~RB_FLAG_MASK;
> -
> -	ret = (unsigned long)cmpxchg(&list->next,
> -				     val | old_flag, val | new_flag);
> -
> -	/* check if the reader took the page */
> -	if ((ret & ~RB_FLAG_MASK) != val)
> -		return RB_PAGE_MOVED;
> -
> -	return ret & RB_FLAG_MASK;
> -}
> -
> -static int rb_head_page_set_update(struct ring_buffer_per_cpu *cpu_buffer,
> -				   struct buffer_page *head,
> -				   struct buffer_page *prev,
> -				   int old_flag)
> -{
> -	return rb_head_page_set(cpu_buffer, head, prev,
> -				old_flag, RB_PAGE_UPDATE);
> -}
> -
> -static int rb_head_page_set_head(struct ring_buffer_per_cpu *cpu_buffer,
> -				 struct buffer_page *head,
> -				 struct buffer_page *prev,
> -				 int old_flag)
> -{
> -	return rb_head_page_set(cpu_buffer, head, prev,
> -				old_flag, RB_PAGE_HEAD);
> -}
> -
> -static int rb_head_page_set_normal(struct ring_buffer_per_cpu *cpu_buffer,
> -				   struct buffer_page *head,
> -				   struct buffer_page *prev,
> -				   int old_flag)
> -{
> -	return rb_head_page_set(cpu_buffer, head, prev,
> -				old_flag, RB_PAGE_NORMAL);
> -}
> -
>  static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
>  			       struct buffer_page **bpage)
>  {
> @@ -746,60 +609,171 @@ static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
>  	*bpage = list_entry(p, struct buffer_page, list);
>  }
>  
> -static struct buffer_page *
> -rb_set_head_page(struct ring_buffer_per_cpu *cpu_buffer)
> -{
> -	struct buffer_page *head;
> -	struct buffer_page *page;
> -	struct list_head *list;
> -	int i;
> -
> -	if (RB_WARN_ON(cpu_buffer, !cpu_buffer->head_page))
> -		return NULL;
> -
> -	/* sanity check */
> -	list = cpu_buffer->pages;
> -	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->prev->next) != list))
> -		return NULL;
> -
> -	page = head = cpu_buffer->head_page;
> -	/*
> -	 * It is possible that the writer moves the header behind
> -	 * where we started, and we miss in one loop.
> -	 * A second loop should grab the header, but we'll do
> -	 * three loops just because I'm paranoid.
> -	 */
> -	for (i = 0; i < 3; i++) {
> -		do {
> -			if (rb_is_head_page(cpu_buffer, page, page->list.prev)) {
> -				cpu_buffer->head_page = page;
> -				return page;
> -			}
> -			rb_inc_page(cpu_buffer, &page);
> -		} while (page != head);
> -	}
> -
> -	RB_WARN_ON(cpu_buffer, 1);
> -
> -	return NULL;
> -}
> -
> -static int rb_head_page_replace(struct buffer_page *old,
> -				struct buffer_page *new)
> -{
> -	unsigned long *ptr = (unsigned long *)&old->list.prev->next;
> -	unsigned long val;
> -	unsigned long ret;
> -
> -	val = *ptr & ~RB_FLAG_MASK;
> -	val |= RB_PAGE_HEAD;
> -
> -	ret = cmpxchg(ptr, val, &new->list);
> -
> -	return ret == val;
> -}
> -
>  /*
> + * returns:
> + * 0: success
> + * 1: it's done by other
> + */
> +static int __rb_advance_head(struct ring_buffer_per_cpu *cpu_buffer,
> +		struct buffer_page *head_page)
> +{
> +	struct list_head *next;
> +	struct buffer_page *next_page;
> +	unsigned long *ptr, old, new;
> +
> +	next = rb_list_head(head_page->list.next);
> +	next_page = list_entry(next, struct buffer_page, list);
> +
> +	ptr = (unsigned long *)(void *)&cpu_buffer->head_page;
> +	old = (unsigned long)(void *)head_page;
> +	new = (unsigned long)(void *)next_page;
> +
> +	return !!(cmpxchg(ptr, old, new) != old);
> +}
> +
> +/*
> + * rb_switch_head - switches the head_page with a new page
> + *   swaps the original head_page and new page
> + *   and advances the head page.
> + * returns the original head_page(swapped-out page)
> + */
> +static
> +struct buffer_page *rb_switch_head(struct ring_buffer_per_cpu *cpu_buffer,
> +		struct buffer_page *new_page)
> +{
> +	struct buffer_page *head_page;
> +	unsigned long *ptr, hval, nval;
> +
> +	nval = (unsigned long)(void *)new_page;
> +
> +again:
> +	head_page = ACCESS_ONCE(cpu_buffer->head_page);
> +
> +	/* S-Step1: Set the RB_PAGE_SWITCH_HEAD LSB */
> +	hval = (unsigned long)(void *)head_page | RB_PAGE_SWITCH_HEAD;
> +	ptr = (unsigned long *)(void *)&head_page->list.prev->next;
> +	ACCESS_ONCE(*ptr) = hval;
> +	smp_mb();
> +
> +	/* S-Step2: Synchoronize existing rb_push_head() */
> +	while (atomic_read(&cpu_buffer->push_head))
> +		cpu_relax();
> +
> +	/* S-Step3: Test if we compete at the right place. */
> +	smp_mb();
> +	if (head_page != ACCESS_ONCE(cpu_buffer->head_page)) {
> +		/* clear the bit and try again. */
> +		ACCESS_ONCE(*ptr) = (unsigned long)(void *)head_page;
> +		goto again;
> +	}
> +
> +	/*
> +	 * We should not do S-Step4 when the RB_PAGE_SWITCH_HEAD LSB
> +	 * is not set for the real head_page, otherwise we will win
> +	 * the fight but swap out a WRONG page.
> +	 * P-Step1, P-Step3, P-Step4, S-Step2 and S-Step3 ensure we
> +	 * try again when the head_page is pushed.
> +	 *
> +	 * OK, we can fight now:
> +	 */
> +
> +	/*
> +	 * S-Step4: Atomic Clear the LSB and Sew the new page
> +	 * into ring_buffer.
> +	 */
> +	new_page->list.prev = head_page->list.prev;
> +	new_page->list.next = head_page->list.next;
> +
> +	if (cmpxchg(ptr, hval, nval) != hval)
> +		goto again;
> +	new_page->list.next->prev = &new_page->list;
> +
> +	/* S-Step5: Advance the head page */
> +	__rb_advance_head(cpu_buffer, head_page);
> +
> +	return head_page;
> +}
> +
> +static inline unsigned long rb_page_entries(struct buffer_page *bpage);
> +
> +/*
> + * rb_push_head move the head page forward
> + * returns:
> + * <0: Error
> + * 0: successful move the head forward
> + * 1: it's done by other.
> + *
> + * @tail_page is the prev page of @head_page.
> + * We can not access to page->list.prev in write side.
> + */
> +static int rb_push_head(struct ring_buffer_per_cpu *cpu_buffer,
> +		 struct buffer_page *tail_page, struct buffer_page *head_page)
> +{
> +	unsigned long *ptr, val;
> +	int fail = 0;
> +	int ret = 1;
> +	int entries;
> +
> +	entries = rb_page_entries(head_page);
> +	ptr = (unsigned long *)(void *)&tail_page->list.next;
> +
> +	/* P-Step1: Increase the push_head counter */
> +	atomic_inc(&cpu_buffer->push_head);
> +	smp_mb__after_atomic_inc();
> +
> +	/* P-Step2: Atomic Clear RB_PAGE_SWITCH_HEAD LSB */
> +again:
> +	val = ACCESS_ONCE(*ptr);
> +
> +	if (val & RB_PAGE_SWITCH_HEAD) {
> +		/* fight with the S-Step4 */
> +		if (cmpxchg(ptr, val, val & ~RB_PAGE_SWITCH_HEAD) != val) {
> +			if (head_page != ACCESS_ONCE(cpu_buffer->head_page))
> +				goto out;
> +
> +			/*
> +			 * If this P-Step1 is after S-Step2(other cpu),
> +			 * we may fail once, it's not possible that we fail
> +			 * tiwce or more.
> +			 */
> +			if (RB_WARN_ON(cpu_buffer, fail > 0)) {
> +				ret = -1;
> +				goto out;
> +			}
> +
> +			fail++;
> +			goto again;
> +		}
> +
> +	}
> +
> +	/*
> +	 * It's hell when S-Step1 happen between P-Step2 and P-Step3,
> +	 * we may advance the head page to a swapped-out page. But
> +	 * P-Step1, P-Step4, S-Step2 and S-Step3 ensure rb_switch_head()
> +	 * try again when it happens and save we from the hell.
> +	 */
> +
> +	/* P-Step3: Advance the head page */
> +	ret = __rb_advance_head(cpu_buffer, head_page);
> +
> +	if (!ret) {
> +		/*
> +		 * We advanced the head page, thus
> +		 * it is our responsibility to update
> +		 * the counters.
> +		 */
> +		local_add(entries, &cpu_buffer->overrun);
> +	}
> +
> +out:
> +	/* P-Step4: Decrease the push_head counter */
> +	atomic_dec(&cpu_buffer->push_head);
> +
> +	return ret;
> +}
> +
> +/*
>   * rb_tail_page_update - move the tail page forward
>   *
>   * Returns 1 if moved tail page, 0 if someone else did.
> @@ -907,8 +717,6 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
>  	struct list_head *head = cpu_buffer->pages;
>  	struct buffer_page *bpage, *tmp;
>  
> -	rb_head_page_deactivate(cpu_buffer);
> -
>  	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
>  		return -1;
>  	if (RB_WARN_ON(cpu_buffer, head->prev->next != head))
> @@ -928,8 +736,6 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
>  			return -1;
>  	}
>  
> -	rb_head_page_activate(cpu_buffer);
> -
>  	return 0;
>  }
>  
> @@ -1023,8 +829,6 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
>  		= list_entry(cpu_buffer->pages, struct buffer_page, list);
>  	cpu_buffer->tail_page = cpu_buffer->commit_page = cpu_buffer->head_page;
>  
> -	rb_head_page_activate(cpu_buffer);
> -
>  	return cpu_buffer;
>  
>   fail_free_reader:
> @@ -1042,8 +846,6 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
>  
>  	free_buffer_page(cpu_buffer->reader_page);
>  
> -	rb_head_page_deactivate(cpu_buffer);
> -
>  	if (head) {
>  		list_for_each_entry_safe(bpage, tmp, head, list) {
>  			list_del_init(&bpage->list);
> @@ -1194,8 +996,6 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
>  	atomic_inc(&cpu_buffer->record_disabled);
>  	synchronize_sched();
>  
> -	rb_head_page_deactivate(cpu_buffer);
> -
>  	for (i = 0; i < nr_pages; i++) {
>  		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
>  			return;
> @@ -1227,7 +1027,6 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	synchronize_sched();
>  
>  	spin_lock_irq(&cpu_buffer->reader_lock);
> -	rb_head_page_deactivate(cpu_buffer);
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
> @@ -1513,7 +1312,7 @@ static void rb_inc_iter(struct ring_buffer_iter *iter)
>  	 * to the head page instead of next.
>  	 */
>  	if (iter->head_page == cpu_buffer->reader_page)
> -		iter->head_page = rb_set_head_page(cpu_buffer);
> +		iter->head_page = cpu_buffer->head_page;
>  	else
>  		rb_inc_page(cpu_buffer, &iter->head_page);
>  
> @@ -1557,163 +1356,6 @@ rb_update_event(struct ring_buffer_event *event,
>  	}
>  }
>  
> -/*
> - * rb_handle_head_page - writer hit the head page
> - *
> - * Returns: +1 to retry page
> - *           0 to continue
> - *          -1 on error
> - */
> -static int
> -rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
> -		    struct buffer_page *tail_page,
> -		    struct buffer_page *next_page)
> -{
> -	struct buffer_page *new_head;
> -	int entries;
> -	int type;
> -	int ret;
> -
> -	entries = rb_page_entries(next_page);
> -
> -	/*
> -	 * The hard part is here. We need to move the head
> -	 * forward, and protect against both readers on
> -	 * other CPUs and writers coming in via interrupts.
> -	 */
> -	type = rb_head_page_set_update(cpu_buffer, next_page, tail_page,
> -				       RB_PAGE_HEAD);
> -
> -	/*
> -	 * type can be one of four:
> -	 *  NORMAL - an interrupt already moved it for us
> -	 *  HEAD   - we are the first to get here.
> -	 *  UPDATE - we are the interrupt interrupting
> -	 *           a current move.
> -	 *  MOVED  - a reader on another CPU moved the next
> -	 *           pointer to its reader page. Give up
> -	 *           and try again.
> -	 */
> -
> -	switch (type) {
> -	case RB_PAGE_HEAD:
> -		/*
> -		 * We changed the head to UPDATE, thus
> -		 * it is our responsibility to update
> -		 * the counters.
> -		 */
> -		local_add(entries, &cpu_buffer->overrun);
> -
> -		/*
> -		 * The entries will be zeroed out when we move the
> -		 * tail page.
> -		 */
> -
> -		/* still more to do */
> -		break;
> -
> -	case RB_PAGE_UPDATE:
> -		/*
> -		 * This is an interrupt that interrupt the
> -		 * previous update. Still more to do.
> -		 */
> -		break;
> -	case RB_PAGE_NORMAL:
> -		/*
> -		 * An interrupt came in before the update
> -		 * and processed this for us.
> -		 * Nothing left to do.
> -		 */
> -		return 1;
> -	case RB_PAGE_MOVED:
> -		/*
> -		 * The reader is on another CPU and just did
> -		 * a swap with our next_page.
> -		 * Try again.
> -		 */
> -		return 1;
> -	default:
> -		RB_WARN_ON(cpu_buffer, 1); /* WTF??? */
> -		return -1;
> -	}
> -
> -	/*
> -	 * Now that we are here, the old head pointer is
> -	 * set to UPDATE. This will keep the reader from
> -	 * swapping the head page with the reader page.
> -	 * The reader (on another CPU) will spin till
> -	 * we are finished.
> -	 *
> -	 * We just need to protect against interrupts
> -	 * doing the job. We will set the next pointer
> -	 * to HEAD. After that, we set the old pointer
> -	 * to NORMAL, but only if it was HEAD before.
> -	 * otherwise we are an interrupt, and only
> -	 * want the outer most commit to reset it.
> -	 */
> -	new_head = next_page;
> -	rb_inc_page(cpu_buffer, &new_head);
> -
> -	ret = rb_head_page_set_head(cpu_buffer, new_head, next_page,
> -				    RB_PAGE_NORMAL);
> -
> -	/*
> -	 * Valid returns are:
> -	 *  HEAD   - an interrupt came in and already set it.
> -	 *  NORMAL - One of two things:
> -	 *            1) We really set it.
> -	 *            2) A bunch of interrupts came in and moved
> -	 *               the page forward again.
> -	 */
> -	switch (ret) {
> -	case RB_PAGE_HEAD:
> -	case RB_PAGE_NORMAL:
> -		/* OK */
> -		break;
> -	default:
> -		RB_WARN_ON(cpu_buffer, 1);
> -		return -1;
> -	}
> -
> -	/*
> -	 * It is possible that an interrupt came in,
> -	 * set the head up, then more interrupts came in
> -	 * and moved it again. When we get back here,
> -	 * the page would have been set to NORMAL but we
> -	 * just set it back to HEAD.
> -	 *
> -	 * How do you detect this? Well, if that happened
> -	 * the tail page would have moved.
> -	 */
> -	if (ret == RB_PAGE_NORMAL) {
> -		/*
> -		 * If the tail had moved passed next, then we need
> -		 * to reset the pointer.
> -		 */
> -		if (cpu_buffer->tail_page != tail_page &&
> -		    cpu_buffer->tail_page != next_page)
> -			rb_head_page_set_normal(cpu_buffer, new_head,
> -						next_page,
> -						RB_PAGE_HEAD);
> -	}
> -
> -	/*
> -	 * If this was the outer most commit (the one that
> -	 * changed the original pointer from HEAD to UPDATE),
> -	 * then it is up to us to reset it to NORMAL.
> -	 */
> -	if (type == RB_PAGE_HEAD) {
> -		ret = rb_head_page_set_normal(cpu_buffer, next_page,
> -					      tail_page,
> -					      RB_PAGE_UPDATE);
> -		if (RB_WARN_ON(cpu_buffer,
> -			       ret != RB_PAGE_UPDATE))
> -			return -1;
> -	}
> -
> -	return 0;
> -}
> -
>  static unsigned rb_calculate_event_length(unsigned length)
>  {
>  	struct ring_buffer_event event; /* Used only for sizeof array */
> @@ -1793,6 +1435,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  	     struct buffer_page *tail_page, u64 *ts)
>  {
>  	struct ring_buffer *buffer = cpu_buffer->buffer;
> +	struct buffer_page *head_page;
>  	struct buffer_page *next_page;
>  	int ret;
>  
> @@ -1824,7 +1467,8 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  	 * the buffer, unless the commit page is still on the
>  	 * reader page.
>  	 */
> -	if (rb_is_head_page(cpu_buffer, next_page, &tail_page->list)) {
> +	head_page = ACCESS_ONCE(cpu_buffer->head_page);
> +	if (next_page == head_page) {
>  
>  		/*
>  		 * If the commit is not on the reader page, then
> @@ -1838,9 +1482,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  			if (!(buffer->flags & RB_FL_OVERWRITE))
>  				goto out_reset;
>  
> -			ret = rb_handle_head_page(cpu_buffer,
> -						  tail_page,
> -						  next_page);
> +			ret = rb_push_head(cpu_buffer, tail_page, head_page);
>  			if (ret < 0)
>  				goto out_reset;
>  			if (ret)
> @@ -1856,10 +1498,8 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  			 * Note, if the tail page is also the on the
>  			 * reader_page, we let it move out.
>  			 */
> -			if (unlikely((cpu_buffer->commit_page !=
> -				      cpu_buffer->tail_page) &&
> -				     (cpu_buffer->commit_page ==
> -				      cpu_buffer->reader_page))) {
> +			if (unlikely(cpu_buffer->commit_page !=
> +				     cpu_buffer->tail_page)) {
>  				local_inc(&cpu_buffer->commit_overrun);
>  				goto out_reset;
>  			}
> @@ -2468,13 +2108,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_write);
>  static int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
>  {
>  	struct buffer_page *reader = cpu_buffer->reader_page;
> -	struct buffer_page *head = rb_set_head_page(cpu_buffer);
> +	struct buffer_page *head = cpu_buffer->head_page;
>  	struct buffer_page *commit = cpu_buffer->commit_page;
>  
> -	/* In case of error, head will be NULL */
> -	if (unlikely(!head))
> -		return 1;
> -
>  	return reader->read == rb_page_commit(reader) &&
>  		(commit == reader ||
>  		 (commit == head &&
> @@ -2666,9 +2302,7 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
>  
>  	/* Iterator usage is expected to have record disabled */
>  	if (list_empty(&cpu_buffer->reader_page->list)) {
> -		iter->head_page = rb_set_head_page(cpu_buffer);
> -		if (unlikely(!iter->head_page))
> -			return;
> +		iter->head_page = cpu_buffer->head_page;
>  		iter->head = iter->head_page->read;
>  	} else {
>  		iter->head_page = cpu_buffer->reader_page;
> @@ -2786,7 +2420,6 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	struct buffer_page *reader = NULL;
>  	unsigned long flags;
>  	int nr_loops = 0;
> -	int ret;
>  
>  	local_irq_save(flags);
>  	__raw_spin_lock(&cpu_buffer->lock);
> @@ -2826,50 +2459,12 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	local_set(&cpu_buffer->reader_page->entries, 0);
>  	local_set(&cpu_buffer->reader_page->page->commit, 0);
>  
> - spin:
> -	/*
> -	 * Splice the empty reader page into the list around the head.
> -	 */
> -	reader = rb_set_head_page(cpu_buffer);
> -	cpu_buffer->reader_page->list.next = reader->list.next;
> -	cpu_buffer->reader_page->list.prev = reader->list.prev;
> +	cpu_buffer->pages = &cpu_buffer->reader_page->list;
>  
>  	/*
> -	 * cpu_buffer->pages just needs to point to the buffer, it
> -	 *  has no specific buffer page to point to. Lets move it out
> -	 *  of our way so we don't accidently swap it.
> -	 */
> -	cpu_buffer->pages = reader->list.prev;
> -
> -	/* The reader page will be pointing to the new head */
> -	rb_set_list_to_head(cpu_buffer, &cpu_buffer->reader_page->list);
> -
> -	/*
> -	 * Here's the tricky part.
> -	 *
> -	 * We need to move the pointer past the header page.
> -	 * But we can only do that if a writer is not currently
> -	 * moving it. The page before the header page has the
> -	 * flag bit '1' set if it is pointing to the page we want.
> -	 * but if the writer is in the process of moving it
> -	 * than it will be '2' or already moved '0'.
> +	 * Switch the reader page with the head page.
>  	 */
> -
> -	ret = rb_head_page_replace(reader, cpu_buffer->reader_page);
> -
> -	/*
> -	 * If we did not convert it, then we must try again.
> -	 */
> -	if (!ret)
> -		goto spin;
> -
> -	/*
> -	 * Yeah! We succeeded in replacing the page.
> -	 *
> -	 * Now make the new head point back to the reader page.
> -	 */
> -	reader->list.next->prev = &cpu_buffer->reader_page->list;
> -	rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
> +	reader = rb_switch_head(cpu_buffer, cpu_buffer->reader_page);
>  
>  	/* Finally update the reader page to the new head */
>  	cpu_buffer->reader_page = reader;
> @@ -3325,8 +2920,6 @@ EXPORT_SYMBOL_GPL(ring_buffer_size);
>  static void
>  rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
>  {
> -	rb_head_page_deactivate(cpu_buffer);
> -
>  	cpu_buffer->head_page
>  		= list_entry(cpu_buffer->pages, struct buffer_page, list);
>  	local_set(&cpu_buffer->head_page->write, 0);
> @@ -3353,8 +2946,6 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
>  
>  	cpu_buffer->write_stamp = 0;
>  	cpu_buffer->read_stamp = 0;
> -
> -	rb_head_page_activate(cpu_buffer);
>  }
>  
>  /**
> 
> 
> 
> 
> 
> 
> 
