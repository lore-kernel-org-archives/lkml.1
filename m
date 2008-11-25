Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYKYIMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYKYIMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYKYIMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:12:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:4984 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751939AbYKYIMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:12:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="467050944"
Date: Tue, 25 Nov 2008 09:12:31 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 8/9] x86, ftrace: call trace->open() before stopping tracing; add trace->print_header()
Message-ID: <20081125091231.A31411@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a callback to allow an ftrace plug-in to write its own header.

Move the call to trace->open() up a few lines.

The changes are required by the BTS ftrace plug-in.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/kernel/trace/trace.c
===================================================================
--- ftrace.orig/kernel/trace/trace.c	2008-11-24 13:46:26.000000000 +0100
+++ ftrace/kernel/trace/trace.c	2008-11-25 08:18:05.000000000 +0100
@@ -2298,7 +2298,9 @@
 			seq_printf(m, "# tracer: %s\n", iter->trace->name);
 			seq_puts(m, "#\n");
 		}
-		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
+		if (iter->trace && iter->trace->print_header)
+			iter->trace->print_header(m);
+		else if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
 			/* print nothing if the buffers are empty */
 			if (trace_empty(iter))
 				return 0;
@@ -2350,6 +2352,10 @@
 	iter->trace = current_trace;
 	iter->pos = -1;
 
+	/* Notify the tracer early; before we stop tracing. */
+	if (iter->trace && iter->trace->open)
+			iter->trace->open(iter);
+
 	/* Annotate start of buffers if we had overruns */
 	if (ring_buffer_overruns(iter->tr->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
@@ -2375,9 +2381,6 @@
 	/* stop the trace while dumping */
 	tracing_stop();
 
-	if (iter->trace && iter->trace->open)
-			iter->trace->open(iter);
-
 	mutex_unlock(&trace_types_lock);
 
  out:
Index: ftrace/kernel/trace/trace.h
===================================================================
--- ftrace.orig/kernel/trace/trace.h	2008-11-24 13:46:26.000000000 +0100
+++ ftrace/kernel/trace/trace.h	2008-11-25 08:18:05.000000000 +0100
@@ -311,6 +311,7 @@
 	int			(*selftest)(struct tracer *trace,
 					    struct trace_array *tr);
 #endif
+	void			(*print_header)(struct seq_file *m);
 	enum print_line_t	(*print_line)(struct trace_iterator *iter);
 	/* If you handled the flag setting, return 0 */
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
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

