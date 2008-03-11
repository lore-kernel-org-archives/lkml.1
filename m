Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYCKUVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYCKUVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbYCKUVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:21:35 -0400
Received: from mail.queued.net ([207.210.101.209]:3959 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYCKUVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:21:33 -0400
Date: Tue, 11 Mar 2008 16:25:25 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] gxfb: Replace FBSIZE config option with a kernel
 argument
Message-ID: <20080311162525.04a9cc47@ephemeral>
In-Reply-To: <20080227163105.e1b96023.akpm@linux-foundation.org>
References: <20080223011045.48e6cb8e@ephemeral>
	<20080227163105.e1b96023.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 16:31:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 23 Feb 2008 01:10:45 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > @@ -425,7 +424,10 @@ static int __init gxfb_setup(char *options)
> >  		if (!*opt)
> >  			continue;
> >  
> > -		mode_option = opt;
> > +		if (!strncmp(opt, "fbsize:", 7))
> > +			fbsize = simple_strtoul(opt+7, NULL, 0);
> > +		else
> > +			mode_option = opt;
> >  	}
> 
> The above shouldn't be necessary.
> 
> And it should have been documented in Documentation/kernel-parameters.txt.
> 
> And "fbsize=N" would be a lot more conventional than "fbsize:N"
> 
> I suspect that the formulation you have here will not permit "fbsize:128k",
> whereas "fbsize=128k" or "gxfb.fbsize=128k" should work.  Needs checking.
> 
> >  	return 0;
> > @@ -456,5 +458,8 @@ module_exit(gxfb_cleanup);
> >  module_param(mode_option, charp, 0);
> >  MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
> >  
> > +module_param(fbsize, int, 0);
> > +MODULE_PARM_DESC(fbsize, "video memory size");
> > +
> 
> Because the module_param() already makes fbsize available on the kernel
> boot command line via gxfb.fbsize=42 (or something similar).
> 
> 


Thanks, here's an updated patch:




Use a command line option (vram) rather than hardcoding the vram size.
LxFB already does this; it's useful for machines that can't query the
BIOS for fb size.  This patch originated from David Woodhouse, was
modified by Jordan Crouse, and was then modified further by me.

This also adds some gxfb documentation in Documentation/fb.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 Documentation/fb/gxfb.txt        |   51 ++++++++++++++++++++++++++++++++++++++
 drivers/video/geode/Kconfig      |   20 ---------------
 drivers/video/geode/display_gx.c |    7 -----
 drivers/video/geode/gxfb_core.c  |   14 ++++++----
 4 files changed, 59 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/fb/gxfb.txt

diff --git a/Documentation/fb/gxfb.txt b/Documentation/fb/gxfb.txt
new file mode 100644
index 0000000..2d3dbaf
--- /dev/null
+++ b/Documentation/fb/gxfb.txt
@@ -0,0 +1,51 @@
+[This file is cloned from VesaFB/aty128fb]
+
+What is gxfb?
+=================
+
+This is a graphics framebuffer driver for AMD Geode GX2 based processors.
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
+Switching modes is done using  gxfb.mode_option=<resolution>... boot
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
+You can pass kernel command line options to gxfb with gxfb.<option>.
+For example, gxfb.mode_option=800x600@75.
+Accepted options:
+
+mode_option	- specify the video mode.  Of the form
+		  <x>x<y>[-<bpp>][@<refresh>]
+vram		- size of video ram (normally auto-detected)
+
+
+--
+Andres Salomon <dilinger@debian.org>
diff --git a/drivers/video/geode/Kconfig b/drivers/video/geode/Kconfig
index 7608429..c5d8ba4 100644
--- a/drivers/video/geode/Kconfig
+++ b/drivers/video/geode/Kconfig
@@ -38,26 +38,6 @@ config FB_GEODE_GX
 
 	  If unsure, say N.
 
