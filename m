Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbYLSSPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbYLSSPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYLSSNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:13:34 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50358 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066AbYLSSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:13:32 -0500
Subject: [PATCH 06/14] kmemleak: Add the vmalloc memory allocation/freeing
	hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 19 Dec 2008 18:13:29 +0000
Message-ID: <20081219181329.7778.77083.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2008 18:13:31.0079 (UTC) FILETIME=[7F88A570:01C96205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to kmemleak_(alloc|free) functions from
vmalloc/vfree.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/vmalloc.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1ddb77b..ad0a0af 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,6 +23,7 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/kmemleak.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -1196,6 +1197,9 @@ static void __vunmap(const void *addr, int deallocate_pages)
 void vfree(const void *addr)
 {
 	BUG_ON(in_interrupt());
+
+	kmemleak_free(addr);
+
 	__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
@@ -1305,8 +1309,16 @@ fail:
 
 void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_area_node(area, gfp_mask, prot, -1,
-					__builtin_return_address(0));
+	void *addr = __vmalloc_area_node(area, gfp_mask, prot, -1,
+					 __builtin_return_address(0));
+
+	/*
+	 * This needs ref_count = 2 since vm_struct also contains a pointer to
+	 * this address. The guard page is subtracted from the size.
+	 */
+	kmemleak_alloc(addr, area->size - PAGE_SIZE, 2, gfp_mask);
+
+	return addr;
 }
 
 /**
@@ -1325,6 +1337,8 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 						int node, void *caller)
 {
 	struct vm_struct *area;
+	void *addr;
+	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > num_physpages)
@@ -1336,7 +1350,15 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 	if (!area)
 		return NULL;
 
-	return __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+
+	/*
+	 * This needs ref_count = 2 since the vm_struct also contains a
+	 * pointer to this address.
+	 */
+	kmemleak_alloc(addr, real_size, 2, gfp_mask);
+
+	return addr;
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)

