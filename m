Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZKTQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZKTQrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZKTQrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:47:19 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43101 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZKTQrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RcjaYull9pjQsYaWwjRi/Ip3FVkunG8ejTcF84YdUsLVAFJz5BuDIpkIyYtByBoLc9
         NBIFUca43S6+DMZKV/nq49ph4XlNab9ZZoZByMYt/NwBDt59gNsWYQhgSR0Cqm/Qx7hS
         AYvha6s5ifdJ+DQ1eHC7HKJ17UojL6na99gCE=
MIME-Version: 1.0
In-Reply-To: <1258723764-4399-4-git-send-email-jglisse@redhat.com>
References: <1258723764-4399-1-git-send-email-jglisse@redhat.com>
	 <1258723764-4399-2-git-send-email-jglisse@redhat.com>
	 <1258723764-4399-3-git-send-email-jglisse@redhat.com>
	 <1258723764-4399-4-git-send-email-jglisse@redhat.com>
Date: Fri, 20 Nov 2009 11:47:22 -0500
Message-ID: <a728f9f90911200847g68311ddbx4a5fa652588504ab@mail.gmail.com>
Subject: Re: [PATCH 3/3] drm/radeon/kms: Add range pinning to crtc/cursor bo
From: Alex Deucher <alexdeucher@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 8:29 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> We force the crtc & cursor bo to be in the first 64M, this
> will help on legacy modesetting hw where the offset of
> scanout buffer and cursor are relative to a base address.

This limitation only applies to pre-avivo (r1xx-r4xx) chips, there's
no need on newer hardware.  Also the cursor and crtc have to be within
128 MB of each other, so you could bump the limits to 128 MB.  Another
thing to consider down the road might be to treat memory over 128 MB
as "invisible" on these pre-avivo chips (once we support that in
general) then we no longer need this limit.

Alex

