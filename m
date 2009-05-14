Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZENHka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZENHka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZENHkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:40:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZENHkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:40:17 -0400
Subject: [git-pull -tip][PATCH 0/6] x86: fix mtrr's MSR double declaration
 patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 May 2009 13:01:44 +0530
Message-Id: <1242286304.4574.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4791445ef20cfee28e36e6c3338846618bffa937:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (6):
      x86: mtrr replace MTRRcap_MSR with msr-index's MSR_MTRRcap
      x86: mtrr replace MTRRfix64K_00000_MSR with msr-index's MSR_MTRRfix64K_00000
      x86: mtrr replace MTRRfix16K_80000_MSR with msr-index's MSR_MTRRfix16K_80000
      x86: mtrr remove mtrr MSRs double declaration
      x86: mtrr replace MTRRfix4K_C0000_MSR with msr-index's MSR_MTRRfix4K_C0000
      x86: mtrr replace MTRRdefType_MSR with msr-index's MSR_MTRRdefType

 arch/x86/kernel/cpu/mtrr/cleanup.c |    4 ++--
 arch/x86/kernel/cpu/mtrr/generic.c |   24 ++++++++++++------------
 arch/x86/kernel/cpu/mtrr/main.c    |    2 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h    |   15 ---------------
 arch/x86/kernel/cpu/mtrr/state.c   |    6 +++---
 5 files changed, 18 insertions(+), 33 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index ce0fe4b..1d584a1 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -808,7 +808,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 
 	if (!is_cpu(INTEL) || enable_mtrr_cleanup < 1)
 		return 0;
-	rdmsr(MTRRdefType_MSR, def, dummy);
+	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
@@ -1003,7 +1003,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	 */
 	if (!is_cpu(INTEL) || disable_mtrr_trim)
 		return 0;
-	rdmsr(MTRRdefType_MSR, def, dummy);
+	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index d21d4fb..0543f69 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -20,9 +20,9 @@ struct fixed_range_block {
 };
 
 static struct fixed_range_block fixed_range_blocks[] = {
-	{ MTRRfix64K_00000_MSR, 1 }, /* one  64k MTRR  */
-	{ MTRRfix16K_80000_MSR, 2 }, /* two  16k MTRRs */
-	{ MTRRfix4K_C0000_MSR,  8 }, /* eight 4k MTRRs */
+	{ MSR_MTRRfix64K_00000, 1 }, /* one  64k MTRR  */
+	{ MSR_MTRRfix16K_80000, 2 }, /* two  16k MTRRs */
+	{ MSR_MTRRfix4K_C0000,  8 }, /* eight 4k MTRRs */
 	{}
 };
 
@@ -194,12 +194,12 @@ get_fixed_ranges(mtrr_type * frs)
 
 	k8_check_syscfg_dram_mod_en();
 
-	rdmsr(MTRRfix64K_00000_MSR, p[0], p[1]);
+	rdmsr(MSR_MTRRfix64K_00000, p[0], p[1]);
 
 	for (i = 0; i < 2; i++)
-		rdmsr(MTRRfix16K_80000_MSR + i, p[2 + i * 2], p[3 + i * 2]);
+		rdmsr(MSR_MTRRfix16K_80000 + i, p[2 + i * 2], p[3 + i * 2]);
 	for (i = 0; i < 8; i++)
-		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
+		rdmsr(MSR_MTRRfix4K_C0000 + i, p[6 + i * 2], p[7 + i * 2]);
 }
 
 void mtrr_save_fixed_ranges(void *info)
@@ -310,7 +310,7 @@ void __init get_mtrr_state(void)
 
 	vrs = mtrr_state.var_ranges;
 
-	rdmsr(MTRRcap_MSR, lo, dummy);
+	rdmsr(MSR_MTRRcap, lo, dummy);
 	mtrr_state.have_fixed = (lo >> 8) & 1;
 
 	for (i = 0; i < num_var_ranges; i++)
@@ -318,7 +318,7 @@ void __init get_mtrr_state(void)
 	if (mtrr_state.have_fixed)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 
