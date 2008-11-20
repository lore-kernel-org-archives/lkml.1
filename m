Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbYKTUxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbYKTUxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbYKTUvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:41 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22344 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756246AbYKTUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cypMwTY3LycjXR8+3s/x5YVgKhjJyBQXP0QDyHH5bGiR3o0+vzO6ZyMjnjFZaUUVfyIGdctL9s1MXwOi2IUsf6jsEDJhrtGlhqfr+bIii6wruDsPSVQv0Sl1p1kK/DgaBEL9FC+SBXN9sNZ5IdLns1OTxgQLazEwxpKKzSGEsiw=  ;
X-YMail-OSG: x1pP58UVM1ljSWy3R8wZ1yJzmr2exoIThb75I_fVeLRQZ98DR7kmWG0_HIdY5HVHEz78HtGtdWQp5VyKe9qDTkxDA7MQohQD28wsA8cvPMguKKFlB3m80UfIs_D2UWtjldnvM33dEogzz_G7In2dk4ad.MMwOXAKBcSwBTeFMQTdxgiIsC78eh6fIiJD
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 06/16] Blackfin SPI Driver: unify duplicated code in dma read/write paths
Date: Thu, 20 Nov 2008 12:32:16 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-7-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-7-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201232.16712.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

assuming:  this patch grows a real patch comment
instead of only having the long $SUBJECT ...


> ---
>  drivers/spi/spi_bfin5xx.c |   47 ++++++++++++++++++++------------------------
>  1 files changed, 21 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index 642c402..df424a2 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -755,18 +755,19 @@ static void pump_transfers(unsigned long data)
>  	if (!full_duplex && drv_data->cur_chip->enable_dma
>  				&& drv_data->len > 6) {
>  
> +		unsigned long dma_start_addr;
> +
>  		disable_dma(drv_data->dma_channel);
>  		clear_dma_irqstat(drv_data->dma_channel);
>  		bfin_spi_disable(drv_data);
>  
>  		/* config dma channel */
>  		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
> +		set_dma_x_count(drv_data->dma_channel, drv_data->len);
>  		if (width == CFG_SPI_WORDSIZE16) {
> -			set_dma_x_count(drv_data->dma_channel, drv_data->len);
>  			set_dma_x_modify(drv_data->dma_channel, 2);
>  			dma_width = WDSIZE_16;
>  		} else {
> -			set_dma_x_count(drv_data->dma_channel, drv_data->len);
>  			set_dma_x_modify(drv_data->dma_channel, 1);
>  			dma_width = WDSIZE_8;
>  		}
> @@ -801,6 +802,7 @@ static void pump_transfers(unsigned long data)
>  		}
>  
>  		/* In dma mode, rx or tx must be NULL in one transfer */
> +		dma_config = (RESTART | dma_width | DI_EN);
>  		if (drv_data->rx != NULL) {
>  			/* set transfer mode, and enable SPI */
>  			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
> @@ -814,19 +816,9 @@ static void pump_transfers(unsigned long data)
>  			/* clear tx reg soformer data is not shifted out */
>  			write_TDBR(drv_data, 0xFFFF);
>  
> -			set_dma_x_count(drv_data->dma_channel, drv_data->len);
> -
> -			/* start dma */
> -			dma_enable_irq(drv_data->dma_channel);
> -			dma_config = (WNR | RESTART | dma_width | DI_EN);
> -			set_dma_config(drv_data->dma_channel, dma_config);
> -			set_dma_start_addr(drv_data->dma_channel,
> -					(unsigned long)drv_data->rx);
> -			enable_dma(drv_data->dma_channel);
> -
> -			/* start SPI transfer */
> -			write_CTRL(drv_data,
> -				(cr | CFG_SPI_DMAREAD | BIT_CTL_ENABLE));
> +			dma_config |= WNR;
> +			dma_start_addr = (unsigned long)drv_data->rx;
> +			cr |= CFG_SPI_DMAREAD;
>  
>  		} else if (drv_data->tx != NULL) {
>  			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
> @@ -837,18 +829,21 @@ static void pump_transfers(unsigned long data)
>  						(unsigned long) (drv_data->tx +
>  						drv_data->len_in_bytes));
>  
> -			/* start dma */
> -			dma_enable_irq(drv_data->dma_channel);
> -			dma_config = (RESTART | dma_width | DI_EN);
> -			set_dma_config(drv_data->dma_channel, dma_config);
> -			set_dma_start_addr(drv_data->dma_channel,
> -					(unsigned long)drv_data->tx);
> -			enable_dma(drv_data->dma_channel);
> +			dma_start_addr = (unsigned long)drv_data->tx;
> +			cr |= CFG_SPI_DMAWRITE;
> +
> +		} else
> +			BUG();
> +
> +		/* start dma */
> +		dma_enable_irq(drv_data->dma_channel);
> +		set_dma_config(drv_data->dma_channel, dma_config);
> +		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
> +		enable_dma(drv_data->dma_channel);
> +
> +		/* start SPI transfer */
> +		write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
>  
> -			/* start SPI transfer */
> -			write_CTRL(drv_data,
> -				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
> -		}
>  	} else {
>  		/* IO mode write then read */
>  		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
> -- 
> 1.5.6.3
> 
> 


