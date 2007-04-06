Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbXDFAJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbXDFAJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXDFAJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:09:40 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:42539 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbXDFAJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UNNBSNIC6LXZotIlBUSoVd1T3+kXuvtfIC/F01cnskCtEp0/5eHZR8fccHNmCq3umPZXJOskBKLMhSvVYpwqXuDIH2JOpGsD+Y0yyhSksO1u7wKlnzfAkhMhfvI7X56dAw4U18L1y6JlCETDKi9J0j4JmH4yB+N9cZe7M5xsgkU=
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1175769886.10382.29.camel@localhost>
References: <1175769886.10382.29.camel@localhost>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 08:09:18 +0800
Message-Id: <1175818158.31131.63.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 11:44 +0100, Alan Hourihane wrote:
> Attached is a patch against 2.6.21-rc5 which adds the Intel Vermilion
> Range support.
> 
> Intel funded Tungsten Graphics to do this work.
> 
> If there's any problems or updates needed to be done to get accepted,
> please let me know.
> 

Preferably, add sparse annotations and compile with make C=1. I've
included possible sparse annotations (the only ones I can see) below.
> 
> +
> +struct cr_sys {
> +	struct vml_sys sys;
> +	struct pci_dev *mch_dev;
> +	struct pci_dev *lpc_dev;
> +	__u32 mch_bar;
> +	__u8 *mch_regs_base;

void __iomem *mch_regs_base; (sparse)

> +	__u32 gpio_bar;
> +	__u32 saved_panel_state;
> +	__u32 saved_clock;
> +};
> +
> 
> +static void crvml_panel_on(const struct vml_sys *sys)
> +{
> +	const struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 addr = crsys->gpio_bar + CRVML_PANEL_PORT;
> +	__u32 cur = inl(addr);
> +
> +	if (!(cur & CRVML_PANEL_ON)) {
> +		/* Make sure LVDS controller is down. */
> +		if (cur & 0x00000001) {
> +			cur &= ~CRVML_LVDS_ON;
> +			outl(cur, addr);
> +		}
> +		/* Power up Panel */
> +		schedule_timeout(HZ / 10);
> +		cur |= CRVML_PANEL_ON;
> +		outl(cur, addr);
> +	}
> +
> +	/* Power up LVDS controller */
> +
> +	if (!(cur & CRVML_LVDS_ON)) {
> +		schedule_timeout(HZ / 10);
> +		outl(cur | CRVML_LVDS_ON, addr);
> +	}
> +}
> +
> +static void crvml_panel_off(const struct vml_sys *sys)
> +{
> +	const struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +
> +	__u32 addr = crsys->gpio_bar + CRVML_PANEL_PORT;
> +	__u32 cur = inl(addr);
> +
> +	/* Power down LVDS controller first to avoid high currents */
> +	if (cur & CRVML_LVDS_ON) {
> +		cur &= ~CRVML_LVDS_ON;
> +		outl(cur, addr);
> +	}
> +	if (cur & CRVML_PANEL_ON) {
> +		schedule_timeout(HZ / 10);
> +		outl(cur & ~CRVML_PANEL_ON, addr);
> +	}
> +}
> +
> +static void crvml_backlight_on(const struct vml_sys *sys)
> +{
> +	const struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 addr = crsys->gpio_bar + CRVML_PANEL_PORT;
> +	__u32 cur = inl(addr);
> +
> +	if (cur & CRVML_BACKLIGHT_OFF) {
> +		cur &= ~CRVML_BACKLIGHT_OFF;
> +		outl(cur, addr);
> +	}
> +}
> +
> +static void crvml_backlight_off(const struct vml_sys *sys)
> +{
> +	const struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 addr = crsys->gpio_bar + CRVML_PANEL_PORT;
> +	__u32 cur = inl(addr);
> +
> +	if (!(cur & CRVML_BACKLIGHT_OFF)) {
> +		cur |= CRVML_BACKLIGHT_OFF;
> +		outl(cur, addr);
> +	}
> +}
> 

