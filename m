Return-Path: <linux-kernel-owner+w=401wt.eu-S1161580AbXD2XrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161580AbXD2XrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161625AbXD2XrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:24 -0400
Received: from mx1.suse.de ([195.135.220.2]:41934 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161580AbXD2XqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:19 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/26] x86_64: Fix vmalloc_32 to really allocate <4GB on 64bit platforms
Message-Id: <20070429234618.4CC7E150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ugly ifdef, but should handle all 64bit platforms that have suitable
zones. On some like Altix it's probably impossible without IOMMU
use to get memory <4GB this way,  but they have to live with that.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/vmalloc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux/mm/vmalloc.c
===================================================================
--- linux.orig/mm/vmalloc.c
+++ linux/mm/vmalloc.c
@@ -577,6 +577,14 @@ void *vmalloc_exec(unsigned long size)
 	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC);
 }
 
+#if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
+#define GFP_VMALLOC32 GFP_DMA32
+#elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
+#define GFP_VMALLOC32 GFP_DMA
+#else
+#define GFP_VMALLOC32 GFP_KERNEL
+#endif
+
 /**
  *	vmalloc_32  -  allocate virtually contiguous memory (32bit addressable)
  *	@size:		allocation size
@@ -586,7 +594,7 @@ void *vmalloc_exec(unsigned long size)
  */
 void *vmalloc_32(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL);
+	return __vmalloc(size, GFP_VMALLOC32, PAGE_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc_32);
 
@@ -602,7 +610,7 @@ void *vmalloc_32_user(unsigned long size
 	struct vm_struct *area;
 	void *ret;
 
-	ret = __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+	ret = __vmalloc(size, GFP_VMALLOC32 | __GFP_ZERO, PAGE_KERNEL);
 	if (ret) {
 		write_lock(&vmlist_lock);
 		area = __find_vm_area(ret);
