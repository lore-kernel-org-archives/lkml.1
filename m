Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbXBCSzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbXBCSzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 13:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXBCSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 13:55:37 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:41099 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751093AbXBCSzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 13:55:36 -0500
Date: Sat, 3 Feb 2007 10:55:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <1170525860.3073.1054.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702031053590.18224@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> 
 <20070203005316.eb0b4042.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Arjan van de Ven wrote:

> Well.. That's the point! Only IF there is a reclaim scan do you move
> them out again. The fact that these pages are on the list isn't a
> problem. The fact that you keep encountering them over and over again
> during *scanning* is. So Andrews suggestion makes them go away in the
> situations that actually matter

In order to get this to work try_to_unmap() must be able to distinguish 
betwen failures due to MLOCK and otherwise. So I guess we need this patch:


[PATCH] Make try_to_unmap() return SWAP_MLOCK for mlocked pages

Modify try_to_unmap() so that we can distinguish between failing to
unmap because a page is mlocked from other causes.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: current/include/linux/rmap.h
===================================================================
--- current.orig/include/linux/rmap.h	2007-02-03 10:24:47.000000000 -0800
+++ current/include/linux/rmap.h	2007-02-03 10:25:08.000000000 -0800
@@ -134,5 +134,6 @@ static inline int page_mkclean(struct pa
 #define SWAP_SUCCESS	0
 #define SWAP_AGAIN	1
 #define SWAP_FAIL	2
+#define SWAP_MLOCK	3
 
 #endif	/* _LINUX_RMAP_H */
Index: current/mm/rmap.c
===================================================================
--- current.orig/mm/rmap.c	2007-02-03 10:24:47.000000000 -0800
+++ current/mm/rmap.c	2007-02-03 10:25:08.000000000 -0800
@@ -631,10 +631,16 @@ static int try_to_unmap_one(struct page 
 	 * If it's recently referenced (perhaps page_referenced
 	 * skipped over this mm) then we should reactivate it.
 	 */
-	if (!migration && ((vma->vm_flags & VM_LOCKED) ||
-			(ptep_clear_flush_young(vma, address, pte)))) {
-		ret = SWAP_FAIL;
-		goto out_unmap;
+	if (!migration) {
+		if (vma->vm_flags & VM_LOCKED) {
+			ret = SWAP_MLOCK;
+			goto out_unmap;
+		}
+
+		if (ptep_clear_flush_young(vma, address, pte)) {
+			ret = SWAP_FAIL;
+			goto out_unmap;
+		}
 	}
 
 	/* Nuke the page table entry. */
@@ -799,7 +805,8 @@ static int try_to_unmap_anon(struct page
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
 		ret = try_to_unmap_one(page, vma, migration);
-		if (ret == SWAP_FAIL || !page_mapped(page))
+		if (ret == SWAP_FAIL || ret == SWAP_MLOCK ||
+				!page_mapped(page))
 			break;
 	}
 	spin_unlock(&anon_vma->lock);
@@ -830,7 +837,8 @@ static int try_to_unmap_file(struct page
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		ret = try_to_unmap_one(page, vma, migration);
-		if (ret == SWAP_FAIL || !page_mapped(page))
+		if (ret == SWAP_FAIL || ret == SWAP_MLOCK ||
+				!page_mapped(page))
 			goto out;
 	}
 
@@ -913,6 +921,7 @@ out:
  * SWAP_SUCCESS	- we succeeded in removing all mappings
  * SWAP_AGAIN	- we missed a mapping, try again later
  * SWAP_FAIL	- the page is unswappable
+ * SWAP_MLOCK	- the page is under mlock()
  */
 int try_to_unmap(struct page *page, int migration)
 {
Index: current/mm/vmscan.c
===================================================================
--- current.orig/mm/vmscan.c	2007-02-03 10:25:00.000000000 -0800
+++ current/mm/vmscan.c	2007-02-03 10:25:12.000000000 -0800
@@ -516,6 +516,7 @@ static unsigned long shrink_page_list(st
 		if (page_mapped(page) && mapping) {
 			switch (try_to_unmap(page, 0)) {
 			case SWAP_FAIL:
+			case SWAP_MLOCK:
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
