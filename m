Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZEKREV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZEKREV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZEKRBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:01:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:43755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbZEKRBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:01:44 -0400
Subject: [PATCH 15/15 -tip] x86: Add cpufeature for ancient performance
 monitoring
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242060905.5139.24.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
	 <1242060119.5139.9.camel@ht.satnam>  <1242060207.5139.11.camel@ht.satnam>
	 <1242060254.5139.12.camel@ht.satnam>  <1242060301.5139.13.camel@ht.satnam>
	 <1242060523.5139.15.camel@ht.satnam>  <1242060567.5139.16.camel@ht.satnam>
	 <1242060601.5139.17.camel@ht.satnam>  <1242060644.5139.18.camel@ht.satnam>
	 <1242060681.5139.19.camel@ht.satnam>  <1242060721.5139.20.camel@ht.satnam>
	 <1242060771.5139.21.camel@ht.satnam>  <1242060812.5139.22.camel@ht.satnam>
	 <1242060858.5139.23.camel@ht.satnam>  <1242060905.5139.24.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:25:47 +0530
Message-Id: <1242060947.5139.25.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


X86_FEATURE_ARCH_PERFMON uses almost different MSRs as compare to
ancient performance monitoring, so introduced X86_FEATURE_PERFMON
to friendly access ancient performance monitor MSRs:

X86_FEATURE_PERFMON : performance monitoring for !X86_FEATURE_ARCH_PERFMON

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    2 ++
 arch/x86/kernel/cpu/intel.c       |    4 +++-
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index b91cb47..f660e99 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -169,6 +169,7 @@
 #define X86_FEATURE_MM_CFG 	(7*32+ 14) /* MM configuration		*/
 #define X86_FEATURE_BUS_CFG 	(7*32+ 15) /* Bus configuration		*/
 #define X86_FEATURE_PERF_FREQ 	(7*32+ 16) /* Performance frequency	*/
+#define X86_FEATURE_PERFMON 	(7*32+ 17) /* Performance monitoring	*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4b7f7dc..849d794 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -481,6 +481,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 7) {				/* K7+		*/
 		/* MSRC001_0015 Hardware Configuration Register (HWCR)	*/
 		set_cpu_cap(c, X86_FEATURE_HW_CFG);
+		/* Performance monitoring support			*/
+		set_cpu_cap(c, X86_FEATURE_PERFMON);
 	}
 	if (c->x86 >= 8) {				/* K8+		*/
 		/*
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9c5169c..e3ce8c6 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -310,7 +310,9 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		/* Check for version and the number of counters */
 		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
-	}
+	} else if (c->x86 >= 5)
+		/* ancient performance monitoring support */
+		set_cpu_cap(c, X86_FEATURE_PERFMON);
 
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-- 
1.6.0.6



