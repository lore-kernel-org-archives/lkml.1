Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbZIHJ5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbZIHJ5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZIHJ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:57:37 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45055 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZIHJ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dxOy/cQjQmrk7v7g4SxRIdvhEK1InVe852pF47SyOOEiFsnWjc8NoQaaMWwluuc4bb
         4MwQzwPtEUwRWO39WFxxyOddDb0JzLmcfO4/KZizzagAkHOOvjqt3aZjkg6eB5igQHfx
         n+1IoqjcB5e26ZD2om45QgShhwMIiuIvKDy/g=
Date: Tue, 8 Sep 2009 11:56:27 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected] Output to external monitor is broken (Re: Linux
	2.6.31-rc9)
Message-ID: <20090908095627.GA4094@Pilar.aei.mpg.de>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain> <20090906142206.GA4449@Pilar.aei.mpg.de> <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain> <20090907191219.GA5015@Pilar.aei.mpg.de> <20090908065808.GA30390@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908065808.GA30390@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue  8.Sep'09 at 14:58:08 +0800, Zhenyu Wang wrote:
> Carlos, I've just taken a look at that one, there're some drawbacks in
> it, but can't understand why it caused break for you. It'll be great if
> you can test with this one. 

Yes, the patch below fixes the problem here.
Thanks everyone and sorry for the delay!

> 
> From f3932299964b2616d42d7fcf734bd880009ab206 Mon Sep 17 00:00:00 2001
> From: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date: Tue, 8 Sep 2009 14:52:25 +0800
> Subject: [PATCH] drm/i915: fix mask bits setting
> 
> eDP is exclusive connector too, and add missing crtc_mask
> setting for TV.
> 
> Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c  |    2 +-
>  drivers/gpu/drm/i915/intel_drv.h |    1 +
>  drivers/gpu/drm/i915/intel_tv.c  |    1 +
>  3 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index f2afc4a..2b914d7 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1263,7 +1263,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
>  
>  	if (IS_eDP(intel_output)) {
>  		intel_output->crtc_mask = (1 << 1);
> -		intel_output->clone_mask = (1 << INTEL_OUTPUT_EDP);
> +		intel_output->clone_mask = (1 << INTEL_EDP_CLONE_BIT);
>  	} else
>  		intel_output->crtc_mask = (1 << 0) | (1 << 1);
>  	connector->interlace_allowed = true;
> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
> index 25aa6fa..26a6227 100644
> --- a/drivers/gpu/drm/i915/intel_drv.h
> +++ b/drivers/gpu/drm/i915/intel_drv.h
> @@ -74,6 +74,7 @@
>  #define INTEL_LVDS_CLONE_BIT 14
>  #define INTEL_DVO_TMDS_CLONE_BIT 15
>  #define INTEL_DVO_LVDS_CLONE_BIT 16
> +#define INTEL_EDP_CLONE_BIT 17
>  
>  #define INTEL_DVO_CHIP_NONE 0
>  #define INTEL_DVO_CHIP_LVDS 1
> diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> index 2fbe13a..5b1c9e9 100644
> --- a/drivers/gpu/drm/i915/intel_tv.c
> +++ b/drivers/gpu/drm/i915/intel_tv.c
> @@ -1730,6 +1730,7 @@ intel_tv_init(struct drm_device *dev)
>  	drm_mode_connector_attach_encoder(&intel_output->base, &intel_output->enc);
>  	tv_priv = (struct intel_tv_priv *)(intel_output + 1);
>  	intel_output->type = INTEL_OUTPUT_TVOUT;
> +	intel_output->crtc_mask = (1 << 0) | (1 << 1);
>  	intel_output->clone_mask = (1 << INTEL_TV_CLONE_BIT);
>  	intel_output->enc.possible_crtcs = ((1 << 0) | (1 << 1));
>  	intel_output->enc.possible_clones = (1 << INTEL_OUTPUT_TVOUT);
> -- 
> 1.6.3.3
> 
> -- 
> Open Source Technology Center, Intel ltd.
> 
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827


