Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXEOVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXEOVWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbXEOVWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:22:05 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35115 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbXEOVWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:22:03 -0400
Date: Tue, 15 May 2007 19:56:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jayson Santos <jaysonsantos2003@yahoo.com.br>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] prio_tree: debugging patch
Message-ID: <Pine.LNX.4.64.0705151953050.30826@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 May 2007 21:22:02.0134 (UTC) FILETIME=[1434AB60:01C79737]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBqYXlzb25zYW50b3MyMDAzQHlhaG9vLmNvbS5icgByYW5keS5kdW5sYXBAb3JhY2xlLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jayson Santos has sighted mm/prio_tree.c:78,79 BUGs (kernel bugzilla 8446),
and one was sighted a couple of years ago.  No reason yet to suppose they're
prio_tree bugs, but we can't tell much about them without seeing the vmas.

So dump vma and the one it's supposed to resemble: I had expected to use
print_hex_dump(), but that's designed for u8 dumps, whereas almost every
field of vm_area_struct is either a pointer or an unsigned long - which
look nonsense dumped as u8s.

Replace the two BUG_ONs by a single WARN_ON; and if it fires, just keep
this vma out of the tree (truncation and swapout won't be able to find it).
How safe this is depends on what the error really is; but we hold a file's
i_mmap_lock here, so it may be impossible to recover from BUG_ON.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Andrew, please replace -mm's prio-tree-debugging.patch by this one,
which is now suitable for both 32-bit and 64-bit architectures.

Jayson, you can use either this one or the one I sent earlier:
they provide the same information so no need to update; but this
one might allow you to continue working (depending on the corruption).

 mm/prio_tree.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

--- 2.6.22-rc1/mm/prio_tree.c	2005-03-02 07:39:17.000000000 +0000
+++ linux/mm/prio_tree.c	2007-05-15 17:49:48.000000000 +0100
@@ -67,6 +67,20 @@
  * 	vma->shared.vm_set.head == NULL ==> a list node
  */
 
+static void dump_vma(struct vm_area_struct *vma)
+{
+	void **ptr = (void **) vma;
+	int i;
+
+	printk("vm_area_struct at %p:", ptr);
+	for (i = 0; i < sizeof(*vma)/sizeof(*ptr); i++, ptr++) {
+		if (!(i & 3))
+			printk("\n");
+		printk(" %p", *ptr);
+	}
+	printk("\n");
+}
+
 /*
  * Add a new vma known to map the same set of pages as the old vma:
  * useful for fork's dup_mmap as well as vma_prio_tree_insert below.
@@ -74,14 +88,23 @@
  */
 void vma_prio_tree_add(struct vm_area_struct *vma, struct vm_area_struct *old)
 {
-	/* Leave these BUG_ONs till prio_tree patch stabilizes */
-	BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
-	BUG_ON(HEAP_INDEX(vma) != HEAP_INDEX(old));
-
 	vma->shared.vm_set.head = NULL;
 	vma->shared.vm_set.parent = NULL;
 
-	if (!old->shared.vm_set.parent)
+	if (WARN_ON(RADIX_INDEX(vma) != RADIX_INDEX(old) ||
+		    HEAP_INDEX(vma)  != HEAP_INDEX(old))) {
+		/*
+		 * This should never happen, yet it has been seen a few times:
+		 * we cannot say much about it without seeing the vma contents.
+		 */
+		dump_vma(vma);
+		dump_vma(old);
+		/*
+		 * Don't try to link this (corrupt?) vma into the (corrupt?)
+		 * prio_tree, but arrange for its removal to succeed later.
+		 */
+		INIT_LIST_HEAD(&vma->shared.vm_set.list);
+	} else if (!old->shared.vm_set.parent)
 		list_add(&vma->shared.vm_set.list,
 				&old->shared.vm_set.list);
 	else if (old->shared.vm_set.head)
