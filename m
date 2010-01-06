Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730Ab0AFAUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0AFAUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320Ab0AFAUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:20:23 -0500
Received: from mga06.intel.com ([134.134.136.21]:39311 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752036Ab0AFAUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:20:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,225,1262592000"; 
   d="scan'208";a="481579007"
Date: Wed, 6 Jan 2010 01:21:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, ian@mnementh.co.uk, linux-sh@vger.kernel.org
Subject: Re: [PATCH] MMC: hardware abstraction for CNF area
Message-ID: <20100106002158.GM4274@sortiz.org>
References: <20100105050914.32264.762.sendpatchset@rxone.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105050914.32264.762.sendpatchset@rxone.opensource.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tue, Jan 05, 2010 at 02:09:14PM +0900, Magnus Damm wrote:
> From: Ian Molton <ian@mnementh.co.uk>
> 
> This patch abstracts out the CNF area code from tmio_mmc which
> is not present in all hardware that can use this driver. This
> is required so that we can support non-toshiba based hardware.
> 
> ASIC3 support by Philipp Zabel
> 
> [ Magnus Damm: extracted patch from git.mnementh.co.uk, tried
>   to apply on top of current linux-2.6 but got rejects due to
>   -mm patch 14f1b75b1d31673d7ab6ac6d2f8fe7f23c705229, solved
>   conflict by hand, regenerated patch and posted to lkml ]
Thanks for taking care of that.
I wish I could take this patch straight away, but I have some objections, see
below:

> +	.suspend       = asic3_mmc_disable,
> +	.resume        = asic3_mmc_enable,
Why are we moving from enable/disable to resume/suspend ?
It makes sense from a naming point of view, but that should be in a separate
patch.

> +static const struct resource t7l66xb_mmc_resources[];
Could we simply move the t7l66xb_mmc_resources[] definition here instead ?


> --- 0001/drivers/mfd/tc6387xb.c
> +++ work/drivers/mfd/tc6387xb.c	2010-01-05 13:27:31.000000000 +0900
> @@ -22,28 +22,41 @@ enum {
>  	TC6387XB_CELL_MMC,
>  };
>  
> +struct tc6387xb {
> +	void __iomem *scr;
> +	struct clk *clk32k;
> +	struct resource rscr;
> +};
> +
> +static struct resource tc6387xb_mmc_resources[];
Same here.

> --- /dev/null
> +++ work/drivers/mfd/tmio_core.c	2010-01-05 13:27:31.000000000 +0900
> @@ -0,0 +1,62 @@
> +/*
> + * Toshiba TC6393XB SoC support
Bogus comment.


> + * Copyright(c) 2009 Ian Molton <spyro@f2s.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/mfd/tmio.h>
> +
> +static int shift;
That I dont like. Carry the shift as a function argument, because there is no
reason to have a static variable here.
In fact, we could even move this code to tmio_mmc.c and export the symbols
from there. The tmio_mmc code know the bus shift, doesnt it ?

> --- 0001/drivers/mmc/host/tmio_mmc.c
> +++ work/drivers/mmc/host/tmio_mmc.c	2010-01-05 13:28:07.000000000 +0900
> @@ -46,7 +46,9 @@ static void tmio_mmc_set_clock(struct tm
>  		clk |= 0x100;
>  	}
>  
> -	sd_config_write8(host, CNF_SD_CLK_MODE, clk >> 22);
> +	if (host->set_no_clk_div)
> +		host->set_no_clk_div(host->pdev, (clk>>22) & 1);
> +
You either need a backup path or make the set_no_clk_div() implementation
mandatory. IOW, we should at least call tmio_core_mmc_clk_div() if
set_no_clk_div() is not defined. Or then if you assume that all tmio drivers
must implement those hooks, then return if it's not there. I would prefer the
former option though as that would allow me to split this patch into what I
see as .33 material (tmio_mmc.[ch], tmio_core.c [that I would rather see moved
to tmio_mmc.c], and tmio.h)

> -		sd_config_write8(host, CNF_PWR_CTL_2, 0x00);
> +		if (host->set_pwr)
> +			host->set_pwr(host->pdev, 0);
Ditto.


>  		tmio_mmc_clk_stop(host);
>  		break;
>  	case MMC_POWER_ON: /* power up SD bus */
> -
> -		sd_config_write8(host, CNF_PWR_CTL_2, 0x02);
> +		if (host->set_pwr)
> +			host->set_pwr(host->pdev, 1);
Ditto.


>  		break;
>  	case MMC_POWER_UP: /* start bus clock */
>  		tmio_mmc_clk_start(host);
> @@ -475,8 +478,8 @@ static int tmio_mmc_suspend(struct platf
>  	ret = mmc_suspend_host(mmc, state);
>  
>  	/* Tell MFD core it can disable us now.*/
> -	if (!ret && cell->disable)
> -		cell->disable(dev);
> +	if (!ret && cell->suspend)
> +		cell->suspend(dev);
That sort of change doesnt belong to that patch, unless I'm missing something.


> +	/* Callbacks for clock / power control */
> +	void (*set_pwr)(struct platform_device *host, int state);
> +	void (*set_no_clk_div)(struct platform_device *host, int state);
The name is a bit misleading, imo. Wouldn't set_clk_div() be more appropriate?


> +
>  	/* pio related stuff */
>  	struct scatterlist      *sg_ptr;
>  	unsigned int            sg_len;
>  	unsigned int            sg_off;
> +
> +	struct platform_device *pdev;
>  };
>  
>  #include <linux/io.h>
> @@ -163,25 +148,6 @@ static inline void sd_ctrl_write32(struc
>  	writew(val >> 16, host->ctl + ((addr + 2) << host->bus_shift));
>  }
>  
> -static inline void sd_config_write8(struct tmio_mmc_host *host, int addr,
> -		u8 val)
> -{
> -	writeb(val, host->cnf + (addr << host->bus_shift));
> -}
> -
> -static inline void sd_config_write16(struct tmio_mmc_host *host, int addr,
> -		u16 val)
> -{
> -	writew(val, host->cnf + (addr << host->bus_shift));
> -}
> -
> -static inline void sd_config_write32(struct tmio_mmc_host *host, int addr,
> -		u32 val)
> -{
> -	writew(val, host->cnf + (addr << host->bus_shift));
> -	writew(val >> 16, host->cnf + ((addr + 2) << host->bus_shift));
> -}
> -
>  #include <linux/scatterlist.h>
>  #include <linux/blkdev.h>
>  
> --- 0001/include/linux/mfd/tmio.h
> +++ work/include/linux/mfd/tmio.h	2010-01-05 13:27:31.000000000 +0900
> @@ -2,6 +2,8 @@
>  #define MFD_TMIO_H
>  
>  #include <linux/fb.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
>  
>  #define tmio_ioread8(addr) readb(addr)
>  #define tmio_ioread16(addr) readw(addr)
> @@ -18,11 +20,49 @@
>  	writew((val) >> 16, (addr) + 2); \
>  	} while (0)
>  
> +#define CNF_CMD     0x04
> +#define CNF_CTL_BASE   0x10
> +#define CNF_INT_PIN  0x3d
> +#define CNF_STOP_CLK_CTL 0x40
> +#define CNF_GCLK_CTL 0x41
> +#define CNF_SD_CLK_MODE 0x42
> +#define CNF_PIN_STATUS 0x44
> +#define CNF_PWR_CTL_1 0x48
> +#define CNF_PWR_CTL_2 0x49
> +#define CNF_PWR_CTL_3 0x4a
> +#define CNF_CARD_DETECT_MODE 0x4c
> +#define CNF_SD_SLOT 0x50
> +#define CNF_EXT_GCLK_CTL_1 0xf0
> +#define CNF_EXT_GCLK_CTL_2 0xf1
> +#define CNF_EXT_GCLK_CTL_3 0xf9
> +#define CNF_SD_LED_EN_1 0xfa
> +#define CNF_SD_LED_EN_2 0xfe
> +
> +#define   SDCREN 0x2   /* Enable access to MMC CTL regs. (flag in COMMAND_REG)*/
> +
> +#define sd_config_write8(base, shift, reg, val) \
> +	tmio_iowrite8((val), (base) + ((reg) << (shift)))
> +#define sd_config_write16(base, shift, reg, val) \
> +	tmio_iowrite16((val), (base) + ((reg) << (shift)))
> +#define sd_config_write32(base, shift, reg, val) \
> +	do { \
> +	tmio_iowrite16((val), (base) + ((reg) << (shift))); \
> +	tmio_iowrite16((val) >> 16, (base) + ((reg + 2) << (shift))); \
> +	} while (0)
By implementing the tmio_core API in tmio_mmc.c, you wouldnt need to redefine
those.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
