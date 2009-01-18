Return-Path: <linux-kernel-owner+w=401wt.eu-S933479AbZARMmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbZARMmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 07:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbZARMmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 07:42:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:53906 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbZARMmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 07:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=vMzVU/11y6CFapB3RijNNwdfR1h6MoLf1LiaruYGQhWehWkRNmZR+Hxf04Vk2gl8Hc
         sk+OIAfjQS+h1OEssB1I9dwMtL+DxfNm3tlzyab6hcEtw3xxgq8wfjs350MVAqSbUN0x
         79cyqkfvRc8P9asKsMxwVjE5NjGFagL7fO5BQ=
Message-ID: <497323AB.4080203@gmail.com>
Date: Sun, 18 Jan 2009 13:42:19 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: wli@holomorphy.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] unless signed chg cannot become less than 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

region_chg returns long, so let vma_needs_reservation() forward this to
alloc_huge_page(). and do not store it in an unsigned, since a negative
will go unnoticed. Store it as long as well. all callers treat it as
long anyway. 

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

