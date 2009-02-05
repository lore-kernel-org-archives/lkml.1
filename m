Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZBEPEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZBEPEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZBEPEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:04:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZBEPEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:04:44 -0500
Subject: Re: [PATCH] wireless: introduce POWEROF2_BLOCKSIZE_ONLY option
From: Dan Williams <dcbw@redhat.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>
In-Reply-To: <1233819002-6912-1-git-send-email-cooloney@kernel.org>
References: <1233819002-6912-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 10:03:15 -0500
Message-Id: <1233846195.3028.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 15:30 +0800, Bryan Wu wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Introduce POWEROF2_BLOCKSIZE_ONLY option for those SD/SDIO host
> which only support transferring block with size of power-of-2

Is the point here to avoid copying in the controller code?  As with the
other patches on libertas-dev, I really dislike adding code to *every
SDIO driver* just because the host has certain restrictions.  I'd much
rather that the host/controller code became aware of it's own
restrictions, and exposed those generically to drivers above it.
Without a KConfig option.

Seriously.  The host knows what it needs.  The code to handle that
should go in the host.

How about adding a method like "sdio_align_size" that takes the
controller's constraints into account?  That seems a lot cleaner than
adding #define/KConfig junk to every SDIO driver in the kernel.  One
less codepath to test, makes your life and all our lives easier.

Dan

> [ Bryan Wu <cooloney@kernel.org>:
>  - remove some useless coding style cleanup
>  - using roundup() function as upstream does
> ]
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/net/wireless/Kconfig            |    6 ++++++
>  drivers/net/wireless/libertas/if_sdio.c |   16 ++++++++++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index e4f9f74..a2685fa 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -151,6 +151,12 @@ config LIBERTAS_SDIO
>  	---help---
>  	  A driver for Marvell Libertas 8385 and 8686 SDIO devices.
>  
> +config POWEROF2_BLOCKSIZE_ONLY
> +	bool "Support transferring block with size of power-of-2 only"
> +	depends on LIBERTAS_SDIO
> +	---help---
> +	  For SD/SDIO host which only supports transferring block with size of power-of-2.
> +
>  config LIBERTAS_DEBUG
>  	bool "Enable full debugging output in the Libertas module."
>  	depends on LIBERTAS
> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> index 4519d73..5efc056 100644
> --- a/drivers/net/wireless/libertas/if_sdio.c
> +++ b/drivers/net/wireless/libertas/if_sdio.c
> @@ -272,6 +272,11 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
>  	 */
>  	chunk = sdio_align_size(card->func, size);
>  
> +/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
> +#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
> +	chunk = (chunk + card->func->cur_blksize - 1) /
> +			card->func->cur_blksize * card->func->cur_blksize;
> +#endif
>  	ret = sdio_readsb(card->func, card->buffer, card->ioport, chunk);
>  	if (ret)
>  		goto out;
> @@ -581,8 +586,14 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
>  			lbs_deb_sdio("sending %d bytes (%d bytes) chunk\n",
>  				chunk_size, (chunk_size + 31) / 32 * 32);
>  */
> +/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
> +#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
> +  			ret = sdio_writesb(card->func, card->ioport,
> + 				chunk_buffer, roundup(chunk_size, 256);
> +#else
>  			ret = sdio_writesb(card->func, card->ioport,
>  				chunk_buffer, roundup(chunk_size, 32));
> +#endif
>  			if (ret)
>  				goto release;
>  
> @@ -699,6 +710,11 @@ static int if_sdio_host_to_card(struct lbs_private *priv,
>  	 */
>  	size = sdio_align_size(card->func, nb + 4);
>  
> +/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
> +#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
> +	size = (size + card->func->cur_blksize - 1) /
> +			card->func->cur_blksize * card->func->cur_blksize;
> +#endif
>  	packet = kzalloc(sizeof(struct if_sdio_packet) + size,
>  			GFP_ATOMIC);
>  	if (!packet) {

