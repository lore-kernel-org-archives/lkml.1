Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYI0TZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYI0TZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYI0TY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:24:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58717 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYI0TY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:24:58 -0400
Date: Sat, 27 Sep 2008 15:24:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v9] Unified trace buffer
In-Reply-To: <20080927183912.GA13685@elte.hu>
Message-ID: <alpine.DEB.1.10.0809271444460.11865@gandalf.stny.rr.com>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>
 <20080927183912.GA13685@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

Thanks for the review!

On Sat, 27 Sep 2008, Ingo Molnar wrote:

> 
> small nitpicking review, nothing structural yet:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Index: linux-trace.git/include/linux/ring_buffer.h
> > +enum {
> > +	RB_TYPE_PADDING,	/* Left over page padding
> 
> RB_ clashes with red-black tree namespace. (on the thought level)

Yeah, Linus pointed this out with the rb_ static function names. But since 
the functions are static I kept them as is. But here we have global names.

Would RNGBF_ be OK, or do you have any other ideas?

> 
> > +#define RB_ALIGNMENT_SHIFT	2
> > +#define RB_ALIGNMENT		(1 << RB_ALIGNMENT_SHIFT)
> > +#define RB_MAX_SMALL_DATA	(28)
> 
> no need to put numeric literals into parenthesis.

Ah, I think I had it more complex and changed it to a literal without 
removing the parenthesis.

> 
> > +static inline unsigned
> > +ring_buffer_event_length(struct ring_buffer_event *event)
> > +{
> > +	unsigned length;
> > +
> > +	switch (event->type) {
> > +	case RB_TYPE_PADDING:
> > +		/* undefined */
> > +		return -1;
> > +
> > +	case RB_TYPE_TIME_EXTENT:
> > +		return RB_LEN_TIME_EXTENT;
> > +
> > +	case RB_TYPE_TIME_STAMP:
> > +		return RB_LEN_TIME_STAMP;
> > +
> > +	case RB_TYPE_DATA:
> > +		if (event->len)
> > +			length = event->len << RB_ALIGNMENT_SHIFT;
> > +		else
> > +			length = event->array[0];
> > +		return length + RB_EVNT_HDR_SIZE;
> > +	default:
> > +		BUG();
> > +	}
> > +	/* not hit */
> > +	return 0;
> 
> too large, please uninline.

I calculated this on x86_64 to add 78 bytes. Is that still too big?

> 
> > +static inline void *
> > +ring_buffer_event_data(struct ring_buffer_event *event)
> > +{
> > +	BUG_ON(event->type != RB_TYPE_DATA);
> > +	/* If length is in len field, then array[0] has the data */
> > +	if (event->len)
> > +		return (void *)&event->array[0];
> > +	/* Otherwise length is in array[0] and array[1] has the data */
> > +	return (void *)&event->array[1];
> > +}
> 
> ditto.

No biggy. I thought this would be nicer as inline. But I have no problem
changing this.

> 
> > +/* FIXME!!! */
> > +u64 ring_buffer_time_stamp(int cpu)
> > +{
> > +	/* shift to debug/test normalization and TIME_EXTENTS */
> > +	return sched_clock() << DEBUG_SHIFT;
> 
> [ duly noted ;-) ]
> 
> > +}
> > +void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
> 
> needs extra newline above.

Yeah, I kept them bounded just to stress the "FIXME" part ;-)

> 
> > +/*
> > + * head_page == tail_page && head == tail then buffer is empty.
> > + */
> > +struct ring_buffer_per_cpu {
> > +	int			cpu;
> > +	struct ring_buffer	*buffer;
> > +	raw_spinlock_t		lock;
> 
> hm, should not be raw, at least initially. I am 95% sure we'll see 
> lockups, we always did when we iterated ftrace's buffer implementation 
> ;-)