>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/radeon/radeon.h             |    3 ++
>  drivers/gpu/drm/radeon/radeon_cursor.c      |    3 +-
>  drivers/gpu/drm/radeon/radeon_gem.c         |   15 +++++++++++
>  drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    6 ++++-
>  drivers/gpu/drm/radeon/radeon_object.c      |   35 +++++++++++++++++++++++++++
>  drivers/gpu/drm/radeon/radeon_object.h      |    2 +
>  6 files changed, 62 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 4b5d86b..5cb1b79 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -245,6 +245,9 @@ int radeon_gem_object_create(struct radeon_device *rdev, int size,
>                                struct drm_gem_object **obj);
>  int radeon_gem_object_pin(struct drm_gem_object *obj, uint32_t pin_domain,
>                          uint64_t *gpu_addr);
> +extern int radeon_gem_object_pin_range(struct drm_gem_object *obj,
> +                               uint32_t pin_domain, uint64_t *gpu_addr,
> +                               unsigned long start, unsigned long end);
>  void radeon_gem_object_unpin(struct drm_gem_object *obj);
>
>
> diff --git a/drivers/gpu/drm/radeon/radeon_cursor.c b/drivers/gpu/drm/radeon/radeon_cursor.c
> index 28772a3..205fca1 100644
> --- a/drivers/gpu/drm/radeon/radeon_cursor.c
> +++ b/drivers/gpu/drm/radeon/radeon_cursor.c
> @@ -156,7 +156,8 @@ int radeon_crtc_cursor_set(struct drm_crtc *crtc,
>                return -EINVAL;
>        }
>
> -       ret = radeon_gem_object_pin(obj, RADEON_GEM_DOMAIN_VRAM, &gpu_addr);
> +       ret = radeon_gem_object_pin_range(obj, RADEON_GEM_DOMAIN_VRAM,
> +                                       &gpu_addr, 0, 64 * 1024 * 1024);
>        if (ret)
>                goto fail;
>
> diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
> index f3fb2bf..7db8fcb 100644
> --- a/drivers/gpu/drm/radeon/radeon_gem.c
> +++ b/drivers/gpu/drm/radeon/radeon_gem.c
> @@ -92,6 +92,21 @@ int radeon_gem_object_pin(struct drm_gem_object *obj, uint32_t pin_domain,
>        return r;
>  }
>
> +int radeon_gem_object_pin_range(struct drm_gem_object *obj,
> +                               uint32_t pin_domain, uint64_t *gpu_addr,
> +                               unsigned long start, unsigned long end)
> +{
> +       struct radeon_bo *robj = obj->driver_private;
> +       int r;
> +
> +       r = radeon_bo_reserve(robj, false);
> +       if (unlikely(r != 0))
> +               return r;
> +       r = radeon_bo_pin_range(robj, pin_domain, gpu_addr, start, end);
> +       radeon_bo_unreserve(robj);
> +       return r;
> +}
> +
>  void radeon_gem_object_unpin(struct drm_gem_object *obj)
>  {
>        struct radeon_bo *robj = obj->driver_private;
> diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
> index e8a984d..3a2fb68 100644
> --- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
> +++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
> @@ -439,7 +439,11 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
>        r = radeon_bo_reserve(rbo, false);
>        if (unlikely(r != 0))
>                return r;
> -       r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &base);
> +       /* Pin buffer in the first 64M and always set crtc_base to start of
> +        * vram
> +        */
> +       r = radeon_bo_pin_range(rbo, RADEON_GEM_DOMAIN_VRAM, &base,
> +                               0, 64 * 1024 * 1024);
>        if (unlikely(r != 0)) {
>                radeon_bo_unreserve(rbo);
>                return -EINVAL;
> diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
> index bec4943..15399e6 100644
> --- a/drivers/gpu/drm/radeon/radeon_object.c
> +++ b/drivers/gpu/drm/radeon/radeon_object.c
> @@ -200,6 +200,41 @@ retry:
>        return r;
>  }
>
> +int radeon_bo_pin_range(struct radeon_bo *bo, u32 domain, u64 *gpu_addr,
> +                       unsigned long start, unsigned long end)
> +{
> +       u32 flags;
> +       u32 tmp;
> +       int r;
> +
> +       flags = radeon_ttm_flags_from_domain(domain);
> +       if (bo->pin_count) {
> +               bo->pin_count++;
> +               if (gpu_addr)
> +                       *gpu_addr = radeon_bo_gpu_offset(bo);
> +               return 0;
> +       }
> +       tmp = bo->tbo.mem.placement;
> +       ttm_flag_masked(&tmp, flags, TTM_PL_MASK_MEM);
> +       bo->tbo.proposed_placement = tmp | TTM_PL_FLAG_NO_EVICT |
> +                                       TTM_PL_MASK_CACHING;
> +retry:
> +       r = ttm_buffer_object_validate_range(&bo->tbo,
> +                                               bo->tbo.proposed_placement,
> +                                               start, end, true, false);
> +       if (likely(r == 0)) {
> +               bo->pin_count = 1;
> +               if (gpu_addr != NULL)
> +                       *gpu_addr = radeon_bo_gpu_offset(bo);
> +       }
> +       if (unlikely(r != 0)) {
> +               if (r == -ERESTART)
> +                       goto retry;
> +               dev_err(bo->rdev->dev, "%p pin failed\n", bo);
> +       }
> +       return r;
> +}
> +
>  int radeon_bo_unpin(struct radeon_bo *bo)
>  {
>        int r;
> diff --git a/drivers/gpu/drm/radeon/radeon_object.h b/drivers/gpu/drm/radeon/radeon_object.h
> index e9da130..a40bf67 100644
> --- a/drivers/gpu/drm/radeon/radeon_object.h
> +++ b/drivers/gpu/drm/radeon/radeon_object.h
> @@ -153,6 +153,8 @@ extern int radeon_bo_kmap(struct radeon_bo *bo, void **ptr);
>  extern void radeon_bo_kunmap(struct radeon_bo *bo);
>  extern void radeon_bo_unref(struct radeon_bo **bo);
>  extern int radeon_bo_pin(struct radeon_bo *bo, u32 domain, u64 *gpu_addr);
> +extern int radeon_bo_pin_range(struct radeon_bo *bo, u32 domain, u64 *gpu_addr,
> +                               unsigned long start, unsigned long end);
>  extern int radeon_bo_unpin(struct radeon_bo *bo);
>  extern int radeon_bo_evict_vram(struct radeon_device *rdev);
>  extern void radeon_bo_force_delete(struct radeon_device *rdev);
> --
> 1.6.5.2
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
