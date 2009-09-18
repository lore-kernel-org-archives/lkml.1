Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZIRVcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZIRVcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZIRVcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:32:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbZIRVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:32:39 -0400
Date: Fri, 18 Sep 2009 14:30:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, yi.li@analog.com
Subject: Re: [PATCH 2/2 v2] mmc_spi: lock the SPI bus when accessing the
 card
Message-Id: <20090918143054.a6cf31f7.akpm@linux-foundation.org>
In-Reply-To: <1253235134-25571-1-git-send-email-vapier@gentoo.org>
References: <BD79186B4FD85F4B8E60E381CAEE190901D41E4C@mi8nycmail19.Mi8.com>
	<1253235134-25571-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 20:52:14 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

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
> v2
> 	- drop now unused maybe_count_child as pointed out by H Hartley Sweeten
> 
>  drivers/mmc/host/mmc_spi.c |   41 ++---------------------------------------
>  1 files changed, 2 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index a461017..c3563a7 100644
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

I can't find any code anywhere which puts a non-zero value into
spi_master.[un]lock_bus so in my tree at least, neither of these
patches do anything.

This makes it all a bit hard to understand and review.
