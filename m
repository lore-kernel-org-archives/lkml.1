Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZCKKBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZCKKBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZCKKBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:01:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:18209 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbZCKKBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wMW9Yzo6nHyic9jOOzO03p2OYEbOu5RMaE5+SugMM7JpAUVA9yyEzvcbgHlqrmY6rc
         ugjcUGk/C3oCiU2h6IBI0TUtCJzr8lmJU8RzFMl5lwnkju+d0zDUfoczE1vFaeeKor0+
         dr3qs4sX7XMhMdGHcZ3lohKrx2+UNCimA5jWU=
MIME-Version: 1.0
Date: Wed, 11 Mar 2009 12:01:09 +0200
Message-ID: <8c5a844a0903110301w57c1d3e7k5e76d371ae33147d@mail.gmail.com>
Subject: [PATCH 2/2] mm: use list.h for vma list
From: Daniel Lowengrub <lowdanie@gmail.com>
To: linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the vmas are stored as a doubly linked list the find_vma
function can be optimized by using the cache
more efficiently.

Signed-off-by: Daniel Lowengrub
---
diff -uNr linux-2.6.28.7.vanilla/mm/mmap.c linux-2.6.28.7/mm/mmap.c
--- linux-2.6.28.7.vanilla/mm/mmap.c	2009-03-11 11:32:02.000000000 +0200
+++ linux-2.6.28.7/mm/mmap.c	2009-03-11 11:37:35.000000000 +0200
@@ -1461,37 +1461,52 @@

 EXPORT_SYMBOL(get_unmapped_area);

+/* Checks if this is the first VMA which satisfies addr < vm_end */
+static inline int after_addr(struct vm_area_struct *vma, unsigned long addr)
+{
+	if (!vma)
+		return 0;
+	if (vma->vm_end > addr) {
+		if (!vma_prev(vma))
+			return 1;
+		if (vma_prev(vma)->vm_end <= addr)
+			return 1;
+	}
+	return 0;
+}
+
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr)
 {
 	struct vm_area_struct *vma = NULL;
-
+	struct rb_node * rb_node;
 	if (mm) {
 		/* Check the cache first. */
 		/* (Cache hit rate is typically around 35%.) */
 		vma = mm->mmap_cache;
-		if (!(vma && vma->vm_end > addr && vma->vm_start <= addr)) {
-			struct rb_node * rb_node;
-
-			rb_node = mm->mm_rb.rb_node;
-			vma = NULL;
-
-			while (rb_node) {
-				struct vm_area_struct * vma_tmp;
-
-				vma_tmp = rb_entry(rb_node,
-						struct vm_area_struct, vm_rb);
-
-				if (vma_tmp->vm_end > addr) {
-					vma = vma_tmp;
-					if (vma_tmp->vm_start <= addr)
-						break;
-					rb_node = rb_node->rb_left;
-				} else
-					rb_node = rb_node->rb_right;
-			}
-			if (vma)
-				mm->mmap_cache = vma;
+		
+		if (after_addr(vma, addr))
+			return vma;
+
+		rb_node = mm->mm_rb.rb_node;
+		vma = NULL;
+
+		while (rb_node) {
+			struct vm_area_struct * vma_tmp;
+
+			vma_tmp = rb_entry(rb_node,
+					struct vm_area_struct, vm_rb);
+
+			if (vma_tmp->vm_end > addr) {
+				vma = vma_tmp;
+				if (vma_tmp->vm_start <= addr)
+					break;
+				rb_node = rb_node->rb_left;
+			} else
+				rb_node = rb_node->rb_right;
+		}
+		if (vma)
+			mm->mmap_cache = vma;
 		}
 	}
 	return vma;
