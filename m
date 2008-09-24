Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYIXPpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYIXPpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYIXPox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:44:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYIXPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:44:51 -0400
Date: Wed, 24 Sep 2008 11:44:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Tom Zanussi <zanussi@comcast.net>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0809241106210.1860@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Peter Zijlstra wrote:

> On Wed, 2008-09-24 at 01:10 -0400, Steven Rostedt wrote:
> > plain text document attachment (ring-buffer.patch)
> > RFC RFC RFC RFC RFC!!!!
> 
> Plenty comments, things I like, things I don't like, specifics below ;-)

Thanks!

> 
> > Now did I get your attention that this is a request for comment patch.
> > 
> > This is probably very buggy. I ran it as a back end for ftrace but only
> > tested the irqsoff and ftrace tracers. The selftests are busted with it.
> > 
> > But this is an attempt to get a unified buffering system that was
> > talked about at the LPC meeting.
> > 
> > I did not get a chance to implement all the event recording and printing
> > in the debugfs/tracing/buffers directory. But I got enough to do
> > some ftrace work with it.
> > 
> > Now that it boots and runs (albeit, a bit buggy), I decided to post it.
> > This is some idea that I had to handle this.
> > 
> > I tried to make it as simple as possible. Basically we have:
> > 
> > buffer = ring_buffer_alloc(size, flags, max_event_size, print_func, name);
> 
> Don't like that max_event_size param.

Actually, that is there so that a user reading the buffer could allocate 
a buffer and read all the events. It also allows for greater than 1 page 
size events to be recorded, which it currently does not do (the 
max_event_size is currently ignored and set for you).

> Don't like that print_func param.

At the meeting we talked about having a way to do pretty print from the
debugfs. But you are free to pass in a NULL. I did with the ftrace work.

> Maybe like the name param.

That gives you a way to see what buffers are allocated in
/debugfs/tracing/buffers/<name>


> 
> > We can record either the fast way of reserving a part of the buffer:
> > 
> > event = ring_buffer_lock_reserve(buffer, event_id, length, &flags);
> > event->data = record_this_data;
> > ring_buffer_unlock_commit(buffer, event, flags);
> 
> This can, in generic, not work. Due to the simple fact that we might
> straddle a page boundary. Therefore I think its best to limit our self
> to the write interface below, so that it can handle that.

The code does not allow straddling of pages. Actually this is not much
different than what ftrace does today. If the new entry straddles a page,
we mark the rest of the page as "not used" and start on the next page.
This is actually nicer than straddling pages, which is what logdev does,
and one of the things that makes logdev slow.

Otherwise, we always need to copy twice. Once into the tracer sturcture
and than again into the buffer.

Having implemented both concepts, I much prefer this one. It also allows 
us to improve the buffering in the future.

> 
> > Or if we already have the data together:
> > 
> > ring_buffer_write(buffer, event_id, length, data);
> 
> Don't like the event_id, just stick to plain binary data, and leave
> interpretation open to whoemever uses it.

This is up to debate. I know you don't like this extra event layer,
but seriously, all my uses with ring buffers has had some kind of event.
But then I'm sure you can argue that if you are using a single type you
can can the event.

I'm open to doing this, but I would like a consensus on this.

Martin, Thomas, Ingo, Linus?

> 
> > We can read by consuming or iterating:
> > 
> > event = ring_buffer_consume(buffer);
> 
> By the above, this would have to be per-cpu as you cannot interpret the
> actual binary data, and this cannot do the fwd-merge-sort-iter thing.

Why not? It does ;-)

> 
> > iter = ring_buffer_start(buffer, iter_flags);
> > event = ring_buffer_read(iter, &next_cpu);
> > ring_buffer_finish(iter);
> > 
> > Note, the iteration part stops recording to the buffer. This is a feature.
> > If you want producer/consumer, then you should be using the consumer.
> 
> Why?

Because if we do not, then it is a lot more work to keep the iterator 
knowing about overruns, and becomes a pain in the ass. I ended up in
ftrace trying hard to disable tracing when we are reading the trace. If we 
do not, then the output always becomes corrupted. That is, the end half 
of the trace does not match the beginning.

For static reads (non consuming), in my pass experience, has become the 
preferred method. Note that the consuming read does not have this 
limitation, because a consuming read is usually done with in flight 
tracing. A static read is usually done (for best results) from running a 
trace and looking at the results at a later time.

> 
> 
> ---
> 
> So the interface I would like to see is:
> 
> struct ringbuffer *ringbuffer_alloc(unsigned long size);
> void ringbuffer_free(struct ringbuffer *rb);

Again this should be up to debate. I'm not that attached to one way or 
another.

> 
> /*
>  * disables preemption, cmpxchg reserves size on local cpu, memcpy 
>  * chunks of @buf into the page buffers, enables preemption.
>  */
> int ringbuffer_write(struct ringbuffer *buffer, const void *buf, unsigned long size);

Again this forces a double copy when one should be enough. This is what
logdev currently does, but it has proved inefficient.

> 
> /*
>  * consumes @size data from @cpu's buffer and copies it into @buf.
>  * has internal synchronization for read pos, returns error when
>  * overwritten - but resets state to next half-buffer.
>  */
> int ringbuffer_read(struct ringbuffer *buffer, int cpu, void *buf, unsigned long size);
> 
> This interface is enough to abstract the fact that our buffer
> is non-linear and further assumes as little as possible.

So you want to push the merge sort into the tracer. This also means that 
the tracer must be aware of per cpu data and also add the counter.

You may be the only one that wants this. But I'll let others speak for
themselves.

> 
> 
> For your IRQ/preempt tracers you can possibly add another operation:
> 
> /*
>  * swaps the @cpu buffer of @src and @dst, returns error when dimensions
>  * mis-match.
>  */
> int ringbuffer_xchg_cpu(struct ringbuffer *src, struct ringbuffer *dst, int cpu);

I can see this getting a bit confusing.

> 
> ---
> 
> On top of that foundation build an eventbuffer, which knows about
> encoding/decoding/printing events.
> 
> This too needs to be a flexible layer - as I suspect the google guys
> will want their ultra-compressed events back.
> 
> I'm not quite sure yet how to model this layer most flexible without
> being a nuisance.
> 
> So obviously its also this layer that has the whole debugfs interface,
> but maybe we could even push that one layer up, so as to keep that
> reusable with the print methods and be encoding invariant.

Since I didn't even need to use the debugfs layer for this buffering,
I have no problems in making that a separate layer.  But separating out
the ring buffer from the events might be a bit hard.

I could work on something if others agree too, but I do not want to spend
too much time on it if this idea is quickly NACKed by others.

Please someone speak up on this.

