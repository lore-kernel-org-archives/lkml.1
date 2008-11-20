Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYKTUxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYKTUxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYKTUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:40 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22335 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755956AbYKTUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TlpQBp3iV/QxVTdn2zwMFtt1C2xc10BCU1cFkmizN5Tn3BTAvC4WU7CEJQMzjr1y053fXWX/8fQpToSlb/XHNJaTgqz9W5pDEZ/wEN2B5LGx0nH1X3AI0MayJpG89MF1jqLvq9aOkDunN4hflTtsHqT6KMhOlR0ZA8ew4Zbar7Q=  ;
X-YMail-OSG: mQCyQGEVM1mifPsNGnv.KlZ1yLuKwez6gYOJ1UQU6Lu11LKzEwZsC0rir83.eO10USahDjRdouzh5E79iiLXb4z5SlmaE76bD4s1FuxdHjYnBe13gOHBF9H6gEARP8bNAzewYsiyXO6ojvQJiZKAIUE3prt37i2myhVJF7.EWZeQmGEArb.iKUsrKE8R
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 05/16] Blackfin SPI Driver: pass DMA overflow error to the higher level
Date: Thu, 20 Nov 2008 12:29:10 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-6-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-6-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201229.10924.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> If the SPI bus registers a receive overflow error,
> pass the result back up to the higher levels.
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  drivers/spi/spi_bfin5xx.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index cc415e8..642c402 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -559,6 +559,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
>  	struct driver_data *drv_data = dev_id;
>  	struct chip_data *chip = drv_data->cur_chip;
>  	struct spi_message *msg = drv_data->cur_msg;
> +	u16 spistat = read_STAT(drv_data);
>  
>  	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
>  	clear_dma_irqstat(drv_data->dma_channel);
> @@ -582,13 +583,18 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
>  	while (!(read_STAT(drv_data) & SPIF))
>  		cpu_relax();
>  
> -	msg->actual_length += drv_data->len_in_bytes;
> +	if (spistat & RBSY) {
> +		msg->state = ERROR_STATE;
> +		dev_err(&drv_data->pdev->dev, "dma receive: fifo/buffer overflow\n");
> +	} else {
> +		msg->actual_length += drv_data->len_in_bytes;
>  
> -	if (drv_data->cs_change)
> -		cs_deactive(drv_data, chip);
> +		if (drv_data->cs_change)
> +			cs_deactive(drv_data, chip);
>  
> -	/* Move to next transfer */
> -	msg->state = next_transfer(drv_data);
> +		/* Move to next transfer */
> +		msg->state = next_transfer(drv_data);
> +	}
>  
>  	/* Schedule transfer tasklet */
>  	tasklet_schedule(&drv_data->pump_transfers);
> -- 
> 1.5.6.3
> 
> 


