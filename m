Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYCTW20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYCTW20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbYCTW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:28:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759559AbYCTW2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:28:03 -0400
Date: Thu, 20 Mar 2008 15:27:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: York Sun <yorksun@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       yorksun@freescale.com, timur@freescale.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v2] Driver for Freescale 8610 and 5121 DIU
Message-Id: <20080320152708.23c6c734.akpm@linux-foundation.org>
In-Reply-To: <12059526274026-git-send-email-yorksun@freescale.com>
References: <12059526271941-git-send-email-yorksun@freescale.com>
	<12059526274026-git-send-email-yorksun@freescale.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 13:50:26 -0500
York Sun <yorksun@freescale.com> wrote:

> The following features are supported:
> plane 0 works as a regular frame buffer, can be accessed by /dev/fb0
> plane 1 has two AOIs (area of interest), can be accessed by /dev/fb1 and /dev/fb2
> plane 2 has two AOIs, can be accessed by /dev/fb3 and /dev/fb4
> Special ioctls support AOIs
> 
> All /dev/fb* can be used as regular frame buffer devices, except hardware change can
> only be made through /dev/fb0. Changing pixel clock has no effect on other fbs.
> 
> Limitation of usage of AOIs:
> AOIs on the same plane can not be horizonally overlapped
> AOIs have horizonal order, i.e. AOI0 should be always on top of AOI1
> AOIs can not beyond phisical display area. Application should check AOI geometry
> before changing physical resolution on /dev/fb0
> 
> required command line parameters to preallocate memory for frame buffer
> diufb=15M
> 
> optional command line parameters to set modes and monitor
> video=fslfb:[resolution][,bpp][,monitor]
> Syntax:
> 
> Resolution
> xres x yres-bpp@refresh_rate, the -bpp and @refresh_rate are optional
> eg, 1024x768, 1280x1024, 1280x1024-32, 1280x1024@60, 1280x1024-32@60, 1280x480-32@60
> 
> Bpp
> bpp=32, bpp=24, or bpp=16
> 
> Monitor
> monitor=0, monitor=1, monitor=2
> 0 is DVI
> 1 is Single link LVDS
> 2 is Double link LVDS
> 
> Note: switching monitor is a board feather, not DIU feather. MPC8610HPCD has three
> monitor ports to swtich to. MPC5121ADS doesn't have additional monitor port. So switching
> monirot port for MPC5121ADS has no effect.
> 
> If compiled as a module, it takes pamameters mode, bpp, monitor with the same syntax above.
> 
> ...
>
> +static struct diu_hw dr = {
> +	.mode = MFB_MODE1,
> +	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
> +};

I'm not clear on what's supposed to happen with __SPIN_LOCK_UNLOCKED().  I
do know that its documentation is crap.

I guess you should have used SPIN_LOCK_UNLOCKED there rather than
open-coding its equivalent.  And SPIN_LOCK_UNLOCKED _is_ documented.  It
says "don't use this".

Now, s/documentation/guesswork-and-grep/ says that you're supposed to pick
a tree-wide-unique string here as your lockdep key.

So I did this:

--- a/drivers/video/fsl-diu-fb.c~fbdev-driver-for-freescale-8610-and-5121-diu-fix
+++ a/drivers/video/fsl-diu-fb.c
@@ -274,7 +274,7 @@ static struct mfb_info mfb_template[] = 
 
 static struct diu_hw dr = {
 	.mode = MFB_MODE1,
-	.reg_lock = __SPIN_LOCK_UNLOCKED(old_style_spin_init),
+	.reg_lock = __SPIN_LOCK_UNLOCKED(diu_hw.reg_lock),
 };
 
 static struct diu_pool pool;

