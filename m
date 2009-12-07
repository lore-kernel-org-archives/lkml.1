Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbZLGIBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbZLGIBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbZLGIBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:01:41 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49090 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962AbZLGIB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:01:27 -0500
Message-ID: <4B1CB5D9.8000504@ah.jp.nec.com>
Date: Mon, 07 Dec 2009 16:59:21 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reply-To: n-horiguchi@ah.jp.nec.com
Organization: NEC Corporation
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: hugh.dickins@tiscali.co.uk, linux-mm <linux-mm@kvack.org>
Subject: [PATCH 1/2] mm hugetlb x86: fix hugepage memory leak in walk_page_range()
References: <1260172193-14397-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1260172193-14397-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 mm/pagewalk.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index d5878be..3d88824 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
+#include <linux/hugetlb.h>
 
 static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
@@ -107,6 +108,7 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
+	struct vm_area_struct *vma;
 
 	if (addr >= end)
 		return err;
@@ -117,11 +119,21 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	pgd = pgd_offset(walk->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
+
+		/* skip hugetlb vma to avoid hugepage PMD being cleared
+		 * in pmd_none_or_clear_bad(). */
+		vma = find_vma(walk->mm, addr);
+		if (is_vm_hugetlb_page(vma)) {
+			next = (vma->vm_end < next) ? vma->vm_end : next;
+			continue;
+		}
+
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
+			pgd++;
 			continue;
 		}
 		if (walk->pgd_entry)
@@ -131,7 +143,8 @@ int walk_page_range(unsigned long addr, unsigned long end,
 			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
-	} while (pgd++, addr = next, addr != end);
+		pgd++;
+	} while (addr = next, addr != end);
 
 	return err;
 }
-- 
1.6.0.6


