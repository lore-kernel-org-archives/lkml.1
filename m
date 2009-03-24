Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbZCXP3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbZCXP3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760639AbZCXP2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:28:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680AbZCXP2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:28:11 -0400
Date: Tue, 24 Mar 2009 11:28:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH][GIT PULL] function-graph: add option for include sleep
 times
In-Reply-To: <20090324135833.GB32043@elte.hu>
Message-ID: <alpine.DEB.2.00.0903241127290.22830@gandalf.stny.rr.com>
References: <20090324135422.026619569@goodmis.org> <20090324135610.441707783@goodmis.org> <20090324135833.GB32043@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      function-graph: add option for include sleep times

----
 kernel/trace/ftrace.c |    7 +++++++
 kernel/trace/trace.c  |    3 ++-
 kernel/trace/trace.h  |    1 +
 3 files changed, 10 insertions(+), 1 deletions(-)
---------------------------
commit be6f164a02f394675e2ac2077dd354cebef5b4c0
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Mar 24 11:06:24 2009 -0400

    function-graph: add option for include sleep times
    
    Impact: give user a choice to show times spent while sleeping
    
    The user may want to see the time a function spent sleeping.
    This patch adds the trace option "sleep-time" to allow that.
    The "sleep-time" option is default on.
    
     echo sleep-time > /debug/tracing/trace_options
    
    produces:
    
     ------------------------------------------
     2)  avahi-d-3428  =>    <idle>-0
     ------------------------------------------
    
     2)               |      finish_task_switch() {
     2)   0.621 us    |        _spin_unlock_irq();
     2)   2.202 us    |      }
     2) ! 1002.197 us |    }
     2) ! 1003.521 us |  }
    
    where as,
    
     echo nosleep-time > /debug/tracing/trace_options
    
    produces:
    
     0)    <idle>-0    =>  yum-upd-3416
     ------------------------------------------
    
     0)               |              finish_task_switch() {
     0)   0.643 us    |                _spin_unlock_irq();
     0)   2.342 us    |              }
     0) + 41.302 us   |            }
     0) + 42.453 us   |          }
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0b90364..02d2de9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2599,6 +2599,13 @@ ftrace_graph_probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	unsigned long long timestamp;
 	int index;
 
+	/*
+	 * Does the user want to count the time a function was asleep.
+	 * If so, do not update the time stamps.
+	 */
+	if (trace_flags & TRACE_ITER_SLEEP_TIME)
+		return;
+
 	timestamp = trace_clock_local();
 
 	prev->ftrace_timestamp = timestamp;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f0e1337..67c6a21 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -255,7 +255,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
+	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -316,6 +316,7 @@ static const char *trace_options[] = {
 	"context-info",
 	"latency-format",
 	"global-clock",
+	"sleep-time",
 	NULL
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7cfb741..d7410bb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -683,6 +683,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
 	TRACE_ITER_LATENCY_FMT		= 0x40000,
 	TRACE_ITER_GLOBAL_CLK		= 0x80000,
+	TRACE_ITER_SLEEP_TIME		= 0x100000,
 };
 
 /*


