Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZBHQHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZBHQHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZBHQHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:07:31 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:24582 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752206AbZBHQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:07:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M9zzORULH1zhVMatrZv5fPMxQwNfxFzyCV7Qjm/76k0O8nadEiK40G57Htr/W+JPeWNskxnbEYwZE3+g3aGhWabWnYwgYSPo4925Po0tFVuSU3MpcWg9liF5HgxbLIo0q23HgrgKLs3fxBAxVPyGxYnxN4kgbUOdMPToUtWhGKg=  ;
X-YMail-OSG: vougCqEVM1l7yTyPQcqjF.0J1K1lYgLHi4gmvfeU2jFFFvIrIO9ZJ7roLHEX1WjrcXpjksLm5HcKz9IVDNBeXpXRZndPU9wZ3HPsErQ1ihmKvi1nlYqsJqJFEz9J0Q5Z_koUDYt.H0GzskuPjVyOgXkCtHENSbfBwh7LrouKr8Vx.qTmN28nsAEhzIFYY2hSGc.YEh7_sLDQDo8g5D1JIPW9R.WCMbECPoID7A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: pxa2xx_spi: spi_bfin5xx: limit reaches -1 rather than 0
Date: Sun, 8 Feb 2009 08:07:28 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <498F0004.1030709@gmail.com>
In-Reply-To: <498F0004.1030709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902080807.29237.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Roel Kluin wrote:
> vi drivers/spi/pxa2xx_spi.c +919 
> vi drivers/spi/spi_bfin5xx.c +645
> 
>         if (flush(drv_data) == 0) {
>                 dev_err(&drv_data->pdev->dev, "pump_transfers: flush failed\n");
>                 message->status = -EIO;
>                 giveback(drv_data);
>                 return;
>         }
> 
> But with a postfix decrement limit reaches -1 rather than 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Although, note that if the *actual* count mattered here,
the correect patch would be to test "flush() < 0)" ...
except when using a "do {...} while (--limit)" idiom.

Try the thought experiment of starting with "limit = 1";
not all of these patches of your would go through the 
loop even once.  Fortunately in all these cases, the
limit is an arbitrary "don't loop forever" thing.


> ---
>  drivers/spi/pxa2xx_spi.c  |    2 +-
>  drivers/spi/spi_bfin5xx.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
> index d0fc4ca..3164741 100644
> --- a/drivers/spi/pxa2xx_spi.c
> +++ b/drivers/spi/pxa2xx_spi.c
> @@ -185,7 +185,7 @@ static int flush(struct driver_data *drv_data)
>  		while (read_SSSR(reg) & SSSR_RNE) {
>  			read_SSDR(reg);
>  		}
> -	} while ((read_SSSR(reg) & SSSR_BSY) && limit--);
> +	} while ((read_SSSR(reg) & SSSR_BSY) && --limit);
>  	write_SSSR(SSSR_ROR, reg);
>  
>  	return limit;
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index 7fea3cf..ea94567 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -162,7 +162,7 @@ static int flush(struct driver_data *drv_data)
>  	unsigned long limit = loops_per_jiffy << 1;
>  
>  	/* wait for stop and clear stat */
> -	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && limit--)
> +	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && --limit)
>  		cpu_relax();
>  
>  	write_STAT(drv_data, BIT_STAT_CLR);
> 
> 


