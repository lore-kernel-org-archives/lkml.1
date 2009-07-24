Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZGXVY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZGXVY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbZGXVY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:24:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396AbZGXVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:24:58 -0400
Date: Fri, 24 Jul 2009 14:23:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       davinci-linux-open-source@linux.davincidsp.com, krzysztof.h1@poczta.fm,
       sudhakar.raj@ti.com, pkiryukhin@ru.mvista.com, schen@mvista.com
Subject: Re: [PATCH v4] davinci: fb: Frame Buffer driver for TI
 DA8xx/OMAP-L1xx
Message-Id: <20090724142336.2b9b4082.akpm@linux-foundation.org>
In-Reply-To: <1248238020-8266-1-git-send-email-sudhakar.raj@ti.com>
References: <1248238020-8266-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 00:47:00 -0400
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
> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> Signed-off-by: Pavel Kiryukhin <pkiryukhin@ru.mvista.com>
> Signed-off-by: Steve Chen <schen@mvista.com>
> Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
>  This patch applies to Linus's Kernel tree.
> 
>  Since the previous version, return values in ioctl()
>  function have been modified.

That wasn't the only change in version 4:

--- a/drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4
+++ a/drivers/video/da8xx-fb.c
@@ -201,14 +201,13 @@ static int lcd_disable_raster(struct da8
 		ret = wait_event_interruptible_timeout(par->da8xx_wq,
 						!lcdc_read(LCD_STAT_REG) &
 						LCD_END_OF_FRAME0, WSI_TIMEOUT);
+		if (ret < 0)
+			return ret;
+		if (ret == 0)
+			ret = -ETIMEDOUT;
 	}
 
-	if (ret < 0)
-		return ret;
-	if (ret == 0)
-		return -ETIMEDOUT;
-
-	return 0;
+	return ret;
 }
 
 static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
@@ -634,11 +633,11 @@ static int fb_ioctl(struct fb_info *info
 	case FBIPUT_BRIGHTNESS:
 	case FBIGET_COLOR:
 	case FBIPUT_COLOR:
-		return -EINVAL;
+		return -ENOTTY;
 	case FBIPUT_HSYNC:
 		if (copy_from_user(&sync_arg, (char *)arg,
 				sizeof(struct lcd_sync_arg)))
-			return -EINVAL;
+			return -EFAULT;
 		lcd_cfg_horizontal_sync(sync_arg.back_porch,
 					sync_arg.pulse_width,
 					sync_arg.front_porch);
@@ -646,7 +645,7 @@ static int fb_ioctl(struct fb_info *info
 	case FBIPUT_VSYNC:
 		if (copy_from_user(&sync_arg, (char *)arg,
 				sizeof(struct lcd_sync_arg)))
-			return -EINVAL;
+			return -EFAULT;
 		lcd_cfg_vertical_sync(sync_arg.back_porch,
 					sync_arg.pulse_width,
 					sync_arg.front_porch);
_


Was that intentional?


The change to lcd_disable_raster() is a bit odd:

static int lcd_disable_raster(struct da8xx_fb_par *par)
{
	int ret = 0;
	u32 reg;

	reg = lcdc_read(LCD_RASTER_CTRL_REG);
	if (reg & LCD_RASTER_ENABLE) {
		lcdc_write(reg & ~LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
		ret = wait_event_interruptible_timeout(par->da8xx_wq,
						!lcdc_read(LCD_STAT_REG) &
						LCD_END_OF_FRAME0, WSI_TIMEOUT);
		if (ret < 0)
			return ret;
		if (ret == 0)
			ret = -ETIMEDOUT;
	}

	return ret;
}


We can do this, yes?

--- a/drivers/video/da8xx-fb.c~davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup
+++ a/drivers/video/da8xx-fb.c
@@ -201,8 +201,6 @@ static int lcd_disable_raster(struct da8
 		ret = wait_event_interruptible_timeout(par->da8xx_wq,
 						!lcdc_read(LCD_STAT_REG) &
 						LCD_END_OF_FRAME0, WSI_TIMEOUT);
-		if (ret < 0)
-			return ret;
 		if (ret == 0)
 			ret = -ETIMEDOUT;
 	}
_

