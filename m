Return-Path: <linux-kernel-owner+w=401wt.eu-S967008AbXEGVke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967008AbXEGVke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967003AbXEGVk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:40:29 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:1773 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967001AbXEGVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pn+/yUyUAvpNR/bRixYJWNMK5EsuZjv4rkQ01wvNyLInENyrPXsxwKCFASLCYksnY+DzIpaGIKaPsipsGWEE8c7i0EDBt/QkPlqpbayhPMe06rtEOO7iY2SrLyt39oORSGV9oU+vYT/OtnRyha+WtCF7HWE0iv58L82jNTbhx1g=
Subject: Re: [Linux-fbdev-devel] [PATCH] atmel_lcdfb: AT91/AT32 LCD
	Controller framebuffer driver
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
In-Reply-To: <463F3388.7020102@rfo.atmel.com>
References: <463F3388.7020102@rfo.atmel.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 05:40:17 +0800
Message-Id: <1178574017.4674.30.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 16:11 +0200, Nicolas Ferre wrote:
> From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> 
> Adds a framebuffer driver to ATMEL AT91SAM9x and AT32 
> aka AVR32 platforms. Those chips share quite the same
> IP and this code is suitable for both architectures.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> ---
> 
> +#if defined(CONFIG_ARCH_AT91)
> +#define	ATMEL_LCDFB_FBINFO_DEFAULT	FBINFO_DEFAULT
> +
> +static inline void atmel_lcdfb_update_dma2d(struct atmel_lcdfb_info *sinfo,
> +					struct fb_var_screeninfo *var)
> +{
> +
> +}

Or

#define atmel_lcdfb_update(...) do {} while (0)

?


> +
> +static struct fb_fix_screeninfo atmel_lcdfb_fix __initdata = {
> +	.type		= FB_TYPE_PACKED_PIXELS,
> +	.visual		= FB_VISUAL_TRUECOLOR,
> +	.xpanstep	= 0,
> +	.ypanstep	= 0,
> +	.ywrapstep	= 0,
> +	.accel		= FB_ACCEL_NONE,
> +};
> +

This driver has fb_pan_display() which I assume works. However, you also
need to set ypanstep and/or xpanstep and/or ywrapstep to a nonzero
value, depending on the hardware/drive capability.

> +static u32 pseudo_palette[16] = {
> +	0x000000,
> +	0xaa0000,
> +	0x00aa00,
> +	0xaa5500,
> +	0x0000aa,
> +	0xaa00aa,
> +	0x00aaaa,
> +	0xaaaaaa,
> +	0x555555,
> +	0xff5555,
> +	0x55ff55,
> +	0xffff55,
> +	0x5555ff,
> +	0xff55ff,
> +	0x55ffff,
> +	0xffffff
> +};
> +

Do you really need to pre-fill pseudo_palette[]? The contents are going
to be overwritten by the console anyway (The pseudo_palette is for
fbcon's use only).

You can also include pseudo_palette[] as part of struct
atmel_lcdfb_info, then in your probe routine:

info->pseudo_palette = par->pseudo_palette;

to reduce the size of the kernel image. 


> +
> +static inline u_int chan_to_field(u_int chan, const struct fb_bitfield *bf)

Might as well change u_int to u32 or unsigned int, for consistency.

> +{
> +	chan &= 0xffff;
> +	chan >>= 16 - bf->length;
> +	return chan << bf->offset;
> +}
> +
> +
> +
> +
> +static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
> +{
> +	struct fb_info *info = sinfo->info;
> +	int ret = 0;
> +
> +	memset(info->screen_base, 0, info->fix.smem_len);

memset_io?

> +	info->var.activate |= FB_ACTIVATE_FORCE | FB_ACTIVATE_NOW;
> +
> +	dev_info(info->device,
> +	       "%luKiB frame buffer at %08lx (mapped at %p)\n",
> +	       (unsigned long)info->fix.smem_len / 1024,
> +	       (unsigned long)info->fix.smem_start,
> +	       info->screen_base);
> +
> +	/* Allocate colormap */
> +	ret = fb_alloc_cmap(&info->cmap, 256, 0);
> +	if (ret < 0)
> +		dev_err(info->device, "Alloc color map failed\n");
> +
> +	return ret;
> +}
> +

> +
> +
> +static int __init atmel_lcdfb_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct fb_info *info;
> +	struct atmel_lcdfb_info *sinfo;
> +	struct atmel_lcdfb_info *pdata_sinfo;
> +	struct resource *regs = NULL;
> +	struct resource *map = NULL;
> +	int ret;
> +
> +	dev_dbg(dev, "%s BEGIN\n", __func__);
> +
> +	ret = -ENOMEM;
> +	info = framebuffer_alloc(sizeof(struct atmel_lcdfb_info), dev);
> +	if (!info) {
> +		dev_err(dev, "cannot allocate memory\n");
> +		goto out;
> +	}
> +
> +	sinfo = info->par;
> +
> +	if (dev->platform_data) {
> +		pdata_sinfo = (struct atmel_lcdfb_info *)dev->platform_data;
> +		sinfo->default_bpp = pdata_sinfo->default_bpp;
> +		sinfo->default_dmacon = pdata_sinfo->default_dmacon;
> +		sinfo->default_lcdcon2 = pdata_sinfo->default_lcdcon2;
> +		sinfo->default_monspecs = pdata_sinfo->default_monspecs;
> +		sinfo->atmel_lcdfb_power_control = pdata_sinfo->atmel_lcdfb_power_control;
> +		sinfo->guard_time = pdata_sinfo->guard_time;
> +	} else {
> +		dev_err(dev, "cannot get default configuration\n");
> +		goto out;

Wrong goto? Should be goto free_info?


> +
> +free_cmap:
> +	fb_dealloc_cmap(&info->cmap);
> +unregister_irqs:
> +	free_irq(sinfo->irq_base, info);
> +unmap_mmio:
> +	iounmap(sinfo->mmio);
> +release_mem:
> + 	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
> +free_fb:
> +	if (map) {
> +		iounmap(info->screen_base);
> +	} else {
> +		atmel_lcdfb_free_video_memory(sinfo);
> +	}
> +
> +release_intmem:
> +	if (map) {
> +		release_mem_region(info->fix.smem_start, info->fix.smem_len);
> +	}

Unnecessary curly braces

> +
> +static struct platform_driver atmel_lcdfb_driver = {
> +	.remove		= __exit_p(atmel_lcdfb_remove),
> +	.driver		= {
> +		.name	= "atmel_lcdfb",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init atmel_lcdfb_init(void)
> +{
> +	return platform_driver_probe(&atmel_lcdfb_driver, atmel_lcdfb_probe);
> +}

Is this intentional?  Why not platform_driver_register()?

> +
> +static void __exit atmel_lcdfb_exit(void)
> +{
> +	platform_driver_unregister(&atmel_lcdfb_driver);
> +}
> +

Tony

