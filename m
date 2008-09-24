Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYIXFOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYIXFOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYIXFOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:14:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65342 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYIXFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:14:07 -0400
Message-Id: <20080924051400.195780424@goodmis.org>
References: <20080924051056.650388887@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 01:10:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Tom Zanussi <zanussi@comcast.net>, Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 1/3] Unified trace buffer
Content-Disposition: inline; filename=ring-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC RFC RFC RFC RFC!!!!

Now did I get your attention that this is a request for comment patch.

This is probably very buggy. I ran it as a back end for ftrace but only
tested the irqsoff and ftrace tracers. The selftests are busted with it.

But this is an attempt to get a unified buffering system that was
talked about at the LPC meeting.

I did not get a chance to implement all the event recording and printing
in the debugfs/tracing/buffers directory. But I got enough to do
some ftrace work with it.

Now that it boots and runs (albeit, a bit buggy), I decided to post it.
This is some idea that I had to handle this.

I tried to make it as simple as possible. Basically we have:

buffer = ring_buffer_alloc(size, flags, max_event_size, print_func, name);

We can record either the fast way of reserving a part of the buffer:

event = ring_buffer_lock_reserve(buffer, event_id, length, &flags);
event->data = record_this_data;
ring_buffer_unlock_commit(buffer, event, flags);

Or if we already have the data together:

ring_buffer_write(buffer, event_id, length, data);

We can read by consuming or iterating:

event = ring_buffer_consume(buffer);

iter = ring_buffer_start(buffer, iter_flags);
event = ring_buffer_read(iter, &next_cpu);
ring_buffer_finish(iter);

Note, the iteration part stops recording to the buffer. This is a feature.
If you want producer/consumer, then you should be using the consumer.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |  138 +++
 kernel/trace/Kconfig        |    4 
 kernel/trace/Makefile       |    1 
 kernel/trace/ring_buffer.c  | 1565 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 1708 insertions(+)

