Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZCYEJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZCYEJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZCYEIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:08:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZCYEIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:08:36 -0400
Message-Id: <20090325040832.912184194@goodmis.org>
References: <20090325035646.662994901@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 23:56:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5][RFC] tracing: make the function profiler per cpu
Content-Disposition: inline; filename=0004-tracing-make-the-function-profiler-per-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: speed enhancement

By making the function profiler record in per cpu data we not only
get better readings, avoid races, we also do not have to take any
locks.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |  201 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 131 insertions(+), 70 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a9ccd71..ed1fc50 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -257,28 +257,28 @@ struct ftrace_profile_page {
 	struct ftrace_profile		records[];
 };
 
+struct ftrace_profile_stat {
+	atomic_t			disabled;
+	struct hlist_head		*hash;
+	struct ftrace_profile_page	*pages;
+	struct ftrace_profile_page	*start;
+	struct tracer_stat		stat;
+};
+
 #define PROFILE_RECORDS_SIZE						\
 	(PAGE_SIZE - offsetof(struct ftrace_profile_page, records))
 
 #define PROFILES_PER_PAGE					\
 	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
 
-/* TODO: make these percpu, to prevent cache line bouncing */
-static struct ftrace_profile_page *profile_pages_start;
-static struct ftrace_profile_page *profile_pages;
-
-static struct hlist_head *ftrace_profile_hash;
 static int ftrace_profile_bits;
 static int ftrace_profile_enabled;
 static DEFINE_MUTEX(ftrace_profile_lock);
 
-static DEFINE_PER_CPU(atomic_t, ftrace_profile_disable);
+static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
 
 #define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
 
