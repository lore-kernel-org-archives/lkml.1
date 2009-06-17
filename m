Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbZFQIco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbZFQIco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZFQIcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:32:31 -0400
Received: from mail.hevs.ch ([153.109.23.10]:43349 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675AbZFQIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:32:30 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 3/6] atmel-mci: Optional controller reset before every command
Date: Wed, 17 Jun 2009 10:32:22 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.26-2-686; KDE/4.2.2; i686; ; )
Cc: Rob Emanuele <rob@emanuele.us>, nicolas.ferre@atmel.com,
       haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org
References: <1245200079-6323-1-git-send-email-rob@emanuele.us> <1245200079-6323-3-git-send-email-rob@emanuele.us>
In-Reply-To: <1245200079-6323-3-git-send-email-rob@emanuele.us>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906171032.23285.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wednesday 17 June 2009 02:54:36 Rob Emanuele wrote:
> This patch adds the compile time configuration option for the atmel-mci driver to reset the Atmel MCI controller before every command.
> 
> This is sometimes needed for the Atmel controller / board to function properly.
> 
> Signed-off-by: Rob Emanuele <rob@emanuele.us>
> ---
>  drivers/mmc/host/Kconfig     |   10 ++++++++++
>  drivers/mmc/host/atmel-mci.c |   11 ++++++++++-
>  2 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index a0eaf69..5875125 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -161,6 +161,16 @@ config MMC_ATMELMCI
>  
>  endchoice
>  
> +config MMC_ATMELMCI_ALWAYS_RESET
> +	bool "Reset before every request.  Sometimes needed for buggy chips."
> +	depends on MMC_ATMELMCI
> +	help
> +	  There are reports that some buggy controllers work better
> +	  with a reset before every command.  This may improve your
> +	  controller's reliability.
> +
> +	  If unsure, say N.
> +
>  config MMC_ATMELMCI_DMA
>  	bool "Atmel MCI DMA support (EXPERIMENTAL)"
>  	depends on MMC_ATMELMCI && AVR32 && DMA_ENGINE && EXPERIMENTAL
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 98b25de..e5894f6 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -63,6 +63,15 @@ struct atmel_mci_dma {
>  #endif
>  };
>  
> +/*
> + * Configuration options from the kernel config
> + */
> +#ifdef CONFIG_MMC_ATMELMCI_ALWAYS_RESET
> +#define MMC_ALWAYS_RESET 1
> +#else
> +#define MMC_ALWAYS_RESET 0
> +#endif

Some chips are known to hang after (some) transfer. There is no need for this
configuration option, I think we should just do : 

#define MMC_ALWAYS_RESET (cpu_is_at91rm9200() || add_your_cpu_name_here())

> +
>  /**
>   * struct atmel_mci - MMC controller state shared between all slots
>   * @lock: Spinlock protecting the queue and associated data.
> @@ -720,7 +729,7 @@ static void atmci_start_request(struct atmel_mci *host,
>  	host->completed_events = 0;
>  	host->data_status = 0;
>  
> -	if (host->need_reset) {
> +	if (host->need_reset || MMC_ALWAYS_RESET) {
>  		mci_writel(host, CR, MCI_CR_SWRST);
>  		mci_writel(host, CR, MCI_CR_MCIEN);
>  		mci_writel(host, MR, host->mode_reg);

Another option is to always reset the controller.

The reset operation won't hurt, it is simple and fast, and the code will be
simpler and better tested.

Best regards

Marc
