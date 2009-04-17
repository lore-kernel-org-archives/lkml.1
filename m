Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbZDQGg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbZDQGg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZDQGfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:35:47 -0400
Received: from gw.goop.org ([64.81.55.164]:36613 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752150AbZDQGfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:35:44 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/4] tracing: pass proto and args to DEFINE_TRACE
Date: Thu, 16 Apr 2009 23:35:38 -0700
Message-Id: <1239950139-1119-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239950139-1119-1-git-send-email-jeremy@goop.org>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We need to pass the prototype and args to DEFINE_TRACE so that it can
instantiate __do_trace_X.  Unfortunately, this requires duplication
of information already passed to DECLARE_TRACE, so any change needs
to be updated in both places.  It doesn't help that uses of DEFINE_TRACE
are scattered throughout the sources.

(Moving to the new TRACE_EVENT() interface will solve this by putting
all the information into one place.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 +-
 arch/x86/kernel/process.c                  |    9 +++-
 block/blk-core.c                           |   56 ++++++++++++++++++++++-----
 block/elevator.c                           |   13 +++++-
 drivers/md/dm.c                            |    4 +-
 fs/bio.c                                   |    4 +-
 include/linux/tracepoint.h                 |   12 ++++--
 include/trace/define_trace.h               |    9 +---
 kernel/workqueue.c                         |   16 ++++++--
 mm/bounce.c                                |    4 +-
 10 files changed, 97 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 3e3cd3d..07a6ce7 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -73,7 +73,9 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
-DEFINE_TRACE(power_mark);
+DEFINE_TRACE(power_mark,
+	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
+	      TP_ARGS(it, type, state));
 
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..e3b0593 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -22,8 +22,13 @@ EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
 
-DEFINE_TRACE(power_start);
-DEFINE_TRACE(power_end);
+DEFINE_TRACE(power_start,
+	TP_PROTO(struct power_trace *it, unsigned int type, unsigned int state),
+	      TP_ARGS(it, type, state));
+
+DEFINE_TRACE(power_end,
+	TP_PROTO(struct power_trace *it),
+	      TP_ARGS(it));
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..dbd6391 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -32,17 +32,51 @@
 
 #include "blk.h"
 
-DEFINE_TRACE(block_plug);
-DEFINE_TRACE(block_unplug_io);
-DEFINE_TRACE(block_unplug_timer);
-DEFINE_TRACE(block_getrq);
-DEFINE_TRACE(block_sleeprq);
-DEFINE_TRACE(block_rq_requeue);
-DEFINE_TRACE(block_bio_backmerge);
-DEFINE_TRACE(block_bio_frontmerge);
-DEFINE_TRACE(block_bio_queue);
-DEFINE_TRACE(block_rq_complete);
-DEFINE_TRACE(block_remap);	/* Also used in drivers/md/dm.c */
+DEFINE_TRACE(block_rq_requeue,
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
+
+DEFINE_TRACE(block_rq_complete,
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
+
+DEFINE_TRACE(block_bio_backmerge,
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
+
+DEFINE_TRACE(block_bio_frontmerge,
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
+
+DEFINE_TRACE(block_bio_queue,
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
+
+DEFINE_TRACE(block_getrq,
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	      TP_ARGS(q, bio, rw));
+
+DEFINE_TRACE(block_sleeprq,
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+	      TP_ARGS(q, bio, rw));
+
+DEFINE_TRACE(block_plug,
+	TP_PROTO(struct request_queue *q),
+	      TP_ARGS(q));
+
+DEFINE_TRACE(block_unplug_timer,
+	TP_PROTO(struct request_queue *q),
+	      TP_ARGS(q));
+
+DEFINE_TRACE(block_unplug_io,
+	TP_PROTO(struct request_queue *q),
+	      TP_ARGS(q));
+
+DEFINE_TRACE(block_remap,	/* Also used in drivers/md/dm.c */
+	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
+		 sector_t from, sector_t to),
+	      TP_ARGS(q, bio, dev, from, to));
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_remap);
 
 static int __make_request(struct request_queue *q, struct bio *bio);
diff --git a/block/elevator.c b/block/elevator.c
index fb81bcc..96c7849 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -42,7 +42,9 @@
 static DEFINE_SPINLOCK(elv_list_lock);
 static LIST_HEAD(elv_list);
 
-DEFINE_TRACE(block_rq_abort);
+DEFINE_TRACE(block_rq_abort,
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
 
 /*
  * Merge hash stuff.
@@ -55,8 +57,13 @@ static const int elv_hash_shift = 6;
 #define rq_hash_key(rq)		((rq)->sector + (rq)->nr_sectors)
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
-DEFINE_TRACE(block_rq_insert);
-DEFINE_TRACE(block_rq_issue);
+DEFINE_TRACE(block_rq_insert,
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
+
+DEFINE_TRACE(block_rq_issue,
+	TP_PROTO(struct request_queue *q, struct request *rq),
+	      TP_ARGS(q, rq));
 
 /*
  * Query io scheduler to see if the current process issuing bio may be
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a994be..73efa35 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -54,7 +54,9 @@ struct dm_target_io {
 	union map_info info;
 };
 
-DEFINE_TRACE(block_bio_complete);
+DEFINE_TRACE(block_bio_complete,
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
 
 /*
  * For request-based dm.
diff --git a/fs/bio.c b/fs/bio.c
index e0c9e54..07fa718 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -29,7 +29,9 @@
 #include <trace/block.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
-DEFINE_TRACE(block_split);
+DEFINE_TRACE(block_split,
+	TP_PROTO(struct request_queue *q, struct bio *bio, unsigned int pdu),
+	      TP_ARGS(q, bio, pdu));
 
 /*
  * Test patch to inline a certain number of bi_io_vec's inside the bio
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 1052e33..7451361 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -80,17 +80,21 @@ struct tracepoint {
 		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
-#define DEFINE_TRACE(name)						\
+#define DEFINE_TRACE(name, proto, args)					\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, NULL }
+	{ __tpstrtab_##name, 0, NULL };					\
+	DEFINE_DO_TRACE(name, TP_PROTO(proto), TP_ARGS(args))
 
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
-	EXPORT_SYMBOL_GPL(__tracepoint_##name)
+	EXPORT_SYMBOL_GPL(__tracepoint_##name);				\
+	EXPORT_SYMBOL_GPL(__do_trace_##name)
+
 #define EXPORT_TRACEPOINT_SYMBOL(name)					\
-	EXPORT_SYMBOL(__tracepoint_##name)
+	EXPORT_SYMBOL(__tracepoint_##name);				\
+	EXPORT_SYMBOL(__do_trace_##name)
 
 extern void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end);
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index fa46100..9887525 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -24,18 +24,15 @@
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
-	DEFINE_DO_TRACE(name, TP_PROTO(proto), TP_ARGS(args))	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, TP_PROTO(proto), TP_ARGS(args))
 
 #undef TRACE_FORMAT
 #define TRACE_FORMAT(name, proto, args, print)			\
-	DEFINE_DO_TRACE(name, TP_PROTO(proto), TP_ARGS(args))	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, TP_PROTO(proto), TP_ARGS(args))
 
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)			\
-	DEFINE_DO_TRACE(name, TP_PROTO(proto), TP_ARGS(args))	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, TP_PROTO(proto), TP_ARGS(args))
 
 #undef TRACE_INCLUDE
 #undef __TRACE_INCLUDE
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f71fb2a..4e8b519 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -124,7 +124,9 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
-DEFINE_TRACE(workqueue_insertion);
+DEFINE_TRACE(workqueue_insertion,
+	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+	   TP_ARGS(wq_thread, work));
 
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
@@ -262,7 +264,9 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
-DEFINE_TRACE(workqueue_execution);
+DEFINE_TRACE(workqueue_execution,
+	     TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+	     TP_ARGS(wq_thread, work));
 
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
@@ -753,7 +757,9 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	return cwq;
 }
 
-DEFINE_TRACE(workqueue_creation);
+DEFINE_TRACE(workqueue_creation,
+	   TP_PROTO(struct task_struct *wq_thread, int cpu),
+	   TP_ARGS(wq_thread, cpu));
 
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
@@ -860,7 +866,9 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-DEFINE_TRACE(workqueue_destruction);
+DEFINE_TRACE(workqueue_destruction,
+	   TP_PROTO(struct task_struct *wq_thread),
+	   TP_ARGS(wq_thread));
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
diff --git a/mm/bounce.c b/mm/bounce.c
index e590272..8a7a59d 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -22,7 +22,9 @@
 
 static mempool_t *page_pool, *isa_page_pool;
 
-DEFINE_TRACE(block_bio_bounce);
+DEFINE_TRACE(block_bio_bounce,
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+	      TP_ARGS(q, bio));
 
 #ifdef CONFIG_HIGHMEM
 static __init int init_emergency_pool(void)
-- 
1.6.0.6

