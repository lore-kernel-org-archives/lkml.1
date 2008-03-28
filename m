Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYC1AKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYC1AKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYC1AKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:10:25 -0400
Received: from mail.queued.net ([207.210.101.209]:1601 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbYC1AKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:10:24 -0400
Date: Thu, 27 Mar 2008 20:11:05 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: [PATCH 6/7] lxfb: rename kernel arg fbsize to vram
Message-ID: <20080327201105.34cae8b5@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Match other fb drivers (including gxfb).  Also, document the current
boot arguments in Documentation/fb/lxfb.txt.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 Documentation/fb/lxfb.txt       |   50 +++++++++++++++++++++++++++++++++++++++
 drivers/video/geode/lxfb_core.c |   12 ++++-----
 2 files changed, 55 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/fb/lxfb.txt

diff --git a/Documentation/fb/lxfb.txt b/Documentation/fb/lxfb.txt
new file mode 100644
index 0000000..dc501da
--- /dev/null
+++ b/Documentation/fb/lxfb.txt
@@ -0,0 +1,50 @@
+[This file is cloned from VesaFB/aty128fb]
+
+What is lxfb?
+=================
+
+This is a graphics framebuffer driver for AMD Geode LX based processors.
+
+Advantages:
+
+ * No need to use AMD's VSA code (or other VESA emulation layer) in the
+   BIOS.
+ * It provides a nice large console (128 cols + 48 lines with 1024x768)
+   without using tiny, unreadable fonts.
+ * You can run XF68_FBDev on top of /dev/fb0
+ * Most important: boot logo :-)
+
+Disadvantages:
+
+ * graphic mode is slower than text mode... 
+
+
+How to use it?
+==============
+
+Switching modes is done using  lxfb.mode_option=<resolution>... boot
+parameter or using `fbset' program.
+
+See Documentation/fb/modedb.txt for more information on modedb
+resolutions.
+
+
+X11
+===
+
+XF68_FBDev should generally work fine, but it is non-accelerated.
+
+
+Configuration
+=============
+
+You can pass kernel command line options to lxfb with lxfb.<option>.
+For example, lxfb.mode_option=800x600@75.
+Accepted options:
+
+mode_option	- specify the video mode.  Of the form
+		  <x>x<y>[-<bpp>][@<refresh>]
+vram		- size of video ram (normally auto-detected)
+
+--
+Andres Salomon <dilinger@debian.org>
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index d6a2aea..d0502a5 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -27,7 +27,7 @@
 
 static char *mode_option;
 static int noclear, nopanel, nocrt;
-static int fbsize;
+static int vram;
 
 /* Most of these modes are sorted in ascending order, but
  * since the first entry in this table is the "default" mode,
@@ -339,7 +339,7 @@ static int __init lxfb_map_video_memory(struct fb_info *info,
 		return ret;
 
 	info->fix.smem_start = pci_resource_start(dev, 0);
-	info->fix.smem_len = fbsize ? fbsize : lx_framebuffer_size();
+	info->fix.smem_len = vram ? vram : lx_framebuffer_size();
 
 	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
 
@@ -613,9 +613,7 @@ static int __init lxfb_setup(char *options)
 		if (!*opt)
 			continue;
 
-		if (!strncmp(opt, "fbsize:", 7))
-			fbsize = simple_strtoul(opt+7, NULL, 0);
-		else if (!strcmp(opt, "noclear"))
+		if (!strcmp(opt, "noclear"))
 			noclear = 1;
 		else if (!strcmp(opt, "nopanel"))
 			nopanel = 1;
@@ -652,8 +650,8 @@ module_exit(lxfb_cleanup);
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 
-module_param(fbsize, int, 0);
-MODULE_PARM_DESC(fbsize, "video memory size");
+module_param(vram, int, 0);
+MODULE_PARM_DESC(vram, "video memory size");
 
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode LX");
 MODULE_LICENSE("GPL");
-- 
1.5.3.7

