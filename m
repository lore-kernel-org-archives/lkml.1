Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYJWNlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYJWNlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYJWNhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52156 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYJWNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:26 -0400
Message-Id: <20081023133724.645822090@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:33:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 11/12 v3] ftrace: remove ftrace hash
Content-Disposition: inline; filename=ftrace-remove-hash.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace hash was used by the ftrace_daemon code. The record ip function
would place the calling address (ip) into the hash. The daemon would later
read the hash and modify that code.

The hash complicates the code. This patch removes it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    8 -
 kernel/trace/ftrace.c  |  247 +++++++------------------------------------------
 kernel/trace/trace.c   |    3 
 3 files changed, 40 insertions(+), 218 deletions(-)

Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-10-22 16:08:24.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-10-22 16:09:05.000000000 -0400
@@ -44,8 +44,6 @@ static inline void ftrace_kill(void) { }
 #endif /* CONFIG_FTRACE */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-# define FTRACE_HASHBITS	10
-# define FTRACE_HASHSIZE	(1<<FTRACE_HASHBITS)
 
 enum {
 	FTRACE_FL_FREE		= (1 << 0),
@@ -58,9 +56,9 @@ enum {
 };
 
 struct dyn_ftrace {
-	struct hlist_node node;
-	unsigned long	  ip; /* address of mcount call-site */
-	unsigned long	  flags;
+	struct list_head	list;
+	unsigned long		ip; /* address of mcount call-site */
+	unsigned long		flags;
 };
 
 int ftrace_force_update(void);
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 16:07:55.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 16:09:05.000000000 -0400
@@ -25,7 +25,6 @@
 #include <linux/ftrace.h>
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
-#include <linux/hash.h>
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
@@ -189,9 +188,7 @@ static int ftrace_filtered;
 static int tracing_on;
 static int frozen_record_count;
 
-static struct hlist_head ftrace_hash[FTRACE_HASHSIZE];
-
-static DEFINE_PER_CPU(int, ftrace_shutdown_disable_cpu);
+static LIST_HEAD(ftrace_new_addrs);
 
 static DEFINE_MUTEX(ftrace_regex_lock);
 
@@ -210,8 +207,6 @@ struct ftrace_page {
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
 
-static int ftrace_record_suspend;
-
 static struct dyn_ftrace *ftrace_free_records;
 
 
@@ -242,72 +237,6 @@ static inline int record_frozen(struct d
 # define record_frozen(rec)			({ 0; })
 #endif /* CONFIG_KPROBES */
 
-int skip_trace(unsigned long ip)
-{
-	unsigned long fl;
-	struct dyn_ftrace *rec;
-	struct hlist_node *t;
-	struct hlist_head *head;
-
-	if (frozen_record_count == 0)
-		return 0;
-
-	head = &ftrace_hash[hash_long(ip, FTRACE_HASHBITS)];
-	hlist_for_each_entry_rcu(rec, t, head, node) {
-		if (rec->ip == ip) {
-			if (record_frozen(rec)) {
-				if (rec->flags & FTRACE_FL_FAILED)
-					return 1;
-
-				if (!(rec->flags & FTRACE_FL_CONVERTED))
-					return 1;
-
-				if (!tracing_on || !ftrace_enabled)
-					return 1;
-
-				if (ftrace_filtered) {
-					fl = rec->flags & (FTRACE_FL_FILTER |
-							   FTRACE_FL_NOTRACE);
-					if (!fl || (fl & FTRACE_FL_NOTRACE))
-						return 1;
-				}
-			}
-			break;
-		}
-	}
-
-	return 0;
-}
-
-static inline int
-ftrace_ip_in_hash(unsigned long ip, unsigned long key)
-{
-	struct dyn_ftrace *p;
-	struct hlist_node *t;
-	int found = 0;
-
-	hlist_for_each_entry_rcu(p, t, &ftrace_hash[key], node) {
-		if (p->ip == ip) {
-			found = 1;
-			break;
-		}
-	}
-
-	return found;
-}
-
-static inline void
-ftrace_add_hash(struct dyn_ftrace *node, unsigned long key)
-{
-	hlist_add_head_rcu(&node->node, &ftrace_hash[key]);
-}
-
-/* called from kstop_machine */
-static inline void ftrace_del_hash(struct dyn_ftrace *node)
-{
-	hlist_del(&node->node);
-}
-
 static void ftrace_free_rec(struct dyn_ftrace *rec)
 {
 	rec->ip = (unsigned long)ftrace_free_records;
@@ -361,69 +290,36 @@ static struct dyn_ftrace *ftrace_alloc_d
 	}
 
 	if (ftrace_pages->index == ENTRIES_PER_PAGE) {
-		if (!ftrace_pages->next)
-			return NULL;
+		if (!ftrace_pages->next) {
+			/* allocate another page */
+			ftrace_pages->next =
+				(void *)get_zeroed_page(GFP_KERNEL);
+			if (!ftrace_pages->next)
+				return NULL;
+		}
 		ftrace_pages = ftrace_pages->next;
 	}
 
 	return &ftrace_pages->records[ftrace_pages->index++];
 }
 
-static void
+static struct dyn_ftrace *
 ftrace_record_ip(unsigned long ip)
 {
-	struct dyn_ftrace *node;
-	unsigned long key;
-	int resched;
-	int cpu;
+	struct dyn_ftrace *rec;
 
 	if (!ftrace_enabled || ftrace_disabled)
-		return;
-
-	resched = need_resched();
-	preempt_disable_notrace();
-
-	/*
-	 * We simply need to protect against recursion.
-	 * Use the the raw version of smp_processor_id and not
-	 * __get_cpu_var which can call debug hooks that can
-	 * cause a recursive crash here.
-	 */
-	cpu = raw_smp_processor_id();
-	per_cpu(ftrace_shutdown_disable_cpu, cpu)++;
-	if (per_cpu(ftrace_shutdown_disable_cpu, cpu) != 1)
-		goto out;
-
-	if (unlikely(ftrace_record_suspend))
-		goto out;
-
-	key = hash_long(ip, FTRACE_HASHBITS);
-
-	FTRACE_WARN_ON_ONCE(key >= FTRACE_HASHSIZE);
-
-	if (ftrace_ip_in_hash(ip, key))
-		goto out;
+		return NULL;
 
-	/* This ip may have hit the hash before the lock */
-	if (ftrace_ip_in_hash(ip, key))
-		goto out;
-
-	node = ftrace_alloc_dyn_node(ip);
-	if (!node)
-		goto out;
-
-	node->ip = ip;
+	rec = ftrace_alloc_dyn_node(ip);
+	if (!rec)
+		return NULL;
 
-	ftrace_add_hash(node, key);
+	rec->ip = ip;
 
- out:
-	per_cpu(ftrace_shutdown_disable_cpu, cpu)--;
+	list_add(&rec->list, &ftrace_new_addrs);
 
-	/* prevent recursion with scheduler */
-	if (resched)
-		preempt_enable_no_resched_notrace();
-	else
-		preempt_enable_notrace();
+	return rec;
 }
 
 #define FTRACE_ADDR ((long)(ftrace_caller))
@@ -542,7 +438,6 @@ static void ftrace_replace_code(int enab
 				rec->flags |= FTRACE_FL_FAILED;
 				if ((system_state == SYSTEM_BOOTING) ||
 				    !core_kernel_text(rec->ip)) {
-					ftrace_del_hash(rec);
 					ftrace_free_rec(rec);
 				}
 			}
@@ -550,15 +445,6 @@ static void ftrace_replace_code(int enab
 	}
 }
 
-static void ftrace_shutdown_replenish(void)
-{
-	if (ftrace_pages->next)
-		return;
-
-	/* allocate another page */
-	ftrace_pages->next = (void *)get_zeroed_page(GFP_KERNEL);
-}
-
 static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
@@ -615,18 +501,11 @@ ftrace_code_disable(struct dyn_ftrace *r
 	return 1;
 }
 
-static int ftrace_update_code(void *ignore);
-
 static int __ftrace_modify_code(void *data)
 {
 	int *command = data;
 
 	if (*command & FTRACE_ENABLE_CALLS) {
-		/*
-		 * Update any recorded ips now that we have the
-		 * machine stopped
-		 */
-		ftrace_update_code(NULL);
 		ftrace_replace_code(1);
 		tracing_on = 1;
 	} else if (*command & FTRACE_DISABLE_CALLS) {
@@ -737,84 +616,34 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int ftrace_update_code(void *ignore)
+static int ftrace_update_code(void)
 {
-	int i, save_ftrace_enabled;
+	struct dyn_ftrace *p, *t;
 	cycle_t start, stop;
-	struct dyn_ftrace *p;
-	struct hlist_node *t, *n;
-	struct hlist_head *head, temp_list;
-
-	/* Don't be recording funcs now */
-	ftrace_record_suspend++;
-	save_ftrace_enabled = ftrace_enabled;
-	ftrace_enabled = 0;
 
 	start = ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt = 0;
 
-	/* No locks needed, the machine is stopped! */
-	for (i = 0; i < FTRACE_HASHSIZE; i++) {
-		INIT_HLIST_HEAD(&temp_list);
-		head = &ftrace_hash[i];
-
-		/* all CPUS are stopped, we are safe to modify code */
-		hlist_for_each_entry_safe(p, t, n, head, node) {
-			/* Skip over failed records which have not been
-			 * freed. */
-			if (p->flags & FTRACE_FL_FAILED)
-				continue;
-
-			/* Unconverted records are always at the head of the
-			 * hash bucket. Once we encounter a converted record,
-			 * simply skip over to the next bucket. Saves ftraced
-			 * some processor cycles (ftrace does its bid for
-			 * global warming :-p ). */
-			if (p->flags & (FTRACE_FL_CONVERTED))
-				break;
-
-			/* Ignore updates to this record's mcount site.
-			 * Reintroduce this record at the head of this
-			 * bucket to attempt to "convert" it again if
-			 * the kprobe on it is unregistered before the
-			 * next run. */
-			if (get_kprobe((void *)p->ip)) {
-				ftrace_del_hash(p);
-				INIT_HLIST_NODE(&p->node);
-				hlist_add_head(&p->node, &temp_list);
-				freeze_record(p);
-				continue;
-			} else {
-				unfreeze_record(p);
-			}
-
-			/* convert record (i.e, patch mcount-call with NOP) */
-			if (ftrace_code_disable(p)) {
-				p->flags |= FTRACE_FL_CONVERTED;
-				ftrace_update_cnt++;
-			} else {
-				if ((system_state == SYSTEM_BOOTING) ||
-				    !core_kernel_text(p->ip)) {
-					ftrace_del_hash(p);
-					ftrace_free_rec(p);
-				}
-			}
-		}
+	list_for_each_entry_safe(p, t, &ftrace_new_addrs, list) {
 
-		hlist_for_each_entry_safe(p, t, n, &temp_list, node) {
-			hlist_del(&p->node);
-			INIT_HLIST_NODE(&p->node);
-			hlist_add_head(&p->node, head);
-		}
+		/* If something went wrong, bail without enabling anything */
+		if (unlikely(ftrace_disabled))
+			return -1;
+
+		list_del_init(&p->list);
+
+		/* convert record (i.e, patch mcount-call with NOP) */
+		if (ftrace_code_disable(p)) {
+			p->flags |= FTRACE_FL_CONVERTED;
+			ftrace_update_cnt++;
+		} else
+			ftrace_free_rec(p);
 	}
 
 	stop = ftrace_now(raw_smp_processor_id());
 	ftrace_update_time = stop - start;
 	ftrace_update_tot_cnt += ftrace_update_cnt;
 
-	ftrace_enabled = save_ftrace_enabled;
-	ftrace_record_suspend--;
-
 	return 0;
 }
 
@@ -846,7 +675,7 @@ static int __init ftrace_dyn_table_alloc
 	pg = ftrace_pages = ftrace_pages_start;
 
 	cnt = num_to_init / ENTRIES_PER_PAGE;
-	pr_info("ftrace: allocating %ld hash entries in %d pages\n",
+	pr_info("ftrace: allocating %ld entries in %d pages\n",
 		num_to_init, cnt);
 
 	for (i = 0; i < cnt; i++) {
@@ -1450,20 +1279,18 @@ static int ftrace_convert_nops(unsigned 
 	unsigned long addr;
 	unsigned long flags;
 
+	mutex_lock(&ftrace_start_lock);
 	p = start;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
-		/* should not be called from interrupt context */
-		spin_lock(&ftrace_lock);
 		ftrace_record_ip(addr);
-		spin_unlock(&ftrace_lock);
-		ftrace_shutdown_replenish();
 	}
 
-	/* p is ignored */
+	/* disable interrupts to prevent kstop machine */
 	local_irq_save(flags);
-	ftrace_update_code(p);
+	ftrace_update_code();
 	local_irq_restore(flags);
+	mutex_unlock(&ftrace_start_lock);
 
 	return 0;
 }
Index: linux-compile.git/kernel/trace/trace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace.c	2008-10-22 16:07:27.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.c	2008-10-22 16:09:05.000000000 -0400
@@ -865,9 +865,6 @@ function_trace_call(unsigned long ip, un
 	if (unlikely(!ftrace_function_enabled))
 		return;
 
-	if (skip_trace(ip))
-		return;
-
 	pc = preempt_count();
 	resched = need_resched();
 	preempt_disable_notrace();

-- 
