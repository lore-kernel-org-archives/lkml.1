Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZLRM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZLRM5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZLRM5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:57:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:45232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZLRM5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:57:16 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net,
       andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/27] workqueue: define both bit position and mask for work flags
Date: Fri, 18 Dec 2009 21:57:52 +0900
Message-Id: <1261141088-2014-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1261141088-2014-1-git-send-email-tj@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work flags are about to see more traditional mask handling.  Define
WORK_STRUCT_*_BIT as the bit position constant and redefine
WORK_STRUCT_* as bit masks.

While at it, re-define these constants as enums and use
WORK_STRUCT_STATIC instead of hard-coding 2 in
WORK_DATA_STATIC_INIT().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   23 +++++++++++++++--------
 kernel/workqueue.c        |   14 +++++++-------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 495572a..e51b5dc 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -22,12 +22,19 @@ typedef void (*work_func_t)(struct work_struct *work);
  */
 #define work_data_bits(work) ((unsigned long *)(&(work)->data))
 
+enum {
+	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
+	WORK_STRUCT_STATIC_BIT	= 1,	/* static initializer (debugobjects) */
+
+	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
+
+	WORK_STRUCT_FLAG_MASK	= 3UL,
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
@@ -36,7 +43,7 @@ struct work_struct {
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
-#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(2)
+#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(WORK_STRUCT_STATIC)
 
 struct delayed_work {
 	struct work_struct work;
@@ -98,7 +105,7 @@ extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
 static inline bool work_static(struct work_struct *work)
 {
-	return test_bit(WORK_STRUCT_STATIC, work_data_bits(work));
+	return test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work));
 }
 #else
 static inline void __init_work(struct work_struct *work, int onstack) { }
@@ -167,7 +174,7 @@ static inline bool work_static(struct work_struct *work) { return false; }
  * @work: The work item in question
  */
 #define work_pending(work) \
-	test_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	test_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 /**
  * delayed_work_pending - Find out whether a delayable work item is currently
@@ -182,7 +189,7 @@ static inline bool work_static(struct work_struct *work) { return false; }
  * @work: The work item in question
  */
 #define work_clear_pending(work) \
-	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	clear_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 579041f..f8e4d67 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -115,7 +115,7 @@ static int work_fixup_activate(void *addr, enum debug_obj_state state)
 		 * statically initialized. We just make sure that it
 		 * is tracked in the object tracker.
 		 */
-		if (test_bit(WORK_STRUCT_STATIC, work_data_bits(work))) {
+		if (test_bit(WORK_STRUCT_STATIC_BIT, work_data_bits(work))) {
 			debug_object_init(work, &work_debug_descr);
 			debug_object_activate(work, &work_debug_descr);
 			return 0;
@@ -232,8 +232,8 @@ static inline void set_wq_data(struct work_struct *work,
 	BUG_ON(!work_pending(work));
 
 	atomic_long_set(&work->data, (unsigned long)cwq |
-			(work_static(work) ? (1UL << WORK_STRUCT_STATIC) : 0) |
-			(1UL << WORK_STRUCT_PENDING) | extra_flags);
+			(work_static(work) ? WORK_STRUCT_STATIC : 0) |
+			WORK_STRUCT_PENDING | extra_flags);
 }
 
 static inline
@@ -323,7 +323,7 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		__queue_work(cpu, wq, work);
 		ret = 1;
 	}
@@ -373,7 +373,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
@@ -509,7 +509,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	 * might deadlock.
 	 */
 	INIT_WORK_ON_STACK(&barr->work, wq_barrier_func);
-	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
+	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
 
 	debug_work_activate(&barr->work);
@@ -621,7 +621,7 @@ static int try_to_grab_pending(struct work_struct *work)
 	struct cpu_workqueue_struct *cwq;
 	int ret = -1;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
 		return 0;
 
 	/*
-- 
1.6.4.2

