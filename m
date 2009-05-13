Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZEMGOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZEMGOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZEMGOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:14:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbZEMGOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:14:08 -0400
Date: Tue, 12 May 2009 23:11:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luis Galdos <luis.galdos@digi.com>
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [LIBERTAS-SDIO]  Support for single transfer blocks?
Message-Id: <20090512231150.bc0c65c6.akpm@linux-foundation.org>
In-Reply-To: <4A08392F.70108@digi.com>
References: <4A08392F.70108@digi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let's Cc the wireless development list.

On Mon, 11 May 2009 16:41:51 +0200 Luis Galdos <luis.galdos@digi.com> wrote:

> Hi all,
> 
> I have one question concerning to the Libertas-driver: Does this driver works with 
> SDIO-hosts that only support single transfer blocks? I ask cause I have seen two problems 
> with a SDIO-port that doesn't support multiple blocks:
> 
> * The firmware installation successes only with a modification of the block size (see 
> below patch)
> 
> * The transfer of Ethernet-frames works only if the "complete" frame is smaller than the 
> block size of the SDIO-host. By larger packages, the SD8686 doesn't generate the expected 
> IRQ (cause it expected a multiple transfer) and the driver detects a timeout.
> 
> Do you know something about this? Thanks in advance,
> 
> 
> PS: Sorry for the possible wrong format of this email (my first one)
> 
> 
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index b54e2ea..f88a4da 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -33,6 +33,7 @@
>   #include <linux/mmc/card.h>
>   #include <linux/mmc/sdio_func.h>
>   #include <linux/mmc/sdio_ids.h>
> +#include <linux/mmc/host.h>
> 
>   #include "host.h"
>   #include "decl.h"
> @@ -507,6 +508,8 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
>          u32 chunk_size;
>          const u8 *firmware;
>          size_t size, req_size;
> +       struct mmc_host *host;
> +       int max_blksize = 0;
> 
>          lbs_deb_enter(LBS_DEB_SDIO);
> 
> @@ -524,7 +527,19 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
> 
>          sdio_claim_host(card->func);
> 
> -       ret = sdio_set_block_size(card->func, 32);
> +       /*
> +        * If the host doesn't support multi-blocks, then use the the maximal block
> +        * size for the transfers. Otherwise the firmware installation will fail.
> +        */
> +       host = card->func->card->host;
> +       if (host->max_blk_count == 1) {
> +               lbs_pr_info("Setting block size to %u\n", host->max_blk_size);
> +               max_blksize = card->func->max_blksize;
> +               card->func->max_blksize = host->max_blk_size;
> +               ret = sdio_set_block_size(card->func, host->max_blk_size);
> +       } else
> +               ret = sdio_set_block_size(card->func, 32);
> +
>          if (ret)
>                  goto release;
> 
> @@ -593,6 +608,10 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
> 
>          ret = 0;
> 
> +        /* Restore the original block size if it was changed before */
> +        if (max_blksize)
> +                card->func->max_blksize = max_blksize;
> +
>          lbs_deb_sdio("waiting for firmware to boot...\n");
> 
>          /* wait for the firmware to boot */
> 
> 
> -- 
> Luis Galdos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
