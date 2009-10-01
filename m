Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbZJAINM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbZJAINM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087AbZJAINJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:13:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:38405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbZJAIKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:38 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/19] workqueue: define both bit position and mask for work flags
Date: Thu,  1 Oct 2009 17:09:10 +0900
Message-Id: <1254384558-1018-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work flags are about to see more traditional mask handling.  Define
WORK_STRUCT_*_BIT as the bit position constant and redefine
WORK_STRUCT_* as bit masks.

NOT_SIGNED_OFF_YET
---
 include/linux/workqueue.h |    8 +++++---
 kernel/workqueue.c        |   12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 3d11ce3..541c5eb 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -23,7 +23,9 @@ typedef void (*work_func_t)(struct work_struct *work);
 #define work_data_bits(work) ((unsigned long *)(&(work)->data))
 
 enum {
-	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
+	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
+
+	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
 
 	/*
 	 * Reserve 3bits off of cwq pointer.  This is enough and
@@ -157,7 +159,7 @@ struct execute_work {
  * @work: The work item in question
  */
 #define work_pending(work) \
-	test_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	test_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 /**
  * delayed_work_pending - Find out whether a delayable work item is currently
@@ -172,7 +174,7 @@ struct execute_work {
  * @work: The work item in question
  */
 #define work_clear_pending(work) \
-	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
+	clear_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))
 
 enum {
 	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 28de966..1678dd1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -124,8 +124,8 @@ static inline void set_wq_data(struct work_struct *work,
 			       unsigned long extra_flags)
 {
 	BUG_ON(!work_pending(work));
-	atomic_long_set(&work->data, (unsigned long)cwq |
-			(1UL << WORK_STRUCT_PENDING) | extra_flags);
+	atomic_long_set(&work->data,
+			(unsigned long)cwq | WORK_STRUCT_PENDING | extra_flags);
 }
 
 static inline
@@ -230,7 +230,7 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 {
 	int ret = 0;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		__queue_work(cpu, wq, work);
 		ret = 1;
 	}
@@ -280,7 +280,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
@@ -412,7 +412,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 			struct wq_barrier *barr, struct list_head *head)
 {
 	INIT_WORK(&barr->work, wq_barrier_func);
-	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
+	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
 
 	insert_work(cwq, &barr->work, head, 0);
@@ -519,7 +519,7 @@ static int try_to_grab_pending(struct work_struct *work)
 	struct cpu_workqueue_struct *cwq;
 	int ret = -1;
 
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
 		return 0;
 
 	/*
-- 
1.6.4.2

