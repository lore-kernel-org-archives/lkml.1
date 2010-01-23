Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534Ab0AWAoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0AWAoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232Ab0AWAoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:44:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:52445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab0AWAoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:44:07 -0500
Date: Sat, 23 Jan 2010 00:43:38 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1264172467-25155-6-git-send-email-bp@amd64.org>
References: <1264172467-25155-6-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Calculate L3 indices
Message-ID: <tip-048a8774ca43488d78605031f11cc206d7a2682a@git.kernel.org>
Git-Commit-ID: 048a8774ca43488d78605031f11cc206d7a2682a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Jan 2010 00:43:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  048a8774ca43488d78605031f11cc206d7a2682a
Gitweb:     http://git.kernel.org/tip/048a8774ca43488d78605031f11cc206d7a2682a
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 22 Jan 2010 16:01:07 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 22 Jan 2010 16:06:31 -0800

x86, cacheinfo: Calculate L3 indices

We need to know the valid L3 indices interval when disabling them over
/sysfs. Do that when the core is brought online and add boundary checks
to the sysfs .store attribute.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-6-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   35 +++++++++++++++++++++++++++++---
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 3976ce9..589b705 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -151,7 +151,8 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
@@ -161,7 +162,8 @@ struct _cpuid4_info_regs {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 };
 
 unsigned short			num_cache_leaves;
@@ -291,6 +293,29 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
+static unsigned int __cpuinit amd_calc_l3_indices(void)
+{
+	/*
+	 * We're called over smp_call_function_single() and therefore
+	 * are on the correct cpu.
+	 */
+	int cpu = smp_processor_id();
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int sc0, sc1, sc2, sc3;
+	u32 val;
+
+	pci_read_config_dword(dev, 0x1C4, &val);
+
+	/* calculate subcache sizes */
+	sc0 = !(val & BIT(0));
+	sc1 = !(val & BIT(4));
+	sc2 = !(val & BIT(8))  + !(val & BIT(9));
+	sc3 = !(val & BIT(12)) + !(val & BIT(13));
+
+	return (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+}
+
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
@@ -306,7 +331,8 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
-	this_leaf->can_disable = 1;
+	this_leaf->can_disable = true;
+	this_leaf->l3_indices  = amd_calc_l3_indices();
 }
 
 static int
@@ -765,7 +791,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 		return -EINVAL;
 
 	/* do not allow writes outside of allowed bits */
-	if (val & ~(SUBCACHE_MASK | SUBCACHE_INDEX))
+	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
 		return -EINVAL;
 
 	val |= BIT(30);
