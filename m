Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbZLKBYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbZLKBYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761788AbZLKBYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:24:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:50487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761625AbZLKBYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:24:52 -0500
Date: Fri, 11 Dec 2009 01:24:35 GMT
From: tip-bot for Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <20091209183336.17855.98708.sendpatchset@prarit.bos.redhat.com>
References: <20091209183336.17855.98708.sendpatchset@prarit.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, AMD: Fix stale cpuid4_info shared_map data in shared_cpu_map cpumasks
Message-ID: <tip-ebb682f522411abbe358059a256a8672ec0bd55b@git.kernel.org>
Git-Commit-ID: ebb682f522411abbe358059a256a8672ec0bd55b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebb682f522411abbe358059a256a8672ec0bd55b
Gitweb:     http://git.kernel.org/tip/ebb682f522411abbe358059a256a8672ec0bd55b
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Wed, 9 Dec 2009 13:36:45 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Dec 2009 17:19:03 -0800

x86, AMD: Fix stale cpuid4_info shared_map data in shared_cpu_map cpumasks

The per_cpu cpuid4_info shared_map can contain stale data when CPUs are added
and removed.

The stale data can lead to a NULL pointer derefernce panic on a remove of a
CPU that has had siblings previously removed.

This patch resolves the panic by verifying a cpu is actually online before
adding it to the shared_cpu_map, only examining cpus that are part of
the same lower level cache, and by updating other siblings lowest level cache
maps when a cpu is added.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
LKML-Reference: <20091209183336.17855.98708.sendpatchset@prarit.bos.redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6c40f6b..63ada17 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -507,18 +507,19 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
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
