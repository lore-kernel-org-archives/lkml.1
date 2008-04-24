Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYDXVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYDXVGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYDXVGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:06:03 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:36142 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYDXVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:06:01 -0400
Date: Thu, 24 Apr 2008 23:05:55 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Roel Kluin <12o3l@tiscali.nl>
cc: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] atafb: test virtual screen range
 before subtraction on unsigned
In-Reply-To: <480F8522.4090805@tiscali.nl>
Message-ID: <Pine.LNX.4.64.0804242304310.21224@anakin>
References: <480F6FF9.9000605@tiscali.nl> <480F8522.4090805@tiscali.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Roel Kluin wrote:
> a bit similar to vga16fb,
> ---
> dx and dy are u32's, so the test should occur before the subtraction

Note that fb_copyarea.d[xy] are also u32, while there are many tests
that check for these fields being negative.

> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
> index 5d4fbaa..8f60a8f 100644
> --- a/drivers/video/atafb.c
> +++ b/drivers/video/atafb.c
> @@ -2593,13 +2593,16 @@ static void atafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
>  	width = x2 - dx;
>  	height = y2 - dy;
>  
> +	if (area->sx + dx < area->dx || area->sy + dy < area->dy)
> +		return;
> +
>  	/* update sx,sy */
>  	sx = area->sx + (dx - area->dx);
>  	sy = area->sy + (dy - area->dy);
>  
>  	/* the source must be completely inside the virtual screen */
> -	if (sx < 0 || sy < 0 || (sx + width) > info->var.xres_virtual ||
> -	    (sy + height) > info->var.yres_virtual)
> +	if (sx + width > info->var.xres_virtual ||
> +			sy + height > info->var.yres_virtual)
>  		return;
>  
>  	if (dy > sy || (dy == sy && dx > sx)) {
> 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
