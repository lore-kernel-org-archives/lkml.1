Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab0BYXwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:52:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:40521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934553Ab0BYXwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:52:15 -0500
Date: Thu, 25 Feb 2010 23:51:46 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <alpine.DEB.2.00.1002241703570.1180@melkki.cs.helsinki.fi>
References: <alpine.DEB.2.00.1002241703570.1180@melkki.cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Unify kernel_physical_mapping_init() API
Message-ID: <tip-c1fd1b43831fa20c91cdd461342af8edf2e87c2f@git.kernel.org>
Git-Commit-ID: c1fd1b43831fa20c91cdd461342af8edf2e87c2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 23:51:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1fd1b43831fa20c91cdd461342af8edf2e87c2f
Gitweb:     http://git.kernel.org/tip/c1fd1b43831fa20c91cdd461342af8edf2e87c2f
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Wed, 24 Feb 2010 17:04:47 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 25 Feb 2010 15:15:21 -0800

x86, mm: Unify kernel_physical_mapping_init() API

This patch changes the 32-bit version of kernel_physical_mapping_init() to
return the last mapped address like the 64-bit one so that we can unify the
call-site in init_memory_mapping().

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <alpine.DEB.2.00.1002241703570.1180@melkki.cs.helsinki.fi>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/init.c    |    7 -------
 arch/x86/mm/init_32.c |    8 +++++---
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d406c52..e71c5cb 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -266,16 +266,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		find_early_table_space(end, use_pse, use_gbpages);
 
-#ifdef CONFIG_X86_32
-	for (i = 0; i < nr_range; i++)
-		kernel_physical_mapping_init(mr[i].start, mr[i].end,
-					     mr[i].page_size_mask);
-	ret = end;
-#else /* CONFIG_X86_64 */
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
 						   mr[i].page_size_mask);
-#endif
 
 #ifdef CONFIG_X86_32
 	early_ioremap_page_table_range_init();
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 9a0c258..2226f2c 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -241,6 +241,7 @@ kernel_physical_mapping_init(unsigned long start,
 			     unsigned long page_size_mask)
 {
 	int use_pse = page_size_mask == (1<<PG_LEVEL_2M);
+	unsigned long last_map_addr = end;
 	unsigned long start_pfn, end_pfn;
 	pgd_t *pgd_base = swapper_pg_dir;
 	int pgd_idx, pmd_idx, pte_ofs;
@@ -341,9 +342,10 @@ repeat:
 					prot = PAGE_KERNEL_EXEC;
 
 				pages_4k++;
-				if (mapping_iter == 1)
+				if (mapping_iter == 1) {
 					set_pte(pte, pfn_pte(pfn, init_prot));
-				else
+					last_map_addr = (pfn << PAGE_SHIFT) + PAGE_SIZE;
+				} else
 					set_pte(pte, pfn_pte(pfn, prot));
 			}
 		}
@@ -368,7 +370,7 @@ repeat:
 		mapping_iter = 2;
 		goto repeat;
 	}
-	return 0;
+	return last_map_addr;
 }
 
 pte_t *kmap_pte;
