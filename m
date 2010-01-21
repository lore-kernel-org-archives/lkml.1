Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945Ab0AUQlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0AUQlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605Ab0AUQl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:41:29 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38414 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0AUQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:41:25 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] x86, cacheinfo: Fix disabling of L3 cache indices
Date: Thu, 21 Jan 2010 17:41:31 +0100
Message-Id: <1264092093-13739-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264092093-13739-1-git-send-email-bp@amd64.org>
References: <1264092093-13739-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

* Correct the masks used for writing the cache index disable indices.
* Do not turn off L3 scrubber - it is not necessary.
* Make sure wbinvd is executed on the same node where the L3 is.
* Check for out-of-bounds values written to the registers.
* Make show_cache_disable hex values unambiguous
* Check for Erratum #388

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fc6c8ef..cef4fdd 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -18,6 +18,7 @@
 #include <asm/processor.h>
 #include <linux/smp.h>
 #include <asm/k8.h>
+#include <asm/smp.h>
 
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
@@ -299,8 +300,10 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	if (boot_cpu_data.x86 == 0x11)
 		return;
 
-	/* see erratum #382 */
-	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x8))
+	/* see errata #382 and #388 */
+	if ((boot_cpu_data.x86 == 0x10) &&
+	    ((boot_cpu_data.x86_model < 0x9) ||
+	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
 	this_leaf->can_disable = 1;
@@ -726,12 +729,12 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 		return -EINVAL;
 
 	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
-	return sprintf(buf, "%x\n", reg);
+	return sprintf(buf, "0x%08x\n", reg);
 }
 
 #define SHOW_CACHE_DISABLE(index)					\
 static ssize_t								\
-show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)  	\
+show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
 {									\
 	return show_cache_disable(this_leaf, buf, index);		\
 }
@@ -745,7 +748,9 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	int node = cpu_to_node(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned long val = 0;
-	unsigned int scrubber = 0;
+
+#define SUBCACHE_MASK	(3UL << 20)
+#define SUBCACHE_INDEX	0xfff
 
 	if (!this_leaf->can_disable)
 		return -EINVAL;
@@ -759,21 +764,20 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
-	val |= 0xc0000000;
-
-	pci_read_config_dword(dev, 0x58, &scrubber);
-	scrubber &= ~0x1f000000;
-	pci_write_config_dword(dev, 0x58, scrubber);
+	/* do not allow writes outside of allowed bits */
+	if (val & ~(SUBCACHE_MASK | SUBCACHE_INDEX))
+		return -EINVAL;
 
-	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
-	wbinvd();
+	val |= BIT(30);
 	pci_write_config_dword(dev, 0x1BC + index * 4, val);
+	wbinvd_on_cpu(cpu);
+	pci_write_config_dword(dev, 0x1BC + index * 4, val | BIT(31));
 	return count;
 }
 
 #define STORE_CACHE_DISABLE(index)					\
 static ssize_t								\
-store_cache_disable_##index(struct _cpuid4_info *this_leaf,	     	\
+store_cache_disable_##index(struct _cpuid4_info *this_leaf,		\
 			    const char *buf, size_t count)		\
 {									\
 	return store_cache_disable(this_leaf, buf, count, index);	\
-- 
1.6.6

