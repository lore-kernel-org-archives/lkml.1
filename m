Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYACAui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYACAui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYACAt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:49:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:58333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbYACAt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:49:58 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: andreas.herrmann3@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/20] x86: Implement support to synchronize RDTSC through MFENCE on AMD CPUs
Message-Id: <20080103004957.36B1414D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:49:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to AMD RDTSC can be synchronized through MFENCE.
Implement the necessary CPUID bit for that.

Cc: andreas.herrmann3@amd.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/amd.c    |    3 +++
 arch/x86/kernel/setup_64.c   |    4 ++--
 include/asm-x86/cpufeature.h |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -757,8 +757,8 @@ static void __cpuinit init_amd(struct cp
 	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_K8);
 
-	/* RDTSC can be speculated around */
-	clear_cpu_cap(c, X86_FEATURE_SYNC_RDTSC);
+	/* MFENCE stops RDTSC speculation */
+	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
Index: linux/include/asm-x86/cpufeature.h
===================================================================
--- linux.orig/include/asm-x86/cpufeature.h
+++ linux/include/asm-x86/cpufeature.h
@@ -79,6 +79,7 @@
 /* 14 free */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
+#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
Index: linux/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/amd.c
+++ linux/arch/x86/kernel/cpu/amd.c
@@ -301,6 +301,9 @@ static void __cpuinit init_amd(struct cp
 	/* K6s reports MCEs but don't actually have all the MSRs */
 	if (c->x86 < 6)
 		clear_bit(X86_FEATURE_MCE, c->x86_capability);
+
+	if (cpu_has_xmm)
+		set_bit(X86_FEATURE_MFENCE_RDTSC, c->x86_capability);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
