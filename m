Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZCENio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZCENio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZCENhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:37:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:49895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZCENhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:37:32 -0500
Date: Thu, 5 Mar 2009 13:36:58 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-4-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-4-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: move pgd_base out of init_memory_mapping()
Message-ID: <tip-e7179853e7552ba6631e2cdd9f5c374383403b4b@git.kernel.org>
Git-Commit-ID: e7179853e7552ba6631e2cdd9f5c374383403b4b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:37:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7179853e7552ba6631e2cdd9f5c374383403b4b
Gitweb:     http://git.kernel.org/tip/e7179853e7552ba6631e2cdd9f5c374383403b4b
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:54:55 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:12 +0100

x86: move pgd_base out of init_memory_mapping()

Impact: cleanup

This patch moves pgd_base out of init_memory_mapping() to reduce
the diff between the 32-bit version and the 64-bit version of the
function.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-4-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 86a9994..cfc68d6 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -227,11 +227,11 @@ static inline int is_kernel_text(unsigned long addr)
  * of max_low_pfn pages, by creating page tables starting from address
  * PAGE_OFFSET:
  */
-static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
-						unsigned long start_pfn,
+static void __init kernel_physical_mapping_init(unsigned long start_pfn,
 						unsigned long end_pfn,
 						int use_pse)
 {
+	pgd_t *pgd_base = swapper_pg_dir;
 	int pgd_idx, pmd_idx, pte_ofs;
 	unsigned long pfn;
 	pgd_t *pgd;
@@ -509,8 +509,9 @@ void __init native_pagetable_setup_done(pgd_t *base)
  * be partially populated, and so it avoids stomping on any existing
  * mappings.
  */
-static void __init early_ioremap_page_table_range_init(pgd_t *pgd_base)
+static void __init early_ioremap_page_table_range_init(void)
 {
+	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long vaddr, end;
 
 	/*
@@ -925,7 +926,6 @@ static int save_mr(struct map_range *mr, int nr_range,
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long pos;
@@ -1040,12 +1040,12 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
-		kernel_physical_mapping_init(pgd_base,
+		kernel_physical_mapping_init(
 				mr[i].start >> PAGE_SHIFT,
 				mr[i].end >> PAGE_SHIFT,
 				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
 
-	early_ioremap_page_table_range_init(pgd_base);
+	early_ioremap_page_table_range_init();
 
 	load_cr3(swapper_pg_dir);
 
