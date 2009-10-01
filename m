Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZJAIOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZJAIOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbZJAIOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:14:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:38390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbZJAIK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:28 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/19] workqueue: temporarily disable workqueue tracing
Date: Thu,  1 Oct 2009 17:09:12 +0900
Message-Id: <1254384558-1018-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip tracing code from workqueue and disable workqueue tracing.  This
is temporary measure till concurrency managed workqueue is complete.

NOT_SIGNED_OFF_YET
---
 kernel/trace/Kconfig |    4 +++-
 kernel/workqueue.c   |   14 +++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b416512..0e14ecf 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -393,7 +393,9 @@ config KMEMTRACE
 	  If unsure, say N.
 
 config WORKQUEUE_TRACER
-	bool "Trace workqueues"
+# Temporarily disabled during workqueue reimplementation
+#	bool "Trace workqueues"
+	def_bool n
 	select GENERIC_TRACER
 	help
 	  The workqueue tracer provides some statistical informations
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0f94eb5..39a04ec 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,8 +33,6 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
-#define CREATE_TRACE_POINTS
-#include <trace/events/workqueue.h>
 
 #include "sched_workqueue.h"
 
@@ -128,10 +126,10 @@ static inline void set_wq_data(struct work_struct *work,
 			(unsigned long)cwq | WORK_STRUCT_PENDING | extra_flags);
 }
 
-static inline
-struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
+static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
-	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
+	return (void *)(atomic_long_read(&work->data) &
+			WORK_STRUCT_WQ_DATA_MASK);
 }
 
 /*
@@ -166,8 +164,6 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
-	trace_workqueue_insertion(cwq->thread, work);
-
 	/* we own @work, set data and link */
 	set_wq_data(work, cwq, extra_flags);
 
@@ -331,7 +327,6 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 	struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
 	/* claim and process */
-	trace_workqueue_execution(cwq->thread, work);
 	cwq->current_work = work;
 	list_del_init(&work->entry);
 
@@ -838,8 +833,6 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 		return PTR_ERR(p);
 	cwq->thread = p;
 
-	trace_workqueue_creation(cwq->thread, cpu);
-
 	return 0;
 }
 
@@ -944,7 +937,6 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	trace_workqueue_destruction(cwq->thread);
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }
-- 
1.6.4.2

