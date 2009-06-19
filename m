Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZFSPWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZFSPWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZFSPVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:21:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZFSPVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:21:18 -0400
Message-Id: <20090619152117.384751340@goodmis.org>
References: <20090619151922.830665788@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 19 Jun 2009 11:19:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 2/3] ring-buffer: make lockless
Content-Disposition: inline; filename=0002-ring-buffer-make-lockless.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch converts the ring buffers into a completely lockless
buffer recording system. The read side still takes locks since
we still serialize readers. But the writers are the ones that
must be lockless (those can happen in NMIs).

The main change is to the "head_page" pointer. We write to the
tail, and read from the head. The "head_page" pointer in the cpu
buffer is now just a reference to where to look. The real head
page is now kept in the head_page->list->prev->next pointer.
That is, in the list head of the previous page we set flags.

The list pages are allocated to be aligned such that the lowest
significant bits are always zero pointing to the list. This gives
us play to put in flags to their pointers.

bit 0: set when the page is a head page
bit 1: set when the writer is moving the page (for overwrite mode)

cmpxchg is used to update the pointer.

When the writer wraps the buffer and the tail meets the head,
in overwrite mode, the writer must move the head page forward.
It first uses cmpxchg to change the pointer flag from 1 to 2.
Once this is done, the reader on another CPU will not take the
page from the buffer.

The writers need to protect against interrupts (we don't bother with
disabling interrupts because NMIs are allowed to write too).

After the writer sets the pointer flag to 2, it takes care to
manage interrupts coming in. This is discribed in detail within the
comments of the code.

 Changes in version 2:
  - Let reader reset entries value of header page.
  - Fix tail page passing commit page on reader page test.
  - Always increment entries and write counter in rb_tail_page_update
  - Add safety check in rb_set_commit_to_write to break out of infinite loop
  - add mask in rb_is_reader_page

[ Impact: lock free writing to the ring buffer ]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    1 -
 kernel/trace/ring_buffer.c  |  886 +++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.c        |    3 -
 3 files changed, 738 insertions(+), 152 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 8670f15..d65885b 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -166,7 +166,6 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
-unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3b2ffe8..85ae3dc 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -321,6 +321,14 @@ struct buffer_data_page {
 	unsigned char	 data[];	/* data of buffer page */
 };
 
