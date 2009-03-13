Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZCMJpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZCMJpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZCMJpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:45:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:3303 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZCMJpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:45:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,356,1233561600"; 
   d="scan'208";a="394217611"
Date: Fri, 13 Mar 2009 10:45:07 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 2/5] x86, bts: add selftest for BTS
Message-ID: <20090313104507.A30125@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform a selftest of branch trace store when a cpu is initialized.

WARN and disable branch trace store support if the selftest fails.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/kernel/ds.c
===================================================================
--- gits.orig/arch/x86/kernel/ds.c	2009-03-09 12:43:29.000000000 +0100
+++ gits/arch/x86/kernel/ds.c	2009-03-09 12:43:30.000000000 +0100
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/kernel.h>
 
+#include "ds_selftest.h"
 
 /*
  * The configuration for a particular DS hardware implementation.
@@ -940,6 +941,26 @@ ds_configure(const struct ds_configurati
 		printk(KERN_INFO "[ds] pebs not available\n");
 	}
 
+	if (ds_cfg.sizeof_rec[ds_bts]) {
+		int error;
+
+		error = ds_selftest_bts();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling bts.\n");
+			ds_cfg.sizeof_rec[ds_bts] = 0;
+		}
+	}
+
+	if (ds_cfg.sizeof_rec[ds_pebs]) {
+		int error;
+
+		error = ds_selftest_pebs();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling pebs.\n");
+			ds_cfg.sizeof_rec[ds_pebs] = 0;
+		}
+	}
+
 	printk(KERN_INFO "[ds] sizes: address: %u bit, ",
 	       8 * ds_cfg.sizeof_ptr_field);
 	printk("bts/pebs record: %u/%u bytes\n",
Index: gits/arch/x86/Kconfig.debug
===================================================================
--- gits.orig/arch/x86/Kconfig.debug	2009-03-09 12:43:25.000000000 +0100
+++ gits/arch/x86/Kconfig.debug	2009-03-09 12:43:30.000000000 +0100
@@ -176,6 +176,15 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config X86_DS_SELFTEST
+    bool "DS selftest"
+    default y
+    depends on DEBUG_KERNEL
+    depends on X86_DS
+	---help---
+	  Perform Debug Store selftests at boot time.
+	  If in doubt, say "N".
+
 config HAVE_MMIOTRACE_SUPPORT
 	def_bool y
 
Index: gits/arch/x86/kernel/ds_selftest.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ gits/arch/x86/kernel/ds_selftest.c	2009-03-09 12:43:30.000000000 +0100
@@ -0,0 +1,241 @@
+/*
+ * Debug Store support - selftest
+ *
+ *
+ * Copyright (C) 2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2009
+ */
+
+#include "ds_selftest.h"
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+#include <asm/ds.h>
+
+
+#define DS_SELFTEST_BUFFER_SIZE 1021 /* Intentionally chose an odd size. */
+
+
+static int ds_selftest_bts_consistency(const struct bts_trace *trace)
+{
+	int error = 0;
+
+	if (!trace) {
+		printk(KERN_CONT "failed to access trace...");
+		/* Bail out. Other tests are pointless. */
+		return -1;
+	}
+
+	if (!trace->read) {
+		printk(KERN_CONT "bts read not available...");
+		error = -1;
+	}
+
+	/* Do some sanity checks on the trace configuration. */
+	if (!trace->ds.n) {
+		printk(KERN_CONT "empty bts buffer...");
+		error = -1;
+	}
+	if (!trace->ds.size) {
+		printk(KERN_CONT "bad bts trace setup...");
+		error = -1;
+	}
+	if (trace->ds.end !=
+	    (char *)trace->ds.begin + (trace->ds.n * trace->ds.size)) {
+		printk(KERN_CONT "bad bts buffer setup...");
+		error = -1;
+	}
+	if ((trace->ds.top < trace->ds.begin) ||
+	    (trace->ds.end <= trace->ds.top)) {
+		printk(KERN_CONT "bts top out of bounds...");
+		error = -1;
+	}
+
+	return error;
+}
+
+static int ds_selftest_bts_read(struct bts_tracer *tracer,
+				const struct bts_trace *trace,
+				const void *from, const void *to)
+{
+	const unsigned char *at;
+
+	/*
+	 * Check a few things which do not belong to this test.
+	 * They should be covered by other tests.
+	 */
+	if (!trace)
+		return -1;
+
+	if (!trace->read)
+		return -1;
+
+	if (to < from)
+		return -1;
+
+	if (from < trace->ds.begin)
+		return -1;
+
+	if (trace->ds.end < to)
+		return -1;
+
+	if (!trace->ds.size)
+		return -1;
+
+	/* Now to the test itself. */
+	for (at = from; (void *)at < to; at += trace->ds.size) {
+		struct bts_struct bts;
+		size_t index;
+		int error;
+
+		if (((void *)at - trace->ds.begin) % trace->ds.size) {
+			printk(KERN_CONT
+			       "read from non-integer index...");
+			return -1;
+		}
+		index = ((void *)at - trace->ds.begin) / trace->ds.size;
+
+		memset(&bts, 0, sizeof(bts));
+		error = trace->read(tracer, at, &bts);
+		if (error < 0) {
+			printk(KERN_CONT
+			       "error reading bts trace at [%lu] (0x%p)...",
+			       index, at);
+			return error;
+		}
+
+		switch (bts.qualifier) {
+		case BTS_BRANCH:
+			break;
+		default:
+			printk(KERN_CONT
+			       "unexpected bts entry %llu at [%lu] (0x%p)...",
+			       bts.qualifier, index, at);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+int ds_selftest_bts(void)
+{
+	const struct bts_trace *trace;
+	struct bts_tracer *tracer;
+	int error = 0;
+	void *top;
+	unsigned char buffer[DS_SELFTEST_BUFFER_SIZE];
+
+	printk(KERN_INFO "[ds] bts selftest...");
+
+	tracer = ds_request_bts(NULL, buffer, DS_SELFTEST_BUFFER_SIZE,
+				NULL, (size_t)-1, BTS_KERNEL);
+	if (IS_ERR(tracer)) {
+		error = PTR_ERR(tracer);
+		tracer = NULL;
+
+		printk(KERN_CONT
+		       "initialization failed (err: %d)...", error);
+		goto out;
+	}
+
+	/* The return should already give us enough trace. */
+	ds_suspend_bts(tracer);
+
+	/* Let's see if we can access the trace. */
+	trace = ds_read_bts(tracer);
+
+	error = ds_selftest_bts_consistency(trace);
+	if (error < 0)
+		goto out;
+
+	/* If everything went well, we should have a few trace entries. */
+	if (trace->ds.top == trace->ds.begin) {
+		/*
+		 * It is possible but highly unlikely that we got a
+		 * buffer overflow and end up at exactly the same
+		 * position we started from.
+		 * Let's issue a warning, but continue.
+		 */
+		printk(KERN_CONT "no trace/overflow...");
+	}
+
+	/* Let's try to read the trace we collected. */
+	error = ds_selftest_bts_read(tracer, trace,
+				     trace->ds.begin, trace->ds.top);
+	if (error < 0)
+		goto out;
+
+	/*
+	 * Let's read the trace again.
+	 * Since we suspended tracing, we should get the same result.
+	 */
+	top = trace->ds.top;
+
+	trace = ds_read_bts(tracer);
+	error = ds_selftest_bts_consistency(trace);
+	if (error < 0)
+		goto out;
+
+	if (top != trace->ds.top) {
+		printk(KERN_CONT "suspend not working...");
+		error = -1;
+		goto out;
+	}
+
+	/* Let's collect some more trace - see if resume is working. */
+	ds_resume_bts(tracer);
+	ds_suspend_bts(tracer);
+
+	trace = ds_read_bts(tracer);
+
+	error = ds_selftest_bts_consistency(trace);
+	if (error < 0)
+		goto out;
+
+	if (trace->ds.top == top) {
+		/*
+		 * It is possible but highly unlikely that we got a
+		 * buffer overflow and end up at exactly the same
+		 * position we started from.
+		 * Let's issue a warning and check the full trace.
+		 */
+		printk(KERN_CONT
+		       "no resume progress/overflow...");
+
+		error = ds_selftest_bts_read(tracer, trace,
+					     trace->ds.begin, trace->ds.end);
+	} else if (trace->ds.top < top) {
+		/*
+		 * We had a buffer overflow - the entire buffer should
+		 * contain trace records.
+		 */
+		error = ds_selftest_bts_read(tracer, trace,
+					     trace->ds.begin, trace->ds.end);
+	} else {
+		/*
+		 * It is quite likely that the buffer did not overflow.
+		 * Let's just check the delta trace.
+		 */
+		error = ds_selftest_bts_read(tracer, trace,
+					     top, trace->ds.top);
+	}
+	if (error < 0)
+		goto out;
+
+	error = 0;
+
+	/* The final test: release the tracer while tracing is suspended. */
+ out:
+	ds_release_bts(tracer);
+
+	printk(KERN_CONT "%s.\n", (error ? "failed" : "passed"));
+
+	return error;
+}
+
+int ds_selftest_pebs(void)
+{
+	return 0;
+}
Index: gits/arch/x86/kernel/ds_selftest.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ gits/arch/x86/kernel/ds_selftest.h	2009-03-09 12:43:51.000000000 +0100
@@ -0,0 +1,15 @@
+/*
+ * Debug Store support - selftest
+ *
+ *
+ * Copyright (C) 2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2009
+ */
+
+#ifdef CONFIG_X86_DS_SELFTEST
+extern int ds_selftest_bts(void);
+extern int ds_selftest_pebs(void);
+#else
+static inline int ds_selftest_bts(void) { return 0; }
+static inline int ds_selftest_pebs(void) { return 0; }
+#endif /* CONFIG_X86_DS_SELFTEST */
Index: gits/arch/x86/kernel/Makefile
===================================================================
--- gits.orig/arch/x86/kernel/Makefile	2009-03-09 12:43:25.000000000 +0100
+++ gits/arch/x86/kernel/Makefile	2009-03-09 12:43:30.000000000 +0100
@@ -44,6 +44,7 @@ obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
 obj-$(CONFIG_X86_DS)		+= ds.o
+obj-$(CONFIG_X86_DS_SELFTEST)		+= ds_selftest.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
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

