Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbYACAuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbYACAuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYACAuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:58335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbYACAt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:49:59 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: asit.k.mallick@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/20] x86: Implement support to synchronize RDTSC with LFENCE on Intel CPUs
Message-Id: <20080103004958.44D3314D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:49:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to Intel RDTSC can be always synchronized with LFENCE
on all current CPUs. Implement the necessary CPUID bit for that.

It is unclear yet if that is true for all future CPUs too,
but if there's another way the kernel can be always updated.

Cc: asit.k.mallick@intel.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/intel.c  |    3 ++-
 arch/x86/kernel/setup_64.c   |    5 +----
 include/asm-x86/cpufeature.h |    1 +
 3 files changed, 4 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -899,10 +899,7 @@ static void __cpuinit init_intel(struct 
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	if (c->x86 == 15)
-		set_cpu_cap(c, X86_FEATURE_SYNC_RDTSC);
-	else
-		clear_cpu_cap(c, X86_FEATURE_SYNC_RDTSC);
+	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 	c->x86_max_cores = intel_num_cpu_cores(c);
 
 	srat_detect_node();
Index: linux/include/asm-x86/cpufeature.h
===================================================================
--- linux.orig/include/asm-x86/cpufeature.h
+++ linux/include/asm-x86/cpufeature.h
@@ -80,6 +80,7 @@
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
+#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
Index: linux/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -203,9 +203,10 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
+	if (cpu_has_xmm)
+		set_bit(X86_FEATURE_LFENCE_RDTSC, c->x86_capability);
 	if (c->x86 == 15) {
 		set_bit(X86_FEATURE_P4, c->x86_capability);
-		set_bit(X86_FEATURE_SYNC_RDTSC, c->x86_capability);
 	}
 	if (c->x86 == 6) 
 		set_bit(X86_FEATURE_P3, c->x86_capability);