+/*
+ * Note, the buffer_page list must be first. The buffer pages
+ * are allocated in cache lines, which means that each buffer
+ * page will be at the beginning of a cache line, and thus
+ * the least significant bits will be zero. We use this to
+ * add flags in the list struct pointers, to make the ring buffer
+ * lockless.
+ */
 struct buffer_page {
 	struct list_head list;		/* list of buffer pages */
 	local_t		 write;		/* index for next write */
@@ -329,6 +337,21 @@ struct buffer_page {
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
+/*
+ * The buffer page counters, write and entries, must be reset
+ * atomically when crossing page boundaries. To synchronize this
+ * update, two counters are inserted into the number. One is
+ * the actual counter for the write position or count on the page.
+ *
+ * The other is a counter of updaters. Before an update happens
+ * the update partition of the counter is incremented. This will
+ * allow the updater to update the counter atomically.
+ *
+ * The counter is 20 bits, and the state data is 12.
+ */
+#define RB_WRITE_MASK		0xfffff
+#define RB_WRITE_INTCNT		(1 << 20)
+
 static void rb_init_page(struct buffer_data_page *bpage)
 {
 	local_set(&bpage->commit, 0);
@@ -402,7 +425,7 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
-	spinlock_t			reader_lock; /* serialize readers */
+	spinlock_t			reader_lock;	/* serialize readers */
 	raw_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		*pages;
@@ -410,13 +433,12 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
-	unsigned long			nmi_dropped;
-	unsigned long			commit_overrun;
-	unsigned long			overrun;
-	unsigned long			read;
+	local_t				commit_overrun;
+	local_t				overrun;
 	local_t				entries;
 	local_t				committing;
 	local_t				commits;
+	unsigned long			read;
 	u64				write_stamp;
 	u64				read_stamp;
 	atomic_t			record_disabled;
@@ -488,6 +510,385 @@ void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
 
+/*
+ * Making the ring buffer lockless makes things tricky.
+ * Although writes only happen on the CPU that they are on,
+ * and they only need to worry about interrupts. Reads can
+ * happen on any CPU.
+ *
+ * The reader page is always off the ring buffer, but when the
+ * reader finishes with a page, it needs to swap its page with
+ * a new one from the buffer. The reader needs to take from
+ * the head (writes go to the tail). But if a writer is in overwrite
+ * mode and wraps, it must push the head page forward.
+ *
+ * Here lies the problem.
+ *
+ * The reader must be careful to replace only the head page, and
+ * not another one. As described at the top of the file in the
+ * ASCII art, the reader sets its old page to point to the next
+ * page after head. It then sets the page after head to point to
+ * the old reader page. But if the writer moves the head page
+ * during this operation, the reader could end up with the tail.
+ *
+ * We use cmpxchg to help prevent this race. We also do something
+ * special with the page before head. We set the LSB to 1.
+ *
+ * When the writer must push the page forward, it will clear the
+ * bit that points to the head page, move the head, and then set
+ * the bit that points to the new head page.
+ *
+ * We also don't want an interrupt coming in and moving the head
+ * page on another writer. Thus we use the second LSB to catch
+ * that too. Thus:
+ *
+ * head->list->prev->next        bit 1          bit 0
+ *                              -------        -------
+ * Normal page                     0              0
+ * Points to head page             0              1
+ * New head page                   1              0
+ *
+ * Note we can not trust the prev pointer of the head page, because:
+ *
+ * +----+       +-----+        +-----+
+ * |    |------>|  T  |---X--->|  N  |
+ * |    |<------|     |        |     |
+ * +----+       +-----+        +-----+
+ *   ^                           ^ |
+ *   |          +-----+          | |
+ *   +----------|  R  |----------+ |
+ *              |     |<-----------+
+ *              +-----+
+ *
+ * Key:  ---X-->  HEAD flag set in pointer
+ *         T      Tail page
+ *         R      Reader page
+ *         N      Next page
+ *
+ * (see __rb_reserve_next() to see where this happens)
+ *
+ *  What the above shows is that the reader just swapped out
+ *  the reader page with a page in the buffer, but before it
+ *  could make the new header point back to the new page added
+ *  it was preempted by a writer. The writer moved forward onto
+ *  the new page added by the reader and is about to move forward
+ *  again.
+ *
+ *  You can see, it is legitimate for the previous pointer of
+ *  the head (or any page) not to point back to itself. But only
+ *  temporarially.
+ */
+
+#define RB_PAGE_NORMAL		0UL
+#define RB_PAGE_HEAD		1UL
+#define RB_PAGE_UPDATE		2UL
+
+
+#define RB_FLAG_MASK		3UL
+
+/* PAGE_MOVED is not part of the mask */
+#define RB_PAGE_MOVED		4UL
+
+/*
+ * rb_list_head - remove any bit
+ */
+static struct list_head *rb_list_head(struct list_head *list)
+{
+	unsigned long val = (unsigned long)list;
+
+	return (struct list_head *)(val & ~RB_FLAG_MASK);
+}
+
+/*
+ * rb_is_head_page - test if the give page is the head page
+ *
+ * Because the reader may move the head_page pointer, we can
+ * not trust what the head page is (it may be pointing to
+ * the reader page). But if the next page is a header page,
+ * its flags will be non zero.
+ */
+static int inline
+rb_is_head_page(struct ring_buffer_per_cpu *cpu_buffer,
+		struct buffer_page *page, struct list_head *list)
+{
+	unsigned long val;
+
+	val = (unsigned long)list->next;
+
+	if ((val & ~RB_FLAG_MASK) != (unsigned long)&page->list)
+		return RB_PAGE_MOVED;
+
+	return val & RB_FLAG_MASK;
+}
+
+/*
+ * rb_is_reader_page
+ *
+ * The unique thing about the reader page, is that, if the
+ * writer is ever on it, the previous pointer never points
+ * back to the reader page.
+ */
+static int rb_is_reader_page(struct buffer_page *page)
+{
+	struct list_head *list = page->list.prev;
+
+	return rb_list_head(list->next) != &page->list;
+}
+
+/*
+ * rb_set_list_to_head - set a list_head to be pointing to head.
+ */
+static void rb_set_list_to_head(struct ring_buffer_per_cpu *cpu_buffer,
+				struct list_head *list)
+{
+	unsigned long *ptr;
+
+	ptr = (unsigned long *)&list->next;
+	*ptr |= RB_PAGE_HEAD;
+	*ptr &= ~RB_PAGE_UPDATE;
+}
+
+/*
+ * rb_head_page_activate - sets up head page
+ */
+static void rb_head_page_activate(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *head;
+
+	head = cpu_buffer->head_page;
+	if (!head)
+		return;
+
+	/*
+	 * Set the previous list pointer to have the HEAD flag.
+	 */
+	rb_set_list_to_head(cpu_buffer, head->list.prev);
+}
+
+static void rb_list_head_clear(struct list_head *list)
+{
+	unsigned long *ptr = (unsigned long *)&list->next;
+
+	*ptr &= ~RB_FLAG_MASK;
+}
+
+/*
+ * rb_head_page_dactivate - clears head page ptr (for free list)
+ */
+static void
+rb_head_page_deactivate(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct list_head *hd;
+
+	/* Go through the whole list and clear any pointers found. */
+	rb_list_head_clear(cpu_buffer->pages);
+
+	list_for_each(hd, cpu_buffer->pages)
+		rb_list_head_clear(hd);
+}
+
+static int rb_head_page_set(struct ring_buffer_per_cpu *cpu_buffer,
+			    struct buffer_page *head,
+			    struct buffer_page *prev,
+			    int old_flag, int new_flag)
+{
+	struct list_head *list;
+	unsigned long val = (unsigned long)&head->list;
+	unsigned long ret;
+
+	list = &prev->list;
+
+	val &= ~RB_FLAG_MASK;
+
+	ret = (unsigned long)cmpxchg(&list->next,
+				     val | old_flag, val | new_flag);
+
+	/* check if the reader took the page */
+	if ((ret & ~RB_FLAG_MASK) != val)
+		return RB_PAGE_MOVED;
+
+	return ret & RB_FLAG_MASK;
+}
+
+static int rb_head_page_set_update(struct ring_buffer_per_cpu *cpu_buffer,
+				   struct buffer_page *head,
+				   struct buffer_page *prev,
+				   int old_flag)
+{
+	return rb_head_page_set(cpu_buffer, head, prev,
+				old_flag, RB_PAGE_UPDATE);
+}
+
+static int rb_head_page_set_head(struct ring_buffer_per_cpu *cpu_buffer,
+				 struct buffer_page *head,
+				 struct buffer_page *prev,
+				 int old_flag)
+{
+	return rb_head_page_set(cpu_buffer, head, prev,
+				old_flag, RB_PAGE_HEAD);
+}
+
+static int rb_head_page_set_normal(struct ring_buffer_per_cpu *cpu_buffer,
+				   struct buffer_page *head,
+				   struct buffer_page *prev,
+				   int old_flag)
+{
+	return rb_head_page_set(cpu_buffer, head, prev,
+				old_flag, RB_PAGE_NORMAL);
+}
+
+static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
+			       struct buffer_page **bpage)
+{
+	struct list_head *p = rb_list_head((*bpage)->list.next);
+
+	*bpage = list_entry(p, struct buffer_page, list);
+}
+
+static struct buffer_page *
+rb_set_head_page(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	struct buffer_page *head;
+	struct buffer_page *page;
+	struct list_head *list;
+	int i;
+
+	if (RB_WARN_ON(cpu_buffer, !cpu_buffer->head_page))
+		return NULL;
+
+	/* sanity check */
+	list = cpu_buffer->pages;
+	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->prev->next) != list))
+		return NULL;
+
+	page = head = cpu_buffer->head_page;
+	/*
+	 * It is possible that the writer moves the header behind
+	 * where we started, and we miss in one loop.
+	 * A second loop should grab the header, but we'll do
+	 * three loops just because I'm paranoid.
+	 */
+	for (i = 0; i < 3; i++) {
+		do {
+			if (rb_is_head_page(cpu_buffer, page, page->list.prev)) {
+				cpu_buffer->head_page = page;
+				return page;
+			}
+			rb_inc_page(cpu_buffer, &page);
+		} while (page != head);
+	}
+
+	RB_WARN_ON(cpu_buffer, 1);
+
+	return NULL;
+}
+
+static int rb_head_page_replace(struct buffer_page *old,
+				struct buffer_page *new)
+{
+	unsigned long *ptr = (unsigned long *)&old->list.prev->next;
+	unsigned long val;
+	unsigned long ret;
+
+	val = *ptr & ~RB_FLAG_MASK;
+	val |= RB_PAGE_HEAD;
+
+	ret = cmpxchg(ptr, val, &new->list);
+
+	return ret == val;
+}
+
+/*
+ * rb_tail_page_update - move the tail page forward
+ *
+ * Returns 1 if moved tail page, 0 if someone else did.
+ */
+static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
+			       struct buffer_page *tail_page,
+			       struct buffer_page *next_page)
+{
+	struct buffer_page *old_tail;
+	unsigned long old_entries;
+	unsigned long old_write;
+	int ret = 0;
+
+	/*
+	 * The tail page now needs to be moved forward.
+	 *
+	 * We need to reset the tail page, but without messing
+	 * with possible erasing of data brought in by interrupts
+	 * that have moved the tail page and are currently on it.
+	 *
+	 * We add a counter to the write field to denote this.
+	 */
+	old_write = local_add_return(RB_WRITE_INTCNT, &next_page->write);
+	old_entries = local_add_return(RB_WRITE_INTCNT, &next_page->entries);
+
+	/*
+	 * Just make sure we have seen our old_write and synchronize
+	 * with any interrupts that come in.
+	 */
+	barrier();
+
+	/*
+	 * If the tail page is still the same as what we think
+	 * it is, then it is up to us to update the tail
+	 * pointer.
+	 */
+	if (tail_page == cpu_buffer->tail_page) {
+		/* Zero the write counter */
+		unsigned long val = old_write & ~RB_WRITE_MASK;
+		unsigned long eval = old_entries & ~RB_WRITE_MASK;
+
+		/*
+		 * This will only succeed if an interrupt did
+		 * not come in and change it. In which case, we
+		 * do not want to modify it.
+		 */
+		local_cmpxchg(&next_page->write, old_write, val);
+		local_cmpxchg(&next_page->entries, old_entries, eval);
+
+		/*
+		 * No need to worry about races with clearing out the commit.
+		 * it only can increment when a commit takes place. But that
+		 * only happens in the outer most nested commit.
+		 */
+		local_set(&next_page->page->commit, 0);
+
+		old_tail = cmpxchg(&cpu_buffer->tail_page,
+				   tail_page, next_page);
+
+		if (old_tail == tail_page)
+			ret = 1;
+	}
+
+	return ret;
+}
+
+static int rb_check_bpage(struct ring_buffer_per_cpu *cpu_buffer,
+			  struct buffer_page *bpage)
+{
+	unsigned long val = (unsigned long)bpage;
+
+	if (RB_WARN_ON(cpu_buffer, val & RB_FLAG_MASK))
+		return 1;
+
+	return 0;
+}
+
+/**
+ * rb_check_list - make sure a pointer to a list has the last bits zero
+ */
+static int rb_check_list(struct ring_buffer_per_cpu *cpu_buffer,
+			 struct list_head *list)
+{
+	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->prev) != list->prev))
+		return 1;
+	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->next) != list->next))
+		return 1;
+	return 0;
+}
+
 /**
  * check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
@@ -500,11 +901,16 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 	struct list_head *head = cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 
+	rb_head_page_deactivate(cpu_buffer);
+
 	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
 		return -1;
 	if (RB_WARN_ON(cpu_buffer, head->prev->next != head))
 		return -1;
 
+	if (rb_check_list(cpu_buffer, head))
+		return -1;
+
 	list_for_each_entry_safe(bpage, tmp, head, list) {
 		if (RB_WARN_ON(cpu_buffer,
 			       bpage->list.next->prev != &bpage->list))
@@ -512,8 +918,12 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 		if (RB_WARN_ON(cpu_buffer,
 			       bpage->list.prev->next != &bpage->list))
 			return -1;
+		if (rb_check_list(cpu_buffer, &bpage->list))
+			return -1;
 	}
 
+	rb_head_page_activate(cpu_buffer);
+
 	return 0;
 }
 
@@ -532,6 +942,9 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
 		if (!bpage)
 			goto free_pages;
+
+		rb_check_bpage(cpu_buffer, bpage);
+
 		list_add(&bpage->list, &pages);
 
 		addr = __get_free_page(GFP_KERNEL);
@@ -585,6 +998,8 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	if (!bpage)
 		goto fail_free_buffer;
 
+	rb_check_bpage(cpu_buffer, bpage);
+
 	cpu_buffer->reader_page = bpage;
 	addr = __get_free_page(GFP_KERNEL);
 	if (!addr)
@@ -602,6 +1017,8 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 		= list_entry(cpu_buffer->pages, struct buffer_page, list);
 	cpu_buffer->tail_page = cpu_buffer->commit_page = cpu_buffer->head_page;
 
+	rb_head_page_activate(cpu_buffer);
+
 	return cpu_buffer;
 
  fail_free_reader:
@@ -619,6 +1036,8 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	free_buffer_page(cpu_buffer->reader_page);
 
+	rb_head_page_deactivate(cpu_buffer);
+
 	if (head) {
 		list_for_each_entry_safe(bpage, tmp, head, list) {
 			list_del_init(&bpage->list);
@@ -769,6 +1188,8 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
+	rb_head_page_deactivate(cpu_buffer);
+
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
 			return;
@@ -799,6 +1220,9 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
+	spin_lock_irq(&cpu_buffer->reader_lock);
+	rb_head_page_deactivate(cpu_buffer);
+
 	for (i = 0; i < nr_pages; i++) {
 		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
 			return;
@@ -808,6 +1232,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		list_add_tail(&bpage->list, cpu_buffer->pages);
 	}
 	rb_reset_cpu(cpu_buffer);
+	spin_unlock_irq(&cpu_buffer->reader_lock);
 
 	rb_check_pages(cpu_buffer);
 
@@ -958,21 +1383,14 @@ rb_reader_event(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static inline struct ring_buffer_event *
-rb_head_event(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	return __rb_page_index(cpu_buffer->head_page,
-			       cpu_buffer->head_page->read);
-}
-
-static inline struct ring_buffer_event *
 rb_iter_head_event(struct ring_buffer_iter *iter)
 {
 	return __rb_page_index(iter->head_page, iter->head);
 }
 
-static inline unsigned rb_page_write(struct buffer_page *bpage)
+static inline unsigned long rb_page_write(struct buffer_page *bpage)
 {
-	return local_read(&bpage->write);
+	return local_read(&bpage->write) & RB_WRITE_MASK;
 }
 
 static inline unsigned rb_page_commit(struct buffer_page *bpage)
@@ -980,6 +1398,11 @@ static inline unsigned rb_page_commit(struct buffer_page *bpage)
 	return local_read(&bpage->page->commit);
 }
 
+static inline unsigned long rb_page_entries(struct buffer_page *bpage)
+{
+	return local_read(&bpage->entries) & RB_WRITE_MASK;
+}
+
 /* Size is determined by what has been commited */
 static inline unsigned rb_page_size(struct buffer_page *bpage)
 {
@@ -992,19 +1415,6 @@ rb_commit_index(struct ring_buffer_per_cpu *cpu_buffer)
 	return rb_page_commit(cpu_buffer->commit_page);
 }
 