> 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  include/linux/ring_buffer.h |  138 +++
> >  kernel/trace/Kconfig        |    4 
> >  kernel/trace/Makefile       |    1 
> >  kernel/trace/ring_buffer.c  | 1565 ++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 1708 insertions(+)
> > 
> > Index: linux-compile.git/include/linux/ring_buffer.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-compile.git/include/linux/ring_buffer.h	2008-09-23 17:45:49.000000000 -0400
> > @@ -0,0 +1,138 @@
> > +#ifndef _LINUX_RING_BUFFER_H
> > +#define _LINUX_RING_BUFFER_H
> > +
> > +#include <linux/mm.h>
> > +#include <linux/seq_file.h>
> > +
> > +struct ring_buffer;
> > +struct ring_buffer_iter;
> > +
> > +/*
> > + * Don't reference this struct directly, use the inline items below.
> > + */
> > +struct ring_buffer_event {
> > +	unsigned long long counter;
> > +	short type;
> > +	short length;
> > +	char body[];
> > +} __attribute__((__packed__));
> > +
> > +#define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
> > +
> > +static inline unsigned
> > +ring_buffer_event_type(struct ring_buffer_event *event_handler)
> > +{
> > +	return event_handler->type;
> > +}
> > +
> > +static inline unsigned
> > +ring_buffer_event_length(struct ring_buffer_event *event_handler)
> > +{
> > +	return event_handler->length;
> > +}
> > +
> > +static inline void *
> > +ring_buffer_event_data(struct ring_buffer_event *event_handler)
> > +{
> > +	return event_handler->body;
> > +}
> > +
> > +static inline unsigned long long
> > +ring_buffer_event_counter(struct ring_buffer_event *event_handler)
> > +{
> > +	return event_handler->counter;
> > +}
> > +
> > +struct ring_buffer_seq;
> > +
> > +unsigned long ring_buffer_max_event_size(struct ring_buffer *buffer);
> > +
> > +typedef void (*ring_buffer_print_func) (struct ring_buffer *buffer,
> > +					struct ring_buffer_seq *seq,
> > +					struct ring_buffer_event *event);
> > +
> > +struct ring_buffer_seq *ring_buffer_seq_alloc(gfp_t flags);
> > +void ring_buffer_seq_free(struct ring_buffer_seq *seq);
> > +unsigned ring_buffer_seq_length(struct ring_buffer_seq *seq);
> > +void ring_buffer_seq_set_length(struct ring_buffer_seq *seq, unsigned len);
> > +int ring_buffer_seq_printf(struct ring_buffer_seq *seq, const char *fmt, ...)
> > +	__attribute__ ((format (printf, 2, 3)));
> > +int ring_buffer_seq_puts(struct ring_buffer_seq *seq, const char *str);
> > +int ring_buffer_seq_putc(struct ring_buffer_seq *seq, unsigned char c);
> > +int ring_buffer_seq_putmem(struct ring_buffer_seq *s, void *mem, size_t len);
> > +int ring_buffer_seq_to_seqfile(struct seq_file *m, struct ring_buffer_seq *s);
> > +int ring_buffer_seq_putmem_hex(struct ring_buffer_seq *s, void *mem, size_t len);
> > +ssize_t ring_buffer_seq_copy_to_user(struct ring_buffer_seq *seq,
> > +				 char __user *ubuf,
> > +				 size_t cnt);
> > +int ring_buffer_seq_to_mem(struct ring_buffer_seq *s, void *mem, size_t len);
> > +void ring_buffer_seq_reset(struct ring_buffer_seq *s);
> > +
> > +void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags);
> > +void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags);
> > +
> > +struct ring_buffer *
> > +ring_buffer_alloc(unsigned long size, unsigned long flags,
> > +		  unsigned long max_event_size,
> > +		  ring_buffer_print_func print_func,
> > +		  const char *name, ...);
> > +void ring_buffer_free(struct ring_buffer *buffer);
> > +
> > +int
> > +ring_buffer_register_event(struct ring_buffer *buffer, unsigned long length,
> > +			   ring_buffer_print_func print_func,
> > +			   int event_type,
> > +			   const char *name, ...);
> > +void *ring_buffer_lock_reserve(struct ring_buffer *buffer,
> > +			       int event_type,
> > +			       unsigned long length,
> > +			       unsigned long *flags);
> > +int ring_buffer_unlock_commit(struct ring_buffer *buffer,
> > +			      void *data, unsigned long flags);
> > +
> > +int ring_buffer_rename(struct ring_buffer *buffer, char *new_name, ...);
> > +
> > +void *ring_buffer_write(struct ring_buffer *buffer,
> > +			int event_type,
> > +			unsigned long length,
> > +			void *event);
> > +
> > +enum ring_buffer_iter_flags {
> > +	RB_ITER_FL_SNAP		= 1 << 0,
> > +};
> > +
> > +struct ring_buffer_event *
> > +ring_buffer_consume(struct ring_buffer *buffer);
> > +
> > +struct ring_buffer_iter *
> > +ring_buffer_start(struct ring_buffer *buffer, unsigned flags);
> > +void ring_buffer_finish(struct ring_buffer_iter *iter);
> > +
> > +struct ring_buffer_event *
> > +ring_buffer_peek(struct ring_buffer_iter *iter, int *next_cpu);
> > +
> > +struct ring_buffer_event *
> > +ring_buffer_read(struct ring_buffer_iter *iter, int *next_cpu);
> > +
> > +unsigned long ring_buffer_size(struct ring_buffer *buffer);
> > +
> > +void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
> > +
> > +int ring_buffer_empty(struct ring_buffer *buffer);
> > +
> > +void ring_buffer_disable(struct ring_buffer *buffer);
> > +void ring_buffer_enable(struct ring_buffer *buffer);
> > +
> > +void ring_buffer_snapshot(struct ring_buffer *buffer);
> > +void ring_buffer_snapshot_cpu(struct ring_buffer *buffer, int cpu);
> > +void ring_buffer_snapshot_one_cpu(struct ring_buffer *buffer, int cpu);
> > +
> > +unsigned long ring_buffer_entries(struct ring_buffer *buffer);
> > +unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
> > +
> > +enum ring_buffer_flags {
> > +	RB_FL_OVERWRITE		= 1 << 0,
> > +	RB_FL_SNAPSHOT		= 1 << 1,
> > +};
> > +
> > +#endif /* _LINUX_RING_BUFFER_H */
> > Index: linux-compile.git/kernel/trace/ring_buffer.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-compile.git/kernel/trace/ring_buffer.c	2008-09-24 00:46:40.000000000 -0400
> > @@ -0,0 +1,1565 @@
> > +/*
> > + * Generic ring buffer
> > + *
> > + * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
> > + */
> > +#include <linux/ring_buffer.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/module.h>
> > +#include <linux/percpu.h>
> > +#include <linux/init.h>
> > +#include <linux/hash.h>
> > +#include <linux/list.h>
> > +#include <linux/fs.h>
> > +
> > +#include "trace.h"
> > +
> > +#define MAX_NAME_SIZE 256
> > +#define RING_BUFFER_EVENT_DYN_START 1000
> > +#define RB_EVENT_HASHBITS	10
> > +#define RB_EVENT_HASHSIZE	(1<<RB_EVENT_HASHBITS)
> > +
> > +/*
> > + * head_page == tail_page && head == tail then buffer is empty.
> > + */
> > +struct ring_buffer_per_cpu {
> > +	int			cpu;
> > +	struct ring_buffer	*buffer;
> > +	raw_spinlock_t		lock;
> > +	struct lock_class_key	lock_key;
> 
> lockdep keys cannot be in dynamic storage, also mainline raw_spinlock_t
> doesn't have lockdep.

This was copied from ftrace. I didn't know what it did so I just copied
it ;-)

> 
> > +	void			**pages;
> 
> You used to link these using the pageframe, what happened to that?

It would have added another day to code it. Also I was playing with the 
idea that the "pages" might actually be bigger than a single page. But 
that could still be done with pages. The page handling can be very tricky.

Another thing about using the page struct link list is that it is very 
difficult to find the buffer pages from crash. This is something that 
needs to be solved before going back to that idea.


