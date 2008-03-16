Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYCPTsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYCPTsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYCPTsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:48:08 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:51354 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYCPTsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:48:07 -0400
Date: Sun, 16 Mar 2008 20:48:05 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: [Linux-fbdev-devel] [PATCH] i810fb: Fix console switch regression
In-Reply-To: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de>
Message-ID: <Pine.LNX.4.64.0803162042460.7207@anakin>
References: <200803161942.24555.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008, Stefan Bauer wrote:
> From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
> 
> Commit eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 ("fix ! versus & precedence in 
> various places") introduced a regression in console switching when using 
> i810fb. Every 5th to 10th console switch causes 'pixel waste' - the same line 
> of multi-colored pixels repeated over the whole screen.
> This reverts eaa0ff1 for i810_main.c.
> 
> Signed-off-by: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
> Cc: Antonino Daplas <adaplas@pol.net>
> 
> ---
> As I'm not subscribed to the LKML, please CC me, thanks.
> 
> --- linux-2.6/drivers/video/i810/i810_main.c.orig
> +++ linux-2.6/drivers/video/i810/i810_main.c
> @@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info 
> 	struct i810fb_par *par = info->par;
> 	u8 __iomem *mmio = par->mmio_start_virtual;
> 
> -	if (!(par->dev_flags & LOCKUP))
> +	if (!par->dev_flags & LOCKUP)
> 		return -ENXIO;

However, the original expression didn't make sense, as LOCKUP is 8 and
!par->dev_flags is either 0 or 1, so `!par->dev_flags & LOCKUP' is
always 0.

I took a quick look at the usage of the LOCKUP flag. Apparently when a
lock-up is detected, this flag is set, and the driver will fall back to
software operations instead of hardware accelerated operations.

Is it possible the intended code was

	if (par->dev_flags & LOCKUP)
		return -ENXIO;

?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
