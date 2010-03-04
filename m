Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0CDQdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:33:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:46393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab0CDQdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:33:38 -0500
Date: Thu, 4 Mar 2010 16:33:07 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267667418-32233-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267667418-32233-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu, ftrace: Fix RCU lockdep splat in ftrace_perf_buf_prepare()
Message-ID: <tip-8d53dd546f36073e0d29b0cfc24c665db301e3e7@git.kernel.org>
Git-Commit-ID: 8d53dd546f36073e0d29b0cfc24c665db301e3e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:33:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d53dd546f36073e0d29b0cfc24c665db301e3e7
Gitweb:     http://git.kernel.org/tip/8d53dd546f36073e0d29b0cfc24c665db301e3e7
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 3 Mar 2010 17:50:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:07:35 +0100

rcu, ftrace: Fix RCU lockdep splat in ftrace_perf_buf_prepare()

Change the pair of rcu_dereference() calls in
ftrace_perf_buf_prepare() to rcu_dereference_sched().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1267667418-32233-3-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
