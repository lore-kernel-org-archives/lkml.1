Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZLUQN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZLUQN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbZLUQN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:13:58 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:45527 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbZLUQN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n67W/YgNaYRvQg69J4RjxS0GAF1mJTDkg9EnuTVo9zdiSHQ3w65PQNQOEHfGEQpAqB
         jOGzqpQjs072sOa56Ij8Hs77VFmrolJhLfSlyOOS62evXTTIaOqVJeZY5VdRtk2/Avs5
         jQ0cbedVZW3sZSEFMCkGwWgBStbdIP/GnR6DA=
MIME-Version: 1.0
In-Reply-To: <200912201723.10385.johannes.hirte@fem.tu-ilmenau.de>
References: <200912201723.10385.johannes.hirte@fem.tu-ilmenau.de>
Date: Mon, 21 Dec 2009 11:13:55 -0500
Message-ID: <a728f9f90912210813v66cc8badkf7863e38bc619685@mail.gmail.com>
Subject: Re: [stable] Regression in 2.6.32.2: radeon KMS hangs system
From: Alex Deucher <alexdeucher@gmail.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 11:23 AM, Johannes Hirte
<johannes.hirte@fem.tu-ilmenau.de> wrote:
> With 2.6.32.2 the system hangs completely with black screen when modprobing
> radeon with modeset=1. I was able to connect via ssh, but after entering the
> password nothing happend. I didn't got a prompt. Only SysRq worked. I've
> tracked it down to the following patch:
>

Fixed here:
http://marc.info/?l=dri-devel&m=126137027403059&w=2

2.6.32 didn't have irq support for r6xx+.

Alex

> >From 500b758725314ab1b5316eb0caa5b0fa26740e6b Mon Sep 17 00:00:00 2001
> From: Alex Deucher <alexdeucher@gmail.com>
> Date: Wed, 2 Dec 2009 11:46:52 -0500
> Subject: drm/radeon/kms: handle vblanks properly with dpms on
>
> From: Alex Deucher <alexdeucher@gmail.com>
>
> commit 500b758725314ab1b5316eb0caa5b0fa26740e6b upstream.
>
> avivo chips
>
> Copied from pre-avivo code.
>
> Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/gpu/drm/radeon/atombios_crtc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
> @@ -241,6 +241,7 @@ void atombios_crtc_dpms(struct drm_crtc
>  {
>        struct drm_device *dev = crtc->dev;
>        struct radeon_device *rdev = dev->dev_private;
> +       struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
>
>        switch (mode) {
>        case DRM_MODE_DPMS_ON:
> @@ -248,20 +249,19 @@ void atombios_crtc_dpms(struct drm_crtc
>                if (ASIC_IS_DCE3(rdev))
>                        atombios_enable_crtc_memreq(crtc, 1);
>                atombios_blank_crtc(crtc, 0);
> +               drm_vblank_post_modeset(dev, radeon_crtc->crtc_id);
> +               radeon_crtc_load_lut(crtc);
>                break;
>        case DRM_MODE_DPMS_STANDBY:
>        case DRM_MODE_DPMS_SUSPEND:
>        case DRM_MODE_DPMS_OFF:
> +               drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
>                atombios_blank_crtc(crtc, 1);
>                if (ASIC_IS_DCE3(rdev))
>                        atombios_enable_crtc_memreq(crtc, 0);
>                atombios_enable_crtc(crtc, 0);
>                break;
>        }
> -
> -       if (mode != DRM_MODE_DPMS_OFF) {
> -               radeon_crtc_load_lut(crtc);
> -       }
>  }
>
>  static void
>
>
> After reverting this patch, modesetting works again. It's a Radeon HD3650 AGP
> (RV635) on a Tyan Tiger K8W S2875ANRF (AMD 8151 AGP tunnel). Display is an
> Acer X223W connected on DVI.
>
>
> regards,
>  Johannes
>
> ------------------------------------------------------------------------------
> This SF.Net email is sponsored by the Verizon Developer Community
> Take advantage of Verizon's best-in-class app development support
> A streamlined, 14 day to market process makes app distribution fast and easy
> Join now and get one step closer to millions of Verizon customers
> http://p.sf.net/sfu/verizon-dev2dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
