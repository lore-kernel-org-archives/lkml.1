Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZCYEJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZCYEJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZCYEIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:08:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZCYEIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:08:35 -0400
Message-Id: <20090325040832.443420395@goodmis.org>
References: <20090325035646.662994901@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 23:56:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5][RFC] tracing: move function profiler data out of function struct
Content-Disposition: inline; filename=0002-tracing-move-function-profiler-data-out-of-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: reduce size of memory in function profiler

The function profiler originally introduces its counters into the
function records itself. There is 20 thousand different functions on
a normal system, and that is adding 20 thousand counters for profiling
event when not needed.

A normal run of the profiler yields only a couple of thousand functions
executed, depending on what is being profiled. This means we have around
18 thousand useless counters.

This patch rectifies this by moving the data out of the function
records used by dynamic ftrace. Data is preallocated to hold the functions
when the profiling begins. Checks are made during profiling to see if
more recorcds should be allocated, and they are allocated if it is safe
to do so.

This also removes the dependency from using dynamic ftrace, and also
removes the overhead by having it enabled.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    4 -
 kernel/trace/Kconfig   |   10 +-
 kernel/trace/ftrace.c  |  440 ++++++++++++++++++++++++++++--------------------
 3 files changed, 263 insertions(+), 191 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0456c3a..015a3d2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -153,10 +153,6 @@ struct dyn_ftrace {
 		unsigned long		flags;
 		struct dyn_ftrace	*newlist;
 	};
-#ifdef CONFIG_FUNCTION_PROFILER
-	unsigned long			counter;
-	struct hlist_node		node;
-#endif
 	struct dyn_arch_ftrace		arch;
 };
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 95e9ad5..8a41360 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -379,20 +379,16 @@ config DYNAMIC_FTRACE
 
 config FUNCTION_PROFILER
 	bool "Kernel function profiler"
-	depends on DYNAMIC_FTRACE
+	depends on FUNCTION_TRACER
 	default n
 	help
-	 This option enables the kernel function profiler. When the dynamic
-	 function tracing is enabled, a counter is added into the function
-	 records used by the dynamic function tracer. A file is created in
-	 debugfs called function_profile_enabled which defaults to zero.
+	 This option enables the kernel function profiler. A file is created
+	 in debugfs called function_profile_enabled which defaults to zero.
 	 When a 1 is echoed into this file profiling begins, and when a
 	 zero is entered, profiling stops. A file in the trace_stats
 	 directory called functions, that show the list of functions that
 	 have been hit and their counters.
 
-	 This takes up around 320K more memory.
-
 	 If in doubt, say N
 
 config FTRACE_MCOUNT_RECORD
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 11f364c..24dac44 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -241,87 +241,48 @@ static void ftrace_update_pid_func(void)
 #endif
 }
 
