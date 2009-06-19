Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZFSPVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZFSPVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZFSPVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:21:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36860 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZFSPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:21:16 -0400
Message-Id: <20090619152117.203253639@goodmis.org>
References: <20090619151922.830665788@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 19 Jun 2009 11:19:23 -0400
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
Subject: [PATCH v2 1/3] ring-buffer: make the buffer a true circular link list
Content-Disposition: inline; filename=0001-ring-buffer-make-the-buffer-a-true-circular-link-lis.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch changes the ring buffer data pages from using a link list
head pointer, to making each buffer page point to another buffer page
and never back to a "head".

This makes the handling of the ring buffer less complex, since the
traversing of the ring buffer pages no longer needs to account for the
head pointer.

This change also is needed to make the ring buffer lockless.

[
  Changes in version 2:

  - Added change that Lai Jiangshan mentioned.

  From: Lai Jiangshan <laijs@cn.fujitsu.com>
  Date: Thu, 11 Jun 2009 11:25:48 +0800
  LKML-Reference: <4A30793C.6090208@cn.fujitsu.com>

  I'm not sure whether these 4 lines:
	bpage = list_entry(pages.next, struct buffer_page, list);
	list_del_init(&bpage->list);
	cpu_buffer->pages = &bpage->list;

	list_splice(&pages, cpu_buffer->pages);
  equal to these 2 lines:
 	cpu_buffer->pages = pages.next;
 	list_del(&pages);

  If there are equivalent, I think the second one
  are simpler. It may be not a really necessarily cleanup.

  What I asked is: if there are equivalent, could you use these two line:
 	cpu_buffer->pages = pages.next;
	list_del(&pages);
]

[ Impact: simplify the ring buffer to help make it lockless ]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   49 ++++++++++++++++++++++++++++---------------
 1 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 589b3ee..3b2ffe8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -405,7 +405,7 @@ struct ring_buffer_per_cpu {
 	spinlock_t			reader_lock; /* serialize readers */
 	raw_spinlock_t			lock;
 	struct lock_class_key		lock_key;
-	struct list_head		pages;
+	struct list_head		*pages;
 	struct buffer_page		*head_page;	/* read from head */
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
@@ -497,7 +497,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
  */
 static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct list_head *head = &cpu_buffer->pages;
+	struct list_head *head = cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 
 	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
@@ -520,12 +520,13 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 			     unsigned nr_pages)
 {
-	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 	unsigned long addr;
 	LIST_HEAD(pages);
 	unsigned i;
 
+	WARN_ON(!nr_pages);
+
 	for (i = 0; i < nr_pages; i++) {
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
@@ -540,7 +541,13 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		rb_init_page(bpage->page);
 	}
 
-	list_splice(&pages, head);
+	/*
+	 * The ring buffer page list is a circular list that does not
+	 * start and end with a list head. All page list items point to
+	 * other pages.
+	 */
+	cpu_buffer->pages = pages.next;
+	list_del(&pages);
 
 	rb_check_pages(cpu_buffer);
 
@@ -572,7 +579,6 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-	INIT_LIST_HEAD(&cpu_buffer->pages);
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -593,7 +599,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 		goto fail_free_reader;
 
 	cpu_buffer->head_page
-		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+		= list_entry(cpu_buffer->pages, struct buffer_page, list);
 	cpu_buffer->tail_page = cpu_buffer->commit_page = cpu_buffer->head_page;
 
 	return cpu_buffer;
@@ -608,15 +614,20 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct list_head *head = &cpu_buffer->pages;
+	struct list_head *head = cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 
 	free_buffer_page(cpu_buffer->reader_page);
 
-	list_for_each_entry_safe(bpage, tmp, head, list) {
-		list_del_init(&bpage->list);
+	if (head) {
+		list_for_each_entry_safe(bpage, tmp, head, list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
+		bpage = list_entry(head, struct buffer_page, list);
 		free_buffer_page(bpage);
 	}
+
 	kfree(cpu_buffer);
 }
 
@@ -759,14 +770,14 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	synchronize_sched();
 
 	for (i = 0; i < nr_pages; i++) {
-		if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
+		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
 			return;
-		p = cpu_buffer->pages.next;
+		p = cpu_buffer->pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
 		free_buffer_page(bpage);
 	}
-	if (RB_WARN_ON(cpu_buffer, list_empty(&cpu_buffer->pages)))
+	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
 		return;
 
 	rb_reset_cpu(cpu_buffer);
@@ -794,7 +805,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		p = pages->next;
 		bpage = list_entry(p, struct buffer_page, list);
 		list_del_init(&bpage->list);
-		list_add_tail(&bpage->list, &cpu_buffer->pages);
+		list_add_tail(&bpage->list, cpu_buffer->pages);
 	}
 	rb_reset_cpu(cpu_buffer);
 
@@ -991,9 +1002,6 @@ static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	struct list_head *p = (*bpage)->list.next;
 
-	if (p == &cpu_buffer->pages)
-		p = p->next;
-
 	*bpage = list_entry(p, struct buffer_page, list);
 }
 
@@ -2235,6 +2243,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page->list.next = reader->list.next;
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
+	/*
+	 * cpu_buffer->pages just needs to point to the buffer, it
+	 *  has no specific buffer page to point to. Lets move it out
+	 *  of our way so we don't accidently swap it.
+	 */
+	cpu_buffer->pages = reader->list.prev;
+
 	local_set(&cpu_buffer->reader_page->write, 0);
 	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
@@ -2707,7 +2722,7 @@ static void
 rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	cpu_buffer->head_page
-		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
+		= list_entry(cpu_buffer->pages, struct buffer_page, list);
 	local_set(&cpu_buffer->head_page->write, 0);
 	local_set(&cpu_buffer->head_page->entries, 0);
 	local_set(&cpu_buffer->head_page->page->commit, 0);
-- 
1.6.3.1

-- 
