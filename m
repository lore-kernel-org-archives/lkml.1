Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbZC0Jdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbZC0Jdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZC0JdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:33:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:49663 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbZC0JdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="501272158"
Date: Fri, 27 Mar 2009 09:58:40 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 4/14] x86, ds: wait before freeing the DS configuration
Message-ID: <20090327095840.A11187@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After suspending bts tracing, the task is still traced as long as it is
running. The suspend will take effect when the task is scheduled out.

Wait until the traced task becomes inactive before freeing the DS configuration.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-27 07:59:23.000000000 +0100
+++ git-tip/arch/x86/kernel/ds.c	2009-03-27 08:00:41.000000000 +0100
@@ -783,6 +783,14 @@ void ds_release_bts(struct bts_tracer *t
 
 	ds_suspend_bts(tracer);
 
+	/*
+	 * We must wait for the suspend to take effect before we may
+	 * free the tracer and the ds configuration.
+	 */
+	if (tracer->ds.context->task &&
+	    (tracer->ds.context->task != current))
+		wait_task_inactive(tracer->ds.context->task, 0);
+
 	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
 	tracer->ds.context->bts_master = NULL;
 
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

