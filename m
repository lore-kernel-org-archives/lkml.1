Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbYGQV0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbYGQV0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbYGQV0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:26:12 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:42593 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760597AbYGQV0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:26:11 -0400
From: Timur Tabi <timur@freescale.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH v2] fsl-diu-fb: Update Freescale DIU driver to use page_alloc_exact()
Date: Thu, 17 Jul 2008 16:25:16 -0500
Message-Id: <1216329916-31549-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the Freescale DIU driver to use page_alloc_exact() to allocate a
DMA buffer.  This also eliminates the rheap-based memory allocator.  We
can do this now because commit 6ccf61f9 allows us to allocate 8MB physically-
contiguous memory blocks.

Signed-off-by: Timur Tabi <timur@freescale.com>
---

Fix printk format specifiers, per Andrew Morton.

My other patch, "Add alloc_pages_exact() and free_pages_exact()", must be
applied first, otherwise drivers/video/fsl-diu-fb.c will not compile.

 drivers/video/fsl-diu-fb.c |   60 ++++++++++++++++---------------------------
 1 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 09d7e22..9cd36c2 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -279,58 +279,42 @@ static struct diu_hw dr = {
 
 static struct diu_pool pool;
 
-/*	To allocate memory for framebuffer. First try __get_free_pages(). If it
- *	fails, try rh_alloc. The reason is __get_free_pages() cannot allocate
- *	very large memory (more than 4MB). We don't want to allocate all memory
- *	in rheap since small memory allocation/deallocation will fragment the
- *	rheap and make the furture large allocation fail.
+/**
+ * fsl_diu_alloc - allocate memory for the DIU
+ * @size: number of bytes to allocate
+ * @param: returned physical address of memory
+ *
+ * This function allocates a physically-contiguous block of memory.
  */
-
-static void *fsl_diu_alloc(unsigned long size, phys_addr_t *phys)
+static void *fsl_diu_alloc(size_t size, phys_addr_t *phys)
 {
 	void *virt;
 
-	pr_debug("size=%lu\n", size);
+	pr_debug("size=%zu\n", size);
 
-	virt = (void *)__get_free_pages(GFP_DMA | __GFP_ZERO, get_order(size));
+	virt = alloc_pages_exact(size, GFP_DMA | __GFP_ZERO);
 	if (virt) {
 		*phys = virt_to_phys(virt);
-		pr_debug("virt %p, phys=%llx\n", virt, (uint64_t) *phys);
-		return virt;
-	}
-	if (!diu_ops.diu_mem) {
-		printk(KERN_INFO "%s: no diu_mem."
-			" To reserve more memory, put 'diufb=15M' "
-			"in the command line\n", __func__);
-		return NULL;
-	}
-
-	virt = (void *)rh_alloc(&diu_ops.diu_rh_info, size, "DIU");
-	if (virt) {
-		*phys = virt_to_bus(virt);
-		memset(virt, 0, size);
+		pr_debug("virt=%p phys=%llx\n", virt,
+			(unsigned long long)*phys);
 	}
 
-	pr_debug("rh virt=%p phys=%llx\n", virt, (unsigned long long)*phys);
-
 	return virt;
 }
 
-static void fsl_diu_free(void *p, unsigned long size)
+/**
+ * fsl_diu_free - release DIU memory
+ * @virt: pointer returned by fsl_diu_alloc()
+ * @size: number of bytes allocated by fsl_diu_alloc()
+ *
+ * This function releases memory allocated by fsl_diu_alloc().
+ */
+static void fsl_diu_free(void *virt, size_t size)
 {
-	pr_debug("p=%p size=%lu\n", p, size);
+	pr_debug("virt=%p size=%zu\n", virt, size);
 
-	if (!p)
-		return;
-
-	if ((p >= diu_ops.diu_mem) &&
-	    (p < (diu_ops.diu_mem + diu_ops.diu_size))) {
-		pr_debug("rh\n");
-		rh_free(&diu_ops.diu_rh_info, (unsigned long) p);
-	} else {
-		pr_debug("dma\n");
-		free_pages((unsigned long)p, get_order(size));
-	}
+	if (virt && size)
+		free_pages_exact(virt, size);
 }
 
 static int fsl_diu_enable_panel(struct fb_info *info)
-- 
1.5.5

