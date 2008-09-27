Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYI0Sk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYI0Sk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYI0SkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:40:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55224 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYI0SkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:40:13 -0400
Date: Sat, 27 Sep 2008 20:39:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20080927183912.GA13685@elte.hu>
References: <20080925185154.230259579@goodmis.org> <20080925185236.244343232@goodmis.org> <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com> <48DC406D.1050508@redhat.com> <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com>
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


small nitpicking review, nothing structural yet:

* Steven Rostedt <rostedt@goodmis.org> wrote:

> Index: linux-trace.git/include/linux/ring_buffer.h
> +enum {
> +	RB_TYPE_PADDING,	/* Left over page padding

RB_ clashes with red-black tree namespace. (on the thought level)

> +#define RB_ALIGNMENT_SHIFT	2
> +#define RB_ALIGNMENT		(1 << RB_ALIGNMENT_SHIFT)
> +#define RB_MAX_SMALL_DATA	(28)

no need to put numeric literals into parenthesis.

> +static inline unsigned
> +ring_buffer_event_length(struct ring_buffer_event *event)
> +{
> +	unsigned length;
> +
> +	switch (event->type) {
> +	case RB_TYPE_PADDING:
> +		/* undefined */
> +		return -1;
> +
> +	case RB_TYPE_TIME_EXTENT:
> +		return RB_LEN_TIME_EXTENT;
> +
> +	case RB_TYPE_TIME_STAMP:
> +		return RB_LEN_TIME_STAMP;
> +
> +	case RB_TYPE_DATA:
> +		if (event->len)
> +			length = event->len << RB_ALIGNMENT_SHIFT;
> +		else
> +			length = event->array[0];
> +		return length + RB_EVNT_HDR_SIZE;
> +	default:
> +		BUG();
> +	}
> +	/* not hit */
> +	return 0;

too large, please uninline.

> +static inline void *
> +ring_buffer_event_data(struct ring_buffer_event *event)
> +{
> +	BUG_ON(event->type != RB_TYPE_DATA);
> +	/* If length is in len field, then array[0] has the data */
> +	if (event->len)
> +		return (void *)&event->array[0];
> +	/* Otherwise length is in array[0] and array[1] has the data */
> +	return (void *)&event->array[1];
> +}

ditto.

> +/* FIXME!!! */
> +u64 ring_buffer_time_stamp(int cpu)
> +{
> +	/* shift to debug/test normalization and TIME_EXTENTS */
> +	return sched_clock() << DEBUG_SHIFT;

[ duly noted ;-) ]

> +}
> +void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)

needs extra newline above.

> +/*
> + * head_page == tail_page && head == tail then buffer is empty.
> + */
> +struct ring_buffer_per_cpu {
> +	int			cpu;
> +	struct ring_buffer	*buffer;
> +	raw_spinlock_t		lock;

hm, should not be raw, at least initially. I am 95% sure we'll see 
lockups, we always did when we iterated ftrace's buffer implementation 
;-)

> +struct ring_buffer {
> +	unsigned long		size;
> +	unsigned		pages;
> +	unsigned		flags;
> +	int			cpus;
> +	cpumask_t		cpumask;
> +	atomic_t		record_disabled;
> +
> +	struct mutex		mutex;
> +
> +	struct ring_buffer_per_cpu **buffers;
> +};
> +
> +struct ring_buffer_iter {
> +	struct ring_buffer_per_cpu	*cpu_buffer;
> +	unsigned long			head;
> +	struct buffer_page		*head_page;
> +	u64				read_stamp;

please use consistent vertical whitespaces.  Above, in the struct 
ring_buffer definition, you can add another tab to most of the vars - 
that will also make the '**buffers' line look nice.

same for all structs across this file. In my experience, a 50% vertical 
break works best - the one you used here in 'struct ring_buffer_iter'.

> +};
> +
> +#define CHECK_COND(buffer, cond)			\
> +	if (unlikely(cond)) {				\
> +		atomic_inc(&buffer->record_disabled);	\
> +		WARN_ON(1);				\
> +		return -1;				\
> +	}

