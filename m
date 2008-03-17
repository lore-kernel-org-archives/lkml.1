Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbYCQCDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbYCQCDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYCQB6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:35 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:45416 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbYCQB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:33 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [17/18] Add huge pud support to mm/memory.c
Message-Id: <20080317015831.297501B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:31 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:56.0892 (UTC) FILETIME=[7B7021C0:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mm/memory.c seems to have already gained some knowledge about huge pages:
in particularly in get_user_pages.  Fix that code up to support huge 
puds.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c
+++ linux/mm/memory.c
@@ -931,7 +931,13 @@ struct page *follow_page(struct vm_area_
 	pud = pud_offset(pgd, address);
 	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
 		goto no_page_table;
-	
+
+	if (pud_huge(*pud)) {
+		BUG_ON(flags & FOLL_GET);
+		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
+		goto out;
+	}
+
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto no_page_table;
@@ -1422,6 +1428,8 @@ static int apply_to_pmd_range(struct mm_
 	unsigned long next;
 	int err;
 
+	BUG_ON(pud_huge(*pud));
+
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
 		return -ENOMEM;
