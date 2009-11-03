Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZKCH7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZKCH7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:59:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZKCH7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:59:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299AbZKCH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:59:00 -0500
Date: Mon, 2 Nov 2009 23:58:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valentin Sitdikov <valentin.sitdikov@siemens.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] mb862xxfb: add acceleration support for
 Coral-P/Coral-PA. * imageblt * copyarea * fillrect
Message-Id: <20091102235808.6ccc1bcd.akpm@linux-foundation.org>
In-Reply-To: <1256041745-21128-1-git-send-email-valentin.sitdikov@siemens.com>
References: <1256041745-21128-1-git-send-email-valentin.sitdikov@siemens.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 16:29:05 +0400 Valentin Sitdikov <valentin.sitdikov@siemens.com> wrote:

> 
> ...
>
> +/* Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
> + * Make sure cmd has enough room! */

The comment layout is sicky-looking.

> +static void mb86290fb_imageblit(struct fb_info *info,
> +				const struct fb_image *image)
> +{
> +	int mdr;
> +	u32 *cmd = NULL;
> +	void (*cmdfn) (u32 *, u16, u16, u16, u16, u16, u32, u32,
> +		       const struct fb_image *, struct fb_info *) = NULL;
> +	u32 cmdlen;
> +	u32 fgcolor = 0, bgcolor = 0;
> +	u16 step;
> +
> +	u16 width = image->width, height = image->height;
> +	u16 dx = image->dx, dy = image->dy;
> +	int x2, y2, vxres, vyres;
> +
> +	mdr = (GDC_ROP_COPY << 9);
> +	x2 = image->dx + image->width;
> +	y2 = image->dy + image->height;
> +	dx = image->dx > 0 ? image->dx : 0;
> +	dy = image->dy > 0 ? image->dy : 0;

image->dz and image->dy are unsigned, so the above two statements
have no effect.

> +	vxres = info->var.xres_virtual;
> +	vyres = info->var.yres_virtual;
> +	x2 = x2 < vxres ? x2 : vxres;
> +	y2 = y2 < vyres ? y2 : vyres;

We have nice helper macros for this - please don't open code them.


Please review:

--- a/drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix
+++ a/drivers/video/mb862xx/mb862xxfb_accel.c
@@ -66,8 +66,10 @@ static void mb86290fb_copyarea(struct fb
 	mb862xxfb_write_fifo(6, cmd, info);
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit1(u32 *cmd, u16 step, u16 dx, u16 dy,
 				 u16 width, u16 height, u32 fgcolor,
 				 u32 bgcolor, const struct fb_image *image,
@@ -113,8 +115,10 @@ static void mb86290fb_imageblit1(u32 *cm
 	}
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 8bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 8bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit8(u32 *cmd, u16 step, u16 dx, u16 dy,
 				 u16 width, u16 height, u32 fgcolor,
 				 u32 bgcolor, const struct fb_image *image,
@@ -150,8 +154,10 @@ static void mb86290fb_imageblit8(u32 *cm
 	}
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 16bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 16bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit16(u32 *cmd, u16 step, u16 dx, u16 dy,
 				  u16 width, u16 height, u32 fgcolor,
 				  u32 bgcolor, const struct fb_image *image,
@@ -195,12 +201,10 @@ static void mb86290fb_imageblit(struct f
 	mdr = (GDC_ROP_COPY << 9);
 	x2 = image->dx + image->width;
 	y2 = image->dy + image->height;
-	dx = image->dx > 0 ? image->dx : 0;
-	dy = image->dy > 0 ? image->dy : 0;
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
-	x2 = x2 < vxres ? x2 : vxres;
-	y2 = y2 < vyres ? y2 : vyres;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
 	width = x2 - dx;
 	height = y2 - dy;
 
@@ -265,8 +269,8 @@ static void mb86290fb_fillrect(struct fb
 	 * hardware clipping by writing to framebuffer directly. */
 	x2 = rect->dx + rect->width;
 	y2 = rect->dy + rect->height;
-	x2 = x2 < vxres ? x2 : vxres;
-	y2 = y2 < vyres ? y2 : vyres;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
 	width = x2 - rect->dx;
 	height = y2 - rect->dy;
 	if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
diff -puN drivers/video/mb862xx/mb862xxfb_accel.h~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix drivers/video/mb862xx/mb862xxfb_accel.h
_

