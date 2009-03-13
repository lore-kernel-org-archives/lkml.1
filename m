Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZCMJmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZCMJmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZCMJm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:42:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:1160 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZCMJm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:42:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,356,1233561600"; 
   d="scan'208";a="438628478"
Date: Fri, 13 Mar 2009 10:42:18 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 1/5] x86, bts: detect size of DS fields
Message-ID: <20090313104218.A30096@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect the size of the pointer-type fields in the DS area configuration
via the DTES64 features rather than based on the cpuid.

Rename a variable to denote that size to reflect that it only covers
the pointer-type fields.

Add more boot-time diagnostics giving the detected size and the sizes
of BTS and PEBS records.

Use the size of the BTS/PEBS record to indicate that the respective
feature is not available (if the record size is zero).


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/kernel/ds.c
===================================================================
--- gits.orig/arch/x86/kernel/ds.c	2009-03-06 16:38:52.000000000 +0100
+++ gits/arch/x86/kernel/ds.c	2009-03-09 10:31:10.000000000 +0100
@@ -39,7 +39,7 @@ struct ds_configuration {
 	/* the size of one pointer-typed field in the DS structure and
 	   in the BTS and PEBS buffers in bytes;
 	   this covers the first 8 DS fields related to buffer management. */
-	unsigned char  sizeof_field;
+	unsigned char  sizeof_ptr_field;
 	/* the size of a BTS/PEBS record in bytes */
 	unsigned char  sizeof_rec[2];
 	/* a series of bit-masks to control various features indexed
@@ -142,14 +142,14 @@ enum ds_qualifier {
 static inline unsigned long ds_get(const unsigned char *base,
 				   enum ds_qualifier qual, enum ds_field field)
 {
-	base += (ds_cfg.sizeof_field * (field + (4 * qual)));
+	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
 	return *(unsigned long *)base;
 }
 
 static inline void ds_set(unsigned char *base, enum ds_qualifier qual,
 			  enum ds_field field, unsigned long value)
 {
-	base += (ds_cfg.sizeof_field * (field + (4 * qual)));
+	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
 	(*(unsigned long *)base) = value;
 }
 
@@ -410,7 +410,7 @@ static int ds_write(struct ds_context *c
  * Later architectures use 64bit pointers throughout, whereas earlier
  * architectures use 32bit pointers in 32bit mode.
  *
- * We compute the base address for the first 8 fields based on:
+ * We compute the base address for the fields based on:
  * - the field size stored in the DS configuration
  * - the relative field position
  *
@@ -441,13 +441,13 @@ enum bts_field {
 
 static inline unsigned long bts_get(const char *base, enum bts_field field)
 {
-	base += (ds_cfg.sizeof_field * field);
+	base += (ds_cfg.sizeof_ptr_field * field);
 	return *(unsigned long *)base;
 }
 
 static inline void bts_set(char *base, enum bts_field field, unsigned long val)
 {
-	base += (ds_cfg.sizeof_field * field);;
+	base += (ds_cfg.sizeof_ptr_field * field);;
 	(*(unsigned long *)base) = val;
 }
 
@@ -593,6 +593,10 @@ static int ds_request(struct ds_tracer *
 	struct ds_context *context;
 	int error;
 
+	error = -EOPNOTSUPP;
+	if (!ds_cfg.sizeof_rec[qual])
+		goto out;
+
 	error = -EINVAL;
 	if (!base)
 		goto out;
@@ -635,10 +639,6 @@ struct bts_tracer *ds_request_bts(struct
 	unsigned long irq;
 	int error;
 
-	error = -EOPNOTSUPP;
-	if (!ds_cfg.ctl[dsf_bts])
-		goto out;
-
 	/* buffer overflow notification is not yet implemented */
 	error = -EOPNOTSUPP;
 	if (ovfl)
@@ -848,7 +848,8 @@ const struct pebs_trace *ds_read_pebs(st
 
 	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
 	tracer->trace.reset_value =
-		*(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8));
+		*(u64 *)(tracer->ds.context->ds +
+			 (ds_cfg.sizeof_ptr_field * 8));
 
 	return &tracer->trace;
 }
