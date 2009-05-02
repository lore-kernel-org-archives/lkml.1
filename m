Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbZEBWTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbZEBWTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZEBWSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:18:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760733AbZEBWSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:18:42 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au,
       Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 4/6] ksm: change the prot handling to use the generic helper functions
Date: Sun,  3 May 2009 01:16:10 +0300
Message-Id: <1241302572-4366-5-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241302572-4366-4-git-send-email-ieidus@redhat.com>
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com>
 <1241302572-4366-2-git-send-email-ieidus@redhat.com>
 <1241302572-4366-3-git-send-email-ieidus@redhat.com>
 <1241302572-4366-4-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to avoid breaking some architectures.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 mm/ksm.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index c14019f..bfbbe1d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -766,8 +766,8 @@ static int try_to_merge_two_pages_alloc(struct mm_struct *mm1,
 		up_read(&mm1->mmap_sem);
 		return ret;
 	}
-	prot = vma->vm_page_prot;
-	pgprot_val(prot) &= ~_PAGE_RW;
+
+	prot = vm_get_page_prot(vma->vm_flags & ~VM_WRITE);
 
 	copy_user_highpage(kpage, page1, addr1, vma);
 	ret = try_to_merge_one_page(mm1, vma, page1, kpage, prot);
@@ -784,8 +784,7 @@ static int try_to_merge_two_pages_alloc(struct mm_struct *mm1,
 			return ret;
 		}
 
-		prot = vma->vm_page_prot;
-		pgprot_val(prot) &= ~_PAGE_RW;
+		prot = vm_get_page_prot(vma->vm_flags & ~VM_WRITE);
 
 		ret = try_to_merge_one_page(mm2, vma, page2, kpage,
 					    prot);
@@ -831,8 +830,9 @@ static int try_to_merge_two_pages_noalloc(struct mm_struct *mm1,
 		up_read(&mm1->mmap_sem);
 		return ret;
 	}
-	prot = vma->vm_page_prot;
-	pgprot_val(prot) &= ~_PAGE_RW;
+
+	prot = vm_get_page_prot(vma->vm_flags & ~VM_WRITE);
+
 	ret = try_to_merge_one_page(mm1, vma, page1, page2, prot);
 	up_read(&mm1->mmap_sem);
 	if (!ret)
-- 
1.5.6.5

