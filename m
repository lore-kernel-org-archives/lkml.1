Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZGXWyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZGXWyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZGXWyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:54:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754999AbZGXWyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:54:00 -0400
Date: Fri, 24 Jul 2009 15:53:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: pierre@ossman.eu, jarkko.lavinen@nokia.com, ext-denis.2.karpov@nokia.com,
       adrian.hunter@nokia.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 26/32] omap_hsmmc: prevent races with irq handler
Message-Id: <20090724155351.a99e30fd.akpm@linux-foundation.org>
In-Reply-To: <20090710124309.1262.22465.sendpatchset@ahunter-tower>
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>
	<20090710124309.1262.22465.sendpatchset@ahunter-tower>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 15:43:09 +0300
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> >From 242fae6293adec671b14354f215217354f5076a0 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Sat, 16 May 2009 10:32:34 +0300
> Subject: [PATCH] omap_hsmmc: prevent races with irq handler
> 
> If an unexpected interrupt occurs while preparing the
> next request, an oops can occur.
> 
> For example, a new request is setting up DMA for data
> transfer so host->data is not NULL.  An unexpected
> transfer complete (TC) interrupt comes along and
> the interrupt handler sets host->data to NULL.  Oops!
> 
> Prevent that by disabling interrupts while setting up
> a new request.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 28563d6..38e1410 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -452,6 +452,13 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
>  	if (host->use_dma)
>  		cmdreg |= DMA_EN;
>  
> +	/*
> +	 * In an interrupt context (i.e. STOP command), the interrupt is already
> +	 * enabled, otherwise it is not (i.e. new request).
> +	 */
> +	if (!in_interrupt())
> +		enable_irq(host->irq);
> +
>  	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
>  	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
>  }
> @@ -1011,6 +1018,13 @@ static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
>  	struct mmc_omap_host *host = mmc_priv(mmc);
>  	int err;
>  
> +	/*
> +	 * Prevent races with the interrupt handler because of unexpected
> +	 * interrupts, but not if we are already in interrupt context i.e.
> +	 * retries.
> +	 */
> +	if (!in_interrupt())
> +		disable_irq(host->irq);
>  	WARN_ON(host->mrq != NULL);
>  	host->mrq = req;
>  	err = mmc_omap_prepare_data(host, req);
> @@ -1019,6 +1033,8 @@ static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
>  		if (req->data)
>  			req->data->error = err;
>  		host->mrq = NULL;
> +		if (!in_interrupt())
> +			enable_irq(host->irq);
>  		mmc_request_done(mmc, req);
>  		return;
>  	}

That seems pretty crude.  Disabling an interrupt line can be expensive,
and will shut off any other innocent devices which share the line.

The usual and superior way of fixing races such as this is
spin_lock_irq[save]().

