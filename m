Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbZB0WIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbZB0WIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbZB0WIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:08:23 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:51297 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbZB0WIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:08:21 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1Lv6Etek1evhZ2ETpWV1q
Date: Fri, 27 Feb 2009 14:08:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: David Brownell <david-b@pacbell.net>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?utf-8?B?77+977+977+91L/vv70=?= <q1.kim@samsung.com>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers
	when resuming
Message-ID: <20090227220812.GM11594@atomide.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com> <200902231023.49653.david-b@pacbell.net> <49A3EF96.3090603@nokia.com> <200902241410.19132.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200902241410.19132.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Brownell <david-b@pacbell.net> [090224 14:14]:
> On Tuesday 24 February 2009, Adrian Hunter wrote:
> > > I agree that code removed by this patch is ugly and worth
> > > removing if it's not actually needed for MMC1.
> > 
> > Here is a patch against current OMAP tree.
> > 
> > From: Adrian Hunter <ext-adrian.hunter@nokia.com>
> > Date: Tue, 24 Feb 2009 14:48:16 +0200
> > Subject: [PATCH] OMAP: HSMMC: do not re-power when powering off MMC
> > 
> > Remove code that turns MMC1 power back on after it
> > has been powered off (when the voltage is 1.8V).
> > 
> > The offending code is not necessary because the
> > host controller bus voltage is initialized to
> > 3V when probing or resuming.  Note that MMC powers up
> > with the highest voltage available (see mmc_power_up())
> > which will be 3V also.
> > 
> > Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> 
> Looks OK to me -- ack.  Safe to merge through the MMC
> tree right away, but it'll be a NOP until the glue
> actually supports 1.8V correctly for MMC1 ... so IMO
> no rush to merge for 2.6.29-final.

Good to hear we get rid of that REVISIT part.. My ack here too.

Acked-by: Tony Lindgren <tony@atomide.com>
 
> > ---
> >  drivers/mmc/host/omap_hsmmc.c |   17 -----------------
> >  1 files changed, 0 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> > index c0d5420..43cec98 100644
> > --- a/drivers/mmc/host/omap_hsmmc.c
> > +++ b/drivers/mmc/host/omap_hsmmc.c
> > @@ -486,9 +486,6 @@ static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
> >         u32 reg_val = 0;
> >         int ret;
> >  
> > -       if (host->id != OMAP_MMC1_DEVID)
> > -               return 0;
> > -
> >         /* Disable the clocks */
> >         clk_disable(host->fclk);
> >         clk_disable(host->iclk);
> > @@ -787,20 +784,6 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> >         switch (ios->power_mode) {
> >         case MMC_POWER_OFF:
> >                 mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
> > -               /*
> > -                * Reset interface voltage to 3V if it's 1.8V now;
> > -                * only relevant on MMC-1, the others always use 1.8V.
> > -                *
> > -                * REVISIT: If we are able to detect cards after unplugging
> > -                * a 1.8V card, this code should not be needed.
> > -                */
> > -               if (host->id != OMAP_MMC1_DEVID)
> > -                       break;
> > -               if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
> > -                       int vdd = fls(host->mmc->ocr_avail) - 1;
> > -                       if (omap_mmc_switch_opcond(host, vdd) != 0)
> > -                               host->mmc->ios.vdd = vdd;
> > -               }
> >                 break;
> >         case MMC_POWER_UP:
> >                 mmc_slot(host).set_power(host->dev, host->slot_id, 1, ios->vdd);
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
