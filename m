Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZDMF4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZDMF4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 01:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZDMF4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 01:56:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33192 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbZDMF4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 01:56:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] ftrace: add latecy mesurement feature to workqueue tracer
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090413145105.6E07.A69D9226@jp.fujitsu.com>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com>
Message-Id: <20090413145335.6E10.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 13 Apr 2009 14:55:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] ftrace: add latecy mesurement feature to workqueue tracer

The schedule_delayed_work() doesn't gurantee delay argument is exactly, of course.
but Administrator often wants to know how long time delayed it.

Then, this patch add latency mesurement feature to workqueue tracer.


<example output>

# cd /sys/kernel/debug/tracing/trace_stat
# cat workqueues

---------------------------------------------------------
# CPU  INSERTED  EXECUTED     MAX_TIME    MAX_LAT  NAME
# |      |         |           |             |      |

  0    326        326         0.000115      2.421  events/0
  0      0          0         0.000000      0.000  cpuset
  0    597        597         0.000387      0.028  khelper
  0      5          5         0.000029      0.002  kblockd/0
  0      0          0         0.000000      0.000  kacpid
  0      0          0         0.000000      0.000  kacpi_notify
  0      0          0         0.000000      0.000  ksuspend_usbd
  0      0          0         0.000000      0.000  aio/0
  0      0          0         0.000000      0.000  crypto/0
  0      0          0         0.000000      0.000  usbhid_resumer
  0    299        299         0.004047      0.001  ata/0
  0      0          0         0.000000      0.000  ata_aux


BTW, I'm not sure about why events/ workqueue thread always have long latency.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/workqueue.h             |    3 +++
 include/trace/workqueue_event_types.h |   10 ++++++++--
 kernel/trace/trace_workqueue.c        |   19 ++++++++++++++++---
 kernel/workqueue.c                    |   18 +++++++++++++++++-
 4 files changed, 44 insertions(+), 6 deletions(-)

