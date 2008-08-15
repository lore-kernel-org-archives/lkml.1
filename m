Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbYHOM66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbYHOM66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYHOM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:58:37 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54076 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYHOM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:58:36 -0400
Date: Fri, 15 Aug 2008 13:58:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix /proc/meminfo DirectMap
Message-ID: <Pine.LNX.4.64.0808151351220.28840@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we actually want these DirectMap lines in the x86 /proc/meminfo?
I can see they're interesting to CPA developers and TLB optimizers,
but they don't fit its usual "where has all my memory gone?" usage.
If they are to stay, here are some fixes.

1. On x86_32 without PAE, they're not 2M but 4M pages: no need to
   mess with the internal enum, but show the right name to users.

2. Many machines can never show anything but 0 for DirectMap1G,
   so suppress that line unless direct_gbpages are really enabled.

3. The unit in /proc/meminfo is kB not number of pages: HugePages
   messed that up, but they're an example to regret not to follow.

4. Once we use kB, it's easy to see that 1GB has gone missing (which
   explains why CONFIG_CPA_DEBUG=y soon wraps DirectMap2M negative):
   because head_64.S's level2_ident_pgt entries were not counted.
   My fix is not ideal, but works for more and for less than 1G,
   and avoids interfering with early bootup pagetable contortions.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
You might prefer me to split these up?

Should we really be using level2_ident_pgt (which needs to avoid NX)
for the final direct map (which wants to use NX)?  But my attempt
to build up a fresh pagetable there failed miserably to boot!

 arch/x86/mm/init_64.c  |    6 +++++-
 arch/x86/mm/pageattr.c |   18 ++++++++++++------
 2 files changed, 17 insertions(+), 7 deletions(-)

--- 2.6.27-rc3/arch/x86/mm/init_64.c	2008-07-29 04:24:15.000000000 +0100
+++ linux/arch/x86/mm/init_64.c	2008-08-13 16:37:41.000000000 +0100
@@ -60,7 +60,7 @@ static unsigned long dma_reserve __initd
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-int direct_gbpages __meminitdata
+int direct_gbpages
 #ifdef CONFIG_DIRECT_GBPAGES
 				= 1
 #endif
@@ -314,6 +314,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 {
 	unsigned long pages = 0;
 	unsigned long last_map_addr = end;
+	unsigned long start = address;
 
 	int i = pmd_index(address);
 
@@ -334,6 +335,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 			if (!pmd_large(*pmd))
 				last_map_addr = phys_pte_update(pmd, address,
 								 end);
+			/* Count entries we're using from level2_ident_pgt */
+			if (start == 0)
+				pages++;
 			continue;
 		}
 
--- 2.6.27-rc3/arch/x86/mm/pageattr.c	2008-07-29 04:24:15.000000000 +0100
+++ linux/arch/x86/mm/pageattr.c	2008-08-13 04:37:27.000000000 +0100
@@ -55,13 +55,19 @@ static void split_page_count(int level)
 
 int arch_report_meminfo(char *page)
 {
-	int n = sprintf(page, "DirectMap4k:  %8lu\n"
-			"DirectMap2M:  %8lu\n",
-			direct_pages_count[PG_LEVEL_4K],
-			direct_pages_count[PG_LEVEL_2M]);
+	int n = sprintf(page, "DirectMap4k:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_4K] << 2);
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+	n += sprintf(page + n, "DirectMap2M:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_2M] << 11);
+#else
+	n += sprintf(page + n, "DirectMap4M:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_2M] << 12);
+#endif
 #ifdef CONFIG_X86_64
-	n += sprintf(page + n, "DirectMap1G:  %8lu\n",
-		     direct_pages_count[PG_LEVEL_1G]);
+	if (direct_gbpages)
+		n += sprintf(page + n, "DirectMap1G:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_1G] << 20);
 #endif
 	return n;
 }
