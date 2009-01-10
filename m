Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbZAJCEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbZAJCEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 21:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbZAJCEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 21:04:24 -0500
Received: from rn-out-0910.google.com ([64.233.170.190]:30593 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZAJCEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 21:04:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S4xJK7PV3HubPYfioKyksWpzUFfZvreHbPXvuSl3L39fUACzP598wQ9U3KtxwXdiqi
         McSJLExY7gYaDMLpf57Cj0Ky+OfIv1VbhZehA+5j7i5sVa8QpklrTgMliLoBIfVNdlK8
         dVFfQghoWFGJ0lr4hG5e8UrfeLoMEH0tUA36M=
Message-ID: <21d7e9970901091804x61e2ba3cofd37d536df2d48b3@mail.gmail.com>
Date: Sat, 10 Jan 2009 12:04:22 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Richard Purdie" <rpurdie@linux.intel.com>
Subject: Re: [git pull] drm
Cc: "Dave Airlie" <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1231550011.5317.72.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	 <1231513655.5317.30.camel@dax.rpnet.com>
	 <1231524232.5317.43.camel@dax.rpnet.com>
	 <1231550011.5317.72.camel@dax.rpnet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 11:13 AM, Richard Purdie
<rpurdie@linux.intel.com> wrote:
> On Fri, 2009-01-09 at 18:03 +0000, Richard Purdie wrote:
>> On Fri, 2009-01-09 at 15:07 +0000, Richard Purdie wrote:
>> > I just updated to the latest kernel from git to test some other patches
>> > and after logging into GDM the X server hangs before launching the
>> > desktop (it appears to be trying to run glxinfo) on my Thinkpad T61
>> > (i915 graphics). Bisection shows this happens after applying this
>> > commit:
>> >
>> > On Mon, 2008-12-29 at 08:32 +0000, Dave Airlie wrote:
>> > > commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
>> > > Author: Dave Airlie <airlied@redhat.com>
>> > > Date:   Fri Nov 28 14:22:24 2008 +1000
>
> The patch below gets my system working again with the latest kernels.
> Was dropping the drm_addmap() call for i915 intentional or not?

Yes, so now we need to find out what happens in your userspace, when
it hangs is the machine dead?

or can you ssh in? any oops in the logs? can you get a sysrq-t
backtrace for X.org and glxinfo?

Dave.
>
>
> drm: Fix userspace X lockups introduced in 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
>
> Add back the drm_addmap() call that was dropped as part of commit
> 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a for the i915 driver, fixing X
> userspace lockups.
>
> Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
>
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 62a4bf7..db61d89 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -29,6 +29,7 @@
>  #include "drmP.h"
>  #include "drm.h"
>  #include "drm_crtc_helper.h"
> +#include "drm_sarea.h"
>  #include "intel_drv.h"
>  #include "i915_drm.h"
>  #include "i915_drv.h"
> @@ -1007,11 +1008,24 @@ out:
>  int i915_master_create(struct drm_device *dev, struct drm_master *master)
>  {
>        struct drm_i915_master_private *master_priv;
> +       unsigned long sareapage;
> +       int ret;
>
>        master_priv = drm_calloc(1, sizeof(*master_priv), DRM_MEM_DRIVER);
>        if (!master_priv)
>                return -ENOMEM;
>
> +       /* prebuild the SAREA */
> +       sareapage = max(SAREA_MAX, PAGE_SIZE);
> +       ret = drm_addmap(dev, 0, sareapage, _DRM_SHM, _DRM_CONTAINS_LOCK|_DRM_DRIVER,
> +                        &master_priv->sarea);
> +       if (ret) {
> +               DRM_ERROR("SAREA setup failed\n");
> +               return ret;
> +       }
> +
> +       master_priv->sarea_priv = master_priv->sarea->handle + sizeof(struct drm_sarea);
> +
>        master->driver_priv = master_priv;
>        return 0;
>  }
> @@ -1023,6 +1037,9 @@ void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
>        if (!master_priv)
>                return;
>
> +       if (master_priv->sarea)
> +               drm_rmmap(dev, master_priv->sarea);
> +
>        drm_free(master_priv, sizeof(*master_priv), DRM_MEM_DRIVER);
>
>        master->driver_priv = NULL;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