please name it RINGBUFFER_BUG_ON() / RINGBUFFER_WARN_ON(), so that we 
dont have to memorize another set of debug names. [ See 
DEBUG_LOCKS_WARN_ON() in include/linux/debug_locks.h ]

you can change it to:

> +static int
> +rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
> +{
> +	struct list_head *head = &cpu_buffer->pages;
> +	LIST_HEAD(pages);
> +	struct buffer_page *page, *tmp;
> +	unsigned long addr;
> +	unsigned i;

please apply ftrace's standard reverse christmas tree style and move the 
'pages' line down two lines.

> +int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	unsigned long buffer_size;
> +	LIST_HEAD(pages);
> +	unsigned long addr;
> +	unsigned nr_pages, rm_pages, new_pages;
> +	struct buffer_page *page, *tmp;
> +	int i, cpu;

ditto.

> +static inline void *rb_page_index(struct buffer_page *page, unsigned index)
> +{
> +	void *addr;
> +
> +	addr = page_address(&page->page);

'addr' initialization can move to the definition line - you save two 
lines.

> +	return addr + index;
> +}
> +
> +static inline struct ring_buffer_event *
> +rb_head_event(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	return rb_page_index(cpu_buffer->head_page,
> +			     cpu_buffer->head);

can all move to the same return line.

> +}
> +
> +static inline struct ring_buffer_event *
> +rb_iter_head_event(struct ring_buffer_iter *iter)
> +{
> +	return rb_page_index(iter->head_page,
> +			     iter->head);

ditto.

> +	for (head = 0; head < rb_head_size(cpu_buffer);
> +	     head += ring_buffer_event_length(event)) {
> +		event = rb_page_index(cpu_buffer->head_page, head);
> +		BUG_ON(rb_null_event(event));

( optional:when there's a multi-line loop then i generally try to insert 
  an extra newline when starting the body - to make sure the iterator 
  and the body stands apart visually. Matter of taste. )

> +static struct ring_buffer_event *
> +rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
> +		      unsigned type, unsigned long length)
> +{
> +	u64 ts, delta;
> +	struct ring_buffer_event *event;
> +	static int once;
> +
> +	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
> +
> +	if (cpu_buffer->tail) {
> +		delta = ts - cpu_buffer->write_stamp;
> +
> +		if (test_time_stamp(delta)) {
> +			if (unlikely(delta > (1ULL << 59) && !once++)) {
> +				printk(KERN_WARNING "Delta way too big! %llu"
> +				       " ts=%llu write stamp = %llu\n",
> +				       delta, ts, cpu_buffer->write_stamp);
> +				WARN_ON(1);
> +			}
> +			/*
> +			 * The delta is too big, we to add a
> +			 * new timestamp.
> +			 */
> +			event = __rb_reserve_next(cpu_buffer,
> +						  RB_TYPE_TIME_EXTENT,
> +						  RB_LEN_TIME_EXTENT,
> +						  &ts);
> +			if (!event)
> +				return NULL;
> +
> +			/* check to see if we went to the next page */
> +			if (cpu_buffer->tail) {
> +				/* Still on same page, update timestamp */
> +				event->time_delta = delta & TS_MASK;
> +				event->array[0] = delta >> TS_SHIFT;
> +				/* commit the time event */
> +				cpu_buffer->tail +=
> +					ring_buffer_event_length(event);
> +				cpu_buffer->write_stamp = ts;
> +				delta = 0;
> +			}
> +		}
> +	} else {
> +		rb_add_stamp(cpu_buffer, &ts);
> +		delta = 0;
> +	}
> +
> +	event = __rb_reserve_next(cpu_buffer, type, length, &ts);
> +	if (!event)
> +		return NULL;
> +
> +	/* If the reserve went to the next page, our delta is zero */
> +	if (!cpu_buffer->tail)
> +		delta = 0;
> +
> +	event->time_delta = delta;
> +
> +	return event;
> +}

this function is too long, please split it up. The first condition's 
body could go into a separate function i guess.

> +	RB_TYPE_TIME_EXTENT,	/* Extent the time delta
> +				 * array[0] = time delta (28 .. 59)
> +				 * size = 8 bytes
> +				 */

please use standard comment style:

 /*
  * Comment
  */

	Ingo
