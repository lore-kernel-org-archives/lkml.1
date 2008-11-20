Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYKTUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYKTUzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbYKTUvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:47 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22401 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756936AbYKTUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PCnUkOM3mgvxHPbQm29w/cZKaxUmDYA6kFyaVH1AQ3JRwPk3OtglZSVVTo9x5dPS8p8DVH3dXHPDlbCnloWcfQAxpIkDEsKF5RZFNoSWuMDYspSnUY/aTUgkoTvq3IzjxAXkev8ji+SKF7PUI5y9M+tAI6IHNK5zumva05+qIH8=  ;
X-YMail-OSG: 8OKQUFsVM1la0PglA1XTStmXPhLsbw7vW1vYEDtyuqsUBBClyA4NBEYnjTqzZDMeaTmgaAk47_Kx7621QWByyxYYh8874s2ms6hP0qqq0ygg2q0iW4P6WWNOFdfGwvaGmVyP0EDrzhaDjoIHkIzKZEZL
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 16/16] Blackfin SPI Driver: fix bug - correct usage of struct spi_transfer.cs_change
Date: Thu, 20 Nov 2008 12:51:33 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Yi Li <yi.li@analog.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-17-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-17-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201251.33339.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Yi Li <yi.li@analog.com>
> 
> According to comments in linux/spi/spi.h:
> 
>  * All SPI transfers start with the relevant chipselect active.  Normally
>  * it stays selected until after the last transfer in a message. Drivers
>  * can affect the chipselect signal using cs_change.
>  *
>  * (i) If the transfer isn't the last one in the message, this flag is
>  * used to make the chipselect briefly go inactive in the middle of the
>  * message.  Toggling chipselect in this way may be needed to terminate
>  * a chip command, letting a single spi_message perform all of group of
>  * chip transactions together.
>  *
>  * (ii) When the transfer is the last one in the message, the chip may
>  * stay selected until the next transfer.  On multi-device SPI busses
>  * with nothing blocking messages going to other devices, this is just
>  * a performance hint; starting a message to another device deselects
>  * this one.  But in other cases, this can be used to ensure correctness.
>  * Some devices need protocol transactions to be built from a series of
>  * spi_message submissions, where the content of one message is determined
>  * by the results of previous messages and where the whole transaction
>  * ends when the chipselect goes intactive.
> 
> Signed-off-by: Yi Li <yi.li@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  drivers/spi/spi_bfin5xx.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index 8cf5d6e..0e3102a 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -540,15 +540,13 @@ static void giveback(struct driver_data *drv_data)
>  
>  	msg->state = NULL;
>  
> -	/* disable chip select signal. And not stop spi in autobuffer mode */
> -	if (drv_data->tx_dma != 0xFFFF) {
> -		cs_deactive(drv_data, chip);
> -		bfin_spi_disable(drv_data);
> -	}
> -
>  	if (!drv_data->cs_change)
>  		cs_deactive(drv_data, chip);
>  
> +	/* Not stop spi in autobuffer mode */
> +	if (drv_data->tx_dma != 0xFFFF)
> +		bfin_spi_disable(drv_data);
> +
>  	if (msg->complete)
>  		msg->complete(msg->context);
>  }
> @@ -757,7 +755,8 @@ static void pump_transfers(unsigned long data)
>  
>  	write_STAT(drv_data, BIT_STAT_CLR);
>  	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
> -	cs_active(drv_data, chip);
> +	if (drv_data->cs_change)
> +		cs_active(drv_data, chip);
>  
>  	dev_dbg(&drv_data->pdev->dev,
>  		"now pumping a transfer: width is %d, len is %d\n",
> @@ -920,6 +919,8 @@ static void pump_transfers(unsigned long data)
>  			message->state = next_transfer(drv_data);
>  		}
>  
> +		if (drv_data->cs_change)
> +			cs_active(drv_data, chip);
>  		/* Schedule next transfer tasklet */
>  		tasklet_schedule(&drv_data->pump_transfers);
>  
> -- 
> 1.5.6.3
> 
> 