Perhaps backling_on/off and panel_on/off can be moved to the backlight
subsystem?

> +
> 
> +static int crvml_sys_restore(struct vml_sys *sys)
> +{
> +	struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 *clock_reg = (__u32 *) (crsys->mch_regs_base + CRVML_REG_CLOCK);

__u32 __iomem *clock_reg = crsys->mch_regs_base + CRVML_REG_CLOCK; (sparse)

> +	__u32 cur = crsys->saved_panel_state;
> +
> +	if (cur & CRVML_BACKLIGHT_OFF) {
> +		crvml_backlight_off(sys);
> +	} else {
> +		crvml_backlight_on(sys);
> +	}
> +
> +	if (cur & CRVML_PANEL_ON) {
> +		crvml_panel_on(sys);
> +	} else {
> +		crvml_panel_off(sys);
> +		if (cur & CRVML_LVDS_ON) {
> +			;
> +			/* Will not power up LVDS controller while panel is off */
> +		}
> +	}
> +	iowrite32(crsys->saved_clock, clock_reg);
> +	ioread32(clock_reg);
> +
> +	return 0;
> +}
> +
> +static int crvml_sys_save(struct vml_sys *sys)
> +{
> +	struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 *clock_reg = (__u32 *) (crsys->mch_regs_base + CRVML_REG_CLOCK);
> +

__u32 __iomem *clock_reg = crsys->mch_regs_base + CRVML_REG_CLOCK; (sparse)

> +	crsys->saved_panel_state = inl(crsys->gpio_bar + CRVML_PANEL_PORT);
> +	crsys->saved_clock = ioread32(clock_reg);
> +
> +	return 0;
> +}
> +
> +static int crvml_nearest_index(const struct vml_sys *sys, int clock)
> +{
> +
> +	int i;
> +	int cur_index;
> +	int cur_diff;
> +	int diff;
> +
> +	cur_index = 0;
> +	cur_diff = clock - crvml_clocks[0];
> +	cur_diff = (cur_diff < 0) ? -cur_diff : cur_diff;
> +	for (i = 1; i < crvml_num_clocks; ++i) {
> +		diff = clock - crvml_clocks[i];
> +		diff = (diff < 0) ? -diff : diff;
> +		if (diff < cur_diff) {
> +			cur_index = i;
> +			cur_diff = diff;
> +		}
> +	}
> +	return cur_index;
> +}
> +
> +static int crvml_nearest_clock(const struct vml_sys *sys, int clock)
> +{
> +	return crvml_clocks[crvml_nearest_index(sys, clock)];
> +}
> +
> +static int crvml_set_clock(struct vml_sys *sys, int clock)
> +{
> +	struct cr_sys *crsys = container_of(sys, struct cr_sys, sys);
> +	__u32 *clock_reg = (__u32 *) (crsys->mch_regs_base + CRVML_REG_CLOCK);
> 

__u32 __iomem *clock_reg = crsys->mch_regs_base + CRVML_REG_CLOCK; (sparse)

> +	int index;
> +	__u32 clock_val;
> +
> +	index = crvml_nearest_index(sys, clock);
> +
> +	if (crvml_clocks[index] != clock)
> +		return -EINVAL;
> +
> +	clock_val = ioread32(clock_reg) & ~CRVML_CLOCK_MASK;
> +	clock_val = crvml_clock_bits[index] << CRVML_CLOCK_SHIFT;
> +	iowrite32(clock_val, clock_reg);
> +	ioread32(clock_reg);
> +
> +	return 0;
> +}
> +

