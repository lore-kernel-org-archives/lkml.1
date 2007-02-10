Return-Path: <linux-kernel-owner+w=401wt.eu-S1946773AbXBJAeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946773AbXBJAeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946774AbXBJAeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:34:24 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:35582 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946773AbXBJAeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:34:23 -0500
Message-ID: <45CD12F6.9050306@gmail.com>
Date: Sat, 10 Feb 2007 01:33:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge, updated
References: <20070209193405.GB2637@localhost.localdomain>
In-Reply-To: <20070209193405.GB2637@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zajicek napsal(a):
> This patch adds driver for S3 Trio / S3 Virge. Driver is tested
> with most versions of S3 Trio and S3 Virge, on i386.
> It is tested both as compiled-in and module. It is against
> linux-2.6.20 .
> 
> This is version 3. There are some minor modifications from version 2
> (mostly coding style cleanups).
> 
> 
> Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
> 
> ---
> 
[...]
> +/* PCI probe */
> +
> +static int __devinit s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> +{
> +	struct fb_info *info;
> +	struct s3fb_info *par;
> +	int rc;
> +	u8 regval, cr38, cr39;
> +
> +	/* Ignore secondary VGA device because there is no VGA arbitration */
> +	if (! svga_primary_device(dev)) {
> +		dev_info(&(dev->dev), "ignoring secondary device\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Allocate and fill driver data structure */
> +	info = framebuffer_alloc(sizeof(struct s3fb_info), NULL);
> +	if (!info) {
> +		dev_err(&(dev->dev), "cannot allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	par = info->par;
> +	mutex_init(&par->open_lock);
> +
> +	info->flags = FBINFO_PARTIAL_PAN_OK | FBINFO_HWACCEL_YPAN;
> +	info->fbops = &s3fb_ops;
> +
> +	/* Prepare PCI device */
> +	rc = pci_enable_device(dev);
> +	if (rc < 0) {
> +		dev_err(&(dev->dev), "cannot enable PCI device\n");
> +		goto err_enable_device;
> +	}
> +
> +	rc = pci_request_regions(dev, "s3fb");
> +	if (rc < 0) {
> +		dev_err(&(dev->dev), "cannot reserve framebuffer region\n");
> +		goto err_request_regions;
> +	}
> +
> +
> +	info->fix.smem_start = pci_resource_start(dev, 0);
> +	info->fix.smem_len = pci_resource_len(dev, 0);
> +
> +	/* Map physical IO memory address into kernel space */
> +	info->screen_base = pci_iomap(dev, 0, 0);
> +	if (! info->screen_base) {
> +		rc = -ENOMEM;
> +		dev_err(&(dev->dev), "iomap for framebuffer failed\n");
> +		goto err_iomap;
> +	}
> +
> +	/* Unlock regs */
> +	cr38 = vga_rcrt(NULL, 0x38);
> +	cr39 = vga_rcrt(NULL, 0x39);
> +	vga_wseq(NULL, 0x08, 0x06);
> +	vga_wcrt(NULL, 0x38, 0x48);
> +	vga_wcrt(NULL, 0x39, 0xA5);
> +
> +	/* Find how many physical memory there is on card */
> +	/* 0x36 register is accessible even if other registers are locked */
> +	regval = vga_rcrt(NULL, 0x36);
> +	info->screen_size = s3_memsizes[regval >> 5] << 10;
> +	info->fix.smem_len = info->screen_size;
> +
> +	par->chip = id->driver_data & CHIP_MASK;
> +	par->rev = vga_rcrt(NULL, 0x2f);
> +	if (par->chip & CHIP_UNDECIDED_FLAG)
> +		par->chip = s3_identification(par->chip);
> +
> +	/* Find MCLK frequency */
> +	regval = vga_rseq(NULL, 0x10);
> +	par->mclk_freq = ((vga_rseq(NULL, 0x11) + 2) * 14318) / ((regval & 0x1F)  + 2);
> +	par->mclk_freq = par->mclk_freq >> (regval >> 5);
> +
> +	/* Restore locks */
> +	vga_wcrt(NULL, 0x38, cr38);
> +	vga_wcrt(NULL, 0x39, cr39);
> +
> +	strcpy(info->fix.id, s3_names [par->chip]);
> +	info->fix.mmio_start = 0;
> +	info->fix.mmio_len = 0;
> +	info->fix.type = FB_TYPE_PACKED_PIXELS;
> +	info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
> +	info->fix.ypanstep = 0;
> +	info->fix.accel = FB_ACCEL_NONE;
> +	info->pseudo_palette = (void*) (par->pseudo_palette);
> +
> +	/* Prepare startup mode */
> +	rc = fb_find_mode(&(info->var), info, mode, NULL, 0, NULL, 8);
> +	if (! ((rc == 1) || (rc == 2))) {
> +		rc = -EINVAL;
> +		dev_err(&(dev->dev), "mode %s not found\n", mode);
> +		goto err_find_mode;
> +	}
> +
> +	rc = fb_alloc_cmap(&info->cmap, 256, 0);
> +	if (rc < 0) {
> +		dev_err(&(dev->dev), "cannot allocate colormap\n");
> +		goto err_alloc_cmap;
> +	}
> +
> +	rc = register_framebuffer(info);
> +	if (rc < 0) {
> +		dev_err(&(dev->dev), "cannot register framebugger\n");

Bugger :DD LOL? Buffer?

> +		goto err_reg_fb;
> +	}
> +
> +	printk(KERN_INFO "fb%d: %s on %s, %d MB RAM, %d MHz MCLK\n", info->node, info->fix.id,
> +		 pci_name(dev), info->fix.smem_len >> 20, (par->mclk_freq + 500) / 1000);
> +
> +	if (par->chip == CHIP_UNKNOWN)
> +		printk(KERN_INFO "fb%d: unknown chip, CR2D=%x, CR2E=%x, CRT2F=%x, CRT30=%x\n",
> +			info->node, vga_rcrt(NULL, 0x2d), vga_rcrt(NULL, 0x2e),
> +			vga_rcrt(NULL, 0x2f), vga_rcrt(NULL, 0x30));

dev_info x 2, but it's a dite.

> +
> +	/* Record a reference to the driver data */
> +	pci_set_drvdata(dev, info);
> +
> +#ifdef CONFIG_MTRR
> +	if (mtrr) {
> +		par->mtrr_reg = -1;
> +		par->mtrr_reg = mtrr_add(info->fix.smem_start, info->fix.smem_len, MTRR_TYPE_WRCOMB, 1);
> +	}
> +#endif
> +
> +	return 0;
> +
> +	/* Error handling */
> +err_reg_fb:
> +	fb_dealloc_cmap(&info->cmap);
> +err_alloc_cmap:
> +err_find_mode:
> +	pci_iounmap(dev, info->screen_base);
> +err_iomap:
> +	pci_release_regions(dev);
> +err_request_regions:
> +/*	pci_disable_device(dev); */
> +err_enable_device:
> +	framebuffer_release(info);
> +	return rc;
> +}
[...]
> diff -uprN -X linux-2.6.20-x/Documentation/dontdiff linux-2.6.20-x/drivers/video/svgalib.c linux-2.6.20-s3fb/drivers/video/svgalib.c
> --- linux-2.6.20-x/drivers/video/svgalib.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.20-s3fb/drivers/video/svgalib.c	2007-02-09 14:28:50.000000000 +0100
> @@ -0,0 +1,631 @@
> +/*
> + * Common utility functions for VGA-based graphics cards.
> + *
> + * Copyright (c) 2006-2007 Ondrej Zajicek <santiago@crfreenet.org>
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file COPYING in the main directory of this archive for
> + * more details.
> + *
> + * Some parts are based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/fb.h>
> +#include <linux/svga.h>
> +#include <linux/slab.h>
> +#include <asm/types.h>
> +#include <asm/io.h>
> +
> +
> +/* Write a CRT register value spread across multiple registers */
> +void svga_wcrt_multi(const struct vga_regset *regset, u32 value) {
> +
> +	u8 regval, bitval, bitnum;
> +
> +	while (regset->regnum != VGA_REGSET_END_VAL) {
> +		regval = vga_rcrt(NULL, regset->regnum);
> +		bitnum = regset->lowbit;
> +		while (bitnum <= regset->highbit) {
> +			bitval = 1 << bitnum;
> +			regval = regval & ~bitval;
> +			if (value & 1) regval = regval | bitval;
> +			bitnum ++;
> +			value = value >> 1;
> +		}
> +		vga_wcrt(NULL, regset->regnum, regval);
> +		regset ++;
> +	}
> +}
> +
> +/* Write a sequencer register value spread across multiple registers */
> +void svga_wseq_multi(const struct vga_regset *regset, u32 value) {
> +
> +	u8 regval, bitval, bitnum;
> +
> +	while (regset->regnum != VGA_REGSET_END_VAL) {
> +		regval = vga_rseq(NULL, regset->regnum);
> +		bitnum = regset->lowbit;
> +		while (bitnum <= regset->highbit) {
> +			bitval = 1 << bitnum;
> +			regval = regval & ~bitval;
> +			if (value & 1) regval = regval | bitval;
> +			bitnum ++;
> +			value = value >> 1;
> +		}
> +		vga_wseq(NULL, regset->regnum, regval);
> +		regset ++;
> +	}
> +}
> +
> +static unsigned int svga_regset_size(const struct vga_regset *regset)
> +{
> +	u8 count = 0;
> +
> +	while (regset->regnum != VGA_REGSET_END_VAL) {
> +		count += regset->highbit - regset->lowbit + 1;
> +		regset ++;
> +	}
> +	return 1 << count;
> +}
> +
> +
> +/* ------------------------------------------------------------------------- */
> +
> +
> +/* Set graphics controller registers to sane values */
> +void svga_set_default_gfx_regs(void)
> +{
> +	/* All standard GFX registers (GR00 - GR08) */
> +	vga_wgfx(NULL, VGA_GFX_SR_VALUE, 0x00);
> +	vga_wgfx(NULL, VGA_GFX_SR_ENABLE, 0x00);
> +	vga_wgfx(NULL, VGA_GFX_COMPARE_VALUE, 0x00);
> +	vga_wgfx(NULL, VGA_GFX_DATA_ROTATE, 0x00);
> +	vga_wgfx(NULL, VGA_GFX_PLANE_READ, 0x00);
> +	vga_wgfx(NULL, VGA_GFX_MODE, 0x00);
> +/*	vga_wgfx(NULL, VGA_GFX_MODE, 0x20); */
> +/*	vga_wgfx(NULL, VGA_GFX_MODE, 0x40); */
> +	vga_wgfx(NULL, VGA_GFX_MISC, 0x05);
> +/*	vga_wgfx(NULL, VGA_GFX_MISC, 0x01); */
> +	vga_wgfx(NULL, VGA_GFX_COMPARE_MASK, 0x0F);
> +	vga_wgfx(NULL, VGA_GFX_BIT_MASK, 0xFF);
> +}
> +
> +/* Set attribute controller registers to sane values */
> +void svga_set_default_atc_regs(void)
> +{
> +	vga_r(NULL, 0x3DA);
> +	vga_w(NULL, VGA_ATT_W, 0x00);
> +
> +	/* All standard ATC registers (AR00 - AR14) */
> +	u8 count;

If I'm not wrong, this adds mixing code/declaration warning?

> +	for (count = 0; count <= 0xF; count ++)
> +		svga_wattr(count, count);
> +
> +	svga_wattr(VGA_ATC_MODE, 0x01);
> +/*	svga_wattr(VGA_ATC_MODE, 0x41); */
> +	svga_wattr(VGA_ATC_OVERSCAN, 0x00);
> +	svga_wattr(VGA_ATC_PLANE_ENABLE, 0x0F);
> +	svga_wattr(VGA_ATC_PEL, 0x00);
> +	svga_wattr(VGA_ATC_COLOR_PAGE, 0x00);
> +
> +	vga_r(NULL, 0x3DA);
> +	vga_w(NULL, VGA_ATT_W, 0x20);
> +}
[...]

Looks nice now.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
