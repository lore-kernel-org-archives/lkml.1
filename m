Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYKTUyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYKTUyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbYKTUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:45 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22382 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756880AbYKTUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IhOB772Flvw3k6USQufFed+D8h40SolRcb2qB0KES/s8Lt56NIDnaQmY6yhPb7RfVlJTupzYZ0g0xxAV67WcaYWWEHzYv7crxntYHr0W/s7g9MbzKM6rQ4jEstQlxymNH2/S9XrDRiZlULkGGmoRGl+WZEixR80aCL4ugQzALFY=  ;
X-YMail-OSG: ZcwVuE8VM1nDFD8yFloUXkQdfKfXSOVyiGx1_5_tG_uSYgO1vRzRld8UkO4O6vvXorRlM_mFJzi5V_lcqkcbrq.DzO.ByeezUw0LkbdiIhUp90DRSByeAXq2h3RLlTQK.03dN9tYtnpanWpgITgtJK45
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 12/16] Blackfin SPI Driver: get dma working for SPI flashes
Date: Thu, 20 Nov 2008 12:43:32 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-13-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-13-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201243.32749.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> When using a BF533-STAMP here with a W25X10 SPI flash. It works fine when
> enable_dma is disabled, but doesn't work at all when turning DMA on.
> We get just 0xff bytes back when trying to read the device.
> 
> If change the code around so that it programs the SPI first and then
> enables DMA, it seems to work a lot better ...
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... and I observe some MM patches from you related to bugs
identifying those chips; good to know I wasn't the only
one to trip over those regressions!


> ---
>  drivers/spi/spi_bfin5xx.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index fba77c2..5cd4873 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -760,11 +760,10 @@ static void pump_transfers(unsigned long data)
>  	if (!full_duplex && drv_data->cur_chip->enable_dma
>  				&& drv_data->len > 6) {
>  
> -		unsigned long dma_start_addr;
> +		unsigned long dma_start_addr, flags;
>  
>  		disable_dma(drv_data->dma_channel);
>  		clear_dma_irqstat(drv_data->dma_channel);
> -		bfin_spi_disable(drv_data);
>  
>  		/* config dma channel */
>  		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
> @@ -795,8 +794,7 @@ static void pump_transfers(unsigned long data)
>  			enable_dma(drv_data->dma_channel);
>  
>  			/* start SPI transfer */
> -			write_CTRL(drv_data,
> -				(cr | BIT_CTL_TIMOD_DMA_TX | BIT_CTL_ENABLE));
> +			write_CTRL(drv_data, cr | BIT_CTL_TIMOD_DMA_TX);
>  
>  			/* just return here, there can only be one transfer
>  			 * in this mode
> @@ -838,14 +836,22 @@ static void pump_transfers(unsigned long data)
>  		} else
>  			BUG();
>  
> -		/* start dma */
> -		dma_enable_irq(drv_data->dma_channel);
> -		set_dma_config(drv_data->dma_channel, dma_config);
> +		/* oh man, here there be monsters ... and i dont mean the
> +		 * fluffy cute ones from pixar, i mean the kind that'll eat
> +		 * your data, kick your dog, and love it all.  do *not* try
> +		 * and change these lines unless you (1) heavily test DMA
> +		 * with SPI flashes on a loaded system (e.g. ping floods),
> +		 * (2) know just how broken the DMA engine interaction with
> +		 * the SPI peripheral is, and (3) have someone else to blame
> +		 * when you screw it all up anyways.
> +		 */
>  		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
> +		set_dma_config(drv_data->dma_channel, dma_config);
> +		local_irq_save(flags);
>  		enable_dma(drv_data->dma_channel);
> -
> -		/* start SPI transfer */
> -		write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
> +		write_CTRL(drv_data, cr);
> +		dma_enable_irq(drv_data->dma_channel);
> +		local_irq_restore(flags);
>  
>  	} else {
>  		/* IO mode write then read */
> -- 
> 1.5.6.3
> 
> 


