Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYKGUlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYKGUlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYKGUjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:39:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52190 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYKGUjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:39:37 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, npiggin@suse.de
Subject: [PATCH 4/4] Do not use guard pages in non-debug kernels
Date: Fri,  7 Nov 2008 20:35:54 -0200
Message-Id: <1226097354-7523-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1226097354-7523-4-git-send-email-glommer@redhat.com>
References: <1226097354-7523-1-git-send-email-glommer@redhat.com>
 <1226097354-7523-2-git-send-email-glommer@redhat.com>
 <1226097354-7523-3-git-send-email-glommer@redhat.com>
 <1226097354-7523-4-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mm/vmalloc.c, make usage of guard pages dependant
on CONFIG_DEBUG_PAGEALLOC.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 mm/vmalloc.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6fe2003..ed73c6f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -28,6 +28,11 @@
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+#define GUARD_PAGE_SIZE PAGE_SIZE
+#else
+#define GUARD_PAGE_SIZE 0
+#endif
 
 /*** Page table manipulation functions ***/
 
@@ -363,7 +368,7 @@ retry:
 		}
 
 		while (addr + size >= first->va_start && addr + size <= vend) {
-			addr = ALIGN(first->va_end + PAGE_SIZE, align);
+			addr = ALIGN(first->va_end, align);
 
 			n = rb_next(&first->rb_node);
 			if (n)
@@ -954,7 +959,7 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
-	unsigned long end = addr + area->size - PAGE_SIZE;
+	unsigned long end = addr + area->size - GUARD_PAGE_SIZE;
 	int err;
 
 	err = vmap_page_range(addr, end, prot, *pages);
@@ -1003,7 +1008,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 	/*
 	 * We always allocate a guard page.
 	 */
-	size += PAGE_SIZE;
+	size += GUARD_PAGE_SIZE;
 
 	va = alloc_vmap_area(size, align, start, end, node, gfp_mask);
 	if (IS_ERR(va)) {
@@ -1098,7 +1103,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 		struct vm_struct *vm = va->private;
 		struct vm_struct *tmp, **p;
 		free_unmap_vmap_area(va);
-		vm->size -= PAGE_SIZE;
+		vm->size -= GUARD_PAGE_SIZE;
 
 		write_lock(&vmlist_lock);
 		for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
@@ -1226,7 +1231,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
 
-	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
+	nr_pages = (area->size - GUARD_PAGE_SIZE) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
 	area->nr_pages = nr_pages;
@@ -1451,7 +1456,7 @@ long vread(char *buf, char *addr, unsigned long count)
 	read_lock(&vmlist_lock);
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
-		if (addr >= vaddr + tmp->size - PAGE_SIZE)
+		if (addr >= vaddr + tmp->size - GUARD_PAGE_SIZE)
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -1461,7 +1466,7 @@ long vread(char *buf, char *addr, unsigned long count)
 			addr++;
 			count--;
 		}
-		n = vaddr + tmp->size - PAGE_SIZE - addr;
+		n = vaddr + tmp->size - GUARD_PAGE_SIZE - addr;
 		do {
 			if (count == 0)
 				goto finished;
@@ -1489,7 +1494,7 @@ long vwrite(char *buf, char *addr, unsigned long count)
 	read_lock(&vmlist_lock);
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
-		if (addr >= vaddr + tmp->size - PAGE_SIZE)
+		if (addr >= vaddr + tmp->size - GUARD_PAGE_SIZE)
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -1498,7 +1503,7 @@ long vwrite(char *buf, char *addr, unsigned long count)
 			addr++;
 			count--;
 		}
-		n = vaddr + tmp->size - PAGE_SIZE - addr;
+		n = vaddr + tmp->size - GUARD_PAGE_SIZE - addr;
 		do {
 			if (count == 0)
 				goto finished;
@@ -1544,7 +1549,7 @@ int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
-	if (usize + (pgoff << PAGE_SHIFT) > area->size - PAGE_SIZE)
+	if (usize + (pgoff << PAGE_SHIFT) > area->size - GUARD_PAGE_SIZE)
 		return -EINVAL;
 
 	addr += pgoff << PAGE_SHIFT;
-- 
1.5.6.5

