Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYIFIw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYIFIw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 04:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYIFIwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 04:52:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:39018 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIFIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 04:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=md2rWc9W4zI8AH2Es5CIBLsNYPulmil8vDhkVXuwdBkT7lzsg+C2zaMLzo7dm6mD+X
         jrGGfAhFAOYLHP1D+2ElwNT1gnY2MAG8ymoqPBbaO7zFWtyNPaghGXKLVp6VH7DHfcJC
         gzz9hLKzHPFW1Iq+wgs/SAT6SNk6wxGyrvbIc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/2] x86: calling early_init_xxx in init_xxx
Date: Sat,  6 Sep 2008 01:52:28 -0700
Message-Id: <1220691148-5608-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220691148-5608-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220691148-5608-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so
1. could set some cap to ap
2. restore some cap after memset in identify_cpu for boot cpu

esp for CONSTANT_TSC

before this patch:
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow rep_good nopl pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs

after this patch:
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs

constant_tsc is back...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/amd.c        |    7 ++-----
 arch/x86/kernel/cpu/amd_64.c     |    2 ++
 arch/x86/kernel/cpu/centaur_64.c |    2 ++
 arch/x86/kernel/cpu/common.c     |    7 ++++---
 arch/x86/kernel/cpu/intel_64.c   |    2 ++
 5 files changed, 12 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -26,11 +26,8 @@ __asm__(".align 4\nvide: ret");
 
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpuid_eax(0x80000000) >= 0x80000007) {
-		c->x86_power = cpuid_edx(0x80000007);
-		if (c->x86_power & (1<<8))
-			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-	}
+	if (c->x86_power & (1<<8))
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
 	/*  Set MTRR capability flag if appropriate */
 	if (c->x86_model == 13 || c->x86_model == 9 ||
Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -140,6 +140,8 @@ static void __cpuinit init_amd(struct cp
 	}
 #endif
 
+	early_init_amd(c);
+
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
 	clear_cpu_cap(c, 0*32+31);
Index: linux-2.6/arch/x86/kernel/cpu/centaur_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur_64.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur_64.c
@@ -16,6 +16,8 @@ static void __cpuinit early_init_centaur
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 {
+	early_init_centaur(c);
+
 	if (c->x86 == 0x6 && c->x86_model >= 0xf) {
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -473,9 +473,6 @@ static void __cpuinit get_cpu_cap(struct
 			c->x86_capability[2] = cpuid_edx(0x80860001);
 	}
 
-	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
-
 	if (c->extended_cpuid_level >= 0x80000008) {
 		u32 eax = cpuid_eax(0x80000008);
 
@@ -483,6 +480,10 @@ static void __cpuinit get_cpu_cap(struct
 		c->x86_phys_bits = eax & 0xff;
 	}
 #endif
+
+	if (c->extended_cpuid_level >= 0x80000007)
+		c->x86_power = cpuid_edx(0x80000007);
+
 }
 /*
  * Do minimum CPU detection early.
Index: linux-2.6/arch/x86/kernel/cpu/intel_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_64.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_64.c
@@ -54,6 +54,8 @@ static void __cpuinit srat_detect_node(v
 
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
+	early_init_intel(c);
+
 	init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
