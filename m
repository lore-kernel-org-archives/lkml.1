Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZBIUD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZBIUD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbZBIUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:02:55 -0500
Received: from mx1.wp.pl ([212.77.101.5]:13714 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203AbZBIUCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:02:54 -0500
Date: Mon, 9 Feb 2009 21:07:06 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 12/15] 68328fb: fix cmap memory
 leaks
Message-Id: <20090209210706.c23ad741.krzysztof.h1@wp.pl>
In-Reply-To: <20090207121840.5138cb3d@ephemeral>
References: <20090207121840.5138cb3d@ephemeral>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [kaOE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 12:18:40 -0500
Andres Salomon <dilinger@queued.net> wrote:

> 
>  - fix cmap leak in removal path
>  - fix cmap leak when register_framebuffer fails
>  - check return value of fb_alloc_cmap
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

>  drivers/video/68328fb.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/68328fb.c b/drivers/video/68328fb.c
> index 7f907fb..0b17824 100644
> --- a/drivers/video/68328fb.c
> +++ b/drivers/video/68328fb.c
> @@ -471,9 +471,11 @@ int __init mc68x328fb_init(void)
>  	fb_info.pseudo_palette = &mc68x328fb_pseudo_palette;
>  	fb_info.flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
>  
> -	fb_alloc_cmap(&fb_info.cmap, 256, 0);
> +	if (fb_alloc_cmap(&fb_info.cmap, 256, 0))
> +		return -ENOMEM;
>  
>  	if (register_framebuffer(&fb_info) < 0) {
> +		fb_dealloc_cmap(&fb_info.cmap);
>  		return -EINVAL;
>  	}
>  
> @@ -494,6 +496,7 @@ module_init(mc68x328fb_init);
>  static void __exit mc68x328fb_cleanup(void)
>  {
>  	unregister_framebuffer(&fb_info);
> +	fb_dealloc_cmap(&fb_info.cmap);
>  }
>  
>  module_exit(mc68x328fb_cleanup);
> -- 
> 1.5.6.5
> 
