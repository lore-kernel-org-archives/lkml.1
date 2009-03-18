Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZCRS1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZCRS1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbZCRS1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:27:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:7302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbZCRS1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,385,1233561600"; 
   d="scan'208";a="440006047"
Date: Wed, 18 Mar 2009 19:27:00 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch] x86, bts: use atomic memory allocation
Message-ID: <20090318192700.A6038@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ds_request_bts() needs to allocate memory. It uses GFP_KERNEL.

Hw-branch-tracer calls ds_request_bts() within on_each_cpu().

Use atomic memory allocation to allow it to be used in that context.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-17 12:26:07.000000000 +0100
+++ git-tip/arch/x86/kernel/ds.c	2009-03-17 13:30:09.000000000 +0100
@@ -255,8 +255,13 @@ static inline struct ds_context *ds_get_
 	struct ds_context *new_context = NULL;
 	unsigned long irq;
 
-	/* Chances are small that we already have a context. */
-	new_context = kzalloc(sizeof(*new_context), GFP_KERNEL);
+	/*
+	 * Chances are small that we already have a context.
+	 *
+	 * Contexts for per-cpu tracing are allocated using
+	 * smp_call_function(). We must not sleep.
+	 */
+	new_context = kzalloc(sizeof(*new_context), GFP_ATOMIC);
 	if (!new_context)
 		return NULL;
 
@@ -662,8 +667,12 @@ struct bts_tracer *ds_request_bts(struct
 	if (ovfl)
 		goto out;
 
+	/*
+	 * Per-cpu tracing is typically requested using smp_call_function().
+	 * We must not sleep.
+	 */
 	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
 		goto out;
 	tracer->ovfl = ovfl;
@@ -722,8 +731,12 @@ struct pebs_tracer *ds_request_pebs(stru
 	if (ovfl)
 		goto out;
 
+	/*
+	 * Per-cpu tracing is typically requested using smp_call_function().
+	 * We must not sleep.
+	 */
 	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
 		goto out;
 	tracer->ovfl = ovfl;
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

