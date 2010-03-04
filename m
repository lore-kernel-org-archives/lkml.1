Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0CDBuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:50:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53046 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab0CDBuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:50:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH tip/core/rcu 3/3] rcu, ftrace: fix RCU lockdep splat in ftrace_perf_buf_prepare()
Date: Wed,  3 Mar 2010 17:50:18 -0800
Message-Id: <1267667418-32233-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100304015001.GA32190@linux.vnet.ibm.com>
References: <20100304015001.GA32190@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the pair of rcu_dereference() calls in ftrace_perf_buf_prepare()
to rcu_dereference_sched().

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/ftrace.h             |    4 ++--
 kernel/trace/trace_event_profile.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 0804cd5..601ad77 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -699,9 +699,9 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *	__cpu = smp_processor_id();
  *
  *	if (in_nmi())
- *		trace_buf = rcu_dereference(perf_trace_buf_nmi);
+ *		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
  *	else
- *		trace_buf = rcu_dereference(perf_trace_buf);
+ *		trace_buf = rcu_dereference_sched(perf_trace_buf);
  *
  *	if (!trace_buf)
  *		goto end;
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index f0d6930..c1cc3ab 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -138,9 +138,9 @@ __kprobes void *ftrace_perf_buf_prepare(int size, unsigned short type,
 	cpu = smp_processor_id();
 
 	if (in_nmi())
-		trace_buf = rcu_dereference(perf_trace_buf_nmi);
+		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
 	else
-		trace_buf = rcu_dereference(perf_trace_buf);
+		trace_buf = rcu_dereference_sched(perf_trace_buf);
 
 	if (!trace_buf)
 		goto err;
-- 
1.6.6

