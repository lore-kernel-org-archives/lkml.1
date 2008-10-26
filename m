Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYJZLrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYJZLrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYJZLrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:47:23 -0400
Received: from server.drzeus.cx ([85.8.24.28]:36714 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbYJZLrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:47:22 -0400
Date: Sun, 26 Oct 2008 12:47:19 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: Re: [PATCH] MMC: Fix race condition in resume/card detect code
Message-ID: <20081026124719.3da77e6f@mjolnir.drzeus.cx>
In-Reply-To: <1224531708-13624-1-git-send-email-jekhor@gmail.com>
References: <20081018191147.00327019@mjolnir.drzeus.cx>
	<1224531708-13624-1-git-send-email-jekhor@gmail.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 22:41:48 +0300
Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> When device wakes up by card change interrupt and MMC_UNSAFE_RESUME is
> enabled then race condition between mmc_rescan() and
> mmc_resume()/mmc_sd_resume() appeared.
> 

Having thought a bit more about this, I'm not sure where the race is.
mmc_sd_resume() will be called before mmc_detect_change() is.

There is a race if the drivers call mmc_detect_change() before
mmc_resume_host() has returned, but that is a driver bug. I won't
object to adding a safe guard against that, but the commit message
should reflect that scenario and not something else. There should also
be some printk() to indicate that the driver is up to no good.

> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 044d84e..427f283 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -657,6 +657,9 @@ void mmc_rescan(struct work_struct *work)
>  	u32 ocr;
>  	int err;
>  
> +	if (host->suspended)
> +		return;
> +
>  	mmc_bus_get(host);
>  
>  	if (host->bus_ops == NULL) {

Was there no way to query the PM layer for this information?

> @@ -805,6 +810,8 @@ int mmc_resume_host(struct mmc_host *host)
>  	 */
>  	mmc_detect_change(host, 1);
>  
> +	host->suspended = 0;
> +
>  	return 0;
>  }
>  

You've added a new race here. ;)

You should set suspended to 0 before calling mmc_detect_change(), not
after. The point was to protect bus_ops->resume(), nothing else.

> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 9c288c9..a584239 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -139,6 +139,9 @@ struct mmc_host {
>  #ifdef CONFIG_MMC_DEBUG
>  	unsigned int		removed:1;	/* host is being removed */
>  #endif
> +#ifdef CONFIG_MMC_UNSAFE_RESUME
> +	unsigned int		suspended:1;
> +#endif
>  
>  	struct mmc_card		*card;		/* device attached to this host */
>  

No #ifdef for this as there are no where this variable is referenced.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