-/* set when tracing only a pid */
-struct pid *ftrace_pid_trace;
-static struct pid * const ftrace_swapper_pid = &init_struct_pid;
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-
-#ifndef CONFIG_FTRACE_MCOUNT_RECORD
-# error Dynamic ftrace depends on MCOUNT_RECORD
-#endif
-
-static struct hlist_head ftrace_func_hash[FTRACE_FUNC_HASHSIZE] __read_mostly;
-
-struct ftrace_func_probe {
-	struct hlist_node	node;
-	struct ftrace_probe_ops	*ops;
-	unsigned long		flags;
-	unsigned long		ip;
-	void			*data;
-	struct rcu_head		rcu;
+#ifdef CONFIG_FUNCTION_PROFILER
+struct ftrace_profile {
+	struct hlist_node		node;
+	unsigned long			ip;
+	unsigned long			counter;
 };
 
-enum {
-	FTRACE_ENABLE_CALLS		= (1 << 0),
-	FTRACE_DISABLE_CALLS		= (1 << 1),
-	FTRACE_UPDATE_TRACE_FUNC	= (1 << 2),
-	FTRACE_ENABLE_MCOUNT		= (1 << 3),
-	FTRACE_DISABLE_MCOUNT		= (1 << 4),
-	FTRACE_START_FUNC_RET		= (1 << 5),
-	FTRACE_STOP_FUNC_RET		= (1 << 6),
+struct ftrace_profile_page {
+	struct ftrace_profile_page	*next;
+	unsigned long			index;
+	struct ftrace_profile		records[];
 };
 
-static int ftrace_filtered;
+#define PROFILE_RECORDS_SIZE						\
+	(PAGE_SIZE - offsetof(struct ftrace_profile_page, records))
 
-static struct dyn_ftrace *ftrace_new_addrs;
+#define PROFILES_PER_PAGE					\
+	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
 
-static DEFINE_MUTEX(ftrace_regex_lock);
-
-struct ftrace_page {
-	struct ftrace_page	*next;
-	int			index;
-	struct dyn_ftrace	records[];
-};
+/* TODO: make these percpu, to prevent cache line bouncing */
+static struct ftrace_profile_page *profile_pages_start;
+static struct ftrace_profile_page *profile_pages;
 
-#define ENTRIES_PER_PAGE \
-  ((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))
-
-/* estimate from running different kernels */
-#define NR_TO_INIT		10000
-
-static struct ftrace_page	*ftrace_pages_start;
-static struct ftrace_page	*ftrace_pages;
-
-static struct dyn_ftrace *ftrace_free_records;
-
-/*
- * This is a double for. Do not use 'break' to break out of the loop,
- * you must use a goto.
- */
-#define do_for_each_ftrace_rec(pg, rec)					\
-	for (pg = ftrace_pages_start; pg; pg = pg->next) {		\
-		int _____i;						\
-		for (_____i = 0; _____i < pg->index; _____i++) {	\
-			rec = &pg->records[_____i];
-
-#define while_for_each_ftrace_rec()		\
-		}				\
-	}
-
-#ifdef CONFIG_FUNCTION_PROFILER
 static struct hlist_head *ftrace_profile_hash;
 static int ftrace_profile_bits;
 static int ftrace_profile_enabled;
 static DEFINE_MUTEX(ftrace_profile_lock);
 
+static DEFINE_PER_CPU(atomic_t, ftrace_profile_disable);
+
+#define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
+
+static raw_spinlock_t ftrace_profile_rec_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
 static void *
 function_stat_next(void *v, int idx)
 {
-	struct dyn_ftrace *rec = v;
-	struct ftrace_page *pg;
+	struct ftrace_profile *rec = v;
+	struct ftrace_profile_page *pg;
 
-	pg = (struct ftrace_page *)((unsigned long)rec & PAGE_MASK);
+	pg = (struct ftrace_profile_page *)((unsigned long)rec & PAGE_MASK);
 
  again:
 	rec++;
@@ -330,27 +291,22 @@ function_stat_next(void *v, int idx)
 		if (!pg)
 			return NULL;
 		rec = &pg->records[0];
+		if (!rec->counter)
+			goto again;
 	}
 
-	if (rec->flags & FTRACE_FL_FREE ||
-	    rec->flags & FTRACE_FL_FAILED ||
-	    !(rec->flags & FTRACE_FL_CONVERTED) ||
-	    /* ignore non hit functions */
-	    !rec->counter)
-		goto again;
-
 	return rec;
 }
 
 static void *function_stat_start(struct tracer_stat *trace)
 {
-	return function_stat_next(&ftrace_pages_start->records[0], 0);
+	return function_stat_next(&profile_pages_start->records[0], 0);
 }
 
 static int function_stat_cmp(void *p1, void *p2)
 {
-	struct dyn_ftrace *a = p1;
-	struct dyn_ftrace *b = p2;
+	struct ftrace_profile *a = p1;
+	struct ftrace_profile *b = p2;
 
 	if (a->counter < b->counter)
 		return -1;
@@ -369,7 +325,7 @@ static int function_stat_headers(struct seq_file *m)
 
 static int function_stat_show(struct seq_file *m, void *v)
 {
-	struct dyn_ftrace *rec = v;
+	struct ftrace_profile *rec = v;
 	char str[KSYM_SYMBOL_LEN];
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
@@ -387,115 +343,191 @@ static struct tracer_stat function_stats = {
 	.stat_show = function_stat_show
 };
 
-static void ftrace_profile_init(int nr_funcs)
+static void ftrace_profile_reset(void)
 {
-	unsigned long addr;
-	int order;
-	int size;
+	struct ftrace_profile_page *pg;
 
-	/*
-	 * We are profiling all functions, lets make it 1/4th of the
-	 * number of functions that are in core kernel. So we have to
-	 * iterate 4 times.
-	 */
-	order = (sizeof(struct hlist_head) * nr_funcs) / 4;
-	order = get_order(order);
-	size = 1 << (PAGE_SHIFT + order);
-
-	pr_info("Allocating %d KB for profiler hash\n", size >> 10);
+	pg = profile_pages = profile_pages_start;
 
-	addr = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
-	if (!addr) {
-		pr_warning("Could not allocate function profiler hash\n");
-		return;
+	while (pg) {
+		memset(pg->records, 0, PROFILE_RECORDS_SIZE);
+		pg->index = 0;
+		pg = pg->next;
 	}
 
-	ftrace_profile_hash = (void *)addr;
+	memset(ftrace_profile_hash, 0,
+	       FTRACE_PROFILE_HASH_SIZE * sizeof(struct hlist_head));
+}
 
-	/*
-	 * struct hlist_head should be a pointer of 4 or 8 bytes.
-	 * And a simple bit manipulation can be done, but if for
-	 * some reason struct hlist_head is not a mulitple of 2,
-	 * then we play it safe, and simply count. This function
-	 * is done once at boot up, so it is not that critical in
-	 * performance.
-	 */
+int ftrace_profile_pages_init(void)
+{
+	struct ftrace_profile_page *pg;
+	int i;
 
-	size--;
-	size /= sizeof(struct hlist_head);
+	/* If we already allocated, do nothing */
+	if (profile_pages)
+		return 0;
 
-	for (; size; size >>= 1)
-		ftrace_profile_bits++;
+	profile_pages = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!profile_pages)
+		return -ENOMEM;
 
-	pr_info("Function profiler has %d hash buckets\n",
-		1 << ftrace_profile_bits);
+	pg = profile_pages_start = profile_pages;
 
-	return;
+	/* allocate 10 more pages to start */
+	for (i = 0; i < 10; i++) {
+		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
+		/*
+		 * We only care about allocating profile_pages, if
+		 * we failed to allocate here, hopefully we will allocate
+		 * later.
+		 */
+		if (!pg->next)
+			break;
+		pg = pg->next;
+	}
+
+	return 0;
 }
 
-static ssize_t
-ftrace_profile_read(struct file *filp, char __user *ubuf,
-		     size_t cnt, loff_t *ppos)
+static int ftrace_profile_init(void)
 {
-	char buf[64];
-	int r;
+	int size;
 
-	r = sprintf(buf, "%u\n", ftrace_profile_enabled);
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
+	if (ftrace_profile_hash) {
+		/* If the profile is already created, simply reset it */
+		ftrace_profile_reset();
+		return 0;
+	}
 
-static void ftrace_profile_reset(void)
-{
-	struct dyn_ftrace *rec;
-	struct ftrace_page *pg;
+	/*
+	 * We are profiling all functions, but usually only a few thousand
+	 * functions are hit. We'll make a hash of 1024 items.
+	 */
+	size = FTRACE_PROFILE_HASH_SIZE;
 
-	do_for_each_ftrace_rec(pg, rec) {
-		rec->counter = 0;
-	} while_for_each_ftrace_rec();
+	ftrace_profile_hash =
+		kzalloc(sizeof(struct hlist_head) * size, GFP_KERNEL);
+
+	if (!ftrace_profile_hash)
+		return -ENOMEM;
+
+	size--;
+
+	for (; size; size >>= 1)
+		ftrace_profile_bits++;
+
+	/* Preallocate a few pages */
+	if (ftrace_profile_pages_init() < 0) {
+		kfree(ftrace_profile_hash);
+		ftrace_profile_hash = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
-static struct dyn_ftrace *ftrace_find_profiled_func(unsigned long ip)
+/* interrupts must be disabled */
+static struct ftrace_profile *ftrace_find_profiled_func(unsigned long ip)
 {
-	struct dyn_ftrace *rec;
+	struct ftrace_profile *rec;
 	struct hlist_head *hhd;
 	struct hlist_node *n;
-	unsigned long flags;
 	unsigned long key;
 
-	if (!ftrace_profile_hash)
-		return NULL;
-
 	key = hash_long(ip, ftrace_profile_bits);
 	hhd = &ftrace_profile_hash[key];
 
 	if (hlist_empty(hhd))
 		return NULL;
 
-	local_irq_save(flags);
 	hlist_for_each_entry_rcu(rec, n, hhd, node) {
 		if (rec->ip == ip)
-			goto out;
+			return rec;
+	}
+
+	return NULL;
+}
+
+static void ftrace_add_profile(struct ftrace_profile *rec)
+{
+	unsigned long key;
+
+	key = hash_long(rec->ip, ftrace_profile_bits);
+	hlist_add_head_rcu(&rec->node, &ftrace_profile_hash[key]);
+}
+
+/* Interrupts must be disabled calling this */
+static struct ftrace_profile *
+ftrace_profile_alloc(unsigned long ip, bool alloc_safe)
+{
+	struct ftrace_profile *rec = NULL;
+
+	/* prevent recursion */
+	if (atomic_inc_return(&__get_cpu_var(ftrace_profile_disable)) != 1)
+		goto out;
+
+	__raw_spin_lock(&ftrace_profile_rec_lock);
+
+	/* Try to always keep another page available */
+	if (!profile_pages->next && alloc_safe)
+		profile_pages->next = (void *)get_zeroed_page(GFP_ATOMIC);
+
+	/*
+	 * Try to find the function again since another
+	 * task on another CPU could have added it
+	 */
+	rec = ftrace_find_profiled_func(ip);
+	if (rec)
+		goto out_unlock;
+
+	if (profile_pages->index == PROFILES_PER_PAGE) {
+		if (!profile_pages->next)
+			goto out_unlock;
+		profile_pages = profile_pages->next;
 	}
-	rec = NULL;
+
+	rec = &profile_pages->records[profile_pages->index++];
+	rec->ip = ip;
+	ftrace_add_profile(rec);
+
+ out_unlock:
+	__raw_spin_unlock(&ftrace_profile_rec_lock);
  out:
-	local_irq_restore(flags);
+	atomic_dec(&__get_cpu_var(ftrace_profile_disable));
 
 	return rec;
 }
 
+/*
+ * If we are not in an interrupt, or softirq and
+ * and interrupts are disabled and preemption is not enabled
+ * (not in a spinlock) then it should be safe to allocate memory.
+ */
+static bool ftrace_safe_to_allocate(void)
+{
+	return !in_interrupt() && irqs_disabled() && !preempt_count();
+}
+
 static void
 function_profile_call(unsigned long ip, unsigned long parent_ip)
 {
-	struct dyn_ftrace *rec;
+	struct ftrace_profile *rec;
 	unsigned long flags;
+	bool alloc_safe;
 
 	if (!ftrace_profile_enabled)
 		return;
 
+	alloc_safe = ftrace_safe_to_allocate();
+
 	local_irq_save(flags);
 	rec = ftrace_find_profiled_func(ip);
-	if (!rec)
-		goto out;
+	if (!rec) {
+		rec = ftrace_profile_alloc(ip, alloc_safe);
+		if (!rec)
+			goto out;
+	}
 
 	rec->counter++;
  out:
@@ -515,11 +547,6 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 	char buf[64];
 	int ret;
 
-	if (!ftrace_profile_hash) {
-		pr_info("Can not enable hash due to earlier problems\n");
-		return -ENODEV;
-	}
-
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
 
@@ -537,7 +564,12 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 	mutex_lock(&ftrace_profile_lock);
 	if (ftrace_profile_enabled ^ val) {
 		if (val) {
-			ftrace_profile_reset();
+			ret = ftrace_profile_init();
+			if (ret < 0) {
+				cnt = ret;
+				goto out;
+			}
+
 			register_ftrace_function(&ftrace_profile_ops);
 			ftrace_profile_enabled = 1;
 		} else {
@@ -545,6 +577,7 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 			unregister_ftrace_function(&ftrace_profile_ops);
 		}
 	}
+ out:
 	mutex_unlock(&ftrace_profile_lock);
 
 	filp->f_pos += cnt;
@@ -552,6 +585,17 @@ ftrace_profile_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static ssize_t
+ftrace_profile_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int r;
+
+	r = sprintf(buf, "%u\n", ftrace_profile_enabled);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
 static const struct file_operations ftrace_profile_fops = {
 	.open		= tracing_open_generic,
 	.read		= ftrace_profile_read,
@@ -577,39 +621,80 @@ static void ftrace_profile_debugfs(struct dentry *d_tracer)
 			   "'function_profile_enabled' entry\n");
 }
 
-static void ftrace_add_profile(struct dyn_ftrace *rec)
-{
-	unsigned long key;
-
-	if (!ftrace_profile_hash)
-		return;
-
-	key = hash_long(rec->ip, ftrace_profile_bits);
-	hlist_add_head_rcu(&rec->node, &ftrace_profile_hash[key]);
-}
-
-static void ftrace_profile_release(struct dyn_ftrace *rec)
-{
-	mutex_lock(&ftrace_profile_lock);
-	hlist_del(&rec->node);
-	mutex_unlock(&ftrace_profile_lock);
-}
-
 #else /* CONFIG_FUNCTION_PROFILER */
-static void ftrace_profile_init(int nr_funcs)
-{
-}
-static void ftrace_add_profile(struct dyn_ftrace *rec)
-{
-}
 static void ftrace_profile_debugfs(struct dentry *d_tracer)
 {
 }
-static void ftrace_profile_release(struct dyn_ftrace *rec)
-{
-}
 #endif /* CONFIG_FUNCTION_PROFILER */
 
+/* set when tracing only a pid */
+struct pid *ftrace_pid_trace;
+static struct pid * const ftrace_swapper_pid = &init_struct_pid;
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+#ifndef CONFIG_FTRACE_MCOUNT_RECORD
+# error Dynamic ftrace depends on MCOUNT_RECORD
+#endif
+
+static struct hlist_head ftrace_func_hash[FTRACE_FUNC_HASHSIZE] __read_mostly;
+
+struct ftrace_func_probe {
+	struct hlist_node	node;
+	struct ftrace_probe_ops	*ops;
+	unsigned long		flags;
+	unsigned long		ip;
+	void			*data;
+	struct rcu_head		rcu;
+};
+
+enum {
+	FTRACE_ENABLE_CALLS		= (1 << 0),
+	FTRACE_DISABLE_CALLS		= (1 << 1),
+	FTRACE_UPDATE_TRACE_FUNC	= (1 << 2),
+	FTRACE_ENABLE_MCOUNT		= (1 << 3),
+	FTRACE_DISABLE_MCOUNT		= (1 << 4),
+	FTRACE_START_FUNC_RET		= (1 << 5),
+	FTRACE_STOP_FUNC_RET		= (1 << 6),
+};
+
+static int ftrace_filtered;
+
+static struct dyn_ftrace *ftrace_new_addrs;
+
+static DEFINE_MUTEX(ftrace_regex_lock);
+
+struct ftrace_page {
+	struct ftrace_page	*next;
+	int			index;
+	struct dyn_ftrace	records[];
+};
+
+#define ENTRIES_PER_PAGE \
+  ((PAGE_SIZE - sizeof(struct ftrace_page)) / sizeof(struct dyn_ftrace))
+
+/* estimate from running different kernels */
+#define NR_TO_INIT		10000
+
+static struct ftrace_page	*ftrace_pages_start;
+static struct ftrace_page	*ftrace_pages;
+
+static struct dyn_ftrace *ftrace_free_records;
+
+/*
+ * This is a double for. Do not use 'break' to break out of the loop,
+ * you must use a goto.
+ */
+#define do_for_each_ftrace_rec(pg, rec)					\
+	for (pg = ftrace_pages_start; pg; pg = pg->next) {		\
+		int _____i;						\
+		for (_____i = 0; _____i < pg->index; _____i++) {	\
+			rec = &pg->records[_____i];
+
+#define while_for_each_ftrace_rec()		\
+		}				\
+	}
+
 #ifdef CONFIG_KPROBES
 
 static int frozen_record_count;
@@ -660,10 +745,8 @@ void ftrace_release(void *start, unsigned long size)
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 		if ((rec->ip >= s) && (rec->ip < e) &&
-		    !(rec->flags & FTRACE_FL_FREE)) {
+		    !(rec->flags & FTRACE_FL_FREE))
 			ftrace_free_rec(rec);
-			ftrace_profile_release(rec);
-		}
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
 }
@@ -717,8 +800,6 @@ ftrace_record_ip(unsigned long ip)
 	rec->newlist = ftrace_new_addrs;
 	ftrace_new_addrs = rec;
 
-	ftrace_add_profile(rec);
-
 	return rec;
 }
 
@@ -2462,8 +2543,6 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 			   "'set_graph_function' entry\n");
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-	ftrace_profile_debugfs(d_tracer);
-
 	return 0;
 }
 
@@ -2532,8 +2611,6 @@ void __init ftrace_init(void)
 	if (ret)
 		goto failed;
 
-	ftrace_profile_init(count);
-
 	last_ftrace_enabled = ftrace_enabled = 1;
 
 	ret = ftrace_convert_nops(NULL,
@@ -2734,6 +2811,9 @@ static __init int ftrace_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'set_ftrace_pid' entry\n");
+
+	ftrace_profile_debugfs(d_tracer);
+
 	return 0;
 }
 fs_initcall(ftrace_init_debugfs);
-- 
1.6.2

-- 