-	rdmsr(MTRRdefType_MSR, lo, dummy);
+	rdmsr(MSR_MTRRdefType, lo, dummy);
 	mtrr_state.def_type = (lo & 0xff);
 	mtrr_state.enabled = (lo & 0xc00) >> 10;
 
@@ -583,10 +583,10 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	__flush_tlb();
 
 	/*  Save MTRR state */
-	rdmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
+	rdmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 
 	/*  Disable MTRRs, and set the default type to uncached  */
-	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo & ~0xcff, deftype_hi);
+	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
 }
 
 static void post_set(void) __releases(set_atomicity_lock)
@@ -595,7 +595,7 @@ static void post_set(void) __releases(set_atomicity_lock)
 	__flush_tlb();
 
 	/* Intel (P6) standard MTRRs */
-	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
+	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 		
 	/*  Enable caches  */
 	write_cr0(read_cr0() & 0xbfffffff);
@@ -707,7 +707,7 @@ int generic_validate_add_page(unsigned long base, unsigned long size, unsigned i
 static int generic_have_wrcomb(void)
 {
 	unsigned long config, dummy;
-	rdmsr(MTRRcap_MSR, config, dummy);
+	rdmsr(MSR_MTRRcap, config, dummy);
 	return (config & (1 << 10));
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 03cda01..8fc248b 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -104,7 +104,7 @@ static void __init set_num_var_ranges(void)
 	unsigned long config = 0, dummy;
 
 	if (use_intel()) {
-		rdmsr(MTRRcap_MSR, config, dummy);
+		rdmsr(MSR_MTRRcap, config, dummy);
 	} else if (is_cpu(AMD))
 		config = 2;
 	else if (is_cpu(CYRIX) || is_cpu(CENTAUR))
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 77f67f7..7538b76 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -5,21 +5,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 
-#define MTRRcap_MSR     0x0fe
-#define MTRRdefType_MSR 0x2ff
-
-#define MTRRfix64K_00000_MSR 0x250
-#define MTRRfix16K_80000_MSR 0x258
-#define MTRRfix16K_A0000_MSR 0x259
-#define MTRRfix4K_C0000_MSR 0x268
-#define MTRRfix4K_C8000_MSR 0x269
-#define MTRRfix4K_D0000_MSR 0x26a
-#define MTRRfix4K_D8000_MSR 0x26b
-#define MTRRfix4K_E0000_MSR 0x26c
-#define MTRRfix4K_E8000_MSR 0x26d
-#define MTRRfix4K_F0000_MSR 0x26e
-#define MTRRfix4K_F8000_MSR 0x26f
-
 #define MTRR_CHANGE_MASK_FIXED     0x01
 #define MTRR_CHANGE_MASK_VARIABLE  0x02
 #define MTRR_CHANGE_MASK_DEFTYPE   0x04
diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index 7f7e275..1f5fb15 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -35,7 +35,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 
 		if (use_intel())
 			/*  Save MTRR state */
-			rdmsr(MTRRdefType_MSR, ctxt->deftype_lo, ctxt->deftype_hi);
+			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
 		else
 			/* Cyrix ARRs - everything else were excluded at the top */
 			ctxt->ccr3 = getCx86(CX86_CCR3);
@@ -46,7 +46,7 @@ void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
 {
 	if (use_intel())
 		/*  Disable MTRRs, and set the default type to uncached  */
-		mtrr_wrmsr(MTRRdefType_MSR, ctxt->deftype_lo & 0xf300UL,
+		mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo & 0xf300UL,
 		      ctxt->deftype_hi);
 	else if (is_cpu(CYRIX))
 		/* Cyrix ARRs - everything else were excluded at the top */
@@ -64,7 +64,7 @@ void set_mtrr_done(struct set_mtrr_context *ctxt)
 		/*  Restore MTRRdefType  */
 		if (use_intel())
 			/* Intel (P6) standard MTRRs */
-			mtrr_wrmsr(MTRRdefType_MSR, ctxt->deftype_lo, ctxt->deftype_hi);
+			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
 		else
 			/* Cyrix ARRs - everything else was excluded at the top */
 			setCx86(CX86_CCR3, ctxt->ccr3);


