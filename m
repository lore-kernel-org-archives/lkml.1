Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575Ab0A0QvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0A0QvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524Ab0A0QvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:51:20 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:42025 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755451Ab0A0QvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:51:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=S9sst67HOFIfYdNjIAOFAhIToozoLyQt8+s2xBM0sBwTM9jF0dXUDBUWEWJVzrhvxvRLnyMyg6vu34HxwddMPQdbRuODh3ZiYL8nCvMvOuwo/KL1heV99JLtglEOmBjX;
Date: Wed, 27 Jan 2010 08:51:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David John <davidjon@xenontk.org>
Cc: yakui.zhao@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Disable SR when more than one pipe is enabled
Message-ID: <20100127085103.317e5ad8@jbarnes-piketon>
In-Reply-To: <1264585748-16929-1-BlackWidow-davidjon@xenontk.org>
References: <4B60080E.2000508@xenontk.org>
	<1264585748-16929-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 15:19:08 +0530
David John <davidjon@xenontk.org> wrote:

> Self Refresh should be disabled on dual plane configs.
> Otherwise, as the SR watermark is not calculated for
> such configs, switching to non VGA mode causes FIFO
> underrun and display flicker.
> 
> This fixes Korg Bug # 14897.
> 
> Signed-off-by: David John <davidjon@xenontk.org>
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 45da78e..46d7c0c 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -2519,6 +2519,10 @@ static void g4x_update_wm(struct drm_device *dev,  int planea_clock,
>  		sr_entries = roundup(sr_entries / cacheline_size, 1);
>  		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
>  		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
> +	} else {
> +		/* Turn off self refresh if both pipes are enabled */
> +		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
> +					& ~FW_BLC_SELF_EN);
>  	}
>  
>  	DRM_DEBUG("Setting FIFO watermarks - A: %d, B: %d, SR %d\n",
> @@ -2562,6 +2566,10 @@ static void i965_update_wm(struct drm_device *dev, int planea_clock,
>  			srwm = 1;
>  		srwm &= 0x3f;
>  		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
> +	} else {
> +		/* Turn off self refresh if both pipes are enabled */
> +		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
> +					& ~FW_BLC_SELF_EN);
>  	}
>  
>  	DRM_DEBUG_KMS("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n",
> @@ -2630,6 +2638,10 @@ static void i9xx_update_wm(struct drm_device *dev, int planea_clock,
>  		if (srwm < 0)
>  			srwm = 1;
>  		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN | (srwm & 0x3f));
> +	} else {
> +		/* Turn off self refresh if both pipes are enabled */
> +		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
> +					& ~FW_BLC_SELF_EN);
>  	}
>  
>  	DRM_DEBUG_KMS("Setting FIFO watermarks - A: %d, B: %d, C: %d, SR %d\n",
> 

Great!  Looks like the docs were a bit misleading here.  Disabling
self-refresh for dual plane configs is the safest thing to do.

Eric, please apply asap.  Should probably go to stable as well.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
