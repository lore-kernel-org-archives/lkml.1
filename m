Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZJHFVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZJHFVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZJHFVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:21:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48441
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbZJHFVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:21:50 -0400
Date: Wed, 07 Oct 2009 22:21:45 -0700 (PDT)
Message-Id: <20091007.222145.102309696.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, peterz@infradead.org, paulus@samba.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: Provide vmalloc() based mmap() backing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091007003202.5a8ac565.akpm@linux-foundation.org>
References: <20091006122359.GA7614@elte.hu>
	<20091007.001321.197898334.davem@davemloft.net>
	<20091007003202.5a8ac565.akpm@linux-foundation.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Oct 2009 00:32:02 -0700

> I seem to have lost it.  We might as well keep the two patches
> together so can you please handle it?

Ingo, in case you don't have a copy handy, I attach it
below.  Please add it to these perf mmap bits in your
tree, thanks!

mm: Make vmalloc_user() align base kernel virtual address to SHMLBA.

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
