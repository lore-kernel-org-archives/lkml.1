Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZC0JTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZC0JTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZC0JT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:19:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:25871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZC0JT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="124823423"
Date: Fri, 27 Mar 2009 10:19:17 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 10/14] x86, ds: add ds selftests for task tracing
Message-ID: <20090327101917.A11582@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add selftests for tracing the current task.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds_selftest.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds_selftest.c	2009-03-26 10:39:24.000000000 +0100
+++ git-tip/arch/x86/kernel/ds_selftest.c	2009-03-26 10:39:25.000000000 +0100
@@ -284,6 +284,7 @@ int ds_selftest_bts(void)
 {
 	struct ds_selftest_bts_conf conf;
 	unsigned char buffer[BUFFER_SIZE];
+	unsigned long irq;
 	int cpu;
 
 	printk(KERN_INFO "[ds] bts selftest...");
@@ -321,6 +322,28 @@ int ds_selftest_bts(void)
 			goto out;
 	}
 
+	conf.suspend = ds_suspend_bts_wrap;
+	conf.resume = ds_resume_bts_wrap;
+	conf.tracer =
+		ds_request_bts_task(current, buffer, BUFFER_SIZE,
+				    NULL, (size_t)-1, BTS_KERNEL);
+	ds_selftest_bts_cpu(&conf);
+	ds_release_bts(conf.tracer);
+	if (conf.error < 0)
+		goto out;
+
+	conf.suspend = ds_suspend_bts_noirq;
+	conf.resume = ds_resume_bts_noirq;
+	conf.tracer =
+		ds_request_bts_task(current, buffer, BUFFER_SIZE,
+				   NULL, (size_t)-1, BTS_KERNEL);
+	local_irq_save(irq);
+	ds_selftest_bts_cpu(&conf);
+	ds_release_bts_noirq(conf.tracer);
+	local_irq_restore(irq);
+	if (conf.error < 0)
+		goto out;
+
 	conf.error = 0;
  out:
 	put_online_cpus();
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

