Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZBIRB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZBIRB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZBIRBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:01:39 -0500
Received: from mx1.wp.pl ([212.77.101.5]:14053 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbZBIRBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:01:38 -0500
Date: Mon, 9 Feb 2009 18:05:49 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, j@mx08.poczta.interia.pl,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 8/15] stifb: check fb_alloc_cmap
 return value and handle failure properly
Message-Id: <20090209180549.cb07d0fb.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121506.427d1cd8@ephemeral>
References: <20090207121506.427d1cd8@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [MQNU]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:15:06 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

I feel something is not right with the driver if memory 
region (info->screen_base) is io mapped first then
reserved with request_mem_region().

Regards,
Krzysztof

>  drivers/video/stifb.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
> index 1664814..eabaad7 100644
> --- a/drivers/video/stifb.c
> +++ b/drivers/video/stifb.c
> @@ -1262,24 +1262,25 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
>  	info->flags = FBINFO_DEFAULT;
>  	info->pseudo_palette = &fb->pseudo_palette;
>  
> -	/* This has to been done !!! */
> -	fb_alloc_cmap(&info->cmap, NR_PALETTE, 0);
> +	/* This has to be done !!! */
> +	if (fb_alloc_cmap(&info->cmap, NR_PALETTE, 0))
> +		goto out_err1;
>  	stifb_init_display(fb);
>  
>  	if (!request_mem_region(fix->smem_start, fix->smem_len, "stifb fb")) {
>  		printk(KERN_ERR "stifb: cannot reserve fb region 0x%04lx-0x%04lx\n",
>  				fix->smem_start, fix->smem_start+fix->smem_len);
> -		goto out_err1;
> +		goto out_err2;
>  	}
>  		
>  	if (!request_mem_region(fix->mmio_start, fix->mmio_len, "stifb mmio")) {
>  		printk(KERN_ERR "stifb: cannot reserve sti mmio region 0x%04lx-0x%04lx\n",
>  				fix->mmio_start, fix->mmio_start+fix->mmio_len);
> -		goto out_err2;
> +		goto out_err3;
>  	}
>  
>  	if (register_framebuffer(&fb->info) < 0)
> -		goto out_err3;
> +		goto out_err4;
>  
>  	sti->info = info; /* save for unregister_framebuffer() */
>  
> @@ -1297,13 +1298,14 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
>  	return 0;
>  
>  
> -out_err3:
> +out_err4:
>  	release_mem_region(fix->mmio_start, fix->mmio_len);
> -out_err2:
> +out_err3:
>  	release_mem_region(fix->smem_start, fix->smem_len);
> +out_err2:
> +	fb_dealloc_cmap(&info->cmap);
>  out_err1:
>  	iounmap(info->screen_base);
> -	fb_dealloc_cmap(&info->cmap);
>  out_err0:
>  	kfree(fb);
>  	return -ENXIO;
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
