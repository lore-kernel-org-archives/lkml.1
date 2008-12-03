Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYLCA5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYLCA5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYLCA44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:56:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYLCA4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:56:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=dFIsuTbKtlmYprBqCJjXCAj0IgXukJ6d8nn01DG44uuG9BgALTR+Zy/vgEmnafJaY
	18xXqS4ldy2UhflzUa40Q==
MIME-Version: 1.0
Date: Tue, 2 Dec 2008 16:56:50 -0800
Message-ID: <5df78e1d0812021656g6485a5e0iea176a84e4e24c29@mail.gmail.com>
Subject: [RFC PATCH 2/3] adding inline buffer write functions to the unified 
	trace buffer
From: Jiaying Zhang <jiayingz@google.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refer to the previous email
"[RFC PATCH 0/3] A couple of feature requests to the unified trace buffer".

Add the inline versions of ring_buffer_lock_reserve and
ring_buffer_unlock_commit to the unified trace buffer to eliminate function
call overhead in buffer write. Please refer to the email "[RFC PATCH 0/3]
A couple of feature requests to the unified trace buffer" for more details.

Index: linux-2.6.26.2/include/linux/ring_buffer.h
===================================================================
--- linux-2.6.26.2.orig/include/linux/ring_buffer.h     2008-11-25
16:48:38.000000000 -0800
+++ linux-2.6.26.2/include/linux/ring_buffer.h  2008-11-26
00:22:36.000000000 -0800
@@ -3,12 +3,64 @@

 #include <linux/mm.h>
 #include <linux/seq_file.h>
