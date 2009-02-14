Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZBNKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZBNKK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 05:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZBNKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 05:10:15 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:39349 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750898AbZBNKKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 05:10:14 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 05:10:13 EST
Subject: Re: [PATCH]: drm: radeon: Use surface for PCI GART table.
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090214.015107.127190039.davem@davemloft.net>
References: <20090214.015107.127190039.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 14 Feb 2009 10:59:59 +0100
Message-Id: <1234605599.4823.177.camel@thor>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 01:51 -0800, David Miller wrote:
> This allocates a physical surface for the PCI GART table, this way no
> matter what other surface configurations exist the GART table will
> always be seen by the hardware properly.

BTW, I don't think the swapping settings affect GPU access to the table,
only CPU access, but this is a good solution anyway.

> We encode the file pointer of the virtual surface allocate using a
> special cookie value, called PCIGART_FILE_PRIV.  On the last close, we
> release that surface.
> 
> Just to be doubly safe, we run the pcigart table setup with the main
> surface control register clear.
> 
> Based upon ideas from David Airlie and Ben Benjamin Herrenschmidt.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

This is only really necessary on big endian, but other than that:

Acked-By: Michel Dänzer <daenzer@vmware.com>


> diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
> index e235778..119e642 100644
> --- a/drivers/gpu/drm/radeon/radeon_cp.c
> +++ b/drivers/gpu/drm/radeon/radeon_cp.c
> @@ -909,6 +909,46 @@ static void radeon_set_pcigart(drm_radeon_private_t * dev_priv, int on)
>  	}
>  }
>  
> +static int radeon_setup_pcigart_surface(drm_radeon_private_t *dev_priv)
> +{
> +	struct drm_ati_pcigart_info *gart_info = &dev_priv->gart_info;
> +	struct radeon_virt_surface *vp;
> +	int i;
> +
> +	for (i = 0; i < RADEON_MAX_SURFACES * 2; i++) {
> +		if (!dev_priv->virt_surfaces[i].file_priv ||
> +		    dev_priv->virt_surfaces[i].file_priv == PCIGART_FILE_PRIV)
> +			break;
> +	}
> +	if (i >= 2 * RADEON_MAX_SURFACES)
> +		return -ENOMEM;
> +	vp = &dev_priv->virt_surfaces[i];
> +
> +	for (i = 0; i < RADEON_MAX_SURFACES; i++) {
> +		struct radeon_surface *sp = &dev_priv->surfaces[i];
> +		if (sp->refcount)
> +			continue;
> +
> +		vp->surface_index = i;
> +		vp->lower = gart_info->bus_addr;
> +		vp->upper = vp->lower + gart_info->table_size;
> +		vp->flags = 0;
> +		vp->file_priv = PCIGART_FILE_PRIV;
> +
> +		sp->refcount = 1;
> +		sp->lower = vp->lower;
> +		sp->upper = vp->upper;
> +		sp->flags = 0;
> +
> +		RADEON_WRITE(RADEON_SURFACE0_INFO + 16 * i, sp->flags);
> +		RADEON_WRITE(RADEON_SURFACE0_LOWER_BOUND + 16 * i, sp->lower);
> +		RADEON_WRITE(RADEON_SURFACE0_UPPER_BOUND + 16 * i, sp->upper);
> +		return 0;
> +	}
> +
> +	return -ENOMEM;
> +}
> +
>  static int radeon_do_init_cp(struct drm_device *dev, drm_radeon_init_t *init,
>  			     struct drm_file *file_priv)
>  {
> @@ -1202,6 +1242,9 @@ static int radeon_do_init_cp(struct drm_device *dev, drm_radeon_init_t *init,
>  	} else
>  #endif
>  	{
> +		u32 sctrl;
> +		int ret;
> +
>  		dev_priv->gart_info.table_mask = DMA_BIT_MASK(32);
>  		/* if we have an offset set from userspace */
>  		if (dev_priv->pcigart_offset_set) {
> @@ -1243,12 +1286,25 @@ static int radeon_do_init_cp(struct drm_device *dev, drm_radeon_init_t *init,
>  			}
>  		}
>  
> -		if (!drm_ati_pcigart_init(dev, &dev_priv->gart_info)) {
> +		sctrl = RADEON_READ(RADEON_SURFACE_CNTL);
> +		RADEON_WRITE(RADEON_SURFACE_CNTL, 0);
> +		ret = drm_ati_pcigart_init(dev, &dev_priv->gart_info);
> +		RADEON_WRITE(RADEON_SURFACE_CNTL, sctrl);
> +
> +		if (!ret) {
>  			DRM_ERROR("failed to init PCI GART!\n");
>  			radeon_do_cleanup_cp(dev);
>  			return -ENOMEM;
>  		}
>  
> +		ret = radeon_setup_pcigart_surface(dev_priv);
> +		if (ret) {
> +			DRM_ERROR("failed to setup GART surface!\n");
> +			drm_ati_pcigart_cleanup(dev, &dev_priv->gart_info);
> +			radeon_do_cleanup_cp(dev);
> +			return ret;
> +		}
> +
>  		/* Turn on PCI GART */
>  		radeon_set_pcigart(dev_priv, 1);
>  	}
> diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
> index 9b60a26..ecfd414 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.h
> +++ b/drivers/gpu/drm/radeon/radeon_drv.h
> @@ -217,6 +217,7 @@ struct radeon_virt_surface {
>  	u32 upper;
>  	u32 flags;
>  	struct drm_file *file_priv;
> +#define PCIGART_FILE_PRIV	((void *) -1L)
>  };
>  
>  #define RADEON_FLUSH_EMITED	(1 << 0)
> diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
> index 03fea43..043293a 100644
> --- a/drivers/gpu/drm/radeon/radeon_state.c
> +++ b/drivers/gpu/drm/radeon/radeon_state.c
> @@ -3155,6 +3155,7 @@ void radeon_driver_preclose(struct drm_device *dev, struct drm_file *file_priv)
>  
>  void radeon_driver_lastclose(struct drm_device *dev)
>  {
> +	radeon_surfaces_release(PCIGART_FILE_PRIV, dev->dev_private);
>  	radeon_do_release(dev);
>  }
>  
> 
> ------------------------------------------------------------------------------
> Open Source Business Conference (OSBC), March 24-25, 2009, San Francisco, CA
> -OSBC tackles the biggest issue in open source: Open Sourcing the Enterprise
> -Strategies to boost innovation and cut costs with open source participation
> -Receive a $600 discount off the registration fee with the source code: SFAD
> http://p.sf.net/sfu/XcvMzF8H
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
