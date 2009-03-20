Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbZCTK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbZCTK1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbZCTKZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:25:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:35213 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762297AbZCTKZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:25:56 -0400
Date: Fri, 20 Mar 2009 10:25:17 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.744044174@chello.nl>
References: <20090319194233.744044174@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: hook up the tracepoint events
Message-ID: <tip-ee78a855ff4d8d3d77b46696994dca393228bb8a@git.kernel.org>
Git-Commit-ID: ee78a855ff4d8d3d77b46696994dca393228bb8a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:25:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee78a855ff4d8d3d77b46696994dca393228bb8a
Gitweb:     http://git.kernel.org/tip/ee78a855ff4d8d3d77b46696994dca393228bb8a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:15:12 +0100

perf_counter: hook up the tracepoint events

Impact: new perfcounters feature

Enable usage of tracepoints as perf counter events.

tracepoint event ids can be found in /debug/tracing/event/*/*/id
and (for now) are represented as -65536+id in the type field.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.744044174@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    3 ++
 init/Kconfig                 |    5 ++++
 kernel/perf_counter.c        |   43 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 08c11a6..065984c 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -53,6 +53,8 @@ enum hw_event_types {
 	PERF_COUNT_PAGE_FAULTS_MAJ	= -7,
 
 	PERF_SW_EVENTS_MIN		= -8,
+
+	PERF_TP_EVENTS_MIN		= -65536
 };
 
 /*
@@ -222,6 +224,7 @@ struct perf_counter {
 	struct perf_data		*usrdata;
 	struct perf_data		data[2];
 
+	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
 #endif
 };
diff --git a/init/Kconfig b/init/Kconfig
index 8a38443..761129a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -945,6 +945,11 @@ config PERF_COUNTERS
 
 	  Say Y if unsure.
 
+config EVENT_PROFILE
+	bool "Tracepoint profile sources"
+	depends on PERF_COUNTERS && EVENT_TRACER
+	default y
+
 endmenu
 
 config VM_EVENT_COUNTERS
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 97f891f..0bbe3e4 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1152,6 +1152,9 @@ static void free_counter_rcu(struct rcu_head *head)
 
 static void free_counter(struct perf_counter *counter)
 {
+	if (counter->destroy)
+		counter->destroy(counter);
+
 	call_rcu(&counter->rcu_head, free_counter_rcu);
 }
 
@@ -1727,6 +1730,45 @@ static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
 	.read		= cpu_migrations_perf_counter_read,
 };
 
+#ifdef CONFIG_EVENT_PROFILE
+void perf_tpcounter_event(int event_id)
+{
+	perf_swcounter_event(PERF_TP_EVENTS_MIN + event_id, 1, 1,
+			task_pt_regs(current));
+}
+
+extern int ftrace_profile_enable(int);
+extern void ftrace_profile_disable(int);
+
+static void tp_perf_counter_destroy(struct perf_counter *counter)
+{
+	int event_id = counter->hw_event.type - PERF_TP_EVENTS_MIN;
+
+	ftrace_profile_disable(event_id);
+}
+
+static const struct hw_perf_counter_ops *
+tp_perf_counter_init(struct perf_counter *counter)
+{
+	int event_id = counter->hw_event.type - PERF_TP_EVENTS_MIN;
+	int ret;
+
+	ret = ftrace_profile_enable(event_id);
+	if (ret)
+		return NULL;
+
+	counter->destroy = tp_perf_counter_destroy;
+
+	return &perf_ops_generic;
+}
+#else
+static const struct hw_perf_counter_ops *
+tp_perf_counter_init(struct perf_counter *counter)
+{
+	return NULL;
+}
+#endif
+
 static const struct hw_perf_counter_ops *
 sw_perf_counter_init(struct perf_counter *counter)
 {
@@ -1772,6 +1814,7 @@ sw_perf_counter_init(struct perf_counter *counter)
 			hw_ops = &perf_ops_cpu_migrations;
 		break;
 	default:
+		hw_ops = tp_perf_counter_init(counter);
 		break;
 	}
 
