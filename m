Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZG1PGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZG1PGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZG1PGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:42 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26547 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZG1PGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:38 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNHZAQ-01-0O9-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH 04/20] x86: cacheinfo: fixup L3 cache information for AMD Magny-Cours
Date: Tue, 28 Jul 2009 17:06:04 +0200
Message-ID: <1248793580-29899-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:24.0097 (UTC) FILETIME=[F905E510:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

L3 cache size, associativity and shared_cpu information need to be
adapted to show information for an internal node instead of the
entire physical package.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..3b54a1e 100644
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
+				     topology_cpu_node_cpumask(cpu));
+		else
+			cache_shared_cpu_map_setup(cpu, j);
 	}
 }
 
-- 
1.6.3.3


