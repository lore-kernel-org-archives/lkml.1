Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYBKJwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYBKJwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYBKJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:26 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:30333 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYBKJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:24 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support self-snoop
Message-Id: <20080211095022.7B8C31B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:22 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:44:01.0329 (UTC) FILETIME=[A1A8FA10:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[2.6.25 candidate I believe]

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
@@ -74,7 +74,7 @@ static void __cpa_flush_all(void *arg)
 	 */
 	__flush_tlb_all();
 
-	if (cache && boot_cpu_data.x86_model >= 4)
+	if (!cpu_has_ss && cache && boot_cpu_data.x86_model >= 4)
 		wbinvd();
 }
 
@@ -108,6 +108,9 @@ static void cpa_flush_range(unsigned lon
 	if (!cache)
 		return;
 
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
@@ -157,6 +157,7 @@ extern const char * const x86_power_flag
 #define cpu_has_mtrr		boot_cpu_has(X86_FEATURE_MTRR)
 #define cpu_has_mmx		boot_cpu_has(X86_FEATURE_MMX)
 #define cpu_has_fxsr		boot_cpu_has(X86_FEATURE_FXSR)
+#define cpu_has_ss		boot_cpu_has(X86_FEATURE_SELFSNOOP)
 #define cpu_has_xmm		boot_cpu_has(X86_FEATURE_XMM)
 #define cpu_has_xmm2		boot_cpu_has(X86_FEATURE_XMM2)
 #define cpu_has_xmm3		boot_cpu_has(X86_FEATURE_XMM3)
