Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbZCMLCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbZCMLCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbZCMLBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:01:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651AbZCMLBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:01:54 -0400
Date: Fri, 13 Mar 2009 11:01:06 GMT
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313105027.A30183@sedona.ch.intel.com>
References: <20090313105027.A30183@sedona.ch.intel.com>
Subject: [tip:tracing/hw-branch-tracing] x86, hw-branch-tracer: add selftest
Message-ID: <tip-321bb5e1ac461c04b6a93f795010d6eb01d8c5ca@git.kernel.org>
Git-Commit-ID: 321bb5e1ac461c04b6a93f795010d6eb01d8c5ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 11:01:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  321bb5e1ac461c04b6a93f795010d6eb01d8c5ca
Gitweb:     http://git.kernel.org/tip/321bb5e1ac461c04b6a93f795010d6eb01d8c5ca
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 13 Mar 2009 10:50:27 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:57:21 +0100

x86, hw-branch-tracer: add selftest

Add a selftest for the hw-branch-tracer.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090313105027.A30183@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.h             |    2 +
 kernel/trace/trace_hw_branches.c |    5 +++-
 kernel/trace/trace_selftest.c    |   53 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 56ce34d..e7fbc82 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -576,6 +576,8 @@ extern int trace_selftest_startup_sysprof(struct tracer *trace,
 					       struct trace_array *tr);
 extern int trace_selftest_startup_branch(struct tracer *trace,
 					 struct trace_array *tr);
+extern int trace_selftest_startup_hw_branches(struct tracer *trace,
+					      struct trace_array *tr);
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index a99a04c..4ca8270 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -342,7 +342,10 @@ struct tracer bts_tracer __read_mostly =
 	.start		= bts_trace_start,
 	.stop		= bts_trace_stop,
 	.open		= trace_bts_prepare,
-	.close		= trace_bts_close
+	.close		= trace_bts_close,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_hw_branches,
+#endif /* CONFIG_FTRACE_SELFTEST */
 };
 
 __init static int init_bts_trace(void)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index f907a2b..3c7b797 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -16,6 +16,7 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	case TRACE_BRANCH:
 	case TRACE_GRAPH_ENT:
 	case TRACE_GRAPH_RET:
+	case TRACE_HW_BRANCHES:
 		return 1;
 	}
 	return 0;
@@ -691,3 +692,55 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	return ret;
 }
 #endif /* CONFIG_BRANCH_TRACER */
+
+#ifdef CONFIG_HW_BRANCH_TRACER
+int
+trace_selftest_startup_hw_branches(struct tracer *trace,
+				   struct trace_array *tr)
+{
+	unsigned long count;
+	int ret;
+	struct trace_iterator iter;
+	struct tracer tracer;
+
+	if (!trace->open) {
+		printk(KERN_CONT "missing open function...");
+		return -1;
+	}
+
+	ret = tracer_init(trace, tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
+	/*
+	 * The hw-branch tracer needs to collect the trace from the various
+	 * cpu trace buffers - before tracing is stopped.
+	 */
+	memset(&iter, 0, sizeof(iter));
+	memcpy(&tracer, trace, sizeof(tracer));
+
+	iter.trace = &tracer;
+	iter.tr = tr;
+	iter.pos = -1;
+	mutex_init(&iter.mutex);
+
+	trace->open(&iter);
+
+	mutex_destroy(&iter.mutex);
+
+	tracing_stop();
+
+	ret = trace_test_buffer(tr, &count);
+	trace->reset(tr);
+	tracing_start();
+
+	if (!ret && !count) {
+		printk(KERN_CONT "no entries found..");
+		ret = -1;
+	}
+
+	return ret;
+}
+#endif /* CONFIG_HW_BRANCH_TRACER */
