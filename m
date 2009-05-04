Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbZEDRit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbZEDRit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZEDRik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:38:40 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:1497 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755095AbZEDRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:38:39 -0400
X-BigFish: VPS0(zz936eQzz1202hzzz32i6bh15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ4RNP-01-2LX-01
Date: Mon, 4 May 2009 19:37:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: cacheinfo: fixup L3 cache information for AMD
	multi-node CPU
Message-ID: <20090504173743.GI28728@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090504173330.GF28728@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 May 2009 17:38:04.0417 (UTC) FILETIME=[141FC710:01C9CCDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


L3 cache size, associativity and shared_cpu information need to be
adapted to show information for one internal node instead of the
entire physical package.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..4918fc9 100644
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
@@ -598,7 +602,11 @@ static void __cpuinit get_cpu_leaves(void *_retval)
 				cache_remove_shared_cpu_map(cpu, i);
 			break;
 		}
-		cache_shared_cpu_map_setup(cpu, j);
+		if (boot_cpu_has(X86_FEATURE_AMD_DCM))
+			cpumask_copy(to_cpumask(this_leaf->shared_cpu_map),
+				     topology_core_cpumask(cpu));
+		else
+			cache_shared_cpu_map_setup(cpu, j);
 	}
 }
 
-- 
1.6.2



