Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZDXQnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZDXQnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbZDXQmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:18 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41542 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759828AbZDXQmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:17 -0400
Subject: [PATCH 06/14] kmemleak: Add the vmalloc memory allocation/freeing
	hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Apr 2009 17:41:32 +0100
Message-ID: <20090424164132.4476.69541.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:16.0517 (UTC) FILETIME=[A07D4750:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to kmemleak_(alloc|free) functions from
vmalloc/vfree.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/vmalloc.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fab1987..507f1b1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -25,6 +25,7 @@
 #include <linux/rcupdate.h>
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
+#include <linux/kmemleak.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -1326,6 +1327,9 @@ static void __vunmap(const void *addr, int deallocate_pages)
 void vfree(const void *addr)
 {
 	BUG_ON(in_interrupt());
+
+	kmemleak_free(addr);
+
 	__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
@@ -1438,8 +1442,17 @@ fail:
 
 void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_area_node(area, gfp_mask, prot, -1,
-					__builtin_return_address(0));
+	void *addr = __vmalloc_area_node(area, gfp_mask, prot, -1,
+					 __builtin_return_address(0));
+
+	/*
+	 * A ref_count = 3 is needed because the vm_struct and vmap_area
+	 * structures allocated in the __get_vm_area_node() function contain
+	 * references to the virtual address of the vmalloc'ed block.
+	 */
+	kmemleak_alloc(addr, area->size - PAGE_SIZE, 3, gfp_mask);
+
+	return addr;
 }
 
 /**
@@ -1458,6 +1471,8 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 						int node, void *caller)
 {
 	struct vm_struct *area;
+	void *addr;
+	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > num_physpages)
@@ -1469,7 +1484,16 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 	if (!area)
 		return NULL;
 
-	return __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+
+	/*
+	 * A ref_count = 3 is needed because the vm_struct and vmap_area
+	 * structures allocated in the __get_vm_area_node() function contain
+	 * references to the virtual address of the vmalloc'ed block.
+	 */
+	kmemleak_alloc(addr, real_size, 3, gfp_mask);
+
+	return addr;
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)

