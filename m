Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZCZBIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZCZBIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZCZBIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:08:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZCZBIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:08:14 -0400
Message-Id: <20090326010811.510051401@goodmis.org>
References: <20090326010737.611522983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 21:07:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] tracing: add average time in function to function profiler
Content-Disposition: inline; filename=0002-tracing-add-average-time-in-function-to-function-pr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Show the average time in the function (Time / Hit)

  Function                               Hit    Time            Avg
  --------                               ---    ----            ---
  mwait_idle                              51    140326.6 us     2751.503 us
  smp_apic_timer_interrupt                47    3517.735 us     74.845 us
  schedule                                10    2738.754 us     273.875 us
  __schedule                              10    2732.857 us     273.285 us
  hrtimer_interrupt                       47    1896.104 us     40.342 us
  irq_exit                                56    1711.833 us     30.568 us
  __run_hrtimer                           47    1315.589 us     27.991 us
  tick_sched_timer                        47    1138.690 us     24.227 us
  do_softirq                              56    1116.829 us     19.943 us
  __do_softirq                            56    1066.932 us     19.052 us
  do_IRQ                                   9    926.153 us      102.905 us

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4d90c91..c7f4a4b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -347,8 +347,10 @@ static int function_stat_cmp(void *p1, void *p2)
 static int function_stat_headers(struct seq_file *m)
 {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	seq_printf(m, "  Function                               Hit    Time\n"
-		      "  --------                               ---    ----\n");
+	seq_printf(m, "  Function                               "
+		   "Hit    Time            Avg\n"
+		      "  --------                               "
+		   "---    ----            ---\n");
 #else
 	seq_printf(m, "  Function                               Hit\n"
 		      "  --------                               ---\n");
@@ -361,12 +363,9 @@ static int function_stat_show(struct seq_file *m, void *v)
 	struct ftrace_profile *rec = v;
 	char str[KSYM_SYMBOL_LEN];
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	static struct trace_seq s;
 	static DEFINE_MUTEX(mutex);
-
-	mutex_lock(&mutex);
-	trace_seq_init(&s);
-	trace_print_graph_duration(rec->time, &s);
+	static struct trace_seq s;
+	unsigned long long avg;
 #endif
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
@@ -374,6 +373,14 @@ static int function_stat_show(struct seq_file *m, void *v)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	seq_printf(m, "    ");
+	avg = rec->time;
+	do_div(avg, rec->counter);
+
+	mutex_lock(&mutex);
+	trace_seq_init(&s);
+	trace_print_graph_duration(rec->time, &s);
+	trace_seq_puts(&s, "    ");
+	trace_print_graph_duration(avg, &s);
 	trace_print_seq(m, &s);
 	mutex_unlock(&mutex);
 #endif
-- 
1.6.2

-- 
