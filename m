Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0BOLny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:43:54 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45979 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0BOLnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:43:53 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [RESEND PATCH] x86, cacheinfo: Remove NUMA dependency
Date: Mon, 15 Feb 2010 12:43:56 +0100
Message-Id: <1266234236-24749-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The show/store_cache_disable routines depend unnecessarily on NUMA's
cpu_to_node and the disabling of cache indices breaks when !CONFIG_NUMA.
Remove that dependency by using a helper which returns always the
correct node id.

While at it, enable L3 Cache Index disable on revD1 Istanbuls which
sport the feature too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
 
-- 
1.6.6.1

