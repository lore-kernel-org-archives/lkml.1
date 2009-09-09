Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZIIWFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZIIWFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZIIWFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:05:34 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52204 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZIIWFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g5dGCtWzDOC0pmHaPyiwoVAFtV4PY2/d075YOO5L0LBJeWKZDsjV4Ays9nYIE2oHTT
         tQL3AGN6Ww/S2L2KlkyJAJHqvbFJCsdcg/9Y2Z125Z88LYsSLeIVX/layhM2QvV1RAMn
         7+JHoPqN67MpDyAUPVbXCtltrvKpGWMQOP5ps=
MIME-Version: 1.0
In-Reply-To: <1252527841-2317-1-git-send-email-jglisse@redhat.com>
References: <1252527841-2317-1-git-send-email-jglisse@redhat.com>
Date: Wed, 9 Sep 2009 18:05:35 -0400
Message-ID: <a728f9f90909091505o59377ae9x2d1f915c0fff62cc@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/kms: R3XX/R4XX AGP asic use PCI GART not PCIE 
	GART
From: Alex Deucher <alexdeucher@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 4:24 PM, Jerome Glisse<jglisse@redhat.com> wrote:
> R3XX/R4XX AGP asic use the old PCI GART block, not the new PCIE GART.
> Make sure we pick the right GART when disabling AGP.
>

Just to clarify which gart block is on what r3xx/r4xx asic; If the
card is chip family CHIP_R300, CHIP_R350, CHIP_RV350, or CHIP_R420, it
uses the AIC PCI gart.  If the chip family is CHIP_RV380, CHIP_R423,
or CHIP_RV410, then it uses PCIE gart.

Alex

> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/radeon/r300.c          |    6 ++++++
>  drivers/gpu/drm/radeon/r420.c          |    9 +++++++--
>  drivers/gpu/drm/radeon/radeon.h        |    4 ++++
>  drivers/gpu/drm/radeon/radeon_device.c |    5 +----
>  4 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
> index a5f82f7..9c17b78 100644
> --- a/drivers/gpu/drm/radeon/r300.c
> +++ b/drivers/gpu/drm/radeon/r300.c
> @@ -181,6 +181,12 @@ int r300_gart_enable(struct radeon_device *rdev)
>                rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
>                return rv370_pcie_gart_enable(rdev);
>        }
> +       if (rdev->flags & RADEON_IS_PCI) {
> +               rdev->asic->gart_disable = &r100_pci_gart_disable;
> +               rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
> +               rdev->asic->gart_set_page = &r100_pci_gart_set_page;
> +               return r100_pci_gart_enable(rdev);
> +       }
>        return r100_pci_gart_enable(rdev);
>  }
>
> diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
> index 97426a6..029cee2 100644
> --- a/drivers/gpu/drm/radeon/r420.c
> +++ b/drivers/gpu/drm/radeon/r420.c
> @@ -100,8 +100,13 @@ int r420_mc_init(struct radeon_device *rdev)
>
>  void r420_mc_fini(struct radeon_device *rdev)
>  {
> -       rv370_pcie_gart_disable(rdev);
> -       radeon_gart_table_vram_free(rdev);
> +       if (rdev->flags & RADEON_IS_PCIE) {
> +               rv370_pcie_gart_disable(rdev);
> +               radeon_gart_table_vram_free(rdev);
> +       } else {
> +               r100_pci_gart_disable(rdev);
> +               radeon_gart_table_ram_free(rdev);
> +       }
>        radeon_gart_fini(rdev);
>  }
>
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 24574bc..fe86b20 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -935,5 +935,9 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
>
>  /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
>  void r100_cp_disable(struct radeon_device *rdev);
> +void r100_pci_gart_disable(struct radeon_device *rdev);
> +int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
> +int r100_pci_gart_enable(struct radeon_device *rdev);
> +void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
>
>  #endif
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index f2469c5..da8646a 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -499,10 +499,7 @@ int radeon_device_init(struct radeon_device *rdev,
>
>        if (radeon_agpmode == -1) {
>                rdev->flags &= ~RADEON_IS_AGP;
> -               if (rdev->family > CHIP_RV515 ||
> -                   rdev->family == CHIP_RV380 ||
> -                   rdev->family == CHIP_RV410 ||
> -                   rdev->family == CHIP_R423) {
> +               if (rdev->family >= CHIP_RV515) {
>                        DRM_INFO("Forcing AGP to PCIE mode\n");
>                        rdev->flags |= RADEON_IS_PCIE;
>                } else {
> --
> 1.6.4.1
>
>
> ------------------------------------------------------------------------------
> Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day
> trial. Simplify your report design, integration and deployment - and focus on
> what you do best, core application coding. Discover what's new with
> Crystal Reports now.  http://p.sf.net/sfu/bobj-july
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
