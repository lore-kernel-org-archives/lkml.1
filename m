Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYIMKHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYIMKHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbYIMKH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:07:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757557AbYIMKHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:07:24 -0400
Date: Sat, 13 Sep 2008 03:05:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-arm@vger.kernel.org, Eric Miao <eric.miao@marvell.com>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@linux.it>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] pxafb: frame buffer overlay support for PXA27x.
Message-Id: <20080913030540.48341eae.akpm@linux-foundation.org>
In-Reply-To: <1221034056-16587-2-git-send-email-giometti@enneenne.com>
References: <1221034056-16587-1-git-send-email-giometti@enneenne.com>
	<1221034056-16587-2-git-send-email-giometti@enneenne.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please cc linux-fbdev-devel@lists.sourceforge.net on fbdev patches.

On Wed, 10 Sep 2008 10:07:35 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:

> From: Rodolfo Giometti <giometti@linux.it>
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
>
>  arch/arm/mach-pxa/include/mach/regs-lcd.h |   39 +
>  drivers/video/Kconfig                     |    6 +
>  drivers/video/Makefile                    |    1 +
>  drivers/video/pxafb.c                     |   75 ++-
>  drivers/video/pxafb.h                     |   74 ++
>  drivers/video/pxafb_overlay.c             | 1476 +++++++++++++++++++++++++++++
>  6 files changed, 1654 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/video/pxafb_overlay.c

Over a thousand lines of code and zero changelog?  No indication what
the driver does, what hardware is it for, nothing needs to be
communicated about the implementation, no todo items, no shortcomings? 
Really?

The code looks generally OK to my untrained eye.  A few things:

>
> ...
>
> +#ifdef CONFIG_FB_PXA_OVERLAY
> +struct overlayfb_info
> +{

Please run scripts/checkpatch.pl across all patches, no exceptions, and
review the result.

>
> ...
>
> +#define o1_to_basefb(d)		container_of(d, struct pxafb_info, overlay1fb)
> +#define o2_to_basefb(d)		container_of(d, struct pxafb_info, overlay2fb)
> +#define cu_to_basefb(d)		container_of(d, struct pxafb_info, cursorfb)

Please convert to typesafe C functions.  And use them.

>
> ...
>
> +#define CLEAR_LCD_INTR(reg, intr) do {  \
> +	reg = (intr);			\
> +} while (0)

This fortunately has no callers.

> +#define WAIT_FOR_LCD_INTR(bfi, reg, intr, timeout) ({		\
> +	int __done = 0;						\
> +	int __t = timeout;					\
> +	while (__t) {						\
> +		__done = lcd_readl(bfi, reg) & (intr);		\
> +		if (__done)					\
> +			break;					\
> +		mdelay(10);					\
> +		__t--;						\
> +	}							\
> +	if (!__t)						\
> +		dev_info(bfi->dev, "wait " #intr " timeount");	\
> +	__done;							\
> +})

afacit this can be implemented as a C function.  That would be vastly
preferable.

