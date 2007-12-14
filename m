Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbXLNRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbXLNRAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXLNRAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:00:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:5449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306AbXLNRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:00:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="438986034"
Date: Fri, 14 Dec 2007 17:52:52 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 2/5] x86, ptrace: use jiffies for BTS timestamps
Message-ID: <20071214175252.A20610@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sched_clock() with jiffies for BTS timestamps.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2007-12-10 09:47:57.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2007-12-10 10:11:37.%N +0100
@@ -616,7 +616,7 @@
 {
 	struct bts_struct rec = {
 		.qualifier = qualifier,
-		.variant.timestamp = sched_clock()
+		.variant.jiffies = jiffies
 	};
 
 	if (ptrace_bts_get_buffer_size(tsk) <= 0)
Index: linux-2.6-x86/include/asm-x86/ds.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ds.h	2007-12-10 09:47:57.%N +0100
+++ linux-2.6-x86/include/asm-x86/ds.h	2007-12-10 10:11:37.%N +0100
@@ -48,7 +48,7 @@
 		} lbr;
 		/* BTS_TASK_ARRIVES or
 		   BTS_TASK_DEPARTS */
-		unsigned long long timestamp;
+		unsigned long jiffies;
 	} variant;
 };
 
Index: linux-2.6-x86/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ds.c	2007-12-10 09:13:55.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ds.c	2007-12-10 10:22:43.%N +0100
@@ -167,23 +167,13 @@
 {
 	(*(unsigned char *)(base + ds_cfg.info_type.offset)) = value;
 }
-/*
- * The info data might overlap with the info type on some architectures.
- * We therefore read and write the exact number of bytes.
- */
-static inline unsigned long long get_info_data(char *base)
-{
-	unsigned long long value = 0;
-	memcpy(&value,
-	       base + ds_cfg.info_data.offset,
-	       ds_cfg.info_data.size);
-	return value;
-}
-static inline void set_info_data(char *base, unsigned long long value)
-{
-	memcpy(base + ds_cfg.info_data.offset,
-	       &value,
-	       ds_cfg.info_data.size);
+static inline unsigned long get_info_data(char *base)
+{
+	return *(unsigned long *)(base + ds_cfg.info_data.offset);
+}
+static inline void set_info_data(char *base, unsigned long value)
+{
+	(*(unsigned long *)(base + ds_cfg.info_data.offset)) = value;
 }
 
 
@@ -282,8 +272,8 @@
 
 	memset(out, 0, sizeof(*out));
 	if (get_from_ip(bts) == BTS_ESCAPE_ADDRESS) {
-		out->qualifier         = get_info_type(bts);
-		out->variant.timestamp = get_info_data(bts);
+		out->qualifier       = get_info_type(bts);
+		out->variant.jiffies = get_info_data(bts);
 	} else {
 		out->qualifier = BTS_BRANCH;
 		out->variant.lbr.from_ip = get_from_ip(bts);
@@ -319,7 +309,7 @@
 	case BTS_TASK_DEPARTS:
 		set_from_ip(bts, BTS_ESCAPE_ADDRESS);
 		set_info_type(bts, in->qualifier);
-		set_info_data(bts, in->variant.timestamp);
+		set_info_data(bts, in->variant.jiffies);
 		break;
 
 	default:
@@ -350,7 +340,7 @@
 	.from_ip = { 0, 4 },
 	.to_ip = { 4, 4 },
 	.info_type = { 4, 1 },
-	.info_data = { 5, 7 },
+	.info_data = { 8, 4 },
 	.debugctl_mask = (1<<2)|(1<<3)
 };
 
@@ -364,7 +354,7 @@
 	.from_ip = { 0, 4 },
 	.to_ip = { 4, 4 },
 	.info_type = { 4, 1 },
-	.info_data = { 5, 7 },
+	.info_data = { 8, 4 },
 	.debugctl_mask = (1<<6)|(1<<7)
 };
 #endif /* _i386_ */
@@ -379,7 +369,7 @@
 	.from_ip = { 0, 8 },
 	.to_ip = { 8, 8 },
 	.info_type = { 8, 1 },
-	.info_data = { 9, 7 },
+	.info_data = { 16, 8 },
 	.debugctl_mask = (1<<6)|(1<<7)|(1<<9)
 };
 
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