+#include <linux/sched.h>
+#include <asm/local.h>
+
+/*
+ * This hack stolen from mm/slob.c.
+ * We can store per page timing information in the page frame of the page.
+ * Thanks to Peter Zijlstra for suggesting this idea.
+ */
+struct buffer_page {
+       u64              time_stamp;    /* page time stamp */
+       local_t          write;         /* index for next write */
+       local_t          commit;        /* write commited index */
+       unsigned         read;          /* index for next read */
+       struct list_head list;          /* list of free pages */
+       void *page;                     /* Actual data page */
+};

 struct ring_buffer;
 struct ring_buffer_per_cpu;
 struct ring_buffer_iter;

 /*
+ * head_page == tail_page && head == tail then buffer is empty.
+ */
+struct ring_buffer_per_cpu {
+       int                             cpu;
+       struct ring_buffer              *buffer;
+       spinlock_t                      lock;
+       struct lock_class_key           lock_key;
+       struct list_head                pages;
+       struct buffer_page              *page_array;
+       struct buffer_page              *head_page;     /* read from head */
+       struct buffer_page              *tail_page;     /* write to tail */
+       struct buffer_page              *commit_page;   /* commited pages */
+       struct buffer_page              *reader_page;
+       unsigned long                   overrun;
+       unsigned long                   entries;
+       u64                             write_stamp;
+       u64                             read_stamp;
+       atomic_t                        record_disabled;
+};
+
+struct ring_buffer {
+       unsigned long                   size;
+       unsigned                        pages;
+       unsigned                        flags;
+       int                             cpus;
+       cpumask_t                       cpumask;
+       atomic_t                        record_disabled;
+
+       struct mutex                    mutex;
+
+       struct ring_buffer_per_cpu      **buffers;
+};
+
+#define BUF_PAGE_SIZE PAGE_SIZE
+
+/*
 * Don't reference this struct directly, use functions below.
 */
 struct ring_buffer_event {
@@ -83,6 +135,211 @@
 int ring_buffer_write(struct ring_buffer *buffer,
                     unsigned long length, void *data);

+/* Up this if you want to test the TIME_EXTENTS and normalization */
+#define DEBUG_SHIFT 0
+
+static inline u64 ring_buffer_time_stamp(int cpu)
+{
+       /* shift to debug/test normalization and TIME_EXTENTS */
+       return sched_clock() << DEBUG_SHIFT;
+}
+
+static inline void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
+{
+       /* Just stupid testing the normalize function and deltas */
+       *ts >>= DEBUG_SHIFT;
+}
+
+
+#define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
+#define RB_ALIGNMENT_SHIFT     2
+#define RB_ALIGNMENT           (1 << RB_ALIGNMENT_SHIFT)
+#define RB_MAX_SMALL_DATA      28
+
+static inline unsigned rb_calculate_event_length(unsigned length)
+{
+       struct ring_buffer_event event; /* Used only for sizeof array */
+
+       /* zero length can cause confusions */
+       if (!length)
+               length = 1;
+
+       if (length > RB_MAX_SMALL_DATA)
+               length += sizeof(event.array[0]);
+
+       length += RB_EVNT_HDR_SIZE;
+       length = ALIGN(length, RB_ALIGNMENT);
+
+       return length;
+}
+
+static inline unsigned rb_page_write(struct buffer_page *bpage)
+{
+       return local_read(&bpage->write);
+}
+
+static inline void *__rb_page_index(struct buffer_page *page, unsigned index)
+{
+       return page->page + index;
+}
+
+struct ring_buffer_event *
+rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
+                     unsigned type, unsigned long length);
+
+static inline unsigned rb_page_commit(struct buffer_page *bpage)
+{
+       return local_read(&bpage->commit);
+}
+
+/* Size is determined by what has been commited */
+static inline unsigned rb_page_size(struct buffer_page *bpage)
+{
+       return rb_page_commit(bpage);
+}
+
+static inline unsigned
+rb_commit_index(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       return rb_page_commit(cpu_buffer->commit_page);
+}
+
+static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       return rb_page_commit(cpu_buffer->head_page);
+}
+
+static inline unsigned
+rb_event_index(struct ring_buffer_event *event)
+{
+       unsigned long addr = (unsigned long)event;
+
+       return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
+}
+
+static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
+                              struct buffer_page **page)
+{
+       struct list_head *p = (*page)->list.next;
+
+       if (p == &cpu_buffer->pages)
+               p = p->next;
+
+       *page = list_entry(p, struct buffer_page, list);
+}
+
+static inline int
+rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
+            struct ring_buffer_event *event)
+{
+       unsigned long addr = (unsigned long)event;
+       unsigned long index;
+
+       index = rb_event_index(event);
+       addr &= PAGE_MASK;
+
+       return cpu_buffer->commit_page->page == (void *)addr &&
+               rb_commit_index(cpu_buffer) == index;
+}
+
+static inline void
+rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
+{
+       /*
+        * We only race with interrupts and NMIs on this CPU.
+        * If we own the commit event, then we can commit
+        * all others that interrupted us, since the interruptions
+        * are in stack format (they finish before they come
+        * back to us). This allows us to do a simple loop to
+        * assign the commit to the tail.
+        */
+       while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
+               cpu_buffer->commit_page->commit =
+                       cpu_buffer->commit_page->write;
+               rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
+               cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
+               /* add barrier to keep gcc from optimizing too much */
+               barrier();
+       }
+       while (rb_commit_index(cpu_buffer) !=
+              rb_page_write(cpu_buffer->commit_page)) {
+               cpu_buffer->commit_page->commit =
+                       cpu_buffer->commit_page->write;
+               barrier();
+       }
+}
+
+static inline struct ring_buffer_event *
+__ring_buffer_lock_reserve(struct ring_buffer *buffer,
+                        unsigned long length,
+                        unsigned long *flags)
+{
+       struct ring_buffer_per_cpu *cpu_buffer;
+       struct ring_buffer_event *event;
+       struct buffer_page *tail_page;
+       unsigned long tail, write;
+       int cpu;
+
+       if (atomic_read(&buffer->record_disabled))
+               return NULL;
+
+       preempt_disable_notrace();
+
+       cpu = raw_smp_processor_id();
+       if (!cpu_isset(cpu, buffer->cpumask))
+               goto out;
+
+       cpu_buffer = buffer->buffers[cpu];
+       if (atomic_read(&cpu_buffer->record_disabled))
+               goto out;
+
+       length = rb_calculate_event_length(length);
+       tail_page = cpu_buffer->tail_page;
+       if (rb_page_write(tail_page) &&
+                       (rb_page_write(tail_page) + length <= BUF_PAGE_SIZE)) {
+               write = local_add_return(length, &tail_page->write);
+               tail = write - length;
+               event = __rb_page_index(tail_page, tail);
+               event->type = RINGBUF_TYPE_DATA;
+               length -= RB_EVNT_HDR_SIZE;
+               if (length > RB_MAX_SMALL_DATA) {
+                       event->len = 0;
+                       event->array[0] = length;
+               } else
+                       event->len = (length + (RB_ALIGNMENT-1))
+                               >> RB_ALIGNMENT_SHIFT;
+                event->time_delta = ring_buffer_time_stamp(cpu) -
+                        cpu_buffer->write_stamp;
+       } else
+               event = rb_reserve_next_event(cpu_buffer,
+                               RINGBUF_TYPE_DATA, length);
+
+       return event;
+ out:
+       preempt_enable_notrace();
+       return NULL;
+}
+
+static inline int __ring_buffer_unlock_commit(struct ring_buffer *buffer,
+                             struct ring_buffer_event *event,
+                             unsigned long flags)
+{
+       struct ring_buffer_per_cpu *cpu_buffer;
+       int cpu = raw_smp_processor_id();
+
+       cpu_buffer = buffer->buffers[cpu];
+
+       cpu_buffer->entries++;
+       if (!rb_is_commit(cpu_buffer, event))
+               return 0;
+
+       cpu_buffer->write_stamp += event->time_delta;
+       rb_set_commit_to_write(cpu_buffer);
+
+       preempt_enable_notrace();
+       return 0;
+}
+
 struct ring_buffer_event *
 ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts);
 struct ring_buffer_event *