-static raw_spinlock_t ftrace_profile_rec_lock =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-
 static void *
 function_stat_next(void *v, int idx)
 {
@@ -303,7 +303,13 @@ function_stat_next(void *v, int idx)
 
 static void *function_stat_start(struct tracer_stat *trace)
 {
-	return function_stat_next(&profile_pages_start->records[0], 0);
+	struct ftrace_profile_stat *stat =
+		container_of(trace, struct ftrace_profile_stat, stat);
+
+	if (!stat || !stat->start)
+		return NULL;
+
+	return function_stat_next(&stat->start->records[0], 0);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -374,20 +380,11 @@ static int function_stat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct tracer_stat function_stats = {
-	.name = "functions",
-	.stat_start = function_stat_start,
-	.stat_next = function_stat_next,
-	.stat_cmp = function_stat_cmp,
-	.stat_headers = function_stat_headers,
-	.stat_show = function_stat_show
-};
-
-static void ftrace_profile_reset(void)
+static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
 {
 	struct ftrace_profile_page *pg;
 
-	pg = profile_pages = profile_pages_start;
+	pg = stat->pages = stat->start;
 
 	while (pg) {
 		memset(pg->records, 0, PROFILE_RECORDS_SIZE);
@@ -395,24 +392,24 @@ static void ftrace_profile_reset(void)
 		pg = pg->next;
 	}
 
-	memset(ftrace_profile_hash, 0,
+	memset(stat->hash, 0,
 	       FTRACE_PROFILE_HASH_SIZE * sizeof(struct hlist_head));
 }
 
-int ftrace_profile_pages_init(void)
+int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 {
 	struct ftrace_profile_page *pg;
 	int i;
 
 	/* If we already allocated, do nothing */
-	if (profile_pages)
+	if (stat->pages)
 		return 0;
 
-	profile_pages = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!profile_pages)
+	stat->pages = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!stat->pages)
 		return -ENOMEM;
 
-	pg = profile_pages_start = profile_pages;
+	pg = stat->start = stat->pages;
 
 	/* allocate 10 more pages to start */
 	for (i = 0; i < 10; i++) {
@@ -430,13 +427,16 @@ int ftrace_profile_pages_init(void)
 	return 0;
 }
 
-static int ftrace_profile_init(void)
+static int ftrace_profile_init_cpu(int cpu)
 {
+	struct ftrace_profile_stat *stat;
 	int size;
 
-	if (ftrace_profile_hash) {
+	stat = &per_cpu(ftrace_profile_stats, cpu);
+
+	if (stat->hash) {
 		/* If the profile is already created, simply reset it */
-		ftrace_profile_reset();
+		ftrace_profile_reset(stat);
 		return 0;
 	}
 
@@ -446,29 +446,45 @@ static int ftrace_profile_init(void)
 	 */
 	size = FTRACE_PROFILE_HASH_SIZE;
 
-	ftrace_profile_hash =
-		kzalloc(sizeof(struct hlist_head) * size, GFP_KERNEL);
+	stat->hash = kzalloc(sizeof(struct hlist_head) * size, GFP_KERNEL);
 
-	if (!ftrace_profile_hash)
+	if (!stat->hash)
 		return -ENOMEM;
 
-	size--;
+	if (!ftrace_profile_bits) {
+		size--;
 
-	for (; size; size >>= 1)
-		ftrace_profile_bits++;
+		for (; size; size >>= 1)
+			ftrace_profile_bits++;
+	}
 
 	/* Preallocate a few pages */
-	if (ftrace_profile_pages_init() < 0) {
-		kfree(ftrace_profile_hash);
-		ftrace_profile_hash = NULL;
+	if (ftrace_profile_pages_init(stat) < 0) {
+		kfree(stat->hash);
+		stat->hash = NULL;
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
+static int ftrace_profile_init(void)
+{
+	int cpu;
+	int ret = 0;
+
+	for_each_online_cpu(cpu) {
+		ret = ftrace_profile_init_cpu(cpu);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 /* interrupts must be disabled */
-static struct ftrace_profile *ftrace_find_profiled_func(unsigned long ip)
+static struct ftrace_profile *
+ftrace_find_profiled_func(struct ftrace_profile_stat *stat, unsigned long ip)
 {
 	struct ftrace_profile *rec;
 	struct hlist_head *hhd;
@@ -476,7 +492,7 @@ static struct ftrace_profile *ftrace_find_profiled_func(unsigned long ip)
 	unsigned long key;
 
 	key = hash_long(ip, ftrace_profile_bits);
-	hhd = &ftrace_profile_hash[key];
+	hhd = &stat->hash[key];
 
 	if (hlist_empty(hhd))
 		return NULL;
@@ -489,52 +505,50 @@ static struct ftrace_profile *ftrace_find_profiled_func(unsigned long ip)
 	return NULL;
 }
 
-static void ftrace_add_profile(struct ftrace_profile *rec)
+static void ftrace_add_profile(struct ftrace_profile_stat *stat,
+			       struct ftrace_profile *rec)
 {
 	unsigned long key;
 
 	key = hash_long(rec->ip, ftrace_profile_bits);
-	hlist_add_head_rcu(&rec->node, &ftrace_profile_hash[key]);
+	hlist_add_head_rcu(&rec->node, &stat->hash[key]);
 }
 
 /* Interrupts must be disabled calling this */
 static struct ftrace_profile *
-ftrace_profile_alloc(unsigned long ip, bool alloc_safe)
+ftrace_profile_alloc(struct ftrace_profile_stat *stat,
+		     unsigned long ip, bool alloc_safe)
 {
 	struct ftrace_profile *rec = NULL;
 
 	/* prevent recursion */
-	if (atomic_inc_return(&__get_cpu_var(ftrace_profile_disable)) != 1)
+	if (atomic_inc_return(&stat->disabled) != 1)
 		goto out;
 
-	__raw_spin_lock(&ftrace_profile_rec_lock);
-
 	/* Try to always keep another page available */
-	if (!profile_pages->next && alloc_safe)
-		profile_pages->next = (void *)get_zeroed_page(GFP_ATOMIC);
+	if (!stat->pages->next && alloc_safe)
+		stat->pages->next = (void *)get_zeroed_page(GFP_ATOMIC);
 
 	/*
 	 * Try to find the function again since another
 	 * task on another CPU could have added it
 	 */
-	rec = ftrace_find_profiled_func(ip);
+	rec = ftrace_find_profiled_func(stat, ip);
 	if (rec)
-		goto out_unlock;
+		goto out;
 
-	if (profile_pages->index == PROFILES_PER_PAGE) {
-		if (!profile_pages->next)
-			goto out_unlock;
-		profile_pages = profile_pages->next;
+	if (stat->pages->index == PROFILES_PER_PAGE) {
+		if (!stat->pages->next)
+			goto out;
+		stat->pages = stat->pages->next;
 	}
 
-	rec = &profile_pages->records[profile_pages->index++];
+	rec = &stat->pages->records[stat->pages->index++];
 	rec->ip = ip;
-	ftrace_add_profile(rec);
+	ftrace_add_profile(stat, rec);
 
- out_unlock:
-	__raw_spin_unlock(&ftrace_profile_rec_lock);
  out:
-	atomic_dec(&__get_cpu_var(ftrace_profile_disable));
+	atomic_dec(&stat->disabled);
 
 	return rec;
 }
@@ -552,6 +566,7 @@ static bool ftrace_safe_to_allocate(void)
 static void
 function_profile_call(unsigned long ip, unsigned long parent_ip)
 {
+	struct ftrace_profile_stat *stat;
 	struct ftrace_profile *rec;
 	unsigned long flags;
 	bool alloc_safe;
@@ -562,9 +577,14 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 	alloc_safe = ftrace_safe_to_allocate();
 
 	local_irq_save(flags);
-	rec = ftrace_find_profiled_func(ip);
+
+	stat = &__get_cpu_var(ftrace_profile_stats);
+	if (!stat->hash)
+		goto out;
+
+	rec = ftrace_find_profiled_func(stat, ip);
 	if (!rec) {
-		rec = ftrace_profile_alloc(ip, alloc_safe);
+		rec = ftrace_profile_alloc(stat, ip, alloc_safe);
 		if (!rec)
 			goto out;
 	}
@@ -583,13 +603,19 @@ static int profile_graph_entry(struct ftrace_graph_ent *trace)
 
 static void profile_graph_return(struct ftrace_graph_ret *trace)
 {
-	unsigned long flags;
+	struct ftrace_profile_stat *stat;
 	struct ftrace_profile *rec;
+	unsigned long flags;
 
 	local_irq_save(flags);
-	rec = ftrace_find_profiled_func(trace->func);
+	stat = &__get_cpu_var(ftrace_profile_stats);
+	if (!stat->hash)
+		goto out;
+
+	rec = ftrace_find_profiled_func(stat, trace->func);
 	if (rec)
 		rec->time += trace->rettime - trace->calltime;
+ out:
 	local_irq_restore(flags);
 }
 
@@ -687,16 +713,51 @@ static const struct file_operations ftrace_profile_fops = {
 	.write		= ftrace_profile_write,
 };
 
+/* used to initialize the real stat files */
+static struct tracer_stat function_stats __initdata = {
+	.name = "functions",
+	.stat_start = function_stat_start,
+	.stat_next = function_stat_next,
+	.stat_cmp = function_stat_cmp,
+	.stat_headers = function_stat_headers,
+	.stat_show = function_stat_show
+};
+
 static void ftrace_profile_debugfs(struct dentry *d_tracer)
 {
+	struct ftrace_profile_stat *stat;
 	struct dentry *entry;
+	char *name;
 	int ret;
+	int cpu;
 
-	ret = register_stat_tracer(&function_stats);
-	if (ret) {
-		pr_warning("Warning: could not register "
-			   "function stats\n");
-		return;
+	for_each_possible_cpu(cpu) {
+		stat = &per_cpu(ftrace_profile_stats, cpu);
+
+		/* allocate enough for function name + cpu number */
+		name = kmalloc(32, GFP_KERNEL);
+		if (!name) {
+			/*
+			 * The files created are permanent, if something happens
+			 * we still do not free memory.
+			 */
+			kfree(stat);
+			WARN(1,
+			     "Could not allocate stat file for cpu %d\n",
+			     cpu);
+			return;
+		}
+		stat->stat = function_stats;
+		snprintf(name, 32, "function%d", cpu);
+		stat->stat.name = name;
+		ret = register_stat_tracer(&stat->stat);
+		if (ret) {
+			WARN(1,
+			     "Could not register function stat for cpu %d\n",
+			     cpu);
+			kfree(name);
+			return;
+		}
 	}
 
 	entry = debugfs_create_file("function_profile_enabled", 0644,
-- 
1.6.2

-- 
