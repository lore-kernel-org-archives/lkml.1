Return-Path: <linux-kernel-owner+w=401wt.eu-S938852AbXHMXbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938852AbXHMXbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938024AbXHMXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:30:37 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:55480 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937946AbXHMXac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:30:32 -0400
Date: Tue, 14 Aug 2007 01:30:28 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070813232902.13138.30065.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] arch/i386: Convert to generic boolean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to generic boolean (+ some minor cleanup).

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with all(yes|mod|no)config on i386
Diffed against Linus' git-tree
Sent on 2007-05-12, no replys

 amd.c     |    2 --
 cyrix.c   |    2 +-
 generic.c |   20 +++++++++-----------
 mtrr.h    |    5 -----
 4 files changed, 10 insertions(+), 19 deletions(-)


diff --git a/arch/i386/kernel/cpu/mtrr/amd.c b/arch/i386/kernel/cpu/mtrr/amd.c
index 0949cdb..ee2331b 100644
--- a/arch/i386/kernel/cpu/mtrr/amd.c
+++ b/arch/i386/kernel/cpu/mtrr/amd.c
@@ -53,8 +53,6 @@ static void amd_set_mtrr(unsigned int reg, unsigned long base,
     <base> The base address of the region.
     <size> The size of the region. If this is 0 the region is disabled.
     <type> The type of the region.
-    <do_safe> If TRUE, do the change safely. If FALSE, safety measures should
-    be done externally.
     [RETURNS] Nothing.
 */
 {
diff --git a/arch/i386/kernel/cpu/mtrr/cyrix.c b/arch/i386/kernel/cpu/mtrr/cyrix.c
index 0737a59..8b1b9fd 100644
--- a/arch/i386/kernel/cpu/mtrr/cyrix.c
+++ b/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -322,7 +322,7 @@ cyrix_arr_init(void)
 			setCx86(CX86_CCR6, ccr[6]);
 		}
 		/* Disable ARR3. This is safe now that we disabled SMM. */
-		/* cyrix_set_arr_up (3, 0, 0, 0, FALSE); */
+		/* cyrix_set_arr_up (3, 0, 0, 0, false); */
 	}
 	/* If we changed CCR1 in memory, change it in the processor, too. */
 	if (ccrc[1])
diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/i386/kernel/cpu/mtrr/generic.c
index 5367e32..fd6ffc5 100644
--- a/arch/i386/kernel/cpu/mtrr/generic.c
+++ b/arch/i386/kernel/cpu/mtrr/generic.c
@@ -187,7 +187,7 @@ static inline void k8_enable_fixed_iorrs(void)
  * \param changed pointer which indicates whether the MTRR needed to be changed
  * \param msrwords pointer to the MSR values which the MSR should have
  */
-static void set_fixed_range(int msr, int * changed, unsigned int * msrwords)
+static void set_fixed_range(int msr, bool * changed, unsigned int * msrwords)
 {
 	unsigned lo, hi;
 
@@ -199,7 +199,7 @@ static void set_fixed_range(int msr, int * changed, unsigned int * msrwords)
 		    ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
 			k8_enable_fixed_iorrs();
 		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
-		*changed = TRUE;
+		*changed = true;
 	}
 }
 
@@ -256,10 +256,10 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
  * Checks and updates the fixed-range MTRRs if they differ from the saved set
  * \param frs pointer to fixed-range MTRR values, saved by get_fixed_ranges()
  */
-static int set_fixed_ranges(mtrr_type * frs)
+static bool set_fixed_ranges(mtrr_type * frs)
 {
 	unsigned long long *saved = (unsigned long long *) frs;
-	int changed = FALSE;
+	bool changed = false;
 	int block=-1, range;
 
 	while (fixed_range_blocks[++block].ranges)
@@ -270,19 +270,19 @@ static int set_fixed_ranges(mtrr_type * frs)
 	return changed;
 }
 
-/*  Set the MSR pair relating to a var range. Returns TRUE if
+/*  Set the MSR pair relating to a var range. Returns 'true' if
     changes are made  */
-static int set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
+static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 {
 	unsigned int lo, hi;
-	int changed = FALSE;
+	bool changed = false;
 
 	rdmsr(MTRRphysBase_MSR(index), lo, hi);
 	if ((vr->base_lo & 0xfffff0ffUL) != (lo & 0xfffff0ffUL)
 	    || (vr->base_hi & (size_and_mask >> (32 - PAGE_SHIFT))) !=
 		(hi & (size_and_mask >> (32 - PAGE_SHIFT)))) {
 		mtrr_wrmsr(MTRRphysBase_MSR(index), vr->base_lo, vr->base_hi);
-		changed = TRUE;
+		changed = true;
 	}
 
 	rdmsr(MTRRphysMask_MSR(index), lo, hi);
@@ -291,7 +291,7 @@ static int set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 	    || (vr->mask_hi & (size_and_mask >> (32 - PAGE_SHIFT))) !=
 		(hi & (size_and_mask >> (32 - PAGE_SHIFT)))) {
 		mtrr_wrmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
-		changed = TRUE;
+		changed = true;
 	}
 	return changed;
 }
@@ -416,8 +416,6 @@ static void generic_set_mtrr(unsigned int reg, unsigned long base,
     <base> The base address of the region.
     <size> The size of the region. If this is 0 the region is disabled.
     <type> The type of the region.
-    <do_safe> If TRUE, do the change safely. If FALSE, safety measures should
-    be done externally.
     [RETURNS] Nothing.
 */
 {
diff --git a/arch/i386/kernel/cpu/mtrr/mtrr.h b/arch/i386/kernel/cpu/mtrr/mtrr.h
index 289dfe6..3aea07c 100644
--- a/arch/i386/kernel/cpu/mtrr/mtrr.h
+++ b/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -2,11 +2,6 @@
  * local mtrr defines.
  */
 
-#ifndef TRUE
-#define TRUE  1
-#define FALSE 0
-#endif
-
 #define MTRRcap_MSR     0x0fe
 #define MTRRdefType_MSR 0x2ff
 
