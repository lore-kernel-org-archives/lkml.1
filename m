Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZBXMzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZBXMzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZBXMza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:55:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:16368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZBXMz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:55:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,259,1233561600"; 
   d="scan'208";a="433695583"
Date: Tue, 24 Feb 2009 13:55:18 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com, fweisbec@gmail.com, rakib.mullick@gmail.com
Subject: [patch] x86, ftrace: fix section mismatch in hw-branch-tracer
Message-ID: <20090224135518.A4180@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an invalid memory reference problem when cpu hotplug support is
disabled and the hw-branch-tracer is set as current tracer.

Initializing the tracer calls bts_trace_init() which has already
been freed at this time.


Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/kernel/trace/trace_hw_branches.c
===================================================================
--- ftrace.orig/kernel/trace/trace_hw_branches.c	2009-02-23 11:01:34.000000000 +0100
+++ ftrace/kernel/trace/trace_hw_branches.c	2009-02-23 11:21:48.000000000 +0100
@@ -127,20 +127,18 @@ static struct notifier_block bts_hotcpu_
 	.notifier_call = bts_hotcpu_handler
 };
 
-static int __cpuinit bts_trace_init(struct trace_array *tr)
+static int bts_trace_init(struct trace_array *tr)
 {
 	hw_branch_trace = tr;
 
-	register_hotcpu_notifier(&bts_hotcpu_notifier);
 	bts_trace_start(tr);
 
 	return 0;
 }
 
-static void __cpuinit bts_trace_reset(struct trace_array *tr)
+static void bts_trace_reset(struct trace_array *tr)
 {
 	bts_trace_stop(tr);
-	unregister_hotcpu_notifier(&bts_hotcpu_notifier);
 }
 
 static void bts_trace_print_header(struct seq_file *m)
@@ -299,6 +297,7 @@ struct tracer bts_tracer __read_mostly =
 
 __init static int init_bts_trace(void)
 {
+	register_hotcpu_notifier(&bts_hotcpu_notifier);
 	return register_tracer(&bts_tracer);
 }
 device_initcall(init_bts_trace);
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

