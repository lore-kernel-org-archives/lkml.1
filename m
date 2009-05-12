Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZELPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZELPru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZELPre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:47:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:51103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZELPrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:47:33 -0400
Subject: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
In-Reply-To: <1242142692.2547.15.camel@ht.satnam>
References: <1242142530.2547.11.camel@ht.satnam>
	 <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 12 May 2009 21:09:13 +0530
Message-Id: <1242142753.2547.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add Advanced Power Management (Function 8000_0007h), edx

/proc/cpuinfo (before)
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16
lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname

/proc/cpuinfo (after)
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good tsc_reliable nonstop_tsc pni cx16
lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit pname
ts ttp htc stc 100mhzsteps hwpstate constant_tsc

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |   14 ++++++++++++--
 arch/x86/kernel/cpu/common.c      |   10 ++++++----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e1a4cc4..d37ab0f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS		10	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -76,7 +76,6 @@
 #define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
 #define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
 #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
 #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
@@ -164,6 +163,17 @@
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
 
+/* Advanced Power Management (Function 8000_0007h), edx			*/
+#define X86_FEATURE_TS		(9*32+ 0) /* Temperatue sensor		*/
+#define X86_FEATURE_FID		(9*32+ 1) /* Frequency ID control	*/
+#define X86_FEATURE_VID		(9*32+ 2) /* Voltage ID control		*/
+#define X86_FEATURE_TTP		(9*32+ 3) /* Thermal trip		*/
+#define X86_FEATURE_HTC		(9*32+ 4) /* Hardware thermal control	*/
+#define X86_FEATURE_STC		(9*32+ 5) /* Software thermal control	*/
+#define X86_FEATURE_100MHZSTEPS	(9*32+ 6) /* 100 MHz multiplier control	*/
+#define X86_FEATURE_HWPSTATE	(9*32+ 7) /* Hardware P-State control	*/
+#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks	*/
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3994feb..a428b36 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -573,6 +573,12 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x80000004)
 		set_cpu_cap(c, X86_FEATURE_PNAME);
 
+	/* Advanced Power Management (Function 8000_0007h), edx */
+	if (c->extended_cpuid_level >= 0x80000007){
+		c->x86_capability[9] = cpuid_edx(0x80000007);
+		c->x86_power = cpuid_edx(0x80000007);
+	}
+
 	if (c->extended_cpuid_level >= 0x80000008) {
 		u32 eax = cpuid_eax(0x80000008);
 
@@ -583,10 +589,6 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	else if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
 		c->x86_phys_bits = 36;
 #endif
-
-	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
-
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
-- 
1.6.0.6



