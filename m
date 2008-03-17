Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYCQCDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYCQCDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbYCQB6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:32 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:18079 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbYCQB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:31 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [15/18] Add support to x86-64 to allocate and lookup GB pages in hugetlb
Message-Id: <20080317015829.1FA4F1B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:29 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:54.0861 (UTC) FILETIME=[7A3A39D0:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/hugetlbpage.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/hugetlbpage.c
===================================================================
--- linux.orig/arch/x86/mm/hugetlbpage.c
+++ linux/arch/x86/mm/hugetlbpage.c
@@ -133,9 +133,14 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	pgd = pgd_offset(mm, addr);
 	pud = pud_alloc(mm, pgd, addr);
 	if (pud) {
-		if (pud_none(*pud))
-			huge_pmd_share(mm, addr, pud);
-		pte = (pte_t *) pmd_alloc(mm, pud, addr);
+		if (sz == PUD_SIZE) {
+			pte = (pte_t *)pud;
+		} else {
+			BUG_ON(sz != PMD_SIZE);
+			if (pud_none(*pud))
+				huge_pmd_share(mm, addr, pud);
+			pte = (pte_t *) pmd_alloc(mm, pud, addr);
+		}
 	}
 	BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));
 
@@ -151,8 +156,11 @@ pte_t *huge_pte_offset(struct mm_struct 
 	pgd = pgd_offset(mm, addr);
 	if (pgd_present(*pgd)) {
 		pud = pud_offset(pgd, addr);
-		if (pud_present(*pud))
+		if (pud_present(*pud)) {
+			if (pud_large(*pud))
+				return (pte_t *)pud;
 			pmd = pmd_offset(pud, addr);
+		}
 	}
 	return (pte_t *) pmd;
 }
