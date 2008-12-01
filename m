Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYLAAsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYLAAsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYLAAsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:48:01 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50170 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYLAAsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:48:00 -0500
Date: Mon, 1 Dec 2008 00:48:17 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 8/8] badpage: KERN_ALERT BUG instead of KERN_EMERG
In-Reply-To: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
Message-ID: <Pine.LNX.4.64.0812010047010.11401@blonde.site>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bad_page() and rmap Eeek messages have said KERN_EMERG for a few years,
which I've followed in print_bad_pte().  These are serious system errors,
on a par with BUGs, but they're not quite emergencies, and we do our best
to carry on: say KERN_ALERT "BUG: " like the x86 oops does.

And remove the "Trying to fix it up, but a reboot is needed" line:
it's not untrue, but I hope the KERN_ALERT "BUG: " conveys as much.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I've left this proposal until last, expecting some opposition.

Considered adding oops_begin() and oops_end(),
but I'm not at all sure that would work out well for these.

 mm/memory.c     |   15 ++++++++-------
 mm/page_alloc.c |    9 ++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

--- badpage7/mm/memory.c	2008-11-28 20:40:50.000000000 +0000
+++ badpage8/mm/memory.c	2008-11-28 20:40:52.000000000 +0000
@@ -397,8 +397,8 @@ static void print_bad_pte(struct vm_area
 			return;
 		}
 		if (nr_unshown) {
-			printk(KERN_EMERG
-				"Bad page map: %lu messages suppressed\n",
+			printk(KERN_ALERT
+				"BUG: Bad page map: %lu messages suppressed\n",
 				nr_unshown);
 			nr_unshown = 0;
 		}
@@ -410,26 +410,27 @@ static void print_bad_pte(struct vm_area
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	printk(KERN_EMERG "Bad page map in process %s  pte:%08llx pmd:%08llx\n",
+	printk(KERN_ALERT
+		"BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
 		current->comm,
 		(long long)pte_val(pte), (long long)pmd_val(*pmd));
 	if (page) {
-		printk(KERN_EMERG
+		printk(KERN_ALERT
 		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
 		page, (void *)page->flags, page_count(page),
 		page_mapcount(page), page->mapping, page->index);
 	}
-	printk(KERN_EMERG
+	printk(KERN_ALERT
 		"addr:%p vm_flags:%08lx anon_vma:%p mapping:%p index:%lx\n",
 		(void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
 	/*
 	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
 	 */
 	if (vma->vm_ops)
-		print_symbol(KERN_EMERG "vma->vm_ops->fault: %s\n",
+		print_symbol(KERN_ALERT "vma->vm_ops->fault: %s\n",
 				(unsigned long)vma->vm_ops->fault);
 	if (vma->vm_file && vma->vm_file->f_op)
-		print_symbol(KERN_EMERG "vma->vm_file->f_op->mmap: %s\n",
+		print_symbol(KERN_ALERT "vma->vm_file->f_op->mmap: %s\n",
 				(unsigned long)vma->vm_file->f_op->mmap);
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE);
--- badpage7/mm/page_alloc.c	2008-11-28 20:40:50.000000000 +0000
+++ badpage8/mm/page_alloc.c	2008-11-28 20:40:52.000000000 +0000
@@ -237,8 +237,8 @@ static void bad_page(struct page *page)
 			goto out;
 		}
 		if (nr_unshown) {
-			printk(KERN_EMERG
-				"Bad page state: %lu messages suppressed\n",
+			printk(KERN_ALERT
+			      "BUG: Bad page state: %lu messages suppressed\n",
 				nr_unshown);
 			nr_unshown = 0;
 		}
@@ -247,13 +247,12 @@ static void bad_page(struct page *page)
 	if (nr_shown++ == 0)
 		resume = jiffies + 60 * HZ;
 
-	printk(KERN_EMERG "Bad page state in process %s  pfn:%05lx\n",
+	printk(KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
-	printk(KERN_EMERG
+	printk(KERN_ALERT
 		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
 		page, (void *)page->flags, page_count(page),
 		page_mapcount(page), page->mapping, page->index);
-	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
 
 	dump_stack();
 out:
