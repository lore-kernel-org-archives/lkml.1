Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbYLWKig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbYLWKig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 05:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYLWKi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 05:38:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:17073 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYLWKi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 05:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Idym1O5BCZsxsJXNcSx/NXIdHOU8pV6QKzNVOPNsqPyKaYKzzCNYNHnnKZgu+5PJ6o
         ILKlc6E+SjQ8RhuujBfORkmHOCAgOkGsAf7KZuIaESZaAxOOY/jbyuorEc6qbg6+7t+F
         AbeUmjvdXGuVN6DNRQvLJasrcgKnb88C5FAy4=
Date: Tue, 23 Dec 2008 19:38:21 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [PATCH] fix unmap_vmas() with NULL vma
Message-ID: <20081223103820.GB7217@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unmap_vmas() with NULL vma causes kernel NULL pointer dereference by
vma->mm.

It is happend the following scenario:

1. dup_mm() duplicates mm_struct and ->mmap is NULL
2. dup_mm() calls dup_mmap() to duplicate vmas

3. If dup_mmap() cannot duplicate any vmas due to no enough memory,
it returns error and ->mmap is still NULL

4. dup_mm() calls mmput() with the incompletely duplicated mm_struct to
deallocate it

5. mmput calls exit_mmap with the mm_struct
6. exit_mmap calls unmap_vmas with NULL vma

Cc: linux-mm@kvack.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/memory.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: 2.6-rc/mm/memory.c
===================================================================
--- 2.6-rc.orig/mm/memory.c
+++ 2.6-rc/mm/memory.c
@@ -899,8 +899,12 @@ unsigned long unmap_vmas(struct mmu_gath
 	unsigned long start = start_addr;
 	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
 	int fullmm = (*tlbp)->fullmm;
-	struct mm_struct *mm = vma->vm_mm;
+	struct mm_struct *mm;
+
+	if (!vma)
+		return start;
 
+	mm = vma->vm_mm;
 	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
 		unsigned long end;
