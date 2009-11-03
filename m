Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZKCRTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZKCRTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZKCRTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:19:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:42986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZKCRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:19:12 -0500
Date: Tue, 3 Nov 2009 17:19:05 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] drm/kms: allocate framebuffer cmap
In-Reply-To: <4AF01FFD.50409@ladisch.de>
Message-ID: <alpine.LFD.2.00.0911031718160.14442@casper.infradead.org>
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de> <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org> <4AF01F72.2030605@ladisch.de> <4AF01FFD.50409@ladisch.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Without an allocated colormap, FBIOGETCMAP fails.  This would make
> programs restore an all-black colormap ("links -g") or fail to work
> altogether ("mplayer -vo fbdev2").
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
> v2: implemented suggestions by James Simmons
> 
>  drivers/gpu/drm/drm_fb_helper.c |   4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- linux-2.6/drivers/gpu/drm/drm_fb_helper.c
> +++ linux-2.6/drivers/gpu/drm/drm_fb_helper.c
> @@ -905,6 +905,9 @@ int drm_fb_helper_single_fb_probe(struct
>  
>  	if (new_fb) {
>  		info->var.pixclock = 0;
> +		ret = fb_alloc_cmap(&info->cmap, crtc->gamma_size, 0);
> +		if (ret)
> +			return ret;


>  		if (register_framebuffer(info) < 0) {
			fb_dealloc_cmap(info->cmap);	
>  			return -EINVAL;
		}

Plug memory leak.


>  	} else {
> @@ -936,6 +939,7 @@ void drm_fb_helper_free(struct drm_fb_he
>  		unregister_sysrq_key('v', &sysrq_drm_fb_helper_restore_op);
>  	}
>  	drm_fb_helper_crtc_free(helper);
> +	fb_dealloc_cmap(&helper->fb->fbdev->cmap);
>  }
>  EXPORT_SYMBOL(drm_fb_helper_free);
>  
> 
> 
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry(R) Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay 
> ahead of the curve. Join us from November 9 - 12, 2009. Register now!
> http://p.sf.net/sfu/devconference
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
