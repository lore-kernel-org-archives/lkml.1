Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZJBWoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZJBWoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZJBWoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:44:18 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50264 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbZJBWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:44:17 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19m95rGiK2tOxa+MazYF+eI
Subject: [PATCH 6/8] omapfb: Condition mutex acquisition
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Imre Deak <imre.deak@nokia.com>, Sergio Aguirre <saaguirre@ti.com>,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Date: Fri, 02 Oct 2009 15:44:13 -0700
Message-ID: <20091002224413.11962.12302.stgit@localhost>
In-Reply-To: <20091002223510.11962.21751.stgit@localhost>
References: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergio Aguirre <saaguirre@ti.com>

This fixes a bug introduced by this commit ID:

  commit 537a1bf059fa312355696fa6db80726e655e7f17
  Author: Krzysztof Helt <krzysztof.h1@wp.pl>
  Date:   Tue Jun 30 11:41:29 2009 -0700

    fbdev: add mutex for fb_mmap locking

In which a mutex was added when changing smem_start and smem_len fields,
so the mutex inside the fb_mmap() call is actually used.

The problem was that set_fb_fix, which modifies the above 2 fields,
was called before and after registering the framebuffer,
which when used before registration, lead to a failed attempt to
use an uninitialized mutex.

Solution: Don't use mutex before framebuffer registration.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Acked-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Acked-by: Imre Deak <imre.deak@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/video/omap/omapfb_main.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/omap/omapfb_main.c
index 125e605..0d0c8c8 100644
--- a/drivers/video/omap/omapfb_main.c
+++ b/drivers/video/omap/omapfb_main.c
@@ -393,7 +393,7 @@ static void omapfb_sync(struct fb_info *fbi)
  * Set fb_info.fix fields and also updates fbdev.
  * When calling this fb_info.var must be set up already.
  */
-static void set_fb_fix(struct fb_info *fbi)
+static void set_fb_fix(struct fb_info *fbi, int from_init)
 {
 	struct fb_fix_screeninfo *fix = &fbi->fix;
 	struct fb_var_screeninfo *var = &fbi->var;
@@ -403,10 +403,16 @@ static void set_fb_fix(struct fb_info *fbi)
 
 	rg = &plane->fbdev->mem_desc.region[plane->idx];
 	fbi->screen_base	= rg->vaddr;
-	mutex_lock(&fbi->mm_lock);
-	fix->smem_start		= rg->paddr;
-	fix->smem_len		= rg->size;
-	mutex_unlock(&fbi->mm_lock);
+
+	if (!from_init) {
+		mutex_lock(&fbi->mm_lock);
+		fix->smem_start		= rg->paddr;
+		fix->smem_len		= rg->size;
+		mutex_unlock(&fbi->mm_lock);
+	} else {
+		fix->smem_start		= rg->paddr;
+		fix->smem_len		= rg->size;
+	}
 
 	fix->type = FB_TYPE_PACKED_PIXELS;
 	bpp = var->bits_per_pixel;
@@ -704,7 +710,7 @@ static int omapfb_set_par(struct fb_info *fbi)
 	int r = 0;
 
 	omapfb_rqueue_lock(fbdev);
-	set_fb_fix(fbi);
+	set_fb_fix(fbi, 0);
 	r = ctrl_change_mode(fbi);
 	omapfb_rqueue_unlock(fbdev);
 
@@ -904,7 +910,7 @@ static int omapfb_setup_mem(struct fb_info *fbi, struct omapfb_mem_info *mi)
 		if (old_size != size) {
 			if (size) {
 				memcpy(&fbi->var, new_var, sizeof(fbi->var));
-				set_fb_fix(fbi);
+				set_fb_fix(fbi, 0);
 			} else {
 				/*
 				 * Set these explicitly to indicate that the
@@ -1504,7 +1510,7 @@ static int fbinfo_init(struct omapfb_device *fbdev, struct fb_info *info)
 	var->bits_per_pixel = fbdev->panel->bpp;
 
 	set_fb_var(info, var);
-	set_fb_fix(info);
+	set_fb_fix(info, 1);
 
 	r = fb_alloc_cmap(&info->cmap, 16, 0);
 	if (r != 0)

