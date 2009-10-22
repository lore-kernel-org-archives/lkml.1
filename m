Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZJVI4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZJVI4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 04:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZJVI4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 04:56:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45087 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZJVI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 04:56:43 -0400
Date: Thu, 22 Oct 2009 10:56:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-fbdev-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@osdl.org>, Arve Hj?nnev?g <arve@android.com>,
       Brian Swetland <swetland@google.com>
Subject: drivers/video/msm: update to new kernel
Message-ID: <20091022085639.GA30548@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TASK_INTERRUPTIBLE and friends are now only available after including
<linux/sched.h>, so include it when needed.

bus_id is no longer available/neccessary, so remove that.

Android pmem driver is not available in mainline, so remove its hooks
from drivers/video.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

index 5c5a1ad..474421f 100644
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@ -24,6 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <mach/msm_iomap.h>
 #include <mach/irqs.h>
 #include <mach/board.h>
diff --git a/drivers/video/msm/mddi_client_nt35399.c b/drivers/video/msm/mddi_client_nt35399.c
index 9c78050..c9e9349 100644
--- a/drivers/video/msm/mddi_client_nt35399.c
+++ b/drivers/video/msm/mddi_client_nt35399.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/gpio.h>
 #include <mach/msm_fb.h>
 
diff --git a/drivers/video/msm/mddi_client_toshiba.c b/drivers/video/msm/mddi_client_toshiba.c
index 80d0f5f..71048e7 100644
--- a/drivers/video/msm/mddi_client_toshiba.c
+++ b/drivers/video/msm/mddi_client_toshiba.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/sched.h>
 #include <mach/msm_fb.h>
 
 
diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
index 99636a2..6c519e2 100644
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@ -22,9 +22,6 @@
 #include <linux/wait.h>
 #include <linux/clk.h>
 #include <linux/file.h>
-#ifdef CONFIG_ANDROID_PMEM
-#include <linux/android_pmem.h>
-#endif
 #include <linux/major.h>
 
 #include <mach/msm_iomap.h>
@@ -262,11 +259,6 @@ int get_img(struct mdp_img *img, struct fb_info *info,
 	struct file *file;
 	unsigned long vstart;
 
-#ifdef CONFIG_ANDROID_PMEM
-	if (!get_pmem_file(img->memory_id, start, &vstart, len, filep))
-		return 0;
-#endif
-
 	file = fget_light(img->memory_id, &put_needed);
 	if (file == NULL)
 		return -1;
@@ -283,12 +275,6 @@ int get_img(struct mdp_img *img, struct fb_info *info,
 
 void put_img(struct file *src_file, struct file *dst_file)
 {
-#ifdef CONFIG_ANDROID_PMEM
-	if (src_file)
-		put_pmem_file(src_file);
-	if (dst_file)
-		put_pmem_file(dst_file);
-#endif
 }
 
 int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
@@ -320,9 +306,6 @@ int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
 	if (unlikely(get_img(&req->dst, fb, &dst_start, &dst_len, &dst_file))) {
 		printk(KERN_ERR "mpd_ppp: could not retrieve dst image from "
 				"memory\n");
-#ifdef CONFIG_ANDROID_PMEM
-		put_pmem_file(src_file);
-#endif
 		return -EINVAL;
 	}
 	mutex_lock(&mdp_mutex);
@@ -499,7 +482,6 @@ int mdp_probe(struct platform_device *pdev)
 	/* register mdp device */
 	mdp->mdp_dev.dev.parent = &pdev->dev;
 	mdp->mdp_dev.dev.class = mdp_class;
-	snprintf(mdp->mdp_dev.dev.bus_id, BUS_ID_SIZE, "mdp%d", pdev->id);
 
 	/* if you can remove the platform device you'd have to implement
 	 * this:
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/msm/mdp_ppp.c
index ba2c467..4ff001f 100644
--- a/drivers/video/msm/mdp_ppp.c
+++ b/drivers/video/msm/mdp_ppp.c
@@ -16,7 +16,6 @@
 #include <linux/file.h>
 #include <linux/delay.h>
 #include <linux/msm_mdp.h>
-#include <linux/android_pmem.h>
 #include <mach/msm_fb.h>
 
 #include "mdp_hw.h"
@@ -579,25 +578,6 @@ static int valid_src_dst(unsigned long src_start, unsigned long src_len,
 static void flush_imgs(struct mdp_blit_req *req, struct mdp_regs *regs,
 		       struct file *src_file, struct file *dst_file)
 {
-#ifdef CONFIG_ANDROID_PMEM
-	uint32_t src0_len, src1_len, dst0_len, dst1_len;
-
-	/* flush src images to memory before dma to mdp */
-	get_len(&req->src, &req->src_rect, regs->src_bpp, &src0_len,
-		&src1_len);
-	flush_pmem_file(src_file, req->src.offset, src0_len);
-	if (IS_PSEUDOPLNR(req->src.format))
-		flush_pmem_file(src_file, req->src.offset + src0_len,
-				src1_len);
-
-	/* flush dst images */
-	get_len(&req->dst, &req->dst_rect, regs->dst_bpp, &dst0_len,
-		&dst1_len);
-	flush_pmem_file(dst_file, req->dst.offset, dst0_len);
-	if (IS_PSEUDOPLNR(req->dst.format))
-		flush_pmem_file(dst_file, req->dst.offset + dst0_len,
-				dst1_len);
-#endif
 }
 
 static void get_chroma_addr(struct mdp_img *img, struct mdp_rect *rect,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
