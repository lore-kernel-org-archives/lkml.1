Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYCXT4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYCXT4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYCXT4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:56:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58403 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755913AbYCXT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:56:41 -0400
Date: Mon, 24 Mar 2008 12:54:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [13/14] vcompound: Use vcompound for swap_map
In-Reply-To: <8763vfixb8.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0803241253250.4218@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061727.269764652@sgi.com>
 <8763vfixb8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andi Kleen wrote:

> But I used a simple trick to avoid the waste problem: it allocated a
> continuous range rounded up to the next page-size order and then freed
> the excess pages back into the page allocator. That was called
> alloc_exact(). If you replace vmalloc with alloc_pages you should
> use something like that too I think.

One way of dealing with it would be to define an additional allocation 
variant that allows the limiting of the loss? I noted that both the swap
and the wait tables vary significantly between allocations. So we could 
specify an upper boundary of a loss that is acceptable. If too much memory
would be lost then use vmalloc unconditionally.

---
 include/linux/vmalloc.h |   12 ++++++++----
 mm/page_alloc.c         |    4 ++--
 mm/swapfile.c           |    4 ++--
 mm/vmalloc.c            |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 46 insertions(+), 8 deletions(-)

Index: linux-2.6.25-rc5-mm1/include/linux/vmalloc.h
===================================================================
--- linux-2.6.25-rc5-mm1.orig/include/linux/vmalloc.h	2008-03-24 12:51:47.457231129 -0700
+++ linux-2.6.25-rc5-mm1/include/linux/vmalloc.h	2008-03-24 12:52:05.449313572 -0700
@@ -88,14 +88,18 @@ extern void free_vm_area(struct vm_struc
 /*
  * Support for virtual compound pages.
  *
- * Calls to vcompound alloc will result in the allocation of normal compound
- * pages unless memory is fragmented.  If insufficient physical linear memory
- * is available then a virtually contiguous area of memory will be created
- * using the vmalloc functionality.
+ * Calls to vcompound_alloc and friends will result in the allocation of
+ * a normal physically contiguous compound page unless memory is fragmented.
+ * If insufficient physical linear memory is available then a virtually
+ * contiguous area of memory will be created using vmalloc.
  */
 struct page *alloc_vcompound(gfp_t flags, int order);
+struct page *alloc_vcompound_maxloss(gfp_t flags, unsigned long size,
+					unsigned long maxloss);
 void free_vcompound(struct page *);
 void *__alloc_vcompound(gfp_t flags, int order);
+void *__alloc_vcompound_maxloss(gfp_t flags, unsigned long size,
+					unsigned long maxloss);
 void __free_vcompound(void *addr);
 struct page *vcompound_head_page(const void *x);
 
Index: linux-2.6.25-rc5-mm1/mm/vmalloc.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/mm/vmalloc.c	2008-03-24 12:51:47.485231279 -0700
+++ linux-2.6.25-rc5-mm1/mm/vmalloc.c	2008-03-24 12:52:05.453313419 -0700
@@ -1198,3 +1198,37 @@ void *__alloc_vcompound(gfp_t flags, int
 
 	return NULL;
 }
+
+/*
+ * Functions to avoid loosing memory because of the rounding up to
+ * power of two sizes for compound page allocation. If the loss would
+ * be too great then use vmalloc regardless of the fragmentation
+ * situation.
+ */
+struct page *alloc_vcompound_maxloss(gfp_t flags, unsigned long size,
+							unsigned long maxloss)
+{
+	int order = get_order(size);
+	unsigned long loss = (PAGE_SIZE << order) - size;
+	void *addr;
+
+	if (loss < maxloss)
+		return alloc_vcompound(flags, order);
+
+	addr = __vmalloc(size, flags, PAGE_KERNEL);
+	if (!addr)
+		return NULL;
+	return vmalloc_to_page(addr);
+}
+
+void *__alloc_vcompound_maxloss(gfp_t flags, unsigned long size,
+							unsigned long maxloss)
+{
+	int order = get_order(size);
+	unsigned long loss = (PAGE_SIZE << order) - size;
+
+	if (loss < maxloss)
+		return __alloc_vcompound(flags, order);
+
+	return __vmalloc(size, flags, PAGE_KERNEL);
+}
Index: linux-2.6.25-rc5-mm1/mm/swapfile.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/mm/swapfile.c	2008-03-24 12:52:05.441314302 -0700
+++ linux-2.6.25-rc5-mm1/mm/swapfile.c	2008-03-24 12:52:05.453313419 -0700
@@ -1636,8 +1636,8 @@ asmlinkage long sys_swapon(const char __
 			goto bad_swap;
 
 		/* OK, set up the swap map and apply the bad block list */
-		if (!(p->swap_map = __alloc_vcompound(GFP_KERNEL | __GFP_ZERO,
-					get_order(maxpages * sizeof(short))))) {
+		if (!(p->swap_map = __alloc_vcompound_maxloss(GFP_KERNEL | __GFP_ZERO,
+					maxpages * sizeof(short))), 16 * PAGE_SIZE) {
 			error = -ENOMEM;
 			goto bad_swap;
 		}
Index: linux-2.6.25-rc5-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/mm/page_alloc.c	2008-03-24 12:52:05.389313168 -0700
+++ linux-2.6.25-rc5-mm1/mm/page_alloc.c	2008-03-24 12:52:07.493322559 -0700
@@ -2866,8 +2866,8 @@ int zone_wait_table_init(struct zone *zo
 		 * To use this new node's memory, further consideration will be
 		 * necessary.
 		 */
-		zone->wait_table = __alloc_vcompound(GFP_KERNEL,
-						get_order(alloc_size));
+		zone->wait_table = __alloc_vcompound_maxloss(GFP_KERNEL,
+				alloc_size, 32 * PAGE_SIZE);
 	}
 	if (!zone->wait_table)
 		return -ENOMEM;
