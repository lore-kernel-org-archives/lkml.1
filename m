Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0CFMy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 07:54:28 -0500
Received: from smtp.nokia.com ([192.100.105.134]:19727 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0CFMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 07:54:26 -0500
Message-ID: <4B925077.1060803@nokia.com>
Date: Sat, 06 Mar 2010 14:54:15 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: Re: [PATCH] mmc: omap_hsmmc: Fix conditional locking
References: <alpine.LFD.2.00.1003011952470.4245@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003011952470.4245@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2010 12:54:16.0553 (UTC) FILETIME=[21216D90:01CABD2C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Conditional locking on (!in_interrupt()) is broken by design and there
> is no reason to keep the host->irq_lock across the call to
> mmc_request_done(). Also the host->protect_card magic hack does not
> depend on the context

Card protect does depend on not being invoked in the middle of a request.
For example, it could result in a open-ended read being started but never
stopped.

in_interrupt() can be replaced with a new flag 'in_request' that is set
in omap_hsmmc_request() and cleared after mmc_request_done()

Also, as you allude to in another email, the spinlock, while preventing an
oops, does not stop the unwanted interrupt, which will cause problems.

I can make the necessary changes but it will be a few days before
I have the time.

> 
> Fix the mess by dropping host->irq_lock before calling
> mmc_request_done().
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 4b23225..99a3383 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -468,14 +468,6 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
>  	if (host->use_dma)
>  		cmdreg |= DMA_EN;
>  
> -	/*
> -	 * In an interrupt context (i.e. STOP command), the spinlock is unlocked
> -	 * by the interrupt handler, otherwise (i.e. for a new request) it is
> -	 * unlocked here.
> -	 */
> -	if (!in_interrupt())
> -		spin_unlock_irqrestore(&host->irq_lock, host->flags);
> -
>  	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
>  	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
>  }
> @@ -506,7 +498,9 @@ omap_hsmmc_xfer_done(struct omap_hsmmc_host *host, struct mmc_data *data)
>  		}
>  
>  		host->mrq = NULL;
> +		spin_unlock(&host->irq_lock);
>  		mmc_request_done(host->mmc, mrq);
> +		spin_lock(&host->irq_lock);
>  		return;
>  	}
>  
> @@ -523,7 +517,9 @@ omap_hsmmc_xfer_done(struct omap_hsmmc_host *host, struct mmc_data *data)
>  
>  	if (!data->stop) {
>  		host->mrq = NULL;
> +		spin_unlock(&host->irq_lock);
>  		mmc_request_done(host->mmc, data->mrq);
> +		spin_lock(&host->irq_lock);
>  		return;
>  	}
>  	omap_hsmmc_start_command(host, data->stop, NULL);
> @@ -551,7 +547,9 @@ omap_hsmmc_cmd_done(struct omap_hsmmc_host *host, struct mmc_command *cmd)
>  	}
>  	if ((host->data == NULL && !host->response_busy) || cmd->error) {
>  		host->mrq = NULL;
> +		spin_unlock(&host->irq_lock);
>  		mmc_request_done(host->mmc, cmd->mrq);
> +		spin_lock(&host->irq_lock);
>  	}
>  }
>  
> @@ -1077,37 +1075,31 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
>  	struct omap_hsmmc_host *host = mmc_priv(mmc);
>  	int err;
>  
> +	spin_lock_irqsave(&host->irq_lock, host->flags);
>  	/*
> -	 * Prevent races with the interrupt handler because of unexpected
> -	 * interrupts, but not if we are already in interrupt context i.e.
> -	 * retries.
> +	 * Protect the card from I/O if there is a possibility
> +	 * it can be removed.
>  	 */
> -	if (!in_interrupt()) {
> -		spin_lock_irqsave(&host->irq_lock, host->flags);
> -		/*
> -		 * Protect the card from I/O if there is a possibility
> -		 * it can be removed.
> -		 */
> -		if (host->protect_card) {
> -			if (host->reqs_blocked < 3) {
> -				/*
> -				 * Ensure the controller is left in a consistent
> -				 * state by resetting the command and data state
> -				 * machines.
> -				 */
> -				omap_hsmmc_reset_controller_fsm(host, SRD);
> -				omap_hsmmc_reset_controller_fsm(host, SRC);
> -				host->reqs_blocked += 1;
> -			}
> -			req->cmd->error = -EBADF;
> -			if (req->data)
> -				req->data->error = -EBADF;
> -			spin_unlock_irqrestore(&host->irq_lock, host->flags);
> -			mmc_request_done(mmc, req);
> -			return;
> -		} else if (host->reqs_blocked)
> -			host->reqs_blocked = 0;
> -	}
> +	if (host->protect_card) {
> +		if (host->reqs_blocked < 3) {
> +			/*
> +			 * Ensure the controller is left in a consistent
> +			 * state by resetting the command and data state
> +			 * machines.
> +			 */
> +			omap_hsmmc_reset_controller_fsm(host, SRD);
> +			omap_hsmmc_reset_controller_fsm(host, SRC);
> +			host->reqs_blocked += 1;
> +		}
> +		req->cmd->error = -EBADF;
> +		if (req->data)
> +			req->data->error = -EBADF;
> +		spin_unlock_irqrestore(&host->irq_lock, host->flags);
> +		mmc_request_done(mmc, req);
> +		return;
> +	} else if (host->reqs_blocked)
> +		host->reqs_blocked = 0;
> +
>  	WARN_ON(host->mrq != NULL);
>  	host->mrq = req;
>  	err = omap_hsmmc_prepare_data(host, req);
> @@ -1116,13 +1108,13 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
>  		if (req->data)
>  			req->data->error = err;
>  		host->mrq = NULL;
> -		if (!in_interrupt())
> -			spin_unlock_irqrestore(&host->irq_lock, host->flags);
> +		spin_unlock_irqrestore(&host->irq_lock, host->flags);
>  		mmc_request_done(mmc, req);
>  		return;
>  	}
>  
>  	omap_hsmmc_start_command(host, req->cmd, req->data);
> +	spin_unlock_irqrestore(&host->irq_lock, host->flags);
>  }
>  
>  /* Routine to configure clock values. Exposed API to core */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

