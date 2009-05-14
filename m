Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZENHnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZENHnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbZENHmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:42:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:49458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761406AbZENHmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:42:13 -0400
Subject: [PATCH 6/6] x86: mtrr replace MTRRdefType_MSR with msr-index's
 MSR_MTRRdefType
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1242286645.4574.21.camel@localhost.localdomain>
References: <1242286304.4574.15.camel@localhost.localdomain>
	 <1242286427.4574.17.camel@localhost.localdomain>
	 <1242286484.4574.18.camel@localhost.localdomain>
	 <1242286549.4574.19.camel@localhost.localdomain>
	 <1242286604.4574.20.camel@localhost.localdomain>
	 <1242286645.4574.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 13:08:05 +0530
Message-Id: <1242286685.4574.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use standard msr-index.h's MSR declaration and no need to declare again.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    4 ++--
 arch/x86/kernel/cpu/mtrr/generic.c |    8 ++++----
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    2 --
 arch/x86/kernel/cpu/mtrr/state.c   |    6 +++---
 4 files changed, 9 insertions(+), 11 deletions(-)

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
index 26c07d0..0543f69 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
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
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index e5ee686..7538b76 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -5,8 +5,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 
-#define MTRRdefType_MSR 0x2ff
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
-- 
1.6.0.6



