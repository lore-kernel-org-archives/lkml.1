Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZIXXd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZIXXd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZIXXd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:33:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbZIXXd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:33:58 -0400
Date: Thu, 24 Sep 2009 16:32:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com, cooloney@kernel.org
Subject: Re: [PATCH v2] fbdev: bfin-lq035q1-fb: new Blackfin Landscape LCD
 EZ-Extender driver
Message-Id: <20090924163240.d03127e3.akpm@linux-foundation.org>
In-Reply-To: <1253223426-5938-1-git-send-email-vapier@gentoo.org>
References: <1252950549-9838-1-git-send-email-vapier@gentoo.org>
	<1253223426-5938-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 17:37:06 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Framebuffer driver for the Landscape LCD EZ-Extender (ADZS-BFLLCD-EZEXT)
> http://docs.blackfin.uclinux.org/doku.php?id=hw:cards:landscape_lcd_ez-extender
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> ...
>
> +config FB_BFIN_LQ035Q1
> +	tristate "SHARP LQ035Q1DH02 TFT LCD"
> +	depends on FB && BLACKFIN
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	select BFIN_GPTIMERS
> +	select SPI

Are we sure about the `select SPI'?  There's only one other place in
the kernel which does this, and `select' often makes things explode.  I
fear that you're either selecting the wrong thing or you're selecting
something which won't work well.

> +	help
> +	  This is the framebuffer device driver for a SHARP LQ035Q1DH02 TFT display found on
> +	  the Blackfin Landscape LCD EZ-Extender Card.
> +	  This display is a QVGA 320x240 18-bit RGB display interfaced by an 16-bit wide PPI
> +	  It uses PPI[0..15] PPI_FS1, PPI_FS2 and PPI_CLK.
>  
>
> ...
>
> +
> +#define DRIVER_NAME "bfin-lq035q1"
> +static char driver_name[] = DRIVER_NAME;

Will the compielr magically put this string into read-only storage for
us, or should we do that manually with `const'?

>
> ...
>
> +static int lq035q1_control(unsigned char reg, unsigned short value)
> +{
> +	int ret;
> +	u8 regs[3] = {LQ035_INDEX, 0, 0};
> +	u8 dat[3] = {LQ035_DATA, 0, 0};
> +
> +	if (spi_control.spidev) {
> +		regs[2] = reg;
> +		dat[1] = value >> 8;
> +		dat[2] = value & 0xFF;
> +
> +		ret = spi_write(spi_control.spidev, regs, ARRAY_SIZE(regs));
> +		ret |= spi_write(spi_control.spidev, dat, ARRAY_SIZE(dat));
> +	} else
> +		return -ENODEV;
> +
> +	return ret;
> +}

I am suspecting that this function (and the similar ones below) rely
upon state within the hardware and will hence misbehave if two
instances are run concurrently.

Is that correct>  If so, is there locking to prevent this from occurring?

>
> ...
>

