Return-Path: <linux-kernel-owner+w=401wt.eu-S1765710AbYEUSrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765710AbYEUSrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbYEUSrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:47:16 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:5294 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755892AbYEUSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:47:15 -0400
Date: Wed, 21 May 2008 22:47:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card
	detect line
Message-ID: <20080521184713.GA30284@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080516165057.GC24196@polina.dev.rtsoft.ru> <20080517133633.5aa26938@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080517133633.5aa26938@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 01:36:33PM +0200, Pierre Ossman wrote:
> On Fri, 16 May 2008 20:50:57 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > Some boards do not use interrupts on the CD line, so we want to poll
> > the CD and see if there was a change. 1 second poll interval seems
> > resonable.
> > 
> 
> The idea isn't bad, but I'm not sure about the mechanism.
> 
> To poll a MMC slot, you do not really need a card detect at all. The
> MMC layer can just shoot off some requests and see if anything
> responds.  The PXA driver (if my memory serves me right) already does
> this. So the best idea there would be to add this feature to the MMC
> core and let the host indicate that it needs it via MMC_CAP_NEEDS_POLL
> or something like that.
> 
> The card detection pin then becomes an optimisation, something that is
> also useful in other ways. Have the host driver check the card detection
> pin at the start of every request, and quickly fail it if there is no
> card present.

Calling get_cd() for every request smells like overhead, especially given
that that get_cd() could ask for GPIO status via relatively slow bus (like
I2C GPIO expanders). So, polling seems most reasonable solution here, no
need to call it very often.

How about these patches? Tested with and without get_cd() optimization.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
