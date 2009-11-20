Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZKTEtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZKTEtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 23:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbZKTEtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 23:49:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:45113 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZKTEsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 23:48:16 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/19] workqueue: update cwq alignement and make one more flag bit available
Date: Fri, 20 Nov 2009 13:46:39 +0900
Message-Id: <1258692407-8985-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258692407-8985-1-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
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

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   19 +++++++++++++++----
 kernel/workqueue.c        |   15 +++++++++++++--
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 495572a..5ff8c44 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -22,12 +22,23 @@ typedef void (*work_func_t)(struct work_struct *work);
  */
 #define work_data_bits(work) ((unsigned long *)(&(work)->data))
 
+enum {
+	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
+	WORK_STRUCT_STATIC	= 1,	/* static initializer (debugobjects) */
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
-#define WORK_STRUCT_STATIC  1		/* static initializer (debugobjects) */
-#define WORK_STRUCT_FLAG_MASK (3UL)
-#define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct list_head entry;
 	work_func_t func;
 #ifdef CONFIG_LOCKDEP
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 579041f..f30977f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -48,7 +48,9 @@
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
- * possible cpu).
+ * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
+ * work_struct->data are used for flags and thus cwqs need to be
+ * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {
 
@@ -60,7 +62,7 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	struct task_struct	*thread;
-} ____cacheline_aligned;
+} __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
 
 /*
  * The externally visible workqueue abstraction is an array of
@@ -1198,6 +1200,15 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
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

