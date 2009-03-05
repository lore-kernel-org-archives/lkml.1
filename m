Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZCEPcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZCEPcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZCEPb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:31:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:16908 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbZCEPb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:31:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,307,1233561600"; 
   d="scan'208";a="391940601"
Date: Thu, 5 Mar 2009 16:31:49 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com, srostedt@redhat.com
Subject: [patch 4/4] x86, hw-branch-tracer: add selftest
Message-ID: <20090305163149.A9720@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a selftest to the hw-branch-tracer.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/kernel/trace/trace_hw_branches.c
===================================================================
--- gits.orig/kernel/trace/trace_hw_branches.c	2009-03-03 10:45:35.000000000 +0100
+++ gits/kernel/trace/trace_hw_branches.c	2009-03-03 10:50:04.000000000 +0100
@@ -344,7 +344,10 @@ struct tracer bts_tracer __read_mostly =
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
Index: gits/kernel/trace/trace_selftest.c
===================================================================
--- gits.orig/kernel/trace/trace_selftest.c	2009-03-03 09:32:43.000000000 +0100
+++ gits/kernel/trace/trace_selftest.c	2009-03-03 10:51:27.000000000 +0100
@@ -15,6 +15,7 @@ static inline int trace_valid_entry(stru
 	case TRACE_BRANCH:
 	case TRACE_GRAPH_ENT:
 	case TRACE_GRAPH_RET:
+	case TRACE_HW_BRANCHES:
 		return 1;
 	}
 	return 0;
@@ -693,3 +694,56 @@ trace_selftest_startup_branch(struct tra
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
+	/* start the tracing */
+	ret = tracer_init(trace, tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
+	/* the hw-branch tracer needs to collect the trace from the various
+	 * cpu trace buffers - before tracing is stopped. */
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
+	/* stop the tracing. */
+	tracing_stop();
+
+	/* check the trace buffer */
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
Index: gits/kernel/trace/trace.h
===================================================================
--- gits.orig/kernel/trace/trace.h	2009-03-03 09:32:43.000000000 +0100
+++ gits/kernel/trace/trace.h	2009-03-03 10:50:04.000000000 +0100
@@ -555,6 +555,8 @@ extern int trace_selftest_startup_syspro
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

