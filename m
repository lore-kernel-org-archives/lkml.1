Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbZCZBIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbZCZBIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZCZBIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:08:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZCZBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:08:15 -0400
Message-Id: <20090326010811.319344597@goodmis.org>
References: <20090326010737.611522983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 21:07:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] tracing: remove on the fly allocator from function profiler
Content-Disposition: inline; filename=0001-tracing-remove-on-the-fly-allocator-from-function-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: safer code

The on the fly allocator for the function profiler was to save
memory. But at the expense of stability. Although it survived several
tests, allocating from the function tracer is just too risky, just
to save space.

This patch removes the allocator and simply allocates enough entries
at start up.

Each function gets a profiling structure of 40 bytes. With an average
of 20K functions, and this is for each CPU, we have 800K per online
CPU. This is not too bad, at least for non-embedded.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   76 +++++++++++++++++++++++++++---------------------
 1 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a141d84..4d90c91 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -401,6 +401,8 @@ static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
 int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 {
 	struct ftrace_profile_page *pg;
+	int functions;
+	int pages;
 	int i;
 
 	/* If we already allocated, do nothing */
@@ -411,22 +413,46 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 	if (!stat->pages)
 		return -ENOMEM;
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	functions = ftrace_update_tot_cnt;
+#else
+	/*
+	 * We do not know the number of functions that exist because
+	 * dynamic tracing is what counts them. With past experience
+	 * we have around 20K functions. That should be more than enough.
+	 * It is highly unlikely we will execute every function in
+	 * the kernel.
+	 */
+	functions = 20000;
+#endif
+
 	pg = stat->start = stat->pages;
 
-	/* allocate 10 more pages to start */
-	for (i = 0; i < 10; i++) {
+	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
+
+	for (i = 0; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
-		/*
-		 * We only care about allocating profile_pages, if
-		 * we failed to allocate here, hopefully we will allocate
-		 * later.
-		 */
 		if (!pg->next)
-			break;
+			goto out_free;
 		pg = pg->next;
 	}
 
 	return 0;
+
+ out_free:
+	pg = stat->start;
+	while (pg) {
+		unsigned long tmp = (unsigned long)pg;
+
+		pg = pg->next;
+		free_page(tmp);
+	}
+
+	free_page((unsigned long)stat->pages);
+	stat->pages = NULL;
+	stat->start = NULL;
+
+	return -ENOMEM;
 }
 
 static int ftrace_profile_init_cpu(int cpu)
@@ -460,7 +486,7 @@ static int ftrace_profile_init_cpu(int cpu)
 			ftrace_profile_bits++;
 	}
 
-	/* Preallocate a few pages */
+	/* Preallocate the function profiling pages */
 	if (ftrace_profile_pages_init(stat) < 0) {
 		kfree(stat->hash);
 		stat->hash = NULL;
@@ -516,24 +542,21 @@ static void ftrace_add_profile(struct ftrace_profile_stat *stat,
 	hlist_add_head_rcu(&rec->node, &stat->hash[key]);
 }
 
-/* Interrupts must be disabled calling this */
+/*
+ * The memory is already allocated, this simply finds a new record to use.
+ */
 static struct ftrace_profile *
-ftrace_profile_alloc(struct ftrace_profile_stat *stat,
-		     unsigned long ip, bool alloc_safe)
+ftrace_profile_alloc(struct ftrace_profile_stat *stat, unsigned long ip)
 {
 	struct ftrace_profile *rec = NULL;
 
-	/* prevent recursion */
+	/* prevent recursion (from NMIs) */
 	if (atomic_inc_return(&stat->disabled) != 1)
 		goto out;
 
-	/* Try to always keep another page available */
-	if (!stat->pages->next && alloc_safe)
-		stat->pages->next = (void *)get_zeroed_page(GFP_ATOMIC);
-
 	/*
-	 * Try to find the function again since another
-	 * task on another CPU could have added it
+	 * Try to find the function again since an NMI
+	 * could have added it
 	 */
 	rec = ftrace_find_profiled_func(stat, ip);
 	if (rec)
@@ -555,29 +578,16 @@ ftrace_profile_alloc(struct ftrace_profile_stat *stat,
 	return rec;
 }
 
-/*
- * If we are not in an interrupt, or softirq and
- * and interrupts are disabled and preemption is not enabled
- * (not in a spinlock) then it should be safe to allocate memory.
- */
-static bool ftrace_safe_to_allocate(void)
-{
-	return !in_interrupt() && irqs_disabled() && !preempt_count();
-}
-
 static void
 function_profile_call(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_profile_stat *stat;
 	struct ftrace_profile *rec;
 	unsigned long flags;
-	bool alloc_safe;
 
 	if (!ftrace_profile_enabled)
 		return;
 
-	alloc_safe = ftrace_safe_to_allocate();
-
 	local_irq_save(flags);
 
 	stat = &__get_cpu_var(ftrace_profile_stats);
@@ -586,7 +596,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
 
 	rec = ftrace_find_profiled_func(stat, ip);
 	if (!rec) {
-		rec = ftrace_profile_alloc(stat, ip, alloc_safe);
+		rec = ftrace_profile_alloc(stat, ip);
 		if (!rec)
 			goto out;
 	}
-- 
1.6.2

-- 