> +#define DISABLE_OVERLAYS(fbi) do {	 				\
> +	if (fbi->overlay1fb.state == C_ENABLE)				\
> +		overlay1fb_disable((struct fb_info *) &fbi->overlay1fb);\
> +	if (fbi->overlay2fb.state == C_ENABLE)				\
> +		overlay2fb_disable((struct fb_info *) &fbi->overlay2fb);\
> +	if (fbi->cursorfb.state == C_ENABLE)				\
> +		cursorfb_disable((struct fb_info *) &fbi->cursorfb);	\
> +} while (0)
> +
> +#define ENABLE_OVERLAYS(fbi) do {					\
> +	if (fbi->overlay1fb.state == C_DISABLE)				\
> +		overlay1fb_enable((struct fb_info *) &fbi->overlay1fb);	\
> +	if (fbi->overlay2fb.state == C_DISABLE)				\
> +		overlay2fb_enable((struct fb_info *) &fbi->overlay2fb);	\
> +	if (fbi->cursorfb.state == C_DISABLE)				\
> +		cursorfb_enable((struct fb_info *) &fbi->cursorfb);	\
> +} while (0)
> +
> +#define BLANK_OVERLAYS(fbi) do {	 				\
> +	if (fbi->overlay1fb.state == C_ENABLE) {			\
> +		overlay1fb_disable((struct fb_info *) &fbi->overlay1fb);\
> +		fbi->overlay1fb.state = C_BLANK;			\
> +	}								\
> +	if (fbi->overlay2fb.state == C_ENABLE) {			\
> +		overlay2fb_disable((struct fb_info *) &fbi->overlay2fb);\
> +		fbi->overlay2fb.state = C_BLANK;			\
> +	}								\
> +	if (fbi->cursorfb.state == C_ENABLE) {				\
> +		cursorfb_disable((struct fb_info *) &fbi->cursorfb);	\
> +		fbi->cursorfb.state = C_BLANK;				\
> +	}								\
> +} while (0)
> +
> +#define UNBLANK_OVERLAYS(fbi) do {					\
> +	if (fbi->overlay1fb.state == C_BLANK) {				\
> +		overlay1fb_enable((struct fb_info *) &fbi->overlay1fb);	\
> +		fbi->overlay1fb.state = C_ENABLE;			\
> +	}								\
> +	if (fbi->overlay2fb.state == C_BLANK) {				\
> +		overlay2fb_enable((struct fb_info *) &fbi->overlay2fb);	\
> +		fbi->overlay2fb.state = C_ENABLE;			\
> +	}								\
> +	if (fbi->cursorfb.state == C_BLANK) {				\
> +		cursorfb_enable((struct fb_info *) &fbi->cursorfb);	\
> +		fbi->cursorfb.state = C_ENABLE;				\
> +	}								\
> +} while (0)

Please switch to C functions.

Please remove all the casts and use container_of(), or helper functions
which use container_of().

> +static int overlay1fb_open(struct fb_info *info, int user)
> +{
> +	struct overlayfb_info *fbi = (struct overlayfb_info *) info;

Remove all instances of the above cast and use container_of(), or the
typesafe C-coded helper function which uses container_of().

> +	int ret = 0;
> +
> +	if (!atomic_dec_and_test(&fbi->refcount)) {
> +		atomic_inc(&fbi->refcount);
> +		return -EACCES;
> +	}
> +
> +	/* If basefb is disable, enable fb */
> +	if (o1_to_basefb(fbi)->state != C_ENABLE)
> +		o1_to_basefb(fbi)->fb.fbops->fb_blank(VESA_NO_BLANKING,
> +				(struct fb_info *) o1_to_basefb(fbi));

container_of().

> +	/* Initialize the variables in overlay1 framebuffer */
> +	fbi->fb.var.xres = fbi->fb.var.yres = 0;
> +	fbi->fb.var.bits_per_pixel = 0;
> +
> +	return ret;
> +}
> +
>
> ...
>
> +static int overlay1fb_map_video_memory(struct fb_info *info)
> +{
> +	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
> +
> +	if (fbi->map_cpu)
> +		dma_free_writecombine(o1_to_basefb(fbi)->dev, fbi->map_size,
> +					(void *) fbi->map_cpu, fbi->map_dma);
> +	fbi->video_offset = PAGE_ALIGN(sizeof(struct pxafb_dma_descriptor));
> +	fbi->map_size = PAGE_ALIGN(fbi->fb.fix.smem_len + fbi->video_offset);
> +	fbi->map_cpu = dma_alloc_writecombine(o1_to_basefb(fbi)->dev,
> +						fbi->map_size, &fbi->map_dma,
> +						GFP_KERNEL);
> +	if (!fbi->map_cpu)
> +		return -ENOMEM;
> +
> +	/* Prevent initial garbage on screen */
> +	memset(fbi->map_cpu, 0, fbi->map_size);
> +	fbi->fb.screen_base = fbi->map_cpu + fbi->video_offset;
> +	fbi->screen_cpu = fbi->map_cpu + fbi->video_offset;
> +	fbi->screen_dma = fbi->map_dma + fbi->video_offset;
> +
> +	fbi->fb.fix.smem_start = fbi->screen_dma;
> +
> +	/* Setup dma descriptor */
> +	fbi->dma1 = (struct pxafb_dma_descriptor *)
> +		(fbi->screen_cpu - sizeof(struct pxafb_dma_descriptor));
> +
> +	fbi->dma1->fdadr = (fbi->screen_dma -
> +				sizeof(struct pxafb_dma_descriptor));
> +	fbi->dma1->fsadr = fbi->screen_dma;
> +	fbi->dma1->fidr  = 0;
> +	fbi->dma1->ldcmd = fbi->fb.fix.smem_len;
> +
> +	return 0;
> +}

