Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZB0Px6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZB0Px6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZB0Pxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:53:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:49936 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZB0Pxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:53:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=L+1g8rwLo3ewrT4sjDkkDp7Z3kMPJBIXbYGkSjpMO9wnivPKUzir17V2HbSojM3ku/
         svDwEjwdRUf92io/rBAohb98jF2eMWDFBkve1DsSqoUxiroMV/iqQ9f4OSiuj3kdO7V+
         YAbWMWKCp9ZMNpYwWxeKkhIuO2ObO2HQ7vAIQ=
Message-ID: <49A80C89.9000608@gmail.com>
Date: Fri, 27 Feb 2009 16:53:45 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] chg cannot become less than 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chg is unsigned, so it cannot be less than 0.

Also, since region_chg returns long, let vma_needs_reservation() forward
this to alloc_huge_page(). Store it as long as well. all callers cast it
to long anyway. 

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 618e983..f0eec5e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -918,7 +918,7 @@ static void return_unused_surplus_pages(struct hstate *h,
  * an instantiated the change should be committed via vma_commit_reservation.
  * No action is required on failure.
  */
-static int vma_needs_reservation(struct hstate *h,
+static long vma_needs_reservation(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
@@ -933,7 +933,7 @@ static int vma_needs_reservation(struct hstate *h,
 		return 1;
 
 	} else  {
-		int err;
+		long err;
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
@@ -969,7 +969,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	struct page *page;
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
-	unsigned int chg;
+	long chg;
 
 	/*
 	 * Processes that did not create the mapping will have no reserves and


