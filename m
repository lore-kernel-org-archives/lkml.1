Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZIHMKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZIHMKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbZIHMKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:10:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46014
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131AbZIHMKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:10:31 -0400
Date: Tue, 08 Sep 2009 05:10:46 -0700 (PDT)
Message-Id: <20090908.051046.141535022.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, jens.axboe@oracle.com
Subject: [PATCH 1/2]: mm: Make vmalloc_user() align base kernel virtual
 address to SHMLBA.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When a vmalloc'd area is mmap'd into userspace, some kind of
co-ordination is necessary for this to work on platforms with cpu
D-caches which can have aliases.

Otherwise kernel side writes won't be seen properly in userspace and
vice versa.

If the kernel side mapping and the user side one have the same
alignment, modulo SHMLBA, this can work as long as VM_SHARED is
shared of VMA and for all current users this is true.  VM_SHARED
will force SHMLBA alignment of the user side mmap on platforms
with D-cache aliasing matters.

The bulk of this patch is just making it so that a specific alignment
can be passed down into __get_vm_area_node().  All existing callers
pass in '1' which preserves existing behavior.  vmalloc_user() gives
SHMLBA for the alignment.

As a side effect this should get the video media drivers and other
vmalloc_user() users into more working shape on such systems.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 mm/vmalloc.c |   48 ++++++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f8189a4..be15e03 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -29,6 +29,7 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
+#include <asm/shmparam.h>
 
 
 /*** Page table manipulation functions ***/
@@ -1123,13 +1124,12 @@ DEFINE_RWLOCK(vmlist_lock);
 struct vm_struct *vmlist;
 
 static struct vm_struct *__get_vm_area_node(unsigned long size,
-		unsigned long flags, unsigned long start, unsigned long end,
-		int node, gfp_t gfp_mask, void *caller)
+		unsigned long align, unsigned long flags, unsigned long start,
+		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
 	static struct vmap_area *va;
 	struct vm_struct *area;
 	struct vm_struct *tmp, **p;
-	unsigned long align = 1;
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP) {
@@ -1187,7 +1187,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 				unsigned long start, unsigned long end)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 						__builtin_return_address(0));
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
@@ -1196,7 +1196,7 @@ struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
 				       unsigned long start, unsigned long end,
 				       void *caller)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+	return __get_vm_area_node(size, 1, flags, start, end, -1, GFP_KERNEL,
 				  caller);
 }
 
@@ -1211,22 +1211,22 @@ struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
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
@@ -1385,7 +1385,8 @@ void *vmap(struct page **pages, unsigned int count,
 }
 EXPORT_SYMBOL(vmap);
 
-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
+static void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node, void *caller)
@@ -1399,7 +1400,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
+		pages = __vmalloc_node(array_size, 1, gfp_mask | __GFP_ZERO,
 				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
@@ -1458,6 +1459,7 @@ void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 /**
  *	__vmalloc_node  -  allocate virtually contiguous memory
  *	@size:		allocation size
+ *	@align:		desired alignment
  *	@gfp_mask:	flags for the page level allocator
  *	@prot:		protection mask for the allocated pages
  *	@node:		node to use for allocation or -1
@@ -1467,8 +1469,9 @@ void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
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
@@ -1478,8 +1481,8 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 	if (!size || (size >> PAGE_SHIFT) > num_physpages)
 		return NULL;
 
-	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
-						node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC, VMALLOC_START,
+				  VMALLOC_END, node, gfp_mask, caller);
 
 	if (!area)
 		return NULL;
@@ -1498,7 +1501,7 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_node(size, gfp_mask, prot, -1,
+	return __vmalloc_node(size, 1, gfp_mask, prot, -1,
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
@@ -1514,7 +1517,7 @@ EXPORT_SYMBOL(__vmalloc);
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					-1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc);
@@ -1531,7 +1534,8 @@ void *vmalloc_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+	ret = __vmalloc_node(size, SHMLBA,
+			     GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
 			     PAGE_KERNEL, -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
@@ -1554,7 +1558,7 @@ EXPORT_SYMBOL(vmalloc_user);
  */
 void *vmalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
 					node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_node);
@@ -1577,7 +1581,7 @@ EXPORT_SYMBOL(vmalloc_node);
 
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
 			      -1, __builtin_return_address(0));
 }
 
@@ -1598,7 +1602,7 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc_node(size, GFP_VMALLOC32, PAGE_KERNEL,
+	return __vmalloc_node(size, 1, GFP_VMALLOC32, PAGE_KERNEL,
 			      -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_32);
@@ -1615,7 +1619,7 @@ void *vmalloc_32_user(unsigned long size)
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc_node(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
+	ret = __vmalloc_node(size, 1, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL,
 			     -1, __builtin_return_address(0));
 	if (ret) {
 		area = find_vm_area(ret);
-- 
1.6.4.2

