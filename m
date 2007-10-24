Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXJXFZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXJXFZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXJXFZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:25:06 -0400
Received: from kukmak.uni-mb.si ([164.8.100.3]:35209 "EHLO kukmak.uni-mb.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbXJXFZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:25:04 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 01:25:04 EDT
Date: Wed, 24 Oct 2007 07:01:00 +0200
From: Domen Puncer <domen.puncer@telargo.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dragos Carp <dragos.carp@toptica.com>, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, domen.puncer@telargo.com,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] mpc5200: psc-spi driver must not touch port_config or cdm registers
Message-ID: <20071024050100.GA3369@nd47.coderock.org>
References: <20071024033457.8657.8708.stgit@trillian.cg.shawcable.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024033457.8657.8708.stgit@trillian.cg.shawcable.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/07 21:39 -0600, Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> port_config and the cdm are the responsibility of firmware; and if
> firmware doesn't set it up correctly, it should be fixed up by
> platform code on a per-board basis because it's a property of the
> board.
> 
> Drivers should never touch these registers.  They are completely
> unprotected and the platform may do odd things with them that the
> driver must not interfere with.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Domen, Dragos; can you please check your usage of this driver.  None of
> the in-tree board ports use it as-is, but they are of course just a
> device tree change away from being usable on the lite5200b.

My test cases were just a jumper on RX-TX line.

It's not even allowed to set mclken_div_pscX?
There can be different speed devices on same SPI
(spi_board_info->max_speed_hz).

> 
> Board ports that use it need to be modified to make the cdm/port_config
> changes in firmware (prefered) or in arch/powerpc/platforms/52xx/<board>.c
> 
> Cheers,
> g.
> 
>  drivers/spi/mpc52xx_psc_spi.c |   77 +----------------------------------------
>  1 files changed, 2 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
> index 7051e6c..ec3a618 100644
> --- a/drivers/spi/mpc52xx_psc_spi.c
> +++ b/drivers/spi/mpc52xx_psc_spi.c
> @@ -328,78 +328,15 @@ static void mpc52xx_psc_spi_cleanup(struct spi_device *spi)
>  	kfree(spi->controller_state);
>  }
>  
> -static int mpc52xx_psc_spi_port_config(int psc_id, struct mpc52xx_psc_spi *mps)
> +static void mpc52xx_psc_spi_config(int psc_id, struct mpc52xx_psc_spi *mps)
>  {
> -	struct mpc52xx_cdm __iomem *cdm;
> -	struct mpc52xx_gpio __iomem *gpio;
>  	struct mpc52xx_psc __iomem *psc = mps->psc;
> -	u32 ul;
>  	u32 mclken_div;
> -	int ret = 0;
> -
> -#if defined(CONFIG_PPC_MERGE)
> -	cdm = mpc52xx_find_and_map("mpc5200-cdm");
> -	gpio = mpc52xx_find_and_map("mpc5200-gpio");
> -#else
> -	cdm = ioremap(MPC52xx_PA(MPC52xx_CDM_OFFSET), MPC52xx_CDM_SIZE);
> -	gpio = ioremap(MPC52xx_PA(MPC52xx_GPIO_OFFSET), MPC52xx_GPIO_SIZE);
> -#endif
> -	if (!cdm || !gpio) {
> -		printk(KERN_ERR "Error mapping CDM/GPIO\n");
> -		ret = -EFAULT;
> -		goto unmap_regs;
> -	}
>  
>  	/* default sysclk is 512MHz */
>  	mclken_div = 0x8000 |
>  		(((mps->sysclk ? mps->sysclk : 512000000) / MCLK) & 0x1FF);

It's actually 528e6, and mclken_div doesn't seem to be used anywhere anymore.

>  
> -	switch (psc_id) {
> -	case 1:
...


	Domen
