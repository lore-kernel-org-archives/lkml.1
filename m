Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXKHTB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXKHTB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761097AbXKHTBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:01:19 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:47795 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753971AbXKHTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:01:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=peIktiPnBJixFHxovysplb6LWS8ZSXhIh68VtxpMwByM5tmv6n9j2p8fORbZJMDfNQ6XlIc4TIYyFpVwXvbWtiawKMU283AMYI1OiTOOYWXG7OvQ19Icj3lf0cy1d1vYpyNQmbcvkpwE4A8AfYCgepuWglTTWr369jd5Mb7HFzA=  ;
X-YMail-OSG: 0bCl1JwVM1lL5I1MqMufh7ETqaSKuZXt4zKjjHGs4uGH5p9PnPM.iCFsmGvvu8keWp8eYxD_SQ--
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Tony Jones <tonyj@suse.de>
Subject: Re: [PATCH] spi: Fix double-free on spi_unregister_master
Date: Thu, 8 Nov 2007 10:42:13 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Stephen Street <stephen@streetfiresound.com>
References: <20071108.233505.25913499.anemo@mba.ocn.ne.jp>
In-Reply-To: <20071108.233505.25913499.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081042.14200.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007, Atsushi Nemoto wrote:
> After 49dce689ad4ef0fd1f970ef762168e4bd46f69a3, device_for_each_child
> iteration hits the master device itself.  Do not call
> spi_unregister_device() for the master device.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

ACK, and thanks.  Regression against 2.6.23...

I should have searched for other device_for_each_child() calls
when I had to do the same thing to fix the mmc_spi breakage.

Looks like the pxa2xx_spi suspend() code probably broke too.
I CC'd the maintainer of that code, though I'm not sure how
much time he has for this lately.

I'll hope someone else checks for non-SPI driver stacks which
such "class_dev" elimination may have broke...


> ---
>  drivers/spi/spi.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 89769ce..b31f443 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -457,10 +457,11 @@ done:
>  EXPORT_SYMBOL_GPL(spi_register_master);
>  
>  
> -static int __unregister(struct device *dev, void *unused)
> +static int __unregister(struct device *dev, void *master_dev)
>  {
>  	/* note: before about 2.6.14-rc1 this would corrupt memory: */
> -	spi_unregister_device(to_spi_device(dev));
> +	if (dev != master_dev)
> +		spi_unregister_device(to_spi_device(dev));
>  	return 0;
>  }
>  
> @@ -478,7 +479,8 @@ void spi_unregister_master(struct spi_master *master)
>  {
>  	int dummy;
>  
> -	dummy = device_for_each_child(master->dev.parent, NULL, __unregister);
> +	dummy = device_for_each_child(master->dev.parent, &master->dev,
> +					__unregister);
>  	device_unregister(&master->dev);
>  }
>  EXPORT_SYMBOL_GPL(spi_unregister_master);
> 


