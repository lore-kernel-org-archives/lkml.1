Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYILMah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYILMah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYILMa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:30:27 -0400
Received: from iona.labri.fr ([147.210.8.143]:40912 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYILMa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:30:27 -0400
Message-ID: <48CA611A.8060706@inria.fr>
Date: Fri, 12 Sep 2008 14:31:22 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: [PATCH] mm: make do_move_pages() complexity linear
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page migration is currently very slow because its overhead is quadratic
with the number of pages. This is caused by each single page migration
doing a linear lookup in the page array in new_page_node().
    
Since pages are stored in the array order in the pagelist and do_move_pages
process this list in order, new_page_node() can increase the "pm" pointer
to the page array so that the next iteration will find the next page in
0 or few lookup steps.
    
Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Nathalie Furmento <Nathalie.Furmento@labri.fr>

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -837,14 +837,23 @@ struct page_to_node {
 	int status;
 };
 
+/*
+ * Allocate a page on the node given as a page_to_node in private.
+ * Increase private to point to the next page_to_node so that the
+ * next iteration does not have to traverse the whole pm array.
+ */
 static struct page *new_page_node(struct page *p, unsigned long private,
 		int **result)
 {
-	struct page_to_node *pm = (struct page_to_node *)private;
+	struct page_to_node **pmptr = (struct page_to_node **)private;
+	struct page_to_node *pm = *pmptr;
 
 	while (pm->node != MAX_NUMNODES && pm->page != p)
 		pm++;
 
+	/* prepare for the next iteration */
+	*pmptr = pm + 1;
+
 	if (pm->node == MAX_NUMNODES)
 		return NULL;
 
@@ -926,10 +935,12 @@ set_status:
 		pp->status = err;
 	}
 
-	if (!list_empty(&pagelist))
+	if (!list_empty(&pagelist)) {
+		/* new_page_node() will modify tmp */
+		struct page_to_node *tmp = pm;
 		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm);
-	else
+				    (unsigned long)&tmp);
+	} else
 		err = -ENOENT;
 
 	up_read(&mm->mmap_sem);


