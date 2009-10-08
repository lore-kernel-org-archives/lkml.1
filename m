Return-Path: <linux-kernel-owner+w=401wt.eu-S932707AbZJHPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbZJHPOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbZJHPOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:14:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:39910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689AbZJHPOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:14:45 -0400
Date: Thu, 8 Oct 2009 15:13:12 GMT
From: tip-bot for David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, davem@davemloft.net,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, davem@davemloft.net, jens.axboe@oracle.com,
       akpm@linux-foundation.org, tglx@linutronix.de, nickpiggin@yahoo.com.au,
       mingo@elte.hu
In-Reply-To: <200909211922.n8LJMYjw029425@imap1.linux-foundation.org>
References: <200909211922.n8LJMYjw029425@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] mm, perf_event: Make vmalloc_user() align base kernel virtual address to SHMLBA
Message-ID: <tip-2dca6999eed58d44b67e9de7d6ec230f6250553d@git.kernel.org>
Git-Commit-ID: 2dca6999eed58d44b67e9de7d6ec230f6250553d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 15:13:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2dca6999eed58d44b67e9de7d6ec230f6250553d
Gitweb:     http://git.kernel.org/tip/2dca6999eed58d44b67e9de7d6ec230f6250553d
Author:     David Miller <davem@davemloft.net>
AuthorDate: Mon, 21 Sep 2009 12:22:34 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Oct 2009 17:02:31 +0200

mm, perf_event: Make vmalloc_user() align base kernel virtual address to SHMLBA

When a vmalloc'd area is mmap'd into userspace, some kind of
co-ordination is necessary for this to work on platforms with cpu
D-caches which can have aliases.

Otherwise kernel side writes won't be seen properly in userspace
and vice versa.

If the kernel side mapping and the user side one have the same
alignment, modulo SHMLBA, this can work as long as VM_SHARED is
shared of VMA and for all current users this is true.  VM_SHARED
will force SHMLBA alignment of the user side mmap on platforms with
D-cache aliasing matters.

The bulk of this patch is just making it so that a specific
alignment can be passed down into __get_vm_area_node().  All
existing callers pass in '1' which preserves existing behavior.
vmalloc_user() gives SHMLBA for the alignment.

As a side effect this should get the video media drivers and other
vmalloc_user() users into more working shape on such systems.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <200909211922.n8LJMYjw029425@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/vmalloc.c |   48 ++++++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 69511e6..4ecbbde 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -29,6 +29,7 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
+#include <asm/shmparam.h>
 
 
 /*** Page table manipulation functions ***/
@@ -1156,12 +1157,11 @@ static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 }
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
-		unsigned long flags, unsigned long start, unsigned long end,
-		int node, gfp_t gfp_mask, void *caller)
+		unsigned long align, unsigned long flags, unsigned long start,
+		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
 	static struct vmap_area *va;
 	struct vm_struct *area;
-	unsigned long align = 1;
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
@@ -1201,7 +1201,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 				unsigned long start, unsigned long end)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 						__builtin_return_address(0));
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
@@ -1210,7 +1210,7 @@ struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
 				       unsigned long start, unsigned long end,
 				       void *caller)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 				  caller);
 }
 
@@ -1225,22 +1225,22 @@ struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
  */
 struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
 				-1, GFP_KERNEL, __builtin_return_address(0));
 }
 
 struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				void *caller)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
 						-1, GFP_KERNEL, caller);
 }
 
 struct vm_struct *get_vm_area_node(unsigned long size, unsigned long flags,
 				   int node, gfp_t gfp_mask)
 {
-	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END, node,
-				  gfp_mask, __builtin_return_address(0));
+	return __get_vm_area_node(size, 1, flags, VMALLOC_START, VMALLOC_END,
+				  node, gfp_mask, __builtin_return_address(0));
 }
 
 static struct vm_struct *find_vm_area(const void *addr)
@@ -1403,7 +1403,8 @@ void *vmap(struct page **pages, unsigned int count,
 }
 EXPORT_SYMBOL(vmap);
 
-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node, void *caller)
@@ -1417,7 +1418,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
+		pages = __vmalloc_node(array_size, 1, gfp_mask | __GFP_ZERO,
 				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
@@ -1476,6 +1477,7 @@ void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 /**
  *	__vmalloc_node  -  allocate virtually contiguous memory
  *	@size:		allocation size
+ *	@align:		desired alignment
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
  *	@node:		node to use for allocation or -1
@@ -1485,8 +1487,9 @@ void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
  *	allocator with @gfp_mask flags.  Map them into contiguous
  *	kernel virtual space, using a pagetable protection of @prot.
  */
-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
-						int node, void *caller)
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
+			    int node, void *caller)
 {
 	struct vm_struct *area;
 	void *addr;
@@ -1496,8 +1499,8 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
-	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
-						node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC, VMALLOC_START,
+				  VMALLOC_END, node, gfp_mask, caller);
 
 	if (!area)
 		return NULL;
@@ -1516,7 +1519,7 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_node(size, gfp_mask, prot, -1,
+	return __vmalloc_node(size, 1, gfp_mask, prot, -1,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
@@ -1532,7 +1535,7 @@ EXPORT_SYMBOL(__vmalloc);
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					-1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc);
@@ -1549,7 +1552,8 @@ void *vmalloc_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+	ret = __vmalloc_node(size, SHMLBA,
+			     GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
 			     PAGE_KERNEL, -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
@@ -1572,7 +1576,7 @@ EXPORT_SYMBOL(vmalloc_user);
  */
 void *vmalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_node);
@@ -1595,7 +1599,7 @@ EXPORT_SYMBOL(vmalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
 			      -1, __builtin_return_address(0));
 }
 
@@ -1616,7 +1620,7 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_VMALLOC32, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_VMALLOC32, PAGE_KERNEL,
 			      -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
@@ -1633,7 +1637,7 @@ void *vmalloc_32_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
+	ret = __vmalloc_node(size, 1, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
 			     -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
