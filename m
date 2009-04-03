Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbZDCPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbZDCPk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZDCPkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:40:13 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:18577
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755024AbZDCPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:40:11 -0400
X-BigFish: VPS-11(zz936eQ4015Mzz1202hzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KHJ7IK-01-G2Y-01
Date: Fri, 3 Apr 2009 18:07:21 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [PATCH] x86: cacheinfo: fix build error in cache_disable
Message-ID: <20090403160721.GC6466@alberich.amd.com>
References: <20090402100756.GN5740@alberich.amd.com> <20090402103008.GA10828@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090402103008.GA10828@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Apr 2009 15:39:59.0109 (UTC) FILETIME=[72255350:01C9B472]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix build error

Commit 45ca863 (x86, cpu: conform L3 Cache Index Disable to Linux standard)
introduced following build error with CONFIG_K8_NB=n
  ...
  arch/x86/mm/built-in.o:(.bss+0x5c0): multiple definition of `k8_northbridges'
  arch/x86/kernel/built-in.o:(.bss+0x18c8): first defined here
  ...

The patch deactivates cache_disable functionality for kernels with
CONFIG_K8_NB=n.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/k8.h             |    4 ----
 arch/x86/kernel/cpu/intel_cacheinfo.c |   19 ++++++++++++++++---
 2 files changed, 16 insertions(+), 7 deletions(-)

The real fix would be to enable cache index disable functionality also
for kernels with CONFIG_K8_NB=n but I don't have time to provide such
a patch today.

Ingo, please either apply this (compile tested) patch or revert Mark's
patch to avoid further blocking of tip/x86/cpu branch.


Thanks,

Andreas


diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index 0d619c3..54c8cc5 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -6,11 +6,7 @@
 extern struct pci_device_id k8_nb_ids[];
 
 extern int early_is_k8_nb(u32 value);
-#ifdef CONFIG_K8_NB
 extern struct pci_dev **k8_northbridges;
-#else
-struct pci_dev **k8_northbridges;
-#endif
 extern int num_k8_northbridges;
 extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6f4d2a3..63e4468 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -640,14 +640,23 @@ static ssize_t show_##file_name						\
 	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
 
+#ifndef CONFIG_K8_NB
+struct pci_dev **k8_northbridges = NULL;
+#endif
+
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 		 unsigned int index)
 {
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = k8_northbridges[node];
+	struct pci_dev *dev;
 	unsigned int reg = 0;
 
+	if (!k8_northbridges)
+		return -EINVAL;
+
+	dev = k8_northbridges[node];
+
 	if (!this_leaf->can_disable)
 		return -EINVAL;
 
@@ -668,10 +677,15 @@ store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 {
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 	int node = cpu_to_node(cpu);
-	struct pci_dev *dev = k8_northbridges[node];
+	struct pci_dev *dev;
 	unsigned long val = 0;
 	unsigned int scrubber = 0;
 
+	if (!k8_northbridges)
+		return -EINVAL;
+
+	dev = k8_northbridges[node];
+
 	if (!this_leaf->can_disable)
 		return -EINVAL;
 
@@ -786,7 +800,6 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		 show_cache_disable_1, store_cache_disable_1);
 
-
 static struct attribute * default_attrs[] = {
 	&type.attr,
 	&level.attr,
-- 
1.6.2



