Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYJIMbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYJIMbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYJIMa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:30:58 -0400
Received: from iona.labri.fr ([147.210.8.143]:35787 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbYJIMa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:30:57 -0400
Message-ID: <48EDF9DA.7000508@inria.fr>
Date: Thu, 09 Oct 2008 14:32:26 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org
CC: Andrew Morton <akpm@osdl.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: [PATCH] mm: use a radix-tree to make do_move_pages() complexity linear
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a radix-tree in do_move_pages() to associate each page with
the struct page_to_node that describes its migration.
new_page_node() can now easily find out the page_to_node of the
given page instead of traversing the whole page_to_node array.
So the overall complexity is linear instead of quadratic.

We still need the page_to_node array since it is allocated by the
caller (sys_move_page()) and used by do_pages_stat() when no target
nodes are given by the application. And we need room to store all
these page_to_node entries for do_move_pages() as well anyway.

If a page is given twice by the application, the old code would
return -EBUSY (failure from the second isolate_lru_page()). Now,
radix_tree_insert() will return -EEXIST, and we convert it back
to -EBUSY to keep the user-space ABI.

The radix-tree is emptied at the end of do_move_pages() since
new_page_node() doesn't know when an entry is used for the last
time (unmap_and_move() could try another pass later).
Marking pp->page as ZERO_PAGE(0) was actually never used. We now
set it to NULL when pp is not in the radix-tree. It is faster
than doing a loop of radix_tree_lookup_gang()+delete().

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Nathalie Furmento <Nathalie.Furmento@labri.fr>

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/memcontrol.h>
 #include <linux/syscalls.h>
+#include <linux/radix-tree.h>
 
 #include "internal.h"
 
@@ -840,12 +841,10 @@ struct page_to_node {
 static struct page *new_page_node(struct page *p, unsigned long private,
 		int **result)
 {
-	struct page_to_node *pm = (struct page_to_node *)private;
+	struct radix_tree_root *root = (struct radix_tree_root *) private;
+	struct page_to_node *pm = (struct page_to_node *) radix_tree_lookup(root, (unsigned long) p);
 
-	while (pm->node != MAX_NUMNODES && pm->page != p)
-		pm++;
-
-	if (pm->node == MAX_NUMNODES)
+	if (!pm)
 		return NULL;
 
 	*result = &pm->status;
@@ -865,6 +864,7 @@ static int do_move_pages(struct mm_struct *mm, struct page_to_node *pm,
 	int err;
 	struct page_to_node *pp;
 	LIST_HEAD(pagelist);
+	RADIX_TREE(pmroot, GFP_KERNEL);
 
 	down_read(&mm->mmap_sem);
 
@@ -876,11 +876,8 @@ static int do_move_pages(struct mm_struct *mm, struct page_to_node *pm,
 		struct vm_area_struct *vma;
 		struct page *page;
 
-		/*
-		 * A valid page pointer that will not match any of the
-		 * pages that will be moved.
-		 */
-		pp->page = ZERO_PAGE(0);
+		/* set to NULL as long as pp is not in the radix-tree */
+		pp->page = NULL;
 
 		err = -EFAULT;
 		vma = find_vma(mm, pp->addr);
@@ -900,9 +897,7 @@ static int do_move_pages(struct mm_struct *mm, struct page_to_node *pm,
 		if (PageReserved(page))		/* Check for zero page */
 			goto put_and_set;
 
-		pp->page = page;
 		err = page_to_nid(page);
-
 		if (err == pp->node)
 			/*
 			 * Node already in the right place
@@ -914,6 +909,23 @@ static int do_move_pages(struct mm_struct *mm, struct page_to_node *pm,
 				!migrate_all)
 			goto put_and_set;
 
+		/*
+		 * Insert pp in the radix-tree so that new_page_node() can find it
+		 * while only knowing the page.
+		 * There cannot be any duplicate since isolate_lru_page() would fail
+		 * below anyway.
+		 */
+		err = radix_tree_insert(&pmroot, (unsigned long) page, pp);
+		if (err < 0) {
+			if (err == -EEXIST)
+				/* the page cannot be migrated twice */
+				err = -EBUSY;
+			goto put_and_set;
+		}
+
+		/* set pp->page for real now that pp is in the radix-tree */
+		pp->page = page;
+
 		err = isolate_lru_page(page, &pagelist);
 put_and_set:
 		/*
@@ -927,12 +939,17 @@ set_status:
 	}
 
 	if (!list_empty(&pagelist))
-		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm);
+		err = migrate_pages(&pagelist, new_page_node, (unsigned long) &pmroot);
 	else
 		err = -ENOENT;
 
 	up_read(&mm->mmap_sem);
+
+	/* empty the radix-tree now that new_page_node() will not be called anymore */
+	for(pp = pm; pp->node != MAX_NUMNODES; pp++)
+		if (pp->page)
+			radix_tree_delete(&pmroot, (unsigned long) pp->page);
+
 	return err;
 }
 


