Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966055Ab0BZU25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:28:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35818 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044Ab0BZU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:28:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=OiDBvkpl7c2Zfhw8201Tp+fyKQgEPfeiHcm1xRscCpj8O/koahvLt5P7NONRyKOHKL
         AYkcHYc3xE2K6YwmxCTF2tY1f+dBZ9b/Yuafvm8CG6EU9ZeiKvR56HcImFC/Eog9oT3V
         rOOGhrCCnKLzKm6cCnA5TiPBMrVk4bDaGF+ek=
Date: Fri, 26 Feb 2010 23:20:46 +0300
From: Dan Carpenter <error27@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: akpm@linux-foundation.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       wolfgang.mues@auerswald.de, avictor.za@gmail.com
Subject: Re: [PATCH 1/7] mmc: at91_mci: fix pointer errors
Message-ID: <20100226201934.GG8417@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>, akpm@linux-foundation.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, wolfgang.mues@auerswald.de,
	avictor.za@gmail.com
References: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9535dc8dfe4476a0314b9513fb9d37862faa731d.1267209149.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 07:39:29PM +0100, Nicolas Ferre wrote:
> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> 
> Fixes two pointer errors, one which leads to memory overwrites if used with
> large chunks of data.
> 
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/mmc/host/at91_mci.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
> index 63924e0..6835104 100644
> --- a/drivers/mmc/host/at91_mci.c
> +++ b/drivers/mmc/host/at91_mci.c
> @@ -227,11 +227,13 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
>  			for (index = 0; index < (amount / 4); index++)
>  				*dmabuf++ = swab32(sgbuffer[index]);
>  		} else {
> -			memcpy(dmabuf, sgbuffer, amount);
> -			dmabuf += amount;
> +			char *tmpv = (char *)dmabuf;
> +			memcpy(tmpv, sgbuffer, amount);
> +			tmpv += amount;
> +			dmabuf = (unsigned *)tmpv;
>  		}
>  
> -		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
> +		kunmap_atomic(((void *)sgbuffer)-sg->offset, KM_BIO_SRC_IRQ);

Please put spaces around the minus sign.

	kunmap_atomic(((void *)sgbuffer) - sg->offset, KM_BIO_SRC_IRQ);

regards,
dan carpenter

>  
>  		if (size == 0)
>  			break;
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
