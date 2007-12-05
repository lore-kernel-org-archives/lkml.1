Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbXLEH7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbXLEH7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbXLEHzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:42681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbXLEHzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:12 -0500
Message-Id: <20071205071626.928999000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:49 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: zanussi@us.ibm.com, karim@opersys.com, linux-kernel@vger.kernel.org
Subject: [patch 02/18] relay: nopage
Content-Disposition: inline; filename=relay-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert relay from nopage to fault.
Remove redundant vma range checks.
Switch from OOM to SIGBUS if the resource is not available.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: zanussi@us.ibm.com
Cc: karim@opersys.com
Cc: linux-kernel@vger.kernel.org
---
 kernel/relay.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/relay.c
===================================================================
--- linux-2.6.orig/kernel/relay.c
+++ linux-2.6/kernel/relay.c
@@ -37,37 +37,31 @@ static void relay_file_mmap_close(struct
 }
 
 /*
- * nopage() vm_op implementation for relay file mapping.
+ * fault() vm_op implementation for relay file mapping.
  */
-static struct page *relay_buf_nopage(struct vm_area_struct *vma,
-				     unsigned long address,
-				     int *type)
+static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page;
 	struct rchan_buf *buf = vma->vm_private_data;
-	unsigned long offset = address - vma->vm_start;
+	pgoff_t pgoff = vmf->pgoff;
 
-	if (address > vma->vm_end)
-		return NOPAGE_SIGBUS; /* Disallow mremap */
 	if (!buf)
-		return NOPAGE_OOM;
+		return VM_FAULT_OOM;
 
-	page = vmalloc_to_page(buf->start + offset);
+	page = vmalloc_to_page(buf->start + (pgoff << PAGE_SHIFT));
 	if (!page)
-		return NOPAGE_OOM;
+		return VM_FAULT_SIGBUS;
 	get_page(page);
+	vmf->page = page;
 
-	if (type)
-		*type = VM_FAULT_MINOR;
-
-	return page;
+	return 0;
 }
 
 /*
  * vm_ops for relay file mappings.
  */
 static struct vm_operations_struct relay_file_mmap_ops = {
-	.nopage = relay_buf_nopage,
+	.fault = relay_buf_fault,
 	.close = relay_file_mmap_close,
 };
 

-- 