> 
> > +	unsigned long		head;	/* read from head */
> > +	unsigned long		tail;	/* write to tail */
> > +	unsigned long		head_page;
> > +	unsigned long		tail_page;
> > +	unsigned long		overrun;
> > +	unsigned long		entries;
> > +};
> > +
> > +struct ring_buffer {
> > +	char			name[MAX_NAME_SIZE + 1];
> > +	ring_buffer_print_func	default_func;
> > +	unsigned long		size;
> > +	unsigned long		next_event_type;
> > +	unsigned long		max_event_size;
> > +	unsigned		pages;
> > +	unsigned		page_size;
> > +	unsigned		flags;
> > +	int			cpus;
> > +	atomic_t		record_disabled;
> > +
> > +	spinlock_t		lock;
> > +	struct mutex		mutex;
> > +
> > +	struct ring_buffer_per_cpu *buffers[NR_CPUS];
> 
> People (read SGI) prefer you dynamically allocate this array due to them
> wanting distros to be able to set NR_CPUS=insane. Same goes for all
> NR_CPUS usage below.

I thought I had a comment somewhere that said /* FIXME: */. Yes I hate 
this too, but it was the easiest thing to write up in this patch. But 
this is just implementation, it does not change the basic ideas.

> 
> > +	struct list_head	list;
> > +	struct list_head	events;
> > +
> > +	struct ring_buffer_per_cpu *snap_buffers[NR_CPUS];
> > +
> > +	struct hlist_head	event_hash[RB_EVENT_HASHSIZE];
> > +
> > +	/* debugfs file entries */
> > +	struct dentry		*dir_ent;
> > +	struct dentry		*entry_dir;
> > +	struct dentry		*text_ent;
> > +	struct dentry		**binary_ents; /* per cpu */
> > +};
> > +
> > +struct ring_buffer_event_holder {
> > +	struct ring_buffer	*buffer;
> > +	struct list_head	list;
> > +	struct hlist_node	hash;
> > +	char			*name;
> > +	unsigned		event_type;
> > +	unsigned		length;
> > +	ring_buffer_print_func	print_func;
> > +};
> > +
> > +struct ring_buffer_iter_per_cpu {
> > +	unsigned long			head;
> > +	unsigned long			head_page;
> > +};
> > +
> > +struct ring_buffer_iter {
> > +	struct ring_buffer		*buffer;
> > +	struct ring_buffer_iter_per_cpu	buffers[NR_CPUS];
> > +	int				next_cpu;
> > +	unsigned			flags;
> > +};
> > +
> > +struct ring_buffer_seq {
> > +	unsigned char		buffer[PAGE_SIZE];
> > +	unsigned int		len;
> > +	unsigned int		readpos;
> > +};
> 
> Why not dynamically allocate the page?

Well, the struct is. Yeah, I can probably make this cleaner, but
this was easier. ;-)

> 
> > +static struct file_operations text_fops = {
> > +#if 0
> > +	.open		= text_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= text_release,
> > +#endif
> > +};
> > +
> > +static struct file_operations binary_fops = {
> > +#if 0
> > +	.open		= binary_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= binary_release,
> > +#endif
> > +};
> > +
> > +/* FIXME!!! */
> > +unsigned long long
> > +ring_buffer_next_counter(int cpu)
> > +{
> > +	return sched_clock();
> > +}
> 
> Yeah, we should ask for mathieu's event stamp counter. Non of the clocks
> we currently have suffice for this goal.

Ah, you see the "/* FIXME!!! */" here.

> 
> > +DEFINE_MUTEX(buffer_mutex);
> > +static LIST_HEAD(ring_buffer_list);
> > +static struct dentry *buffer_dent;
> > +#define TEMP_BUFFER_SIZE 1023
> > +static char temp_buffer[TEMP_BUFFER_SIZE+1];
> > +
> > +static int ring_buffer_register_debugfs(struct ring_buffer *buffer)
> > +{
> > +	struct dentry *tracing_dent;
> > +	struct dentry *dentry;
> > +	struct dentry *entry;
> > +	char name_buf[32];
> > +	int ret = -ENOMEM, i;
> > +
> > +	if (!buffer_dent) {
> > +		tracing_dent = tracing_init_dentry();
> > +		buffer_dent = debugfs_create_dir("buffers", tracing_dent);
> > +		if (!buffer_dent) {
> > +			pr_warning("Could not create debugfs directory"
> > +				   " 'tracing/buffers'\n");
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	buffer->binary_ents = kzalloc(sizeof(struct dentry *) * buffer->cpus,
> > +				      GFP_KERNEL);
> > +	if (!buffer->binary_ents)
> > +		return ret;
> > +
> > +	dentry = debugfs_create_dir(buffer->name, buffer_dent);
> > +	if (!dentry)
> > +		goto free_binary_ents;
> > +	buffer->dir_ent = dentry;
> > +
> > +	entry = debugfs_create_file("text", 0444, dentry,
> > +				    buffer, &text_fops);
> > +	if (!entry)
> > +		goto fail_free_dir;
> > +	buffer->text_ent = entry;
> > +
> > +	for (i = 0; i < buffer->cpus; i++) {
> > +		snprintf(name_buf, 32, "binary%d", i);
> > +		entry = debugfs_create_file(name_buf, 0444, dentry,
> > +					    buffer->buffers[i], &binary_fops);
> > +		if (!entry)
> > +			goto fail_free_ents;
> > +		buffer->binary_ents[i] = entry;
> > +	}
> > +
> > +	return 0;
> > +
> > + fail_free_ents:
> > +	debugfs_remove(buffer->text_ent);
> > +	for (i = 0; i < buffer->cpus; i++) {
> > +		if (buffer->binary_ents[i])
> > +			debugfs_remove(buffer->binary_ents[i]);
> > +	}
> > +
> > + fail_free_dir:
> > +	kfree(buffer->binary_ents);
> > +	debugfs_remove(dentry);
> > +
> > + free_binary_ents:
> > +	kfree(buffer->binary_ents);
> > +	return -1;
> > +}
> > +
> > +static void ring_buffer_unregister_debugfs(struct ring_buffer *buffer)
> > +{
> > +	/* fast and simple for now */
> > +	debugfs_remove_recursive(buffer->dir_ent);
> > +}
> > +
> > +static struct ring_buffer_per_cpu *
> > +ring_buffer_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	int pages = buffer->pages;
> > +	int i;
> > +
> > +	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
> > +				  GFP_KERNEL, cpu_to_node(cpu));
> > +	if (!cpu_buffer)
> > +		return NULL;
> > +
> > +	cpu_buffer->cpu = cpu;
> > +	cpu_buffer->buffer = buffer;
> > +	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
> 
> Ah, see, here you don't use this lockdep key ;-

again, copied from the ftrace code. This was not my doing ;-)

> 
> > +	cpu_buffer->pages = kzalloc_node(ALIGN(sizeof(void *) * pages,
> > +					       cache_line_size()), GFP_KERNEL,
> > +					 cpu_to_node(cpu));
> > +	if (!cpu_buffer->pages)
> > +		goto fail_free_buffer;
> > +
> > +	for (i = 0; i < pages; i++) {
> > +		cpu_buffer->pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
> > +		if (!cpu_buffer->pages[i])
> > +			goto fail_free_pages;
> > +	}
> 
> Like said, I rather liked using the pageframe to link these pages
> together. The simple fact is that both read and write are fwd iterative
> operations so you don't need the random access array.

as stated above, we need to fix the "crash" issue.

