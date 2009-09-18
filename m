Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZIRA3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZIRA3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZIRA3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:29:53 -0400
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:57358 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750741AbZIRA3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:29:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [spi-devel-general] [PATCH 2/2] mmc_spi: lock the SPI bus whenaccessing the card
Date: Thu, 17 Sep 2009 20:29:54 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901D41E4C@mi8nycmail19.Mi8.com>
In-Reply-To: <1253224997-7422-2-git-send-email-vapier@gentoo.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [spi-devel-general] [PATCH 2/2] mmc_spi: lock the SPI bus whenaccessing the card
Thread-Index: Aco34snHE+k/AAfXQmK/lwdRodzxFQAE8zrg
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org> <1253224997-7422-2-git-send-email-vapier@gentoo.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Mike Frysinger" <vapier@gentoo.org>,
       <spi-devel-general@lists.sourceforge.net>,
       "David Brownell" <dbrownell@users.sourceforge.net>
Cc: "Yi Li" <yi.li@analog.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Sep 2009 00:29:54.0908 (UTC) FILETIME=[24E779C0:01CA37F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 17, 2009 3:03 PM, Mike Frysinger wrote:
> From: Yi Li <yi.li@analog.com>
> 
> The MMC/SPI spec does not play well with typical SPI design -- it often
> needs to send out a command in one message, read a response, then do some
> other arbitrary step.  Since we can't let another SPI client use the bus
> during this time, use the new SPI lock/unlock functions to provide the
> required exclusivity.
> 
> Signed-off-by: Yi Li <yi.li@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/mmc/host/mmc_spi.c |   29 ++---------------------------
>  1 files changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index a461017..a96e058 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -1084,6 +1084,7 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  #endif
>  
>  	/* issue command; then optionally data and stop */
> +	spi_lock_bus(host->spi);
>  	status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
>  	if (status == 0 && mrq->data) {
>  		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
> @@ -1092,7 +1093,7 @@ static void mmc_spi_request(struct mmc_host *mmc, struct mmc_request *mrq)
>  		else
>  			mmc_cs_off(host);
>  	}
> -
> +	spi_unlock_bus(host->spi);
>  	mmc_request_done(host->mmc, mrq);
>  }
>  
> @@ -1337,32 +1338,6 @@ static int mmc_spi_probe(struct spi_device *spi)
>  		return status;
>  	}
>  
> -	/* We can use the bus safely iff nobody else will interfere with us.
> -	 * Most commands consist of one SPI message to issue a command, then
> -	 * several more to collect its response, then possibly more for data
> -	 * transfer.  Clocking access to other devices during that period will
> -	 * corrupt the command execution.
> -	 *
> -	 * Until we have software primitives which guarantee non-interference,
> -	 * we'll aim for a hardware-level guarantee.
> -	 *
> -	 * REVISIT we can't guarantee another device won't be added later...
> -	 */
> -	if (spi->master->num_chipselect > 1) {
> -		struct count_children cc;
> -
> -		cc.n = 0;
> -		cc.bus = spi->dev.bus;
> -		status = device_for_each_child(spi->dev.parent, &cc,
> -				maybe_count_child);
> -		if (status < 0) {
> -			dev_err(&spi->dev, "can't share SPI bus\n");
> -			return status;
> -		}
> -
> -		dev_warn(&spi->dev, "ASSUMING SPI bus stays unshared!\n");
> -	}
> -
>  	/* We need a supply of ones to transmit.  This is the only time
>  	 * the CPU touches these, so cache coherency isn't a concern.
>  	 *

Removing the above block of code causes:

drivers/mmc/host/mmc_spi.c:1299: warning: 'maybe_count_child' defined but not used

That function should also be removed along with the "struct count_children"
definition.

Regards,
Hartley
