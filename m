Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZCMJu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZCMJu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZCMJut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:50:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:57848 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZCMJus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:50:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,356,1233561600"; 
   d="scan'208";a="119905376"
Date: Fri, 13 Mar 2009 10:50:27 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 5/5] x86, hw-branch-tracer: add selftest
Message-ID: <20090313105027.A30183@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a selftest for the hw-branch-tracer.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-new/kernel/trace/trace_hw_branches.c
===================================================================
--- git-new.orig/kernel/trace/trace_hw_branches.c	2009-03-12 14:13:14.000000000 +0100
+++ git-new/kernel/trace/trace_hw_branches.c	2009-03-12 14:13:16.000000000 +0100
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
Index: git-new/kernel/trace/trace_selftest.c
===================================================================
--- git-new.orig/kernel/trace/trace_selftest.c	2009-03-12 11:28:42.000000000 +0100
+++ git-new/kernel/trace/trace_selftest.c	2009-03-12 14:13:16.000000000 +0100
@@ -16,6 +16,7 @@ static inline int trace_valid_entry(stru
 	case TRACE_BRANCH:
 	case TRACE_GRAPH_ENT:
 	case TRACE_GRAPH_RET:
+	case TRACE_HW_BRANCHES:
 		return 1;
 	}
 	return 0;
@@ -691,3 +692,55 @@ trace_selftest_startup_branch(struct tra
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
Index: git-new/kernel/trace/trace.h
===================================================================
--- git-new.orig/kernel/trace/trace.h	2009-03-12 11:28:42.000000000 +0100
+++ git-new/kernel/trace/trace.h	2009-03-12 14:13:16.000000000 +0100
@@ -565,6 +565,8 @@ extern int trace_selftest_startup_syspro
 					       struct trace_array *tr);
 extern int trace_selftest_startup_branch(struct tracer *trace,
 					 struct trace_array *tr);
+extern int trace_selftest_startup_hw_branches(struct tracer *trace,
+					      struct trace_array *tr);
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