It was to prevent lockdep from checking the locks from inside. We had 
issues with ftroce and lockdep in the past, because ftrace would trace the
internals of lockdep, and lockdep would then recurse back into itself to 
trace.  If lockdep itself can get away with not using raw_spinlocks, then
this will be OK to make back to spinlock.

> 
> > +struct ring_buffer {
> > +	unsigned long		size;
> > +	unsigned		pages;
> > +	unsigned		flags;
> > +	int			cpus;
> > +	cpumask_t		cpumask;
> > +	atomic_t		record_disabled;
> > +
> > +	struct mutex		mutex;
> > +
> > +	struct ring_buffer_per_cpu **buffers;
> > +};
> > +
> > +struct ring_buffer_iter {
> > +	struct ring_buffer_per_cpu	*cpu_buffer;
> > +	unsigned long			head;
> > +	struct buffer_page		*head_page;
> > +	u64				read_stamp;
> 
> please use consistent vertical whitespaces.  Above, in the struct 
> ring_buffer definition, you can add another tab to most of the vars - 
> that will also make the '**buffers' line look nice.

OK, will fix.

> 
> same for all structs across this file. In my experience, a 50% vertical 
> break works best - the one you used here in 'struct ring_buffer_iter'.
> 
> > +};
> > +
> > +#define CHECK_COND(buffer, cond)			\
> > +	if (unlikely(cond)) {				\
> > +		atomic_inc(&buffer->record_disabled);	\
> > +		WARN_ON(1);				\
> > +		return -1;				\
> > +	}
> 
> please name it RINGBUFFER_BUG_ON() / RINGBUFFER_WARN_ON(), so that we 
> dont have to memorize another set of debug names. [ See 
> DEBUG_LOCKS_WARN_ON() in include/linux/debug_locks.h ]

OK, this was a direct copy from what was used in ftrace.

> 
> you can change it to:
> 
> > +static int
> > +rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
> > +{
> > +	struct list_head *head = &cpu_buffer->pages;
> > +	LIST_HEAD(pages);
> > +	struct buffer_page *page, *tmp;
> > +	unsigned long addr;
> > +	unsigned i;
> 
> please apply ftrace's standard reverse christmas tree style and move the 
> 'pages' line down two lines.

Heh, this was directly from a bug I had and laziness ;-)
I originally just had struct list_head pages (and no *tmp), which kept the 
christmas tree format. But later found that you need to initialize list 
heads (duh!), and never moved it.


> 
> > +int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	unsigned long buffer_size;
> > +	LIST_HEAD(pages);
> > +	unsigned long addr;
> > +	unsigned nr_pages, rm_pages, new_pages;
> > +	struct buffer_page *page, *tmp;
> > +	int i, cpu;
> 
> ditto.

Same reason.

