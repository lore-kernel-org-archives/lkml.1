Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbXDMPu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbXDMPu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXDMPu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:50:56 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:38918 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753646AbXDMPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:50:55 -0400
Date: Fri, 13 Apr 2007 17:50:50 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
cc: Andi Kleen <ak@suse.de>, Dave Jones <davej@codemonkey.org.uk>,
       Bernhard Kaindl <bk@suse.de>
Subject: [PATCH 1/4] Adds mtrr_save_fixed_ranges() for use in two later
 patches.
Message-ID: <Pine.LNX.4.64.0704131735570.17956@jbgna.fhfr.qr>
References: <20070413121533.082325752@mahler.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----------------------------------------------------------------
Update: Rediffed against 2.6.21-rc6-mm1, the only change I had
to make was tiny: Andrew's tree has a patch applied which changes
many functions from being prefixed with __init to __cpuinit, which
is actually wrong and will (IMHO) be replaced by another patch:

http://lkml.org/lkml/2007/4/7/113
Jeremy Fitzhardinge: [PATCH 2/2] x86: clean up identify_cpu)

The above patch splits up identify_cpu() into a part for the BSP and
the APs, which also means that the patch to which this patch rejected
to, will then be obsolete, many of the functions can be freed with
__init again, but this is a incremental cleanup which can happen
after the patch from Jeremy Fitzhardinge above is applied. NOTE:
I didn't test Jeremy's patch on x86_64 so far (he has no such
machine) but it's definitely right to do what his patch does, IMHO.
-----------------------------------------------------------------

In this current implementation which is used in other patches,
mtrr_save_fixed_ranges() accepts a dummy void pointer because
in the current implementation of one of these patches, this
function may be called from smp_call_function_single() which
requires that this function takes a void pointer argument.

This function calls get_fixed_ranges(), passing mtrr_state.fixed_ranges
which is the element of the static struct which stores our current
backup of the fixed-range MTRR values which all CPUs shall be
using.

Because  mtrr_save_fixed_ranges calls get_fixed_ranges after
kernel initialisation time, __init needs to be removed from
the declaration of get_fixed_ranges().

If CONFIG_MTRR is not set, we define mtrr_save_fixed_ranges
as an empty statement because there is nothing to do.

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>

---
 arch/i386/kernel/cpu/mtrr/generic.c |   16 +++++++++++++++-
 include/asm-i386/mtrr.h             |    2 ++
 include/asm-x86_64/proto.h          |    2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

Index: 2.6.21-rc6-mm1/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- 2.6.21-rc6-mm1.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ 2.6.21-rc6-mm1/arch/i386/kernel/cpu/mtrr/generic.c
@@ -37,7 +37,11 @@ get_mtrr_var_range(unsigned int index, s
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }

-static void __cpuinit
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
 static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
Index: 2.6.21-rc6-mm1/include/asm-i386/mtrr.h
===================================================================
--- 2.6.21-rc6-mm1.orig/include/asm-i386/mtrr.h
+++ 2.6.21-rc6-mm1/include/asm-i386/mtrr.h
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
Index: 2.6.21-rc6-mm1/include/asm-x86_64/proto.h
===================================================================
--- 2.6.21-rc6-mm1.orig/include/asm-x86_64/proto.h
+++ 2.6.21-rc6-mm1/include/asm-x86_64/proto.h
@@ -17,9 +17,11 @@ extern void mcheck_init(struct cpuinfo_x
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


-- 
