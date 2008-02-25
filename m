Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYBYNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYBYNES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYBYNEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:04:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYBYNED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:04:03 -0500
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 25 Feb 2008 14:03:52 +0100
Message-ID: <87k5kt6vd3.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deferred I/O was utterly broken.  Reading the mmap()ed framebuffer
worked, but writing it made the VM endlessly invoke
vm_ops.page_mkwrite().  That happened because we failed to set
page->mapping and page->index.

The fix is to set them, and clean up properly before the framebuffer
gets released.

Fix extracted from this linux-fbdev-devel message:

    Subject: [PATCH 1/1 2.6.24] fbdev: defio and Metronomefb
    From: Jaya Kumar <jayakumar.lkml@gmail.com>
    Date: 2008-02-18 13:41:26

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Markus Armbruster <armbru@redhat.com>

---

 drivers/video/fb_defio.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 0f8cfb9..24843fd 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2006 Jaya Kumar
  *
  * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
+ * License. See the file COPYING in the main directory of this archive
  * for more details.
  */
 
@@ -31,7 +31,7 @@ static int fb_deferred_io_fault(struct vm_area_struct *vma,
 	unsigned long offset;
 	struct page *page;
 	struct fb_info *info = vma->vm_private_data;
-	/* info->screen_base is in System RAM */
+	/* info->screen_base is virtual memory */
 	void *screen_base = (void __force *) info->screen_base;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
@@ -43,6 +43,15 @@ static int fb_deferred_io_fault(struct vm_area_struct *vma,
 		return VM_FAULT_SIGBUS;
 
 	get_page(page);
+
+	if (vma->vm_file)
+		page->mapping = vma->vm_file->f_mapping;
+	else
+		printk(KERN_ERR "no mapping available\n");
+
+	BUG_ON(!page->mapping);
+	page->index = vmf->pgoff;
+
 	vmf->page = page;
 	return 0;
 }
@@ -138,11 +147,20 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_init);
 
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
+	void *screen_base = (void __force *) info->screen_base;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct page *page;
+	int i;
 
 	BUG_ON(!fbdefio);
 	cancel_delayed_work(&info->deferred_work);
 	flush_scheduled_work();
+
+	/* clear out the mapping that we setup */
+	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
+		page = vmalloc_to_page(screen_base + i);
+		page->mapping = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_cleanup);
 
