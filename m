Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbXDMQEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbXDMQEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXDMQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:04:20 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41032 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754071AbXDMQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:04:19 -0400
Date: Fri, 13 Apr 2007 18:04:15 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
cc: Andi Kleen <ak@suse.de>, Dave Jones <davej@codemonkey.org.uk>,
       Bernhard Kaindl <bk@suse.de>
Subject: [PATCH 4/4] Enable support for fixed-range IORRs to keep RdMem &
 WrMem in sync
Message-ID: <Pine.LNX.4.64.0704131752410.17956@jbgna.fhfr.qr>
References: <20070413121533.082325752@mahler.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------------------------------------------
Update: Only removed __initdata from mtrr_show in the diff context
since the initial post to make it apply to 2.6.21-rc6-mm1

Note to Andrew: The patch which you applied which removes __initdata
from mtrr_show is actually wrong because mtrr_show is really only
accessed before __initdata cleanup. The correct fix is to apply
this patch instead:

http://lkml.org/lkml/2007/4/7/113
Jeremy Fitzhardinge: Subject [PATCH 2/2] x86: clean up identify_cpu

Jeremy tested his patch on i386, but not on x86_64 because he
has no such machine, but his cleanup to split

    identify_cpu(struct cpuinfo_x86 *);

which has

    /*
     * On SMP, boot_cpu_data holds the common feature set between
     * all CPUs; so make sure that we indicate which features are
-    * common between the CPUs.  The first time this routine gets
-    * executed, c == &boot_cpu_data.
-    */
-   if (c != &boot_cpu_data) {
-       /* AND the already accumulated flags with these */
-       for (i = 0 ; i < NCAPINTS ; i++)
-           boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
-   }

    -   if (c == &boot_cpu_data)
    -       mtrr_bp_init();
    -   else
    -       mtrr_ap_init();

identify_boot_cpu()
identify_secondary_cpu()

is much preferred by me, as it allows to do the __init / __initdata
markers in the mtrr code right again.

Conseqently, identify_boot_cpu() and identify_secondary_cpu() should
IMHO be renamed top init_boot_cpu() and init_secondary_cpu(), because
after Jeremy's cleanup, the CPU initialsation code is properly split
apart from the pure CPU identification code which stays in a common
identify_cpu() function, which is used by both functions, so then
the code also is much less ugly to read.

--------------------------------------------------------------
Original Patch description with patch updated to apply to 2.6.21-rc6-mm1:

If our copy of the MTRRs of the BSP has RdMem or WrMem set, and
we are running on an AMD64/K8 system, the boot CPU must have had
MtrrFixDramEn and MtrrFixDramModEn set (otherwise our RDMSR would
have copied these bits cleared), so we set them on this CPU as well.

This allows us to keep the AMD64/K8 RdMem and WrMem bits in sync
across the CPUs of SMP systems in order to fullfill the duty of
system software to "initialize and maintain MTRR consistency
across all processors." as written in the AMD and Intel manuals.

If an WRMSR instruction fails because MtrrFixDramModEn is not
set, I expect that also the Intel-style MTRR bits are not updated.

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>

---
 arch/i386/kernel/cpu/mtrr/generic.c |   90 ++++++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 25 deletions(-)

Index: 2.6.21-rc6-mm1/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- 2.6.21-rc6-mm1.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ 2.6.21-rc6-mm1/arch/i386/kernel/cpu/mtrr/generic.c
@@ -20,12 +20,29 @@ struct mtrr_state {
 	mtrr_type def_type;
 };

+struct fixed_range_block {
+	int base_msr; /* start address of an MTRR block */
+	int ranges;   /* number of MTRRs in this block  */
+};
+
+static struct fixed_range_block fixed_range_blocks[] = {
+	{ MTRRfix64K_00000_MSR, 1 }, /* one  64k MTRR  */
+	{ MTRRfix16K_80000_MSR, 2 }, /* two  16k MTRRs */
+	{ MTRRfix4K_C0000_MSR,  8 }, /* eight 4k MTRRs */
+	{}
+};
+
 static unsigned long smp_changes_mask;
 static struct mtrr_state mtrr_state = {};

 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."

