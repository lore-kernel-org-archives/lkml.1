Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0BOVZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:25:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:49193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab0BOVZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:25:13 -0500
Date: Mon, 15 Feb 2010 21:24:42 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1266234236-24749-1-git-send-email-bp@amd64.org>
References: <1266234236-24749-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Remove NUMA dependency, fix for D1 Isntanbul
Message-ID: <tip-472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7@git.kernel.org>
Git-Commit-ID: 472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 15 Feb 2010 21:24:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7
Gitweb:     http://git.kernel.org/tip/472bf751b56324f8c96d97ada3c9dcdc8b2ec4f7
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 15 Feb 2010 12:43:56 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 15 Feb 2010 12:32:48 -0800

x86, cacheinfo: Remove NUMA dependency, fix for D1 Isntanbul

The show/store_cache_disable routines depend unnecessarily on NUMA's
cpu_to_node and the disabling of cache indices breaks when !CONFIG_NUMA.
Remove that dependency by using a helper which returns always the
correct node id.

While at it, enable L3 Cache Index disable on revD1 Istanbuls which
sport the feature too.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1266234236-24749-1-git-send-email-bp@amd64.org>
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
 
