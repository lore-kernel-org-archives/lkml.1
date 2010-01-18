Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754Ab0ARBDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab0ARBDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240Ab0ARBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:02:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:54189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0ARAxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:01 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/40] workqueue: temporarily disable workqueue tracing
Date: Mon, 18 Jan 2010 09:57:26 +0900
Message-Id: <1263776272-382-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip tracing code from workqueue and disable workqueue tracing.  This
is temporary measure till concurrency managed workqueue is complete.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/trace/Kconfig |    4 +++-
 kernel/workqueue.c   |   14 +++-----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 6c22d8a..833d244 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -414,7 +414,9 @@ config KMEMTRACE
 	  If unsure, say N.
 
 config WORKQUEUE_TRACER
-	bool "Trace workqueues"
+# Temporarily disabled during workqueue reimplementation
+#	bool "Trace workqueues"
+	def_bool n
 	select GENERIC_TRACER
 	help
 	  The workqueue tracer provides some statistical information
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index aa1d680..a48a9b8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,8 +33,6 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
-#define CREATE_TRACE_POINTS
-#include <trace/events/workqueue.h>
 
 /*
  * Structure fields follow one of the following exclusion rules.
@@ -236,10 +234,10 @@ static inline void set_wq_data(struct work_struct *work,
 			WORK_STRUCT_PENDING | extra_flags);
 }
 
-static inline
-struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
+static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
-	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
+	return (void *)(atomic_long_read(&work->data) &
+			WORK_STRUCT_WQ_DATA_MASK);
 }
 
 /**
@@ -258,8 +256,6 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
-	trace_workqueue_insertion(cwq->thread, work);
-
 	/* we own @work, set data and link */
 	set_wq_data(work, cwq, extra_flags);
 
@@ -424,7 +420,6 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 	struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
 	/* claim and process */
-	trace_workqueue_execution(cwq->thread, work);
 	debug_work_deactivate(work);
 	cwq->current_work = work;
 	list_del_init(&work->entry);
@@ -985,8 +980,6 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 		return PTR_ERR(p);
 	cwq->thread = p;
 
-	trace_workqueue_creation(cwq->thread, cpu);
-
 	return 0;
 }
 
@@ -1091,7 +1084,6 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	trace_workqueue_destruction(cwq->thread);
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }
-- 
1.6.4.2