@@ -119,9 +376,6 @@
 unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);

-u64 ring_buffer_time_stamp(int cpu);
-void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
-
 enum ring_buffer_flags {
       RB_FL_OVERWRITE         = 1 << 0,
 };
Index: linux-2.6.26.2/kernel/ktrace/ring_buffer.c
===================================================================
--- linux-2.6.26.2.orig/kernel/ktrace/ring_buffer.c     2008-11-25
16:48:38.000000000 -0800
+++ linux-2.6.26.2/kernel/ktrace/ring_buffer.c  2008-11-25
22:31:50.000000000 -0800
@@ -16,27 +16,6 @@
 #include <linux/list.h>
 #include <linux/fs.h>

-/* Up this if you want to test the TIME_EXTENTS and normalization */
-#define DEBUG_SHIFT 0
-
-/* FIXME!!! */
-u64 ring_buffer_time_stamp(int cpu)
-{
-       /* shift to debug/test normalization and TIME_EXTENTS */
-       return sched_clock() << DEBUG_SHIFT;
-}
-
-void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
-{
-       /* Just stupid testing the normalize function and deltas */
-       *ts >>= DEBUG_SHIFT;
-}
-
-#define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
-#define RB_ALIGNMENT_SHIFT     2
-#define RB_ALIGNMENT           (1 << RB_ALIGNMENT_SHIFT)
-#define RB_MAX_SMALL_DATA      28
-
 enum {
       RB_LEN_TIME_EXTEND = 8,
       RB_LEN_TIME_STAMP = 16,
@@ -110,20 +89,6 @@
 #define TS_DELTA_TEST  (~TS_MASK)

 /*
- * This hack stolen from mm/slob.c.
- * We can store per page timing information in the page frame of the page.
- * Thanks to Peter Zijlstra for suggesting this idea.
- */
-struct buffer_page {
-       u64              time_stamp;    /* page time stamp */
-       local_t          write;         /* index for next write */
-       local_t          commit;        /* write commited index */
-       unsigned         read;          /* index for next read */
-       struct list_head list;          /* list of free pages */
-       void *page;                     /* Actual data page */
-};
-
-/*
 * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
 * this issue out.
 */
@@ -143,42 +108,6 @@
       return 0;
 }

-#define BUF_PAGE_SIZE PAGE_SIZE
-
-/*
- * head_page == tail_page && head == tail then buffer is empty.
- */
-struct ring_buffer_per_cpu {
-       int                             cpu;
-       struct ring_buffer              *buffer;
-       spinlock_t                      lock;
-       struct lock_class_key           lock_key;
-       struct list_head                pages;
-       struct buffer_page              *page_array;
-       struct buffer_page              *head_page;     /* read from head */
-       struct buffer_page              *tail_page;     /* write to tail */
-       struct buffer_page              *commit_page;   /* commited pages */
-       struct buffer_page              *reader_page;
-       unsigned long                   overrun;
-       unsigned long                   entries;
-       u64                             write_stamp;
-       u64                             read_stamp;
-       atomic_t                        record_disabled;
-};
-
-struct ring_buffer {
-       unsigned long                   size;
-       unsigned                        pages;
-       unsigned                        flags;
-       int                             cpus;
-       cpumask_t                       cpumask;
-       atomic_t                        record_disabled;
-
-       struct mutex                    mutex;
-
-       struct ring_buffer_per_cpu      **buffers;
-};
-
 struct ring_buffer_iter {
       struct ring_buffer_per_cpu      *cpu_buffer;
       unsigned long                   head;
@@ -580,11 +509,6 @@
       return event->type == RINGBUF_TYPE_PADDING;
 }

