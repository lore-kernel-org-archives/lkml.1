Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbZDCOt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbZDCOt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbZDCOqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:65184 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbZDCOqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:03 -0400
Content-Type: multipart/mixed; boundary="===============1659026938=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328339"
Message-Id: <20090403144556.578777000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:41 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 09/20] x86, hw-branch-tracer: allocate selftest iterator on heap
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1659026938==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.hw-branch-tracer.selftest_alloc.patch

Allocate the trace_iterator for the hw-branch-tracer selftest on the heap.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 kernel/trace/trace_selftest.c |   20 	12 +	8 -	0 !
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: b/kernel/trace/trace_selftest.c
===================================================================
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -699,7 +699,7 @@ int
 trace_selftest_startup_hw_branches(struct tracer *trace,
 				   struct trace_array *tr)
 {
-	struct trace_iterator iter;
+	struct trace_iterator *iter;
 	struct tracer tracer;
 	unsigned long count;
 	int ret;
@@ -719,17 +719,21 @@ trace_selftest_startup_hw_branches(struc
 	 * The hw-branch tracer needs to collect the trace from the various
 	 * cpu trace buffers - before tracing is stopped.
 	 */
-	memset(&iter, 0, sizeof(iter));
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
 	memcpy(&tracer, trace, sizeof(tracer));
 
-	iter.trace = &tracer;
-	iter.tr = tr;
-	iter.pos = -1;
-	mutex_init(&iter.mutex);
+	iter->trace = &tracer;
+	iter->tr = tr;
+	iter->pos = -1;
+	mutex_init(&iter->mutex);
 
-	trace->open(&iter);
+	trace->open(iter);
 
-	mutex_destroy(&iter.mutex);
+	mutex_destroy(&iter->mutex);
+	kfree(iter);
 
 	tracing_stop();
 

-- 

--===============1659026938==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

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

--===============1659026938==--
