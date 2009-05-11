Return-Path: <linux-kernel-owner+w=401wt.eu-S1758082AbZEKKLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbZEKKLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZEKKL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:11:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:50744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603AbZEKKL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:11:26 -0400
Date: Mon, 11 May 2009 10:10:35 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241699741.17846.30.camel@penberg-laptop>
References: <1241699741.17846.30.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: unify 64-bit UMA and NUMA paging_init()
Message-ID: <tip-3551f88f6439cf4da3f5a3747b320280e30500de@git.kernel.org>
Git-Commit-ID: 3551f88f6439cf4da3f5a3747b320280e30500de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 10:10:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3551f88f6439cf4da3f5a3747b320280e30500de
Gitweb:     http://git.kernel.org/tip/3551f88f6439cf4da3f5a3747b320280e30500de
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Thu, 7 May 2009 15:35:41 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 11:52:06 +0200

x86: unify 64-bit UMA and NUMA paging_init()

64-bit UMA and NUMA versions of paging_init() are almost identical.
Therefore, merge the copy in mm/numa_64.c to mm/init_64.c to remove
duplicate code.

[ Impact: cleanup ]

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1241699741.17846.30.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_64.c |    6 +++++-
 arch/x86/mm/numa_64.c |   15 ---------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 6a1a573..be7e127 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -585,6 +585,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
 	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 }
+#endif
 
 void __init paging_init(void)
 {
@@ -595,11 +596,14 @@ void __init paging_init(void)
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
index 2d05a12..fb61d81 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -578,21 +578,6 @@ unsigned long __init numa_free_all_bootmem(void)
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
