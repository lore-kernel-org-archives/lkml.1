Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386Ab0AETWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0AETWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367Ab0AETWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:22:11 -0500
Received: from kroah.org ([198.145.64.141]:55814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab0AETWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:22:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 098/101] ksm: fix mlockfreed to munlocked
Date: Tue,  5 Jan 2010 11:21:26 -0800
Message-Id: <1262719290-310-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105192014.GA23628@kroah.com>
References: <20100105192014.GA23628@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

2.6.33-rc1 commit 73848b4684e84a84cfd1555af78d41158f31e16b, adjusted
to include 31e855ea7173bdb0520f9684580423a9560f66e0's movement of
the unlock_page(oldpage), but omit other intervening cleanups.

When KSM merges an mlocked page, it has been forgetting to munlock it:
that's been left to free_page_mlock(), which reports it in /proc/vmstat
as unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked,
which indicates that such pages _might_ be left unevictable for long
after they should be evictable.  Call munlock_vma_page() to fix that.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/internal.h |    3 ++-
 mm/ksm.c      |   14 +++++++-------
 mm/mlock.c    |    4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 22ec8d2..17bc0df 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -107,9 +107,10 @@ static inline int is_mlocked_vma(struct vm_area_struct *vma, struct page *page)
 }
 
 /*
- * must be called with vma's mmap_sem held for read, and page locked.
+ * must be called with vma's mmap_sem held for read or write, and page locked.
  */
 extern void mlock_vma_page(struct page *page);
+extern void munlock_vma_page(struct page *page);
 
 /*
  * Clear the page's PageMlocked().  This can be useful in a situation where
diff --git a/mm/ksm.c b/mm/ksm.c
index 5575f86..e9501f8 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
+#include "internal.h"
 
 /*
  * A few notes about the KSM scanning process,
@@ -767,15 +768,14 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 	 * ptes are necessarily already write-protected.  But in either
 	 * case, we need to lock and check page_count is not raised.
 	 */
-	if (write_protect_page(vma, oldpage, &orig_pte)) {
-		unlock_page(oldpage);
-		goto out_putpage;
-	}
-	unlock_page(oldpage);
-
-	if (pages_identical(oldpage, newpage))
+	if (write_protect_page(vma, oldpage, &orig_pte) == 0 &&
+	    pages_identical(oldpage, newpage))
 		err = replace_page(vma, oldpage, newpage, orig_pte);
 
+	if ((vma->vm_flags & VM_LOCKED) && !err)
+		munlock_vma_page(oldpage);
+
+	unlock_page(oldpage);
 out_putpage:
 	put_page(oldpage);
 	put_page(newpage);
diff --git a/mm/mlock.c b/mm/mlock.c
index bd6f0e4..2e05c97 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -99,14 +99,14 @@ void mlock_vma_page(struct page *page)
  * not get another chance to clear PageMlocked.  If we successfully
  * isolate the page and try_to_munlock() detects other VM_LOCKED vmas
  * mapping the page, it will restore the PageMlocked state, unless the page
- * is mapped in a non-linear vma.  So, we go ahead and SetPageMlocked(),
+ * is mapped in a non-linear vma.  So, we go ahead and ClearPageMlocked(),
  * perhaps redundantly.
  * If we lose the isolation race, and the page is mapped by other VM_LOCKED
  * vmas, we'll detect this in vmscan--via try_to_munlock() or try_to_unmap()
  * either of which will restore the PageMlocked state by calling
  * mlock_vma_page() above, if it can grab the vma's mmap sem.
  */
-static void munlock_vma_page(struct page *page)
+void munlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 
-- 
1.6.6

