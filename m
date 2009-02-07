Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZBGRZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZBGRZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZBGRWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:36 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43447 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbZBGRWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:31 -0500
Date: Sat, 7 Feb 2009 12:15:26 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 9/15] valkyriefb: check fb_alloc_cmap return value and
 handle failure properly
Message-ID: <20090207121526.33494f59@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/valkyriefb.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/video/valkyriefb.c b/drivers/video/valkyriefb.c
index 7b0cef9..4bb9a0b 100644
--- a/drivers/video/valkyriefb.c
+++ b/drivers/video/valkyriefb.c
@@ -119,7 +119,7 @@ static void set_valkyrie_clock(unsigned char *params);
 static int valkyrie_var_to_par(struct fb_var_screeninfo *var,
 	struct fb_par_valkyrie *par, const struct fb_info *fb_info);
 
-static void valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p);
+static int valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p);
 static void valkyrie_par_to_fix(struct fb_par_valkyrie *par, struct fb_fix_screeninfo *fix);
 static void valkyrie_init_fix(struct fb_fix_screeninfo *fix, struct fb_info_valkyrie *p);
 
@@ -381,18 +381,22 @@ int __init valkyriefb_init(void)
 
 	valkyrie_choose_mode(p);
 	mac_vmode_to_var(default_vmode, default_cmode, &p->info.var);
-	valkyrie_init_info(&p->info, p);
+	err = valkyrie_init_info(&p->info, p);
+	if (err < 0)
+		goto out_free;
 	valkyrie_init_fix(&p->info.fix, p);
 	if (valkyriefb_set_par(&p->info))
 		/* "can't happen" */
 		printk(KERN_ERR "valkyriefb: can't set default video mode\n");
 
 	if ((err = register_framebuffer(&p->info)) != 0)
-		goto out_free;
+		goto out_cmap_free;
 
 	printk(KERN_INFO "fb%d: valkyrie frame buffer device\n", p->info.node);
 	return 0;
 
+ out_cmap_free:
+	fb_dealloc_cmap(&p->info.cmap);
  out_free:
 	if (p->frame_buffer)
 		iounmap(p->frame_buffer);
@@ -538,14 +542,15 @@ static void valkyrie_par_to_fix(struct fb_par_valkyrie *par,
 		/* ywrapstep, xpanstep, ypanstep */
 }
 
-static void __init valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p)
+static int __init valkyrie_init_info(struct fb_info *info,
+		struct fb_info_valkyrie *p)
 {
 	info->fbops = &valkyriefb_ops;
 	info->screen_base = p->frame_buffer + 0x1000;
 	info->flags = FBINFO_DEFAULT;
 	info->pseudo_palette = p->pseudo_palette;
-	fb_alloc_cmap(&info->cmap, 256, 0);
 	info->par = &p->par;
+	return fb_alloc_cmap(&info->cmap, 256, 0);
 }
 
 
-- 
1.5.6.5

