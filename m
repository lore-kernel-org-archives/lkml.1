Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbXGBUfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbXGBUfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbXGBUf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:35:28 -0400
Received: from mga06.intel.com ([134.134.136.21]:9397 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754631AbXGBUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:35:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,488,1175497200"; 
   d="scan'208";a="261451448"
Message-Id: <20070702170708.062695000@em64tdvp.jf.intel.com>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
Date: Mon, 02 Jul 2007 10:06:17 -0700
From: Chandramouli Narayanan <mouli@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org
Subject: [PATCH 2.6.21 3/3] x86_64 EFI64 support Try #2
Content-Disposition: inline; filename=patch3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EFI x86_64 support Patch 3 of 3 (try #2)
----------------------------------------
- Fixed redundant check in efifb_init().

This patch depends on the EFI x86_64 patches 1/3 and 2/3.

This patch adds Graphics Output Protocol support to the kernel.
x86_64 systems with UEFI2.0 firmware conform to UEFI 2.0 specification.
UEFI2.0 spec deprecates Universal Graphics Adapter (UGA) protocol and
only Graphics Output Protocol (GOP) is produced. Therefore, the boot loader
needs to query the UEFI firmware with appropriate Output Protocol and
pass the video information to the kernel. As a result of GOP
protocol, an EFI framebuffer driver is needed for displaying console messages.
Patch 3 of 3 adds a EFI framebuffer driver. The EFI frame buffer driver in this
patch is based on the Intel Mac framebuffer driver.

The x86_64 ELILO bootloader takes care of passing the video information
as appropriate for EFI firmware. 

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/include/linux/screen_info.h linux-2.6.21-uefi-finaltest4/include/linux/screen_info.h
--- linux-2.6.21-orig/include/linux/screen_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/include/linux/screen_info.h	2007-06-12 16:16:12.000000000 -0700
@@ -63,6 +63,7 @@ extern struct screen_info screen_info;
 #define VIDEO_TYPE_EGAC		0x21	/* EGA in Color Mode		*/
 #define VIDEO_TYPE_VGAC		0x22	/* VGA+ in Color Mode		*/
 #define VIDEO_TYPE_VLFB		0x23	/* VESA VGA in graphic mode	*/
+#define VIDEO_TYPE_EFI		0x24	/* EFI graphic mode		*/
 
 #define VIDEO_TYPE_PICA_S3	0x30	/* ACER PICA-61 local S3 video	*/
 #define VIDEO_TYPE_MIPS_G364	0x31    /* MIPS Magnum 4000 G364 video  */
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/drivers/video/Kconfig linux-2.6.21-uefi-finaltest4/drivers/video/Kconfig
--- linux-2.6.21-orig/drivers/video/Kconfig	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/drivers/video/Kconfig	2007-06-12 16:16:12.000000000 -0700
@@ -539,6 +539,17 @@ config FB_VESA
 	  You will get a boot time penguin logo at no additional cost. Please
 	  read <file:Documentation/fb/vesafb.txt>. If unsure, say Y.
 
+config FB_EFI
+	bool "EFI-based Framebuffer Support"
+	depends on (FB = y) && X86 && EFI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the EFI frame buffer device driver. If the firmware on
+	  your platform is UEFI2.0, select Y to add support for
+	  Graphics Output Protocol for early console messages to appear.
+
 config FB_IMAC
 	bool "Intel-based Macintosh Framebuffer Support"
 	depends on (FB = y) && X86 && EFI
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/drivers/video/Makefile linux-2.6.21-uefi-finaltest4/drivers/video/Makefile
--- linux-2.6.21-orig/drivers/video/Makefile	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/drivers/video/Makefile	2007-06-12 16:16:12.000000000 -0700
@@ -103,6 +103,7 @@ obj-$(CONFIG_FB_SM501)            += sm5
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_VESA)             += vesafb.o
 obj-$(CONFIG_FB_IMAC)             += imacfb.o
+obj-$(CONFIG_FB_EFI)              += efifb.o
 obj-$(CONFIG_FB_VGA16)            += vga16fb.o vgastate.o
 obj-$(CONFIG_FB_OF)               += offb.o
 
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/drivers/video/efifb.c linux-2.6.21-uefi-finaltest4/drivers/video/efifb.c
--- linux-2.6.21-orig/drivers/video/efifb.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21-uefi-finaltest4/drivers/video/efifb.c	2007-06-12 16:16:12.000000000 -0700
@@ -0,0 +1,249 @@
+/*
+ * framebuffer driver for Intel Based Mac's
+ *
+ * (c) 2006 Edgar Hucek <gimli@dark-green.com>
+ * Original efi driver written by Gerd Knorr <kraxel@goldbach.in-berlin.de>
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/screen_info.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/dmi.h>
+#include <linux/efi.h>
+
+#include <asm/io.h>
+
+#include <video/vga.h>
+
+static struct fb_var_screeninfo efifb_defined __initdata = {
+	.activate		= FB_ACTIVATE_NOW,
+	.height			= -1,
+	.width			= -1,
+	.right_margin		= 32,
+	.upper_margin		= 16,
+	.lower_margin		= 4,
+	.vsync_len		= 4,
+	.vmode			= FB_VMODE_NONINTERLACED,
+};
+
+static struct fb_fix_screeninfo efifb_fix __initdata = {
+	.id			= "EFI VGA",
+	.type			= FB_TYPE_PACKED_PIXELS,
+	.accel			= FB_ACCEL_NONE,
+	.visual			= FB_VISUAL_TRUECOLOR,
+};
+
+static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			    unsigned blue, unsigned transp,
+			    struct fb_info *info)
+{
+	/*
+	 *  Set a single color register. The values supplied are
+	 *  already rounded down to the hardware's capabilities
+	 *  (according to the entries in the `var' structure). Return
+	 *  != 0 for invalid regno.
+	 */
+
+	if (regno >= info->cmap.len)
+		return 1;
+
+	if (regno < 16) {
+		red   >>= 8;
+		green >>= 8;
+		blue  >>= 8;
+		((u32 *)(info->pseudo_palette))[regno] =
+			(red   << info->var.red.offset)   |
+			(green << info->var.green.offset) |
+			(blue  << info->var.blue.offset);
+	}
+	return 0;
+}
+
+static struct fb_ops efifb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_setcolreg	= efifb_setcolreg,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+static int __init efifb_probe(struct platform_device *dev)
+{
+	struct fb_info *info;
+	int err;
+	unsigned int size_vmode;
+	unsigned int size_remap;
+	unsigned int size_total;
+
+	efifb_fix.smem_start = screen_info.lfb_base;
+	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
+	efifb_defined.xres = screen_info.lfb_width;
+	efifb_defined.yres = screen_info.lfb_height;
+	efifb_fix.line_length = screen_info.lfb_linelength;
+
+	/*   size_vmode -- that is the amount of memory needed for the
+	 *                 used video mode, i.e. the minimum amount of
+	 *                 memory we need. */
+	size_vmode = efifb_defined.yres * efifb_fix.line_length;
+
+	/*   size_total -- all video memory we have. Used for
+	 *                 entries, ressource allocation and bounds
+	 *                 checking. */
+	//size_total = screen_info.lfb_size * 65536;
+	size_total = screen_info.lfb_size;
+	if (size_total < size_vmode)
+		size_total = size_vmode;
+
+	/*   size_remap -- the amount of video memory we are going to
+	 *                 use for efifb.  With modern cards it is no
+	 *                 option to simply use size_total as that
+	 *                 wastes plenty of kernel address space. */
+	size_remap  = size_vmode * 2;
+	if (size_remap < size_vmode)
+		size_remap = size_vmode;
+	if (size_remap > size_total)
+		size_remap = size_total;
+	efifb_fix.smem_len = size_remap;
+
+#ifndef __i386__
+	//screen_info.imacpm_seg = 0;
+#endif
+
+	if (!request_mem_region(efifb_fix.smem_start, size_total, "efifb")) {
+		printk(KERN_WARNING
+		       "efifb: cannot reserve video memory at 0x%lx\n",
+			efifb_fix.smem_start);
+		/* We cannot make this fatal. Sometimes this comes from magic
+		   spaces our resource handlers simply don't know about */
+	}
+
+	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
+	if (!info) {
+		err = -ENOMEM;
+		goto err_release_mem;
+	}
+	info->pseudo_palette = info->par;
+	info->par = NULL;
+
+	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
+	if (!info->screen_base) {
+		printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
+				"0x%x @ 0x%lx\n",
+			efifb_fix.smem_len, efifb_fix.smem_start);
+		err = -EIO;
+		goto err_unmap;
+	}
+
+	printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
+	       "using %dk, total %dk\n",
+	       efifb_fix.smem_start, info->screen_base,
+	       size_remap/1024, size_total/1024);
+	printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+	       efifb_defined.xres, efifb_defined.yres,
+	       efifb_defined.bits_per_pixel, efifb_fix.line_length,
+	       screen_info.pages);
+
+	efifb_defined.xres_virtual = efifb_defined.xres;
+	efifb_defined.yres_virtual = efifb_fix.smem_len /
+					efifb_fix.line_length;
+	printk(KERN_INFO "efifb: scrolling: redraw\n");
+	efifb_defined.yres_virtual = efifb_defined.yres;
+
+	/* some dummy values for timing to make fbset happy */
+	efifb_defined.pixclock     = 10000000 / efifb_defined.xres *
+					1000 / efifb_defined.yres;
+	efifb_defined.left_margin  = (efifb_defined.xres / 8) & 0xf8;
+	efifb_defined.hsync_len    = (efifb_defined.xres / 8) & 0xf8;
+
+	efifb_defined.red.offset    = screen_info.red_pos;
+	efifb_defined.red.length    = screen_info.red_size;
+	efifb_defined.green.offset  = screen_info.green_pos;
+	efifb_defined.green.length  = screen_info.green_size;
+	efifb_defined.blue.offset   = screen_info.blue_pos;
+	efifb_defined.blue.length   = screen_info.blue_size;
+	efifb_defined.transp.offset = screen_info.rsvd_pos;
+	efifb_defined.transp.length = screen_info.rsvd_size;
+
+	printk(KERN_INFO "efifb: %s: "
+	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
+	       "Truecolor",
+	       screen_info.rsvd_size,
+	       screen_info.red_size,
+	       screen_info.green_size,
+	       screen_info.blue_size,
+	       screen_info.rsvd_pos,
+	       screen_info.red_pos,
+	       screen_info.green_pos,
+	       screen_info.blue_pos);
+
+	efifb_fix.ypanstep  = 0;
+	efifb_fix.ywrapstep = 0;
+
+	info->fbops = &efifb_ops;
+	info->var = efifb_defined;
+	info->fix = efifb_fix;
+	info->flags = FBINFO_FLAG_DEFAULT;
+
+	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
+		err = -ENOMEM;
+		goto err_unmap;
+	}
+	if (register_framebuffer(info)<0) {
+		err = -EINVAL;
+		goto err_fb_dealoc;
+	}
+	printk(KERN_INFO "fb%d: %s frame buffer device\n",
+	       info->node, info->fix.id);
+	return 0;
+
+err_fb_dealoc:
+	fb_dealloc_cmap(&info->cmap);
+err_unmap:
+	iounmap(info->screen_base);
+	framebuffer_release(info);
+err_release_mem:
+	release_mem_region(efifb_fix.smem_start, size_total);
+	return err;
+}
+
+static struct platform_driver efifb_driver = {
+	.probe	= efifb_probe,
+	.driver	= {
+		.name	= "efifb",
+	},
+};
+
+static struct platform_device efifb_device = {
+	.name	= "efifb",
+};
+
+static int __init efifb_init(void)
+{
+	int ret;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return -ENODEV;
+
+
+	ret = platform_driver_register(&efifb_driver);
+
+	if (!ret) {
+		ret = platform_device_register(&efifb_device);
+		if (ret)
+			platform_driver_unregister(&efifb_driver);
+	}
+	return ret;
+}
+module_init(efifb_init);
+
+MODULE_LICENSE("GPL");

--
