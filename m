Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZLISgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZLISgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbZLISgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:36:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbZLISgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:36:40 -0500
Date: Wed, 9 Dec 2009 13:36:45 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com,
       bhavna.sarathy@amd.com, mingo@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20091209183336.17855.98708.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: AMD cache - Fix stale data in shared_cpu_map cpumasks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per_cpu cpuid4_info shared_map can contain stale data when CPUs are added
and removed.

The stale data can lead to a NULL pointer derefernce panic on a remove of a
CPU that has had siblings previously removed.

This patch resolves the panic by verifying a cpu is actually online before
adding it to the shared_cpu_map, only examining cpus that are part of
the same lower level cache, and by updating other siblings lowest level cache
maps when a cpu is added.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 0df4c2b..70df1e4 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -504,18 +504,19 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
 	unsigned long num_threads_sharing;
-	int index_msb, i;
+	int index_msb, i, sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	if ((index == 3) && (c->x86_vendor == X86_VENDOR_AMD)) {
-		struct cpuinfo_x86 *d;
-		for_each_online_cpu(i) {
+		for_each_cpu(i, c->llc_shared_map) {
 			if (!per_cpu(cpuid4_info, i))
 				continue;
-			d = &cpu_data(i);
 			this_leaf = CPUID4_INFO_IDX(i, index);
-			cpumask_copy(to_cpumask(this_leaf->shared_cpu_map),
-				     d->llc_shared_map);
+			for_each_cpu(sibling, c->llc_shared_map) {
+				if (!cpu_online(sibling))
+					continue;
+				set_bit(sibling, this_leaf->shared_cpu_map);
+			}
 		}
 		return;
 	}