> +static struct diu_pool pool;
> +
> +/*	To allocate memory for framebuffer. First try __get_free_pages(). If it
> + *	fails, try rh_alloc. The reason is __get_free_pages() cannot allocate
> + *	very large memory (more than 4MB). We don't want to allocate all memory
> + *	in rheap since small memory allocation/deallocation will fragment the
> + *	rheap and make the furture large allocation fail.
> + */
> +
> +void *fsl_diu_alloc(unsigned long size, phys_addr_t *phys)
> +{
> +	void *virt;
> +
> +	pr_debug("size=%lu\n", size);
> +
> +	virt = (void *)__get_free_pages(GFP_DMA | GFP_ATOMIC, get_order(size));

GFP_DMA implies GFP_ATOMIC, but it's appropriate for documentation purposes.

> +	if (virt) {
> +		*phys = virt_to_phys(virt);
> +		pr_debug("virt %p, phys=%llx\n", virt, (uint64_t) *phys);
> +		memset(virt, 0, size);

Could have used __GFP_ZERO, I guess.

> +		return virt;
> +	}
> +	if (!diu_ops.diu_mem) {
> +		printk(KERN_INFO "%s: no diu_mem."
> +			" To reserve more memory, put 'diufb=15M' "
> +			"in the command line\n", __func__);
> +		return NULL;
> +	}
> +
> +	virt = (void *) rh_alloc(&diu_ops.diu_rh_info, size, "DIU");

hm, I'd have expected checkpatch to whine about the space after the cast
there.  Whatever.

checkpatch does turn up some significant problems:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
#205: FILE: drivers/video/fsl-diu-fb.c:32:
+#include <asm/uaccess.h>

WARNING: consider using strict_strtoul in preference to simple_strtoul
#1599: FILE: drivers/video/fsl-diu-fb.c:1426:
+       val = simple_strtoul(buf, last, 0);

WARNING: consider using strict_strtoul in preference to simple_strtoul
#1821: FILE: drivers/video/fsl-diu-fb.c:1648:
+                       val = simple_strtoul(opt + 8, NULL, 0);

WARNING: consider using strict_strtoul in preference to simple_strtoul
#1825: FILE: drivers/video/fsl-diu-fb.c:1652:
+                       default_bpp = simple_strtoul(opt + 4, NULL, 0);


please take a look, and please use checkpatch on all future patches.

> +	if (virt) {
> +		*phys = virt_to_bus(virt);
> +		memset(virt, 0, size);
> +	}
> +
> +	pr_debug("rh virt=%p phys=%lx\n", virt, *phys);
> +
> +	return virt;
> +}
> +
> +void fsl_diu_free(void *p, unsigned long size)
> +{
> +	pr_debug("p=%p size=%lu\n", p, size);
> +
> +	if (!p)
> +		return;
> +
> +	if ((p >= diu_ops.diu_mem) &&
> +	    (p < (diu_ops.diu_mem + diu_ops.diu_size))) {
> +		pr_debug("rh\n");
> +		rh_free(&diu_ops.diu_rh_info, (unsigned long) p);
> +	} else {
> +		pr_debug("dma\n");
> +		free_pages((unsigned long)p, get_order(size));
> +	}
> +}
> +
> +
> +/*
> + * Checks to see if the hardware supports the state requested by var passed
> + * in. This function does not alter the hardware state! If the var passed in
> + * is slightly off by what the hardware can support then we alter the var
> + * PASSED in to what we can do. If the hardware doesn't support mode change
> + * a -EINVAL will be returned by the upper layers.
> + */
> +static int fsl_diu_check_var
> +	(struct fb_var_screeninfo *var, struct fb_info *info)

Like this:

static int fsl_diu_check_var(struct fb_var_screeninfo *var,
				struct fb_info *info)

please.

