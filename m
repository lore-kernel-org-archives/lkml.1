Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXCKLaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXCKLaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932444AbXCKLaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:30:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbXCKLaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:30:09 -0400
Date: Sun, 11 Mar 2007 13:30:08 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 1/5] revoke: special mmap handling
Message-ID: <Pine.LNX.4.64.0703111329230.765@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This adds special handling for revoked memory mappings.  We want to
raise SIGBUS when accessing revoked mappings and return ENODEV when
trying to remap with mmap(2).

Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/mm.h |    1 +
 mm/memory.c        |    3 +++
 mm/mmap.c          |   12 ++++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

Index: uml-2.6/include/linux/mm.h
===================================================================
--- uml-2.6.orig/include/linux/mm.h	2007-03-11 13:07:57.000000000 +0200
+++ uml-2.6/include/linux/mm.h	2007-03-11 13:09:19.000000000 +0200
@@ -169,6 +169,7 @@ #define VM_NONLINEAR	0x00800000	/* Is no
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
+#define VM_REVOKED	0x08000000	/* Mapping has been revoked */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
Index: uml-2.6/mm/memory.c
===================================================================
--- uml-2.6.orig/mm/memory.c	2007-03-11 13:07:57.000000000 +0200
+++ uml-2.6/mm/memory.c	2007-03-11 13:09:19.000000000 +0200
@@ -2504,6 +2504,9 @@ int __handle_mm_fault(struct mm_struct *
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, write_access);
 
+	if (unlikely(vma->vm_flags & VM_REVOKED))
+		return VM_FAULT_SIGBUS;
+
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
Index: uml-2.6/mm/mmap.c
===================================================================
--- uml-2.6.orig/mm/mmap.c	2007-03-11 13:07:57.000000000 +0200
+++ uml-2.6/mm/mmap.c	2007-03-11 13:09:19.000000000 +0200
@@ -1030,10 +1030,14 @@ 				accountable = 0;
 	error = -ENOMEM;
 munmap_back:
 	vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
-	if (vma && vma->vm_start < addr + len) {
-		if (do_munmap(mm, addr, len))
-			return -ENOMEM;
-		goto munmap_back;
+	if (vma) {
+		if (unlikely(vma->vm_flags & VM_REVOKED))
+			return -ENODEV;
+		if (vma->vm_start < addr + len) {
+			if (do_munmap(mm, addr, len))
+				return -ENOMEM;
+			goto munmap_back;
+		}
 	}
 
 	/* Check against address space limit. */
