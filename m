Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYLHLkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYLHLkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYLHLhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48264 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 17/45] x86: Export some definition of MTRR
Date: Mon,  8 Dec 2008 13:36:28 +0200
Message-Id: <1228736216-15787-18-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

For KVM can reuse the type define, and need them to support shadow MTRR.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/include/asm/mtrr.h        |   25 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/mtrr/generic.c |   12 +++---------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |   17 -----------------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 7c1e425..cb988aa 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -57,6 +57,31 @@ struct mtrr_gentry {
 };
 #endif /* !__i386__ */
 
+struct mtrr_var_range {
+	u32 base_lo;
+	u32 base_hi;
+	u32 mask_lo;
+	u32 mask_hi;
+};
+
+/* In the Intel processor's MTRR interface, the MTRR type is always held in
+   an 8 bit field: */
+typedef u8 mtrr_type;
+
+#define MTRR_NUM_FIXED_RANGES 88
+#define MTRR_MAX_VAR_RANGES 256
+
+struct mtrr_state_type {
+	struct mtrr_var_range var_ranges[MTRR_MAX_VAR_RANGES];
+	mtrr_type fixed_ranges[MTRR_NUM_FIXED_RANGES];
+	unsigned char enabled;
+	unsigned char have_fixed;
+	mtrr_type def_type;
+};
+
+#define MTRRphysBase_MSR(reg) (0x200 + 2 * (reg))
+#define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
+
 /*  These are the various ioctls  */
 #define MTRRIOC_ADD_ENTRY        _IOW(MTRR_IOCTL_BASE,  0, struct mtrr_sentry)
 #define MTRRIOC_SET_ENTRY        _IOW(MTRR_IOCTL_BASE,  1, struct mtrr_sentry)
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 90db91e..b59ddcc 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -14,14 +14,6 @@
 #include <asm/pat.h>
 #include "mtrr.h"
 
-struct mtrr_state_type {
-	struct mtrr_var_range var_ranges[MTRR_MAX_VAR_RANGES];
-	mtrr_type fixed_ranges[MTRR_NUM_FIXED_RANGES];
-	unsigned char enabled;
-	unsigned char have_fixed;
-	mtrr_type def_type;
-};
-
 struct fixed_range_block {
 	int base_msr; /* start address of an MTRR block */
 	int ranges;   /* number of MTRRs in this block  */
@@ -35,10 +27,12 @@ static struct fixed_range_block fixed_range_blocks[] = {
 };
 
 static unsigned long smp_changes_mask;
-static struct mtrr_state_type mtrr_state = {};
 static int mtrr_state_set;
 u64 mtrr_tom2;
 
+struct mtrr_state_type mtrr_state = {};
+EXPORT_SYMBOL_GPL(mtrr_state);
+
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
 
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 9885382..ffd6040 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -8,12 +8,6 @@
 #define MTRRcap_MSR     0x0fe
 #define MTRRdefType_MSR 0x2ff
 
-#define MTRRphysBase_MSR(reg) (0x200 + 2 * (reg))
-#define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
-
-#define MTRR_NUM_FIXED_RANGES 88
-#define MTRR_MAX_VAR_RANGES 256
-
 #define MTRRfix64K_00000_MSR 0x250
 #define MTRRfix16K_80000_MSR 0x258
 #define MTRRfix16K_A0000_MSR 0x259
@@ -30,10 +24,6 @@
 #define MTRR_CHANGE_MASK_VARIABLE  0x02
 #define MTRR_CHANGE_MASK_DEFTYPE   0x04
 
-/* In the Intel processor's MTRR interface, the MTRR type is always held in
-   an 8 bit field: */
-typedef u8 mtrr_type;
-
 extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 
 struct mtrr_ops {
@@ -71,13 +61,6 @@ struct set_mtrr_context {
 	u32 ccr3;
 };
 
-struct mtrr_var_range {
-	u32 base_lo;
-	u32 base_hi;
-	u32 mask_lo;
-	u32 mask_hi;
-};
-
 void set_mtrr_done(struct set_mtrr_context *ctxt);
 void set_mtrr_cache_disable(struct set_mtrr_context *ctxt);
 void set_mtrr_prepare_save(struct set_mtrr_context *ctxt);
-- 
1.6.0.3

