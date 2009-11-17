Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZKQIj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZKQIj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZKQIj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:39:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57627 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZKQIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:39:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]  [for mmotm-1113] mm: Simplify try_to_unmap_one()
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20091117173759.3DF6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 17:39:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SWAP_MLOCK mean "We marked the page as PG_MLOCK, please move it to
unevictable-lru". So, following code is easy confusable.

        if (vma->vm_flags & VM_LOCKED) {
                ret = SWAP_MLOCK;
                goto out_unmap;
        }

Plus, if the VMA doesn't have VM_LOCKED, We don't need to check
the needed of calling mlock_vma_page().

Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/rmap.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 82e31fb..70dec01 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -779,10 +779,9 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!(flags & TTU_IGNORE_MLOCK)) {
-		if (vma->vm_flags & VM_LOCKED) {
-			ret = SWAP_MLOCK;
-			goto out_unmap;
-		}
+		if (vma->vm_flags & VM_LOCKED)
+			goto out_mlock;
+
 		if (TTU_ACTION(flags) == TTU_MUNLOCK)
 			goto out_unmap;
 	}
@@ -855,18 +854,19 @@ static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
+out:
+	return ret;
 
-	if (ret == SWAP_MLOCK) {
-		ret = SWAP_AGAIN;
-		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
-			if (vma->vm_flags & VM_LOCKED) {
-				mlock_vma_page(page);
-				ret = SWAP_MLOCK;
-			}
-			up_read(&vma->vm_mm->mmap_sem);
+out_mlock:
+	pte_unmap_unlock(pte, ptl);
+
+	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
+		if (vma->vm_flags & VM_LOCKED) {
+			mlock_vma_page(page);
+			ret = SWAP_MLOCK;
 		}
+		up_read(&vma->vm_mm->mmap_sem);
 	}
-out:
 	return ret;
 }
 
-- 
1.6.2.5