-static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	return rb_page_commit(cpu_buffer->head_page);
-}
-
-static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
-			       struct buffer_page **bpage)
-{
-	struct list_head *p = (*bpage)->list.next;
-
-	*bpage = list_entry(p, struct buffer_page, list);
-}
-
 static inline unsigned
 rb_event_index(struct ring_buffer_event *event)
 {
@@ -1030,6 +1440,8 @@ rb_event_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 static void
 rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 {
+	unsigned long max_count;
+
 	/*
 	 * We only race with interrupts and NMIs on this CPU.
 	 * If we own the commit event, then we can commit
@@ -1039,9 +1451,16 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	 * assign the commit to the tail.
 	 */
  again:
+	max_count = cpu_buffer->buffer->pages * 100;
+
 	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
-		cpu_buffer->commit_page->page->commit =
-			cpu_buffer->commit_page->write;
+		if (RB_WARN_ON(cpu_buffer, !(--max_count)))
+			return;
+		if (RB_WARN_ON(cpu_buffer,
+			       rb_is_reader_page(cpu_buffer->tail_page)))
+			return;
+		local_set(&cpu_buffer->commit_page->page->commit,
+			  rb_page_write(cpu_buffer->commit_page));
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
 		cpu_buffer->write_stamp =
 			cpu_buffer->commit_page->page->time_stamp;
@@ -1050,8 +1469,12 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	}
 	while (rb_commit_index(cpu_buffer) !=
 	       rb_page_write(cpu_buffer->commit_page)) {
-		cpu_buffer->commit_page->page->commit =
-			cpu_buffer->commit_page->write;
+
+		local_set(&cpu_buffer->commit_page->page->commit,
+			  rb_page_write(cpu_buffer->commit_page));
+		RB_WARN_ON(cpu_buffer,
+			   local_read(&cpu_buffer->commit_page->page->commit) &
+			   ~RB_WRITE_MASK);
 		barrier();
 	}
 
@@ -1084,7 +1507,7 @@ static void rb_inc_iter(struct ring_buffer_iter *iter)
 	 * to the head page instead of next.
 	 */
 	if (iter->head_page == cpu_buffer->reader_page)
-		iter->head_page = cpu_buffer->head_page;
+		iter->head_page = rb_set_head_page(cpu_buffer);
 	else
 		rb_inc_page(cpu_buffer, &iter->head_page);
 
@@ -1128,6 +1551,163 @@ rb_update_event(struct ring_buffer_event *event,
 	}
 }
 
