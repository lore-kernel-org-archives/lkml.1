Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbZJFQJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbZJFQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbZJFQJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:09:28 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46739 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbZJFQJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fq8dxKxLmkg8AAp94QjOzRHoFNKAkg6guKlW+nAJcAwiBdHqJAvM1nYITzukE56KC7
         1Vco66b06FK+6uW7h3HYXPiU4ZrnDSKONIBBPM+XXxUtRphDaPAPuX9fBIPwQQ2R9SXE
         uQB3j/8ZMBBDJdNg/FDMbIbSrQWJXzkQ23gzE=
MIME-Version: 1.0
In-Reply-To: <1254842860-5492-1-git-send-email-jglisse@redhat.com>
References: <1254842860-5492-1-git-send-email-jglisse@redhat.com>
Date: Tue, 6 Oct 2009 12:08:50 -0400
Message-ID: <a728f9f90910060908i6c4cb7d9yd011722e0b216282@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/radeon/kms: Fallback to non AGP when acceleration 
	fails to initialize
From: Alex Deucher <alexdeucher@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 11:27 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> When GPU acceleration is not working with AGP try to fallback to non
> AGP GART (either PCI or PCIE GART). This should make KMS failure on
> AGP less painfull. We still need to find out what is wrong when AGP
> fails but at least user have a lot of more chances to get a working
> configuration with acceleration. This patch also cleanup R600/RV770
> fallback path so they use same code as others asics.
>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/radeon/r600.c          |   18 +-----------------
>  drivers/gpu/drm/radeon/radeon_device.c |   25 ++++++++++++++++++++++++-
>  drivers/gpu/drm/radeon/rv770.c         |   18 +-----------------
>  3 files changed, 26 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
> index 9f7eb08..2cef638 100644
> --- a/drivers/gpu/drm/radeon/r600.c
> +++ b/drivers/gpu/drm/radeon/r600.c
> @@ -1560,15 +1560,8 @@ int r600_init(struct radeon_device *rdev)
>        if (r)
>                return r;
>        r = r600_mc_init(rdev);
> -       if (r) {
> -               if (rdev->flags & RADEON_IS_AGP) {
> -                       /* Retry with disabling AGP */
> -                       r600_fini(rdev);
> -                       rdev->flags &= ~RADEON_IS_AGP;
> -                       return r600_init(rdev);
> -               }
> +       if (r)
>                return r;
> -       }
>        /* Memory manager */
>        r = radeon_object_init(rdev);
>        if (r)
> @@ -1597,15 +1590,8 @@ int r600_init(struct radeon_device *rdev)
>
>        r = r600_startup(rdev);
>        if (r) {
> -               if (rdev->flags & RADEON_IS_AGP) {
> -                       /* Retry with disabling AGP */
> -                       r600_fini(rdev);
> -                       rdev->flags &= ~RADEON_IS_AGP;
> -                       return r600_init(rdev);
> -               }
>                r600_suspend(rdev);
>                r600_wb_fini(rdev);
> -               radeon_ib_pool_fini(rdev);
>                radeon_ring_fini(rdev);
>                r600_pcie_gart_fini(rdev);
>                rdev->accel_working = false;
> @@ -1637,10 +1623,8 @@ void r600_fini(struct radeon_device *rdev)
>        radeon_gem_fini(rdev);
>        radeon_fence_driver_fini(rdev);
>        radeon_clocks_fini(rdev);
> -#if __OS_HAS_AGP
>        if (rdev->flags & RADEON_IS_AGP)
>                radeon_agp_fini(rdev);
> -#endif
>        radeon_object_fini(rdev);
>        radeon_atombios_fini(rdev);
>        kfree(rdev->bios);
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 2d07ccc..ec02006 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -565,8 +565,31 @@ int radeon_device_init(struct radeon_device *rdev,
>        DRM_INFO("register mmio size: %u\n", (unsigned)rdev->rmmio_size);
>
>        r = radeon_init(rdev);
> -       if (r) {
> +       if (r)
>                return r;
> +       if (rdev->flags & RADEON_IS_AGP && !rdev->accel_working) {
> +               /* Acceleration not working on AGP card try again
> +                * with fallback to PCI or PCIE GART
> +                */
> +               radeon_fini(rdev);
> +               rdev->flags &= ~RADEON_IS_AGP;
> +               if (rdev->family >= CHIP_RV515 ||
> +                       rdev->family == CHIP_RV380 ||
> +                       rdev->family == CHIP_RV410 ||
> +                       rdev->family == CHIP_R423) {
> +                       DRM_INFO("Forcing AGP to PCIE mode\n");
> +                       rdev->flags |= RADEON_IS_PCIE;
> +                       rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
> +                       rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
> +               } else {
> +                       DRM_INFO("Forcing AGP to PCI mode\n");
> +                       rdev->flags |= RADEON_IS_PCI;
> +                       rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
> +                       rdev->asic->gart_set_page = &r100_pci_gart_set_page;
> +               }

The above code is wrong for r6xx/r7xx.  should be:
		if (rdev->family >= CHIP_R600) {
                        DRM_INFO("Forcing AGP to PCIE mode\n");
                        rdev->flags |= RADEON_IS_PCIE;
                } else if (rdev->family >= CHIP_RV515 ||
                           rdev->family == CHIP_RV380 ||
                           rdev->family == CHIP_RV410 ||
	                   rdev->family == CHIP_R423) {
                        DRM_INFO("Forcing AGP to PCIE mode\n");
                        rdev->flags |= RADEON_IS_PCIE;
	                rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
                        rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
		} else {
                        DRM_INFO("Forcing AGP to PCI mode\n");
                        rdev->flags |= RADEON_IS_PCI;
                        rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
                        rdev->asic->gart_set_page = &r100_pci_gart_set_page;
                }

Otherwise you end up with rv370 pcie gart functions.

> +               r = radeon_init(rdev);
> +               if (r)
> +                       return r;
>        }
>        if (radeon_testing) {
>                radeon_test_moves(rdev);
> diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
> index 295cf14..5c597df 100644
> --- a/drivers/gpu/drm/radeon/rv770.c
> +++ b/drivers/gpu/drm/radeon/rv770.c
> @@ -923,15 +923,8 @@ int rv770_init(struct radeon_device *rdev)
>        if (r)
>                return r;
>        r = rv770_mc_init(rdev);
> -       if (r) {
> -               if (rdev->flags & RADEON_IS_AGP) {
> -                       /* Retry with disabling AGP */
> -                       rv770_fini(rdev);
> -                       rdev->flags &= ~RADEON_IS_AGP;
> -                       return rv770_init(rdev);
> -               }
> +       if (r)
>                return r;
> -       }
>        /* Memory manager */
>        r = radeon_object_init(rdev);
>        if (r)
> @@ -960,15 +953,8 @@ int rv770_init(struct radeon_device *rdev)
>
>        r = rv770_startup(rdev);
>        if (r) {
> -               if (rdev->flags & RADEON_IS_AGP) {
> -                       /* Retry with disabling AGP */
> -                       rv770_fini(rdev);
> -                       rdev->flags &= ~RADEON_IS_AGP;
> -                       return rv770_init(rdev);
> -               }
>                rv770_suspend(rdev);
>                r600_wb_fini(rdev);
> -               radeon_ib_pool_fini(rdev);
>                radeon_ring_fini(rdev);
>                rv770_pcie_gart_fini(rdev);
>                rdev->accel_working = false;
> @@ -999,10 +985,8 @@ void rv770_fini(struct radeon_device *rdev)
>        radeon_gem_fini(rdev);
>        radeon_fence_driver_fini(rdev);
>        radeon_clocks_fini(rdev);
> -#if __OS_HAS_AGP
>        if (rdev->flags & RADEON_IS_AGP)
>                radeon_agp_fini(rdev);
> -#endif
>        radeon_object_fini(rdev);
>        radeon_atombios_fini(rdev);
>        kfree(rdev->bios);
> --
> 1.6.4.4
>
>
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry&reg; Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay
> ahead of the curve. Join us from November 9&#45;12, 2009. Register now&#33;
> http://p.sf.net/sfu/devconf
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
