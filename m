Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZHaNCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZHaNCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZHaNCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:02:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:24295 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZHaNCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:02:30 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KP8S7X-01-A3O-02
X-M-MSG: 
Date: Mon, 31 Aug 2009 15:01:29 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86, cacheinfo: Fixup L3 cache information for AMD
	multi-node processors
Message-ID: <20090831130129.GE21867@alberich.amd.com>
References: <20090831125349.GA21867@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090831125349.GA21867@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Aug 2009 13:01:29.0265 (UTC) FILETIME=[27CCCA10:01CA2A3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


L3 cache size, associativity and shared_cpu information need to be
adapted to show information for an internal node instead of the
entire physical package.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 306bf0d..41bdada 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -241,7 +241,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	case 0:
 		if (!l1->val)
 			return;
-		assoc = l1->assoc;
+		assoc = assocs[l1->assoc];
 		line_size = l1->line_size;
 		lines_per_tag = l1->lines_per_tag;
 		size_in_kb = l1->size_in_kb;
@@ -249,7 +249,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	case 2:
 		if (!l2.val)
 			return;
-		assoc = l2.assoc;
+		assoc = assocs[l2.assoc];
 		line_size = l2.line_size;
 		lines_per_tag = l2.lines_per_tag;
 		/* cpu_data has errata corrections for K7 applied */
@@ -258,10 +258,14 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	case 3:
 		if (!l3.val)
 			return;
-		assoc = l3.assoc;
+		assoc = assocs[l3.assoc];
 		line_size = l3.line_size;
 		lines_per_tag = l3.lines_per_tag;
 		size_in_kb = l3.size_encoded * 512;
+		if (boot_cpu_has(X86_FEATURE_AMD_DCM)) {
+			size_in_kb = size_in_kb >> 1;
+			assoc = assoc >> 1;
+		}
 		break;
 	default:
 		return;
@@ -270,18 +274,14 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	eax->split.is_self_initializing = 1;
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
-	if (leaf == 3)
-		eax->split.num_threads_sharing =
-			current_cpu_data.x86_max_cores - 1;
-	else
-		eax->split.num_threads_sharing = 0;
+	eax->split.num_threads_sharing = 0;
 	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
 
 
-	if (assoc == 0xf)
+	if (assoc == 0xffff)
 		eax->split.is_fully_associative = 1;
 	ebx->split.coherency_line_size = line_size - 1;
-	ebx->split.ways_of_associativity = assocs[assoc] - 1;
+	ebx->split.ways_of_associativity = assoc - 1;
 	ebx->split.physical_line_partition = lines_per_tag - 1;
 	ecx->split.number_of_sets = (size_in_kb * 1024) / line_size /
 		(ebx->split.ways_of_associativity + 1) - 1;
@@ -523,6 +523,16 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 	int index_msb, i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
+	if ((index == 3) && (c->x86_vendor == X86_VENDOR_AMD)) {
+		for_each_online_cpu(i) {
+			if (!per_cpu(cpuid4_info, i))
+				continue;
+			this_leaf = CPUID4_INFO_IDX(i, index);
+			cpumask_copy(to_cpumask(this_leaf->shared_cpu_map),
+				     cpu_node_mask(i));
+		}
+		return;
+	}
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	num_threads_sharing = 1 + this_leaf->eax.split.num_threads_sharing;
 
-- 
1.6.4



