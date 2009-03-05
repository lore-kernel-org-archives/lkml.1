Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZCENi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZCENi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZCENhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:37:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:49876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbZCENhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:37:19 -0500
Date: Thu, 5 Mar 2009 13:36:40 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-2-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-2-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: add gbpages support to 32-bit init_memory_mapping()
Message-ID: <tip-4bbd4fa03832208f0e6e0b9e73a0ffa2620a626a@git.kernel.org>
Git-Commit-ID: 4bbd4fa03832208f0e6e0b9e73a0ffa2620a626a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:36:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bbd4fa03832208f0e6e0b9e73a0ffa2620a626a
Gitweb:     http://git.kernel.org/tip/4bbd4fa03832208f0e6e0b9e73a0ffa2620a626a
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:54:53 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:11 +0100

x86: add gbpages support to 32-bit init_memory_mapping()

Impact: cleanup

To reduce the diff between the 32-bit and 64-bit versions of
init_memory_mapping(), add gbpages support to the 32-bit version.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-2-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index ad4e03c..5fad0f9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -65,6 +65,8 @@ static unsigned long __meminitdata table_top;
 
 static int __initdata after_init_bootmem;
 
+int direct_gbpages;
+
 static __init void *alloc_low_page(void)
 {
 	unsigned long pfn = table_end++;
@@ -831,14 +833,22 @@ void __init setup_bootmem_allocator(void)
 	after_init_bootmem = 1;
 }
 
-static void __init find_early_table_space(unsigned long end, int use_pse)
+static void __init find_early_table_space(unsigned long end, int use_pse,
+					  int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 
-	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	if (use_gbpages) {
+		unsigned long extra;
+
+		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
+		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+	} else
+		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
 	if (use_pse) {
@@ -913,7 +923,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
-	int use_pse;
+	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
@@ -923,9 +933,10 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * This will simplify cpa(), which otherwise needs to support splitting
 	 * large pages into small in interrupt context, etc.
 	 */
-	use_pse = 0;
+	use_pse = use_gbpages = 0;
 #else
 	use_pse = cpu_has_pse;
+	use_gbpages = direct_gbpages;
 #endif
 
 #ifdef CONFIG_X86_PAE
@@ -944,6 +955,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 
+	if (use_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
 	if (use_pse)
 		page_size_mask |= 1 << PG_LEVEL_2M;
 
@@ -1015,7 +1028,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_init_bootmem)
-		find_early_table_space(end, use_pse);
+		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		kernel_physical_mapping_init(pgd_base,
