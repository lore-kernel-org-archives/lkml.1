Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYGQP37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYGQP37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYGQP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:29:49 -0400
Received: from server.drzeus.cx ([85.8.24.28]:51753 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756659AbYGQP3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:29:48 -0400
Date: Thu, 17 Jul 2008 17:29:45 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: MMC: s3cmci: ensure host stopped on machine shutdown
Message-ID: <20080717172945.3481eefa@mjolnir.drzeus.cx>
In-Reply-To: <20080717143253.823429733@fluff.org.uk>
References: <20080717143253.823429733@fluff.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 15:32:54 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> Ensure that the s3cmci host controller is turned off
> when the machine is shutdown, otherwise we end up
> leaving the card powered and processing insertion and
> removal events after the system prints "System halted."
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Index: linux-2.6.26-quilt3/drivers/mmc/host/s3cmci.c
> ===================================================================
> --- linux-2.6.26-quilt3.orig/drivers/mmc/host/s3cmci.c	2008-07-17 15:15:35.000000000 +0100
> +++ linux-2.6.26-quilt3/drivers/mmc/host/s3cmci.c	2008-07-17 15:29:23.000000000 +0100
> @@ -1331,21 +1331,30 @@ static int __devinit s3cmci_probe(struct
>  	return ret;
>  }
>  
> +static void s3cmci_shutdown(struct platform_device *pdev)
> +{
> +	struct mmc_host	*mmc = platform_get_drvdata(pdev);
> +	struct s3cmci_host *host = mmc_priv(mmc);
> +
> +	if (host->irq_cd >= 0)
> +		free_irq(host->irq_cd, host);
> +
> +	mmc_remove_host(mmc);
> +	clk_disable(host->clk);
> +}
> +

The core can send requests your way until mmc_remove_host() returns so
you can't remove the interrupt before then.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
