Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZEKRAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZEKRAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZEKQ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:59:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:34770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbZEKQ7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:59:34 -0400
Subject: [PATCH 4/15 -tip] x86: Add cpufeature for Cache MSRs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060254.5139.12.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:15:01 +0530
Message-Id: <1242060301.5139.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_CACHE : BBL_CR_* MSRs (Pentium II and Pentium III processors)
X86_FEATURE_CACHE_CTL : Cache control MSRs

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 arch/x86/kernel/cpu/amd.c         |    6 ++++++
 arch/x86/kernel/cpu/intel.c       |   21 +++++++++++++++++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 06b0919..da88aa0 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -156,6 +156,8 @@
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
 #define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
 #define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
+#define X86_FEATURE_CACHE	(7*32+ 4) /* BBL_CR_* MSRs (PII & PIII)	*/
+#define X86_FEATURE_CACHE_CTL	(7*32+ 5) /* Cache control MSRs		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2c1931f..e2fe8e2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -476,6 +476,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* Set cpufeatures for miscellaneous MSRs			*/
+	if (c->x86 >= 0x10) {				/* fam10h+	*/
+		/* MSRC001_1022 Data Cache Configuration (DC_CFG)	*/
+		set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 330f42c..cb198ed 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -390,6 +390,27 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
+
+	/* Set cpufeatures for miscellaneous MSRs			*/
+	if (c->x86 == 6) {
+		switch (c->x86_model) {
+		case 3: case 5:				/* Pentium II	*/
+		case 7: case 8: case 0xA: case 0xB:	/* Pentium III	*/
+			/* BBL_CR_* MSRs (Pentium II & III processors)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			break;
+
+		case 9:	case 0xD:			/* Pentium M	*/
+		case 0xE:				/* Core		*/
+		case 0xF: case 0x17:			/* Core 2	*/
+		case 0x1C:				/* ATOM		*/
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			break;
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
1.6.0.6



