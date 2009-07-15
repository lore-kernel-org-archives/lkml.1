Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbZGOVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbZGOVCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932354AbZGOVCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:02:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340AbZGOVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:02:18 -0400
Date: Wed, 15 Jul 2009 14:00:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       davinci-linux-open-source@linux.davincidsp.com, krzysztof.h1@poczta.fm,
       sudhakar.raj@ti.com, pkiryukhin@ru.mvista.com, schen@mvista.com
Subject: Re: [PATCH v3] davinci: fb: Frame Buffer driver for TI
 DA8xx/OMAP-L1xx
Message-Id: <20090715140012.93397475.akpm@linux-foundation.org>
In-Reply-To: <1247644654-10952-1-git-send-email-sudhakar.raj@ti.com>
References: <1247644654-10952-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 03:57:34 -0400
Sudhakar Rajashekhara <sudhakar.raj@ti.com> wrote:

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
>
> ...
>
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2038,6 +2038,17 @@ config FB_SH7760
>  	  and 8, 15 or 16 bpp color; 90 degrees clockwise display rotation for
>  	  panels <= 320 pixel horizontal resolution.
>  
> +config FB_DA8XX
> +        tristate "DA8xx/OMAP-L1xx Framebuffer support"
> +        depends on FB && ARCH_DAVINCI_DA8XX
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	---help---
> +          This is the frame buffer device driver for the TI LCD controller
> +	  found on DA8xx/OMAP-L1xx SoCs.
> +          If unsure, say N.

Leading whitespace is all mucked up there - I fixed it.

>  config FB_VIRTUAL
>  	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
>  	depends on FB
>
> ...
>
> +/* Disable the Raster Engine of the LCD Controller */
> +static int lcd_disable_raster(struct da8xx_fb_par *par)
> +{
> +	int ret = 0;
> +	u32 reg;
> +
> +	reg = lcdc_read(LCD_RASTER_CTRL_REG);
> +	if (reg & LCD_RASTER_ENABLE) {
> +		lcdc_write(reg & ~LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
> +		ret = wait_event_interruptible_timeout(par->da8xx_wq,
> +						!lcdc_read(LCD_STAT_REG) &
> +						LCD_END_OF_FRAME0, WSI_TIMEOUT);
> +	}
> +
> +	if (ret < 0)
> +		return ret;
> +	if (ret == 0)
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}

This looks wrongish.  If LCD_RASTER_ENABLE is not set, it will return
-ETIMEDOUT without ever having waited for anything.

>
> ...
>
> +static int fb_ioctl(struct fb_info *info, unsigned int cmd,
> +			  unsigned long arg)
> +{
> +	struct lcd_sync_arg sync_arg;
> +
> +	switch (cmd) {
> +	case FBIOGET_CONTRAST:
> +	case FBIOPUT_CONTRAST:
> +	case FBIGET_BRIGHTNESS:
> +	case FBIPUT_BRIGHTNESS:
> +	case FBIGET_COLOR:
> +	case FBIPUT_COLOR:
> +		return -EINVAL;
> +	case FBIPUT_HSYNC:
> +		if (copy_from_user(&sync_arg, (char *)arg,
> +				sizeof(struct lcd_sync_arg)))
> +			return -EINVAL;

-EFAULT?

> +		lcd_cfg_horizontal_sync(sync_arg.back_porch,
> +					sync_arg.pulse_width,
> +					sync_arg.front_porch);
> +		break;
> +	case FBIPUT_VSYNC:
> +		if (copy_from_user(&sync_arg, (char *)arg,
> +				sizeof(struct lcd_sync_arg)))
> +			return -EINVAL;

-EFAULT?

> +		lcd_cfg_vertical_sync(sync_arg.back_porch,
> +					sync_arg.pulse_width,
> +					sync_arg.front_porch);
> +		break;
> +	default:
> +		return -EINVAL;

-ENOTTY?  (Maybe not - I forget)

> +	}
> +	return 0;
> +}
> +
>
> ...
>
