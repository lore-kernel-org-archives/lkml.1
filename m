Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZERLil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZERLil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZERLi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:38:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZERLi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:38:28 -0400
Message-ID: <4A114806.7090302@cn.fujitsu.com>
Date: Mon, 18 May 2009 19:35:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: add trace_event_read_lock()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found that there is nothing to protect event_hash in
ftrace_find_event().

RCU can also protect ftrace_find_event(), but it will add
latency to kernel. So this fix converts 'trace_event_mutex'
to a read/write semaphore, and adds trace_event_read_lock()
to protect ftrace_find_event().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 665a915..4ef8052 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1569,12 +1569,14 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		p = s_next(m, p, &l);
 	}
 
+	trace_event_read_lock();
 	return p;
 }
 
 static void s_stop(struct seq_file *m, void *p)
 {
 	atomic_dec(&trace_record_cmdline_disabled);
+	trace_event_read_unlock();
 }
 
 static void print_lat_help_header(struct seq_file *m)
@@ -1817,6 +1819,7 @@ static int trace_empty(struct trace_iterator *iter)
 	return 1;
 }
 
+/*  Called with trace_event_read_lock() held. */
 static enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
@@ -3008,6 +3011,7 @@ waitagain:
 	       offsetof(struct trace_iterator, seq));
 	iter->pos = -1;
 
+	trace_event_read_lock();
 	while (find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
@@ -3024,6 +3028,7 @@ waitagain:
 		if (iter->seq.len >= cnt)
 			break;
 	}
+	trace_event_read_unlock();
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
@@ -3146,6 +3151,8 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		goto out_err;
 	}
 
+	trace_event_read_lock();
+
 	/* Fill as many pages as possible. */
 	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
 		pages[i] = alloc_page(GFP_KERNEL);
@@ -3168,6 +3175,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		trace_seq_init(&iter->seq);
 	}
 
+	trace_event_read_unlock();
 	mutex_unlock(&iter->mutex);
 
 	spd.nr_pages = i;
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 489c0e8..7136420 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -14,7 +14,7 @@
 /* must be a power of 2 */
 #define EVENT_HASHSIZE	128
 
-static DEFINE_MUTEX(trace_event_mutex);
+static DECLARE_RWSEM(trace_event_mutex);
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
@@ -466,6 +466,7 @@ static int task_state_char(unsigned long state)
  * @type: the type of event to look for
  *
  * Returns an event of type @type otherwise NULL
+ * Called with trace_event_read_lock() held.
  */
 struct trace_event *ftrace_find_event(int type)
 {
@@ -475,7 +476,7 @@ struct trace_event *ftrace_find_event(int type)
 
 	key = type & (EVENT_HASHSIZE - 1);
 
-	hlist_for_each_entry_rcu(event, n, &event_hash[key], node) {
+	hlist_for_each_entry(event, n, &event_hash[key], node) {
 		if (event->type == type)
 			return event;
 	}
@@ -513,6 +514,16 @@ static int trace_search_list(struct list_head **list)
 	return last + 1;
 }
 
+void trace_event_read_lock(void)
+{
+	down_read(&trace_event_mutex);
+}
+
+void trace_event_read_unlock(void)
+{
+	up_read(&trace_event_mutex);
+}
+
 /**
  * register_ftrace_event - register output for an event type
  * @event: the event type to register
@@ -533,7 +544,7 @@ int register_ftrace_event(struct trace_event *event)
 	unsigned key;
 	int ret = 0;
 
-	mutex_lock(&trace_event_mutex);
+	down_write(&trace_event_mutex);
 
 	if (WARN_ON(!event))
 		goto out;
@@ -581,11 +592,11 @@ int register_ftrace_event(struct trace_event *event)
 
 	key = event->type & (EVENT_HASHSIZE - 1);
 
-	hlist_add_head_rcu(&event->node, &event_hash[key]);
+	hlist_add_head(&event->node, &event_hash[key]);
 
 	ret = event->type;
  out:
-	mutex_unlock(&trace_event_mutex);
+	up_write(&trace_event_mutex);
 
 	return ret;
 }
@@ -597,10 +608,10 @@ EXPORT_SYMBOL_GPL(register_ftrace_event);
  */
 int unregister_ftrace_event(struct trace_event *event)
 {
-	mutex_lock(&trace_event_mutex);
+	down_write(&trace_event_mutex);
 	hlist_del(&event->node);
 	list_del(&event->list);
-	mutex_unlock(&trace_event_mutex);
+	up_write(&trace_event_mutex);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 6e220a8..ac240e7 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -20,6 +20,8 @@ extern int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 extern int trace_print_context(struct trace_iterator *iter);
 extern int trace_print_lat_context(struct trace_iterator *iter);
 
+extern void trace_event_read_lock(void);
+extern void trace_event_read_unlock(void);
 extern struct trace_event *ftrace_find_event(int type);
 
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,




