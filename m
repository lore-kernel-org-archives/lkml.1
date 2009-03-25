Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZCYFWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZCYFWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZCYFU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:20:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZCYFU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:20:26 -0400
Message-Id: <20090325052023.994667072@goodmis.org>
References: <20090325051920.406564281@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 01:19:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] mm: remove unlikelys for unlock in rmap.c
Content-Disposition: inline; filename=0005-mm-remove-unlikelys-for-unlock-in-rmap.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: clean up

The annotated branch profiler shows that the rmap calls are likely
called with unlock set.

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0    46100 100 try_to_unmap_anon              rmap.c               1013
       0    46100 100 try_to_unmap_anon              rmap.c               1005
       0     5763 100 try_to_unmap_file              rmap.c               1074
       0     5763 100 try_to_unmap_file              rmap.c               1069

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 mm/rmap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1652166..ad62fe0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1002,7 +1002,7 @@ static int try_to_unmap_anon(struct page *page, int unlock, int migration)
 	unsigned int mlocked = 0;
 	int ret = SWAP_AGAIN;
 
-	if (MLOCK_PAGES && unlikely(unlock))
+	if (MLOCK_PAGES && unlock)
 		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
 
 	anon_vma = page_lock_anon_vma(page);
@@ -1010,7 +1010,7 @@ static int try_to_unmap_anon(struct page *page, int unlock, int migration)
 		return ret;
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-		if (MLOCK_PAGES && unlikely(unlock)) {
+		if (MLOCK_PAGES && unlock) {
 			if (!((vma->vm_flags & VM_LOCKED) &&
 			      page_mapped_in_vma(page, vma)))
 				continue;  /* must visit all unlocked vmas */
@@ -1066,12 +1066,12 @@ static int try_to_unmap_file(struct page *page, int unlock, int migration)
 	unsigned int mapcount;
 	unsigned int mlocked = 0;
 
-	if (MLOCK_PAGES && unlikely(unlock))
+	if (MLOCK_PAGES && unlock)
 		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
 
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
-		if (MLOCK_PAGES && unlikely(unlock)) {
+		if (MLOCK_PAGES && unlock) {
 			if (!((vma->vm_flags & VM_LOCKED) &&
 						page_mapped_in_vma(page, vma)))
 				continue;	/* must visit all vmas */
-- 
1.6.2

-- 
