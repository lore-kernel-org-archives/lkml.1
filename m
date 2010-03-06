Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab0CFL6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:58:00 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:55520 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab0CFL57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:57:59 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Mar 2010 06:57:58 EST
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--H*Ad:D*sourceforge.net,
	0.000-+--H*Ad:D*lists.sourceforge.net, 0.000-+--H*Ad:D*kernel.org
X-Spam-Spammy: 0.980-+--HTo:U*daniel.vetter, 0.958-+--H*Ad:U*daniel.vetter,
	0.957-+--H*r:mail.ffwll.ch
Date: Sat, 6 Mar 2010 12:50:54 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dan Carpenter <error27@gmail.com>, David Airlie <airlied@linux.ie>,
       Eric Anholt <eric@anholt.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
       maximlevitsky@gmail.com, Chris Wilson <chris@chris-wilson.co.uk>,
       Luca Barbieri <luca@luca-barbieri.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] i915: fix small leak on error path
Message-ID: <20100306115054.GA3462@viiv.ffwll.ch>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	maximlevitsky@gmail.com, Chris Wilson <chris@chris-wilson.co.uk>,
	Luca Barbieri <luca@luca-barbieri.com>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100306110539.GD4958@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306110539.GD4958@bicker>
X-Operating-System: Linux viiv 2.6.33-05070-g64ba992 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, dang. Thanks for catching this. Eric, please merge.

Cc: stable@kernel.org (for .33)
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>

On Sat, Mar 06, 2010 at 02:05:39PM +0300, Dan Carpenter wrote:
> We should free "params" before returning.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
> index d355d1d..60595fc 100644
> --- a/drivers/gpu/drm/i915/intel_overlay.c
> +++ b/drivers/gpu/drm/i915/intel_overlay.c
> @@ -1068,14 +1068,18 @@ int intel_overlay_put_image(struct drm_device *dev, void *data,
>  
>  	drmmode_obj = drm_mode_object_find(dev, put_image_rec->crtc_id,
>                          DRM_MODE_OBJECT_CRTC);
> -	if (!drmmode_obj)
> -		return -ENOENT;
> +	if (!drmmode_obj) {
> +		ret = -ENOENT;
> +		goto out_free;
> +	}
>  	crtc = to_intel_crtc(obj_to_crtc(drmmode_obj));
>  
>  	new_bo = drm_gem_object_lookup(dev, file_priv,
>  			put_image_rec->bo_handle);
> -	if (!new_bo)
> -		return -ENOENT;
> +	if (!new_bo) {
> +		ret = -ENOENT;
> +		goto out_free;
> +	}
>  
>  	mutex_lock(&dev->mode_config.mutex);
>  	mutex_lock(&dev->struct_mutex);
> @@ -1165,6 +1169,7 @@ out_unlock:
>  	mutex_unlock(&dev->struct_mutex);
>  	mutex_unlock(&dev->mode_config.mutex);
>  	drm_gem_object_unreference_unlocked(new_bo);
> +out_free:
>  	kfree(params);
>  
>  	return ret;

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
