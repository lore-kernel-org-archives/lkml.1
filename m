Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZBIUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZBIUMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZBIUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:12:03 -0500
Received: from mx1.wp.pl ([212.77.101.5]:28959 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZBIUMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:12:02 -0500
Date: Mon, 9 Feb 2009 21:16:14 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 13/15] amba-clcd: fix cmap memory
 leaks
Message-Id: <20090209211614.44459a12.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121848.536b136d@ephemeral>
References: <20090207121848.536b136d@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [0fPE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:18:48 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
>  - fix cmap leak in removal path
>  - fix cmap leak when register_framebuffer fails
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

One comment (see below).

>  drivers/video/amba-clcd.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
> index 4e046fe..61050ab 100644
> --- a/drivers/video/amba-clcd.c
> +++ b/drivers/video/amba-clcd.c
> @@ -408,7 +408,9 @@ static int clcdfb_register(struct clcd_fb *fb)
>  	/*
>  	 * Allocate colourmap.
>  	 */
> -	fb_alloc_cmap(&fb->fb.cmap, 256, 0);
> +	ret = fb_alloc_cmap(&fb->fb.cmap, 256, 0);
> +	if (ret)
> +		goto unmap;
>  
>  	/*
>  	 * Ensure interrupts are disabled.
> @@ -426,6 +428,8 @@ static int clcdfb_register(struct clcd_fb *fb)
>  
>  	printk(KERN_ERR "CLCD: cannot register framebuffer (%d)\n", ret);
>  
> +	fb_dealloc_cmap(&fb->fb.cmap);
> + unmap:
>  	iounmap(fb->regs);
>   free_clk:
>  	clk_put(fb->clk);
> @@ -485,6 +489,8 @@ static int clcdfb_remove(struct amba_device *dev)
>  
>  	clcdfb_disable(fb);
>  	unregister_framebuffer(&fb->fb);
> +	if (fb->fb.cmap.len)
> +		fb_dealloc_cmap(&fb->fb.cmap);

Is this if() needed? Is this function called twice (or more) or
can it be called without the cmap allocated?

>  	iounmap(fb->regs);
>  	clk_put(fb->clk);
>  
> -- 
> 1.5.6.5
> 
