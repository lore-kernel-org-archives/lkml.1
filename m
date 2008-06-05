Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYFEOnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYFEOnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYFEOnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:43:14 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24135 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752035AbYFEOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:43:13 -0400
Date: Thu, 5 Jun 2008 18:43:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/3] mmc: change .get_ro() callback semantics
Message-ID: <20080605144310.GA31596@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080523154204.GA19803@polina.dev.rtsoft.ru> <20080523154347.GC24862@polina.dev.rtsoft.ru> <200806031207.49843.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200806031207.49843.marc.pignat@hevs.ch>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 12:07:49PM +0200, Marc Pignat wrote:
> Hi all!
> 
> On Friday 23 May 2008, Anton Vorontsov wrote:
> > get_ro() callback must return values >= 0 for its logical state, and
> ...
> >  static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> > diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> > index f2e9885..ef3b773 100644
> > --- a/include/linux/mmc/host.h
> > +++ b/include/linux/mmc/host.h
> > @@ -55,6 +55,9 @@ struct mmc_host_ops {
> >  	 * Avoid calling these three functions too often or in a "fast path",
> >  	 * since underlaying controller might implement them in an expensive
> >  	 * and/or slow way.
> > +	 *
> > +	 * .get_ro and .get_cd should return >= 0 for their logical values,
> > +	 * or negative errno value in case of error.
> >  	 */
> 
> I would suggest to use something more strict (bulletproof), something like:
> 
> /*
>  * get_ro will return:
>  *   0 for a read/write card
>  *   1 for a read-only card 

This isn't always practical. For example, host is using u8 register for
the status, so it might safely return u8 & mask, that will always fit
into int. Or very smart/adventurous authors might be aware that, for the
particular host, mask's bit isn't last, and safely do uXX & mask. :-)

The above is weak argument of course, since it is about optimization.

As an counter-evidence, the strict scheme that you described probably
less error prone. But is it? To implement it we'll need something like
WARN_ON(ret > 0 && ret != 1) to catch erroneous users. Take a closer
look though, will it catch uXX & lastbit case? Nope. :-)

We can catch bogus users though... via hack (_assuming_ that there
are no errno values of 1 << (sizeof(int) * 8 - 1)), i.e.
WARN_ON(ret == (1 << (sizeof(int) * 8 - 1)). Though, to do so, we don't
need the strict scheme, this debugging hack will work in the current
scheme too.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
