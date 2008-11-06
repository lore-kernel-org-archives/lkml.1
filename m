Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYKFAsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYKFAsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYKFAsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:48:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41232 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYKFAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:48:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH] (cleanup) get rid of #ifdef CONFIG_MIGRATION
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081106094458.0D32.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  6 Nov 2008 09:48:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


#ifdef in *.c file decrease source readability a bit.
removing is better.

this patch doesn't have any functional change.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/migrate.h |    4 ++++
 mm/mprotect.c           |    6 ++----
 mm/rmap.c               |   10 +++-------
 3 files changed, 9 insertions(+), 11 deletions(-)

Index: b/include/linux/migrate.h
===================================================================
--- a/include/linux/migrate.h	2008-11-06 09:26:07.000000000 +0900
+++ b/include/linux/migrate.h	2008-11-06 09:34:47.000000000 +0900
@@ -7,6 +7,8 @@
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
 #ifdef CONFIG_MIGRATION
+#define PAGE_MIGRATION 1
+
 extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -20,6 +22,8 @@ extern int migrate_vmas(struct mm_struct
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
 #else
+#define PAGE_MIGRATION 0
+
 static inline int putback_lru_pages(struct list_head *l) { return 0; }
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private) { return -ENOSYS; }
Index: b/mm/mprotect.c
===================================================================
--- a/mm/mprotect.c	2008-11-06 09:26:11.000000000 +0900
+++ b/mm/mprotect.c	2008-11-06 09:37:43.000000000 +0900
@@ -22,6 +22,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mmu_notifier.h>
+#include <linux/migrate.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
@@ -59,8 +60,7 @@ static void change_pte_range(struct mm_s
 				ptent = pte_mkwrite(ptent);
 
 			ptep_modify_prot_commit(mm, addr, pte, ptent);
-#ifdef CONFIG_MIGRATION
-		} else if (!pte_file(oldpte)) {
+		} else if (PAGE_MIGRATION && !pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
 			if (is_write_migration_entry(entry)) {
@@ -72,9 +72,7 @@ static void change_pte_range(struct mm_s
 				set_pte_at(mm, addr, pte,
 					swp_entry_to_pte(entry));
 			}
-#endif
 		}
-
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
Index: b/mm/rmap.c
===================================================================
--- a/mm/rmap.c	2008-11-06 09:26:11.000000000 +0900
+++ b/mm/rmap.c	2008-11-06 09:38:35.000000000 +0900
@@ -50,6 +50,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
+#include <linux/migrate.h>
 
 #include <asm/tlbflush.h>
 
@@ -818,8 +819,7 @@ static int try_to_unmap_one(struct page 
 				spin_unlock(&mmlist_lock);
 			}
 			dec_mm_counter(mm, anon_rss);
-#ifdef CONFIG_MIGRATION
-		} else {
+		} else if (PAGE_MIGRATION) {
 			/*
 			 * Store the pfn of the page in a special migration
 			 * pte. do_swap_page() will wait until the migration
@@ -827,19 +827,15 @@ static int try_to_unmap_one(struct page 
 			 */
 			BUG_ON(!migration);
 			entry = make_migration_entry(page, pte_write(pteval));
-#endif
 		}
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 		BUG_ON(pte_file(*pte));
-	} else
-#ifdef CONFIG_MIGRATION
-	if (migration) {
+	} else if (PAGE_MIGRATION && migration) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
 		entry = make_migration_entry(page, pte_write(pteval));
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 	} else
-#endif
 		dec_mm_counter(mm, file_rss);
 
 


