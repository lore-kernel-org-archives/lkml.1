Return-Path: <linux-kernel-owner+w=401wt.eu-S1763172AbZDINRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763172AbZDINRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZDINQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:16:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:13689 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbZDINQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:16:57 -0400
X-BigFish: VPS-4(z34a4jz936eQzz1202hzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KHU4V3-01-LZU-01
Date: Thu, 9 Apr 2009 15:16:17 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [PATCH 5/8] x86: cacheinfo: use cached K8 NB_MISC devices instead
	of scanning for it
Message-ID: <20090409131617.GI31527@alberich.amd.com>
References: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090409125659.GD31527@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 13:16:18.0555 (UTC) FILETIME=[5E5FACB0:01C9B915]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: avoid code duplication

CC: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/k8.h             |    8 +++++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |   37 ++------------------------------
 2 files changed, 11 insertions(+), 34 deletions(-)

Ingo,

you have asked for a function to replace the exported
k8_northbridges array.

Actually this is a good idea and I'll look at it.
But this also requires additional changes in pci-gart_64.c
And I don't like to mix such changes with this cache_disable stuff.

For the time beeing I provide a small macro to access the array.

Regards,
Andreas


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
index 9dac235..50f7b88 100644
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
 
-#ifdef CONFIG_PCI
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
-- 
1.6.2



