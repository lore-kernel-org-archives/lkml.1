Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbZCaNe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbZCaNe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760469AbZCaNdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:33:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:16613 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760444AbZCaNda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677481201"
Date: Tue, 31 Mar 2009 14:42:29 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 0/21] x86, ptrace, bts, hw-branch-tracer: fixes and cleanups
Message-ID: <20090331144229.A11867@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 1-6 fix a number of races when the traced task is currently running.

In the worst case, the kernel may crash since the cpu may continue
tracing after the trace buffer has already been freed.
This may happen when the tracing or traced task are killed.

The first 5 patches apply to .29 with the small preparation patch below.


Patches 7-11 fix problems with the hw-branch-tracer. It performs DS
operations in an on_each_cpu() context, which has interrupts disabled.
Patch 7 adds a _noirq version for most ds_ functions and separates
cpu and task tracing. It allows cpu tracing to be configured from any cpu.
This allows the hw-branch-tracer in patch 8 to remove the bad spinlock
and use simple for_each_online_cpu loops.
The remaining patches change the other DS users to use the new interface.

Patches 12-15 add more selftests, defer selftesting, and fix a bad check.

Patches 16-19 do some cleanups that have been requested from reviewers.

Patch 20 fixes a bug where the wrong qualifier was passed to a shared function
resulting in the bts configuration to be reset when a reset of the pebs
configuration had been requested.

Patch 21 adds support for Core i7.


Thanks to Oleg Nesterov for reviewing the first round of patches and
for pointing out several races!


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6.29/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6.29.orig/arch/x86/kernel/ds.c	2009-03-31 11:56:21.000000000 +0200
+++ linux-2.6.29/arch/x86/kernel/ds.c	2009-03-31 11:57:38.000000000 +0200
@@ -78,8 +78,8 @@ struct bts_tracer {
 	struct ds_tracer ds;
 	/* the trace including the DS configuration */
 	struct bts_trace trace;
-	/* buffer overflow notification function */
-	bts_ovfl_callback_t ovfl;
+	/* Buffer overflow notification function: */
+	bts_ovfl_callback_t	ovfl;
 };
 
 struct pebs_tracer {
Index: linux-2.6.29/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6.29.orig/arch/x86/kernel/ptrace.c	2009-03-31 11:56:21.000000000 +0200
+++ linux-2.6.29/arch/x86/kernel/ptrace.c	2009-03-31 11:56:24.000000000 +0200
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
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