+#define K8_MSR_SYSCFG			0xc0010010 /* AMD64/K8 SYSCFG MSR  */
+#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
+#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
+#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
+
 static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);

@@ -162,6 +179,44 @@ void mtrr_wrmsr(unsigned msr, unsigned a
 			smp_processor_id(), msr, a, b);
 }

+/**
+ * Enable and allow read/write of extended fixed-range MTRR bits on K8 CPUs
+ * see AMD publication no. 24593, chapter 3.2.1 for more information
+ */
+static inline void k8_enable_fixed_iorrs(void)
+{
+	unsigned lo, hi;
+
+	rdmsr(K8_MSR_SYSCFG, lo, hi);
+	mtrr_wrmsr(K8_MSR_SYSCFG, lo
+				| K8_MTRRFIXRANGE_DRAM_ENABLE
+				| K8_MTRRFIXRANGE_DRAM_MODIFY, hi);
+}
+
+/**
+ * Checks and updates an fixed-range MTRR if it differs from the value it
+ * should have. If K8 extenstions are wanted, update the K8 SYSCFG MSR also.
+ * see AMD publication no. 24593, chapter 7.8.1, page 233 for more information
+ * \param msr MSR address of the MTTR which should be checked and updated
+ * \param changed pointer which indicates whether the MTRR needed to be changed
+ * \param msrwords pointer to the MSR values which the MSR should have
+ */
+static void set_fixed_range(int msr, int * changed, unsigned int * msrwords)
+{
+	unsigned lo, hi;
+
+	rdmsr(msr, lo, hi);
+
+	if (lo != msrwords[0] || hi != msrwords[1]) {
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+		    boot_cpu_data.x86 == 15 &&
+		    ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
+			k8_enable_fixed_iorrs();
+		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
+		*changed = TRUE;
+	}
+}
+
 int generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
 /*  [SUMMARY] Get a free MTRR.
     <base> The starting (base) address of the region.
@@ -211,36 +266,21 @@ static void generic_get_mtrr(unsigned in
 	*type = base_lo & 0xff;
 }

+/**
+ * Checks and updates the fixed-range MTRRs if they differ from the saved set
+ * \param frs pointer to fixed-range MTRR values, saved by get_fixed_ranges()
+ */
 static int set_fixed_ranges(mtrr_type * frs)
 {
-	unsigned int *p = (unsigned int *) frs;
+	unsigned long long *saved = (unsigned long long *) frs;
 	int changed = FALSE;
-	int i;
-	unsigned int lo, hi;
+	int block=-1, range;

-	rdmsr(MTRRfix64K_00000_MSR, lo, hi);
-	if (p[0] != lo || p[1] != hi) {
-		mtrr_wrmsr(MTRRfix64K_00000_MSR, p[0], p[1]);
-		changed = TRUE;
-	}
+	while (fixed_range_blocks[++block].ranges)
+	    for (range=0; range < fixed_range_blocks[block].ranges; range++)
+		set_fixed_range(fixed_range_blocks[block].base_msr + range,
+		    &changed, (unsigned int *) saved++);

-	for (i = 0; i < 2; i++) {
-		rdmsr(MTRRfix16K_80000_MSR + i, lo, hi);
-		if (p[2 + i * 2] != lo || p[3 + i * 2] != hi) {
-			mtrr_wrmsr(MTRRfix16K_80000_MSR + i, p[2 + i * 2],
-			      p[3 + i * 2]);
-			changed = TRUE;
-		}
-	}
-
-	for (i = 0; i < 8; i++) {
-		rdmsr(MTRRfix4K_C0000_MSR + i, lo, hi);
-		if (p[6 + i * 2] != lo || p[7 + i * 2] != hi) {
-			mtrr_wrmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2],
-			      p[7 + i * 2]);
-			changed = TRUE;
-		}
-	}
 	return changed;
 }


-- 
