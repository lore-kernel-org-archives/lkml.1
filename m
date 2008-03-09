Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYCIXy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYCIXy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYCIXyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:54:19 -0400
Received: from mail.queued.net ([207.210.101.209]:4207 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYCIXyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:54:18 -0400
Date: Sun, 9 Mar 2008 19:57:54 -0400
From: Andres Salomon <dilinger@queued.net>
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/4] gxfb: Replace FBSIZE config
 option with a kernel argument
Message-ID: <20080309195754.6d972be7@ephemeral>
In-Reply-To: <20080309220025.GD9971@localhost.localdomain>
References: <20080223011045.48e6cb8e@ephemeral>
	<20080227163105.e1b96023.akpm@linux-foundation.org>
	<20080227195839.1e86074e@ephemeral>
	<20080308201950.28f6eae8@ephemeral>
	<20080309220025.GD9971@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 23:00:25 +0100
Ondrej Zajicek <santiago@crfreenet.org> wrote:

> On Sat, Mar 08, 2008 at 08:19:50PM -0500, Andres Salomon wrote:
> > > assuming this is historical at this point, and manual options parsing can
> > > be removed from all fb drivers at this point, or is there another reason
> > > why manual parsing would be necessary?
> > > 
> > 
> > Could I get an answer from the fbdevel folks about this?  It looks like
> > the fb_get_options stuff is there for backwards compatibility.
> 
> I think so. I used fb_get_options() in arkfb and vt8623fb for mode option
> only. Universal notation module.option=value is much nicer than manual
> options parsing.  
> 


If that is indeed the case, here's a patch that might be useful.  I have
no idea what kind of timeframe would be proposed for removing
fb_get_options (or if it's even desirable to remove it at all given that
people are likely still using video=$foo syntax).



>From dc3f29acc1f5fedf41e1705d1d820727c8fa1e89 Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Sun, 9 Mar 2008 13:29:21 -0400
Subject: [PATCH] fb: mark fb_get_options as deprecated, and remove from skeletonfb.c

fb_get_options is now marked as deprecated.  This also removes
the fb_get_options stuff from skeletonfb.c (so people don't use it
in new code), and it allows mode_options to be set via module_param.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/skeletonfb.c |   40 ++++------------------------------------
 include/linux/fb.h         |    2 +-
 2 files changed, 5 insertions(+), 37 deletions(-)

diff --git a/drivers/video/skeletonfb.c b/drivers/video/skeletonfb.c
index 6232145..62cbc08 100644
--- a/drivers/video/skeletonfb.c
+++ b/drivers/video/skeletonfb.c
@@ -903,17 +903,6 @@ MODULE_DEVICE_TABLE(pci, xxxfb_id_table);
 
 int __init xxxfb_init(void)
 {
-	/*
-	 *  For kernel boot options (in 'video=xxxfb:<options>' format)
-	 */
-#ifndef MODULE
-	char *option = NULL;
-
-	if (fb_get_options("xxxfb", &option))
-		return -ENODEV;
-	xxxfb_setup(option);
-#endif
-
 	return pci_register_driver(&xxxfb_driver);
 }
 
@@ -974,34 +963,10 @@ static struct platform_device xxxfb_device = {
 	.name = "xxxfb",
 };
 
-#ifndef MODULE
-    /*
-     *  Setup
-     */
-
-/*
- * Only necessary if your driver takes special options,
- * otherwise we fall back on the generic fb_setup().
- */
-int __init xxxfb_setup(char *options)
-{
-    /* Parse user speficied options (`video=xxxfb:') */
-}
-#endif /* MODULE */
-
 static int __init xxxfb_init(void)
 {
 	int ret;
-	/*
-	 *  For kernel boot options (in 'video=xxxfb:<options>' format)
-	 */
-#ifndef MODULE
-	char *option = NULL;
-
-	if (fb_get_options("xxxfb", &option))
-		return -ENODEV;
-	xxxfb_setup(option);
-#endif
+
 	ret = driver_register(&xxxfb_driver);
 
 	if (!ret) {
@@ -1031,3 +996,6 @@ module_init(xxxfb_init);
 module_exit(xxxfb_remove);
 
 MODULE_LICENSE("GPL");
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "Specify resolution as"
+		" \"<xres>x<yres>[-<bpp>][@<refresh>]\"");
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 58c57a3..c46009b 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -942,7 +942,7 @@ extern void fb_pad_aligned_buffer(u8 *dst, u32 d_pitch, u8 *src, u32 s_pitch, u3
 extern void fb_set_suspend(struct fb_info *info, int state);
 extern int fb_get_color_depth(struct fb_var_screeninfo *var,
 			      struct fb_fix_screeninfo *fix);
-extern int fb_get_options(char *name, char **option);
+extern int __deprecated fb_get_options(char *name, char **option);
 extern int fb_new_modelist(struct fb_info *info);
 
 extern struct fb_info *registered_fb[FB_MAX];
-- 
1.5.3.7



