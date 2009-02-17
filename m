Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZBQFms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZBQFms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZBQFmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:42:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZBQFmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:42:39 -0500
Message-Id: <20090217051406.599319629@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/15] ftrace: convert ftrace_lock from a spinlock to mutex
Content-Disposition: inline; filename=0008-ftrace-convert-ftrace_lock-from-a-spinlock-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The older versions of ftrace required doing the ftrace list
search under atomic context. Now all the calls are in non-atomic
context. There is no reason to keep the ftrace_lock as a spinlock.

This patch converts it to a mutex.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   51 ++++++++++++++++++------------------------------
 1 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 45a44c4..4771732 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -61,7 +61,7 @@ int function_trace_stop;
  */
 static int ftrace_disabled __read_mostly;
 
-static DEFINE_SPINLOCK(ftrace_lock);
+static DEFINE_MUTEX(ftrace_lock);
 static DEFINE_MUTEX(ftrace_sysctl_lock);
 static DEFINE_MUTEX(ftrace_start_lock);
 
@@ -134,8 +134,7 @@ static void ftrace_test_stop_func(unsigned long ip, unsigned long parent_ip)
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
+	mutex_lock(&ftrace_lock);
 
 	ops->next = ftrace_list;
 	/*
@@ -172,7 +171,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 #endif
 	}
 
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 
 	return 0;
 }
@@ -182,8 +181,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	struct ftrace_ops **p;
 	int ret = 0;
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
+	mutex_lock(&ftrace_lock);
 
 	/*
 	 * If we are removing the last function, then simply point
@@ -224,7 +222,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	}
 
  out:
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 
 	return ret;
 }
@@ -233,8 +231,7 @@ static void ftrace_update_pid_func(void)
 {
 	ftrace_func_t func;
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
+	mutex_lock(&ftrace_lock);
 
 	if (ftrace_trace_function == ftrace_stub)
 		goto out;
@@ -256,7 +253,7 @@ static void ftrace_update_pid_func(void)
 #endif
 
  out:
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -358,15 +355,12 @@ void ftrace_release(void *start, unsigned long size)
 	if (ftrace_disabled || !start)
 		return;
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
-
+	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 		if ((rec->ip >= s) && (rec->ip < e))
 			ftrace_free_rec(rec);
 	} while_for_each_ftrace_rec();
-
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 }
 
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
@@ -803,8 +797,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	if (iter->flags & FTRACE_ITER_PRINTALL)
 		return NULL;
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
+	mutex_lock(&ftrace_lock);
  retry:
 	if (iter->idx >= iter->pg->index) {
 		if (iter->pg->next) {
@@ -833,7 +826,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 			goto retry;
 		}
 	}
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 
 	return rec;
 }
@@ -962,8 +955,7 @@ static void ftrace_filter_reset(int enable)
 	struct dyn_ftrace *rec;
 	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
+	mutex_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 0;
 	do_for_each_ftrace_rec(pg, rec) {
@@ -971,8 +963,7 @@ static void ftrace_filter_reset(int enable)
 			continue;
 		rec->flags &= ~type;
 	} while_for_each_ftrace_rec();
-
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 }
 
 static int
@@ -1151,8 +1142,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 
 	search_len = strlen(search);
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
+	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (rec->flags & FTRACE_FL_FAILED)
@@ -1171,7 +1161,7 @@ static void ftrace_match_records(char *buff, int len, int enable)
 		if (enable && (rec->flags & FTRACE_FL_FILTER))
 			ftrace_filtered = 1;
 	} while_for_each_ftrace_rec();
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 }
 
 static int
@@ -1218,8 +1208,7 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 		search_len = strlen(search);
 	}
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
+	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (rec->flags & FTRACE_FL_FAILED)
@@ -1236,7 +1225,7 @@ static void ftrace_match_module_records(char *buff, char *mod, int enable)
 			ftrace_filtered = 1;
 
 	} while_for_each_ftrace_rec();
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 }
 
 /*
@@ -1676,9 +1665,7 @@ ftrace_set_func(unsigned long *array, int idx, char *buffer)
 	if (ftrace_disabled)
 		return -ENODEV;
 
-	/* should not be called from interrupt context */
-	spin_lock(&ftrace_lock);
-
+	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
 
 		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
@@ -1699,7 +1686,7 @@ ftrace_set_func(unsigned long *array, int idx, char *buffer)
 		}
 	} while_for_each_ftrace_rec();
  out:
-	spin_unlock(&ftrace_lock);
+	mutex_unlock(&ftrace_lock);
 
 	return found ? 0 : -EINVAL;
 }
-- 
1.5.6.5

-- 
