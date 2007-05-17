Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbXEQXlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbXEQXlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbXEQXln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:41:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:27913 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbXEQXlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=V75RTJeFR+rpNNNvVvsb/bKCANm0+/8DZ0+m5mzI+ZVrZuvQaSLAOBBwOMXsTVx4lEURoY2gYFiArO/+ADepfB00f+2L58E/D8QOFl3zgAqLo3NXq3wR22TnJoMQcZVzi+XXd3sBGac82F51hB2hvwCNgWX9N+zY+hX2tZ9JTus=
Date: Fri, 18 May 2007 01:41:35 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/3] drm modesetting core
Message-ID: <20070517234135.GA18012@dreamland.darkstar.lan>
References: <200705171423.46748.jesse.barnes@intel.com> <200705171537.46639.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200705171537.46639.jesse.barnes@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Thu, May 17, 2007 at 03:37:45PM -0700, Jesse Barnes ha scritto: 
> This patch adds the core of the new DRM based modesetting system.

A couple of comments on drm_fb since I'm somewhat familiar with fb code:

> new file mode 100644
> index 0000000..0d06792
> --- /dev/null
> +++ b/linux-core/drm_edid.c
> @@ -0,0 +1,467 @@
> +/*
> + * Copyright (c) 2007 Intel Corporation
> + *   Jesse Barnes <jesse.barnes@intel.com>
> + *
> + * DDC probing routines (drm_ddc_read & drm_do_probe_ddc_edid) 
> originally from
> + * FB layer.

Hum, why are you duplicating them here? fbmon.c has the
infrastructure for parsing and even fixing known-broken EDIDs.

> + *   Copyright (C) 2006 Dennis Munsie <dmunsie@cecropia.com>
> + */
> +#include <linux/i2c.h>
> +#include <linux/i2c-algo-bit.h>
> +#include "drmP.h"
> +#include "drm_edid.h"
> +
> +/* Valid EDID header has these bytes */
> +static u8 edid_header[] = { 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
> 0x00 };
> +
> +/**
> + * edid_valid - sanity check EDID data
> + * @edid: EDID data
> + *
> + * Sanity check the EDID block by looking at the header, the version 
> number
> + * and the checksum.  Return 0 if the EDID doesn't check out, or 1 if 
> it's
> + * valid.
> + */
> +static bool edid_valid(struct edid *edid)
> +{
> +	int i;
> +	u8 csum = 0;
> +	u8 *raw_edid = (u8 *)edid;
> +
> +	if (memcmp(edid->header, edid_header, sizeof(edid_header)))
> +		goto bad;
> +	if (edid->version != 1)
> +		goto bad;
> +	if (edid->revision <= 0 || edid->revision > 3)
> +		goto bad;
> +
> +	for (i = 0; i < EDID_LENGTH; i++)
> +		csum += raw_edid[i];
> +	if (csum)
> +		goto bad;
> +
> +	return 1;
> +
> +bad:
> +	return 0;
> +}

This is basically edid_check_header + edid_checksum.