> 
> > +	return cpu_buffer;
> > +
> > + fail_free_pages:
> > +	for (i = 0; i < pages; i++) {
> > +		if (cpu_buffer->pages[i])
> > +			free_page((unsigned long)cpu_buffer->pages[i]);
> > +	}
> > +	kfree(cpu_buffer->pages);
> > +
> > + fail_free_buffer:
> > +	kfree(cpu_buffer);
> > +	return NULL;
> > +}
> > +
> > +static void
> > +ring_buffer_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < cpu_buffer->buffer->pages; i++) {
> > +		if (cpu_buffer->pages[i])
> > +			free_page((unsigned long)cpu_buffer->pages[i]);
> > +	}
> > +	kfree(cpu_buffer->pages);
> > +	kfree(cpu_buffer);
> > +}
> > +
> > +struct ring_buffer *
> > +ring_buffer_alloc(unsigned long size, unsigned long flags,
> > +		  unsigned long max_event_size,
> > +		  ring_buffer_print_func print_func,
> > +		  const char *name, ...)
> > +{
> > +	struct ring_buffer *buffer, *p;
> > +	va_list args;
> > +	int order = 0;
> > +	int ret = 0;
> > +	int cpu;
> > +
> > +	/* For now, we only allow max of page size */
> > +	if (max_event_size > PAGE_SIZE) {
> > +		WARN_ON(1);
> > +		return NULL;
> > +	}
> > +	max_event_size = PAGE_SIZE;
> > +
> > +	mutex_lock(&buffer_mutex);
> > +
> > +	/* keep it in its own cache line */
> > +	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
> > +			 GFP_KERNEL);
> > +	if (!buffer)
> > +		goto fail_unlock;
> > +
> > +	va_start(args, name);
> > +	vsnprintf(buffer->name, MAX_NAME_SIZE, name, args);
> > +	va_end(args);
> > +
> > +	buffer->name[MAX_NAME_SIZE] = 0;
> > +	/* FIXME; this should be better than a linear search */
> > +	list_for_each_entry(p, &ring_buffer_list, list) {
> > +		if (strcmp(p->name, buffer->name) == 0) {
> > +			ret = -EBUSY;
> > +			break;
> > +		}
> > +	}
> > +	if (ret)
> > +		goto fail_free_buffer;
> > +
> > +	buffer->page_size = 1 << order << PAGE_SHIFT;
> > +	buffer->next_event_type = RING_BUFFER_EVENT_DYN_START;
> > +	buffer->max_event_size = max_event_size;
> > +	INIT_LIST_HEAD(&buffer->events);
> > +
> > +	buffer->default_func = print_func;
> > +	buffer->pages = (size + (buffer->page_size - 1)) / buffer->page_size;
> > +	buffer->flags = flags;
> > +
> > +	/* need at least two pages */
> > +	if (buffer->pages == 1)
> > +		buffer->pages++;
> > +
> > +	/* FIXME: do for only online CPUS */
> > +	buffer->cpus = num_possible_cpus();
> > +	for_each_possible_cpu(cpu) {
> > +		if (cpu >= buffer->cpus)
> > +			continue;
> > +		buffer->buffers[cpu] =
> > +			ring_buffer_allocate_cpu_buffer(buffer, cpu);
> > +		if (!buffer->buffers[cpu])
> > +			goto fail_free_buffers;
> > +	}
> > +
> > +	if (flags & RB_FL_SNAPSHOT) {
> > +		for_each_possible_cpu(cpu) {
> > +			if (cpu >= buffer->cpus)
> > +				continue;
> > +			buffer->snap_buffers[cpu] =
> > +				ring_buffer_allocate_cpu_buffer(buffer, cpu);
> > +			if (!buffer->snap_buffers[cpu])
> > +				goto fail_free_snap_buffers;
> > +		}
> > +	}
> 
> Right, like said above, I don't think you need the snapshot stuff in
> here, if you provide this per cpu buffer xchg method.

If we go with your approach, I will probably keep this interface as is, 
(perhaps rename it s/ring_buffer/trace_buffer/) and implement all this
on top of your ring buffer approach. Because this snapshot idea can really
clean up ftrace a lot.

