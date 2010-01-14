Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888Ab0ANCqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0ANCqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560Ab0ANCqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:46:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:45154 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0ANCqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:46:14 -0500
Subject: Re: drm/radeon/kms: fix up LVDS handling on macs (v2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>,
       Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
In-Reply-To: <201001140059.o0E0x4wS006650@hera.kernel.org>
References: <201001140059.o0E0x4wS006650@hera.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 13:45:42 +1100
Message-ID: <1263437142.724.320.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 00:59 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/3890ddf56dbc0f804953198e65a7e406ed654576
> Commit:     3890ddf56dbc0f804953198e65a7e406ed654576
> Parent:     804c7559e9376c3ba78ae15a30337b1e24f8ae80
> Author:     Alex Deucher <alexdeucher@gmail.com>
> AuthorDate: Tue Jan 12 11:16:57 2010 -0500
> Committer:  Dave Airlie <airlied@redhat.com>
> CommitDate: Wed Jan 13 13:25:08 2010 +1000
> 
>     drm/radeon/kms: fix up LVDS handling on macs (v2)
>     
>     Based on radeonfb code and recent ddx fix.
>     
>     v2: minor formatting fix from Michel Dänzer
>     
>     Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>     Reviewed-by: Michel Dänzer <michel@daenzer.net>
>     Tested-by: Michel Dänzer <michel@daenzer.net>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>

I have to dbl check that ... but I think the "Real" issue is that some
panel have inverted polarity on the PWM signal. Thus if BLON is turned
off the panels goes full backlight instead among other things :-)

However, not all macs are the same. If you look at the radeonfb code,
we do things differently depending on the mac model...

I don't know if there's a "proper" way to figure out how the panel is
really wired on these. Here, the ATI "mac" guys might be able to help
by telling us how the Mac driver figures it out :-)

Cheers,
Ben.

> ---
>  drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
> index 981508f..38e45e2 100644
> --- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
> +++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
> @@ -46,6 +46,7 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
>  	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
>  	uint32_t lvds_gen_cntl, lvds_pll_cntl, pixclks_cntl, disp_pwr_man;
>  	int panel_pwr_delay = 2000;
> +	bool is_mac = false;
>  	DRM_DEBUG("\n");
>  
>  	if (radeon_encoder->enc_priv) {
> @@ -58,6 +59,15 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
>  		}
>  	}
>  
> +	/* macs (and possibly some x86 oem systems?) wire up LVDS strangely
> +	 * Taken from radeonfb.
> +	 */
> +	if ((rdev->mode_info.connector_table == CT_IBOOK) ||
> +	    (rdev->mode_info.connector_table == CT_POWERBOOK_EXTERNAL) ||
> +	    (rdev->mode_info.connector_table == CT_POWERBOOK_INTERNAL) ||
> +	    (rdev->mode_info.connector_table == CT_POWERBOOK_VGA))
> +		is_mac = true;
> +
>  	switch (mode) {
>  	case DRM_MODE_DPMS_ON:
>  		disp_pwr_man = RREG32(RADEON_DISP_PWR_MAN);
> @@ -74,6 +84,8 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
>  
>  		lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
>  		lvds_gen_cntl |= (RADEON_LVDS_ON | RADEON_LVDS_EN | RADEON_LVDS_DIGON | RADEON_LVDS_BLON);
> +		if (is_mac)
> +			lvds_gen_cntl |= RADEON_LVDS_BL_MOD_EN;
>  		lvds_gen_cntl &= ~(RADEON_LVDS_DISPLAY_DIS);
>  		udelay(panel_pwr_delay * 1000);
>  		WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
> @@ -85,7 +97,14 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
>  		WREG32_PLL_P(RADEON_PIXCLKS_CNTL, 0, ~RADEON_PIXCLK_LVDS_ALWAYS_ONb);
>  		lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
>  		lvds_gen_cntl |= RADEON_LVDS_DISPLAY_DIS;
> -		lvds_gen_cntl &= ~(RADEON_LVDS_ON | RADEON_LVDS_BLON | RADEON_LVDS_EN | RADEON_LVDS_DIGON);
> +		if (is_mac) {
> +			lvds_gen_cntl &= ~RADEON_LVDS_BL_MOD_EN;
> +			WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
> +			lvds_gen_cntl &= ~(RADEON_LVDS_ON | RADEON_LVDS_EN);
> +		} else {
> +			WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
> +			lvds_gen_cntl &= ~(RADEON_LVDS_ON | RADEON_LVDS_BLON | RADEON_LVDS_EN | RADEON_LVDS_DIGON);
> +		}
>  		udelay(panel_pwr_delay * 1000);
>  		WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
>  		WREG32_PLL(RADEON_PIXCLKS_CNTL, pixclks_cntl);
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


