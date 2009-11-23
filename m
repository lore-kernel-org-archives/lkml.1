Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZKWQ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZKWQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZKWQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:28:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:52708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbZKWQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:28:19 -0500
From: Tejun Heo <tj@kernel.org>
To: peterz@infradead.org, torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] workqueue: define both bit position and mask for work flags
Date: Tue, 24 Nov 2009 01:27:02 +0900
Message-Id: <1258993624-28735-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1258993624-28735-1-git-send-email-tj@kernel.org>
References: <1258993624-28735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work flags are about to see more traditional mask handling.  Define
WORK_STRUCT_*_BIT as the bit position constant and redefine
WORK_STRUCT_* as bit masks.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   15 +++++++++------
 kernel/workqueue.c        |   14 +++++++-------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5ff8c44..8e689d1 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -23,8 +23,11 @@ typedef void (*work_func_t)(struct work_struct *work);
 #define work_data_bits(work) ((unsigned long *)(&(work)->data))
 
 enum {
-	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
-	WORK_STRUCT_STATIC	= 1,	/* static initializer (debugobjects) */
+	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
+	WORK_STRUCT_STATIC_BIT	= 1,	/* static initializer (debugobjects) */
+
+	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
 
 	/*
 	 * Reserve 3bits off of cwq pointer.  This is enough and
@@ -47,7 +50,7 @@ struct work_struct {
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
-#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(2)
+#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_STATIC)
 
 struct delayed_work {
 	struct work_struct work;
@@ -109,7 +112,7 @@ extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
 static inline bool work_static(struct work_struct *work)
 {
-	return test_bit(WORK_STRUCT_STATIC, work_data_bits(work));
+	return test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work));
 }
 #else
 static inline void __init_work(struct work_struct *work, int onstack) { }
@@ -178,7 +181,7 @@ static inline bool work_static(struct work_struct *work) { return false; }
  * @work: The work item in question
  */
 #define work_pending(work) \
-	test_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	test_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 /**
  * delayed_work_pending - Find out whether a delayable work item is currently
@@ -193,7 +196,7 @@ static inline bool work_static(struct work_struct *work) { return false; }
  * @work: The work item in question
  */
 #define work_clear_pending(work) \
-	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	clear_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f30977f..0083da6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -117,7 +117,7 @@ static int work_fixup_activate(void *addr, enum debug_obj_state state)
 		 * statically initialized. We just make sure that it
 		 * is tracked in the object tracker.
 		 */
-		if (test_bit(WORK_STRUCT_STATIC, work_data_bits(work))) {
+		if (test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work))) {
 			debug_object_init(work, &work_debug_descr);
 			debug_object_activate(work, &work_debug_descr);
 			return 0;
@@ -234,8 +234,8 @@ static inline void set_wq_data(struct work_struct *work,
 	BUG_ON(!work_pending(work));
 
 	atomic_long_set(&work->data, (unsigned long)cwq |
-			(work_static(work) ? (1UL << WORK_STRUCT_STATIC) : 0) |
-			(1UL << WORK_STRUCT_PENDING) | extra_flags);
+			(work_static(work) ? WORK_STRUCT_STATIC : 0) |
+			WORK_STRUCT_PENDING | extra_flags);
 }
 
 static inline
@@ -325,7 +325,7 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		__queue_work(cpu, wq, work);
 		ret = 1;
 	}
@@ -375,7 +375,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
@@ -511,7 +511,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	 * might deadlock.
 	 */
 	INIT_WORK_ON_STACK(&barr->work, wq_barrier_func);
-	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
+	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
 
 	debug_work_activate(&barr->work);
@@ -623,7 +623,7 @@ static int try_to_grab_pending(struct work_struct *work)
 	struct cpu_workqueue_struct *cwq;
 	int ret = -1;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
 		return 0;
 
 	/*
-- 
1.6.5.3

