Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbXLNPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbXLNPP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXLNPPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:15:47 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59122 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbXLNPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:15:46 -0500
Date: Fri, 14 Dec 2007 17:15:43 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [RFC/PATCH 1/8] revoke: special mmap handling V7
Message-ID: <Pine.LNX.4.64.0712141714120.28689@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This adds special handling for revoked shared memory mappings.  We want to
raise SIGBUS if someone accesses a revoked mapping and return ENODEV if
somebody tries to remap one with mmap(2).

Cc: Alan Cox <alan@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/mm.h |    1 +
 mm/memory.c        |    3 +++
 mm/mmap.c          |   12 ++++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

Index: 2.6/include/linux/mm.h
===================================================================
--- 2.6.orig/include/linux/mm.h	2007-12-14 11:33:57.000000000 +0200
+++ 2.6/include/linux/mm.h	2007-12-14 16:40:48.000000000 +0200
@@ -106,6 +106,7 @@ #define VM_INSERTPAGE	0x02000000	/* The 
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
+#define VM_REVOKED	0x10000000	/* Mapping has been revoked */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
Index: 2.6/mm/memory.c
===================================================================
--- 2.6.orig/mm/memory.c	2007-11-23 09:58:11.000000000 +0200
+++ 2.6/mm/memory.c	2007-12-14 16:40:49.000000000 +0200
@@ -2530,6 +2530,9 @@ int handle_mm_fault(struct mm_struct *mm
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, write_access);
 
+	if (unlikely(vma->vm_flags & VM_REVOKED))
+		return VM_FAULT_SIGBUS;
+
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
Index: 2.6/mm/mmap.c
===================================================================
--- 2.6.orig/mm/mmap.c	2007-12-14 11:33:57.000000000 +0200
+++ 2.6/mm/mmap.c	2007-12-14 16:40:49.000000000 +0200
@@ -1081,10 +1081,14 @@ 	unsigned long charged = 0;
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