The above code is implicitly implementing some memory layout which I
assume is defined by the hardware.

Where would someone go to find out about that layout?  Some
documentation reference or a description in a comment would add
maintainability and understandability.

> +static int overlay1fb_enable(struct fb_info *info)
> +{
> +	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
> +
> +	unsigned long bpp1;
> +	unsigned int lccr5;

Avoid random newline between local definitions, please.

> +	if (!fbi->map_cpu)
> +		return -EINVAL;
> +
> +	switch (fbi->fb.var.bits_per_pixel) {
> +	case 16:
> +		bpp1 = 0x4;
> +		break;
> +	case 18:
> +		bpp1 = 0x6;
> +		break;
> +	case 19:
> +		bpp1 = 0x8;
> +		break;
> +	case 24:
> +		bpp1 = 0x9;
> +		break;
> +	case 25:
> +		bpp1 = 0xa;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* Disable branch/start/end of frame interrupt */
> +	lccr5 = lcd_readl(o1_to_basefb(fbi), LCCR5);
> +	lcd_writel(o1_to_basefb(fbi), LCCR5,
> +				lccr5 | LCCR5_IUM(1) | LCCR5_BSM(1)
> +					| LCCR5_EOFM(1) | LCCR5_SOFM(1));
> +
> +	if (fbi->state == C_DISABLE || fbi->state == C_BLANK)
> +		lcd_writel(o1_to_basefb(fbi), FDADR1, fbi->dma1->fdadr);
> +	else
> +		lcd_writel(o1_to_basefb(fbi), DFBR1, fbi->dma1->fdadr | 0x1);
> +
> +	/* Enable overlay 1 window */
> +	lcd_writel(o1_to_basefb(fbi), OVL1C2,
> +				(fbi->ypos << 10) | fbi->xpos);;
> +	lcd_writel(o1_to_basefb(fbi), OVL1C1,
> +				OVL1C1_O1EN | (bpp1 << 20) |
> +				((fbi->fb.var.yres-1)<<10) |
> +				(fbi->fb.var.xres-1));
> +
> +	fbi->state = C_ENABLE;
> +
> +	return 0;
> +}
> +
>
> ...
>
> +static int overlay1fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
> +{
> +	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
> +	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
>
> +	if (off < info->fix.smem_len) {
> +		vma->vm_pgoff += fbi->video_offset / PAGE_SIZE;
> +		return dma_mmap_writecombine(o1_to_basefb(fbi)->dev, vma,
> +					     fbi->map_cpu, fbi->map_dma,
> +					     fbi->map_size);
> +	}
> +	return -EINVAL;
> +}

No need to set VM_IO or VM_RESERVED, etc?

>
> ...
>
> +/*
> + * LCD enhancement : Overlay 2
> + *
> + * Features:
> + * - support planar YCbCr420/YCbCr422/YCbCr444;
> + */
> +static int overlay2fb_open(struct fb_info *info, int user)
> +{
> +	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
> +
> +	if (!atomic_dec_and_test(&fbi->refcount)) {
> +		atomic_inc(&fbi->refcount);
> +		return -EACCES;
> +	}

Now what's happening here.

- Please add a comment demystifying this.  It looks fishy.

- It surely is racy

- It would be non-racy were it to use atomic_dec_not_zero(), but I
  suspect we're just covering up bugs here.


> +	/* If basefb is disable, enable fb */
> +	if (o2_to_basefb(fbi)->state != C_ENABLE)
> +		o2_to_basefb(fbi)->fb.fbops->fb_blank(VESA_NO_BLANKING,
> +				(struct fb_info *) o2_to_basefb(fbi));
> +
> +	fbi->fb.var.xres = fbi->fb.var.yres = 0;
> +
> +	return 0;
> +}
> +
> +static int overlay2fb_release(struct fb_info *info, int user)
> +{
> +	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
> +
> +	/* Disable overlay when released */
> +	overlay2fb_blank(1, info);
> +
> +	atomic_inc(&fbi->refcount);

Strange to see a refcount _increase_ in a ->release handler!

> +	return 0;
> +}
> +
>
> ...
>

