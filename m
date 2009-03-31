Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbZCaOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbZCaOeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbZCaOde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:33:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:11071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760434AbZCaOdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677497646"
Date: Tue, 31 Mar 2009 15:37:59 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 17/21] x86, ds: use single debug store cpu configuration
Message-ID: <20090331153759.A13452@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a single configuration for all cpus.


Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-30 19:14:01.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-30 19:14:51.000000000 +0200
@@ -46,9 +46,8 @@ struct ds_configuration {
 	/* Control bit-masks indexed by enum ds_feature: */
 	unsigned long		ctl[dsf_ctl_max];
 };
-static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
+static struct ds_configuration ds_cfg __read_mostly;
 
-#define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
 
 /* Maximal size of a DS configuration: */
 #define MAX_SIZEOF_DS		(12 * 8)
@@ -1294,11 +1293,15 @@ ds_configure(const struct ds_configurati
 	printk("bts/pebs record: %u/%u bytes\n",
 	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
 
-	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
+	WARN_ON(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 {
+	/* Only configure the first cpu. Others are identical. */
+	if (ds_cfg.name)
+		return;
+
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
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