-config FB_GEODE_GX_SET_FBSIZE
-	bool "Manually specify the Geode GX framebuffer size"
-	depends on FB_GEODE_GX
-	default n
-	---help---
-	  If you want to manually specify the size of your GX framebuffer,
-	  say Y here, otherwise say N to dynamically probe it.
-
-	  Say N unless you know what you are doing.
-
-config FB_GEODE_GX_FBSIZE
-	hex "Size of the GX framebuffer, in bytes"
-	depends on FB_GEODE_GX_SET_FBSIZE
-	default "0x1600000"
-	---help---
-	  Specify the size of the GX framebuffer.  Normally, you will
-	  want this to be MB aligned.  Common values are 0x80000 (8MB)
-	  and 0x1600000 (16MB).  Don't change this unless you know what
-	  you are doing
-
 config FB_GEODE_GX1
 	tristate "AMD Geode GX1 framebuffer support (EXPERIMENTAL)"
 	depends on FB && FB_GEODE && EXPERIMENTAL
diff --git a/drivers/video/geode/display_gx.c b/drivers/video/geode/display_gx.c
index 0f16e4b..8cd7572 100644
--- a/drivers/video/geode/display_gx.c
+++ b/drivers/video/geode/display_gx.c
@@ -21,12 +21,6 @@
 #include "geodefb.h"
 #include "display_gx.h"
 
-#ifdef CONFIG_FB_GEODE_GX_SET_FBSIZE
-unsigned int gx_frame_buffer_size(void)
-{
-	return CONFIG_FB_GEODE_GX_FBSIZE;
-}
-#else
 unsigned int gx_frame_buffer_size(void)
 {
 	unsigned int val;
@@ -41,7 +35,6 @@ unsigned int gx_frame_buffer_size(void)
 	val = (unsigned int)(inw(0xAC1E)) & 0xFFl;
 	return (val << 19);
 }
-#endif
 
 int gx_line_delta(int xres, int bpp)
 {
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index cf841ef..a3e4a34 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -36,6 +36,7 @@
 #include "video_gx.h"
 
 static char *mode_option;
+static int vram;
 
 /* Modes relevant to the GX (taken from modedb.c) */
 static const struct fb_videomode gx_modedb[] __initdata = {
@@ -207,7 +208,6 @@ static int gxfb_blank(int blank_mode, struct fb_info *info)
 static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *dev)
 {
 	struct geodefb_par *par = info->par;
-	int fb_len;
 	int ret;
 
 	ret = pci_enable_device(dev);
@@ -232,21 +232,20 @@ static int __init gxfb_map_video_memory(struct fb_info *info, struct pci_dev *de
 	ret = pci_request_region(dev, 0, "gxfb (framebuffer)");
 	if (ret < 0)
 		return ret;
-	if ((fb_len = gx_frame_buffer_size()) < 0)
-		return -ENOMEM;
+
 	info->fix.smem_start = pci_resource_start(dev, 0);
-	info->fix.smem_len = fb_len;
+	info->fix.smem_len = vram ? vram : gx_frame_buffer_size();
 	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
 	if (!info->screen_base)
 		return -ENOMEM;
 
-	/* Set the 16MB aligned base address of the graphics memory region
+	/* Set the 16MiB aligned base address of the graphics memory region
 	 * in the display controller */
 
 	writel(info->fix.smem_start & 0xFF000000,
 			par->dc_regs + DC_GLIU0_MEM_OFFSET);
 
-	dev_info(&dev->dev, "%d Kibyte of video memory at 0x%lx\n",
+	dev_info(&dev->dev, "%d KiB of video memory at 0x%lx\n",
 		 info->fix.smem_len / 1024, info->fix.smem_start);
 
 	return 0;
@@ -456,5 +455,8 @@ module_exit(gxfb_cleanup);
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
 
+module_param(vram, int, 0);
+MODULE_PARM_DESC(vram, "video memory size");
+
 MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode GX");
 MODULE_LICENSE("GPL");
-- 
1.5.3.7

.

