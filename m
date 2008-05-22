Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYEVSR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYEVSR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYEVSRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:17:16 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:8437 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750991AbYEVSRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:17:15 -0400
Date: Thu, 22 May 2008 22:17:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card
	detect line
Message-ID: <20080522181713.GA26918@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080516165057.GC24196@polina.dev.rtsoft.ru> <20080517133633.5aa26938@mjolnir.drzeus.cx> <20080521184713.GA30284@polina.dev.rtsoft.ru> <20080521212831.523f344b@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080521212831.523f344b@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 09:28:31PM +0200, Pierre Ossman wrote:
> On Wed, 21 May 2008 22:47:13 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > 
> > Calling get_cd() for every request smells like overhead, especially given
> > that that get_cd() could ask for GPIO status via relatively slow bus (like
> > I2C GPIO expanders). So, polling seems most reasonable solution here, no
> > need to call it very often.
> > 
> 
> Fair enough. You should probably add a comment about this somewhere so
> that people do not call get_cd() in the core request function and
> similar places. Place it so that both get_cd() and get_ro() are covered
> though, as it should be relevant for both.

I think this is applicable to the .set_ios() too.

[...]
> > +	if (host->ops->get_cd) {
> > +		int old_cd_status = host->cd_status;
> > +
> > +		host->cd_status = !!host->ops->get_cd(host);
> > +		if (!(old_cd_status ^ host->cd_status)) {
> > +			mmc_bus_put(host);
> > +			goto out;
> > +		}
> > +	}
> > +
> 
> This should only be done when there is no bus handler. Since we are
> polling, we might actually miss the user removing and reinserting the
> card. The only way to check for that is to poke the card and see if it
> is still alive. This also means you won't need that state variable.

Yeah, this makes sense. Indeed pretty easy to trigger [if poll interval
increased to 3 seconds, for example].

> Also, that second if clause seems fit for an obfuscation contest. ;)

cd_status was a bitfield, so I thought that bit operations would be
appropriate. :-)

> > p.s. Since mmc_host_ops no longer the same for every instance of
> > mmc_spi, struct mmc_host_ops can't be const and should be allocated
> > dynamically.
> 
> This can be solved by allowing get_cd() to return an error that will be
> treated as if get_cd() wasn't defined. -ENODEV seems suitable.

-ENOSYS (not implemented) sounds better for this purpose...

> (get_ro() needs the same treatment, but I haven't gotten around to
> that)

Ok. How about this version?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