Index: b/include/trace/workqueue_event_types.h
===================================================================
--- a/include/trace/workqueue_event_types.h	2009-04-13 13:58:21.000000000 +0900
+++ b/include/trace/workqueue_event_types.h	2009-04-13 14:07:14.000000000 +0900
@@ -43,6 +43,8 @@ TRACE_EVENT(workqueue_handler_entry,
 		__field(pid_t,			thread_pid)
 		__field(struct work_struct *,	work)
 		__field(work_func_t,		func)
+		__field(unsigned long,		expected_time)
+		__field(unsigned long,		actual_time)
 	),
 
 	TP_fast_assign(
@@ -50,10 +52,14 @@ TRACE_EVENT(workqueue_handler_entry,
 		__entry->thread_pid	= wq_thread->pid;
 		__entry->work		= work;
 		__entry->func		= work->func;
+		__entry->expected_time	= work->expected_time;
+		__entry->actual_time	= jiffies;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
-		__entry->thread_pid, __entry->func)
+	TP_printk("thread=%s:%d latency=%lums func=%pF", __entry->thread_comm,
+		  __entry->thread_pid,
+		  jiffies_to_msecs(__entry->actual_time-__entry->expected_time),
+		  __entry->func)
 );
 
 TRACE_EVENT(workqueue_handler_exit,
Index: b/kernel/trace/trace_workqueue.c
===================================================================
--- a/kernel/trace/trace_workqueue.c	2009-04-13 13:59:51.000000000 +0900
+++ b/kernel/trace/trace_workqueue.c	2009-04-13 14:09:54.000000000 +0900
@@ -31,6 +31,9 @@ struct cpu_workqueue_stats {
 	/* store handler execution time */
 	u64			    handler_start_time;
 	u64			    max_executed_time;
+
+	/* store actual fired jiffies - caller expected jiffies */
+	unsigned long		    max_work_latency;
 };
 
 /* List of workqueue threads on one cpu */
@@ -80,8 +83,13 @@ probe_workqueue_entry(struct task_struct
 	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
 							list) {
 		if (node->pid == wq_thread->pid) {
+			unsigned long latency;
+
 			node->executed++;
 			node->handler_start_time = trace_clock_global();
+			latency = jiffies - work->expected_time;
+			if (node->max_work_latency < latency)
+				node->max_work_latency = latency;
 			goto found;
 		}
 	}
@@ -226,6 +234,8 @@ static int workqueue_stat_show(struct se
 	unsigned long long exec_time = ns2usecs(cws->max_executed_time);
 	unsigned long exec_usec_rem = do_div(exec_time, USEC_PER_SEC);
 	unsigned long exec_secs = (unsigned long)exec_time;
+	unsigned long lat = jiffies_to_msecs(cws->max_work_latency);
+	unsigned long lat_msec_rem = do_div(lat, MSEC_PER_SEC);
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
@@ -237,10 +247,11 @@ static int workqueue_stat_show(struct se
 		tsk = get_pid_task(pid, PIDTYPE_PID);
 		if (tsk) {
 			seq_printf(s, "%3d %6d     %6u     %5lu.%06lu"
-				   "  %s\n",
+				   "  %5lu.%03lu  %s\n",
 				   cws->cpu,
 				   atomic_read(&cws->inserted), cws->executed,
 				   exec_secs, exec_usec_rem,
+				   lat, lat_msec_rem,
 				   tsk->comm);
 			put_task_struct(tsk);
 		}
@@ -252,8 +263,10 @@ static int workqueue_stat_show(struct se
 
 static int workqueue_stat_headers(struct seq_file *s)
 {
-	seq_printf(s, "# CPU  INSERTED  EXECUTED     MAX_TIME  NAME\n");
-	seq_printf(s, "# |      |         |           |         |\n");
+	seq_printf(s, "# CPU  INSERTED  EXECUTED     MAX_TIME"
+		   "    MAX_LAT  NAME\n");
+	seq_printf(s, "# |      |         |           |      "
+		   "     |        |\n");
 	return 0;
 }
 
Index: b/kernel/workqueue.c
===================================================================
--- a/kernel/workqueue.c	2009-04-13 13:58:21.000000000 +0900
+++ b/kernel/workqueue.c	2009-04-13 14:07:14.000000000 +0900
@@ -82,6 +82,20 @@ static const struct cpumask *cpu_singlet
  */
 static cpumask_var_t cpu_populated_map __read_mostly;
 
+#ifdef CONFIG_WORKQUEUE_TRACER
+static void set_expected_time(struct work_struct *work,
+			      unsigned long expected_jiffies)
+{
+	work->expected_time = expected_jiffies;
+}
+#else
+static void set_expected_time(struct work_struct *work,
+			      unsigned long expected_jiffies)
+{
+}
+#endif
+
+
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_wq_single_threaded(struct workqueue_struct *wq)
 {
@@ -190,6 +204,7 @@ queue_work_on(int cpu, struct workqueue_
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
+		set_expected_time(work, jiffies);
 		__queue_work(wq_per_cpu(wq, cpu), work);
 		ret = 1;
 	}
@@ -251,6 +266,7 @@ int queue_delayed_work_on(int cpu, struc
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
+		set_expected_time(&dwork->work, timer->expires);
 
 		if (unlikely(cpu >= 0))
 			add_timer_on(timer, cpu);
@@ -359,8 +375,8 @@ static void insert_wq_barrier(struct cpu
 {
 	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
-
 	init_completion(&barr->done);
+	set_expected_time(&barr->work, jiffies);
 
 	insert_work(cwq, &barr->work, head);
 }
Index: b/include/linux/workqueue.h
===================================================================
--- a/include/linux/workqueue.h	2009-04-13 12:04:48.000000000 +0900
+++ b/include/linux/workqueue.h	2009-04-13 14:11:06.000000000 +0900
@@ -32,6 +32,9 @@ struct work_struct {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
+#ifdef CONFIG_WORKQUEUE_TRACER
+	unsigned long expected_time;
+#endif
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)


