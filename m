Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYACP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYACP1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYACPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:43022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbYACPYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:30 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [15/28] CPA: Don't flush the caches when the CPU supports self-snoop
Message-Id: <20080103152429.E872014E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When the self-snoop CPUID bit is set change_page_attr() only needs to flush
TLBs, but not the caches.

The description of self-snoop in the Intel manuals is a bit vague
but I got confirmation that this is what SS really means.

This should improve c_p_a() performance significantly on newer
Intel CPUs.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c    |    5 +++--
 arch/x86/mm/pageattr_64.c    |    4 ++--
 include/asm-x86/cpufeature.h |    1 +
 3 files changed, 6 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -97,10 +97,11 @@ static void flush_kernel_map(void *arg)
 	struct flush_arg *a = (struct flush_arg *)arg;
 	struct flush *f;
 
-	if ((!cpu_has_clflush || a->full_flush) && boot_cpu_data.x86_model >= 4)
+	if ((!cpu_has_clflush || a->full_flush) && boot_cpu_data.x86_model >= 4 &&
+		!cpu_has_ss)
 		wbinvd();
 	list_for_each_entry(f, &a->l, l) {
-		if (!a->full_flush)
+		if (!a->full_flush && !cpu_has_ss)
 			clflush_cache_range((void *)f->addr, PAGE_SIZE);
 		if (!a->full_flush)
 			__flush_tlb_one(f->addr);
Index: linux/include/asm-x86/cpufeature.h
===================================================================
--- linux.orig/include/asm-x86/cpufeature.h
+++ linux/include/asm-x86/cpufeature.h
@@ -167,6 +167,7 @@
 #define cpu_has_pebs		boot_cpu_has(X86_FEATURE_PEBS)
 #define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
 #define cpu_has_bts		boot_cpu_has(X86_FEATURE_BTS)
+#define cpu_has_ss 		boot_cpu_has(X86_FEATURE_SELFSNOOP)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -94,10 +94,10 @@ static void flush_kernel_map(void *arg)
 
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
-	if (a->full_flush || !cpu_has_clflush)
+	if ((a->full_flush || !cpu_has_clflush) && !cpu_has_ss)
 		asm volatile("wbinvd" ::: "memory");
 	list_for_each_entry(f, &a->l, l) {
-		if (!a->full_flush)
+		if (!a->full_flush && !cpu_has_ss)
 			clflush_cache_range((void *)f->addr, PAGE_SIZE);
 		if (!a->full_flush)
 			__flush_tlb_one(f->addr);
