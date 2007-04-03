Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXDCOTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXDCOTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030259AbXDCOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:19:35 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:50382 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030250AbXDCOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:19:34 -0400
Date: Tue, 3 Apr 2007 15:58:50 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 1/4] Implement mtrr_save_fixed_ranges()
In-Reply-To: <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
Message-ID: <Pine.LNX.4.64.0704031558050.7626@jbgna.fhfr.qr>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr>
 <200703272213.51947.ak@suse.de> <Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr>
 <200703291525.59116.ak@suse.de> <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements mtrr_save_fixed_ranges() which can be called
from anywhere anytime to retrieve the fixed-range MTRRs from the
current CPU and saves these MTRR values to the MTRR state struct.

This function calls get_fixed_ranges(), passing mtrr_state.fixed_ranges
which is the element of the static struct which stores our current
backup of the fixed-range MTRR values which all CPUs shall be
using.

Because mtrr_save_fixed_ranges calls get_fixed_ranges() after
kernel initialisation time, __init needs to be removed from
the declaration of get_fixed_ranges().

Signed-off-by: Bernhard Kaindl <bk@suse.de>

--- linux-2.6.20.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux-2.6.20/arch/i386/kernel/cpu/mtrr/generic.c
@@ -37,7 +37,11 @@ get_mtrr_var_range(unsigned int index, s
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }

-static void __init
+/**
+ * Retrieves the current fixed-range MTRRs from the current CPU
+ * \param frs address where to write the current MTRR contents
+ */
+static void
 get_fixed_ranges(mtrr_type * frs)
 {
 	unsigned int *p = (unsigned int *) frs;
@@ -51,6 +55,16 @@ get_fixed_ranges(mtrr_type * frs)
 		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
 }

+/**
+ * Updates our copy of the state of the fixed-range MTRR values
+ * with the current fixed-range MTRR contents from the current CPU
+ * \param info dummy needed for use by smp_call_function_single()
+ */
+void mtrr_save_fixed_ranges(void *info)
+{
+	get_fixed_ranges(mtrr_state.fixed_ranges);
+}
+
 static void __init print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
Index: linux-2.6.20/include/asm-i386/mtrr.h
===================================================================
--- linux-2.6.20.orig/include/asm-i386/mtrr.h
+++ linux-2.6.20/include/asm-i386/mtrr.h
@@ -69,6 +69,7 @@ struct mtrr_gentry

 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
+extern void mtrr_save_fixed_ranges(void *);
 extern int mtrr_add (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_add_page (unsigned long base, unsigned long size,
@@ -79,6 +80,7 @@ extern void mtrr_centaur_report_mcr(int
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 #  else
+#define mtrr_save_fixed_ranges(arg) do {} while (0)
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
 {
Index: linux-2.6.20/include/asm-x86_64/proto.h
===================================================================
--- linux-2.6.20.orig/include/asm-x86_64/proto.h
+++ linux-2.6.20/include/asm-x86_64/proto.h
@@ -19,9 +19,11 @@ extern void mcheck_init(struct cpuinfo_x
 #ifdef CONFIG_MTRR
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
+extern void mtrr_save_fixed_ranges(void *);
 #else
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
+#define mtrr_save_fixed_ranges(arg) do {} while (0)
 #endif
 extern void init_memory_mapping(unsigned long start, unsigned long end);

In this current implementation, which is used in other patches,
mtrr_save_fixed_ranges() accepts a dummy void pointer because
in the current implementation of one of these patches, this
function may be called from smp_call_function_single() which
requires that this function takes a void pointer argument.

If CONFIG_MTRR is not set, we define mtrr_save_fixed_ranges
as an empty statement because there is nothing to do.
