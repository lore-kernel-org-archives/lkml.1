Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbZBTBm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbZBTBm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZBTBmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:42:20 -0500
Received: from relais.videotron.ca ([24.201.245.36]:35259 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZBTBmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:42:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 19 Feb 2009 20:41:58 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drzeus-mmc@drzeus.cx, lkml <linux-kernel@vger.kernel.org>,
       maen@marvell.com
Subject: Re: [PATCH v2] SDIO driver for Marvell SoCs
In-reply-to: <20090219145808.796135e4.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0902192038480.5511@xanadu.home>
References: <alpine.LFD.2.00.0902172338110.32550@xanadu.home>
 <20090219124418.dfc4dc9a.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0902191708330.5511@xanadu.home>
 <20090219145808.796135e4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Feb 2009, Andrew Morton wrote:

> --- a/drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update
> +++ a/drivers/mmc/host/mvsdio.c
> @@ -783,9 +783,9 @@ out:
>  			gpio_free(host->gpio_write_protect);
>  		if (host->base)
>  			iounmap(host->base);
> -		if (host->res)
> -			release_resource(host->res);
>  	}
> +	if (r)
> +		release_resource(host->res);
>  	if (mmc)
>  		mmc_free_host(mmc);
>  
> _
> 
> Nope, this will deref a null pointer on that error path and wouldn't
> release the right thing anyway.

Obviously.  I'm just too stupid sometimes.  A s/host->res/r/ in both 
places would be better.

> Something like this...
> 
> --- a/drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update
> +++ a/drivers/mmc/host/mvsdio.c
> @@ -688,6 +688,7 @@ static int __init mvsd_probe(struct plat
>  
>  	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
>  	if (!mmc) {
> +		release_resource(r);
>  		ret = -ENOMEM;
>  		goto out;
>  	}

That's fine too.


Nicolas
