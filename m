Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZBWSYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZBWSYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZBWSYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:24:11 -0500
Received: from n9b.bullet.sp1.yahoo.com ([69.147.64.101]:24228 "HELO
	n9b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754656AbZBWSYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:24:09 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 791182.89346.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Uy2DxcTbGoj/GddkudXv2036ia6OvL5+tDbRnyocy/DcsyGVNQOQ1OvXOlMhzPExbo8tw75iHsAVyNs0D1/7F88G0sFxjhmkz1mMXoXuCy6jeAgqDWMI087GDPB4RIRJLXSwDy095JPQnONz6HzYzSZoIp3eVYG74f9EYWLf6d8=  ;
X-YMail-OSG: bwigxWQVM1nLtf32Y9B99WFuvp8VEoiLLSBs5J733vJlqnVEjLA2OX.m9p5dod752tQzzUWE2g4dMHx2C.i2VQ2f17OocNGA64utbgXq7oL6PKBmgemLa9T__jBb6pxZx7PIh4A8_qeoen5lSgwT8XJaZKoyjqmIViURD6gJazjC1hbhYMApbuAFIA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when resuming
Date: Mon, 23 Feb 2009 10:23:49 -0800
User-Agent: KMail/1.9.10
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?utf-8?q?=EA=B9=80=EA=B7=9C=EC=9B=90?= <q1.kim@samsung.com>,
       "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com> <9c9fda240902230426s2003d208xebeb6630c61b3bec@mail.gmail.com> <49A2A8ED.20208@nokia.com>
In-Reply-To: <49A2A8ED.20208@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902231023.49653.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Adrian Hunter wrote:
> Also, you will need the following patch if you actually want the power
> to go off.

Current GIT already has a patch supporting power-off for
MMC2; tested on SDP and some custom hardware.  So this
patch won't apply.

Are you sure that's needed for MMC1?  The led showing MMC1
power did go off correctly (when using MMC2 for root), and
the MMC1 regulator entry in sysfs agreed MMC1 was off.  So
I thought this was only an issue for MMC2 (and presumably
MMC3, though I don't have a board using it.)

I agree that code removed by this patch is ugly and worth
removing if it's not actually needed for MMC1.

- Dave


> From: Adrian Hunter <ext-adrian.hunter@nokia.com>
> Date: Fri, 30 Jan 2009 11:58:13 +0200
> Subject: [PATCH] OMAP: HSMMC: do not power up after powering off
> 
> The power is configured when probing and when resuming
> so the bus voltage does not need changing after power
> off.
> 
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 1e4a2e0..04e5a0c 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -859,16 +859,6 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>         switch (ios->power_mode) {
>         case MMC_POWER_OFF:
>                 mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
> -               /*
> -                * Reset bus voltage to 3V if it got set to 1.8V earlier.
> -                * REVISIT: If we are able to detect cards after unplugging
> -                * a 1.8V card, this code should not be needed.
> -                */
> -               if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
> -                       int vdd = fls(host->mmc->ocr_avail) - 1;
> -                       if (omap_mmc_switch_opcond(host, vdd) != 0)
> -                               host->mmc->ios.vdd = vdd;
> -               }
>                 break;
>         case MMC_POWER_UP:
>                 mmc_slot(host).set_power(host->dev, host->slot_id, 1, ios->vdd);



