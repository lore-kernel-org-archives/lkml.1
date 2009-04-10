Return-Path: <linux-kernel-owner+w=401wt.eu-S938299AbZDJMjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938299AbZDJMjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938216AbZDJMjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:39:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:45872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938139AbZDJMi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:38:57 -0400
Date: Fri, 10 Apr 2009 12:36:57 GMT
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, andreas.herrmann3@amd.com,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, akpm@linux-foundation.org,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409131617.GI31527@alberich.amd.com>
References: <20090409131617.GI31527@alberich.amd.com>
Subject: [tip:x86/cpu] x86: cacheinfo: use cached K8 NB_MISC devices instead of scanning for it
Message-ID: <tip-afd9fceec55225d33be878927056a548c2eef26c@git.kernel.org>
Git-Commit-ID: afd9fceec55225d33be878927056a548c2eef26c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:36:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afd9fceec55225d33be878927056a548c2eef26c
Gitweb:     http://git.kernel.org/tip/afd9fceec55225d33be878927056a548c2eef26c
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 9 Apr 2009 15:16:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 14:21:49 +0200

x86: cacheinfo: use cached K8 NB_MISC devices instead of scanning for it

Impact: avoid code duplication

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
LKML-Reference: <20090409131617.GI31527@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/k8.h             |    8 +++++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |   37 ++------------------------------
 2 files changed, 11 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index 54c8cc5..c23b3d1 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -12,4 +12,12 @@ extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
 extern int k8_scan_nodes(unsigned long start, unsigned long end);
 
+#ifdef CONFIG_K8_NB
+#define node_to_k8_nb_misc(node) \
+	(node < num_k8_northbridges) ? k8_northbridges[node] : NULL
+#else
+#define node_to_k8_nb_misc(node) NULL
+#endif
+
+
 #endif /* _ASM_X86_K8_H */
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1ab46e0..0cde071 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -17,6 +17,7 @@
 
 #include <asm/processor.h>
 #include <asm/smp.h>
+#include <asm/k8.h>
 
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
@@ -159,14 +160,6 @@ struct _cpuid4_info_regs {
 	unsigned long can_disable;
 };
 
-#if defined(CONFIG_PCI) && defined(CONFIG_SYSFS)
-static struct pci_device_id k8_nb_id[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
-	{}
-};
-#endif
-
 unsigned short			num_cache_leaves;
 
 /* AMD doesn't have CPUID4. Emulate it here to report the same
@@ -704,30 +697,6 @@ static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
 #define to_object(k)	container_of(k, struct _index_kobject, kobj)
 #define to_attr(a)	container_of(a, struct _cache_attr, attr)
 
-#ifdef CONFIG_PCI
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	struct pci_dev *dev = NULL;
-	int i;
-
-	for (i = 0; i <= node; i++) {
-		do {
-			dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
-			if (!dev)
-				break;
-		} while (!pci_match_id(&k8_nb_id[0], dev));
-		if (!dev)
-			break;
-	}
-	return dev;
-}
-#else
-static struct pci_dev *get_k8_northbridge(int node)
-{
-	return NULL;
-}
-#endif
-
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
 {
 	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
@@ -739,7 +708,7 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
 	if (!this_leaf->can_disable)
 		return sprintf(buf, "Feature not enabled\n");
 
-	dev = get_k8_northbridge(node);
+	dev = node_to_k8_nb_misc(node);
 	if (!dev) {
 		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
 		return -EINVAL;
@@ -783,7 +752,7 @@ store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 		return -EINVAL;
 
 	val |= 0xc0000000;
-	dev = get_k8_northbridge(node);
+	dev = node_to_k8_nb_misc(node);
 	if (!dev) {
 		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
 		return -EINVAL;
