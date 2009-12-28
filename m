Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZL1CzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZL1CzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZL1CzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:55:15 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:40748 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZL1CzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:55:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=wItjCTCCCbmkA/jqBO5Ptnu1B/X4UXB1T6A9qZQPcuULcL4icstcA/aY3EOX6vpVD/
         z+NIHmhJf0pFkM70p5a8xI0BuLGKTRaRdL4kRTc/70nE+28mwJQrN9efCRHn6ku/GpCh
         0tPolJANRqyxhokrBX2TKRIzo8Vs3PFBNu+PQ=
Date: Mon, 28 Dec 2009 11:53:15 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mmotm-2009-12-10-17-19] Prevent churning of zero page in
 LRU list.
Message-Id: <20091228115315.76b1ecd0.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


VM doesn't add zero page to LRU list. 
It means zero page's churning in LRU list is pointless. 

As a matter of fact, zero page can't be promoted by mark_page_accessed
since it doesn't have PG_lru. 

This patch prevent unecessary mark_page_accessed call of zero page 
alghouth caller want FOLL_TOUCH. 

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memory.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 09e4b1b..485f727 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1152,6 +1152,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 	spinlock_t *ptl;
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
+	int zero_pfn = 0;
 
 	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
 	if (!IS_ERR(page)) {
@@ -1196,15 +1197,15 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 
 	page = vm_normal_page(vma, address, pte);
 	if (unlikely(!page)) {
-		if ((flags & FOLL_DUMP) ||
-		    !is_zero_pfn(pte_pfn(pte)))
+		zero_pfn = is_zero_pfn(pte_pfn(pte));
+		if ((flags & FOLL_DUMP) || !zero_pfn )
 			goto bad_page;
 		page = pte_page(pte);
 	}
 
 	if (flags & FOLL_GET)
 		get_page(page);
-	if (flags & FOLL_TOUCH) {
+	if (flags & FOLL_TOUCH && !zero_pfn) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
 			set_page_dirty(page);
-- 
1.5.6.3


-- 
Kind regards,
Minchan Kim
