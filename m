Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXCEKlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXCEKlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXCEKlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:41:44 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:52963 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933063AbXCEKlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:41:42 -0500
Date: Mon, 5 Mar 2007 19:39:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jayakumar.lkml@gmail.com
Subject: [PATCH] fb: fsync() method for deferred I/O flush.
Message-ID: <20070305103905.GA12601@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, jayakumar.lkml@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases when we do not want to wait on the delay for
automatically updating the "real" framebuffer, this implements a
simple ->fsync() hook for explicitly flushing the deferred I/O
work. The ->page_mkwrite() handler will rearm the work queue
normally.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/video/fb_defio.c |   12 ++++++++++++
 drivers/video/fbmem.c    |    3 +++
 include/linux/fb.h       |    2 ++
 3 files changed, 17 insertions(+)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index c3e57cc..8a66dc8 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -52,6 +52,18 @@ static void fb_deferred_io_work(struct work_struct *work)
 	mutex_unlock(&fbdefio->lock);
 }
 
+int fb_deferred_io_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	struct fb_info *info = file->private_data;
+
+	/* Kill off the delayed work */
+	cancel_rearming_delayed_work(&info->deferred_work);
+
+	/* Run it immediately */
+	return schedule_delayed_work(&info->deferred_work, 0);
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_fsync);
+
 /* vm_ops->page_mkwrite handler */
 int fb_deferred_io_mkwrite(struct vm_area_struct *vma, 
 					struct page *page)
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 863126a..69bbbe2 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1266,6 +1266,9 @@ static const struct file_operations fb_fops = {
 #ifdef HAVE_ARCH_FB_UNMAPPED_AREA
 	.get_unmapped_area = get_fb_unmapped_area,
 #endif
+#ifdef CONFIG_FB_DEFERRED_IO
+	.fsync =	fb_deferred_io_fsync,
+#endif
 };
 
 struct class *fb_class;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index af217dd..3f62652 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -933,6 +933,8 @@ extern void fb_deferred_io_init(struct fb_info *info);
 extern void fb_deferred_io_cleanup(struct fb_info *info);
 extern int fb_deferred_io_mkwrite(struct vm_area_struct *vma, 
 					struct page *page);
+extern int fb_deferred_io_fsync(struct file *file, struct dentry *dentry,
+				int datasync);
 #else
 #define fb_deferred_io_init(fb_info)	do { } while (0)
 #define fb_deferred_io_cleanup(fb_info)	do { } while (0)
