Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYHPBrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYHPBrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 21:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYHPBqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 21:46:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYHPBqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 21:46:49 -0400
Message-Id: <20080816014647.419838748@goodmis.org>
References: <20080816014003.978160137@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 Aug 2008 21:40:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: add necessary locking for ftrace records
Content-Disposition: inline; filename=ftrace-protect-printout.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new design of pre-recorded mcounts and updating the code outside of
kstop_machine has changed the way the records themselves are protected.

This patch uses the ftrace_lock to protect the records. Note, the lock
still does not need to be taken within calls that are only called via
kstop_machine, since the that code can not run while the spin lock is held.

Also removed the hash_lock needed for the daemon when MCOUNT_RECORD is
configured. Also did a slight cleanup of an unused variable.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-15 12:56:37.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-15 20:35:41.000000000 -0400
@@ -81,7 +81,7 @@ void clear_ftrace_function(void)
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	/* Should never be called by interrupts */
+	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 
 	ops->next = ftrace_list;
@@ -115,6 +115,7 @@ static int __unregister_ftrace_function(
 	struct ftrace_ops **p;
 	int ret = 0;
 
+	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 
 	/*
@@ -153,6 +154,21 @@ static int __unregister_ftrace_function(
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+#ifndef CONFIG_FTRACE_MCOUNT_RECORD
+/*
+ * The hash lock is only needed when the recording of the mcount
+ * callers are dynamic. That is, by the caller themselves and
+ * not recorded via the compilation.
+ */
+static DEFINE_SPINLOCK(ftrace_hash_lock);
+#define ftrace_hash_lock(flags)	  spin_lock_irqsave(ftrace_hash_lock, flags)
+#define ftrace_hash_unlock(flags) spin_lock_irqsave(ftrace_hash_lock, flags)
+#else
+/* This is protected via the ftrace_lock with MCOUNT_RECORD. */
+#define ftrace_hash_lock(flags)   do { (void)flags; } while (0)
+#define ftrace_hash_unlock(flags) do { } while(0)
+#endif
+
 static struct task_struct *ftraced_task;
 
 enum {
@@ -171,7 +187,6 @@ static struct hlist_head ftrace_hash[FTR
 
 static DEFINE_PER_CPU(int, ftrace_shutdown_disable_cpu);
 
-static DEFINE_SPINLOCK(ftrace_shutdown_lock);
 static DEFINE_MUTEX(ftraced_lock);
 static DEFINE_MUTEX(ftrace_regex_lock);
 
@@ -310,7 +325,7 @@ void ftrace_release(void *start, unsigne
 	if (ftrace_disabled || !start)
 		return;
 
-	/* No interrupt should call this */
+	/* should not be called from interrupt context */
 	spin_lock(&ftrace_lock);
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
@@ -362,7 +377,6 @@ ftrace_record_ip(unsigned long ip)
 	unsigned long flags;
 	unsigned long key;
 	int resched;
-	int atomic;
 	int cpu;
 	static int once;
 
@@ -399,9 +413,7 @@ ftrace_record_ip(unsigned long ip)
 	if (ftrace_ip_in_hash(ip, key))
 		goto out;
 
-	atomic = irqs_disabled();
-
-	spin_lock_irqsave(&ftrace_shutdown_lock, flags);
+	ftrace_hash_lock(flags);
 
 	/* This ip may have hit the hash before the lock */
 	if (ftrace_ip_in_hash(ip, key))
@@ -418,7 +430,7 @@ ftrace_record_ip(unsigned long ip)
 	ftraced_trigger = 1;
 
  out_unlock:
-	spin_unlock_irqrestore(&ftrace_shutdown_lock, flags);
+	ftrace_hash_unlock(flags);
  out:
 	per_cpu(ftrace_shutdown_disable_cpu, cpu)--;
 
@@ -894,6 +906,8 @@ t_next(struct seq_file *m, void *v, loff
 
 	(*pos)++;
 
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
  retry:
 	if (iter->idx >= iter->pg->index) {
 		if (iter->pg->next) {
@@ -917,6 +931,7 @@ t_next(struct seq_file *m, void *v, loff
 			goto retry;
 		}
 	}
+	spin_unlock(&ftrace_lock);
 
 	iter->pos = *pos;
 
@@ -1030,8 +1045,8 @@ static void ftrace_filter_reset(int enab
 	unsigned long type = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
 	unsigned i;
 
-	/* keep kstop machine from running */
-	preempt_disable();
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 0;
 	pg = ftrace_pages_start;
@@ -1044,7 +1059,7 @@ static void ftrace_filter_reset(int enab
 		}
 		pg = pg->next;
 	}
-	preempt_enable();
+	spin_unlock(&ftrace_lock);
 }
 
 static int
@@ -1156,8 +1171,8 @@ ftrace_match(unsigned char *buff, int le
 		}
 	}
 
-	/* keep kstop machine from running */
-	preempt_disable();
+	/* should not be called from interrupt context */
+	spin_lock(&ftrace_lock);
 	if (enable)
 		ftrace_filtered = 1;
 	pg = ftrace_pages_start;
@@ -1194,7 +1209,7 @@ ftrace_match(unsigned char *buff, int le
 		}
 		pg = pg->next;
 	}
-	preempt_enable();
+	spin_unlock(&ftrace_lock);
 }
 
 static ssize_t
@@ -1558,6 +1573,7 @@ static int ftrace_convert_nops(unsigned 
 	p = start;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
+		/* should not be called from interrupt context */
 		spin_lock(&ftrace_lock);
 		ftrace_record_ip(addr);
 		spin_unlock(&ftrace_lock);

-- 
