Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYGQLEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYGQLEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbYGQLEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:04:24 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50446 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756649AbYGQLEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 07:04:23 -0400
Date: Thu, 17 Jul 2008 12:04:03 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Ville Syrjala <syrjala@sci.fi>,
       Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [PATCH 3/3] at91_mci: introduce per-mci-revision conditional
	code
Message-ID: <20080717110403.GH24620@fluff.org.uk>
References: <487F13E9.2060601@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487F13E9.2060601@atmel.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:42:01AM +0200, Nicolas Ferre wrote:
> We used to manage features and differences on a per-cpu basis. As several
> cpus share the same mci revision, this patch aggregates cpus that have the
> same IP revision in one defined constant.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> drivers/mmc/host/at91_mci.c |   21 +++++++++++++--------
> 1 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
> index 4e3edf3..a95529c 100644
> --- a/drivers/mmc/host/at91_mci.c
> +++ b/drivers/mmc/host/at91_mci.c
> @@ -80,6 +80,11 @@
>
> #define DRIVER_NAME "at91_mci"
>
> +#define AT91MCI_REV2	(  cpu_is_at91sam9260() \
> +			|| cpu_is_at91sam9263() \
> +			|| cpu_is_at91cap9() \
> +			|| cpu_is_at91sam9rl())
> +

How about making it an inline function to avoid the horrible
upper-case all throughtout?

> #define FL_SENT_COMMAND	(1 << 0)
> #define FL_SENT_STOP	(1 << 1)
>
> @@ -202,8 +207,8 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
> 	size = data->blksz * data->blocks;
> 	len = data->sg_len;
>
> -	/* AT91SAM926[0/3] Data Write Operation and number of bytes erratum */
> -	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
> +	/* AT91MCI_REV2 Data Write Operation and number of bytes erratum */
> +	if (AT91MCI_REV2)
> 		if (host->total_length == 12)
> 			memset(dmabuf, 0, 12);
>
> @@ -463,7 +468,7 @@ static void at91_mci_enable(struct at91mci_host *host)
> 	at91_mci_write(host, AT91_MCI_DTOR, AT91_MCI_DTOMUL_1M | AT91_MCI_DTOCYC);
> 	mr = AT91_MCI_PDCMODE | 0x34a;
>
> -	if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
> +	if (AT91MCI_REV2)
> 		mr |= AT91_MCI_RDPROOF | AT91_MCI_WRPROOF;
>
> 	at91_mci_write(host, AT91_MCI_MR, mr);
> @@ -616,10 +621,10 @@ static void at91_mci_send_command(struct at91mci_host *host, struct mmc_command
> 				 */
> 				host->total_length = block_length * blocks;
> 				/*
> -				 * AT91SAM926[0/3] Data Write Operation and
> +				 * AT91MCI_REV2 Data Write Operation and
> 				 * number of bytes erratum
> 				 */
> -				if (cpu_is_at91sam9260 () || cpu_is_at91sam9263())
> +				if (AT91MCI_REV2)
> 					if (host->total_length < 12)
> 						host->total_length = 12;
> 				host->buffer = dma_alloc_coherent(NULL,
> @@ -1010,7 +1015,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
> 	host->bus_mode = 0;
> 	host->board = pdev->dev.platform_data;
> 	if (host->board->wire4) {
> -		if (cpu_is_at91sam9260() || cpu_is_at91sam9263())
> +		if (AT91MCI_REV2)
> 			mmc->caps |= MMC_CAP_4_BIT_DATA;
> 		else
> 			dev_warn(&pdev->dev, "4 wire bus mode not supported"
> @@ -1018,8 +1023,8 @@ static int __init at91_mci_probe(struct platform_device *pdev)
> 	}
>
> 	/* Add SDIO capability when  available */
> -	if (cpu_is_at91sam9260() || cpu_is_at91sam9263()) {
> -		/* AT91SAM9260/9263 erratum */
> +	if (AT91MCI_REV2) {
> +		/* AT91MCI_REV2 sdio interrupt erratum */
> 		if (host->board->wire4 || !host->board->slot_b)
> 			mmc->caps |= MMC_CAP_SDIO_IRQ;
> 	}
> -- 
> 1.5.3.7
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
