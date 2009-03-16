Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbZCPMcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbZCPMcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZCPMb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:31:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:27999 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbZCPMbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:31:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,373,1233561600"; 
   d="scan'208";a="439249513"
Date: Mon, 16 Mar 2009 13:31:25 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch] x86, ds: add support for core i7
Message-ID: <20090316133125.A7756@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Debug Store support for Core i7.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/ds.h |   10 ++++++++--
 arch/x86/kernel/ds.c      |   24 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

Index: git-tip/arch/x86/include/asm/ds.h
===================================================================
--- git-tip.orig/arch/x86/include/asm/ds.h	2009-03-16 12:06:17.000000000 +0100
+++ git-tip/arch/x86/include/asm/ds.h	2009-03-16 12:12:06.000000000 +0100
@@ -15,8 +15,8 @@
  * - buffer allocation (memory accounting)
  *
  *
- * Copyright (C) 2007-2008 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
+ * Copyright (C) 2007-2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
 #ifndef _ASM_X86_DS_H
@@ -201,8 +201,12 @@ struct bts_trace {
 struct pebs_trace {
 	struct ds_trace ds;
 
-	/* the PEBS reset value */
-	unsigned long long reset_value;
+	/* the number of valid counters in the below array */
+	unsigned int counters;
+
+#define MAX_PEBS_COUNTERS 4
+	/* the counter reset value */
+	unsigned long long counter_reset[MAX_PEBS_COUNTERS];
 };
 
 
@@ -237,9 +241,11 @@ extern int ds_reset_pebs(struct pebs_tra
  * Returns 0 on success; -Eerrno on error
  *
  * tracer: the tracer handle returned from ds_request_pebs()
+ * counter: the index of the counter
  * value: the new counter reset value
  */
-extern int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value);
+extern int ds_set_pebs_reset(struct pebs_tracer *tracer,
+			     unsigned int counter, u64 value);
 
 /*
  * Initialization
Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-16 12:06:17.000000000 +0100
+++ git-tip/arch/x86/kernel/ds.c	2009-03-16 13:19:59.000000000 +0100
@@ -43,6 +43,9 @@ struct ds_configuration {
 	/* The size of a BTS/PEBS record in bytes: */
 	unsigned char		sizeof_rec[2];
 
+	/* The number of pebs counter reset values in the DS structure. */
+	unsigned char		nr_counter_reset;
+
 	/* Control bit-masks indexed by enum ds_feature: */
 	unsigned long		ctl[dsf_ctl_max];
 };
@@ -51,7 +54,7 @@ static DEFINE_PER_CPU(struct ds_configur
 #define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
 
 /* Maximal size of a DS configuration: */
-#define MAX_SIZEOF_DS		(12 * 8)
+#define MAX_SIZEOF_DS		0x80
 
 /* Maximal size of a BTS record: */
 #define MAX_SIZEOF_BTS		(3 * 8)
@@ -59,6 +62,12 @@ static DEFINE_PER_CPU(struct ds_configur
 /* BTS and PEBS buffer alignment: */
 #define DS_ALIGNMENT		(1 << 3)
 
+/* Number of buffer pointers in DS: */
+#define NUM_DS_PTR_FIELDS	8
+
+/* Size of a pebs reset value in DS: */
+#define PEBS_RESET_FIELD_SIZE	8
+
 /* Mask of control bits in the DS MSR register: */
 #define BTS_CONTROL				  \
 	( ds_cfg.ctl[dsf_bts]			| \
@@ -865,9 +874,12 @@ const struct pebs_trace *ds_read_pebs(st
 		return NULL;
 
 	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
-	tracer->trace.reset_value =
-		*(u64 *)(tracer->ds.context->ds +
-			 (ds_cfg.sizeof_ptr_field * 8));
+
+	tracer->trace.counters = ds_cfg.nr_counter_reset;
+	memcpy(tracer->trace.counter_reset,
+	       tracer->ds.context->ds +
+	       (ds_cfg.sizeof_ptr_field * NUM_DS_PTR_FIELDS),
+	       ds_cfg.nr_counter_reset * PEBS_RESET_FIELD_SIZE);
 
 	return &tracer->trace;
 }
@@ -898,13 +910,18 @@ int ds_reset_pebs(struct pebs_tracer *tr
 	return 0;
 }
 
-int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value)
+int ds_set_pebs_reset(struct pebs_tracer *tracer,
+		      unsigned int counter, u64 value)
 {
 	if (!tracer)
 		return -EINVAL;
 
+	if (ds_cfg.nr_counter_reset < counter)
+		return -EINVAL;
+
 	*(u64 *)(tracer->ds.context->ds +
-		 (ds_cfg.sizeof_ptr_field * 8)) = value;
+		 (ds_cfg.sizeof_ptr_field * NUM_DS_PTR_FIELDS) +
+		 (PEBS_RESET_FIELD_SIZE * counter)) = value;
 
 	return 0;
 }
@@ -914,16 +931,26 @@ static const struct ds_configuration ds_
 	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
 	.ctl[dsf_bts_kernel]	= (1 << 5),
 	.ctl[dsf_bts_user]	= (1 << 6),
+	.nr_counter_reset	= 1,
 };
 static const struct ds_configuration ds_cfg_pentium_m = {
 	.name = "Pentium M",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
+	.nr_counter_reset	= 1,
 };
 static const struct ds_configuration ds_cfg_core2_atom = {
 	.name = "Core 2/Atom",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 	.ctl[dsf_bts_kernel]	= (1 << 9),
 	.ctl[dsf_bts_user]	= (1 << 10),
+	.nr_counter_reset	= 1,
+};
+static const struct ds_configuration ds_cfg_core_i7 = {
+	.name = "Core i7",
+	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
+	.ctl[dsf_bts_kernel]	= (1 << 9),
+	.ctl[dsf_bts_user]	= (1 << 10),
+	.nr_counter_reset	= 4,
 };
 
 static void
@@ -940,6 +967,32 @@ ds_configure(const struct ds_configurati
 	nr_pebs_fields = 18;
 #endif
 
+	/*
+	 * Starting with version 2, architectural performance
+	 * monitoring supports a format specifier.
+	 */
+	if ((cpuid_eax(0xa) & 0xff) > 1) {
+		unsigned long perf_capabilities, format;
+
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_capabilities);
+
+		format = (perf_capabilities >> 8) & 0xf;
+
+		switch (format) {
+		case 0:
+			nr_pebs_fields = 18;
+			break;
+		case 1:
+			nr_pebs_fields = 22;
+			break;
+		default:
+			printk(KERN_INFO
+			       "[ds] unknown PEBS format: %lu\n", format);
+			nr_pebs_fields = 0;
+			break;
+		}
+	}
+
 	memset(&ds_cfg, 0, sizeof(ds_cfg));
 	ds_cfg = *cfg;
 
@@ -983,7 +1036,7 @@ ds_configure(const struct ds_configurati
 	printk("bts/pebs record: %u/%u bytes\n",
 	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
 
-	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
+	WARN_ON_ONCE(MAX_PEBS_COUNTERS < ds_cfg.nr_counter_reset);
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
@@ -1001,6 +1054,8 @@ void __cpuinit ds_init_intel(struct cpui
 			ds_configure(&ds_cfg_core2_atom, c);
 			break;
 		case 0x1a: /* Core i7 */
+			ds_configure(&ds_cfg_core_i7, c);
+			break;
 		default:
 			/* Sorry, don't know about them. */
 			break;
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

