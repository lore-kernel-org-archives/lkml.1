Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZBIRC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZBIRC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbZBIRCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:02:47 -0500
Received: from mx1.wp.pl ([212.77.101.5]:15713 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbZBIRCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:02:46 -0500
Date: Mon, 9 Feb 2009 18:06:59 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 9/15] valkyriefb: check
 fb_alloc_cmap return value and handle failure properly
Message-Id: <20090209180659.27650f7d.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121526.33494f59@ephemeral>
References: <20090207121526.33494f59@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [0YPU]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:15:26 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>


>  drivers/video/valkyriefb.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/valkyriefb.c b/drivers/video/valkyriefb.c
> index 7b0cef9..4bb9a0b 100644
> --- a/drivers/video/valkyriefb.c
> +++ b/drivers/video/valkyriefb.c
> @@ -119,7 +119,7 @@ static void set_valkyrie_clock(unsigned char *params);
>  static int valkyrie_var_to_par(struct fb_var_screeninfo *var,
>  	struct fb_par_valkyrie *par, const struct fb_info *fb_info);
>  
> -static void valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p);
> +static int valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p);
>  static void valkyrie_par_to_fix(struct fb_par_valkyrie *par, struct fb_fix_screeninfo *fix);
>  static void valkyrie_init_fix(struct fb_fix_screeninfo *fix, struct fb_info_valkyrie *p);
>  
> @@ -381,18 +381,22 @@ int __init valkyriefb_init(void)
>  
>  	valkyrie_choose_mode(p);
>  	mac_vmode_to_var(default_vmode, default_cmode, &p->info.var);
> -	valkyrie_init_info(&p->info, p);
> +	err = valkyrie_init_info(&p->info, p);
> +	if (err < 0)
> +		goto out_free;
>  	valkyrie_init_fix(&p->info.fix, p);
>  	if (valkyriefb_set_par(&p->info))
>  		/* "can't happen" */
>  		printk(KERN_ERR "valkyriefb: can't set default video mode\n");
>  
>  	if ((err = register_framebuffer(&p->info)) != 0)
> -		goto out_free;
> +		goto out_cmap_free;
>  
>  	printk(KERN_INFO "fb%d: valkyrie frame buffer device\n", p->info.node);
>  	return 0;
>  
> + out_cmap_free:
> +	fb_dealloc_cmap(&p->info.cmap);
>   out_free:
>  	if (p->frame_buffer)
>  		iounmap(p->frame_buffer);
> @@ -538,14 +542,15 @@ static void valkyrie_par_to_fix(struct fb_par_valkyrie *par,
>  		/* ywrapstep, xpanstep, ypanstep */
>  }
>  
> -static void __init valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p)
> +static int __init valkyrie_init_info(struct fb_info *info,
> +		struct fb_info_valkyrie *p)
>  {
>  	info->fbops = &valkyriefb_ops;
>  	info->screen_base = p->frame_buffer + 0x1000;
>  	info->flags = FBINFO_DEFAULT;
>  	info->pseudo_palette = p->pseudo_palette;
> -	fb_alloc_cmap(&info->cmap, 256, 0);
>  	info->par = &p->par;
> +	return fb_alloc_cmap(&info->cmap, 256, 0);
>  }
>  
>  
> -- 
> 1.5.6.5
> 
> 
> ------------------------------------------------------------------------------
> Create and Deploy Rich Internet Apps outside the browser with Adobe(R)AIR(TM)
> software. With Adobe AIR, Ajax developers can use existing skills and code to
> build responsive, highly engaging applications that combine the power of local
> resources and data with the reach of the web. Download the Adobe AIR SDK and
> Ajax docs to start building applications today-http://p.sf.net/sfu/adobe-com
> _______________________________________________
> Linux-fbdev-devel mailing list
> Linux-fbdev-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel
> 