+/*
+ * rb_handle_head_page - writer hit the head page
+ *
+ * Returns: +1 to retry page
+ *           0 to continue
+ *          -1 on error
+ */
+static int
+rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
+		    struct buffer_page *tail_page,
+		    struct buffer_page *next_page)
+{
+	struct buffer_page *new_head;
+	int entries;
+	int type;
+	int ret;
+
+	entries = rb_page_entries(next_page);
+
+	/*
+	 * The hard part is here. We need to move the head
+	 * forward, and protect against both readers on
+	 * other CPUs and writers coming in via interrupts.
+	 */
+	type = rb_head_page_set_update(cpu_buffer, next_page, tail_page,
+				       RB_PAGE_HEAD);
+
+	/*
+	 * type can be one of four:
+	 *  NORMAL - an interrupt already moved it for us
+	 *  HEAD   - we are the first to get here.
+	 *  UPDATE - we are the interrupt interrupting
+	 *           a current move.
+	 *  MOVED  - a reader on another CPU moved the next
+	 *           pointer to its reader page. Give up
+	 *           and try again.
+	 */
+
+	switch (type) {
+	case RB_PAGE_HEAD:
+		/*
+		 * We changed the head to UPDATE, thus
+		 * it is our responsibility to update
+		 * the counters.
+		 */
+		local_add(entries, &cpu_buffer->overrun);
+
+		/*
+		 * The entries will be zeroed out when we move the
+		 * tail page.
+		 */
+
+		/* still more to do */
+		break;
+
+	case RB_PAGE_UPDATE:
+		/*
+		 * This is an interrupt that interrupt the
+		 * previous update. Still more to do.
+		 */
+		break;
+	case RB_PAGE_NORMAL:
+		/*
+		 * An interrupt came in before the update
+		 * and processed this for us.
+		 * Nothing left to do.
+		 */
+		return 1;
+	case RB_PAGE_MOVED:
+		/*
+		 * The reader is on another CPU and just did
+		 * a swap with our next_page.
+		 * Try again.
+		 */
+		return 1;
+	default:
+		RB_WARN_ON(cpu_buffer, 1); /* WTF??? */
+		return -1;
+	}
+
+	/*
+	 * Now that we are here, the old head pointer is
+	 * set to UPDATE. This will keep the reader from
+	 * swapping the head page with the reader page.
+	 * The reader (on another CPU) will spin till
+	 * we are finished.
+	 *
+	 * We just need to protect against interrupts
+	 * doing the job. We will set the next pointer
+	 * to HEAD. After that, we set the old pointer
+	 * to NORMAL, but only if it was HEAD before.
+	 * otherwise we are an interrupt, and only
+	 * want the outer most commit to reset it.
+	 */
+	new_head = next_page;
+	rb_inc_page(cpu_buffer, &new_head);
+
+	ret = rb_head_page_set_head(cpu_buffer, new_head, next_page,
+				    RB_PAGE_NORMAL);
+
+	/*
+	 * Valid returns are:
+	 *  HEAD   - an interrupt came in and already set it.
+	 *  NORMAL - One of two things:
+	 *            1) We really set it.
+	 *            2) A bunch of interrupts came in and moved
+	 *               the page forward again.
+	 */
+	switch (ret) {
+	case RB_PAGE_HEAD:
+	case RB_PAGE_NORMAL:
+		/* OK */
+		break;
+	default:
+		RB_WARN_ON(cpu_buffer, 1);
+		return -1;
+	}
+
+	/*
+	 * It is possible that an interrupt came in,
+	 * set the head up, then more interrupts came in
+	 * and moved it again. When we get back here,
+	 * the page would have been set to NORMAL but we
+	 * just set it back to HEAD.
+	 *
+	 * How do you detect this? Well, if that happened
+	 * the tail page would have moved.
+	 */
+	if (ret == RB_PAGE_NORMAL) {
+		/*
+		 * If the tail had moved passed next, then we need
+		 * to reset the pointer.
+		 */
+		if (cpu_buffer->tail_page != tail_page &&
+		    cpu_buffer->tail_page != next_page)
+			rb_head_page_set_normal(cpu_buffer, new_head,
+						next_page,
+						RB_PAGE_HEAD);
+	}
+
+	/*
+	 * If this was the outer most commit (the one that
+	 * changed the original pointer from HEAD to UPDATE),
+	 * then it is up to us to reset it to NORMAL.
+	 */
+	if (type == RB_PAGE_HEAD) {
+		ret = rb_head_page_set_normal(cpu_buffer, next_page,
+					      tail_page,
+					      RB_PAGE_UPDATE);
+		if (RB_WARN_ON(cpu_buffer,
+			       ret != RB_PAGE_UPDATE))
+			return -1;
+	}
+
+	return 0;
+}
+
 static unsigned rb_calculate_event_length(unsigned length)
 {
 	struct ring_buffer_event event; /* Used only for sizeof array */
@@ -1205,96 +1785,93 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	     struct buffer_page *commit_page,
 	     struct buffer_page *tail_page, u64 *ts)
 {
-	struct buffer_page *next_page, *head_page, *reader_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
-	bool lock_taken = false;
-	unsigned long flags;
+	struct buffer_page *next_page;
+	int ret;
 
 	next_page = tail_page;
 
-	local_irq_save(flags);
-	/*
-	 * Since the write to the buffer is still not
-	 * fully lockless, we must be careful with NMIs.
-	 * The locks in the writers are taken when a write
-	 * crosses to a new page. The locks protect against
-	 * races with the readers (this will soon be fixed
-	 * with a lockless solution).
-	 *
-	 * Because we can not protect against NMIs, and we
-	 * want to keep traces reentrant, we need to manage
-	 * what happens when we are in an NMI.
-	 *
-	 * NMIs can happen after we take the lock.
-	 * If we are in an NMI, only take the lock
-	 * if it is not already taken. Otherwise
-	 * simply fail.
-	 */
-	if (unlikely(in_nmi())) {
-		if (!__raw_spin_trylock(&cpu_buffer->lock)) {
-			cpu_buffer->nmi_dropped++;
-			goto out_reset;
-		}
-	} else
-		__raw_spin_lock(&cpu_buffer->lock);
-
-	lock_taken = true;
-
 	rb_inc_page(cpu_buffer, &next_page);
 
-	head_page = cpu_buffer->head_page;
-	reader_page = cpu_buffer->reader_page;
-
-	/* we grabbed the lock before incrementing */
-	if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
-		goto out_reset;
-
 	/*
 	 * If for some reason, we had an interrupt storm that made
 	 * it all the way around the buffer, bail, and warn
 	 * about it.
 	 */
 	if (unlikely(next_page == commit_page)) {
-		cpu_buffer->commit_overrun++;
+		local_inc(&cpu_buffer->commit_overrun);
 		goto out_reset;
 	}
 
-	if (next_page == head_page) {
-		if (!(buffer->flags & RB_FL_OVERWRITE))
-			goto out_reset;
-
-		/* tail_page has not moved yet? */
-		if (tail_page == cpu_buffer->tail_page) {
-			/* count overflows */
-			cpu_buffer->overrun +=
-				local_read(&head_page->entries);
+	/*
+	 * This is where the fun begins!
+	 *
+	 * We are fighting against races between a reader that
+	 * could be on another CPU trying to swap its reader
+	 * page with the buffer head.
+	 *
+	 * We are also fighting against interrupts coming in and
+	 * moving the head or tail on us as well.
+	 *
+	 * If the next page is the head page then we have filled
+	 * the buffer, unless the commit page is still on the
+	 * reader page.
+	 */
+	if (rb_is_head_page(cpu_buffer, next_page, &tail_page->list)) {
 
-			rb_inc_page(cpu_buffer, &head_page);
-			cpu_buffer->head_page = head_page;
-			cpu_buffer->head_page->read = 0;
+		/*
+		 * If the commit is not on the reader page, then
+		 * move the header page.
+		 */
+		if (!rb_is_reader_page(cpu_buffer->commit_page)) {
+			/*
+			 * If we are not in overwrite mode,
+			 * this is easy, just stop here.
+			 */
+			if (!(buffer->flags & RB_FL_OVERWRITE))
+				goto out_reset;
+
+			ret = rb_handle_head_page(cpu_buffer,
+						  tail_page,
+						  next_page);
+			if (ret < 0)
+				goto out_reset;
+			if (ret)
+				goto out_again;
+		} else {
+			/*
+			 * We need to be careful here too. The
+			 * commit page could still be on the reader
+			 * page. We could have a small buffer, and
+			 * have filled up the buffer with events
+			 * from interrupts and such, and wrapped.
+			 *
+			 * Note, if the tail page is also the on the
+			 * reader_page, we let it move out.
+			 */
+			if (unlikely((cpu_buffer->commit_page !=
+				      cpu_buffer->tail_page) &&
+				     (cpu_buffer->commit_page ==
+				      cpu_buffer->reader_page))) {
+				local_inc(&cpu_buffer->commit_overrun);
+				goto out_reset;
+			}
 		}
 	}
 
-	/*
-	 * If the tail page is still the same as what we think
-	 * it is, then it is up to us to update the tail
-	 * pointer.
-	 */
-	if (tail_page == cpu_buffer->tail_page) {
-		local_set(&next_page->write, 0);
-		local_set(&next_page->entries, 0);
-		local_set(&next_page->page->commit, 0);
-		cpu_buffer->tail_page = next_page;
-
-		/* reread the time stamp */
+	ret = rb_tail_page_update(cpu_buffer, tail_page, next_page);
+	if (ret) {
+		/*
+		 * Nested commits always have zero deltas, so
+		 * just reread the time stamp
+		 */
 		*ts = rb_time_stamp(buffer, cpu_buffer->cpu);
-		cpu_buffer->tail_page->page->time_stamp = *ts;
+		next_page->page->time_stamp = *ts;
 	}
 
-	rb_reset_tail(cpu_buffer, tail_page, tail, length);
+ out_again:
 
-	__raw_spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
+	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
 	/* fail and let the caller try again */
 	return ERR_PTR(-EAGAIN);
@@ -1303,9 +1880,6 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	/* reset write */
 	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
-	if (likely(lock_taken))
-		__raw_spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
 	return NULL;
 }
 
@@ -1322,6 +1896,9 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	barrier();
 	tail_page = cpu_buffer->tail_page;
 	write = local_add_return(length, &tail_page->write);
+
+	/* set write to only the index of the write */
+	write &= RB_WRITE_MASK;
 	tail = write - length;
 
 	/* See if we shot pass the end of this buffer page */
@@ -1365,12 +1942,16 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 	bpage = cpu_buffer->tail_page;
 
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
+		unsigned long write_mask =
+			local_read(&bpage->write) & ~RB_WRITE_MASK;
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
 		 * and write to the next page. That is fine
 		 * because we just shorten what is on this page.
 		 */
+		old_index += write_mask;
+		new_index += write_mask;
 		index = local_cmpxchg(&bpage->write, old_index, new_index);
 		if (index == old_index)
 			return 1;
@@ -1870,9 +2451,13 @@ EXPORT_SYMBOL_GPL(ring_buffer_write);
 static int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct buffer_page *reader = cpu_buffer->reader_page;
-	struct buffer_page *head = cpu_buffer->head_page;
+	struct buffer_page *head = rb_set_head_page(cpu_buffer);
 	struct buffer_page *commit = cpu_buffer->commit_page;
 
+	/* In case of error, head will be NULL */
+	if (unlikely(!head))
+		return 1;
+
 	return reader->read == rb_page_commit(reader) &&
 		(commit == reader ||
 		 (commit == head &&
@@ -1963,7 +2548,7 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = (local_read(&cpu_buffer->entries) - cpu_buffer->overrun)
+	ret = (local_read(&cpu_buffer->entries) - local_read(&cpu_buffer->overrun))
 		- cpu_buffer->read;
 
 	return ret;
@@ -1984,33 +2569,13 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->overrun;
+	ret = local_read(&cpu_buffer->overrun);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
- * ring_buffer_nmi_dropped_cpu - get the number of nmis that were dropped
- * @buffer: The ring buffer
- * @cpu: The per CPU buffer to get the number of overruns from
- */
-unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu)
-{
-	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long ret;
-
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return 0;
-
-	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->nmi_dropped;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(ring_buffer_nmi_dropped_cpu);
-
-/**
  * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
@@ -2025,7 +2590,7 @@ ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->commit_overrun;
+	ret = local_read(&cpu_buffer->commit_overrun);
 
 	return ret;
 }
@@ -2048,7 +2613,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 		entries += (local_read(&cpu_buffer->entries) -
-			    cpu_buffer->overrun) - cpu_buffer->read;
+			    local_read(&cpu_buffer->overrun)) - cpu_buffer->read;
 	}
 
 	return entries;
@@ -2071,7 +2636,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		overruns += cpu_buffer->overrun;
+		overruns += local_read(&cpu_buffer->overrun);
 	}
 
 	return overruns;
@@ -2084,8 +2649,10 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 
 	/* Iterator usage is expected to have record disabled */
 	if (list_empty(&cpu_buffer->reader_page->list)) {
-		iter->head_page = cpu_buffer->head_page;
-		iter->head = cpu_buffer->head_page->read;
+		iter->head_page = rb_set_head_page(cpu_buffer);
+		if (unlikely(!iter->head_page))
+			return;
+		iter->head = iter->head_page->read;
 	} else {
 		iter->head_page = cpu_buffer->reader_page;
 		iter->head = cpu_buffer->reader_page->read;
@@ -2202,6 +2769,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
 	int nr_loops = 0;
+	int ret;
 
 	local_irq_save(flags);
 	__raw_spin_lock(&cpu_buffer->lock);
@@ -2235,11 +2803,17 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 		goto out;
 
 	/*
-	 * Splice the empty reader page into the list around the head.
 	 * Reset the reader page to size zero.
 	 */
+	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->entries, 0);
+	local_set(&cpu_buffer->reader_page->page->commit, 0);
 
-	reader = cpu_buffer->head_page;
+ spin:
+	/*
+	 * Splice the empty reader page into the list around the head.
+	 */
+	reader = rb_set_head_page(cpu_buffer);
 	cpu_buffer->reader_page->list.next = reader->list.next;
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
@@ -2250,22 +2824,35 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 */
 	cpu_buffer->pages = reader->list.prev;
 
-	local_set(&cpu_buffer->reader_page->write, 0);
-	local_set(&cpu_buffer->reader_page->entries, 0);
-	local_set(&cpu_buffer->reader_page->page->commit, 0);
+	/* The reader page will be pointing to the new head */
+	rb_set_list_to_head(cpu_buffer, &cpu_buffer->reader_page->list);
 
-	/* Make the reader page now replace the head */
-	reader->list.prev->next = &cpu_buffer->reader_page->list;
-	reader->list.next->prev = &cpu_buffer->reader_page->list;
+	/*
+	 * Here's the tricky part.
+	 *
+	 * We need to move the pointer past the header page.
+	 * But we can only do that if a writer is not currently
+	 * moving it. The page before the header page has the
+	 * flag bit '1' set if it is pointing to the page we want.
+	 * but if the writer is in the process of moving it
+	 * than it will be '2' or already moved '0'.
+	 */
+
+	ret = rb_head_page_replace(reader, cpu_buffer->reader_page);
 
 	/*
-	 * If the tail is on the reader, then we must set the head
-	 * to the inserted page, otherwise we set it one before.
+	 * If we did not convert it, then we must try again.
 	 */
-	cpu_buffer->head_page = cpu_buffer->reader_page;
+	if (!ret)
+		goto spin;
 
-	if (cpu_buffer->commit_page != reader)
-		rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
+	/*
+	 * Yeah! We succeeded in replacing the page.
+	 *
+	 * Now make the new head point back to the reader page.
+	 */
+	reader->list.next->prev = &cpu_buffer->reader_page->list;
+	rb_inc_page(cpu_buffer, &cpu_buffer->head_page);
 
 	/* Finally update the reader page to the new head */
 	cpu_buffer->reader_page = reader;
@@ -2721,6 +3308,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_size);
 static void
 rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 {
+	rb_head_page_deactivate(cpu_buffer);
+
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages, struct buffer_page, list);
 	local_set(&cpu_buffer->head_page->write, 0);
@@ -2738,16 +3327,17 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
-	cpu_buffer->nmi_dropped = 0;
-	cpu_buffer->commit_overrun = 0;
-	cpu_buffer->overrun = 0;
-	cpu_buffer->read = 0;
+	local_set(&cpu_buffer->commit_overrun, 0);
+	local_set(&cpu_buffer->overrun, 0);
 	local_set(&cpu_buffer->entries, 0);
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
+	cpu_buffer->read = 0;
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
+
+	rb_head_page_activate(cpu_buffer);
 }
 
 /**
@@ -3095,7 +3685,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		read = 0;
 	} else {
 		/* update the entry counter */
-		cpu_buffer->read += local_read(&reader->entries);
+		cpu_buffer->read += rb_page_entries(reader);
 
 		/* swap the pages */
 		rb_init_page(bpage);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0f57f1b..09f11db 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3642,9 +3642,6 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
 
-	cnt = ring_buffer_nmi_dropped_cpu(tr->buffer, cpu);
-	trace_seq_printf(s, "nmi dropped: %ld\n", cnt);
-
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
 
 	kfree(s);
-- 
1.6.3.1

-- 
