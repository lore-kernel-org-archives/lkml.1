Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZBKNaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZBKNaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZBKNaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:30:07 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:63014 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZBKNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:30:06 -0500
Date: Wed, 11 Feb 2009 13:30:04 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
Message-ID: <20090211133004.GH478@console-pimps.org>
References: <4991A00B.8040002@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4991A00B.8040002@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 05:40:59PM +0200, Adrian Hunter wrote:
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 9c50e6f..418a270 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -248,12 +248,16 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
>
> 	sg_init_one(&sg, data_buf, len);
>
> -	/*
> -	 * The spec states that CSR and CID accesses have a timeout
> -	 * of 64 clock cycles.
> -	 */
> -	data.timeout_ns = 0;
> -	data.timeout_clks = 64;
> +	if (!mmc_host_is_spi(card->host) && opcode == MMC_SEND_EXT_CSD)
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
> 	mmc_wait_for_req(host, &mrq);
>

Doh! You're right, I did inadvertently break this. Your fix looks good.
