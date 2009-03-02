Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZCBUJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZCBUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZCBUJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:09:50 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47659 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZCBUJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:09:49 -0500
Date: Mon, 2 Mar 2009 21:09:45 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: linux-kernel@vger.kernel.org,
       Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: Re: [PATCH RFT] MMC: core/core.c: mmc_rescan detects card change in
 one run
Message-ID: <20090302210945.04bfa623@mjolnir.ossman.eu>
In-Reply-To: <1235057186-31714-1-git-send-email-ext-jorg.2.schummer@nokia.com>
References: <1235057186-31714-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009 17:26:26 +0200
Jorg Schummer <ext-jorg.2.schummer@nokia.com> wrote:

> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index df6ce4a..cd2e29f 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -740,6 +740,22 @@ void mmc_rescan(struct work_struct *work)
>  
>  	mmc_bus_get(host);
>  
> +	/* if there is a card registered */
> +	if (host->bus_ops != NULL) {
> +
> +		if (host->bus_ops->detect && !host->bus_dead) {
> +
> +			/* check whether the card is still present */
> +			host->bus_ops->detect(host);
> +
> +			/* release the bus and update bus status in case
> +			   the card was removed */
> +			mmc_bus_put(host);
> +			mmc_bus_get(host);
> +		}
> +	}
> +
> +	/* if there is no card registered */
>  	if (host->bus_ops == NULL) {
>  		/*
>  		 * Only we can add a new handler, so it's safe to

Perhaps it's more clear if you grab the lock for the first section,
release it after and then regrab it for the second section. A bit less
efficient, but I don't think that will be a problem in practice.

> @@ -789,12 +805,8 @@ void mmc_rescan(struct work_struct *work)
>  
>  		mmc_release_host(host);
>  		mmc_power_off(host);
> -	} else {
> -		if (host->bus_ops->detect && !host->bus_dead)
> -			host->bus_ops->detect(host);
> -
> +	} else
>  		mmc_bus_put(host);
> -	}
>  out:
>  	if (host->caps & MMC_CAP_NEEDS_POLL)
>  		mmc_schedule_delayed_work(&host->detect, HZ);

The else section got a bit small here with that code removed. Perhaps
we should instead have:

	if (host->bus_ops != NULL) {
		mmc_bus_put(host);
		goto out;
	}

With some adjusted comments to make the flow clear.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
