Return-Path: <linux-kernel-owner+w=401wt.eu-S1946472AbXEAEFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946472AbXEAEFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXEAEBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:48971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946497AbXEAD6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:14 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [15/30] i386: Implement X86_FEATURE_SYNC_RDTSC on i386
Message-Id: <20070501035813.2109313CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Syncs up with x86-64.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/intel.c  |    4 +++-
 include/asm-i386/cpufeature.h |    1 +
 include/asm-i386/tsc.h        |    4 ----
 3 files changed, 4 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/intel.c
+++ linux/arch/i386/kernel/cpu/intel.c
@@ -188,8 +188,10 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
-	if (c->x86 == 15)
+	if (c->x86 == 15) {
 		set_bit(X86_FEATURE_P4, c->x86_capability);
+		set_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
+	}
 	if (c->x86 == 6) 
 		set_bit(X86_FEATURE_P3, c->x86_capability);
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -79,6 +79,7 @@
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
 #define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
+#define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
Index: linux/include/asm-i386/tsc.h
===================================================================
--- linux.orig/include/asm-i386/tsc.h
+++ linux/include/asm-i386/tsc.h
@@ -35,7 +35,6 @@ static inline cycles_t get_cycles(void)
 static __always_inline cycles_t get_cycles_sync(void)
 {
 	unsigned long long ret;
-#ifdef X86_FEATURE_SYNC_RDTSC
 	unsigned eax;
 
 	/*
@@ -44,9 +43,6 @@ static __always_inline cycles_t get_cycl
 	 */
 	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
 			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-#else
-	sync_core();
-#endif
 	rdtscll(ret);
 
 	return ret;
