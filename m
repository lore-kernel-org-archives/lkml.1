Return-Path: <linux-kernel-owner+w=401wt.eu-S1762456AbZDBPEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762456AbZDBPEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761028AbZDBO5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:57531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761451AbZDBO5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:45 -0400
Content-Type: multipart/mixed; boundary="===============0269707722=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="678191068"
Message-Id: <20090402145737.055056000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:55:13 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 18/18] x86, ds: support Core i7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0269707722==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.i7.patch

Add debug store support for Core i7.

Core i7 adds a reset value for each performance counter and a new
PEBS record format.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/ds.h |   12 	9 +	3 -	0 !
 arch/x86/kernel/ds.c      |   69 	62 +	7 -	0 !
 2 files changed, 71 insertions(+), 10 deletions(-)

Index: b/arch/x86/include/asm/ds.h
===================================================================
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -235,8 +235,12 @@ struct bts_trace {
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
 
 
@@ -271,9 +275,11 @@ extern int ds_reset_pebs(struct pebs_tra
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
Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -43,6 +43,9 @@ struct ds_configuration {
 	/* The size of a BTS/PEBS record in bytes: */
 	unsigned char		sizeof_rec[2];
 
+	/* The number of pebs counter reset values in the DS structure. */
+	unsigned char		nr_counter_reset;
+
 	/* Control bit-masks indexed by enum ds_feature: */
 	unsigned long		ctl[dsf_ctl_max];
 };
@@ -50,7 +53,7 @@ static struct ds_configuration ds_cfg __
 
 
 /* Maximal size of a DS configuration: */
-#define MAX_SIZEOF_DS		(12 * 8)
+#define MAX_SIZEOF_DS		0x80
 
 /* Maximal size of a BTS record: */
 #define MAX_SIZEOF_BTS		(3 * 8)
@@ -58,6 +61,12 @@ static struct ds_configuration ds_cfg __
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
@@ -1187,9 +1196,12 @@ const struct pebs_trace *ds_read_pebs(st
 		return NULL;
 
 	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
-	tracer->trace.reset_value =
-		*(u64 *)(tracer->ds.context->ds +
-			 (ds_cfg.sizeof_ptr_field * 8));
+
+	tracer->trace.counters = ds_cfg.nr_counter_reset;
+	memcpy(tracer->trace.counter_reset,
+	       tracer->ds.context->ds +
+	       (NUM_DS_PTR_FIELDS * ds_cfg.sizeof_ptr_field),
+	       ds_cfg.nr_counter_reset * PEBS_RESET_FIELD_SIZE);
 
 	return &tracer->trace;
 }
@@ -1220,13 +1232,18 @@ int ds_reset_pebs(struct pebs_tracer *tr
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
+		 (NUM_DS_PTR_FIELDS * ds_cfg.sizeof_ptr_field) +
+		 (counter * PEBS_RESET_FIELD_SIZE)) = value;
 
 	return 0;
 }
@@ -1236,16 +1253,26 @@ static const struct ds_configuration ds_
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
@@ -1262,6 +1289,32 @@ ds_configure(const struct ds_configurati
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
 
@@ -1285,7 +1338,7 @@ ds_configure(const struct ds_configurati
 	printk("bts/pebs record: %u/%u bytes\n",
 	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
 
-	WARN_ON(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
+	WARN_ON(MAX_PEBS_COUNTERS < ds_cfg.nr_counter_reset);
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
@@ -1307,6 +1360,8 @@ void __cpuinit ds_init_intel(struct cpui
 			ds_configure(&ds_cfg_core2_atom, c);
 			break;
 		case 0x1a: /* Core i7 */
+			ds_configure(&ds_cfg_core_i7, c);
+			break;
 		default:
 			/* Sorry, don't know about them. */
 			break;

-- 

--===============0269707722==
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

--===============0269707722==--
