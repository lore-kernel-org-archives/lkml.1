Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZDXK6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZDXK6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZDXK6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:58:22 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50765 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZDXK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:58:21 -0400
Date: Fri, 24 Apr 2009 13:57:56 +0300
From: "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] TWL4030: Activate VDD1, VDD2 and VPLL1 at startup
Message-ID: <20090424105756.GB4720@codecarver.research.nokia.com>
References: <1240492208-14791-1-git-send-email-peter.de-schrijver@nokia.com> <1240492208-14791-2-git-send-email-peter.de-schrijver@nokia.com> <200904231453.47223.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904231453.47223.david-b@pacbell.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-OriginalArrivalTime: 24 Apr 2009 10:57:58.0446 (UTC) FILETIME=[8751CCE0:01C9C4CB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 11:53:47PM +0200, ext David Brownell wrote:
> On Thursday 23 April 2009, Peter 'p2' De Schrijver wrote:
> > This patch activates VDD1, VDD2 and VPLL1 when booting. This is necessary
> > because these resources are in warm reset state after a reboot.
> 
> Warm reset state?  I thought there were only ACTIVE, SLEEP, and OFF
> states for individual resources.  Do you mean SLEEP?  And if so, is
> this not something that should be dealt with by the power script
> which runs inside the twl4030 when it handles the warm reset event?
> 

No. I don't mean SLEEP. WARM-RESET state means the output level has its
default value. I think this is used to prevent any DVFS or smartreflex
related changes during warm reset. At least the TRM suggests to do this
from the 'software'. I will ask my contact at TI why they suggest to do
it this way.

> I thought those regulators couldn't provide enough power from SLEEP
> state to let the system boot.  So being able to run this code means
> they're not in SLEEP state...
> 

That's correct.

> Please explain.  (Remembering that most of us haven't really looked
> in much detail at this level of reset even handling!)
> 

I haven't read the public TRM on this part, so I don't know how much of
this is undocumented for you.

> 
> > This means 
> > their voltage levels cannot be modified so DVFS and smartreflex don't work.
> 
> Three thoughts on this:
> 
>  - These three switching regulators are currently ignored by this
>    driver, because I've expected them to be managed as part of the
>    DVFS framework.  (Mostly via the hardware SmartReflex support.
>    They don't seem particularly geared for software control.)
> 

VPLL1 is not managed by DVFS or smartreflex. OTOH it needs to be on all
the time, so there is no point in controlling them from software I
guess.

>    It seems odd to add these hooks for regulators that are otherwise
>    consciously ignored by this driver, and not software-controlled...
> 
>  - This *could* be done with the twl4030-power.c (nyet in mainline)
>    resource_config hooks.  But those hooks are board-specific (and
>    nyet in mainline), while these should "always" be done.
> 

Indeed. At least that's my understanding now.

>    Should we maybe have all those power resource init hooks done
>    by the twl4030_core.c code?  So as to work even if regulator
>    and power (script) drivers aren't present.
> 

You mean moving this to twl4030_core.c ?

>  - The policy you described is specific to OMAP3 ... so shouldn't
>    these changes be conditionalized so they only kick in on OMAP3
>    based platforms?  (Just as code-cleanliness for now; no other
>    platform yet uses these PMIC solutions, that I've heard of.)
> 

I don't really know. Even on non OMAP3 platforms, I would expect VDD1
and VDD2 to control core voltages, as those are the ones which you can
easily use for DVFS and they are SMPS. I don't really see why you would
use TWL4030 (and cope with its complexity) if you don't want to make use
of these features. 

>    And if they only matter for DVFS + SmartReflex ... should they
>    maybe be conditionalized for those, too?  (Minor point at best;
>    it "shouldn't" hurt to do this at other times too.)  Or maybe
>    even put into a twl4030-smartreflex.c driver, if there'd be
>    much for that to do.  Setting FLOOR and CEILING voltages and
>    other stuff in section 5.5.1 of the tps65950 manual (step 4),
>    for example.
> 
> Having this in twl4030-core.c would affect the patch you sent to
> move the "send PowerBus message" logic to its own function; that
> would need to be in twl4030_core too.
> 

I think that might be a good idea anyway. It seems sending these
powerbus messages needs to be done more often then we expected when
initially writing the twl4030 code.

Cheers,

Peter.

-- 
goa is a state of mind