-static inline void *__rb_page_index(struct buffer_page *page, unsigned index)
-{
-       return page->page + index;
-}
-
 static inline struct ring_buffer_event *
 rb_reader_event(struct ring_buffer_per_cpu *cpu_buffer)
 {
@@ -605,33 +529,6 @@
       return __rb_page_index(iter->head_page, iter->head);
 }

-static inline unsigned rb_page_write(struct buffer_page *bpage)
-{
-       return local_read(&bpage->write);
-}
-
-static inline unsigned rb_page_commit(struct buffer_page *bpage)
-{
-       return local_read(&bpage->commit);
-}
-
-/* Size is determined by what has been commited */
-static inline unsigned rb_page_size(struct buffer_page *bpage)
-{
-       return rb_page_commit(bpage);
-}
-
-static inline unsigned
-rb_commit_index(struct ring_buffer_per_cpu *cpu_buffer)
-{
-       return rb_page_commit(cpu_buffer->commit_page);
-}
-
-static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
-{
-       return rb_page_commit(cpu_buffer->head_page);
-}
-
 /*
 * When the tail hits the head and the buffer is in overwrite mode,
 * the head jumps to the next page and all content on the previous
@@ -656,39 +553,6 @@
       }
 }

-static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
-                              struct buffer_page **page)
-{
-       struct list_head *p = (*page)->list.next;
-
-       if (p == &cpu_buffer->pages)
-               p = p->next;
-
-       *page = list_entry(p, struct buffer_page, list);
-}
-
-static inline unsigned
-rb_event_index(struct ring_buffer_event *event)
-{
-       unsigned long addr = (unsigned long)event;
-
-       return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
-}
-
-static inline int
-rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
-            struct ring_buffer_event *event)
-{
-       unsigned long addr = (unsigned long)event;
-       unsigned long index;
-
-       index = rb_event_index(event);
-       addr &= PAGE_MASK;
-
-       return cpu_buffer->commit_page->page == (void *)addr &&
-               rb_commit_index(cpu_buffer) == index;
-}
-
 static inline void
 rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
                   struct ring_buffer_event *event)
@@ -712,33 +576,6 @@
       local_set(&cpu_buffer->commit_page->commit, index);
 }

-static inline void
-rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
-{
-       /*
-        * We only race with interrupts and NMIs on this CPU.
-        * If we own the commit event, then we can commit
-        * all others that interrupted us, since the interruptions
-        * are in stack format (they finish before they come
-        * back to us). This allows us to do a simple loop to
-        * assign the commit to the tail.
-        */
-       while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
-               cpu_buffer->commit_page->commit =
-                       cpu_buffer->commit_page->write;
-               rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
-               cpu_buffer->write_stamp = cpu_buffer->commit_page->time_stamp;
-               /* add barrier to keep gcc from optimizing too much */
-               barrier();
-       }
-       while (rb_commit_index(cpu_buffer) !=
-              rb_page_write(cpu_buffer->commit_page)) {
-               cpu_buffer->commit_page->commit =
-                       cpu_buffer->commit_page->write;
-               barrier();
-       }
-}
-
 static void rb_reset_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
       cpu_buffer->read_stamp = cpu_buffer->reader_page->time_stamp;
@@ -813,23 +650,6 @@
       }
 }

-static inline unsigned rb_calculate_event_length(unsigned length)
-{
-       struct ring_buffer_event event; /* Used only for sizeof array */
-
-       /* zero length can cause confusions */
-       if (!length)
-               length = 1;
-
-       if (length > RB_MAX_SMALL_DATA)
-               length += sizeof(event.array[0]);
-
-       length += RB_EVNT_HDR_SIZE;
-       length = ALIGN(length, RB_ALIGNMENT);
-
-       return length;
-}
-
 static struct ring_buffer_event *
 __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
                 unsigned type, unsigned long length, u64 *ts)
@@ -1011,7 +831,7 @@
       return ret;
 }

-static struct ring_buffer_event *
+struct ring_buffer_event *
 rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
                     unsigned type, unsigned long length)
 {
