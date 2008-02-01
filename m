Return-Path: <linux-kernel-owner+w=401wt.eu-S1763692AbYBAJ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763692AbYBAJ6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbYBAJzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:55:18 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:49686 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbYBAJzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:55:15 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <200802011055.370582801@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] CPA: Don't flush caches on CPUs that support self-snoop
Date: Fri,  1 Feb 2008 10:55:13 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:48:55.0907 (UTC) FILETIME=[A91C8330:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The specification of SS in the public manuals is a little unclear,
but I got confirmation from Intel that SS implies that there is no cache
flush needed on caching attribute changes.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c       |    5 ++++-
 include/asm-x86/cpufeature.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -60,7 +60,7 @@ static void __cpa_flush_all(void *arg)
 	 */
 	__flush_tlb_all();
 
-	if (boot_cpu_data.x86_model >= 4)
+	if (!cpu_has_ss && boot_cpu_data.x86_model >= 4)
 		wbinvd();
 }
 
@@ -91,6 +91,9 @@ static void cpa_flush_range(unsigned lon
 
 	on_each_cpu(__cpa_flush_range, NULL, 1, 1);
 
+	if (cpu_has_ss)
+		return;
+
 	/*
 	 * We only need to flush on one CPU,
 	 * clflush is a MESI-coherent instruction that
Index: linux/include/asm-x86/cpufeature.h
===================================================================
--- linux.orig/include/asm-x86/cpufeature.h
+++ linux/include/asm-x86/cpufeature.h
@@ -153,6 +153,7 @@
 #define cpu_has_mtrr		boot_cpu_has(X86_FEATURE_MTRR)
 #define cpu_has_mmx		boot_cpu_has(X86_FEATURE_MMX)
 #define cpu_has_fxsr		boot_cpu_has(X86_FEATURE_FXSR)
+#define cpu_has_ss		boot_cpu_has(X86_FEATURE_SELFSNOOP)
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
 #define cpu_has_xmm2		boot_cpu_has(X86_FEATURE_XMM2)
 #define cpu_has_xmm3		boot_cpu_has(X86_FEATURE_XMM3)
