Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbZEGJbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbZEGJbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761981AbZEGJZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:25:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:45108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761852AbZEGJZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:25:36 -0400
Date: Thu, 7 May 2009 09:25:04 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144607.088997000@intel.com>
References: <20090403144607.088997000@intel.com>
Subject: [tip:tracing/core] x86, ds: support Core i7
Message-ID: <tip-017bc617657c928cb9a0c45a7a7e9f4e66695347@git.kernel.org>
Git-Commit-ID: 017bc617657c928cb9a0c45a7a7e9f4e66695347
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:25:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  017bc617657c928cb9a0c45a7a7e9f4e66695347
Gitweb:     http://git.kernel.org/tip/017bc617657c928cb9a0c45a7a7e9f4e66695347
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:36 +0200

x86, ds: support Core i7

Add debug store support for Core i7.

Core i7 adds a reset value for each performance counter and a new
PEBS record format.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144607.088997000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/ds.h |   12 ++++++--
 arch/x86/kernel/ds.c      |   69 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/ds.h b/arch/x86/include/asm/ds.h
index 149e520..70dac19 100644
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -234,8 +234,12 @@ struct bts_trace {
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
 
 
@@ -270,9 +274,11 @@ extern int ds_reset_pebs(struct pebs_tracer *tracer);
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
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 4e05157..48bfe13 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -44,6 +44,9 @@ struct ds_configuration {
 	/* The size of a BTS/PEBS record in bytes: */
 	unsigned char		sizeof_rec[2];
 
+	/* The number of pebs counter reset values in the DS structure. */
+	unsigned char		nr_counter_reset;
+
 	/* Control bit-masks indexed by enum ds_feature: */
 	unsigned long		ctl[dsf_ctl_max];
 };
@@ -51,7 +54,7 @@ static struct ds_configuration ds_cfg __read_mostly;
 
 
 /* Maximal size of a DS configuration: */
-#define MAX_SIZEOF_DS		(12 * 8)
+#define MAX_SIZEOF_DS		0x80
 
 /* Maximal size of a BTS record: */
 #define MAX_SIZEOF_BTS		(3 * 8)
@@ -59,6 +62,12 @@ static struct ds_configuration ds_cfg __read_mostly;
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
@@ -1164,9 +1173,12 @@ const struct pebs_trace *ds_read_pebs(struct pebs_tracer *tracer)
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
@@ -1197,13 +1209,18 @@ int ds_reset_pebs(struct pebs_tracer *tracer)
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
@@ -1213,16 +1230,26 @@ static const struct ds_configuration ds_cfg_netburst = {
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
@@ -1239,6 +1266,32 @@ ds_configure(const struct ds_configuration *cfg,
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
 
@@ -1262,7 +1315,7 @@ ds_configure(const struct ds_configuration *cfg,
 	printk("bts/pebs record: %u/%u bytes\n",
 	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
 
-	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_ptr_field));
+	WARN_ON_ONCE(MAX_PEBS_COUNTERS < ds_cfg.nr_counter_reset);
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
@@ -1284,6 +1337,8 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 			ds_configure(&ds_cfg_core2_atom, c);
 			break;
 		case 0x1a: /* Core i7 */
+			ds_configure(&ds_cfg_core_i7, c);
+			break;
 		default:
 			/* Sorry, don't know about them. */
 			break;
