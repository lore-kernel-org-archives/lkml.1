Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbXBLHkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbXBLHkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933107AbXBLHi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933088AbXBLHiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:05 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [17/39] x86_64: Tighten mce_amd driver MSR reads
Message-Id: <20070212073804.7953A13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>

while debugging an unrelated problem in Xen, I noticed odd reads from
non-existent MSRs. Having now found time to look why these happen, I
came up with below patch, which
- prevents accessing MCi_MISCj with j > 0 when the block pointer in
MCi_MISC0 is zero
- accesses only contiguous MCi_MISCj until a non-implemented one is
found
- doesn't touch unimplemented blocks in mce_threshold_interrupt at all
- gives names to two bits previously derived from MASK_VALID_HI (it
took me some time to understand the code without this)

The first three items, besides being apparently closer to the spec, should
namely help cutting down on the time mce_threshold_interrupt() takes.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/mce_amd.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

Index: linux/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce_amd.c
+++ linux/arch/x86_64/kernel/mce_amd.c
@@ -37,6 +37,8 @@
 #define THRESHOLD_MAX     0xFFF
 #define INT_TYPE_APIC     0x00020000
 #define MASK_VALID_HI     0x80000000
+#define MASK_CNTP_HI      0x40000000
+#define MASK_LOCKED_HI    0x20000000
 #define MASK_LVTOFF_HI    0x00F00000
 #define MASK_COUNT_EN_HI  0x00080000
 #define MASK_INT_TYPE_HI  0x00060000
@@ -122,14 +124,17 @@ void __cpuinit mce_amd_feature_init(stru
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
 				address = MSR_IA32_MC0_MISC + bank * 4;
-			else if (block == 1)
-				address = MCG_XBLK_ADDR
-					+ ((low & MASK_BLKPTR_LO) >> 21);
+			else if (block == 1) {
+				address = (low & MASK_BLKPTR_LO) >> 21;
+				if (!address)
+					break;
+				address += MCG_XBLK_ADDR;
+			}
 			else
 				++address;
 
 			if (rdmsr_safe(address, &low, &high))
-				continue;
+				break;
 
 			if (!(high & MASK_VALID_HI)) {
 				if (block)
@@ -138,8 +143,8 @@ void __cpuinit mce_amd_feature_init(stru
 					break;
 			}
 
-			if (!(high & MASK_VALID_HI >> 1)  ||
-			     (high & MASK_VALID_HI >> 2))
+			if (!(high & MASK_CNTP_HI)  ||
+			     (high & MASK_LOCKED_HI))
 				continue;
 
 			if (!block)
@@ -187,17 +192,22 @@ asmlinkage void mce_threshold_interrupt(
 
 	/* assume first bank caused it */
 	for (bank = 0; bank < NR_BANKS; ++bank) {
+		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
+			continue;
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
 				address = MSR_IA32_MC0_MISC + bank * 4;
-			else if (block == 1)
-				address = MCG_XBLK_ADDR
-					+ ((low & MASK_BLKPTR_LO) >> 21);
+			else if (block == 1) {
+				address = (low & MASK_BLKPTR_LO) >> 21;
+				if (!address)
+					break;
+				address += MCG_XBLK_ADDR;
+			}
 			else
 				++address;
 
 			if (rdmsr_safe(address, &low, &high))
-				continue;
+				break;
 
 			if (!(high & MASK_VALID_HI)) {
 				if (block)
@@ -206,8 +216,8 @@ asmlinkage void mce_threshold_interrupt(
 					break;
 			}
 
-			if (!(high & MASK_VALID_HI >> 1)  ||
-			     (high & MASK_VALID_HI >> 2))
+			if (!(high & MASK_CNTP_HI)  ||
+			     (high & MASK_LOCKED_HI))
 				continue;
 
 			if (high & MASK_OVERFLOW_HI) {
@@ -385,7 +395,7 @@ static __cpuinit int allocate_threshold_
 		return 0;
 
 	if (rdmsr_safe(address, &low, &high))
-		goto recurse;
+		return 0;
 
 	if (!(high & MASK_VALID_HI)) {
 		if (block)
@@ -394,8 +404,8 @@ static __cpuinit int allocate_threshold_
 			return 0;
 	}
 
-	if (!(high & MASK_VALID_HI >> 1)  ||
-	     (high & MASK_VALID_HI >> 2))
+	if (!(high & MASK_CNTP_HI)  ||
+	     (high & MASK_LOCKED_HI))
 		goto recurse;
 
 	b = kzalloc(sizeof(struct threshold_block), GFP_KERNEL);
