Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbZGJGbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbZGJGbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZGJGbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:31:35 -0400
Received: from centrinvest.ru ([94.25.115.130]:53852 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZGJGbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:31:34 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Fri, 10 Jul 2009 10:31:23 +0400
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fbdev-devel@lists.sourceforge.net,
       davinci-linux-open-source@linux.davincidsp.com, krzysztof.h1@poczta.fm,
       Pavel Kiryukhin <pkiryukhin@ru.mvista.com>,
       Steve Chen <schen@mvista.com>
Subject: Re: [PATCH] davinci: fb: Frame Buffer driver for TI DA8xx/OMAP-L1xx
Message-ID: <20090710063123.GA15969@centrinvest.ru>
Mail-Followup-To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-fbdev-devel@lists.sourceforge.net,
	davinci-linux-open-source@linux.davincidsp.com,
	krzysztof.h1@poczta.fm, Pavel Kiryukhin <pkiryukhin@ru.mvista.com>,
	Steve Chen <schen@mvista.com>
References: <1247203174-11474-1-git-send-email-sudhakar.raj@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247203174-11474-1-git-send-email-sudhakar.raj@ti.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 191, 07 10, 2009 at 01:19:34AM -0400, Sudhakar Rajashekhara wrote:
> Adds LCD controller (LCDC) driver for TI's DA8xx/OMAP-L1xx
> architecture. LCDC specifications can be found at
> http://www.ti.com/litv/pdf/sprufm0a.
> 
> LCDC on DA8xx consists of two independent controllers, the
> Raster Controller and the LCD Interface Display Driver (LIDD)
> controller. LIDD further supports character and graphic displays.
> 
> This patch adds support for the graphic display (Sharp LQ035Q3DG01)
> found on the DA830 based EVM. The EVM details can be found at:
> http://support.spectrumdigital.com/boards/dskda830/revc/.
> 
> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> Signed-off-by: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
> Signed-off-by: Steve Chen <schen@mvista.com>
> Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
>  This patch applies to Linus's Kernel tree.


<SNIP>

> +static int __init fb_probe(struct platform_device *device)
> +{
> +	struct da8xx_lcdc_platform_data *fb_pdata =
> +						device->dev.platform_data;
> +	struct lcd_ctrl_config *lcd_cfg;
> +	struct da8xx_panel *lcdc_info;
> +	struct fb_info *da8xx_fb_info;
> +	struct resource *lcdc_regs;
> +	struct clk *fb_clk = NULL;
> +	struct da8xx_fb_par *par;
> +	resource_size_t len;
> +	int ret, i;
> +
> +	if (fb_pdata == NULL) {
> +		dev_err(&device->dev, "Can not get platform data\n");
> +		return -ENOENT;
> +	}
> +
> +	lcdc_regs = platform_get_resource(device, IORESOURCE_MEM, 0);
> +	if (!lcdc_regs) {
> +		dev_err(&device->dev,
> +			"Can not get memory resource for LCD controller\n");
> +		return -ENOENT;
> +	}
> +
> +	len = lcdc_regs->end - lcdc_regs->start + 1;
> +
> +	lcdc_regs = request_mem_region(lcdc_regs->start, len, lcdc_regs->name);
> +	if (!lcdc_regs)
> +		return -EBUSY;
> +
> +	da8xx_fb_reg_base = (resource_size_t)ioremap(lcdc_regs->start, len);

1. ioremap() can return NULL, so check is needed here;
2. ioremapped region is leaked in case of error and on module unload too.

> +	fb_clk = clk_get(&device->dev, NULL);
> +	if (IS_ERR(fb_clk)) {
> +		dev_err(&device->dev, "Can not get device clock\n");
> +		ret = -ENODEV;
> +		goto err_request_mem;
> +	}
> +	ret = clk_enable(fb_clk);
> +	if (ret)
> +		goto err_clk_put;
> +
> +	for (i = 0, lcdc_info = known_lcd_panels;
> +		i < ARRAY_SIZE(known_lcd_panels);
> +		i++, lcdc_info++) {
> +		if (strcmp(fb_pdata->type, lcdc_info->name) == 0)
> +			break;
> +	}
> +
> +	if (i == ARRAY_SIZE(known_lcd_panels)) {
> +		dev_err(&device->dev, "GLCD: No valid panel found\n");
> +		ret = ENODEV;
> +		goto err_clk_disable;
> +	} else
> +		dev_info(&device->dev, "GLCD: Found %s panel\n",
> +					fb_pdata->type);
> +
> +	lcd_cfg = (struct lcd_ctrl_config *)fb_pdata->controller_data;
> +
> +	da8xx_fb_info = framebuffer_alloc(sizeof(struct da8xx_fb_par),
> +					&device->dev);
> +	if (!da8xx_fb_info) {
> +		dev_dbg(&device->dev, "Memory allocation failed for fb_info\n");
> +		ret = -ENOMEM;
> +		goto err_clk_disable;
> +	}
> +
> +	par = da8xx_fb_info->par;
> +
> +	if (lcd_init(par, lcd_cfg, lcdc_info) < 0) {
> +		dev_err(&device->dev, "lcd_init failed\n");
> +		ret = -EFAULT;
> +		goto err_release_fb;
> +	}
> +
> +	/* allocate frame buffer */
> +	da8xx_fb_info->screen_base = dma_alloc_coherent(NULL,
> +					par->databuf_sz + PAGE_SIZE,
> +					(resource_size_t *)
> +					&da8xx_fb_info->fix.smem_start,
> +					GFP_KERNEL | GFP_DMA);
> +
> +	if (!da8xx_fb_info->screen_base) {
> +		dev_err(&device->dev,
> +			"GLCD: kmalloc for frame buffer failed\n");
> +		ret = -EINVAL;
> +		goto err_release_fb;
> +	}
> +
> +	/* move palette base pointer by (PAGE_SIZE - palette_sz) bytes */
> +	par->v_palette_base = da8xx_fb_info->screen_base +
> +				(PAGE_SIZE - par->palette_sz);
> +	par->p_palette_base = da8xx_fb_info->fix.smem_start +
> +				(PAGE_SIZE - par->palette_sz);
> +
> +	/* the rest of the frame buffer is pixel data */
> +	da8xx_fb_info->screen_base = par->v_palette_base + par->palette_sz;
> +	da8xx_fb_fix.smem_start = par->p_palette_base + par->palette_sz;
> +	da8xx_fb_fix.smem_len = par->databuf_sz - par->palette_sz;
> +	da8xx_fb_fix.line_length = (lcdc_info->width * lcd_cfg->bpp) / 8;
> +
> +	par->lcdc_clk = fb_clk;
> +
> +	init_waitqueue_head(&par->da8xx_wq);
> +
> +	par->irq = platform_get_irq(device, 0);
> +	if (par->irq < 0) {
> +		ret = -ENOENT;
> +		goto err_release_fb_mem;
> +	}
> +
> +	ret = request_irq(par->irq, lcdc_irq_handler, 0, DRIVER_NAME, par);
> +	if (ret)
> +		goto err_release_fb_mem;
> +
> +	/* Initialize par */
> +	da8xx_fb_info->var.bits_per_pixel = lcd_cfg->bpp;
> +
> +	da8xx_fb_var.xres = lcdc_info->width;
> +	da8xx_fb_var.xres_virtual = lcdc_info->width;
> +
> +	da8xx_fb_var.yres = lcdc_info->height;
> +	da8xx_fb_var.yres_virtual = lcdc_info->height;
> +
> +	da8xx_fb_var.grayscale =
> +	    lcd_cfg->p_disp_panel->panel_shade == MONOCHROME ? 1 : 0;
> +	da8xx_fb_var.bits_per_pixel = lcd_cfg->bpp;
> +
> +	da8xx_fb_var.hsync_len = lcdc_info->hsw;
> +	da8xx_fb_var.vsync_len = lcdc_info->vsw;
> +
> +	/* Initialize fbinfo */
> +	da8xx_fb_info->flags = FBINFO_FLAG_DEFAULT;
> +	da8xx_fb_info->fix = da8xx_fb_fix;
> +	da8xx_fb_info->var = da8xx_fb_var;
> +	da8xx_fb_info->fbops = &da8xx_fb_ops;
> +	da8xx_fb_info->pseudo_palette = par->pseudo_palette;
> +
> +	ret = fb_alloc_cmap(&da8xx_fb_info->cmap, PALETTE_SIZE, 0);
> +	if (ret)
> +		goto err_free_irq;
> +
> +	/* First palette_sz byte of the frame buffer is the palette */
> +	da8xx_fb_info->cmap.len = par->palette_sz;
> +
> +	/* Flush the buffer to the screen. */
> +	lcd_blit(LOAD_DATA, par);
> +
> +	/* initialize var_screeninfo */
> +	da8xx_fb_var.activate = FB_ACTIVATE_FORCE;
> +	fb_set_var(da8xx_fb_info, &da8xx_fb_var);
> +
> +	dev_set_drvdata(&device->dev, da8xx_fb_info);
> +	/* Register the Frame Buffer  */
> +	if (register_framebuffer(da8xx_fb_info) < 0) {
> +		dev_err(&device->dev,
> +			"GLCD: Frame Buffer Registration Failed!\n");
> +		ret = -EINVAL;
> +		goto err_dealloc_cmap;
> +	}
> +
> +	/* enable raster engine */
> +	lcdc_write(lcdc_read(LCD_RASTER_CTRL_REG) |
> +			LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
> +
> +	return 0;
> +
> +err_dealloc_cmap:
> +	fb_dealloc_cmap(&da8xx_fb_info->cmap);
> +
> +err_free_irq:
> +	free_irq(par->irq, NULL);
> +
> +err_release_fb_mem:
> +	dma_free_coherent(NULL, par->databuf_sz + PAGE_SIZE,
> +				da8xx_fb_info->screen_base,
> +				da8xx_fb_info->fix.smem_start);
> +
> +err_release_fb:
> +	framebuffer_release(da8xx_fb_info);
> +
> +err_clk_disable:
> +	clk_disable(fb_clk);
> +
> +err_clk_put:
> +	clk_put(fb_clk);
> +
> +err_request_mem:
> +	release_mem_region(lcdc_regs->start, len);;
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_PM
> +static int fb_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +	 return -EBUSY;
> +}
> +static int fb_resume(struct platform_device *dev)
> +{
> +	 return -EBUSY;
> +}
> +#else
> +#define fb_suspend NULL
> +#define fb_resume NULL
> +#endif
> +
> +static struct platform_driver da8xx_fb_driver = {
> +	.probe = fb_probe,
> +	.remove = fb_remove,
> +	.suspend = fb_suspend,
> +	.resume = fb_resume,
> +	.driver = {
> +		   .name = DRIVER_NAME,
> +		   .owner = THIS_MODULE,
> +		   },
> +};
> +
> +static int __init da8xx_fb_init(void)
> +{
> +	return platform_driver_register(&da8xx_fb_driver);
> +}
> +
> +static void __exit da8xx_fb_cleanup(void)
> +{
> +	platform_driver_unregister(&da8xx_fb_driver);
> +}
> +
> +module_init(da8xx_fb_init);
> +module_exit(da8xx_fb_cleanup);
> +
> +MODULE_DESCRIPTION("Framebuffer driver for TI da8xx/omap-l1xx");
> +MODULE_AUTHOR("Texas Instruments");
> +MODULE_LICENSE("GPL");
> diff --git a/include/video/da8xx-fb.h b/include/video/da8xx-fb.h
> new file mode 100644
> index 0000000..5f77675
> --- /dev/null
> +++ b/include/video/da8xx-fb.h
> @@ -0,0 +1,106 @@
> +/*
> + * Header file for TI DA8XX LCD controller platform data.
> + *
> + * Copyright (C) 2008-2009 MontaVista Software Inc.
> + * Copyright (C) 2008-2009 Texas Instruments Inc
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef DA8XX_FB_H
> +#define DA8XX_FB_H
> +
> +enum panel_type {
> +	QVGA = 0
> +};
> +
> +enum panel_shade {
> +	MONOCHROME = 0,
> +	COLOR_ACTIVE,
> +	COLOR_PASSIVE,
> +};
> +
> +enum raster_load_mode {
> +	LOAD_DATA = 1,
> +	LOAD_PALETTE,
> +};
> +
> +struct display_panel {
> +	enum panel_type panel_type; /* QVGA */
> +	int max_bpp;
> +	int min_bpp;
> +	enum panel_shade panel_shade;
> +};
> +
> +struct da8xx_lcdc_platform_data {
> +	const char manu_name[10];
> +	void *controller_data;
> +	const char type[25];
> +};
> +
> +struct lcd_ctrl_config {
> +	const struct display_panel *p_disp_panel;
> +
> +	/* AC Bias Pin Frequency */
> +	int ac_bias;
> +
> +	/* AC Bias Pin Transitions per Interrupt */
> +	int ac_bias_intrpt;
> +
> +	/* DMA burst size */
> +	int dma_burst_sz;
> +
> +	/* Bits per pixel */
> +	int bpp;
> +
> +	/* FIFO DMA Request Delay */
> +	int fdd;
> +
> +	/* TFT Alternative Signal Mapping (Only for active) */
> +	unsigned char tft_alt_mode;
> +
> +	/* 12 Bit Per Pixel (5-6-5) Mode (Only for passive) */
> +	unsigned char stn_565_mode;
> +
> +	/* Mono 8-bit Mode: 1=D0-D7 or 0=D0-D3 */
> +	unsigned char mono_8bit_mode;
> +
> +	/* Invert pixel clock */
> +	unsigned char invert_pxl_clock;
> +
> +	/* Invert line clock */
> +	unsigned char invert_line_clock;
> +
> +	/* Invert frame clock  */
> +	unsigned char invert_frm_clock;
> +
> +	/* Horizontal and Vertical Sync Edge: 0=rising 1=falling */
> +	unsigned char sync_edge;
> +
> +	/* Horizontal and Vertical Sync: Control: 0=ignore */
> +	unsigned char sync_ctrl;
> +
> +	/* Raster Data Order Select: 1=Most-to-least 0=Least-to-most */
> +	unsigned char raster_order;
> +};
> +
> +struct lcd_sync_arg {
> +	int back_porch;
> +	int front_porch;
> +	int pulse_width;
> +};
> +
> +/* ioctls */
> +#define FBIOGET_CONTRAST	_IOR('F', 1, int)
> +#define FBIOPUT_CONTRAST	_IOW('F', 2, int)
> +#define FBIGET_BRIGHTNESS	_IOR('F', 3, int)
> +#define FBIPUT_BRIGHTNESS	_IOW('F', 3, int)
> +#define FBIGET_COLOR		_IOR('F', 5, int)
> +#define FBIPUT_COLOR		_IOW('F', 6, int)
> +#define FBIPUT_HSYNC		_IOW('F', 9, int)
> +#define FBIPUT_VSYNC		_IOW('F', 10, int)
> +
> +#endif  /* ifndef DA8XX_FB_H */
> +
> -- 
> 1.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
