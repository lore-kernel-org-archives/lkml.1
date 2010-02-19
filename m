Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0BSGKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:10:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:41437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0BSGKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:10:00 -0500
Date: Fri, 19 Feb 2010 06:09:36 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <20100218184339.GG20473@aftab>
References: <20100218184339.GG20473@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Remove NUMA dependency, fix for AMD Fam10h rev D1
Message-ID: <tip-f619b3d8427eb57f0134dab75b0d217325c72411@git.kernel.org>
Git-Commit-ID: f619b3d8427eb57f0134dab75b0d217325c72411
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 06:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f619b3d8427eb57f0134dab75b0d217325c72411
Gitweb:     http://git.kernel.org/tip/f619b3d8427eb57f0134dab75b0d217325c72411
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 4 Feb 2010 12:09:07 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Feb 2010 21:58:57 -0800

x86, cacheinfo: Remove NUMA dependency, fix for AMD Fam10h rev D1

The show/store_cache_disable routines depend unnecessarily on NUMA's
cpu_to_node and the disabling of cache indices broke when !CONFIG_NUMA.
Remove that dependency by using a helper which is always correct.

While at it, enable L3 Cache Index disable on rev D1 Istanbuls which
sport the feature too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100218184339.GG20473@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 589b705..be5f5c2 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -327,7 +327,7 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 
 	/* see errata #382 and #388 */
 	if ((boot_cpu_data.x86 == 0x10) &&
-	    ((boot_cpu_data.x86_model < 0x9) ||
+	    ((boot_cpu_data.x86_model < 0x8) ||
 	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
@@ -744,7 +744,7 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int index)
 {
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
+	int node = amd_get_nb_id(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned int reg = 0;
 
@@ -771,7 +771,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	const char *buf, size_t count, unsigned int index)
 {
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
+	int node = amd_get_nb_id(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned long val = 0;
 
