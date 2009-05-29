Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbZE2Sus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbZE2Sus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZE2Sul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:50:41 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:46947
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751789AbZE2Suk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:50:40 -0400
X-BigFish: VPS1(zzzz1202hzzz32i6bh17ch62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KKF5O1-01-EZC-01
Date: Fri, 29 May 2009 20:49:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: cacheinfo: fixup L3 cache information for AMD
	multi-node processors
Message-ID: <20090529184943.GG23770@alberich.amd.com>
References: <20090529184023.GD23770@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090529184023.GD23770@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 29 May 2009 18:50:25.0775 (UTC) FILETIME=[541A2FF0:01C9E08E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L3 cache size, associativity and shared_cpu information need to be
adapted to show information for an internal node instead of the
entire physical package.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..dbafe2b 100644
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
@@ -278,10 +282,10 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
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
@@ -598,7 +602,15 @@ static void __cpuinit get_cpu_leaves(void *_retval)
 				cache_remove_shared_cpu_map(cpu, i);
 			break;
 		}
+#ifdef CONFIG_MULTI_NODE_CPU
+		if (boot_cpu_has(X86_FEATURE_AMD_DCM))
+			cpumask_copy(to_cpumask(this_leaf->shared_cpu_map),
+				     topology_cpu_node_cpumask(cpu));
+		else
+			cache_shared_cpu_map_setup(cpu, j);
+#else
 		cache_shared_cpu_map_setup(cpu, j);
+#endif
 	}
 }
 
-- 
1.6.3.1



