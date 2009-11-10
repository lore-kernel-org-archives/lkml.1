Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbZKJXBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbZKJXBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758377AbZKJXBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:01:31 -0500
Received: from mx1.wp.pl ([212.77.101.5]:26237 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758317AbZKJXBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:01:30 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 18:01:29 EST
Date: Wed, 11 Nov 2009 00:58:25 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Ben Dooks <ben@simtec.co.uk>
Cc: akpm@linux-foundation.org, lethal@linux-sh.org, dilinger@debian.org,
       linux-kernel@vger.kernel.org, Vincent Sanders <vince@simtec.co.uk>,
       Simtec Linux Team <linux@simtec.co.uk>
Subject: Re: SM501: Implement acceleration features
Message-Id: <20091111005825.801e180e.krzysztof.h1@wp.pl>
In-Reply-To: <20091110171810.584051931@fluff.org.uk>
References: <20091110171810.584051931@fluff.org.uk>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [0YM0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 17:18:10 +0000
Ben Dooks <ben@simtec.co.uk> wrote:

> From: Vincent Sanders <vince@simtec.co.uk>
> 
> This patch provides the acceleration entry points for the SM501
> framebuffer driver.
> 
> This patch provides the sync, copyarea and fillrect entry points,
> using the SM501's 2D acceleration engine to perform the operations
> in-chip rather than across the bus.
> 
> Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
> Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
> 
> ---
>  drivers/video/sm501fb.c    |  238 ++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/sm501-regs.h |    2 
>  2 files changed, 226 insertions(+), 14 deletions(-)
> 
> Index: b/drivers/video/sm501fb.c
> ===================================================================
> --- a/drivers/video/sm501fb.c	2009-11-03 11:19:44.000000000 +0000
> +++ b/drivers/video/sm501fb.c	2009-11-03 11:19:46.000000000 +0000

(snip)

> @@ -1246,7 +1248,173 @@ static ssize_t sm501fb_debug_show_pnl(st
>  
>  static DEVICE_ATTR(fbregs_pnl, 0444, sm501fb_debug_show_pnl, NULL);
>  
> -/* framebuffer ops */
> +/* acceleration operations */
> +static int sm501fb_sync(struct fb_info *info)
> +{
> +	int count = 1000000;
> +	struct sm501fb_par  *par = info->par;
> +	struct sm501fb_info *fbi = par->info;
> +
> +	/* wait for the 2d engine to be ready */
> +	while ((count > 0) &&
> +	       (readl(fbi->regs + SM501_SYSTEM_CONTROL) &
> +		SM501_SYSCTRL_2D_ENGINE_STATUS) != 0)
> +		count--;
> +

You may add cpu_relax() inside this loop.

> +	if (count <= 0) {
> +		dev_err(info->dev, "Timeout waiting for 2d engine sync\n");
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static void sm501fb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
> +{
> +	struct sm501fb_par  *par = info->par;
> +	struct sm501fb_info *fbi = par->info;
> +	int width = area->width;
> +	int height = area->height;
> +	int sx = area->sx;
> +	int sy = area->sy;
> +	int dx = area->dx;
> +	int dy = area->dy;
> +	unsigned long rtl = 0;
> +
> +	/* source clip */
> +	if ((sx >= info->var.xres_virtual) ||
> +	    (sy >= info->var.yres_virtual))
> +		/* source Area not within virtual screen, skipping */
> +		return;
> +	if ((sx + width) >= info->var.xres_virtual)
> +		width = info->var.xres_virtual - sx - 1;
> +	if ((sy + height) >= info->var.yres_virtual)
> +		height = info->var.yres_virtual - sy - 1;
> +
> +	/* dest clip */
> +	if ((dx >= info->var.xres_virtual) ||
> +	    (dy >= info->var.yres_virtual))
> +		/* Destination Area not within virtual screen, skipping */
> +		return;
> +	if ((dx + width) >= info->var.xres_virtual)
> +		width = info->var.xres_virtual - dx - 1;
> +	if ((dy + height) >= info->var.yres_virtual)
> +		height = info->var.yres_virtual - dy - 1;
> +
> +	if ((sx < dx) || (sy < dy)) {
> +		rtl = 1 << 27;
> +		sx += width - 1;
> +		dx += width - 1;
> +		sy += height - 1;
> +		dy += height - 1;
> +	}
> +
> +	if (sm501fb_sync(info))
> +		return;
> +

Please check if you need to wait for the blit engine before writting to any register.
Usually, the values in the bit engine registers are shadowed after the engine is started
(ie. the blitting operation is started) and the next set of values can be written into the regs.

> +	/* set the base addresses */
> +	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
> +	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_DESTINATION_BASE);
> +
> +	/* set the window width */
> +	writel((info->var.xres << 16) | info->var.xres,
> +	       fbi->regs2d + SM501_2D_WINDOW_WIDTH);
> +
> +	/* set window stride */
> +	writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
> +	       fbi->regs2d + SM501_2D_PITCH);
> +
> +	/* set data format */
> +	switch (info->var.bits_per_pixel) {
> +	case 8:
> +		writel(0, fbi->regs2d + SM501_2D_STRETCH);
> +		break;
> +	case 16:
> +		writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
> +		break;
> +	case 32:
> +		writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
> +		break;
> +	}
> +
> +	/* 2d compare mask */
> +	writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
> +
> +	/* 2d mask */
> +	writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);

All writes above do not use any copyarea specific value. They should be done
only once in the sm501fb_set_par() function. It is enough to initialize the blitting
engine when a mode is set (xres/yres and bpp values are known then). The only
exception is when these values are reset by every blit operation.

> +
> +	/* source and destination x y */
> +	writel((sx << 16) | sy, fbi->regs2d + SM501_2D_SOURCE);
> +	writel((dx << 16) | dy, fbi->regs2d + SM501_2D_DESTINATION);
> +
> +	/* w/h */
> +	writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
> +
> +	/* do area move */
> +	writel(0x800000cc | rtl, fbi->regs2d + SM501_2D_CONTROL);
> +}
> +

The same comments apply for the fillrect() method.

> +static void sm501fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
> +{
> +	struct sm501fb_par  *par = info->par;
> +	struct sm501fb_info *fbi = par->info;
> +	int width = rect->width, height = rect->height;
> +
> +	if ((rect->dx >= info->var.xres_virtual) ||
> +	    (rect->dy >= info->var.yres_virtual))
> +		/* Rectangle not within virtual screen, skipping */
> +		return;
> +	if ((rect->dx + width) >= info->var.xres_virtual)
> +		width = info->var.xres_virtual - rect->dx - 1;
> +	if ((rect->dy + height) >= info->var.yres_virtual)
> +		height = info->var.yres_virtual - rect->dy - 1;
> +
> +	if (sm501fb_sync(info))
> +		return;
> +
> +	/* set the base addresses */
> +	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_SOURCE_BASE);
> +	writel(par->screen.sm_addr, fbi->regs2d + SM501_2D_DESTINATION_BASE);
> +
> +	/* set the window width */
> +	writel((info->var.xres << 16) | info->var.xres,
> +	       fbi->regs2d + SM501_2D_WINDOW_WIDTH);
> +
> +	/* set window stride */
> +	writel((info->var.xres_virtual << 16) | info->var.xres_virtual,
> +	       fbi->regs2d + SM501_2D_PITCH);
> +
> +	/* set data format */
> +	switch (info->var.bits_per_pixel) {
> +	case 8:
> +		writel(0, fbi->regs2d + SM501_2D_STRETCH);
> +		break;
> +	case 16:
> +		writel(0x00100000, fbi->regs2d + SM501_2D_STRETCH);
> +		break;
> +	case 32:
> +		writel(0x00200000, fbi->regs2d + SM501_2D_STRETCH);
> +		break;
> +	}
> +
> +	/* 2d compare mask */
> +	writel(0xffffffff, fbi->regs2d + SM501_2D_COLOR_COMPARE_MASK);
> +
> +	/* 2d mask */
> +	writel(0xffffffff, fbi->regs2d + SM501_2D_MASK);
> +
> +	/* colour */
> +	writel(rect->color, fbi->regs2d + SM501_2D_FOREGROUND);
> +
> +	/* x y */
> +	writel((rect->dx << 16) | rect->dy, fbi->regs2d + SM501_2D_DESTINATION);
> +
> +	/* w/h */
> +	writel((width << 16) | height, fbi->regs2d + SM501_2D_DIMENSION);
> +
> +	/* do rectangle fill */
> +	writel(0x800100cc, fbi->regs2d + SM501_2D_CONTROL);
> +}
> +
>  
>  static struct fb_ops sm501fb_ops_crt = {
>  	.owner		= THIS_MODULE,
> @@ -1256,9 +1424,10 @@ static struct fb_ops sm501fb_ops_crt = {
>  	.fb_setcolreg	= sm501fb_setcolreg,
>  	.fb_pan_display	= sm501fb_pan_crt,
>  	.fb_cursor	= sm501fb_cursor,
> -	.fb_fillrect	= cfb_fillrect,
> -	.fb_copyarea	= cfb_copyarea,
> +	.fb_fillrect	= sm501fb_fillrect,
> +	.fb_copyarea	= sm501fb_copyarea,
>  	.fb_imageblit	= cfb_imageblit,
> +	.fb_sync	= sm501fb_sync,
>  };
>  

You may want to try if setting the info->flags bit FBINFO_READS_FAST gives
you a faster scrolling on the  fb device. This flags says that you prefer to use
the copyarea function over the imageblit function for scrolling. The latter is
not accelerated in this driver.

Regards,
Krzysztof