> 
> > +	ret = ring_buffer_register_debugfs(buffer);
> > +	if (ret)
> > +		goto fail_free_snap_buffers;
> > +
> > +	spin_lock_init(&buffer->lock);
> > +	mutex_init(&buffer->mutex);
> > +
> > +	mutex_unlock(&buffer_mutex);
> > +
> > +	return buffer;
> > +
> > + fail_free_snap_buffers:
> > +	if (!(flags & RB_FL_SNAPSHOT))
> > +		goto fail_free_buffers;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		if (cpu >= buffer->cpus)
> > +			continue;
> > +		if (buffer->snap_buffers[cpu])
> > +			ring_buffer_free_cpu_buffer(buffer->snap_buffers[cpu]);
> > +	}
> > +
> > + fail_free_buffers:
> > +	for_each_possible_cpu(cpu) {
> > +		if (cpu >= buffer->cpus)
> > +			continue;
> > +		if (buffer->buffers[cpu])
> > +			ring_buffer_free_cpu_buffer(buffer->buffers[cpu]);
> > +	}
> > +
> > + fail_free_buffer:
> > +	kfree(buffer);
> > +
> > + fail_unlock:
> > +	mutex_unlock(&buffer_mutex);
> > +	return NULL;
> > +}
> > +
> > +static struct ring_buffer_event_holder *
> > +__ring_buffer_find_event(struct ring_buffer *buffer, int event_type)
> > +{
> > +	struct ring_buffer_event_holder *p;
> > +	struct hlist_node *t;
> > +	unsigned long key;
> > +
> > +	key = hash_long(event_type, RB_EVENT_HASHBITS);
> > +
> > +	hlist_for_each_entry_rcu(p, t, &buffer->event_hash[key], hash) {
> > +		if (p->event_type == event_type)
> > +			return p;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +/**
> > + * ring_buffer_register_event - register an event to a ring buffer
> > + * @buffer: the buffer to register the event to.
> > + * @length: the length of the event
> > + * @print_func: The pretty print output to handle this event.
> > + * @event_type: Set the event type, or 0 to have one given
> > + * @name: The name of this event, to show in the debugfs.
> > + *
> > + * This function allows events to be registered, as well as adding
> > + * a function to handle how to show this event in text format.
> > + * The event_type must be less than 1000, since that is where
> > + * the dynamic event types start. Event types are unique to buffers.
> > + */
> > +int
> > +ring_buffer_register_event(struct ring_buffer *buffer, unsigned long length,
> > +			   ring_buffer_print_func print_func,
> > +			   int event_type,
> > +			   const char *name, ...)
> > +{
> > +	struct ring_buffer_event_holder *ptr, *event;
> > +	struct list_head *p;
> > +	va_list args, args2;
> > +	unsigned long key;
> > +	int r;
> > +
> > +	if (event_type >= RING_BUFFER_EVENT_DYN_START)
> > +		return -EINVAL;
> > +
> > +	event = kzalloc(sizeof(*event), GFP_KERNEL);
> > +	if (!event)
> > +		return -ENOMEM;
> > +
> > +	event->print_func = print_func;
> > +
> > +	mutex_lock(&buffer->mutex);
> > +
> > +	if (!event_type)
> > +		event_type = buffer->next_event_type++;
> > +
> > +	ptr = __ring_buffer_find_event(buffer, event_type);
> > +	if (ptr) {
> > +		event_type = -EBUSY;
> > +		kfree(event);
> > +		goto out;
> > +	}
> > +
> > +	va_start(args, name);
> > +	va_copy(args2, args);
> > +	r = vsnprintf(temp_buffer, TEMP_BUFFER_SIZE, name, args);
> > +
> > +	event->name = kzalloc(r+1, GFP_KERNEL);
> > +	if (!event->name) {
> > +		va_end(args2);
> > +		va_end(args);
> > +		kfree(event);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	if (unlikely(r >= TEMP_BUFFER_SIZE))
> > +		vsnprintf(event->name, r+1, name, args2);
> > +	else
> > +		strcpy(event->name, temp_buffer);
> > +
> > +	va_end(args2);
> > +	va_end(args);
> > +
> > +	list_for_each(p, &buffer->events) {
> > +		ptr = list_entry(p, struct ring_buffer_event_holder, list);
> > +		r = strcmp(event->name, ptr->name);
> > +		if (!r) {
> > +			WARN_ON(1);
> > +			kfree(event->name);
> > +			kfree(event);
> > +			event = NULL;
> > +			goto out;
> > +		}
> > +		if (r < 0)
> > +			break;
> > +	}
> > +
> > +	list_add_tail(&event->list, p);
> > +
> > +	key = hash_long(event_type, RB_EVENT_HASHBITS);
> > +	hlist_add_head_rcu(&event->hash, &buffer->event_hash[key]);
> > +
> > + out:
> > +	mutex_unlock(&buffer->mutex);
> > +	return event_type;
> > +}
> > +
> > +static void
> > +ring_buffer_event_free(struct ring_buffer_event_holder *event)
> > +{
> > +	kfree(event->name);
> > +	kfree(event);
> > +}
> > +
> > +/**
> > + * ring_buffer_free - free a ring buffer.
> > + * @buffer: the buffer to free.
> > + */
> > +void
> > +ring_buffer_free(struct ring_buffer *buffer)
> > +{
> > +	struct ring_buffer_event_holder *event_holder, *n;
> > +	int cpu;
> > +
> > +	for (cpu = 0; cpu < buffer->cpus; cpu++)
> > +		ring_buffer_free_cpu_buffer(buffer->buffers[cpu]);
> > +
> > +	list_for_each_entry_safe(event_holder, n,
> > +				 &buffer->events, list)
> > +		ring_buffer_event_free(event_holder);
> > +
> > +	ring_buffer_unregister_debugfs(buffer);
> > +	kfree(buffer);
> > +}
> > +
> > +/**
> > + * ring_buffer_max_event_size - return max_event_size of the buffer
> > + * @buffer: the buffer to get the max event size that is allowed.
> > + *
> > + * Returns the max event size allowed for the given buffer.
> > + */
> > +unsigned long
> > +ring_buffer_max_event_size(struct ring_buffer *buffer)
> > +{
> > +	return buffer->max_event_size;
> > +}
> 
> Right, I think this sound die.

I actually use this to copy the event into a buffer while consuming it.
Once you consume it, it is gone.

> 
> > +static inline int
> > +ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
> > +{
> > +	return cpu_buffer->head_page == cpu_buffer->tail_page &&
> > +		cpu_buffer->head == cpu_buffer->tail;
> > +}
> > +
> > +static inline int
> > +ring_buffer_null_event(struct ring_buffer_event *event)
> > +{
> > +	return !event->type && !event->counter;
> > +}
> > +
> > +static inline int
> > +ring_buffer_short_event(struct ring_buffer *buffer, unsigned long ptr)
> > +{
> > +	return ptr + RB_EVNT_HDR_SIZE > buffer->page_size;
> > +}
> > +
> > +static void
> > +ring_buffer_update_overflow(struct ring_buffer_per_cpu *cpu_buffer,
> > +			    unsigned long head_page)
> > +{
> > +	struct ring_buffer *buffer = cpu_buffer->buffer;
> > +	struct ring_buffer_event *event;
> > +	unsigned long head;
> > +
> > +	for (head = 0; head < buffer->page_size; head += event->length) {
> > +		if (ring_buffer_short_event(buffer, head))
> > +			break;
> > +		event = cpu_buffer->pages[cpu_buffer->head_page] + head;
> > +		if (ring_buffer_null_event(event))
> > +			break;
> > +		cpu_buffer->overrun++;
> > +		cpu_buffer->entries--;
> > +	}
> > +}
> > +
> > +static inline void
> > +ring_buffer_inc_page(struct ring_buffer *buffer,
> > +		     unsigned long *page)
> > +{
> > +	(*page)++;
> > +	if (*page >= buffer->pages)
> > +		*page = 0;
> > +}
> > +
> > +static struct ring_buffer_event *
> > +ring_buffer_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
> > +			   unsigned long length)
> > +{
> > +	unsigned long head_page, tail_page, tail;
> > +	struct ring_buffer *buffer = cpu_buffer->buffer;
> > +	struct ring_buffer_event *event;
> > +
> > +	if (length > buffer->page_size)
> > +		return NULL;
> > +
> > +	tail_page = cpu_buffer->tail_page;
> > +	head_page = cpu_buffer->head_page;
> > +	tail = cpu_buffer->tail;
> > +
> > +	BUG_ON(tail_page >= buffer->pages);
> > +	BUG_ON(head_page >= buffer->pages);
> > +
> > +	if (tail + length > buffer->page_size) {
> > +		unsigned long next_page = tail_page;
> > +
> > +		ring_buffer_inc_page(buffer, &next_page);
> > +
> > +		if (next_page == head_page) {
> > +			if (!(buffer->flags & RB_FL_OVERWRITE))
> > +				return NULL;
> > +
> > +			/* count overflows */
> > +			ring_buffer_update_overflow(cpu_buffer, head_page);
> > +
> > +			ring_buffer_inc_page(buffer, &head_page);
> > +			cpu_buffer->head_page = head_page;
> > +			cpu_buffer->head = 0;
> > +		}
> > +
> > +		if (!ring_buffer_short_event(buffer, tail)) {
> > +			event = cpu_buffer->pages[tail_page] + tail;
> > +			/* empty event */
> > +			event->counter = 0;
> > +			event->type = 0;
> > +			event->length = buffer->page_size - tail;
> > +		}
> > +
> > +		tail = 0;
> > +		tail_page = next_page;
> > +		cpu_buffer->tail_page = tail_page;
> > +		cpu_buffer->tail = tail;
> > +	}
> > +
> > +	BUG_ON(tail_page >= buffer->pages);
> > +	BUG_ON(ring_buffer_short_event(buffer, tail));
> > +
> > +	event = cpu_buffer->pages[tail_page] + tail;
> > +	event->length = length;
> > +	cpu_buffer->entries++;
> > +
> > +	return event;
> > +}
> > +
> > +/**
> > + * ring_buffer_lock_reserve - reserve a part of the buffer
> > + * @buffer: the ring buffer to reserve from
> > + * @event_type: the event type to reserve
> > + * @length: the length of the data to reserve (excluding event header)
> > + * @flags: a pointer to save the interrupt flags
> > + *
> > + * Returns a location on the ring buffer to copy directly to.
> > + * The length is the length of the data needed, not the event length
> > + * which also includes the event header.
> > + *
> > + * Must be paired with ring_buffer_unlock_commit, unless NULL is returned.
> > + * If NULL is returned, then nothing has been allocated or locked.
> > + */
> > +void *ring_buffer_lock_reserve(struct ring_buffer *buffer,
> > +			       int event_type,
> > +			       unsigned long length,
> > +			       unsigned long *flags)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_event *event;
> > +	int cpu;
> > +
> > +	if (atomic_read(&buffer->record_disabled))
> > +		return NULL;
> > +
> > +	raw_local_irq_save(*flags);
> > +	cpu = raw_smp_processor_id();
> > +	cpu_buffer = buffer->buffers[cpu];
> > +	__raw_spin_lock(&cpu_buffer->lock);
> 
> I'm a bit mystified by the need to take an actual lock on the write path
> - disabling preemption should be sufficient to keep up local, or are you
> synchonizing against read as well?

Yeah, the read is syncronized here. Since all reads will merge sort.

> 
> > +	if (atomic_read(&buffer->record_disabled))
> > +		goto no_record;
> > +
> > +	length += RB_EVNT_HDR_SIZE;
> > +	length = ALIGN(length, 8);
> > +	WARN_ON(length > buffer->max_event_size);
> > +	event = ring_buffer_reserve_next_event(cpu_buffer, length);
> > +	if (!event)
> > +		goto no_record;
> > +
> > +	event->counter = ring_buffer_next_counter(cpu_buffer->cpu);
> > +	event->type = event_type;
> > +
> > +	return &event->body;
> > +
> > + no_record:
> > +	__raw_spin_unlock(&cpu_buffer->lock);
> > +	local_irq_restore(*flags);
> > +	return NULL;
> > +}
> > +
> > +/**
> > + * ring_buffer_unlock_commit - commit a reserved
> > + * @buffer: The buffer to commit to
> > + * @data: The data pointer to commit.
> > + * @flags: the interrupt flags received from ring_buffer_lock_reserve.
> > + *
> > + * This commits the data to the ring buffer, and releases any locks held.
> > + *
> > + * Must be paired with ring_buffer_lock_reserve.
> > + */
> > +int ring_buffer_unlock_commit(struct ring_buffer *buffer, void *data, unsigned long flags)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_event *event =
> > +		container_of(data, struct ring_buffer_event, body);
> > +
> > +	int cpu = raw_smp_processor_id();
> > +
> > +	cpu_buffer = buffer->buffers[cpu];
> > +
> > +	cpu_buffer->tail += event->length;
> > +
> > +	__raw_spin_unlock(&cpu_buffer->lock);
> > +	raw_local_irq_restore(flags);
> > +
> > +	return 0;
> > +}
> 
> Like said, I don't think we can use the reserve/commit interface due to
> not having a linear buffer.

