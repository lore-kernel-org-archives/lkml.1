Return-Path: <linux-kernel-owner+w=401wt.eu-S936230AbXEVPbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936230AbXEVPbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934902AbXEVPTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:52 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:5019
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965820AbXEVPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:17 -0400
Message-Id: <20070522141251.514546814@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:49 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       "Jan Beulich" <JBeulich@novell.com>, "Andi Kleen" <ak@muc.de>
Subject: [patch 08/33] xen: Allocate and free vmalloc areas
Content-Disposition: inline; filename=alloc-vm-area.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate/release a chunk of vmalloc address space:
 alloc_vm_area reserves a chunk of address space, and makes sure all
 the pagetables are constructed for that address range - but no pages.

 free_vm_area releases the address space range.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: "Jan Beulich" <JBeulich@novell.com>
Cc: "Andi Kleen" <ak@muc.de>

---
 include/linux/vmalloc.h |    4 +++
 mm/vmalloc.c            |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

===================================================================
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -69,6 +69,10 @@ extern int map_vm_area(struct vm_struct 
 			struct page ***pages);
 extern void unmap_vm_area(struct vm_struct *area);
 
+/* Allocate/destroy a 'vmalloc' VM area. */
+extern struct vm_struct *alloc_vm_area(size_t size);
+extern void free_vm_area(struct vm_struct *area);
+
 /*
  *	Internals.  Dont't use..
  */
===================================================================
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -762,3 +762,56 @@ void  __attribute__((weak)) vmalloc_sync
 void  __attribute__((weak)) vmalloc_sync_all(void)
 {
 }
+
+
+static int f(pte_t *pte, struct page *pmd_page, unsigned long addr, void *data)
+{
+	/* apply_to_page_range() does all the hard work. */
+	return 0;
+}
+
+/**
+ *	alloc_vm_area - allocate a range of kernel address space
+ *	@size:		size of the area
+ *	@returns:	NULL on failure, vm_struct on success
+ *
+ *	This function reserves a range of kernel address space, and
+ *	allocates pagetables to map that range.  No actual mappings
+ *	are created.  If the kernel address space is not shared
+ *	between processes, it syncs the pagetable across all
+ *	processes.
+ */
+struct vm_struct *alloc_vm_area(size_t size)
+{
+	struct vm_struct *area;
+
+	area = get_vm_area(size, VM_IOREMAP);
+	if (area == NULL)
+		return NULL;
+
+	/*
+	 * This ensures that page tables are constructed for this region
+	 * of kernel virtual address space and mapped into init_mm.
+	 */
+	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
+				area->size, f, NULL)) {
+		free_vm_area(area);
+		return NULL;
+	}
+
+	/* Make sure the pagetables are constructed in process kernel
+	   mappings */
+	vmalloc_sync_all();
+
+	return area;
+}
+EXPORT_SYMBOL_GPL(alloc_vm_area);
+
+void free_vm_area(struct vm_struct *area)
+{
+	struct vm_struct *ret;
+	ret = remove_vm_area(area->addr);
+	BUG_ON(ret != area);
+	kfree(area);
+}
+EXPORT_SYMBOL_GPL(free_vm_area);

-- 

