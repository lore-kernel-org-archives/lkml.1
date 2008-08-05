Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbYHEPcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbYHEPcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbYHEPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:32:26 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:45227 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbYHEPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:32:25 -0400
Subject: [PATCH] hugetlb: call arch_prepare_hugepage() for surplus pages
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@us.ibm.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 17:29:07 +0200
Message-Id: <1217950147.5032.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

The s390 software large page emulation implements shared page tables
by using page->index of the first tail page from a compound large page
to store page table information. This is set up in arch_prepare_hugepage(),
which is called from alloc_fresh_huge_page_node().

A similar call to arch_prepare_hugepage() is missing for surplus large
pages that are allocated in alloc_buddy_huge_page(), which breaks the
software emulation mode for (surplus) large pages on s390. This patch
adds the missing call to arch_prepare_hugepage(). It will have no effect
on other architectures where arch_prepare_hugepage() is a nop.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---

 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux/mm/hugetlb.c
===================================================================
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -565,7 +565,7 @@ static struct page *alloc_fresh_huge_pag
 		huge_page_order(h));
 	if (page) {
 		if (arch_prepare_hugepage(page)) {
-			__free_pages(page, HUGETLB_PAGE_ORDER);
+			__free_pages(page, huge_page_order(h));
 			return NULL;
 		}
 		prep_new_huge_page(h, page, nid);
@@ -665,6 +665,11 @@ static struct page *alloc_buddy_huge_pag
 					__GFP_REPEAT|__GFP_NOWARN,
 					huge_page_order(h));
 
+	if (page && arch_prepare_hugepage(page)) {
+		__free_pages(page, huge_page_order(h));
+		return NULL;
+	}
+
 	spin_lock(&hugetlb_lock);
 	if (page) {
 		/*