@@ -884,7 +885,8 @@ int ds_set_pebs_reset(struct pebs_tracer
 	if (!tracer)
 		return -EINVAL;
 
-	*(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8)) = value;
+	*(u64 *)(tracer->ds.context->ds +
+		 (ds_cfg.sizeof_ptr_field * 8)) = value;
 
 	return 0;
 }
@@ -894,52 +896,54 @@ static const struct ds_configuration ds_
 	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
 	.ctl[dsf_bts_kernel]	= (1 << 5),
 	.ctl[dsf_bts_user]	= (1 << 6),
-
-	.sizeof_field		= sizeof(long),
-	.sizeof_rec[ds_bts]	= sizeof(long) * 3,
-#ifdef __i386__
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 10,
-#else
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
-#endif
 };
 static const struct ds_configuration ds_cfg_pentium_m = {
 	.name = "Pentium M",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
-
-	.sizeof_field		= sizeof(long),
-	.sizeof_rec[ds_bts]	= sizeof(long) * 3,
-#ifdef __i386__
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 10,
-#else
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
-#endif
 };
 static const struct ds_configuration ds_cfg_core2_atom = {
 	.name = "Core 2/Atom",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 	.ctl[dsf_bts_kernel]	= (1 << 9),
 	.ctl[dsf_bts_user]	= (1 << 10),
-
-	.sizeof_field		= 8,
-	.sizeof_rec[ds_bts]	= 8 * 3,
-	.sizeof_rec[ds_pebs]	= 8 * 18,
 };
 
 static void
-ds_configure(const struct ds_configuration *cfg)
+ds_configure(const struct ds_configuration *cfg,
+	     struct cpuinfo_x86 *cpu)
 {
+	unsigned long nr_pebs_fields = 0;
+
+	printk(KERN_INFO "[ds] using %s configuration\n", cfg->name);
+
+#ifdef __i386__
+	nr_pebs_fields = 10;
+#else
+	nr_pebs_fields = 18;
+#endif
+
 	memset(&ds_cfg, 0, sizeof(ds_cfg));
 	ds_cfg = *cfg;
 
-	printk(KERN_INFO "[ds] using %s configuration\n", ds_cfg.name);
+	ds_cfg.sizeof_ptr_field =
+		(cpu_has(cpu, X86_FEATURE_DTES64) ? 8 : 4);
 
-	if (!cpu_has_bts) {
-		ds_cfg.ctl[dsf_bts] = 0;
+	ds_cfg.sizeof_rec[ds_bts]  = ds_cfg.sizeof_ptr_field * 3;
+	ds_cfg.sizeof_rec[ds_pebs] = ds_cfg.sizeof_ptr_field * nr_pebs_fields;
+
+	if (!cpu_has(cpu, X86_FEATURE_BTS)) {
+		ds_cfg.sizeof_rec[ds_bts] = 0;
 		printk(KERN_INFO "[ds] bts not available\n");
 	}
-	if (!cpu_has_pebs)
+	if (!cpu_has(cpu, X86_FEATURE_PEBS)) {
+		ds_cfg.sizeof_rec[ds_pebs] = 0;
 		printk(KERN_INFO "[ds] pebs not available\n");
+	}
+
+	printk(KERN_INFO "[ds] sizes: address: %u bit, ",
+	       8 * ds_cfg.sizeof_ptr_field);
+	printk("bts/pebs record: %u/%u bytes\n",
+	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
 
 	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_field));
 }
@@ -951,12 +955,12 @@ void __cpuinit ds_init_intel(struct cpui
 		switch (c->x86_model) {
 		case 0x9:
 		case 0xd: /* Pentium M */
-			ds_configure(&ds_cfg_pentium_m);
+			ds_configure(&ds_cfg_pentium_m, c);
 			break;
 		case 0xf:
 		case 0x17: /* Core2 */
 		case 0x1c: /* Atom */
-			ds_configure(&ds_cfg_core2_atom);
+			ds_configure(&ds_cfg_core2_atom, c);
 			break;
 		case 0x1a: /* i7 */
 		default:
@@ -969,7 +973,7 @@ void __cpuinit ds_init_intel(struct cpui
 		case 0x0:
 		case 0x1:
 		case 0x2: /* Netburst */
-			ds_configure(&ds_cfg_netburst);
+			ds_configure(&ds_cfg_netburst, c);
 			break;
 		default:
 			/* sorry, don't know about them */
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

