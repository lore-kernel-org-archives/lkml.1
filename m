Return-Path: <linux-kernel-owner+w=401wt.eu-S1763567AbYDOBli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567AbYDOBli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbYDOBla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:41:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901AbYDOBl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:41:29 -0400
Date: Mon, 14 Apr 2008 21:41:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH sched-devel] ftrace: trace_entries to change trace buffer
 size 
In-Reply-To: <20080414211433.3bfa5649@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0804142139240.16591@gandalf.stny.rr.com>
References: <20080411163923.439680284@goodmis.org> <20080411164037.219665668@goodmis.org>
 <20080411214328.25c06a5d@daedalus.pq.iki.fi> <Pine.LNX.4.58.0804112021200.4500@gandalf.stny.rr.com>
 <20080413145604.3fb396a2@daedalus.pq.iki.fi> <20080414095645.GC3761@elte.hu>
 <20080414211433.3bfa5649@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds /debug/tracing/trace_entries that allows users to see as
well as modify the number of entries the buffers hold. The number of entries
only increments in ENTRIES_PER_PAGE which is calculated by the size of an
entry with the number of entries that can fit in a page. The user does
not need to use an exact size, but the entries will be rounded to one of
the increments.

Trying to set the entries to 0 will return with -EINVAL.

To avoid race conditions, the modification of the buffer size can only
be done when tracing is completely disabled (current_tracer == none).
A info message will be printed if a user tries to modify the buffer size
when not set to none.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  145 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 137 insertions(+), 8 deletions(-)

Index: linux-sched-devel.git/kernel/trace/trace.c
===================================================================
--- linux-sched-devel.git.orig/kernel/trace/trace.c	2008-04-14 14:27:26.000000000 -0400
+++ linux-sched-devel.git/kernel/trace/trace.c	2008-04-14 21:09:04.000000000 -0400
@@ -35,6 +35,15 @@
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;

+/* dummy trace to disable tracing */
+static struct tracer no_tracer __read_mostly =
+{
+	.name		= "none",
+};
+
+static int trace_alloc_page(void);
+static int trace_free_page(void);
+
 static int tracing_disabled = 1;

 long
@@ -2411,6 +2420,70 @@ tracing_read_pipe(struct file *filp, cha
 	return read;
 }

+static ssize_t
+tracing_entries_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	char buf[64];
+	int r;
+
+	r = sprintf(buf, "%lu\n", tr->entries);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+tracing_entries_write(struct file *filp, const char __user *ubuf,
+		      size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	char buf[64];
+
+	if (cnt > 63)
+		cnt = 63;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	val = simple_strtoul(buf, NULL, 10);
+
+	/* must have at least 1 entry */
+	if (!val)
+		return -EINVAL;
+
+	mutex_lock(&trace_types_lock);
+
+	if (current_trace != &no_tracer) {
+		cnt = -EBUSY;
+		pr_info("ftrace: set current_tracer to none"
+			" before modifying buffer size\n");
+		goto out;
+	}
+
+	if (val > global_trace.entries) {
+		while (global_trace.entries < val) {
+			if (trace_alloc_page()) {
+				cnt = -ENOMEM;
+				goto out;
+			}
+		}
+	} else {
+		/* include the number of entries in val (inc of page entries) */
+		while (global_trace.entries > val + (ENTRIES_PER_PAGE - 1))
+			trace_free_page();
+	}
+
+	filp->f_pos += cnt;
+
+ out:
+	max_tr.entries = global_trace.entries;
+	mutex_unlock(&trace_types_lock);
+
+	return cnt;
+}
+
 static struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -2436,6 +2509,12 @@ static struct file_operations tracing_pi
 	.release	= tracing_release_pipe,
 };

+static struct file_operations tracing_entries_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_entries_read,
+	.write		= tracing_entries_write,
+};
+
 #ifdef CONFIG_DYNAMIC_FTRACE

 static ssize_t
@@ -2547,6 +2626,12 @@ static __init void tracer_init_debugfs(v
 		pr_warning("Could not create debugfs "
 			   "'tracing_threash' entry\n");

+	entry = debugfs_create_file("trace_entries", 0644, d_tracer,
+				    &global_trace, &tracing_entries_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'tracing_threash' entry\n");
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 				    &ftrace_update_tot_cnt,
@@ -2560,12 +2645,6 @@ static __init void tracer_init_debugfs(v
 #endif
 }

-/* dummy trace to disable tracing */
-static struct tracer no_tracer __read_mostly =
-{
-	.name		= "none",
-};
-
 static int trace_alloc_page(void)
 {
 	struct trace_array_cpu *data;
@@ -2602,7 +2681,6 @@ static int trace_alloc_page(void)
 	/* Now that we successfully allocate a page per CPU, add them */
 	for_each_possible_cpu(i) {
 		data = global_trace.data[i];
-		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 		page = list_entry(pages.next, struct page, lru);
 		list_del_init(&page->lru);
 		list_add_tail(&page->lru, &data->trace_pages);
@@ -2610,7 +2688,6 @@ static int trace_alloc_page(void)

 #ifdef CONFIG_TRACER_MAX_TRACE
 		data = max_tr.data[i];
-		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 		page = list_entry(pages.next, struct page, lru);
 		list_del_init(&page->lru);
 		list_add_tail(&page->lru, &data->trace_pages);
@@ -2629,6 +2706,55 @@ static int trace_alloc_page(void)
 	return -ENOMEM;
 }

+static int trace_free_page(void)
+{
+	struct trace_array_cpu *data;
+	struct page *page;
+	struct list_head *p;
+	int i;
+	int ret = 0;
+
+	/* free one page from each buffer */
+	for_each_possible_cpu(i) {
+		data = global_trace.data[i];
+		p = data->trace_pages.next;
+		if (p == &data->trace_pages) {
+			/* should never happen */
+			WARN_ON(1);
+			tracing_disabled = 1;
+			ret = -1;
+			break;
+		}
+		page = list_entry(p, struct page, lru);
+		ClearPageLRU(page);
+		list_del(&page->lru);
+		__free_page(page);
+
+		tracing_reset(data);
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+		data = max_tr.data[i];
+		p = data->trace_pages.next;
+		if (p == &data->trace_pages) {
+			/* should never happen */
+			WARN_ON(1);
+			tracing_disabled = 1;
+			ret = -1;
+			break;
+		}
+		page = list_entry(p, struct page, lru);
+		ClearPageLRU(page);
+		list_del(&page->lru);
+		__free_page(page);
+
+		tracing_reset(data);
+#endif
+	}
+	global_trace.entries -= ENTRIES_PER_PAGE;
+
+	return ret;
+}
+
 __init static int tracer_alloc_buffers(void)
 {
 	struct trace_array_cpu *data;
@@ -2659,6 +2785,9 @@ __init static int tracer_alloc_buffers(v
 		/* use the LRU flag to differentiate the two buffers */
 		ClearPageLRU(page);

+		data->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+		max_tr.data[i]->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
 /* Only allocate if we are actually using the max trace */
 #ifdef CONFIG_TRACER_MAX_TRACE
 		array = (void *)__get_free_page(GFP_KERNEL);


