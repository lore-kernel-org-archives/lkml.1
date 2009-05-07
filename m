Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbZEGMfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbZEGMfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbZEGMfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:35:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41829 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbZEGMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:35:42 -0400
Subject: [PATCH 1/2] x86: unify 64-bit UMA and NUMA paging_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 07 May 2009 15:35:41 +0300
Message-Id: <1241699741.17846.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

64-bit UMA and NUMA versions of paging_init() are almost identical.
Therefore, merge the copy in mm/numa_64.c to mm/init_64.c to remove
duplicate code.

[ Impact: cleanup ]

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_64.c |    6 +++++-
 arch/x86/mm/numa_64.c |   15 ---------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1753e80..ccc0e6e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -628,6 +628,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
 	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 }
+#endif
 
 void __init paging_init(void)
 {
@@ -638,11 +639,14 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
+#ifdef CONFIG_NUMA
+	sparse_memory_present_with_active_regions(MAX_NUMNODES);
+#else
 	memory_present(0, 0, max_pfn);
+#endif
 	sparse_init();
 	free_area_init_nodes(max_zone_pfns);
 }
-#endif
 
 /*
  * Memory hotplug specific functions
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index d73aaa8..b816922 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -575,21 +575,6 @@ unsigned long __init numa_free_all_bootmem(void)
 	return pages;
 }
 
-void __init paging_init(void)
-{
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-	max_zone_pfns[ZONE_NORMAL] = max_pfn;
-
-	sparse_memory_present_with_active_regions(MAX_NUMNODES);
-	sparse_init();
-
-	free_area_init_nodes(max_zone_pfns);
-}
-
 static __init int numa_setup(char *opt)
 {
 	if (!opt)
-- 
1.5.6.3



