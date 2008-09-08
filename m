Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYIHNrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYIHNrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 09:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYIHNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 09:46:59 -0400
Received: from trinity.fluff.org ([89.145.97.151]:50939 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbYIHNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 09:46:58 -0400
Date: Mon, 8 Sep 2008 14:46:56 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Christer Weinigel <christer@weinigel.se>
Cc: ben-linux@fluff.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] s3cmci - call pio_tasklet from IRQ
Message-ID: <20080908134656.GB30478@trinity.fluff.org>
References: <20080908124848.541807034@zoo.weinigel.se> <20080908124909.554600509@zoo.weinigel.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908124909.554600509@zoo.weinigel.se>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 02:48:50PM +0200, Christer Weinigel wrote:
> Scheduling a tasklet to perform the pio transfer introduces a bit of
> extra processing, just call pio_tasklet directly from the interrupt
> instead.  Writing up to 64 bytes to a FIFO is probably uses less CPU
> than scheduling a tasklet anyway.

Hmm, i'd be interested to find out how long these are taking... I might
try and rig up something to test the time being taken via an SMDK.

If the fifo read/writes are taking significant amounts of time, then the
pio tasklet will at least improve the interrupt latencies invloved, as
iirc we're currently running the main irq handler in IRQ_DISABLED mode
to stop any problems with re-enternancy.... I'll check this and see what
is going on.
 
> Signed-off-by: Christer Weinigel <christer@weinigel.se>
> 
> Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.c
> ===================================================================
> --- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.c
> +++ linux-2.6.26.2/drivers/mmc/host/s3cmci.c
> @@ -361,11 +361,8 @@ static void do_pio_write(struct s3cmci_h
>  	enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
>  }
>  
> -static void pio_tasklet(unsigned long data)
> +static void pio_tasklet(struct s3cmci_host *host)
>  {
> -	struct s3cmci_host *host = (struct s3cmci_host *) data;
> -
> -
>  	disable_irq(host->irq);
>  
>  	if (host->pio_active == XFER_WRITE)
> @@ -460,10 +457,10 @@ static irqreturn_t s3cmci_irq(int irq, v
>  	if (!host->dodma) {
>  		if ((host->pio_active == XFER_WRITE) &&
>  		    (mci_fsta & S3C2410_SDIFSTA_TFDET)) {
> -
>  			disable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
> -			tasklet_schedule(&host->pio_tasklet);
> +			pio_tasklet(host);
>  			host->status = "pio tx";
> +			goto irq_out;
>  		}
>  
>  		if ((host->pio_active == XFER_READ) &&
> @@ -473,8 +470,9 @@ static irqreturn_t s3cmci_irq(int irq, v
>  				      S3C2410_SDIIMSK_RXFIFOHALF |
>  				      S3C2410_SDIIMSK_RXFIFOLAST);
>  
> -			tasklet_schedule(&host->pio_tasklet);
> +			pio_tasklet(host);
>  			host->status = "pio rx";
> +			goto irq_out;
>  		}
>  	}
>  
> @@ -595,7 +593,7 @@ close_transfer:
>  	host->complete_what = COMPLETION_FINALIZE;
>  
>  	clear_imask(host);
> -	tasklet_schedule(&host->pio_tasklet);
> +	pio_tasklet(host);
>  
>  	goto irq_out;
>  
> @@ -666,7 +664,7 @@ void s3cmci_dma_done_callback(struct s3c
>  	host->complete_what = COMPLETION_FINALIZE;
>  
>  out:
> -	tasklet_schedule(&host->pio_tasklet);
> +	pio_tasklet(host);
>  	spin_unlock_irqrestore(&host->complete_lock, iflags);
>  	return;
>  
> @@ -1198,7 +1196,6 @@ static int __devinit s3cmci_probe(struct
>  	}
>  
>  	spin_lock_init(&host->complete_lock);
> -	tasklet_init(&host->pio_tasklet, pio_tasklet, (unsigned long) host);
>  
>  	if (is2440) {
>  		host->sdiimsk	= S3C2440_SDIIMSK;
> @@ -1381,7 +1378,6 @@ static int __devexit s3cmci_remove(struc
>  
>  	clk_put(host->clk);
>  
> -	tasklet_disable(&host->pio_tasklet);
>  	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
>  
>  	free_irq(host->irq, host);
> Index: linux-2.6.26.2/drivers/mmc/host/s3cmci.h
> ===================================================================
> --- linux-2.6.26.2.orig/drivers/mmc/host/s3cmci.h
> +++ linux-2.6.26.2/drivers/mmc/host/s3cmci.h
> @@ -66,5 +66,4 @@ struct s3cmci_host {
>  	char			*status;
>  
>  	unsigned int		ccnt, dcnt;
> -	struct tasklet_struct	pio_tasklet;
>  };
> 
> -- 
> "Just how much can I get away with and still go to heaven?"
> 
> Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

