Return-Path: <linux-kernel-owner+w=401wt.eu-S932981AbXA2AIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbXA2AIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXA2AIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:08:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42912 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932981AbXA2AIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:08:37 -0500
Date: Sun, 28 Jan 2007 16:08:31 -0800
From: Andrew Morton <akpm@osdl.org>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] nvidiafb: allow ignoring EDID info
Message-Id: <20070128160831.fb51347f.akpm@osdl.org>
In-Reply-To: <ephv35$4i3$1@sea.gmane.org>
References: <ephv35$4i3$1@sea.gmane.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 11:48:59 +0100
Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:

> From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
> 
> Some nVidia video cards have broken EDID information. Using nvidiafb
> with CONFIG_FB_NVIDIA_I2C enabled on these systems causes the console
> framebuffer to use wrong timing information, causing the display to be
> extremely 'snowy'. Since most distribution kernels are compiled with
> CONFIG_FB_NVIDIA_I2C enabled, this prevents usage of the nvidia
> framebuffer on said broken system without recompiling the kernel
> (or at least the nvidiafb module).
> 
> Solve the issue by introducing a new boolean module parameter (useedid)
> which can be set to 0 to prevent the driver from using the EDID
> information.
> 
> If this patch is accepted, we can probably get rid of CONFIG_FB_NVIDIA_I2C
> altogether.
> 

That's a pretty sad solution.  Is it possible to detect these bad cards at
runtime via ther behaviour?  If not, can we generate a blacklist for the
known-bad cards based on PCI IDs or something?

Because most users won't even be aware of the module option: they'll just
know that their card doesn't work right.


> diff --git a/drivers/video/nvidia/nv_i2c.c b/drivers/video/nvidia/nv_i2c.c
> index 8454adf..6387f2b 100644
> --- a/drivers/video/nvidia/nv_i2c.c
> +++ b/drivers/video/nvidia/nv_i2c.c
> @@ -25,6 +25,8 @@
>  
>  #include "../edid.h"
>  
> +extern int useedid;
> +
>  static void nvidia_gpio_setscl(void *data, int state)
>  {
>         struct nvidia_i2c_chan *chan = data;
> @@ -128,6 +130,9 @@ static int nvidia_setup_i2c_bus(struct nvidia_i2c_chan *chan, const char *name)
>  
>  void nvidia_create_i2c_busses(struct nvidia_par *par)
>  {
> +       if (!useedid)
> +               return;
> +
>         par->bus = 3;
>  
>         par->chan[0].par = par;
> @@ -146,6 +151,9 @@ void nvidia_create_i2c_busses(struct nvidia_par *par)
>  
>  void nvidia_delete_i2c_busses(struct nvidia_par *par)
>  {
> +       if (!useedid)
> +               return;
> +
>         if (par->chan[0].par)
>                 i2c_del_adapter(&par->chan[0].adapter);
>         par->chan[0].par = NULL;
> @@ -195,6 +203,9 @@ static u8 *nvidia_do_probe_i2c_edid(struct nvidia_i2c_chan *chan)
>  
>  int nvidia_probe_i2c_connector(struct fb_info *info, int conn, u8 **out_edid)
>  {
> +       if (!useedid)
> +               return -1;
> +
>         struct nvidia_par *par = info->par;
>         u8 *edid = NULL;
>         int i;
> diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
> index 538e947..179fd67 100644
> --- a/drivers/video/nvidia/nvidia.c
> +++ b/drivers/video/nvidia/nvidia.c
> @@ -83,6 +83,9 @@ static int bpp __devinitdata = 8;
>  #ifdef CONFIG_MTRR
>  static int nomtrr __devinitdata = 0;
>  #endif
> +#ifdef CONFIG_FB_NVIDIA_I2C
> +int useedid __devinitdata = 1;
> +#endif
>  
>  static char *mode_option __devinitdata = NULL;
>  
> @@ -1506,6 +1509,11 @@ module_param(nomtrr, bool, 0);
>  MODULE_PARM_DESC(nomtrr, "Disables MTRR support (0 or 1=disabled) "
>                  "(default=0)");
>  #endif
> +#ifdef CONFIG_FB_NVIDIA_I2C
> +module_param(useedid, bool, 0);
> +MODULE_PARM_DESC(useedid, "Use EDID to detect video modes (0 or 1) "
> +                "(default=1, use EDID)");
> +#endif
>  
>  MODULE_AUTHOR("Antonino Daplas");
>  MODULE_DESCRIPTION("Framebuffer driver for nVidia graphics chipset");
> 
> 
> 
> 
> -- 
> Giuseppe "Oblomov" Bilotta
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
