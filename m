Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbYC0XhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbYC0XhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYC0Xg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:36:58 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49660 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYC0Xg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:36:57 -0400
Subject: [PATCH 2/5] [PPC] htab_remove_mapping() error handling
From: Badari Pulavarty <pbadari@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com>
References: <1206664406.19368.2.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 16:37:21 -0800
Message-Id: <1206664642.19368.8.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the sub-arch doesn't support hpte_removebolted(), gracefully
return failure rather than success.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 arch/powerpc/mm/hash_utils_64.c |   14 +++++++++-----
 include/asm-powerpc/sparsemem.h |    2 +-
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc3/arch/powerpc/mm/hash_utils_64.c
===================================================================
--- linux-2.6.25-rc3.orig/arch/powerpc/mm/hash_utils_64.c	2008-03-05 10:14:28.000000000 -0800
+++ linux-2.6.25-rc3/arch/powerpc/mm/hash_utils_64.c	2008-03-05 10:18:55.000000000 -0800
@@ -192,7 +192,7 @@ int htab_bolt_mapping(unsigned long vsta
 	return ret < 0 ? ret : 0;
 }
 
-static void htab_remove_mapping(unsigned long vstart, unsigned long vend,
+static int htab_remove_mapping(unsigned long vstart, unsigned long vend,
 		      int psize, int ssize)
 {
 	unsigned long vaddr;
@@ -202,12 +202,15 @@ static void htab_remove_mapping(unsigned
 	step = 1 << shift;
 
 	if (!ppc_md.hpte_removebolted) {
-		printk("Sub-arch doesn't implement hpte_removebolted\n");
-		return;
+		printk(KERN_WARNING "Sub-arch doesn't implement "
+				"hpte_removebolted\n");
+		return -EINVAL;
 	}
 
 	for (vaddr = vstart; vaddr < vend; vaddr += step)
 		ppc_md.hpte_removebolted(vaddr, psize, ssize);
+
+	return 0;
 }
 
 static int __init htab_dt_scan_seg_sizes(unsigned long node,
@@ -449,9 +452,10 @@ void create_section_mapping(unsigned lon
 			mmu_linear_psize, mmu_kernel_ssize));
 }
 
-void remove_section_mapping(unsigned long start, unsigned long end)
+int remove_section_mapping(unsigned long start, unsigned long end)
 {
-	htab_remove_mapping(start, end, mmu_linear_psize, mmu_kernel_ssize);
+	return htab_remove_mapping(start, end, mmu_linear_psize,
+			mmu_kernel_ssize);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
Index: linux-2.6.25-rc3/include/asm-powerpc/sparsemem.h
===================================================================
--- linux-2.6.25-rc3.orig/include/asm-powerpc/sparsemem.h	2008-03-05 10:14:31.000000000 -0800
+++ linux-2.6.25-rc3/include/asm-powerpc/sparsemem.h	2008-03-05 10:19:09.000000000 -0800
@@ -15,7 +15,7 @@
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern void create_section_mapping(unsigned long start, unsigned long end);
-extern void remove_section_mapping(unsigned long start, unsigned long end);
+extern int remove_section_mapping(unsigned long start, unsigned long end);
 #ifdef CONFIG_NUMA
 extern int hot_add_scn_to_nid(unsigned long scn_addr);
 #else