> 
> > +static inline void *rb_page_index(struct buffer_page *page, unsigned index)
> > +{
> > +	void *addr;
> > +
> > +	addr = page_address(&page->page);
> 
> 'addr' initialization can move to the definition line - you save two 
> lines.

Will fix.

> 
> > +	return addr + index;
> > +}
> > +
> > +static inline struct ring_buffer_event *
> > +rb_head_event(struct ring_buffer_per_cpu *cpu_buffer)
> > +{
> > +	return rb_page_index(cpu_buffer->head_page,
> > +			     cpu_buffer->head);
> 
> can all move to the same return line.

Ah, this was caused by my s/ring_buffer_page_index/rb_page_index/ run.

> 
> > +}
> > +
> > +static inline struct ring_buffer_event *
> > +rb_iter_head_event(struct ring_buffer_iter *iter)
> > +{
> > +	return rb_page_index(iter->head_page,
> > +			     iter->head);
> 
> ditto.

Will fix.

> 
> > +	for (head = 0; head < rb_head_size(cpu_buffer);
> > +	     head += ring_buffer_event_length(event)) {
> > +		event = rb_page_index(cpu_buffer->head_page, head);
> > +		BUG_ON(rb_null_event(event));
> 
> ( optional:when there's a multi-line loop then i generally try to insert 
>   an extra newline when starting the body - to make sure the iterator 
>   and the body stands apart visually. Matter of taste. )

Will fix, I have no preference.

> 
> > +static struct ring_buffer_event *
> > +rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
> > +		      unsigned type, unsigned long length)
> > +{
> > +	u64 ts, delta;
> > +	struct ring_buffer_event *event;
> > +	static int once;
> > +
> > +	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
> > +
> > +	if (cpu_buffer->tail) {
> > +		delta = ts - cpu_buffer->write_stamp;
> > +
> > +		if (test_time_stamp(delta)) {
> > +			if (unlikely(delta > (1ULL << 59) && !once++)) {
> > +				printk(KERN_WARNING "Delta way too big! %llu"
> > +				       " ts=%llu write stamp = %llu\n",
> > +				       delta, ts, cpu_buffer->write_stamp);
> > +				WARN_ON(1);
> > +			}
> > +			/*
> > +			 * The delta is too big, we to add a
> > +			 * new timestamp.
> > +			 */
> > +			event = __rb_reserve_next(cpu_buffer,
> > +						  RB_TYPE_TIME_EXTENT,
> > +						  RB_LEN_TIME_EXTENT,
> > +						  &ts);
> > +			if (!event)
> > +				return NULL;
> > +
> > +			/* check to see if we went to the next page */
> > +			if (cpu_buffer->tail) {
> > +				/* Still on same page, update timestamp */
> > +				event->time_delta = delta & TS_MASK;
> > +				event->array[0] = delta >> TS_SHIFT;
> > +				/* commit the time event */
> > +				cpu_buffer->tail +=
> > +					ring_buffer_event_length(event);
> > +				cpu_buffer->write_stamp = ts;
> > +				delta = 0;
> > +			}
> > +		}
> > +	} else {
> > +		rb_add_stamp(cpu_buffer, &ts);
> > +		delta = 0;
> > +	}
> > +
> > +	event = __rb_reserve_next(cpu_buffer, type, length, &ts);
> > +	if (!event)
> > +		return NULL;
> > +
> > +	/* If the reserve went to the next page, our delta is zero */
> > +	if (!cpu_buffer->tail)
> > +		delta = 0;
> > +
> > +	event->time_delta = delta;
> > +
> > +	return event;
> > +}
> 
> this function is too long, please split it up. The first condition's 
> body could go into a separate function i guess.

Will fix.

> 
> > +	RB_TYPE_TIME_EXTENT,	/* Extent the time delta
> > +				 * array[0] = time delta (28 .. 59)
> > +				 * size = 8 bytes
> > +				 */
> 
> please use standard comment style:
> 
>  /*
>   * Comment
>   */

Hmm, this is interesting. I kind of like this because it is not really a 
standard comment. It is a comment about the definitions of the enum. I 
believe if they are above:

  /*
   * Comment
   */
   RB_ENUM_TYPE,

It is not as readable. But if we do:

   RB_ENUM_TYPE,	/*
			 * Comment
			 */

The comment is not at the same line as the enum, which also looks 
unpleasing.

We can't could do:

			/*
   RB_ENUM_TYPE,	 * Comment
			 */
			/*
   RB_ENUM_TYPE2,	 * Comment
			 */

Because the ENUM is also in the comment :-p


I chose this way because we have:

  RB_ENUM_TYPE,		/* Comment
			 * More comment
			 */
  RB_ENUM_TYPE2,	/* Comment
			 */

Since I find this the nices way to describe enums. That last */ is 
good to space the comments apart, otherwise we have:

  RB_ENUM_TYPE,		/* Comment
			 * More comment */
  RB_ENUM_TYPE2,	/* Comment */

That is not as easy to see the separation of one description of enums with 
the other.

-- Steve