> +
> +static int __init crvml_init(void)
> +{
> +	int err = 0;
> +	struct vml_sys *sys;
> +	struct cr_sys *crsys;
> +
> +	crsys = (struct cr_sys *)kmalloc(sizeof(*crsys), GFP_KERNEL);
> +
> +	if (!crsys)
> +		return -ENOMEM;
> +
> +	sys = &crsys->sys;
> +	err = crvml_sysinit(crsys);
> +	if (err) {
> +		kfree(crsys);
> +		return err;
> +	}
> +
> +	sys->destroy = crvml_sys_destroy;
> +	sys->subsys = crvml_subsys;
> +	sys->save = crvml_sys_save;
> +	sys->restore = crvml_sys_restore;
> +	sys->prog_clock = crvml_false;
> +	sys->set_clock = crvml_set_clock;
> +	sys->has_panel = crvml_true;

Hmm...

> +
> +#ifndef FB_BLANK_UNBLANK
> +#define FB_BLANK_UNBLANK	VESA_NO_BLANKING
> +#endif
> +#ifndef FB_BLANK_NORMAL
> +#define FB_BLANK_NORMAL		VESA_NO_BLANKING + 1
> +#endif
> +#ifndef FB_BLANK_VSYNC_SUSPEND
> +#define FB_BLANK_VSYNC_SUSPEND	VESA_VSYNC_SUSPEND + 1
> +#endif
> +#ifndef FB_BLANK_HSYNC_SUSPEND
> +#define FB_BLANK_HSYNC_SUSPEND	VESA_HSYNC_SUSPEND + 1
> +#endif
> +#ifndef FB_BLANK_POWERDOWN
> +#define FB_BLANK_POWERDOWN	VESA_POWERDOWN + 1
> +#endif

Since this driver going to be part of the kernel, the above is redundant,
you don't need it.

> 
> +static int __devinit vml_pci_probe(struct pci_dev *dev,
> +				   const struct pci_device_id *id)
> +{
> +	struct vml_info *vinfo;
> +	struct fb_info *info;
> +	struct vml_par *par;
> +	int err = 0;
> +
> +	par = kmalloc(sizeof(*par), GFP_KERNEL);
> +	if (par == NULL)
> +		return -ENOMEM;
> +
> +	vinfo = kmalloc(sizeof(*vinfo), GFP_KERNEL);

You can use kzalloc instead of kmalloc.

> +	if (vinfo == NULL) {
> +		err = -ENOMEM;
> +		goto out_err_0;
> +	}
> +
> +	memset(vinfo, 0, sizeof(*vinfo));
> +	memset(par, 0, sizeof(*par));
> +

You can also use framebuffer_alloc()/framebuffer_release() for
struct fb_info and for par.  But if it is not possible,
set info->device = dev->dev so your driver can show up in sysfs.

> +	vinfo->par = par;
> +	vinfo->pipe = 0;
> +	par->mutex = &global_mutex;
> +	INIT_LIST_HEAD(&par->gpu.head);
> +	par->gpu_list = &global_gpu_list;
> +	par->vdc = dev;
> +	atomic_set(&par->refcount, 1);
> +
> +	switch (id->device) {
> +	case VML_DEVICE_VDC:
> +		if ((err = vmlfb_get_gpu(par)))
> +			goto out_err_1;
> +		if ((err = pci_enable_device(dev)))
> +			goto out_err_1;
> +		pci_set_drvdata(dev, &vinfo->info);
> +		break;
> +	default:
> +		err = -ENODEV;
> +		goto out_err_1;
> +		break;
> +	}
> +
> +	info = &vinfo->info;
> +	info->flags = FBINFO_PARTIAL_PAN_OK;

Since your driver is tristate, do 

info->flags  = FBINFO_DEFAULT | FBINFO_PARTIAL_PAN_OK;

I will probably use this flag later to differentiate driver modules
to fix a bug in the logo drawing code.

You may also wish to add FBINFO_HW_ACCEL_YPAN for faster text scrolling.

> 
> +
> +static void vml_wait_vblank(struct vml_info *vinfo)
> +{
> +	schedule_timeout(HZ / 40);
> 

This is not really wait for vblank, is it?


> +
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16)
> +static int vmlfb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> +		       unsigned long arg, struct fb_info *info)
> +#else
> +static int vmlfb_ioctl(struct fb_info *info, unsigned int cmd,
> +		       unsigned long arg)
> +#endif
> 

Similarly, you can remove the above version checks.

Tony

