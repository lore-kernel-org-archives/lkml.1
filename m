Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbXHKTEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbXHKTEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbXHKS6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:33 -0400
Received: from 1wt.eu ([62.212.114.60]:1578 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762630AbXHKS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:29 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184849.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:15 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Hugh Dickins <hugh@veritas.com>, Petr Vandrovec <petr@vmware.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <andrea@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 23/28] mm: kill validate_anon_vma to avoid mapcount BUG
Content-Disposition: inline; filename=0023-mm-kill-validate_anon_vma-to-avoid-mapcount-BUG.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

validate_anon_vma gave a useful check on the integrity of the anon_vma list
when Andrea was developing obj rmap; but it was not enabled in SLES9
itself, nor in mainline, until Nick changed commented-out RMAP_DEBUG to
configurable CONFIG_DEBUG_VM in 2.6.17.  Now Petr Vandrovec reports that
its BUG_ON(mapcount > 100000) can easily crash a CONFIG_DEBUG_VM=y system.

That limit was just an arbitrary number to protect against an infinite
loop.  We could raise it to something enormous (depending on sizeof struct
vma and size of memory?); but I rather think validate_anon_vma has outlived
its usefulness, and is better just removed - which gives a magnificent
performance boost to anything like Petr's test program ;)

Of course, a very long anon_vma list is bad news for preemption latency,
and I believe there has been one recent report of such: let's not forget
that, but validate_anon_vma only makes it worse not better.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Petr Vandrovec <petr@vmware.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <andrea@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/rmap.c |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 7ce69c1..c30781c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -53,24 +53,6 @@
 
 struct kmem_cache *anon_vma_cachep;
 
-static inline void validate_anon_vma(struct vm_area_struct *find_vma)
-{
-#ifdef CONFIG_DEBUG_VM
-	struct anon_vma *anon_vma = find_vma->anon_vma;
-	struct vm_area_struct *vma;
-	unsigned int mapcount = 0;
-	int found = 0;
-
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-		mapcount++;
-		BUG_ON(mapcount > 100000);
-		if (vma == find_vma)
-			found = 1;
-	}
-	BUG_ON(!found);
-#endif
-}
-
 /* This must be called under the mmap_sem. */
 int anon_vma_prepare(struct vm_area_struct *vma)
 {
@@ -121,10 +103,8 @@ void __anon_vma_link(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
-	if (anon_vma) {
+	if (anon_vma)
 		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
-		validate_anon_vma(vma);
-	}
 }
 
 void anon_vma_link(struct vm_area_struct *vma)
@@ -134,7 +114,6 @@ void anon_vma_link(struct vm_area_struct *vma)
 	if (anon_vma) {
 		spin_lock(&anon_vma->lock);
 		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
-		validate_anon_vma(vma);
 		spin_unlock(&anon_vma->lock);
 	}
 }
@@ -148,7 +127,6 @@ void anon_vma_unlink(struct vm_area_struct *vma)
 		return;
 
 	spin_lock(&anon_vma->lock);
-	validate_anon_vma(vma);
 	list_del(&vma->anon_vma_node);
 
 	/* We must garbage collect the anon_vma if it's empty */
-- 
1.5.2.4

-- 
