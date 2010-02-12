Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab0BLGEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 01:04:14 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:55030 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0BLGEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 01:04:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PffROGX0FxWdFX/zfRQqBOIFd7PPBVNFTwjB4/+m8AQAJJVKWzrUqx2ltJZWbujogR
         MluxmDvDGXtrziZhNXxTNJ4JZeVqVhQndpZBSQIMyb2+ekZRnN2Xmd/Vqww3RnQPsD4k
         3LgudQu6rEjitmdQvBWES3k7uV4uNqcHYiCRo=
MIME-Version: 1.0
In-Reply-To: <1265917278-22011-1-git-send-email-swirl@gmx.li>
References: <1265917278-22011-1-git-send-email-swirl@gmx.li>
Date: Fri, 12 Feb 2010 13:55:57 +0800
Message-ID: <45a44e481002112155u68c806beg9fe0a3a122d09d25@mail.gmail.com>
Subject: Re: [RESEND][PATCHv2 4/4] OMAP: DSS2: Add Innolux 7" display for 
	DEVKIT8000
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Thomas Weber <swirl@gmx.li>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 3:41 AM, Thomas Weber <swirl@gmx.li> wrote:
> This patch adds the 7 inch display for the DEVKIT8000.
>
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  drivers/video/omap2/displays/Kconfig               |    8 ++-
>  drivers/video/omap2/displays/Makefile              |    1 +
>  .../video/omap2/displays/panel-innolux-at070tn83.c |  107 ++++++++++++++++++++
>  3 files changed, 115 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/video/omap2/displays/panel-innolux-at070tn83.c
>
> diff --git a/drivers/video/omap2/displays/Kconfig b/drivers/video/omap2/displays/Kconfig
> index b12a59c..ca6b372 100644
> --- a/drivers/video/omap2/displays/Kconfig
> +++ b/drivers/video/omap2/displays/Kconfig
> @@ -5,7 +5,7 @@ config PANEL_GENERIC
>         tristate "Generic Panel"
>         help
>          Generic panel driver.
> -         Used for DVI output for Beagle and OMAP3 SDP.
> +         Used for DVI output for Beagle, Devkit8000 and OMAP3 SDP.
>
>  config PANEL_SHARP_LS037V7DW01
>         tristate "Sharp LS037V7DW01 LCD Panel"
> @@ -13,6 +13,12 @@ config PANEL_SHARP_LS037V7DW01
>         help
>           LCD Panel used in TI's SDP3430 and EVM boards
>
> +config PANEL_INNOLUX_AT070TN83
> +       tristate "Innolux AT070TN83 LCD Panel"
> +       depends on OMAP2_DSS
> +       help
> +        LCD Panel used in TimLL's Devkit8000
> +
>  config PANEL_TAAL
>         tristate "Taal DSI Panel"
>         depends on OMAP2_DSS_DSI
> diff --git a/drivers/video/omap2/displays/Makefile b/drivers/video/omap2/displays/Makefile
> index 9556464..087b192 100644
> --- a/drivers/video/omap2/displays/Makefile
> +++ b/drivers/video/omap2/displays/Makefile
> @@ -2,3 +2,4 @@ obj-$(CONFIG_PANEL_GENERIC) += panel-generic.o
>  obj-$(CONFIG_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
>
>  obj-$(CONFIG_PANEL_TAAL) += panel-taal.o
> +obj-$(CONFIG_PANEL_INNOLUX_AT070TN83) += panel-innolux-at070tn83.o
> diff --git a/drivers/video/omap2/displays/panel-innolux-at070tn83.c b/drivers/video/omap2/displays/panel-innolux-at070tn83.c
> new file mode 100644
> index 0000000..f1d7f69
> --- /dev/null
> +++ b/drivers/video/omap2/displays/panel-innolux-at070tn83.c
> @@ -0,0 +1,107 @@
> +/*
> + * LCD panel driver for Innolux AT70TN83
> + *
> + * Copyright (C) 2010 Thomas Weber <weber@corscience.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/err.h>
> +
> +#include <plat/display.h>
> +
> +static struct omap_video_timings innolux_at_timings = {
> +       .x_res          = 800,
> +       .y_res          = 480,
> +
> +       .pixel_clock    = 40000,
> +
> +       .hsw            = 48,
> +       .hfp            = 1,
> +       .hbp            = 1,
> +
> +       .vsw            = 3,
> +       .vfp            = 12,
> +       .vbp            = 25,
> +};
> +
> +static int innolux_at_panel_probe(struct omap_dss_device *dssdev)
> +{
> +       dssdev->panel.config = OMAP_DSS_LCD_TFT | OMAP_DSS_LCD_IVS |
> +               OMAP_DSS_LCD_IHS;
> +       dssdev->panel.acb = 0x28;
> +       dssdev->panel.timings = innolux_at_timings;
> +
> +       return 0;
> +}
> +

Hi Thomas, Tomi,

Just curious, does this patch imply that code like this needs to be
written for every single LCD type and resolution that can be connected
to omap2? Maybe there is a better way, like a common table of timings
and values that can be selected with a module option or even
autodetected.

Thanks,
jaya
