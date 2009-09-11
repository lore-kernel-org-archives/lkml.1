Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbZIKFwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbZIKFwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZIKFwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:52:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33209 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbZIKFwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:52:36 -0400
Date: Fri, 11 Sep 2009 06:52:40 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jerome Glisse <jglisse@redhat.com>
cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH 2/3] drm/radeon/kms: move mtrr range add and memory
 information
In-Reply-To: <1252612057-1993-1-git-send-email-jglisse@redhat.com>
Message-ID: <alpine.DEB.2.00.0909110651450.29694@skynet.skynet.ie>
References: <1252612057-1993-1-git-send-email-jglisse@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  /*
> + * Printing helpers
> + */
> +#define PINF(s, arg...) printk(KERN_INFO "radeon " s, ##arg)
> +#define PWRN(s, arg...) \
> +	printk(KERN_WARNING "radeon (WR:%s:%d) " s, __FILE__, __LINE__, ##arg)
> +#define PERR(s, arg...) \
> +	printk(KERN_ERR "radeon (ER:%s:%d) " s, __FILE__, __LINE__, ##arg)
> +

eh? no.

No more printf wrappers please, use DRM_*, or make them better,
or use drv_* or make them better.

but no sneaking stuff like this in a patch that doesn't mention it
introduces printf wrapping.

Dave.

> +
> +/*
>   * ASICs macro.
>   */
>  #define radeon_init(rdev) (rdev)->asic->init((rdev))
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 72f6262..07ef8b6 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -598,14 +598,6 @@ int radeon_device_init(struct radeon_device *rdev,
>  		/* Get vram informations */
>  		radeon_vram_info(rdev);
>  
> -		/* Add an MTRR for the VRAM */
> -		rdev->mc.vram_mtrr = mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
> -				MTRR_TYPE_WRCOMB, 1);
> -		DRM_INFO("Detected VRAM RAM=%uM, BAR=%uM\n",
> -				(unsigned)(rdev->mc.mc_vram_size >> 20),
> -				(unsigned)(rdev->mc.aper_size >> 20));
> -		DRM_INFO("RAM width %dbits %cDR\n",
> -				rdev->mc.vram_width, rdev->mc.vram_is_ddr ? 'D' : 'S');
>  		/* Initialize memory controller (also test AGP) */
>  		r = radeon_mc_init(rdev);
>  		if (r) {
> diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
> index b85fb83..0100b3b 100644
> --- a/drivers/gpu/drm/radeon/radeon_object.c
> +++ b/drivers/gpu/drm/radeon/radeon_object.c
> @@ -369,6 +369,13 @@ void radeon_object_force_delete(struct radeon_device *rdev)
>  
>  int radeon_object_init(struct radeon_device *rdev)
>  {
> +	/* Add an MTRR for the VRAM */
> +	rdev->mc.vram_mtrr = mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
> +			MTRR_TYPE_WRCOMB, 1);
> +	PINF("Detected VRAM RAM=%lluM, BAR=%lluM\n",
> +		rdev->mc.mc_vram_size >> 20, rdev->mc.aper_size >> 20);
> +	PINF("RAM width %dbits %cDR\n",
> +			rdev->mc.vram_width, rdev->mc.vram_is_ddr ? 'D' : 'S');
>  	return radeon_ttm_init(rdev);
>  }
>  
> 
