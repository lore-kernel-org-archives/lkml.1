Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZBRUQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZBRUQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZBRUQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:16:34 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50185 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbZBRUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:16:33 -0500
Date: Wed, 18 Feb 2009 21:16:27 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
Message-ID: <20090218211627.7c16339a@mjolnir.ossman.eu>
In-Reply-To: <4992E597.2030404@nokia.com>
References: <4991A00B.8040002@nokia.com>
	<20090211133004.GH478@console-pimps.org>
	<4992D90E.10506@nokia.com>
	<4992E597.2030404@nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 16:49:59 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> Commit 0d3e0460f307e84904968aad6cff97bd688583d8
> "MMC: CSD and CID timeout values" inadvertently broke
> the timeout for the MMC command SEND_EXT_CSD.
> 
> This patch puts it back again.
> 
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---
>  drivers/mmc/core/mmc_ops.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 9c50e6f..418a270 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -248,12 +248,16 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
>  
>  	sg_init_one(&sg, data_buf, len);
>  
> -	/*
> -	 * The spec states that CSR and CID accesses have a timeout
> -	 * of 64 clock cycles.
> -	 */
> -	data.timeout_ns = 0;
> -	data.timeout_clks = 64;
> +	if (!mmc_host_is_spi(host) && opcode == MMC_SEND_EXT_CSD)
> +		mmc_set_data_timeout(&data, card);
> +	else {
> +		/*
> +		 * The spec states that CSR and CID accesses have a timeout
> +		 * of 64 clock cycles (8 for SPI).
> +		 */
> +		data.timeout_ns = 0;
> +		data.timeout_clks = 64;
> +	}
>  
>  	mmc_wait_for_req(host, &mrq);
>  

I'm confused. Where did the 64 come from in the first place? That
function will not be called for CID/CSD when !SPI. So the way I see it
the code should be:

if ((opcode == MMC_SEND_CSD) || (opcode == (MMC_SEND_CID)) {
	data.timeout_ns = 0;
	data.timeout_clks = 8;
} else {
	mmc_set_data_timeout(&data, card);
}


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
