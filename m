Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZCENkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZCENkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZCENiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:38:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:49942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbZCENiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:38:04 -0500
Date: Thu, 5 Mar 2009 13:37:34 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-8-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-8-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: unify kernel_physical_mapping_init() call in init_memory_mapping()
Message-ID: <tip-cbba65796df99f3ca9bf70d14e5a19384c54b6a1@git.kernel.org>
Git-Commit-ID: cbba65796df99f3ca9bf70d14e5a19384c54b6a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:37:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbba65796df99f3ca9bf70d14e5a19384c54b6a1
Gitweb:     http://git.kernel.org/tip/cbba65796df99f3ca9bf70d14e5a19384c54b6a1
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:54:59 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:14 +0100

x86: unify kernel_physical_mapping_init() call in init_memory_mapping()

Impact: cleanup

The 64-bit version of init_memory_mapping() uses the last mapped
address returned from kernel_physical_mapping_init() whereas the
32-bit version doesn't. This patch adds relevant ifdefs to both
versions of the function to reduce the diff between them.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-8-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   10 +++++++++-
 arch/x86/mm/init_64.c |   21 +++++++++++++--------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index cc5c399..00c1d85 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -929,6 +929,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long pos;
+	unsigned long ret;
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
@@ -1040,11 +1041,18 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		find_early_table_space(end, use_pse, use_gbpages);
 
+#ifdef CONFIG_X86_32
 	for (i = 0; i < nr_range; i++)
 		kernel_physical_mapping_init(
 				mr[i].start >> PAGE_SHIFT,
 				mr[i].end >> PAGE_SHIFT,
 				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
+	ret = end;
+#else /* CONFIG_X86_64 */
+	for (i = 0; i < nr_range; i++)
+		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
+						   mr[i].page_size_mask);
+#endif
 
 	early_ioremap_page_table_range_init();
 
@@ -1059,7 +1067,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		early_memtest(start, end);
 
-	return end >> PAGE_SHIFT;
+	return ret >> PAGE_SHIFT;
 }
 
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index c3c0be5..e4fadea 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -686,10 +686,10 @@ static int save_mr(struct map_range *mr, int nr_range,
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	unsigned long last_map_addr = 0;
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long pos;
+	unsigned long ret;
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
@@ -819,10 +819,18 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		find_early_table_space(end, use_pse, use_gbpages);
 
+#ifdef CONFIG_X86_32
+	for (i = 0; i < nr_range; i++)
+		kernel_physical_mapping_init(
+				mr[i].start >> PAGE_SHIFT,
+				mr[i].end >> PAGE_SHIFT,
+				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
+	ret = end;
+#else /* CONFIG_X86_64 */
 	for (i = 0; i < nr_range; i++)
-		last_map_addr = kernel_physical_mapping_init(
-					mr[i].start, mr[i].end,
-					mr[i].page_size_mask);
+		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
+						   mr[i].page_size_mask);
+#endif
 
 	if (!after_bootmem)
 		mmu_cr4_features = read_cr4();
@@ -832,13 +840,10 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
 
-	printk(KERN_INFO "last_map_addr: %lx end: %lx\n",
-			 last_map_addr, end);
-
 	if (!after_bootmem)
 		early_memtest(start, end);
 
-	return last_map_addr >> PAGE_SHIFT;
+	return ret >> PAGE_SHIFT;
 }
 
 #ifndef CONFIG_NUMA
