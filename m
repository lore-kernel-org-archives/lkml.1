Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZBOVq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZBOVq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZBOVqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:46:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbZBOVqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:46:49 -0500
Date: Sun, 15 Feb 2009 13:46:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Matt Fleming <matt@console-pimps.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
Message-Id: <20090215134632.18e06d13.akpm@linux-foundation.org>
In-Reply-To: <4992E597.2030404@nokia.com>
References: <4991A00B.8040002@nokia.com>
	<20090211133004.GH478@console-pimps.org>
	<4992D90E.10506@nokia.com>
	<4992E597.2030404@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 16:49:59 +0200 Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> Commit 0d3e0460f307e84904968aad6cff97bd688583d8
> "MMC: CSD and CID timeout values" inadvertently broke
> the timeout for the MMC command SEND_EXT_CSD.
> 
> This patch puts it back again.
> 

People will be interested in knowing whether this regression fix should
be backported into 2.6.28.x.  But apart from the word "broke" we have
no hint as to what the impact of the bug is.  Hence we are unable to
make that decision.

Please be more careful about changelogging.  It helps avoid mistakes.


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

