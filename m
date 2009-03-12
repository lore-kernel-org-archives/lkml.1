Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbZCLQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbZCLQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbZCLQpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:45:50 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:44166 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZCLQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:45:49 -0400
X-BigFish: VPS-25(z6cekz1417L9370P936eQ4015M936fKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KGEJLY-01-HA2-01
Date: Thu, 12 Mar 2009 17:39:37 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, trenn@suse.de,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090312163937.GH20716@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090311150027.GK10490@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Mar 2009 16:39:38.0664 (UTC) FILETIME=[22A39280:01C9A331]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bug fix + BIOS workaround

BIOS is expected to clear the SYSCFG[MtrrFixDramModEn] on AMD CPUs
after fixed MTRRs are configured.

Some BIOSes do not clear SYSCFG[MtrrFixDramModEn] on BP (and on APs).

This can lead to obfuscation in Linux when this bit is not cleared on
BP but cleared on APs. A consequence of this is that the saved
fixed-MTRR state (from BP) differs from the fixed-MTRRs of APs --
because RdDram/WrDram bits are read as zero when
SYSCFG[MtrrFixDramModEn] is cleared -- and Linux tries to sync
fixed-MTRR state from BP to AP. This implies that Linux sets
SYSCFG[MtrrFixDramEn] and activates those bits.

More important is that (some) systems change these bits in SMM when
ACPI is enabled. Hence it is racy if Linux modifies RdMem/WrMem bits,
too.

I suggest not to touch RdDram/WrDram bits of fixed-MTRRs and
SYSCFG[MtrrFixDramEn] and to clear SYSCFG[MtrrFixDramModEn] as
suggested by AMD K8, and AMD family 10h/11h BKDGs.
BIOS is expected to do this anyway. This should avoid that
Linux and SMM tread on each other's toes ...

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |   51 +++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 21 deletions(-)

Change to previous version:
I slightly modified the log message (e.g. addition of FW_WARN).

Please consider to apply this patch for .29.


Thanks,

Andreas



diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0c0a455..6f557e0 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -41,6 +41,32 @@ static int __init mtrr_debug(char *opt)
 }
 early_param("mtrr.show", mtrr_debug);
 
+/**
+ * BIOS is expected to clear MtrrFixDramModEn bit, see for example
+ * "BIOS and Kernel Developer's Guide for the AMD Athlon 64 and AMD
+ * Opteron Processors" (26094 Rev. 3.30 February 2006), section
+ * "13.2.1.2 SYSCFG Register": "The MtrrFixDramModEn bit should be set
+ * to 1 during BIOS initalization of the fixed MTRRs, then cleared to
+ * 0 for operation."
+ */
+static inline void k8_check_syscfg_dram_mod_en(void)
+{
+	u32 lo, hi;
+
+	if (!((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
+	      (boot_cpu_data.x86 >= 0x0f)))
+		return;
+
+	rdmsr(MSR_K8_SYSCFG, lo, hi);
+	if (lo & K8_MTRRFIXRANGE_DRAM_MODIFY) {
+		printk(KERN_ERR FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
+		       " not cleared by BIOS, clearing this bit\n",
+		       smp_processor_id());
+		lo &= ~K8_MTRRFIXRANGE_DRAM_MODIFY;
+		mtrr_wrmsr(MSR_K8_SYSCFG, lo, hi);
+	}
+}
+
 /*
  * Returns the effective MTRR type for the region
  * Error returns:
@@ -174,6 +200,8 @@ get_fixed_ranges(mtrr_type * frs)
 	unsigned int *p = (unsigned int *) frs;
 	int i;
 
+	k8_check_syscfg_dram_mod_en();
+
 	rdmsr(MTRRfix64K_00000_MSR, p[0], p[1]);
 
 	for (i = 0; i < 2; i++)
@@ -308,27 +336,10 @@ void mtrr_wrmsr(unsigned msr, unsigned a, unsigned b)
 }
 
 /**
- * Enable and allow read/write of extended fixed-range MTRR bits on K8 CPUs
- * see AMD publication no. 24593, chapter 3.2.1 for more information
- */
-static inline void k8_enable_fixed_iorrs(void)
-{
-	unsigned lo, hi;
-
-	rdmsr(MSR_K8_SYSCFG, lo, hi);
-	mtrr_wrmsr(MSR_K8_SYSCFG, lo
-				| K8_MTRRFIXRANGE_DRAM_ENABLE
-				| K8_MTRRFIXRANGE_DRAM_MODIFY, hi);
-}
-
-/**
  * set_fixed_range - checks & updates a fixed-range MTRR if it differs from the value it should have
  * @msr: MSR address of the MTTR which should be checked and updated
  * @changed: pointer which indicates whether the MTRR needed to be changed
  * @msrwords: pointer to the MSR values which the MSR should have
- *
- * If K8 extentions are wanted, update the K8 SYSCFG MSR also.
- * See AMD publication no. 24593, chapter 7.8.1, page 233 for more information.
  */
 static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 {
@@ -337,10 +348,6 @@ static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 	rdmsr(msr, lo, hi);
 
 	if (lo != msrwords[0] || hi != msrwords[1]) {
-		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-		    (boot_cpu_data.x86 >= 0x0f && boot_cpu_data.x86 <= 0x11) &&
-		    ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
-			k8_enable_fixed_iorrs();
 		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
 		*changed = true;
 	}
@@ -419,6 +426,8 @@ static int set_fixed_ranges(mtrr_type * frs)
 	bool changed = false;
 	int block=-1, range;
 
+	k8_check_syscfg_dram_mod_en();
+
 	while (fixed_range_blocks[++block].ranges)
 	    for (range=0; range < fixed_range_blocks[block].ranges; range++)
 		set_fixed_range(fixed_range_blocks[block].base_msr + range,
-- 
1.6.2



