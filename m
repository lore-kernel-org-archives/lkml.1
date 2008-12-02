Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbYLBQr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbYLBQr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYLBQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:47:00 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:39427 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbYLBQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:46:59 -0500
Date: Tue, 2 Dec 2008 22:16:50 +0530
To: Ben Dooks <ben-linux@fluff.org>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       drzeus-sdhci@drzeus.cx
Subject: Re: [patch 1/8] SDHCI: Add timeout hooks
Message-ID: <20081202164650.GA6414@debian>
References: <20081202154018.906091477@fluff.org.uk> <20081202154112.009165156@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202154112.009165156@fluff.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: smohideen@mx2.labs.rootshell.ws
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 03:40:19PM +0000, Ben Dooks wrote:
> Some controllers do not provide clock information in their
> capabilities (in the Samsung case, it is because there are
> multiple clock sources available to the controller). Add hooks
> to allow the system to supply clock information.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Index: linux.git/drivers/mmc/host/sdhci.c
> ===================================================================
> --- linux.git.orig/drivers/mmc/host/sdhci.c	2008-12-01 19:11:54.000000000 +0000
> +++ linux.git/drivers/mmc/host/sdhci.c	2008-12-01 19:24:14.000000000 +0000
> @@ -1606,18 +1606,26 @@ int sdhci_add_host(struct sdhci_host *ho
>  
>  	host->max_clk =
>  		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
> +	host->max_clk *= 1000000;
>  	if (host->max_clk == 0) {
> -		printk(KERN_ERR "%s: Hardware doesn't specify base clock "
> -			"frequency.\n", mmc_hostname(mmc));
> +		if (host->ops->get_max_clock)
> +			host->max_clk = host->ops->get_max_clock(host);
> +		else
> +			printk(KERN_ERR
> +			       "%s: Hardware doesn't specify base clock "
> +			       "frequency.\n", mmc_hostname(mmc));
>  		return -ENODEV;
>  	}
> -	host->max_clk *= 1000000;
>  
>  	host->timeout_clk =
>  		(caps & SDHCI_TIMEOUT_CLK_MASK) >> SDHCI_TIMEOUT_CLK_SHIFT;
>  	if (host->timeout_clk == 0) {
> -		printk(KERN_ERR "%s: Hardware doesn't specify timeout clock "
> -			"frequency.\n", mmc_hostname(mmc));
> +		if (host->ops->get_timeout_clock)
> +			host->timeout_clk = host->ops->get_timeout_clock(host);
> +		else
> +			printk(KERN_ERR
> +			       "%s: Hardware doesn't specify timeout clock "
> +			       "frequency.\n", mmc_hostname(mmc));
>  		return -ENODEV;
>  	}
>  	if (caps & SDHCI_TIMEOUT_CLK_UNIT)
> Index: linux.git/drivers/mmc/host/sdhci.h
> ===================================================================
> --- linux.git.orig/drivers/mmc/host/sdhci.h	2008-12-01 19:11:54.000000000 +0000
> +++ linux.git/drivers/mmc/host/sdhci.h	2008-12-01 19:17:55.000000000 +0000
> @@ -267,6 +267,8 @@ struct sdhci_host {
>  
>  struct sdhci_ops {
>  	int		(*enable_dma)(struct sdhci_host *host);
> +	unsigned int	(*get_max_clock)(struct sdhci_host *host);
> +	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
>  };
>  

	Can we cache the multiple dereferences. Here host->ops can be
	saved to a local, instead of multiple dereference several time.

	