Without this, we must copy twice, and I really hate to do that.

> 
> > +/**
> > + * ring_buffer_write - write data to the buffer without reserving
> > + * @buffer: The ring buffer to write to.
> > + * @event_type: The event type to write to.
> > + * @length: The length of the data being written (excluding the event header)
> > + * @data: The data to write to the buffer.
> > + *
> > + * This is like ring_buffer_lock_reserve and ring_buffer_unlock_commit as
> > + * one function. If you already have the data to write to the buffer, it
> > + * may be easier to simply call this function.
> > + *
> > + * Note, like ring_buffer_lock_reserve, the length is the length of the data
> > + * and not the length of the event which would hold the header.
> > + */
> > +void *ring_buffer_write(struct ring_buffer *buffer,
> > +			int event_type,
> > +			unsigned long length,
> > +			void *data)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_event *event;
> > +	unsigned long event_length, flags;
> > +	void *ret = NULL;
> > +	int cpu;
> > +
> > +	if (atomic_read(&buffer->record_disabled))
> > +		return NULL;
> > +
> > +	local_irq_save(flags);
> > +	cpu = raw_smp_processor_id();
> > +	cpu_buffer = buffer->buffers[cpu];
> > +	__raw_spin_lock(&cpu_buffer->lock);
> > +
> > +	if (atomic_read(&buffer->record_disabled))
> > +		goto out;
> > +
> > +	event_length = ALIGN(length + RB_EVNT_HDR_SIZE, 8);
> > +	event = ring_buffer_reserve_next_event(cpu_buffer, event_length);
> > +	if (!event)
> > +		goto out;
> > +
> > +	event->counter = ring_buffer_next_counter(cpu_buffer->cpu);
> > +	event->type = event_type;
> > +	memcpy(&event->body, data, length);
> 
> I'm missing the loop over the page...

It doesn't happen. If the item crosses page bounders, we start on the
next page. Yes this may waste some space, but makes things much cleaner.
Again, logdev does the page bounder crossing, and it causes lots of
headaches.

> 
> > +	cpu_buffer->tail += event->length;
> > +
> > +	ret = event->body;
> > + out:
> > +	__raw_spin_unlock(&cpu_buffer->lock);
> > +	local_irq_restore(flags);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * ring_buffer_lock - lock the ring buffer
> > + * @buffer: The ring buffer to lock
> > + * @flags: The place to store the interrupt flags
> > + *
> > + * This locks all the per CPU buffers.
> > + *
> > + * Must be unlocked by ring_buffer_unlock.
> > + */
> > +void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	int cpu;
> > +
> > +	local_irq_save(*flags);
> > +
> > +	for (cpu = 0; cpu < buffer->cpus; cpu++) {
> > +
> > +		cpu_buffer = buffer->buffers[cpu];
> > +		__raw_spin_lock(&cpu_buffer->lock);
> > +	}
> > +}
> 
> This stuff made me go GAH for a bit,.. the only user I could quickly
> locate is ring_buffer_start() (which btw. is a horribly name) which,
> because it disables writing to the buffer, doesn't seem to need such
> heavy handed locking.

This is where I said if you use an iterator, it will stop the tracing. The
spinlocks are there to synchronize with the disabling.

If you don't want this, just use the consumer.

> 
> > +/**
> > + * ring_buffer_unlock - unlock a locked buffer
> > + * @buffer: The locked buffer to unlock
> > + * @flags: The interrupt flags received by ring_buffer_lock
> > + */
> > +void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	int cpu;
> > +
> > +	for (cpu = buffer->cpus - 1; cpu >= 0; cpu--) {
> > +
> > +		cpu_buffer = buffer->buffers[cpu];
> > +		__raw_spin_unlock(&cpu_buffer->lock);
> > +	}
> > +
> > +	local_irq_restore(flags);
> > +}
> > +
> > +/**
> > + * ring_buffer_record_disable - stop all writes into the buffer
> > + * @buffer: The ring buffer to stop writes to.
> > + *
> > + * This prevents all writes to the buffer. Any attempt to write
> > + * to the buffer after this will fail and return NULL.
> > + */
> > +void ring_buffer_record_disable(struct ring_buffer *buffer)
> > +{
> > +	atomic_inc(&buffer->record_disabled);
> > +}
> > +
> > +/**
> > + * ring_buffer_record_enable - enable writes to the buffer
> > + * @buffer: The ring buffer to enable writes
> > + *
> > + * Note, multiple disables will need the same number of enables
> > + * to truely enable the writing (much like preempt_disable).
> > + */
> > +void ring_buffer_record_enable(struct ring_buffer *buffer)
> > +{
> > +	atomic_dec(&buffer->record_disabled);
> > +}
> 
> Right - I dont think this should be part of the ringbuffer interface,
> maybe on the event interface, preferable on the tracer layer.

I actually disagree here. It makes things so much easier, and is something
I wish ftrace had. I even have something similar with logdev.

