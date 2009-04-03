Return-Path: <linux-kernel-owner+w=401wt.eu-S933433AbZDCOsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbZDCOsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932747AbZDCOqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:17417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbZDCOqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:00 -0400
Content-Type: multipart/mixed; boundary="===============0756186246=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328314"
Message-Id: <20090403144553.773216000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:38 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 06/20] x86, bts: use trace_clock_global() for timestamps
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0756186246==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.bts.cpu_clock.patch

Rename the bts_struct timestamp field to event.

Use trace_clock_global() for time measurement.


Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/ds.h |    4 	2 +	2 -	0 !
 arch/x86/kernel/ds.c      |   17 	9 +	8 -	0 !
 2 files changed, 11 insertions(+), 10 deletions(-)

Index: b/arch/x86/include/asm/ds.h
===================================================================
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -170,9 +170,9 @@ struct bts_struct {
 		} lbr;
 		/* BTS_TASK_ARRIVES or BTS_TASK_DEPARTS */
 		struct {
-			__u64 jiffies;
+			__u64 clock;
 			pid_t pid;
-		} timestamp;
+		} event;
 	} variant;
 };
 
Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/trace_clock.h>
 
 #include <asm/ds.h>
 
@@ -471,7 +472,7 @@ enum bts_field {
 	bts_flags,
 
 	bts_qual		= bts_from,
-	bts_jiffies		= bts_to,
+	bts_clock		= bts_to,
 	bts_pid			= bts_flags,
 
 	bts_qual_mask		= (bts_qual_max - 1),
@@ -517,8 +518,8 @@ bts_read(struct bts_tracer *tracer, cons
 	memset(out, 0, sizeof(*out));
 	if ((bts_get(at, bts_qual) & ~bts_qual_mask) == bts_escape) {
 		out->qualifier = (bts_get(at, bts_qual) & bts_qual_mask);
-		out->variant.timestamp.jiffies = bts_get(at, bts_jiffies);
-		out->variant.timestamp.pid = bts_get(at, bts_pid);
+		out->variant.event.clock = bts_get(at, bts_clock);
+		out->variant.event.pid = bts_get(at, bts_pid);
 	} else {
 		out->qualifier = bts_branch;
 		out->variant.lbr.from = bts_get(at, bts_from);
@@ -555,8 +556,8 @@ static int bts_write(struct bts_tracer *
 	case bts_task_arrives:
 	case bts_task_departs:
 		bts_set(raw, bts_qual, (bts_escape | in->qualifier));
-		bts_set(raw, bts_jiffies, in->variant.timestamp.jiffies);
-		bts_set(raw, bts_pid, in->variant.timestamp.pid);
+		bts_set(raw, bts_clock, in->variant.event.clock);
+		bts_set(raw, bts_pid, in->variant.event.pid);
 		break;
 	default:
 		return -EINVAL;
@@ -1083,9 +1084,9 @@ static inline void ds_take_timestamp(str
 		return;
 
 	memset(&ts, 0, sizeof(ts));
-	ts.qualifier			= qualifier;
-	ts.variant.timestamp.jiffies	= jiffies_64;
-	ts.variant.timestamp.pid	= task->pid;
+	ts.qualifier		= qualifier;
+	ts.variant.event.clock	= trace_clock_global();
+	ts.variant.event.pid	= task->pid;
 
 	bts_write(tracer, &ts);
 }

-- 

--===============0756186246==
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

--===============0756186246==--