> +{
> +	unsigned long htotal, vtotal;
> +	struct mfb_info *pmfbi, *cmfbi, *mfbi = info->par;
> +	struct fsl_diu_data *machine_data = mfbi->parent;
> +	int index = mfbi->index;
> +
>
> ..
>
> +static void update_lcdc(struct fb_info *info)
> +{
> +	struct fb_var_screeninfo *var = &info->var;
> +	struct mfb_info *mfbi = info->par;
> +	struct fsl_diu_data *machine_data = mfbi->parent;
> +	struct diu *hw;
> +	int i, j;
> +	char __iomem *cursor_base, *gamma_table_base;
> +
> +	u32 temp;
> +
> +	spin_lock_init(&dr.reg_lock);

we already did that at compile-time?

> +	hw = dr.diu_reg;
> +
> +	if (mfbi->type == MFB_TYPE_OFF) {
> +		fsl_diu_disable_panel(info);
> +		return;
> +	}
>
> ...
>
> +static void request_irq_local(int irq)
> +{
> +	unsigned long status, ints;
> +	struct diu *hw;
> +
> +	hw = dr.diu_reg;
> +
> +	/* Read to clear the status */
> +	status = in_be32(&(hw->int_status));
> +
> +	if (request_irq(irq, fsl_diu_isr, 0, "diu", 0))
> +		pr_info("Request diu IRQ failed.\n");
> +	else {
> +		ints = INT_PARERR | INT_LS_BF_VS;
> +#if !defined(CONFIG_NOT_COHERENT_CACHE)
> +		ints |=	INT_VSYNC;
> +#endif
> +		if (dr.mode == MFB_MODE2 || dr.mode == MFB_MODE3)
> +			ints |= INT_VSYNC_WB;
> +
> +		/* Read to clear the status */
> +		status = in_be32(&(hw->int_status));
> +		out_be32(&(hw->int_mask), ints);
> +	}
> +}

The request_irq() return value gets dropped on the floor.

> +static void free_irq_local(int irq)
> +{
> +	struct diu *hw = dr.diu_reg;
> +
> +	/* Disable all LCDC interrupt */
> +	out_be32(&(hw->int_mask), 0x1f);
> +
> +	free_irq(irq, 0);
> +}

and the free_irq() will go splat?

> +#ifdef CONFIG_PM
> +/*
> + * Power management hooks. Note that we won't be called from IRQ context,
> + * unlike the blank functions above, so we may sleep.
> + */
> +static int fsl_diu_suspend(struct of_device *dev, pm_message_t state)
> +{
> +	struct fsl_diu_data *machine_data;
> +
> +	machine_data = dev_get_drvdata(&ofdev->dev);
> +	disable_lcdc(machine_data->fsl_diu_info[0]);
> +
> +	return 0;
> +}
> +
> +static int fsl_diu_resume(struct of_device *dev)
> +{
> +	struct fsl_diu_data *machine_data;
> +
> +	machine_data = dev_get_drvdata(&ofdev->dev);
> +	enable_lcdc(machine_data->fsl_diu_info[0]);
> +
> +	return 0;
> +}

Conventionally we'll do

#else
#define fsl_diu_suspend NULL
#define fsl_diu_resume NULL

here, then remove the ifdefs from fsl_diu_driver.

> +#endif				/* CONFIG_PM */
> +
> +/* Align to 64-bit(8-byte), 32-byte, etc. */
> +static int allocate_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
> +{
> +	u32 offset, ssize;
> +	u32 mask;
> +	dma_addr_t paddr = 0;
> +
> +	ssize = size + bytes_align;
> +	buf->vaddr = dma_alloc_coherent(0, ssize, &paddr, GFP_DMA | GFP_KERNEL);
> +	if (!buf->vaddr)
> +		return -ENOMEM;
> +
> +	buf->paddr = (__u32) paddr;
> +	memset(buf->vaddr, 0, ssize);

__GFP_ZERO?

> +	mask = bytes_align - 1;
> +	offset = (u32)buf->paddr & mask;
> +	if (offset) {
> +		buf->offset = bytes_align - offset;
> +		buf->paddr = (u32)buf->paddr + offset;
> +	} else
> +		buf->offset = 0;
> +	return 0;
> +}
> +
> +static int fsl_diu_probe(struct of_device *ofdev,
> +	const struct of_device_id *match)
> +{
> +	struct device_node *np = ofdev->node;
> +	struct mfb_info *mfbi;
> +	phys_addr_t dummy_ad_addr;
> +	int ret, i, error = 0;
> +	struct resource res;
> +	struct fsl_diu_data *machine_data;
> +
> +	machine_data = kzalloc(sizeof(struct fsl_diu_data), GFP_KERNEL);
> +	if (!machine_data)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < sizeof(machine_data->fsl_diu_info) /
> +			sizeof(struct fb_info *); i++) {

Please use ARRAY_SIZE() here, and in all the other places which open-code
it.

> +		machine_data->fsl_diu_info[i] =
> +			framebuffer_alloc(sizeof(struct mfb_info), &ofdev->dev);
> +		if (!machine_data->fsl_diu_info[i]) {
> +			dev_err(&ofdev->dev, "cannot allocate memory\n");
> +			ret = -ENOMEM;
> +			goto error2;
> +		}
