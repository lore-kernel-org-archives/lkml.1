Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZHKNTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZHKNTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZHKNTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:19:06 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34205 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZHKNTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:19:04 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KO7RNH-03-K5U-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86: Print amd virtualization features in /proc/cpuinfo
Date: Tue, 11 Aug 2009 15:18:52 +0200
Message-ID: <1249996732-13794-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 11 Aug 2009 13:18:53.0628 (UTC) FILETIME=[4606EFC0:01CA1A86]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to cpu initialization path to detect the extended
virtualization features of AMD cpus and shows them in /proc/cpuinfo.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/cpufeature.h |    5 +++++
 arch/x86/kernel/cpu/amd.c         |   25 +++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4a28d22..d3218e3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -165,6 +165,11 @@
 #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
+#define X86_FEATURE_LBRV	(8*32+6)  /* LBR Virtualization support */
+#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" SVM locking MSR */
+#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" svm next_rip save */
+
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ec6c7a8..ac567d4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -367,6 +367,28 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 }
 
+static void __cpuinit detect_amd_virt_flags(struct cpuinfo_x86 *c)
+{
+
+#define SVM_FEATURE_NPT_MASK   0x00000001
+#define SVM_FEATURE_LBRV_MASK  0x00000002
+#define SVM_FEATURE_SVML_MASK  0x00000004
+#define SVM_FEATURE_NRIPS_MASK 0x00000008
+
+	u32 virt_flags;
+
+	virt_flags = cpuid_edx(0x8000000A);
+
+	if (virt_flags & SVM_FEATURE_NPT_MASK)
+		set_cpu_cap(c,  X86_FEATURE_NPT);
+	if (virt_flags & SVM_FEATURE_LBRV_MASK)
+		set_cpu_cap(c,  X86_FEATURE_LBRV);
+	if (virt_flags & SVM_FEATURE_SVML_MASK)
+		set_cpu_cap(c,  X86_FEATURE_SVML);
+	if (virt_flags & SVM_FEATURE_NRIPS_MASK)
+		set_cpu_cap(c,  X86_FEATURE_NRIPS);
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
@@ -499,6 +521,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	if (cpu_has(c, X86_FEATURE_SVM))
+		detect_amd_virt_flags(c);
 }
 
 #ifdef CONFIG_X86_32
-- 
1.6.3.3


