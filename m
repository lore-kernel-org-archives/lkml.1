Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbYEUT3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbYEUT3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbYEUT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:29:17 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40991 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756060AbYEUT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:29:16 -0400
Date: Wed, 21 May 2008 21:28:31 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card
 detect line
Message-ID: <20080521212831.523f344b@mjolnir.drzeus.cx>
In-Reply-To: <20080521184713.GA30284@polina.dev.rtsoft.ru>
References: <20080516165057.GC24196@polina.dev.rtsoft.ru>
	<20080517133633.5aa26938@mjolnir.drzeus.cx>
	<20080521184713.GA30284@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 22:47:13 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> 
> Calling get_cd() for every request smells like overhead, especially given
> that that get_cd() could ask for GPIO status via relatively slow bus (like
> I2C GPIO expanders). So, polling seems most reasonable solution here, no
> need to call it very often.
> 

Fair enough. You should probably add a comment about this somewhere so
that people do not call get_cd() in the core request function and
similar places. Place it so that both get_cd() and get_ro() are covered
though, as it should be relevant for both.

> How about these patches? Tested with and without get_cd() optimization.
> 

Very nice. But I have some concerns:

> @@ -53,6 +53,7 @@ struct mmc_host_ops {
>  	void	(*request)(struct mmc_host *host, struct mmc_request *req);
>  	void	(*set_ios)(struct mmc_host *host, struct mmc_ios *ios);
>  	int	(*get_ro)(struct mmc_host *host);
> +	int	(*get_cd)(struct mmc_host *host);
>  	void	(*enable_sdio_irq)(struct mmc_host *host, int enable);
>  };

I'm always nervous when it comes to adding more callbacks, but I
suppose I've resisted this one for far too long already.

> +	if (host->ops->get_cd) {
> +		int old_cd_status = host->cd_status;
> +
> +		host->cd_status = !!host->ops->get_cd(host);
> +		if (!(old_cd_status ^ host->cd_status)) {
> +			mmc_bus_put(host);
> +			goto out;
> +		}
> +	}
> +

This should only be done when there is no bus handler. Since we are
polling, we might actually miss the user removing and reinserting the
card. The only way to check for that is to poke the card and see if it
is still alive. This also means you won't need that state variable.

Also, that second if clause seems fit for an obfuscation contest. ;)

> p.s. Since mmc_host_ops no longer the same for every instance of
> mmc_spi, struct mmc_host_ops can't be const and should be allocated
> dynamically.

This can be solved by allowing get_cd() to return an error that will be
treated as if get_cd() wasn't defined. -ENODEV seems suitable.

(get_ro() needs the same treatment, but I haven't gotten around to
that)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