Index: linux-compile.git/include/linux/ring_buffer.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/include/linux/ring_buffer.h	2008-09-23 17:45:49.000000000 -0400
@@ -0,0 +1,138 @@
+#ifndef _LINUX_RING_BUFFER_H
+#define _LINUX_RING_BUFFER_H
+
+#include <linux/mm.h>
+#include <linux/seq_file.h>
+
+struct ring_buffer;
+struct ring_buffer_iter;
+
+/*
+ * Don't reference this struct directly, use the inline items below.
+ */
+struct ring_buffer_event {
+	unsigned long long counter;
+	short type;
+	short length;
+	char body[];
+} __attribute__((__packed__));
+
+#define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
+
+static inline unsigned
+ring_buffer_event_type(struct ring_buffer_event *event_handler)
+{
+	return event_handler->type;
+}
+
+static inline unsigned
+ring_buffer_event_length(struct ring_buffer_event *event_handler)
+{
+	return event_handler->length;
+}
+
+static inline void *
+ring_buffer_event_data(struct ring_buffer_event *event_handler)
+{
+	return event_handler->body;
+}
+
+static inline unsigned long long
+ring_buffer_event_counter(struct ring_buffer_event *event_handler)
+{
+	return event_handler->counter;
+}
+
+struct ring_buffer_seq;
+
+unsigned long ring_buffer_max_event_size(struct ring_buffer *buffer);
+
+typedef void (*ring_buffer_print_func) (struct ring_buffer *buffer,
+					struct ring_buffer_seq *seq,
+					struct ring_buffer_event *event);
+
+struct ring_buffer_seq *ring_buffer_seq_alloc(gfp_t flags);
+void ring_buffer_seq_free(struct ring_buffer_seq *seq);
+unsigned ring_buffer_seq_length(struct ring_buffer_seq *seq);
+void ring_buffer_seq_set_length(struct ring_buffer_seq *seq, unsigned len);
+int ring_buffer_seq_printf(struct ring_buffer_seq *seq, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+int ring_buffer_seq_puts(struct ring_buffer_seq *seq, const char *str);
+int ring_buffer_seq_putc(struct ring_buffer_seq *seq, unsigned char c);
+int ring_buffer_seq_putmem(struct ring_buffer_seq *s, void *mem, size_t len);
+int ring_buffer_seq_to_seqfile(struct seq_file *m, struct ring_buffer_seq *s);
+int ring_buffer_seq_putmem_hex(struct ring_buffer_seq *s, void *mem, size_t len);
+ssize_t ring_buffer_seq_copy_to_user(struct ring_buffer_seq *seq,
+				 char __user *ubuf,
+				 size_t cnt);
+int ring_buffer_seq_to_mem(struct ring_buffer_seq *s, void *mem, size_t len);
+void ring_buffer_seq_reset(struct ring_buffer_seq *s);
+
+void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags);
+void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags);
+
+struct ring_buffer *
+ring_buffer_alloc(unsigned long size, unsigned long flags,
+		  unsigned long max_event_size,
+		  ring_buffer_print_func print_func,
+		  const char *name, ...);
+void ring_buffer_free(struct ring_buffer *buffer);
+
+int
+ring_buffer_register_event(struct ring_buffer *buffer, unsigned long length,
+			   ring_buffer_print_func print_func,
+			   int event_type,
+			   const char *name, ...);
+void *ring_buffer_lock_reserve(struct ring_buffer *buffer,
+			       int event_type,
+			       unsigned long length,
+			       unsigned long *flags);
+int ring_buffer_unlock_commit(struct ring_buffer *buffer,
+			      void *data, unsigned long flags);
+
+int ring_buffer_rename(struct ring_buffer *buffer, char *new_name, ...);
+
+void *ring_buffer_write(struct ring_buffer *buffer,
+			int event_type,
+			unsigned long length,
+			void *event);
+
+enum ring_buffer_iter_flags {
+	RB_ITER_FL_SNAP		= 1 << 0,
+};
+
+struct ring_buffer_event *
+ring_buffer_consume(struct ring_buffer *buffer);
+
+struct ring_buffer_iter *
+ring_buffer_start(struct ring_buffer *buffer, unsigned flags);
+void ring_buffer_finish(struct ring_buffer_iter *iter);
+
+struct ring_buffer_event *
+ring_buffer_peek(struct ring_buffer_iter *iter, int *next_cpu);
+
+struct ring_buffer_event *
+ring_buffer_read(struct ring_buffer_iter *iter, int *next_cpu);
+
+unsigned long ring_buffer_size(struct ring_buffer *buffer);
+
+void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
+
+int ring_buffer_empty(struct ring_buffer *buffer);
+
+void ring_buffer_disable(struct ring_buffer *buffer);
+void ring_buffer_enable(struct ring_buffer *buffer);
+
+void ring_buffer_snapshot(struct ring_buffer *buffer);
+void ring_buffer_snapshot_cpu(struct ring_buffer *buffer, int cpu);
+void ring_buffer_snapshot_one_cpu(struct ring_buffer *buffer, int cpu);
+
+unsigned long ring_buffer_entries(struct ring_buffer *buffer);
+unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
+
+enum ring_buffer_flags {
+	RB_FL_OVERWRITE		= 1 << 0,
+	RB_FL_SNAPSHOT		= 1 << 1,
+};
+
+#endif /* _LINUX_RING_BUFFER_H */
Index: linux-compile.git/kernel/trace/ring_buffer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/kernel/trace/ring_buffer.c	2008-09-24 00:46:40.000000000 -0400
@@ -0,0 +1,1565 @@
+/*
+ * Generic ring buffer
+ *
+ * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
+ */
+#include <linux/ring_buffer.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <linux/hash.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+
+#include "trace.h"
+
+#define MAX_NAME_SIZE 256
+#define RING_BUFFER_EVENT_DYN_START 1000
+#define RB_EVENT_HASHBITS	10
+#define RB_EVENT_HASHSIZE	(1<<RB_EVENT_HASHBITS)
+
+/*
+ * head_page == tail_page && head == tail then buffer is empty.
+ */
+struct ring_buffer_per_cpu {
+	int			cpu;
+	struct ring_buffer	*buffer;
+	raw_spinlock_t		lock;
+	struct lock_class_key	lock_key;
+	void			**pages;
+	unsigned long		head;	/* read from head */
+	unsigned long		tail;	/* write to tail */
+	unsigned long		head_page;
+	unsigned long		tail_page;
+	unsigned long		overrun;
+	unsigned long		entries;
+};
+
+struct ring_buffer {
+	char			name[MAX_NAME_SIZE + 1];
+	ring_buffer_print_func	default_func;
+	unsigned long		size;
+	unsigned long		next_event_type;
+	unsigned long		max_event_size;
+	unsigned		pages;
+	unsigned		page_size;
+	unsigned		flags;
+	int			cpus;
+	atomic_t		record_disabled;
+
+	spinlock_t		lock;
+	struct mutex		mutex;
+
+	struct ring_buffer_per_cpu *buffers[NR_CPUS];
+	struct list_head	list;
+	struct list_head	events;
+
+	struct ring_buffer_per_cpu *snap_buffers[NR_CPUS];
+
+	struct hlist_head	event_hash[RB_EVENT_HASHSIZE];
+
+	/* debugfs file entries */
+	struct dentry		*dir_ent;
+	struct dentry		*entry_dir;
+	struct dentry		*text_ent;
+	struct dentry		**binary_ents; /* per cpu */
+};
+
+struct ring_buffer_event_holder {
+	struct ring_buffer	*buffer;
+	struct list_head	list;
+	struct hlist_node	hash;
+	char			*name;
+	unsigned		event_type;
+	unsigned		length;
+	ring_buffer_print_func	print_func;
+};
+
+struct ring_buffer_iter_per_cpu {
+	unsigned long			head;
+	unsigned long			head_page;
+};
+
+struct ring_buffer_iter {
+	struct ring_buffer		*buffer;
+	struct ring_buffer_iter_per_cpu	buffers[NR_CPUS];
+	int				next_cpu;
+	unsigned			flags;
+};
+
+struct ring_buffer_seq {
+	unsigned char		buffer[PAGE_SIZE];
+	unsigned int		len;
+	unsigned int		readpos;
+};
+
+static struct file_operations text_fops = {
+#if 0
+	.open		= text_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= text_release,
+#endif
+};
+
+static struct file_operations binary_fops = {
+#if 0
+	.open		= binary_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= binary_release,
+#endif
+};
+
+/* FIXME!!! */
+unsigned long long
+ring_buffer_next_counter(int cpu)
+{
+	return sched_clock();
+}
+
+DEFINE_MUTEX(buffer_mutex);
+static LIST_HEAD(ring_buffer_list);
+static struct dentry *buffer_dent;
+#define TEMP_BUFFER_SIZE 1023
+static char temp_buffer[TEMP_BUFFER_SIZE+1];
+
+static int ring_buffer_register_debugfs(struct ring_buffer *buffer)
+{
+	struct dentry *tracing_dent;
+	struct dentry *dentry;
+	struct dentry *entry;
+	char name_buf[32];
+	int ret = -ENOMEM, i;
+
+	if (!buffer_dent) {
+		tracing_dent = tracing_init_dentry();
+		buffer_dent = debugfs_create_dir("buffers", tracing_dent);
+		if (!buffer_dent) {
+			pr_warning("Could not create debugfs directory"
+				   " 'tracing/buffers'\n");
+			return ret;
+		}
+	}
+
+	buffer->binary_ents = kzalloc(sizeof(struct dentry *) * buffer->cpus,
+				      GFP_KERNEL);
+	if (!buffer->binary_ents)
+		return ret;
+
+	dentry = debugfs_create_dir(buffer->name, buffer_dent);
+	if (!dentry)
+		goto free_binary_ents;
+	buffer->dir_ent = dentry;
+
+	entry = debugfs_create_file("text", 0444, dentry,
+				    buffer, &text_fops);
+	if (!entry)
+		goto fail_free_dir;
+	buffer->text_ent = entry;
+
+	for (i = 0; i < buffer->cpus; i++) {
+		snprintf(name_buf, 32, "binary%d", i);
+		entry = debugfs_create_file(name_buf, 0444, dentry,
+					    buffer->buffers[i], &binary_fops);
+		if (!entry)
+			goto fail_free_ents;
+		buffer->binary_ents[i] = entry;
+	}
+
+	return 0;
+
+ fail_free_ents:
+	debugfs_remove(buffer->text_ent);
+	for (i = 0; i < buffer->cpus; i++) {
+		if (buffer->binary_ents[i])
+			debugfs_remove(buffer->binary_ents[i]);
+	}
+
+ fail_free_dir:
+	kfree(buffer->binary_ents);
+	debugfs_remove(dentry);
+
+ free_binary_ents:
+	kfree(buffer->binary_ents);
+	return -1;
+}
+
+static void ring_buffer_unregister_debugfs(struct ring_buffer *buffer)
+{
+	/* fast and simple for now */
+	debugfs_remove_recursive(buffer->dir_ent);
+}
+
+static struct ring_buffer_per_cpu *
+ring_buffer_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int pages = buffer->pages;
+	int i;
+
+	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
+				  GFP_KERNEL, cpu_to_node(cpu));
+	if (!cpu_buffer)
+		return NULL;
+
+	cpu_buffer->cpu = cpu;
+	cpu_buffer->buffer = buffer;
+	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
+	cpu_buffer->pages = kzalloc_node(ALIGN(sizeof(void *) * pages,
+					       cache_line_size()), GFP_KERNEL,
+					 cpu_to_node(cpu));
+	if (!cpu_buffer->pages)
+		goto fail_free_buffer;
+
+	for (i = 0; i < pages; i++) {
+		cpu_buffer->pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!cpu_buffer->pages[i])
+			goto fail_free_pages;
+	}
+
+	return cpu_buffer;
+
+ fail_free_pages:
+	for (i = 0; i < pages; i++) {
+		if (cpu_buffer->pages[i])
+			free_page((unsigned long)cpu_buffer->pages[i]);
+	}
+	kfree(cpu_buffer->pages);
+
+ fail_free_buffer:
+	kfree(cpu_buffer);
+	return NULL;
+}
+
+static void
+ring_buffer_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	int i;
+
+	for (i = 0; i < cpu_buffer->buffer->pages; i++) {
+		if (cpu_buffer->pages[i])
+			free_page((unsigned long)cpu_buffer->pages[i]);
+	}
+	kfree(cpu_buffer->pages);
+	kfree(cpu_buffer);
+}
+
+struct ring_buffer *
+ring_buffer_alloc(unsigned long size, unsigned long flags,
+		  unsigned long max_event_size,
+		  ring_buffer_print_func print_func,
+		  const char *name, ...)
+{
+	struct ring_buffer *buffer, *p;
+	va_list args;
+	int order = 0;
+	int ret = 0;
+	int cpu;
+
+	/* For now, we only allow max of page size */
+	if (max_event_size > PAGE_SIZE) {
+		WARN_ON(1);
+		return NULL;
+	}
+	max_event_size = PAGE_SIZE;
+
+	mutex_lock(&buffer_mutex);
+
+	/* keep it in its own cache line */
+	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
+			 GFP_KERNEL);
+	if (!buffer)
+		goto fail_unlock;
+
+	va_start(args, name);
+	vsnprintf(buffer->name, MAX_NAME_SIZE, name, args);
+	va_end(args);
+
+	buffer->name[MAX_NAME_SIZE] = 0;
+	/* FIXME; this should be better than a linear search */
+	list_for_each_entry(p, &ring_buffer_list, list) {
+		if (strcmp(p->name, buffer->name) == 0) {
+			ret = -EBUSY;
+			break;
+		}
+	}
+	if (ret)
+		goto fail_free_buffer;
+
+	buffer->page_size = 1 << order << PAGE_SHIFT;
+	buffer->next_event_type = RING_BUFFER_EVENT_DYN_START;
+	buffer->max_event_size = max_event_size;
+	INIT_LIST_HEAD(&buffer->events);
+
+	buffer->default_func = print_func;
+	buffer->pages = (size + (buffer->page_size - 1)) / buffer->page_size;
+	buffer->flags = flags;
+
+	/* need at least two pages */
+	if (buffer->pages == 1)
+		buffer->pages++;
+
+	/* FIXME: do for only online CPUS */
+	buffer->cpus = num_possible_cpus();
+	for_each_possible_cpu(cpu) {
+		if (cpu >= buffer->cpus)
+			continue;
+		buffer->buffers[cpu] =
+			ring_buffer_allocate_cpu_buffer(buffer, cpu);
+		if (!buffer->buffers[cpu])
+			goto fail_free_buffers;
+	}
+
+	if (flags & RB_FL_SNAPSHOT) {
+		for_each_possible_cpu(cpu) {
+			if (cpu >= buffer->cpus)
+				continue;
+			buffer->snap_buffers[cpu] =
+				ring_buffer_allocate_cpu_buffer(buffer, cpu);
+			if (!buffer->snap_buffers[cpu])
+				goto fail_free_snap_buffers;
+		}
+	}
+
+	ret = ring_buffer_register_debugfs(buffer);
+	if (ret)
+		goto fail_free_snap_buffers;
+
+	spin_lock_init(&buffer->lock);
+	mutex_init(&buffer->mutex);
+
+	mutex_unlock(&buffer_mutex);
+
+	return buffer;
+
+ fail_free_snap_buffers:
+	if (!(flags & RB_FL_SNAPSHOT))
+		goto fail_free_buffers;
+
+	for_each_possible_cpu(cpu) {
+		if (cpu >= buffer->cpus)
+			continue;
+		if (buffer->snap_buffers[cpu])
+			ring_buffer_free_cpu_buffer(buffer->snap_buffers[cpu]);
+	}
+
+ fail_free_buffers:
+	for_each_possible_cpu(cpu) {
+		if (cpu >= buffer->cpus)
+			continue;
+		if (buffer->buffers[cpu])
+			ring_buffer_free_cpu_buffer(buffer->buffers[cpu]);
+	}
+
+ fail_free_buffer:
+	kfree(buffer);
+
+ fail_unlock:
+	mutex_unlock(&buffer_mutex);
+	return NULL;
+}
+
+static struct ring_buffer_event_holder *
+__ring_buffer_find_event(struct ring_buffer *buffer, int event_type)
+{
+	struct ring_buffer_event_holder *p;
+	struct hlist_node *t;
+	unsigned long key;
+
+	key = hash_long(event_type, RB_EVENT_HASHBITS);
+
+	hlist_for_each_entry_rcu(p, t, &buffer->event_hash[key], hash) {
+		if (p->event_type == event_type)
+			return p;
+	}
+
+	return NULL;
+}
+
+/**
+ * ring_buffer_register_event - register an event to a ring buffer
+ * @buffer: the buffer to register the event to.
+ * @length: the length of the event
+ * @print_func: The pretty print output to handle this event.
+ * @event_type: Set the event type, or 0 to have one given
+ * @name: The name of this event, to show in the debugfs.
+ *
+ * This function allows events to be registered, as well as adding
+ * a function to handle how to show this event in text format.
+ * The event_type must be less than 1000, since that is where
+ * the dynamic event types start. Event types are unique to buffers.
+ */
+int
+ring_buffer_register_event(struct ring_buffer *buffer, unsigned long length,
+			   ring_buffer_print_func print_func,
+			   int event_type,
+			   const char *name, ...)
+{
+	struct ring_buffer_event_holder *ptr, *event;
+	struct list_head *p;
+	va_list args, args2;
+	unsigned long key;
+	int r;
+
+	if (event_type >= RING_BUFFER_EVENT_DYN_START)
+		return -EINVAL;
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	event->print_func = print_func;
+
+	mutex_lock(&buffer->mutex);
+
+	if (!event_type)
+		event_type = buffer->next_event_type++;
+
+	ptr = __ring_buffer_find_event(buffer, event_type);
+	if (ptr) {
+		event_type = -EBUSY;
+		kfree(event);
+		goto out;
+	}
+
+	va_start(args, name);
+	va_copy(args2, args);
+	r = vsnprintf(temp_buffer, TEMP_BUFFER_SIZE, name, args);
+
+	event->name = kzalloc(r+1, GFP_KERNEL);
+	if (!event->name) {
+		va_end(args2);
+		va_end(args);
+		kfree(event);
+		return -ENOMEM;
+	}
+
+	if (unlikely(r >= TEMP_BUFFER_SIZE))
+		vsnprintf(event->name, r+1, name, args2);
+	else
+		strcpy(event->name, temp_buffer);
+
+	va_end(args2);
+	va_end(args);
+
+	list_for_each(p, &buffer->events) {
+		ptr = list_entry(p, struct ring_buffer_event_holder, list);
+		r = strcmp(event->name, ptr->name);
+		if (!r) {
+			WARN_ON(1);
+			kfree(event->name);
+			kfree(event);
+			event = NULL;
+			goto out;
+		}
+		if (r < 0)
+			break;
+	}
+
+	list_add_tail(&event->list, p);
+
+	key = hash_long(event_type, RB_EVENT_HASHBITS);
+	hlist_add_head_rcu(&event->hash, &buffer->event_hash[key]);
+
+ out:
+	mutex_unlock(&buffer->mutex);
+	return event_type;
+}
+
+static void
+ring_buffer_event_free(struct ring_buffer_event_holder *event)
+{
+	kfree(event->name);
+	kfree(event);
+}
+
+/**
+ * ring_buffer_free - free a ring buffer.
+ * @buffer: the buffer to free.
+ */
+void
+ring_buffer_free(struct ring_buffer *buffer)
+{
+	struct ring_buffer_event_holder *event_holder, *n;
+	int cpu;
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++)
+		ring_buffer_free_cpu_buffer(buffer->buffers[cpu]);
+
+	list_for_each_entry_safe(event_holder, n,
+				 &buffer->events, list)
+		ring_buffer_event_free(event_holder);
+
+	ring_buffer_unregister_debugfs(buffer);
+	kfree(buffer);
+}
+
+/**
+ * ring_buffer_max_event_size - return max_event_size of the buffer
+ * @buffer: the buffer to get the max event size that is allowed.
+ *
+ * Returns the max event size allowed for the given buffer.
+ */
+unsigned long
+ring_buffer_max_event_size(struct ring_buffer *buffer)
+{
+	return buffer->max_event_size;
+}
+
+static inline int
+ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->head_page == cpu_buffer->tail_page &&
+		cpu_buffer->head == cpu_buffer->tail;
+}
+
+static inline int
+ring_buffer_null_event(struct ring_buffer_event *event)
+{
+	return !event->type && !event->counter;
+}
+
+static inline int
+ring_buffer_short_event(struct ring_buffer *buffer, unsigned long ptr)
+{
+	return ptr + RB_EVNT_HDR_SIZE > buffer->page_size;
+}
+
+static void
+ring_buffer_update_overflow(struct ring_buffer_per_cpu *cpu_buffer,
+			    unsigned long head_page)
+{
+	struct ring_buffer *buffer = cpu_buffer->buffer;
+	struct ring_buffer_event *event;
+	unsigned long head;
+
+	for (head = 0; head < buffer->page_size; head += event->length) {
+		if (ring_buffer_short_event(buffer, head))
+			break;
+		event = cpu_buffer->pages[cpu_buffer->head_page] + head;
+		if (ring_buffer_null_event(event))
+			break;
+		cpu_buffer->overrun++;
+		cpu_buffer->entries--;
+	}
+}
+
+static inline void
+ring_buffer_inc_page(struct ring_buffer *buffer,
+		     unsigned long *page)
+{
+	(*page)++;
+	if (*page >= buffer->pages)
+		*page = 0;
+}
+
+static struct ring_buffer_event *
+ring_buffer_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
+			   unsigned long length)
+{
+	unsigned long head_page, tail_page, tail;
+	struct ring_buffer *buffer = cpu_buffer->buffer;
+	struct ring_buffer_event *event;
+
+	if (length > buffer->page_size)
+		return NULL;
+
+	tail_page = cpu_buffer->tail_page;
+	head_page = cpu_buffer->head_page;
+	tail = cpu_buffer->tail;
+
+	BUG_ON(tail_page >= buffer->pages);
+	BUG_ON(head_page >= buffer->pages);
+
+	if (tail + length > buffer->page_size) {
+		unsigned long next_page = tail_page;
+
+		ring_buffer_inc_page(buffer, &next_page);
+
+		if (next_page == head_page) {
+			if (!(buffer->flags & RB_FL_OVERWRITE))
+				return NULL;
+
+			/* count overflows */
+			ring_buffer_update_overflow(cpu_buffer, head_page);
+
+			ring_buffer_inc_page(buffer, &head_page);
+			cpu_buffer->head_page = head_page;
+			cpu_buffer->head = 0;
+		}
+
+		if (!ring_buffer_short_event(buffer, tail)) {
+			event = cpu_buffer->pages[tail_page] + tail;
+			/* empty event */
+			event->counter = 0;
+			event->type = 0;
+			event->length = buffer->page_size - tail;
+		}
+
+		tail = 0;
+		tail_page = next_page;
+		cpu_buffer->tail_page = tail_page;
+		cpu_buffer->tail = tail;
+	}
+
+	BUG_ON(tail_page >= buffer->pages);
+	BUG_ON(ring_buffer_short_event(buffer, tail));
+
+	event = cpu_buffer->pages[tail_page] + tail;
+	event->length = length;
+	cpu_buffer->entries++;
+
+	return event;
+}
+
+/**
+ * ring_buffer_lock_reserve - reserve a part of the buffer
+ * @buffer: the ring buffer to reserve from
+ * @event_type: the event type to reserve
+ * @length: the length of the data to reserve (excluding event header)
+ * @flags: a pointer to save the interrupt flags
+ *
+ * Returns a location on the ring buffer to copy directly to.
+ * The length is the length of the data needed, not the event length
+ * which also includes the event header.
+ *
+ * Must be paired with ring_buffer_unlock_commit, unless NULL is returned.
+ * If NULL is returned, then nothing has been allocated or locked.
+ */
+void *ring_buffer_lock_reserve(struct ring_buffer *buffer,
+			       int event_type,
+			       unsigned long length,
+			       unsigned long *flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	int cpu;
+
+	if (atomic_read(&buffer->record_disabled))
+		return NULL;
+
+	raw_local_irq_save(*flags);
+	cpu = raw_smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+	__raw_spin_lock(&cpu_buffer->lock);
+
+	if (atomic_read(&buffer->record_disabled))
+		goto no_record;
+
+	length += RB_EVNT_HDR_SIZE;
+	length = ALIGN(length, 8);
+	WARN_ON(length > buffer->max_event_size);
+	event = ring_buffer_reserve_next_event(cpu_buffer, length);
+	if (!event)
+		goto no_record;
+
+	event->counter = ring_buffer_next_counter(cpu_buffer->cpu);
+	event->type = event_type;
+
+	return &event->body;
+
+ no_record:
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(*flags);
+	return NULL;
+}
+
+/**
+ * ring_buffer_unlock_commit - commit a reserved
+ * @buffer: The buffer to commit to
+ * @data: The data pointer to commit.
+ * @flags: the interrupt flags received from ring_buffer_lock_reserve.
+ *
+ * This commits the data to the ring buffer, and releases any locks held.
+ *
+ * Must be paired with ring_buffer_lock_reserve.
+ */
+int ring_buffer_unlock_commit(struct ring_buffer *buffer, void *data, unsigned long flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event =
+		container_of(data, struct ring_buffer_event, body);
+
+	int cpu = raw_smp_processor_id();
+
+	cpu_buffer = buffer->buffers[cpu];
+
+	cpu_buffer->tail += event->length;
+
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
+
+	return 0;
+}
+
+/**
+ * ring_buffer_write - write data to the buffer without reserving
+ * @buffer: The ring buffer to write to.
+ * @event_type: The event type to write to.
+ * @length: The length of the data being written (excluding the event header)
+ * @data: The data to write to the buffer.
+ *
+ * This is like ring_buffer_lock_reserve and ring_buffer_unlock_commit as
+ * one function. If you already have the data to write to the buffer, it
+ * may be easier to simply call this function.
+ *
+ * Note, like ring_buffer_lock_reserve, the length is the length of the data
+ * and not the length of the event which would hold the header.
+ */
+void *ring_buffer_write(struct ring_buffer *buffer,
+			int event_type,
+			unsigned long length,
+			void *data)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+	unsigned long event_length, flags;
+	void *ret = NULL;
+	int cpu;
+
+	if (atomic_read(&buffer->record_disabled))
+		return NULL;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+	__raw_spin_lock(&cpu_buffer->lock);
+
+	if (atomic_read(&buffer->record_disabled))
+		goto out;
+
+	event_length = ALIGN(length + RB_EVNT_HDR_SIZE, 8);
+	event = ring_buffer_reserve_next_event(cpu_buffer, event_length);
+	if (!event)
+		goto out;
+
+	event->counter = ring_buffer_next_counter(cpu_buffer->cpu);
+	event->type = event_type;
+	memcpy(&event->body, data, length);
+
+	cpu_buffer->tail += event->length;
+
+	ret = event->body;
+ out:
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+/**
+ * ring_buffer_lock - lock the ring buffer
+ * @buffer: The ring buffer to lock
+ * @flags: The place to store the interrupt flags
+ *
+ * This locks all the per CPU buffers.
+ *
+ * Must be unlocked by ring_buffer_unlock.
+ */
+void ring_buffer_lock(struct ring_buffer *buffer, unsigned long *flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	local_irq_save(*flags);
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+
+		cpu_buffer = buffer->buffers[cpu];
+		__raw_spin_lock(&cpu_buffer->lock);
+	}
+}
+
+/**
+ * ring_buffer_unlock - unlock a locked buffer
+ * @buffer: The locked buffer to unlock
+ * @flags: The interrupt flags received by ring_buffer_lock
+ */
+void ring_buffer_unlock(struct ring_buffer *buffer, unsigned long flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	for (cpu = buffer->cpus - 1; cpu >= 0; cpu--) {
+
+		cpu_buffer = buffer->buffers[cpu];
+		__raw_spin_unlock(&cpu_buffer->lock);
+	}
+
+	local_irq_restore(flags);
+}
+
+/**
+ * ring_buffer_record_disable - stop all writes into the buffer
+ * @buffer: The ring buffer to stop writes to.
+ *
+ * This prevents all writes to the buffer. Any attempt to write
+ * to the buffer after this will fail and return NULL.
+ */
+void ring_buffer_record_disable(struct ring_buffer *buffer)
+{
+	atomic_inc(&buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_record_enable - enable writes to the buffer
+ * @buffer: The ring buffer to enable writes
+ *
+ * Note, multiple disables will need the same number of enables
+ * to truely enable the writing (much like preempt_disable).
+ */
+void ring_buffer_record_enable(struct ring_buffer *buffer)
+{
+	atomic_dec(&buffer->record_disabled);
+}
+
+/**
+ * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the entries from.
+ */
+unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return cpu_buffer->entries;
+}
+
+/**
+ * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	cpu_buffer = buffer->buffers[cpu];
+	return cpu_buffer->overrun;
+}
+
+/**
+ * ring_buffer_entries - get the number of entries in a buffer
+ * @buffer: The ring buffer
+ *
+ * Returns the total number of entries in the ring buffer
+ * (all CPU entries)
+ */
+unsigned long ring_buffer_entries(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long entries = 0;
+	int cpu;
+
+	/* if you care about this being correct, lock the buffer */
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+		entries += cpu_buffer->entries;
+	}
+
+	return entries;
+}
+
+/**
+ * ring_buffer_overrun_cpu - get the number of overruns in buffer
+ * @buffer: The ring buffer
+ *
+ * Returns the total number of overruns in the ring buffer
+ * (all CPU entries)
+ */
+unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long overruns = 0;
+	int cpu;
+
+	/* if you care about this being correct, lock the buffer */
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+		overruns += cpu_buffer->overrun;
+	}
+
+	return overruns;
+}
+
+static inline int
+ring_buffer_iter_cpu_empty(struct ring_buffer_iter_per_cpu *cpu_iter,
+			   struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_iter->head_page == cpu_buffer->tail_page &&
+		cpu_iter->head == cpu_buffer->tail;
+}
+
+static inline struct ring_buffer_per_cpu *
+iter_choose_buffer(struct ring_buffer_iter *iter, int cpu)
+{
+	struct ring_buffer *buffer = iter->buffer;
+
+	if (iter->flags & RB_ITER_FL_SNAP)
+		return buffer->snap_buffers[cpu];
+	else
+		return buffer->buffers[cpu];
+}
+
+static void
+ring_buffer_advance_head(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct ring_buffer *buffer = cpu_buffer->buffer;
+	struct ring_buffer_event *event;
+
+	event = cpu_buffer->pages[cpu_buffer->head_page] + cpu_buffer->head;
+
+	if (ring_buffer_short_event(buffer, cpu_buffer->head) ||
+	    ring_buffer_null_event(event)) {
+		BUG_ON(cpu_buffer->head_page == cpu_buffer->tail_page);
+		ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
+		cpu_buffer->head = 0;
+		return;
+	}
+
+	BUG_ON((cpu_buffer->head_page == cpu_buffer->tail_page) &&
+	       (cpu_buffer->head + event->length > cpu_buffer->tail));
+
+	cpu_buffer->head += event->length;
+	if (ring_buffer_short_event(buffer, cpu_buffer->head)) {
+		ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
+		cpu_buffer->head = 0;
+		return;
+	}
+
+	/* check for end of page padding */
+	event = cpu_buffer->pages[cpu_buffer->head_page] + cpu_buffer->head;
+	if ((ring_buffer_short_event(buffer, cpu_buffer->head) ||
+	     ring_buffer_null_event(event)) &&
+	    (cpu_buffer->head_page != cpu_buffer->tail_page))
+		ring_buffer_advance_head(cpu_buffer);
+}
+
+static void
+ring_buffer_advance_iter(struct ring_buffer_iter *iter, int cpu)
+{
+	struct ring_buffer *buffer = iter->buffer;
+	struct ring_buffer_iter_per_cpu *cpu_iter = &iter->buffers[cpu];
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event;
+
+	cpu_buffer = iter_choose_buffer(iter, cpu);
+	event = cpu_buffer->pages[cpu_iter->head_page] + cpu_iter->head;
+
+	if (ring_buffer_short_event(buffer, cpu_iter->head) ||
+	    ring_buffer_null_event(event)) {
+		BUG_ON(cpu_iter->head_page == cpu_buffer->tail_page);
+		ring_buffer_inc_page(buffer, &cpu_iter->head_page);
+		cpu_iter->head = 0;
+		return;
+	}
+
+	BUG_ON((cpu_iter->head_page == cpu_buffer->tail_page) &&
+	       (cpu_iter->head + event->length > cpu_buffer->tail));
+
+	cpu_iter->head += event->length;
+	if (ring_buffer_short_event(buffer, cpu_iter->head)) {
+		ring_buffer_inc_page(buffer, &cpu_iter->head_page);
+		cpu_iter->head = 0;
+		return;
+	}
+
+	/* check for end of page padding */
+	event = cpu_buffer->pages[cpu_iter->head_page] + cpu_iter->head;
+	if ((ring_buffer_short_event(buffer, cpu_iter->head) ||
+	     ring_buffer_null_event(event)) &&
+	    (cpu_iter->head_page != cpu_buffer->tail_page))
+		ring_buffer_advance_iter(iter, cpu);
+}
+
+/**
+ * ring_buffer_consume - return an event and consume it
+ * @buffer: The ring buffer to get the next event from
+ *
+ * Returns the next event in the ring buffer, and that event is consumed.
+ * Meaning, that sequential reads will keep returning a different event,
+ * and eventually empty the ring buffer if the producer is slower.
+ */
+struct ring_buffer_event *
+ring_buffer_consume(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event, *next_event = NULL;
+	int cpu, next_cpu = -1;
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+		if (ring_buffer_per_cpu_empty(cpu_buffer))
+			continue;
+
+		event = cpu_buffer->pages[cpu_buffer->head_page] +
+			cpu_buffer->head;
+		if (unlikely(ring_buffer_short_event(buffer, cpu_buffer->head) ||
+			     ring_buffer_null_event(event))) {
+			if (cpu_buffer->head_page == cpu_buffer->tail_page)
+				continue;
+			ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
+			cpu_buffer->head = 0;
+
+			if (ring_buffer_per_cpu_empty(cpu_buffer))
+				continue;
+			event = cpu_buffer->pages[cpu_buffer->head_page] +
+				cpu_buffer->head;
+		}
+
+		if (!next_event || event->counter < next_event->counter) {
+			next_cpu = cpu;
+			next_event = event;
+		}
+	}
+
+	if (!next_event)
+		return NULL;
+
+	cpu_buffer = buffer->buffers[next_cpu];
+	ring_buffer_advance_head(cpu_buffer);
+	cpu_buffer->entries--;
+
+	return next_event;
+}
+
+/**
+ * ring_buffer_start - start a non consuming read of the buffer
+ * @buffer: The ring buffer to read from
+ * @iter_flags: control flags on how to read the buffer.
+ *
+ * This starts up an iteration through the buffer. It also disables
+ * the recording to the buffer until the reading is finished.
+ * This prevents the reading from being corrupted. This is not
+ * a consuming read, so a producer is not expected.
+ *
+ * The iter_flags of RB_ITER_FL_SNAP will read the snapshot image
+ * and not the main buffer.
+ *
+ * Must be paired with ring_buffer_finish.
+ */
+struct ring_buffer_iter *
+ring_buffer_start(struct ring_buffer *buffer, unsigned iter_flags)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_iter *iter;
+	unsigned long flags;
+	int cpu;
+
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return NULL;
+
+	iter->buffer = buffer;
+	iter->flags = iter_flags;
+
+	WARN_ON((iter_flags & RB_ITER_FL_SNAP) &&
+		!(buffer->flags & RB_FL_SNAPSHOT));
+
+	atomic_inc(&buffer->record_disabled);
+
+	ring_buffer_lock(buffer, &flags);
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = iter_choose_buffer(iter, cpu);
+		iter->buffers[cpu].head = cpu_buffer->head;
+		iter->buffers[cpu].head_page = cpu_buffer->head_page;
+	}
+	ring_buffer_unlock(buffer, flags);
+
+	iter->next_cpu = -1;
+
+	return iter;
+}
+
+/**
+ * ring_buffer_finish - finish reading the iterator of the buffer
+ * @iter: The iterator retrieved by ring_buffer_start
+ *
+ * This re-enables the recording to the buffer, and frees the
+ * iterator.
+ */
+void
+ring_buffer_finish(struct ring_buffer_iter *iter)
+{
+	struct ring_buffer *buffer = iter->buffer;
+
+	atomic_dec(&buffer->record_disabled);
+	kfree(iter);
+}
+
+/**
+ * ring_buffer_peek - peek at the next event to be read
+ * @iter: The ring buffer iterator
+ * @iter_next_cpu: The CPU that the next event belongs on
+ *
+ * This will return the event that will be read next, but does
+ * not increment the iterator.
+ */
+struct ring_buffer_event *
+ring_buffer_peek(struct ring_buffer_iter *iter, int *iter_next_cpu)
+{
+	struct ring_buffer *buffer = iter->buffer;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_iter_per_cpu *cpu_iter;
+	struct ring_buffer_event *event, *next_event = NULL;
+	int cpu, next_cpu = -1;
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = iter_choose_buffer(iter, cpu);
+		cpu_iter = &iter->buffers[cpu];
+
+		if (ring_buffer_iter_cpu_empty(cpu_iter, cpu_buffer))
+			continue;
+
+		event = cpu_buffer->pages[cpu_iter->head_page] + cpu_iter->head;
+
+		if (ring_buffer_short_event(buffer, cpu_iter->head) ||
+		    ring_buffer_null_event(event)) {
+			if (cpu_iter->head_page == cpu_buffer->tail_page)
+				continue;
+			ring_buffer_inc_page(buffer, &cpu_iter->head_page);
+			cpu_iter->head = 0;
+
+			if (ring_buffer_iter_cpu_empty(cpu_iter, cpu_buffer))
+				continue;
+
+			event = cpu_buffer->pages[cpu_iter->head_page]
+				+ cpu_iter->head;
+		}
+
+		if (!next_event || event->counter < next_event->counter) {
+			next_cpu = cpu;
+			next_event = event;
+		}
+	}
+
+	if (!next_event)
+		return NULL;
+
+	if (iter_next_cpu)
+		*iter_next_cpu = next_cpu;
+
+	return next_event;
+}
+
+/**
+ * ring_buffer_read - read the next item in the ring buffer by the iterator
+ * @iter: The ring buffer iterator
+ * @iter_next_cpu: The CPU that the event was read from
+ *
+ * This reads the next event in the ring buffer and increments the iterator.
+ */
+struct ring_buffer_event *
+ring_buffer_read(struct ring_buffer_iter *iter, int *iter_next_cpu)
+{
+	struct ring_buffer_event *event;
+	int next_cpu;
+
+	event = ring_buffer_peek(iter, &next_cpu);
+	if (!event)
+		return NULL;
+
+	ring_buffer_advance_iter(iter, next_cpu);
+
+	if (iter_next_cpu)
+		*iter_next_cpu = next_cpu;
+
+	return event;
+}
+
+/**
+ * ring_buffer_size - return the size of the ring buffer (in bytes)
+ * @buffer: The ring buffer.
+ */
+unsigned long ring_buffer_size(struct ring_buffer *buffer)
+{
+	return buffer->page_size * buffer->pages;
+}
+
+/**
+ * ring_buffer_rename - rename the ring buffer
+ * @buffer: The ring buffer to rename
+ * @new_name: The new name to rename the ring buffer to
+ */
+int ring_buffer_rename(struct ring_buffer *buffer, char *new_name, ...)
+{
+	va_list args;
+	int ret;
+
+	mutex_lock(&buffer_mutex);
+
+	va_start(args, new_name);
+	vsnprintf(buffer->name, MAX_NAME_SIZE, new_name, args);
+	va_end(args);
+
+	buffer->dir_ent = debugfs_rename(buffer_dent, buffer->dir_ent,
+					 buffer_dent, buffer->name);
+	if (!buffer->dir_ent) {
+		WARN_ON(1);
+		ret = -EBUSY;
+	}
+
+	mutex_unlock(&buffer_mutex);
+
+	return ret;
+}
+
+static void
+__ring_buffer_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer, int cpu)
+{
+	cpu_buffer->head_page = cpu_buffer->tail_page = 0;
+	cpu_buffer->head = cpu_buffer->tail = 0;
+	cpu_buffer->overrun = 0;
+	cpu_buffer->entries = 0;
+}
+
+/**
+ * ring_buffer_reset_cpu - reset a ring buffer per CPU buffer
+ * @buffer: The ring buffer to reset a per cpu buffer of
+ * @cpu: The CPU buffer to be reset
+ */
+void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&cpu_buffer->lock);
+
+	__ring_buffer_reset_cpu(cpu_buffer, cpu);
+
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
+}
+
+/**
+ * rind_buffer_empty - is the ring buffer empty?
+ * @buffer: The ring buffer to test
+ */
+int ring_buffer_empty(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	/* yes this is racy, but if you don't like the race, lock the buffer */
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+		if (!ring_buffer_per_cpu_empty(cpu_buffer))
+			return 0;
+	}
+	return 1;
+}
+
+/**
+ * ring_buffer_empty_cpu - is a cpu buffer of a ring buffer empty?
+ * @buffer: The ring buffer
+ * @cpu: The CPU buffer to test
+ */
+int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	/* yes this is racy, but if you don't like the race, lock the buffer */
+	cpu_buffer = buffer->buffers[cpu];
+	return ring_buffer_per_cpu_empty(cpu_buffer);
+}
+
+/**
+ * ring_buffer_snapshot_cpu - take a snapshot of a current ring buffer cpu buffer
+ * @buffer: The ring buffer
+ * @cpu: Take a snapshot of this CPU buffer
+ *
+ * A snapshot of the per CPU buffer is saved and the main buffer is
+ * replaced. This allows live traces to have a snap shot taken.
+ * This is very effective when needing to take maximums and still record
+ * new traces.
+ */
+void ring_buffer_snapshot_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	cpu_buffer = buffer->buffers[cpu];
+
+	__raw_spin_lock(&cpu_buffer->lock);
+	__ring_buffer_reset_cpu(buffer->snap_buffers[cpu], cpu);
+	buffer->buffers[cpu] = buffer->snap_buffers[cpu];
+	buffer->snap_buffers[cpu] = cpu_buffer;
+
+	__raw_spin_unlock(&cpu_buffer->lock);
+	raw_local_irq_restore(flags);
+}
+
+/**
+ * ring_buffer_snapshot_one_cpu - take a snapshot of cpu and zero the rest
+ * @buffer: The ring buffer
+ * @cpu: Take a snapshot of this CPU buffer
+ *
+ * A snapshot of the per CPU buffer is saved and the main buffer is
+ * replaced. This allows live traces to have a snap shot taken.
+ * This is very effective when needing to take maximums and still record
+ * new traces.
+ *
+ * This function will not only snapshot a particular CPU buffer, but it
+ * will also zero the others. This facilitates reading the snapshot buffer
+ * if only one buffer is of interest.
+ */
+void ring_buffer_snapshot_one_cpu(struct ring_buffer *buffer, int snap_cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+	int cpu;
+
+	raw_local_irq_save(flags);
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		__raw_spin_lock(&cpu_buffer->lock);
+		__ring_buffer_reset_cpu(buffer->snap_buffers[cpu], cpu);
+		if (cpu == snap_cpu) {
+			buffer->buffers[cpu] = buffer->snap_buffers[cpu];
+			buffer->snap_buffers[cpu] = cpu_buffer;
+		}
+		__raw_spin_unlock(&cpu_buffer->lock);
+	}
+
+	raw_local_irq_restore(flags);
+}
+
+/**
+ * ring_buffer_snapshot - take a snapshot of the ring buffer
+ * @buffer: The ring buffer
+ *
+ * A snapshot of the entire ring buffer is saved, and can be
+ * retrieved later, even when we currently have a live trace
+ * recording.
+ */
+void ring_buffer_snapshot(struct ring_buffer *buffer)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
+	int cpu;
+
+	raw_local_irq_save(flags);
+
+	for (cpu = 0; cpu < buffer->cpus; cpu++) {
+		cpu_buffer = buffer->buffers[cpu];
+
+		__raw_spin_lock(&cpu_buffer->lock);
+		__ring_buffer_reset_cpu(buffer->snap_buffers[cpu], cpu);
+		buffer->buffers[cpu] = buffer->snap_buffers[cpu];
+		buffer->snap_buffers[cpu] = cpu_buffer;
+		__raw_spin_unlock(&cpu_buffer->lock);
+	}
+
+	raw_local_irq_restore(flags);
+}
+
+struct ring_buffer_seq *
+ring_buffer_seq_alloc(gfp_t flags)
+{
+	struct ring_buffer_seq *s;
+
+	s = kzalloc(sizeof(*s), flags);
+	return s;
+}
+
+void ring_buffer_seq_free(struct ring_buffer_seq *s)
+{
+	kfree(s);
+}
+
+unsigned ring_buffer_seq_length(struct ring_buffer_seq *seq)
+{
+	return seq->len;
+}
+
+void ring_buffer_seq_set_length(struct ring_buffer_seq *seq, unsigned len)
+{
+	BUG_ON(len > PAGE_SIZE);
+	seq->len = len;
+}
+
+/**
+ * ring_buffer_seq_printf - sequence printing of buffer information
+ * @s: buffer sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * ring_buffer_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+ring_buffer_seq_printf(struct ring_buffer_seq *s, const char *fmt, ...)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	va_list ap;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	va_end(ap);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len)
+		return 0;
+
+	s->len += ret;
+
+	return len;
+}
+
+/**
+ * ring_buffer_seq_puts - buffer sequence printing of simple string
+ * @s: buffer sequence descriptor
+ * @str: simple string to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple string
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ */
+int
+ring_buffer_seq_puts(struct ring_buffer_seq *s, const char *str)
+{
+	int len = strlen(str);
+
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return 0;
+
+	memcpy(s->buffer + s->len, str, len);
+	s->len += len;
+
+	return len;
+}
+
+int
+ring_buffer_seq_putc(struct ring_buffer_seq *s, unsigned char c)
+{
+	if (s->len >= (PAGE_SIZE - 1))
+		return 0;
+
+	s->buffer[s->len++] = c;
+
+	return 1;
+}
+
+int
+ring_buffer_seq_putmem(struct ring_buffer_seq *s, void *mem, size_t len)
+{
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return 0;
+
+	memcpy(s->buffer + s->len, mem, len);
+	s->len += len;
+
+	return len;
+}
+
+#define HEX_CHARS 17
+static const char hex2asc[] = "0123456789abcdef";
+
+int
+ring_buffer_seq_putmem_hex(struct ring_buffer_seq *s, void *mem, size_t len)
+{
+	unsigned char hex[HEX_CHARS];
+	unsigned char *data = mem;
+	unsigned char byte;
+	int i, j;
+
+	BUG_ON(len >= HEX_CHARS);
+
+#ifdef __BIG_ENDIAN
+	for (i = 0, j = 0; i < len; i++) {
+#else
+	for (i = len-1, j = 0; i >= 0; i--) {
+#endif
+		byte = data[i];
+
+		hex[j++] = hex2asc[byte & 0x0f];
+		hex[j++] = hex2asc[byte >> 4];
+	}
+	hex[j++] = ' ';
+
+	return ring_buffer_seq_putmem(s, hex, j);
+}
+
+void
+ring_buffer_seq_reset(struct ring_buffer_seq *s)
+{
+	s->len = 0;
+	s->readpos = 0;
+}
+
+ssize_t
+ring_buffer_seq_copy_to_user(struct ring_buffer_seq *s,
+			     char __user *ubuf, size_t cnt)
+{
+	int len;
+	int ret;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = s->len - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	if (ret)
+		return -EFAULT;
+
+	s->readpos += len;
+
+	if (s->readpos >= s->len)
+		ring_buffer_seq_reset(s);
+
+	return cnt;
+}
+
+int
+ring_buffer_seq_copy_to_mem(struct ring_buffer_seq *s,
+			    void *mem, int cnt)
+{
+	int len;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = s->len - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	memcpy(mem, s->buffer + s->readpos, cnt);
+
+	s->readpos += len;
+
+	if (s->readpos >= s->len)
+		ring_buffer_seq_reset(s);
+
+	return cnt;
+}
+
+int
+ring_buffer_seq_to_seqfile(struct seq_file *m, struct ring_buffer_seq *s)
+{
+	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+	int ret;
+
+	s->buffer[len] = 0;
+	ret = seq_puts(m, s->buffer);
+	if (ret)
+		ring_buffer_seq_reset(s);
+	return ret;
+}
Index: linux-compile.git/kernel/trace/Kconfig
===================================================================
--- linux-compile.git.orig/kernel/trace/Kconfig	2008-07-27 09:26:34.000000000 -0400
+++ linux-compile.git/kernel/trace/Kconfig	2008-09-22 11:47:29.000000000 -0400
@@ -15,6 +15,10 @@ config TRACING
 	select DEBUG_FS
 	select STACKTRACE
 
+config RING_BUFFER
+	bool "ring buffer"
+	select DEBUG_FS
+
 config FTRACE
 	bool "Kernel Function Tracer"
 	depends on HAVE_FTRACE
Index: linux-compile.git/kernel/trace/Makefile
===================================================================
--- linux-compile.git.orig/kernel/trace/Makefile	2008-07-27 09:26:34.000000000 -0400
+++ linux-compile.git/kernel/trace/Makefile	2008-09-22 11:46:46.000000000 -0400
@@ -11,6 +11,7 @@ obj-y += trace_selftest_dynamic.o
 endif
 
 obj-$(CONFIG_FTRACE) += libftrace.o
+obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o

-- 
