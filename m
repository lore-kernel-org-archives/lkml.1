Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXDVWpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXDVWpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 18:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXDVWpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 18:45:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:35296 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752989AbXDVWpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 18:45:24 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18SxaBSyeQSkX0I5dWaaiIMKlHtvnembLXvHyntQW
	VCQMMxNiI1EfQD
Date: Mon, 23 Apr 2007 00:45:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: linux-kernel@vger.kernel.org, jayalk@intworks.biz,
       akpm@linux-foundation.org
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
In-Reply-To: <1177260725.4268.9.camel@mulgrave.il.steeleye.com>
Message-ID: <Pine.LNX.4.60.0704222202050.4127@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
 <1177260725.4268.9.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, James Bottomley wrote:

> On Fri, 2007-04-13 at 20:08 +0200, Guennadi Liakhovetski wrote:
> > -	int bitmap_size = (pages + 31)/32;
> > +	int bitmap_size = DIV_ROUND_UP(pages, 8);
> 
> This isn't quite right.  Bitmaps are arrays of longs, not arrays of
> bytes.  The bug is forgetting that kmalloc() takes bytes ...
> 
> How about
> 
> int bitmap_size = DIV_ROUNDUP(pages, 32) * 4;

Right, thinko. How about using his:

+	int pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	int bitmap_size = BITS_TO_LONGS(pages) * BYTES_PER_LONG;

to also allow for size not an integer number of pages as Andrew noticed? 
This could be done in 2 patches:

---
Introduce BYTES_PER_LONG and remove local definitions. fbsys 
compile-tested, amifb untested (framebuffer maintainer cc'ed)...

Signed-off-by: G. Liakhovetski <g.liakhovetski@gmx.de>

--- a/include/linux/types.h	2007-04-15 22:07:52.000000000 +0200
+++ b/include/linux/types.h	2007-04-22 22:51:17.000000000 +0200
@@ -9,6 +9,7 @@
 	unsigned long name[BITS_TO_LONGS(bits)]
 
 #define BITS_PER_BYTE 8
+#define BYTES_PER_LONG (BITS_PER_LONG / BITS_PER_BYTE)
 #endif
 
 #include <linux/posix_types.h>
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 40c80c8..6bb68b8 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -19,6 +19,7 @@
 #include <linux/fb.h>
 #include <linux/console.h>
 #include <linux/module.h>
+#include <linux/types.h>
 
 #define FB_SYSFS_FLAG_ATTR 1
 
@@ -37,7 +38,6 @@
  */
 struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
 {
-#define BYTES_PER_LONG (BITS_PER_LONG/8)
 #define PADDING (BYTES_PER_LONG - (sizeof(struct fb_info) % BYTES_PER_LONG))
 	int fb_info_size = sizeof(struct fb_info);
 	struct fb_info *info;
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 1a849b8..a53d5a2 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -51,6 +51,8 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/types.h>
+#include <linux/log2.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -1350,15 +1352,7 @@ static int amifb_pan_display(struct fb_var_screeninfo *var,
 }
 
 
-#if BITS_PER_LONG == 32
-#define BYTES_PER_LONG	4
-#define SHIFT_PER_LONG	5
-#elif BITS_PER_LONG == 64
-#define BYTES_PER_LONG	8
-#define SHIFT_PER_LONG	6
-#else
-#define Please update me
-#endif
+#define SHIFT_PER_LONG	ilog2(BITS_PER_LONG)
 
 
     /*
