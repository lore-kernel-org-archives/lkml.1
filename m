Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZJAIKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZJAIKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZJAIKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:38398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbZJAIKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:32 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/19] workqueue: update cwq alignement and make one more flag bit available
Date: Thu,  1 Oct 2009 17:09:09 +0900
Message-Id: <1254384558-1018-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cwqs are aligned to cacheline and lower two bits of
work_struct->data are considered to be available and used as flags.
Make the alignement requirement official by defining
WORK_STRUCT_FLAG_BITS and aligning cwqs to two's power of it.

This is in preparation of concurrency managed workqueue and cwqs being
aligned to cacheline wouldn't matter as much.  While at it, this patch
reserves one more bit for work flags and make sure the resulting
alignment is at least equal to or larger than that of long long.

NOT_SIGNED_OFF_YET
---
 include/linux/workqueue.h |   17 ++++++++++++++---
 kernel/workqueue.c        |   15 +++++++++++++--
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index d3334a0..3d11ce3 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -22,11 +22,22 @@ typedef void (*work_func_t)(struct work_struct *work);
  */
 #define work_data_bits(work) ((unsigned long *)(&(work)->data))
 
+enum {
+	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
+
+	/*
+	 * Reserve 3bits off of cwq pointer.  This is enough and
+	 * provides acceptable alignment on both 32 and 64bit
+	 * machines.
+	 */
+	WORK_STRUCT_FLAG_BITS	= 3,
+
+	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
+	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
+};
+
 struct work_struct {
 	atomic_long_t data;
-#define WORK_STRUCT_PENDING 0		/* T if work item pending execution */
-#define WORK_STRUCT_FLAG_MASK (3UL)
-#define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
 #ifdef CONFIG_LOCKDEP
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index befda6c..28de966 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -50,7 +50,9 @@
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
- * possible cpu).
+ * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
+ * work_struct->data are used for flags and thus cwqs need to be
+ * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {
 
@@ -62,7 +64,7 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	struct task_struct	*thread;
-} ____cacheline_aligned;
+} __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
 
 /*
  * The externally visible workqueue abstraction is an array of
@@ -1049,6 +1051,15 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
 void __init init_workqueues(void)
 {
+	/*
+	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
+	 * Make sure that the alignment isn't lower than that of
+	 * unsigned long long in case this code survives for longer
+	 * than twenty years.  :-P
+	 */
+	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
+		     __alignof__(unsigned long long));
+
 	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
 
 	cpumask_copy(cpu_populated_map, cpu_online_mask);
-- 
1.6.4.2