> 
> > +/**
> > + * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
> > + * @buffer: The ring buffer
> > + * @cpu: The per CPU buffer to get the entries from.
> > + */
> > +unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +
> > +	cpu_buffer = buffer->buffers[cpu];
> > +	return cpu_buffer->entries;
> > +}
> > +
> > +/**
> > + * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
> > + * @buffer: The ring buffer
> > + * @cpu: The per CPU buffer to get the number of overruns from
> > + */
> > +unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +
> > +	cpu_buffer = buffer->buffers[cpu];
> > +	return cpu_buffer->overrun;
> > +}
> 
> Does it make sense to expose this as a statistics interface like:
> 
> enum ringbuffer_stats {
>  RB_ENTRIES,
>  RB_OVERFLOWS,
> }
> 
> unsigned long ringbuffer_stat_cpu(struct ringbuffer *buffer, int cpu, enum ringbuffer_stats);

This is just an implementation detail. I have no pref. I just picked one, 
because I found that I needed it in the last minute and quickly wrote one 
up. Then found I needed the other, and cut and paste it.

> 
> 
> > +/**
> > + * ring_buffer_entries - get the number of entries in a buffer
> > + * @buffer: The ring buffer
> > + *
> > + * Returns the total number of entries in the ring buffer
> > + * (all CPU entries)
> > + */
> > +unsigned long ring_buffer_entries(struct ring_buffer *buffer)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	unsigned long entries = 0;
> > +	int cpu;
> > +
> > +	/* if you care about this being correct, lock the buffer */
> > +	for (cpu = 0; cpu < buffer->cpus; cpu++) {
> > +		cpu_buffer = buffer->buffers[cpu];
> > +		entries += cpu_buffer->entries;
> > +	}
> > +
> > +	return entries;
> > +}
> > +
> > +/**
> > + * ring_buffer_overrun_cpu - get the number of overruns in buffer
> > + * @buffer: The ring buffer
> > + *
> > + * Returns the total number of overruns in the ring buffer
> > + * (all CPU entries)
> > + */
> > +unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	unsigned long overruns = 0;
> > +	int cpu;
> > +
> > +	/* if you care about this being correct, lock the buffer */
> > +	for (cpu = 0; cpu < buffer->cpus; cpu++) {
> > +		cpu_buffer = buffer->buffers[cpu];
> > +		overruns += cpu_buffer->overrun;
> > +	}
> > +
> > +	return overruns;
> > +}
> 
> The summing part of the statistics interface..
> 
> unsigned long ringbuffer_stat(struct ringbuffer *buffer, enum ringbuffer_stats);

again, whatever ;-)

