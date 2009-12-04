Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZLDAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZLDAKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZLDAKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:10:18 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50042 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZLDAKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SmMmIWWcXP501ZLbRNMKe9b/8ey0oDzksqy/moxgJjKjwW5wTHlo5I+V66YYih/nRE
         HtdIQWMnLocAFmUNMZoQtEcyNhGEE5zGdS6h9m2NyyVBiKidW5Aj4tMmvOlKbupazFAN
         xBlNQP/FXCz8Bxq2HAPTM4RvR/oGgxZknVKZQ=
MIME-Version: 1.0
In-Reply-To: <1258723764-4399-3-git-send-email-jglisse@redhat.com>
References: <1258723764-4399-1-git-send-email-jglisse@redhat.com>
	 <1258723764-4399-2-git-send-email-jglisse@redhat.com>
	 <1258723764-4399-3-git-send-email-jglisse@redhat.com>
Date: Fri, 4 Dec 2009 10:10:23 +1000
Message-ID: <21d7e9970912031610s26055089o30a4c2824f50dbf3@mail.gmail.com>
Subject: Re: [PATCH 2/3] drm/radeon/kms: Rework radeon object handling
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:29 PM, Jerome Glisse <jglisse@redhat.com> wrote:
> The locking & protection of radeon object was somewhat messy.
> This patch completely rework it to now use ttm reserve as a
> protection for the radeon object structure member. It also
> shrink down the various radeon object structure by removing
> field which were redondant with the ttm information. Last it
> converts few simple functions to inline which should with
> performances.
>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>



>
>  int radeon_gem_busy_ioctl(struct drm_device *dev, void *data,
> @@ -264,7 +261,7 @@ int radeon_gem_busy_ioctl(struct drm_device *dev, void *data,
>  {
>        struct drm_radeon_gem_busy *args = data;
>        struct drm_gem_object *gobj;
> -       struct radeon_object *robj;
> +       struct radeon_bo *robj;
>        int r;
>        uint32_t cur_placement;
>
> @@ -273,7 +270,7 @@ int radeon_gem_busy_ioctl(struct drm_device *dev, void *data,
>                return -EINVAL;
>        }
>        robj = gobj->driver_private;
> -       r = radeon_object_busy_domain(robj, &cur_placement);
> +       r = radeon_bo_wait(robj, &cur_placement, true);

Here we pass an uninitialised cur_placement to busy ioctl.

> +static inline int radeon_bo_wait(struct radeon_bo *bo, u32 *mem_type,
> +                                       bool no_wait)
> +{
> +       int r;
> +
> +retry:
> +       r = ttm_bo_reserve(&bo->tbo, true, no_wait, false, 0);
> +       if (unlikely(r != 0)) {
> +               if (r == -ERESTART)
> +                       goto retry;
> +               dev_err(bo->rdev->dev, "%p reserve failed for wait\n", bo);
> +               return r;
> +       }
> +       spin_lock(&bo->tbo.lock);
> +       if (mem_type)
> +               *mem_type = bo->tbo.mem.mem_type;
> +       if (bo->tbo.sync_obj)
> +               r = ttm_bo_wait(&bo->tbo, true, true, no_wait);
> +       spin_unlock(&bo->tbo.lock);
> +       ttm_bo_unreserve(&bo->tbo);
> +       if (unlikely(r == -ERESTART))
> +               goto retry;
> +       return r;
> +}

If this return early mem_type never gets set to anything useful.

The compiler warns on this here.

Can you send a fix up patch as I've merged this to drm-radeon-next already.

Dave.
