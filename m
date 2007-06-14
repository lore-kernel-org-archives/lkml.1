Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbXFNWOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbXFNWOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXFNWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:09:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36487 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbXFNWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:09:18 -0400
Message-Id: <20070614220447.422451759@chello.nl>
References: <20070614215817.389524447@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 23:58:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, andrea@suse.de
Subject: [PATCH 17/17] mm: dirty balancing for tasks
Content-Disposition: inline; filename=dirty_pages2.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Based on ideas of Andrew:
  http://marc.info/?l=linux-kernel&m=102912915020543&w=2

Scale the bdi dirty limit inversly with the tasks dirty rate.
This makes heavy writers have a lower dirty limit than the occasional writer. 

Andrea proposed something similar:
  http://lwn.net/Articles/152277/

The main disadvantage to his patch is that he uses an unrelated quantity to
measure time, which leaves him with a workload dependant tunable. Other than
that the two approached appear quite similar.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +
 kernel/exit.c         |    1 
 kernel/fork.c         |    1 
 mm/page-writeback.c   |   56 +++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 59 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -84,6 +84,7 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
+#include <linux/proportions.h>
 
 #include <asm/processor.h>
 
@@ -1151,6 +1152,7 @@ struct task_struct {
 #ifdef CONFIG_FAULT_INJECTION
 	int make_it_fail;
 #endif
+	struct prop_local_single dirties;
 };
 
 static inline pid_t process_group(struct task_struct *tsk)
Index: linux-2.6/kernel/exit.c
===================================================================
--- linux-2.6.orig/kernel/exit.c
+++ linux-2.6/kernel/exit.c
@@ -162,6 +162,7 @@ repeat:
 	ptrace_unlink(p);
 	BUG_ON(!list_empty(&p->ptrace_list) || !list_empty(&p->ptrace_children));
 	__exit_signal(p);
+	prop_local_destroy(&p->dirties);
 
 	/*
 	 * If we are the last non-leader member of the thread
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -192,6 +192,7 @@ static struct task_struct *dup_task_stru
 	tsk->btrace_seq = 0;
 #endif
 	tsk->splice_pipe = NULL;
+	prop_local_init(&tsk->dirties);
 	return tsk;
 }
 
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -118,6 +118,7 @@ static void background_writeout(unsigned
  *
  */
 static struct prop_descriptor vm_completions;
+static struct prop_descriptor vm_dirties;
 
 static unsigned long determine_dirtyable_memory(void);
 
@@ -146,6 +147,7 @@ int dirty_ratio_handler(ctl_table *table
 	if (ret == 0 && write && vm_dirty_ratio != old_ratio) {
 		int shift = calc_period_shift();
 		prop_change_shift(&vm_completions, shift);
+		prop_change_shift(&vm_dirties, shift);
 	}
 	return ret;
 }
@@ -161,6 +163,16 @@ static void __bdi_writeout_inc(struct ba
 	prop_put_global(&vm_completions, pg);
 }
 
+static void task_dirty_inc(struct task_struct *tsk)
+{
+	unsigned long flags;
+	struct prop_global *pg = prop_get_global(&vm_dirties);
+	local_irq_save(flags);
+	__prop_inc(pg, &tsk->dirties);
+	local_irq_restore(flags);
+	prop_put_global(&vm_dirties, pg);
+}
+
 /*
  * Obtain an accurate fraction of the BDI's portion.
  */
@@ -201,6 +213,38 @@ clip_bdi_dirty_limit(struct backing_dev_
 	*pbdi_dirty = min(*pbdi_dirty, avail_dirty);
 }
 
+void task_dirties_fraction(struct task_struct *tsk,
+		long *numerator, long *denominator)
+{
+	struct prop_global *pg = prop_get_global(&vm_dirties);
+	prop_fraction(pg, &tsk->dirties, numerator, denominator);
+	prop_put_global(&vm_dirties, pg);
+}
+
+/*
+ * scale the dirty limit
+ *
+ * task specific dirty limit:
+ *
+ *   dirty -= (dirty/2) * p_{t}
+ */
+void task_dirty_limit(struct task_struct *tsk, long *pdirty)
+{
+	long numerator, denominator;
+	long dirty = *pdirty;
+	long long inv = dirty >> 1;
+
+	task_dirties_fraction(tsk, &numerator, &denominator);
+	inv *= numerator;
+	do_div(inv, denominator);
+
+	dirty -= inv;
+	if (dirty < *pdirty/2)
+		dirty = *pdirty/2;
+
+	*pdirty = dirty;
+}
+
 /*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
@@ -307,6 +351,7 @@ get_dirty_limits(long *pbackground, long
 
 		*pbdi_dirty = bdi_dirty;
 		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
+		task_dirty_limit(current, pbdi_dirty);
 	}
 }
 
@@ -732,6 +777,7 @@ void __init page_writeback_init(void)
 
 	shift = calc_period_shift();
 	prop_descriptor_init(&vm_completions, shift);
+	prop_descriptor_init(&vm_dirties, shift);
 }
 
 /**
@@ -1010,7 +1056,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage
  * If the mapping doesn't provide a set_page_dirty a_op, then
  * just fall through and assume that it wants buffer_heads.
  */
-int fastcall set_page_dirty(struct page *page)
+static int __set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
@@ -1028,6 +1074,14 @@ int fastcall set_page_dirty(struct page 
 	}
 	return 0;
 }
+
+int fastcall set_page_dirty(struct page *page)
+{
+	int ret = __set_page_dirty(page);
+	if (ret)
+		task_dirty_inc(current);
+	return ret;
+}
 EXPORT_SYMBOL(set_page_dirty);
 
 /*

-- 

