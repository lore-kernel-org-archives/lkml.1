Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYKNVl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYKNVl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYKNVlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:41:18 -0500
Received: from server.drzeus.cx ([85.8.24.28]:36104 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751416AbYKNVlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:41:18 -0500
Date: Fri, 14 Nov 2008 22:41:14 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 4/7] SDHCI: Add quirk for controller with no end-of-busy
 IRQ
Message-ID: <20081114224114.5b5932a0@mjolnir.drzeus.cx>
In-Reply-To: <20081103201010.464075837@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201010.464075837@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 20:09:48 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> The Samsung SDHCI controller block seems to fail to generate an
> INT_DATA_END after the transfer has completed and the bus busy
> state finished. 
> 
> Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
> new busy method are the cause of the behaviour change.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Index: linux.git/drivers/mmc/host/sdhci.c
> ===================================================================
> --- linux.git.orig/drivers/mmc/host/sdhci.c	2008-11-03 10:01:03.000000000 +0000
> +++ linux.git/drivers/mmc/host/sdhci.c	2008-11-03 12:20:40.000000000 +0000
> @@ -1291,11 +1291,24 @@ static void sdhci_cmd_irq(struct sdhci_h
>  	 *       controllers.
>  	 */
>  	if (host->cmd->flags & MMC_RSP_BUSY) {
> +		u32 present;
> +
>  		if (host->cmd->data)
>  			DBG("Cannot wait for busy signal when also "
>  				"doing a data transfer");
> -		else
> +		else if (!(host->quirks & SDHCI_QUIRK_NO_TCIRQ_ON_NOT_BUSY))
>  			return;

Not the clearest naming I've ever seen. :)
How about NO_BUSY_IRQ?

> +
> +		/* The Samsung SDHCI does not seem to provide an INT_DATA_END
> +		 * when the system goes non-busy, so check the state of the
> +		 * transfer by reading SDHCI_PRESENT_STATE to see if the
> +		 * controller is ready
> +		 */

There is already a note about this being a problem earlier up, so I
don't think we need another.

> +
> +		present = readl(host->ioaddr + SDHCI_PRESENT_STATE);
> +		DBG("busy? present %08x, intstat %08x\n", present, intmask);
> +

And what does this add really? Controllers not being able to wait for
the busy state to end is so common that we can just ignore the problem
here.

> +#define  SDHCI_DATA_BIT(x)	(1 << ((x) + 20))

This was not supposed to be included I suppose :)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
