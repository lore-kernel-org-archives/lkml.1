Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbZCCHYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbZCCHYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZCCHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:24:33 -0500
Received: from smtp.nokia.com ([192.100.122.230]:47332 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZCCHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:24:32 -0500
Subject: Re: [PATCH RFT] MMC: core/core.c: mmc_rescan detects card change
	in one run
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: ext Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090302210945.04bfa623@mjolnir.ossman.eu>
References: <1235057186-31714-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <20090302210945.04bfa623@mjolnir.ossman.eu>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Mar 2009 09:24:19 +0200
Message-Id: <1236065059.5791.34.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Mar 2009 07:24:21.0011 (UTC) FILETIME=[120D6E30:01C99BD1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks for your reply.

On Mon, 2009-03-02 at 21:09 +0100, ext Pierre Ossman wrote:
> On Thu, 19 Feb 2009 17:26:26 +0200
> Jorg Schummer <ext-jorg.2.schummer@nokia.com> wrote:
> 
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index df6ce4a..cd2e29f 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -740,6 +740,22 @@ void mmc_rescan(struct work_struct *work)
> >  
> >  	mmc_bus_get(host);
> >  
> > +	/* if there is a card registered */
> > +	if (host->bus_ops != NULL) {
> > +
> > +		if (host->bus_ops->detect && !host->bus_dead) {
> > +
> > +			/* check whether the card is still present */
> > +			host->bus_ops->detect(host);
> > +
> > +			/* release the bus and update bus status in case
> > +			   the card was removed */
> > +			mmc_bus_put(host);
> > +			mmc_bus_get(host);
> > +		}
> > +	}
> > +
> > +	/* if there is no card registered */
> >  	if (host->bus_ops == NULL) {
> >  		/*
> >  		 * Only we can add a new handler, so it's safe to
> 
> Perhaps it's more clear if you grab the lock for the first section,
> release it after and then regrab it for the second section. A bit less
> efficient, but I don't think that will be a problem in practice.

Yes, you're probably right, I should take read- and maintainability into
account there. Will change that.

> 
> > @@ -789,12 +805,8 @@ void mmc_rescan(struct work_struct *work)
> >  
> >  		mmc_release_host(host);
> >  		mmc_power_off(host);
> > -	} else {
> > -		if (host->bus_ops->detect && !host->bus_dead)
> > -			host->bus_ops->detect(host);
> > -
> > +	} else
> >  		mmc_bus_put(host);
> > -	}
> >  out:
> >  	if (host->caps & MMC_CAP_NEEDS_POLL)
> >  		mmc_schedule_delayed_work(&host->detect, HZ);
> 
> The else section got a bit small here with that code removed. Perhaps
> we should instead have:
> 
> 	if (host->bus_ops != NULL) {
> 		mmc_bus_put(host);
> 		goto out;
> 	}

I guess you meant

	else {
		mmc_bus_put(host);
		goto out;
	}

since it would be the else clause of

	if (host->bus_ops == NULL)


Also: Are you sure "goto out" should be added in the else-branch? (Since
it's not present in the end of the corresponding if-branch either, and
is technically not needed.)

Regards,
Jörg