> +
> +/**
> + * drm_mode_std - convert standard mode info (width, height, refresh) 
> into mode
> + * @t: standard timing params
> + *
> + * Take the standard timing params (in this case width, aspect, and 
> refresh)
> + * and convert them into a real mode using CVT.
> + *
> + * Punts for now, but should eventually use the FB layer's CVT based 
> mode
> + * generation code.
> + */
> +struct drm_display_mode *drm_mode_std(struct drm_device *dev,
> +				      struct std_timing *t)
> +{

get_std_timing?

> +/**
> + * drm_mode_detailed - create a new mode from an EDID detailed timing 
> section
> + * @timing: EDID detailed timing info
> + * @preferred: is this a preferred mode?
> + *
> + * An EDID detailed timing block contains enough info for us to create 
> and
> + * return a new struct drm_display_mode.  The @preferred flag will be 
> set
> + * if this is the display's preferred timing, and we'll use it to 
> indicate
> + * to the other layers that this mode is desired.
> + */
> +struct drm_display_mode *drm_mode_detailed(drm_device_t *dev,
> +					   struct detailed_timing *timing)
> +{

get_detailed_timing?

If you  can't use 'struct fb_videomode' we may refactor code around a common
data structure instead of a copy&paste.

> +static unsigned char *drm_do_probe_ddc_edid(struct i2c_adapter 
> *adapter)
[...]
> +static unsigned char *drm_ddc_read(struct i2c_adapter *adapter)
[...]

Copy and paste from fb_dcc.c; furthermore a fix in drm_ddc_read hasn't
been backported to the original code.

> diff --git a/linux-core/drm_fb.c b/linux-core/drm_fb.c
> new file mode 100644
> index 0000000..ef05341
> --- /dev/null
> +++ b/linux-core/drm_fb.c
> @@ -0,0 +1,201 @@
> +/*
> + * Copyright © 2007 David Airlie
> + *
> + * Permission is hereby granted, free of charge, to any person 
> obtaining a
> + * copy of this software and associated documentation files 
> (the "Software"),
> + * to deal in the Software without restriction, including without 
> limitation
> + * the rights to use, copy, modify, merge, publish, distribute, 
> sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom 
> the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the 
> next
> + * paragraph) shall be included in all copies or substantial portions 
> of the
> + * Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
> EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
> MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT 
> SHALL
> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
> OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
> ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + *
> + * Authors:
> + *     David Airlie
> + */
> +    /*
> +     *  Modularization
> +     */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/mm.h>
> +#include <linux/tty.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/fb.h>
> +#include <linux/init.h>
> +
> +#include "drmP.h"
> +struct drmfb_par {
> +	struct drm_device *dev;
> +	struct drm_framebuffer *fb;
> +};
> +
> +static int drmfb_setcolreg(unsigned regno, unsigned red, unsigned 
> green,
> +			   unsigned blue, unsigned transp,
> +			   struct fb_info *info)
> +{
> +	struct drmfb_par *par = info->par;
> +	struct drm_framebuffer *fb = par->fb;
> +	if (regno > 17)
> +		return 1;
> +
> +	if (regno < 16) {
> +		switch (fb->depth) {
> +		case 15:
> +			fb->pseudo_palette[regno] = ((red & 0xf800) >>  1) |
> +				((green & 0xf800) >>  6) |
> +				((blue & 0xf800) >> 11);
> +			break;
> +		case 16:
> +			fb->pseudo_palette[regno] = (red & 0xf800) |
> +				((green & 0xfc00) >>  5) |
> +				((blue  & 0xf800) >> 11);
> +			break;
> +		case 24:
> +		case 32:
> +			fb->pseudo_palette[regno] = ((red & 0xff00) << 8) |
> +				(green & 0xff00) |
> +				((blue  & 0xff00) >> 8);
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/* this will let fbcon do the mode init */
> +static int drmfb_set_par(struct fb_info *info)
> +{
> +	struct drmfb_par *par = info->par;
> +	struct drm_device *dev = par->dev;
> +
> +	drm_set_desired_modes(dev);
> +	return 0;
> +}
> +
> +static struct fb_ops drmfb_ops = {
> +	.owner = THIS_MODULE,
> +	//	.fb_open = drmfb_open,
> +	//	.fb_read = drmfb_read,
> +	//	.fb_write = drmfb_write,
> +	//	.fb_release = drmfb_release,
> +	//	.fb_ioctl = drmfb_ioctl,
> +	.fb_set_par = drmfb_set_par,
> +	.fb_setcolreg = drmfb_setcolreg,
> +	.fb_fillrect = cfb_fillrect,
> +	.fb_copyarea = cfb_copyarea,
> +	.fb_imageblit = cfb_imageblit,
> +};
> +
> +int drmfb_probe(struct drm_device *dev, struct drm_framebuffer *fb)
> +{
> +	struct fb_info *info;
> +	struct drmfb_par *par;
> +	struct device *device = &dev->pdev->dev; 
> +	struct fb_var_screeninfo *var_info;
> +	unsigned long base, size;
> +	int ret;
> +
> +	info = framebuffer_alloc(sizeof(struct drmfb_par), device);
> +	if (!info){
> +		return -EINVAL;
> +	}

-ENOMEM? Plus, spurious brackets.

> +	if (register_framebuffer(info) < 0)
> +		return -EINVAL;

You leak the fb_info structure on error path.

> +
> +	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
> +	       info->fix.id);
> +	return 0;
> +}
> +EXPORT_SYMBOL(drmfb_probe);


Luca
-- 
Software is like sex; it's better when it's free.
Linus Torvalds
