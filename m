Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbYJIMH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbYJIMH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbYJIMGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:06:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:39510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759283AbYJIMF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:05:58 -0400
Subject: Re: [PATCH 08/13] mfd: Core support for the WM8350 AudioPlus PMIC
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1223296688-9960-8-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main>
	 <1223296688-9960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1223296688-9960-2-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1223296688-9960-3-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1223296688-9960-4-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1223296688-9960-5-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1223296688-9960-6-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1223296688-9960-7-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1223296688-9960-8-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 13:05:48 +0100
Message-Id: <1223553948.6814.291.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-06 at 13:38 +0100, Mark Brown wrote:

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 0541dfb..c32d676 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -86,6 +86,53 @@ config MFD_WM8400
>  	  the device, additional drivers must be enabled in order to use
>  	  the functionality of the device.
>  
> +config MFD_WM8350
> +	tristate
> +
> +config MFD_WM8350_CONFIG_MODE_0
> +	bool "Support WM8350 in configuration mode 0"
> +	depends on MFD_WM8350
> +	default y
> +	help
> +	  The WM8350 offers four configuration modes with different
> +	  initial register states.  This option enables support for the
> +	  WM8350 in mode 0.
> +
> +	  If unsure say Y

I would make the WM8350 mode configuration selectable by the target
machines Kconfig rather than let the user choose. Wrong choices would
probably mean broken hardware.   

>  
>  menu "Multimedia Capabilities Port drivers"
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 172439d..b0adca0 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -13,6 +13,8 @@ obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o
>  obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o
>  
>  obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
> +wm8350-objs			:= wm8350-core.o wm8350-regmap.o
> +obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
>  
>  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
>  
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> new file mode 100644
> index 0000000..c7552c0
> --- /dev/null
> +++ b/drivers/mfd/wm8350-core.c

> +
> +/*
> + * Cache is always host endian.
> + */
> +static int wm8350_create_cache(struct wm8350 *wm8350, int mode)
> +{
> +	int i, ret = 0;
> +	u16 value;
> +	const u16 *reg_map;
> +
> +	switch (mode) {
> +#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_0
> +	case 0:
> +		reg_map = wm8350_mode0_defaults;
> +		break;
> +#endif
> +#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_1
> +	case 1:
> +		reg_map = wm8350_mode1_defaults;
> +		break;
> +#endif
> +#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_2
> +	case 2:
> +		reg_map = wm8350_mode2_defaults;
> +		break;
> +#endif
> +#ifdef CONFIG_MFD_WM8350_CONFIG_MODE_3
> +	case 3:
> +		reg_map = wm8350_mode3_defaults;
> +		break;
> +#endif

Shouldn't this be #elif for each mode ?

Ditto for the default register values. I would also #error if no mode
was selected just to make it's correctly set by machine/board authors.

Liam


