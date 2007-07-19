Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbXGSKD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbXGSKD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbXGSJzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:35353 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbXGSJzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:06 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [17/58] i386: Add L3 cache support to AMD CPUID4 emulation
Message-Id: <20070719095502.1718214E0B@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With that an L3 cache is correctly reported in the cache information in /sys

With fixes from Andreas Herrmann and Dean Gaudet

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/intel_cacheinfo.c |   74 ++++++++++++++++++++++++---------
 arch/x86_64/kernel/setup.c             |    7 ++-
 2 files changed, 60 insertions(+), 21 deletions(-)

Index: linux/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ linux/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -4,7 +4,7 @@
  *      Changes:
  *      Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
  *		Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
- *	Andi Kleen		: CPUID4 emulation on AMD.
+ *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
  */
 
 #include <linux/init.h>
@@ -135,7 +135,7 @@ unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
    information to the user.  This makes some assumptions about the machine:
-   No L3, L2 not shared, no SMT etc. that is currently true on AMD CPUs.
+   L2 not shared, no SMT etc. that is currently true on AMD CPUs.
 
    In theory the TLBs could be reported as fake type (they are in "dummy").
    Maybe later */
@@ -159,13 +159,26 @@ union l2_cache {
 	unsigned val;
 };
 
+union l3_cache {
+	struct {
+		unsigned line_size : 8;
+		unsigned lines_per_tag : 4;
+		unsigned assoc : 4;
+		unsigned res : 2;
+		unsigned size_encoded : 14;
+	};
+	unsigned val;
+};
+
 static const unsigned short assocs[] = {
 	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
-	[8] = 16,
+	[8] = 16, [0xa] = 32, [0xb] = 48,
+	[0xc] = 64,
 	[0xf] = 0xffff // ??
-	};
-static const unsigned char levels[] = { 1, 1, 2 };
-static const unsigned char types[] = { 1, 2, 3 };
+};
+
+static const unsigned char levels[] = { 1, 1, 2, 3 };
+static const unsigned char types[] = { 1, 2, 3, 3 };
 
 static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		       union _cpuid4_leaf_ebx *ebx,
@@ -175,37 +188,60 @@ static void __cpuinit amd_cpuid4(int lea
 	unsigned line_size, lines_per_tag, assoc, size_in_kb;
 	union l1_cache l1i, l1d;
 	union l2_cache l2;
+	union l3_cache l3;
+	union l1_cache *l1 = &l1d;
 
 	eax->full = 0;
 	ebx->full = 0;
 	ecx->full = 0;
 
 	cpuid(0x80000005, &dummy, &dummy, &l1d.val, &l1i.val);
-	cpuid(0x80000006, &dummy, &dummy, &l2.val, &dummy);
-
-	if (leaf > 2 || !l1d.val || !l1i.val || !l2.val)
-		return;
+	cpuid(0x80000006, &dummy, &dummy, &l2.val, &l3.val);
 
-	eax->split.is_self_initializing = 1;
-	eax->split.type = types[leaf];
-	eax->split.level = levels[leaf];
-	eax->split.num_threads_sharing = 0;
-	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
-
-	if (leaf <= 1) {
-		union l1_cache *l1 = leaf == 0 ? &l1d : &l1i;
+	switch (leaf) {
+	case 1:
+		l1 = &l1i;
+	case 0:
+		if (!l1->val)
+			return;
 		assoc = l1->assoc;
 		line_size = l1->line_size;
 		lines_per_tag = l1->lines_per_tag;
 		size_in_kb = l1->size_in_kb;
-	} else {
+		break;
+	case 2:
+		if (!l2.val)
+			return;
 		assoc = l2.assoc;
 		line_size = l2.line_size;
 		lines_per_tag = l2.lines_per_tag;
 		/* cpu_data has errata corrections for K7 applied */
 		size_in_kb = current_cpu_data.x86_cache_size;
+		break;
+	case 3:
+		if (!l3.val)
+			return;
+		assoc = l3.assoc;
+		line_size = l3.line_size;
+		lines_per_tag = l3.lines_per_tag;
+		switch (l3.size_encoded) {
+		case 4:  size_in_kb = 2 * 1024; break;
+		case 8:  size_in_kb = 4 * 1024; break;
+		case 12: size_in_kb = 6 * 1024; break;
+		default: size_in_kb = 0; break;
+		}
+		break;
+	default:
+		return;
 	}
 
+	eax->split.is_self_initializing = 1;
+	eax->split.type = types[leaf];
+	eax->split.level = levels[leaf];
+	eax->split.num_threads_sharing = 0;
+	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
+
+
 	if (assoc == 0xf)
 		eax->split.is_fully_associative = 1;
 	ebx->split.coherency_line_size = line_size - 1;
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -602,8 +602,11 @@ static void __cpuinit init_amd(struct cp
 	if (c->extended_cpuid_level >= 0x80000008)
 		amd_detect_cmp(c);
 
-	/* Fix cpuid4 emulation for more */
-	num_cache_leaves = 3;
+	if (c->extended_cpuid_level >= 0x80000006 &&
+		(cpuid_edx(0x80000006) & 0xf000))
+		num_cache_leaves = 4;
+	else
+		num_cache_leaves = 3;
 
 	/* RDTSC can be speculated around */
 	clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
