Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbZBXWMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbZBXWMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760252AbZBXWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:12:09 -0500
Received: from n9b.bullet.sp1.yahoo.com ([69.147.64.101]:37879 "HELO
	n9b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759885AbZBXWMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:12:07 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 215437.35034.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BRhpRCEyBtpzEq/OHtUJIJxj+pyx4nQN+Xr0PN5ebekIQ7MipaiwgkA/0Pw0q5V3QFwjf7TXgSx5pzRji62rDoUqD0xLev9i6S6q2HrhWRkaL79jV/hGvb5L1mFcaLbXcceMg+QRGf4+5iB4lj1UnZCHTp9oBIE+Y30TUqwIJxo=  ;
X-YMail-OSG: msa03lEVM1lUMMf6Cjg59TFSlkoLMTe8VqE6SMVIoZAQEZfSioPJsPE1nVqs_91jah4UP9tqyofjy36iEWUjJwzVl9ZmPhW7yvUtXjC9o.N.Zh2EEpywAI_FBMEaliGpiOm1oap8esrEN1E43hXqS8.Kdz5RF06xLu9btKYHODQYgdm6J9rvOmyzSTDY8jNUejLKfY6YViNtEW9YIdmJmMl5__LCUA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when resuming
Date: Tue, 24 Feb 2009 14:10:18 -0800
User-Agent: KMail/1.9.10
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?utf-8?q?=B1=E8=B1=D4=BF=F8?= <q1.kim@samsung.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com> <200902231023.49653.david-b@pacbell.net> <49A3EF96.3090603@nokia.com>
In-Reply-To: <49A3EF96.3090603@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902241410.19132.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Adrian Hunter wrote:
> > I agree that code removed by this patch is ugly and worth
> > removing if it's not actually needed for MMC1.
> 
> Here is a patch against current OMAP tree.
> 
> From: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Date: Tue, 24 Feb 2009 14:48:16 +0200
> Subject: [PATCH] OMAP: HSMMC: do not re-power when powering off MMC
> 
> Remove code that turns MMC1 power back on after it
> has been powered off (when the voltage is 1.8V).
> 
> The offending code is not necessary because the
> host controller bus voltage is initialized to
> 3V when probing or resuming.  Note that MMC powers up
> with the highest voltage available (see mmc_power_up())
> which will be 3V also.
> 
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>

Looks OK to me -- ack.  Safe to merge through the MMC
tree right away, but it'll be a NOP until the glue
actually supports 1.8V correctly for MMC1 ... so IMO
no rush to merge for 2.6.29-final.


> ---
>  drivers/mmc/host/omap_hsmmc.c |   17 -----------------
>  1 files changed, 0 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index c0d5420..43cec98 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -486,9 +486,6 @@ static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
>         u32 reg_val = 0;
>         int ret;
>  
> -       if (host->id != OMAP_MMC1_DEVID)
> -               return 0;
> -
>         /* Disable the clocks */
>         clk_disable(host->fclk);
>         clk_disable(host->iclk);
> @@ -787,20 +784,6 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>         switch (ios->power_mode) {
>         case MMC_POWER_OFF:
>                 mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
> -               /*
> -                * Reset interface voltage to 3V if it's 1.8V now;
> -                * only relevant on MMC-1, the others always use 1.8V.
> -                *
> -                * REVISIT: If we are able to detect cards after unplugging
> -                * a 1.8V card, this code should not be needed.
> -                */
> -               if (host->id != OMAP_MMC1_DEVID)
> -                       break;
> -               if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
> -                       int vdd = fls(host->mmc->ocr_avail) - 1;
> -                       if (omap_mmc_switch_opcond(host, vdd) != 0)
> -                               host->mmc->ios.vdd = vdd;
> -               }
>                 break;
>         case MMC_POWER_UP:
>                 mmc_slot(host).set_power(host->dev, host->slot_id, 1, ios->vdd);