> 
> > +static inline int
> > +ring_buffer_iter_cpu_empty(struct ring_buffer_iter_per_cpu *cpu_iter,
> > +			   struct ring_buffer_per_cpu *cpu_buffer)
> > +{
> > +	return cpu_iter->head_page == cpu_buffer->tail_page &&
> > +		cpu_iter->head == cpu_buffer->tail;
> > +}
> > +
> > +static inline struct ring_buffer_per_cpu *
> > +iter_choose_buffer(struct ring_buffer_iter *iter, int cpu)
> > +{
> > +	struct ring_buffer *buffer = iter->buffer;
> > +
> > +	if (iter->flags & RB_ITER_FL_SNAP)
> > +		return buffer->snap_buffers[cpu];
> > +	else
> > +		return buffer->buffers[cpu];
> > +}
> > +
> > +static void
> > +ring_buffer_advance_head(struct ring_buffer_per_cpu *cpu_buffer)
> > +{
> > +	struct ring_buffer *buffer = cpu_buffer->buffer;
> > +	struct ring_buffer_event *event;
> > +
> > +	event = cpu_buffer->pages[cpu_buffer->head_page] + cpu_buffer->head;
> > +
> > +	if (ring_buffer_short_event(buffer, cpu_buffer->head) ||
> > +	    ring_buffer_null_event(event)) {
> > +		BUG_ON(cpu_buffer->head_page == cpu_buffer->tail_page);
> > +		ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
> > +		cpu_buffer->head = 0;
> > +		return;
> > +	}
> > +
> > +	BUG_ON((cpu_buffer->head_page == cpu_buffer->tail_page) &&
> > +	       (cpu_buffer->head + event->length > cpu_buffer->tail));
> > +
> > +	cpu_buffer->head += event->length;
> > +	if (ring_buffer_short_event(buffer, cpu_buffer->head)) {
> > +		ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
> > +		cpu_buffer->head = 0;
> > +		return;
> > +	}
> > +
> > +	/* check for end of page padding */
> > +	event = cpu_buffer->pages[cpu_buffer->head_page] + cpu_buffer->head;
> > +	if ((ring_buffer_short_event(buffer, cpu_buffer->head) ||
> > +	     ring_buffer_null_event(event)) &&
> > +	    (cpu_buffer->head_page != cpu_buffer->tail_page))
> > +		ring_buffer_advance_head(cpu_buffer);
> > +}
> > +
> > +static void
> > +ring_buffer_advance_iter(struct ring_buffer_iter *iter, int cpu)
> > +{
> > +	struct ring_buffer *buffer = iter->buffer;
> > +	struct ring_buffer_iter_per_cpu *cpu_iter = &iter->buffers[cpu];
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_event *event;
> > +
> > +	cpu_buffer = iter_choose_buffer(iter, cpu);
> > +	event = cpu_buffer->pages[cpu_iter->head_page] + cpu_iter->head;
> > +
> > +	if (ring_buffer_short_event(buffer, cpu_iter->head) ||
> > +	    ring_buffer_null_event(event)) {
> > +		BUG_ON(cpu_iter->head_page == cpu_buffer->tail_page);
> > +		ring_buffer_inc_page(buffer, &cpu_iter->head_page);
> > +		cpu_iter->head = 0;
> > +		return;
> > +	}
> > +
> > +	BUG_ON((cpu_iter->head_page == cpu_buffer->tail_page) &&
> > +	       (cpu_iter->head + event->length > cpu_buffer->tail));
> > +
> > +	cpu_iter->head += event->length;
> > +	if (ring_buffer_short_event(buffer, cpu_iter->head)) {
> > +		ring_buffer_inc_page(buffer, &cpu_iter->head_page);
> > +		cpu_iter->head = 0;
> > +		return;
> > +	}
> > +
> > +	/* check for end of page padding */
> > +	event = cpu_buffer->pages[cpu_iter->head_page] + cpu_iter->head;
> > +	if ((ring_buffer_short_event(buffer, cpu_iter->head) ||
> > +	     ring_buffer_null_event(event)) &&
> > +	    (cpu_iter->head_page != cpu_buffer->tail_page))
> > +		ring_buffer_advance_iter(iter, cpu);
> > +}
> > +
> > +/**
> > + * ring_buffer_consume - return an event and consume it
> > + * @buffer: The ring buffer to get the next event from
> > + *
> > + * Returns the next event in the ring buffer, and that event is consumed.
> > + * Meaning, that sequential reads will keep returning a different event,
> > + * and eventually empty the ring buffer if the producer is slower.
> > + */
> > +struct ring_buffer_event *
> > +ring_buffer_consume(struct ring_buffer *buffer)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_event *event, *next_event = NULL;
> > +	int cpu, next_cpu = -1;
> > +
> > +	for (cpu = 0; cpu < buffer->cpus; cpu++) {
> > +		cpu_buffer = buffer->buffers[cpu];
> > +		if (ring_buffer_per_cpu_empty(cpu_buffer))
> > +			continue;
> > +
> > +		event = cpu_buffer->pages[cpu_buffer->head_page] +
> > +			cpu_buffer->head;
> > +		if (unlikely(ring_buffer_short_event(buffer, cpu_buffer->head) ||
> > +			     ring_buffer_null_event(event))) {
> > +			if (cpu_buffer->head_page == cpu_buffer->tail_page)
> > +				continue;
> > +			ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
> > +			cpu_buffer->head = 0;
> > +
> > +			if (ring_buffer_per_cpu_empty(cpu_buffer))
> > +				continue;
> > +			event = cpu_buffer->pages[cpu_buffer->head_page] +
> > +				cpu_buffer->head;
> > +		}
> > +
> > +		if (!next_event || event->counter < next_event->counter) {
> > +			next_cpu = cpu;
> > +			next_event = event;
> > +		}
> > +	}
> > +
> > +	if (!next_event)
> > +		return NULL;
> > +
> > +	cpu_buffer = buffer->buffers[next_cpu];
> > +	ring_buffer_advance_head(cpu_buffer);
> > +	cpu_buffer->entries--;
> > +
> > +	return next_event;
> > +}
> > +
> > +/**
> > + * ring_buffer_start - start a non consuming read of the buffer
> 
> One might think from the name it starts recording events or something
> similarly daft..

How about "ring_buffer_read_start"?

> 
> > + * @buffer: The ring buffer to read from
> > + * @iter_flags: control flags on how to read the buffer.
> > + *
> > + * This starts up an iteration through the buffer. It also disables
> > + * the recording to the buffer until the reading is finished.
> > + * This prevents the reading from being corrupted. This is not
> > + * a consuming read, so a producer is not expected.
> > + *
> > + * The iter_flags of RB_ITER_FL_SNAP will read the snapshot image
> > + * and not the main buffer.
> > + *
> > + * Must be paired with ring_buffer_finish.
> > + */
> > +struct ring_buffer_iter *
> > +ring_buffer_start(struct ring_buffer *buffer, unsigned iter_flags)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_iter *iter;
> > +	unsigned long flags;
> > +	int cpu;
> > +
> > +	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
> > +	if (!iter)
> > +		return NULL;
> > +
> > +	iter->buffer = buffer;
> > +	iter->flags = iter_flags;
> > +
> > +	WARN_ON((iter_flags & RB_ITER_FL_SNAP) &&
> > +		!(buffer->flags & RB_FL_SNAPSHOT));
> > +
> > +	atomic_inc(&buffer->record_disabled);
> > +
> > +	ring_buffer_lock(buffer, &flags);
> > +	for (cpu = 0; cpu < buffer->cpus; cpu++) {
> > +		cpu_buffer = iter_choose_buffer(iter, cpu);
> > +		iter->buffers[cpu].head = cpu_buffer->head;
> > +		iter->buffers[cpu].head_page = cpu_buffer->head_page;
> > +	}
> > +	ring_buffer_unlock(buffer, flags);
> > +
> > +	iter->next_cpu = -1;
> > +
> > +	return iter;
> > +}
> > +
> > +/**
> > + * ring_buffer_finish - finish reading the iterator of the buffer
> > + * @iter: The iterator retrieved by ring_buffer_start
> > + *
> > + * This re-enables the recording to the buffer, and frees the
> > + * iterator.
> > + */
> > +void
> > +ring_buffer_finish(struct ring_buffer_iter *iter)
> > +{
> > +	struct ring_buffer *buffer = iter->buffer;
> > +
> > +	atomic_dec(&buffer->record_disabled);
> > +	kfree(iter);
> > +}
> > +
> > +/**
> > + * ring_buffer_peek - peek at the next event to be read
> 
> I don't think we actually need this, the iterator could consume and keep
> it if its not the least valued one.

I use this in ftrace. This is how we get the diff in times and do the
"!" annotation in the latency trace. This peek method was really simple
to implement, and as you can see, easy to reuse code.

> 
> > + * @iter: The ring buffer iterator
> > + * @iter_next_cpu: The CPU that the next event belongs on
> > + *
> > + * This will return the event that will be read next, but does
> > + * not increment the iterator.
> > + */
> > +struct ring_buffer_event *
> > +ring_buffer_peek(struct ring_buffer_iter *iter, int *iter_next_cpu)
> > +{
> > +	struct ring_buffer *buffer = iter->buffer;
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_iter_per_cpu *cpu_iter;
> > +	struct ring_buffer_event *event, *next_event = NULL;
> > +	int cpu, next_cpu = -1;
> > +
> > +	for (cpu = 0; cpu < buffer->cpus; cpu++) {
> > +		cpu_buffer = iter_choose_buffer(iter, cpu);
> > +		cpu_iter = &iter->buffers[cpu];
> > +
> > +		if (ring_buffer_iter_cpu_empty(cpu_iter, cpu_buffer))
> > +			continue;
> > +
> > +		event = cpu_buffer->pages[cpu_iter->head_page] + cpu_iter->head;
> > +
> > +		if (ring_buffer_short_event(buffer, cpu_iter->head) ||
> > +		    ring_buffer_null_event(event)) {
> > +			if (cpu_iter->head_page == cpu_buffer->tail_page)
> > +				continue;
> > +			ring_buffer_inc_page(buffer, &cpu_iter->head_page);
> > +			cpu_iter->head = 0;
> > +
> > +			if (ring_buffer_iter_cpu_empty(cpu_iter, cpu_buffer))
> > +				continue;
> > +
> > +			event = cpu_buffer->pages[cpu_iter->head_page]
> > +				+ cpu_iter->head;
> > +		}
> > +
> > +		if (!next_event || event->counter < next_event->counter) {
> > +			next_cpu = cpu;
> > +			next_event = event;
> > +		}
> > +	}
> > +
> > +	if (!next_event)
> > +		return NULL;
> > +
> > +	if (iter_next_cpu)
> > +		*iter_next_cpu = next_cpu;
> > +
> > +	return next_event;
> > +}
> > +
> > +/**
> > + * ring_buffer_read - read the next item in the ring buffer by the iterator
> > + * @iter: The ring buffer iterator
> > + * @iter_next_cpu: The CPU that the event was read from
> > + *
> > + * This reads the next event in the ring buffer and increments the iterator.
> > + */
> > +struct ring_buffer_event *
> > +ring_buffer_read(struct ring_buffer_iter *iter, int *iter_next_cpu)
> > +{
> > +	struct ring_buffer_event *event;
> > +	int next_cpu;
> > +
> > +	event = ring_buffer_peek(iter, &next_cpu);
> > +	if (!event)
> > +		return NULL;
> > +
> > +	ring_buffer_advance_iter(iter, next_cpu);
> > +
> > +	if (iter_next_cpu)
> > +		*iter_next_cpu = next_cpu;
> > +
> > +	return event;
> > +}
> > +
> > +/**
> > + * ring_buffer_size - return the size of the ring buffer (in bytes)
> > + * @buffer: The ring buffer.
> > + */
> > +unsigned long ring_buffer_size(struct ring_buffer *buffer)
> > +{
> > +	return buffer->page_size * buffer->pages;
> > +}
> > +
> > +/**
> > + * ring_buffer_rename - rename the ring buffer
> 
> Do we actually need this?

I did with ftrace. Since the names of the buffer is exposed to userspace,
 the only way to resize the buffer (currently) was to create a new buffer.
To get back to the old name, I had to free the old buffer, and rename
the new one.  I would have freed the old one first, but if the new one 
fails to allocate, we can not fall back to the old one.

Thanks for the review Peter. Perhaps we can get someone else to look too.
Or at least comment on this discussion.

-- Steve
