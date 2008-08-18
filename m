Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbYHRThX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbYHRThX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbYHRTfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:35:21 -0400
Received: from isilmar.linta.de ([213.133.102.198]:46954 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757900AbYHRTfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:35:19 -0400
Date: Mon, 18 Aug 2008 21:35:17 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, andi@lisas.de
Subject: Re: [git pull?] clocksource: ACPI pmtmr bugfixes [Was: Re: ACPI PM-Timer on K6-3 SiS5591: Houston...]
Message-ID: <20080818193517.GA22097@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
	alan@lxorguk.ukuu.org.uk, arjan@infradead.org, andi@lisas.de
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de> <20080818190325.GA12581@comet.dominikbrodowski.net> <20080818121924.6b61f7af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818121924.6b61f7af.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Aug 18, 2008 at 12:19:24PM -0700, Andrew Morton wrote:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git clocksource
> > 
> > Dominik Brodowski (2):
> >       acpi_pm.c: use proper read function also in errata mode.
> >       acpi_pm.c: check for monotonicity
> > 
> >  drivers/clocksource/acpi_pm.c |   50 +++++++++++++++++++++++-----------------
> >  1 files changed, 29 insertions(+), 21 deletions(-)
> 
> A bare git URL is somewhat user-unfriendly.

uh, sorry about that.

> : commit b985f0517e31c1204b5aafb94f86202948f00e16
> : Author: Dominik Brodowski <linux@dominikbrodowski.net>
> : Date:   Sun Aug 10 21:24:21 2008 +0200
> : 
> :     acpi_pm.c: use proper read function also in errata mode.
> :     
> :     When acpi_pm is used in errata mode (three reads instead of one), also the
> :     acpi_pm init functions need to use three reads instead of just one.
> 
> hm, why?  Was there some observeable problem which this change improved?

Indeed: on all affected hardware (some Intel ICH4, PIIX4 and PIIX4E chipsets)
there's about a 4.2% chance that initialization of the ACPI PMTMR fails. On
those chipsets, we need to read out the timer value at least three times to
get a correct result, for every once in a while (i.e. within a 3 ns window
every 69.8 ns) the read returns a bogus result. During normal operation we
work around this issue, but during initialization reading a bogus value may
lead to -EINVAL even though the hardware is usable.

> :     acpi_pm.c: check for monotonicity
> :     
> :     Expand the check for monotonicity by doing ten tests instead of one.
> 
> Why?

Indeed: http://lkml.org/lkml/2008/8/10/77 -- quote:
"Result: catastrophic timer behaviour (a large backwards skip is possible),"

The current check for monotonicity is way too weak. And at least on one
system out there PMTMR is unuseable, but the current check fails.

> I guess this file falls under Thomas's git-hrt tree.  I can queue the
> patches up and spam Thomas with them, but I'm at a bit of a loss
> regarding their priority due to the above questions.

That would be great, thanks.

	Dominik
