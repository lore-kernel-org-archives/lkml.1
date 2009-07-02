Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZGBLL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZGBLL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZGBLLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:11:48 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:41979
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbZGBLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:11:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvkBAKMyTEp8qMex/2dsb2JhbAAIzxCEEQU
X-IronPort-AV: E=Sophos;i="4.42,332,1243785600"; 
   d="scan'208";a="471550196"
Subject: Re: [PATCH] MMC Core: Drop initialization frequency floor to 50kHz
From: Ben Nizette <bn@niasdigital.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: s.hauer@pengutronix.de, linux-kernel <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>
In-Reply-To: <20090702091808.6108d0a9@mjolnir.ossman.eu>
References: <1246492196.2980.17.camel@linux-51e8.site>
	 <20090702091808.6108d0a9@mjolnir.ossman.eu>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 21:10:50 +1000
Message-Id: <1246533050.2980.47.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 09:18 +0200, Pierre Ossman wrote:

> 
> 50 kHz seems very low. I'd be more comfortable if we deviate from
> specified behaviour as little as possible, say 300 kHz. Has anyone
> checked what USB readers use?

Before this patch my controller used ~135kHz, I was just basing the
floor off that.  If the spec says 400 and this is just to work around
broken cards then sure, 300kHz sounds a good plan.

> 
> And have you confirmed that the card is actually getting 350 kHz when
> it fails? Perhaps there is a bug that is causing it to actually run at
> a higher frequency.

'scope confirmed that when 400kHz is requested my controller is giving
the card ~397kHz.

> 
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index d84c880..6ee1931 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -708,12 +708,13 @@ static void mmc_power_up(struct mmc_host *host)
> >  	 */
> >  	mmc_delay(10);
> >  
> > -	if (host->f_min > 400000) {
> > -		pr_warning("%s: Minimum clock frequency too high for "
> > -				"identification mode\n", mmc_hostname(host));
> > -		host->ios.clock = host->f_min;
> > -	} else
> > -		host->ios.clock = 400000;
> > +	/*
> > +	 * Card discovery is typically done at the controller's minimum
> > +	 * allowable frequency but for some controllers this is minimum
> > +	 * is unreasonably slow.  In that case we limit slow clock rate
> > +	 * to 50KHz.
> > +	 */
> > +	host->ios.clock = max(host->f_min, 50000);
> >  
> 
> I like getting that warning for too fast controllers. It makes it
> easier to spot possible problems.

For sure, it's just that if the floor is 50kHz then pretty much /every/
controller is a 'fast' controller and the warning's redundant.  If you
just drop the 400k to 300k, I agree the warning's a good thing to have.

Cheers,
	--Ben.

> 
> Rgds

