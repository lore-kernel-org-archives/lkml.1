Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYECVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYECVDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYECVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:03:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYECVDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:03:37 -0400
Date: Sat, 3 May 2008 23:03:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503210300.GA10979@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503202416.GR5838@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> > > You wrongly (and loudly) blamed Dmitry for something you broke 
> > > yourself.
> > 
> > i didnt. Read what i wrote:
> > 
> > || no, you are wrong, read the current Kconfig rules again. If the user 
> > || can create a .config that does not build, it is driver breakage. It 
> > || always was, and has been in the past 15 years.
> > ||
> > || Kconfig might be extended to make dependencies easier to manage for 
> > || developers but until that is implemented you have to craft your 
> > || driver's dependencies with the current tools in a way that doesnt 
> > || break the build.
> > 
> > and that's exactly what happens with Roman's patch: a Kconfig subsystem 
> > design bug (its inability to properly propagate the dependencies of 
> > select's) is worked around in the driver space: by the LEDS_CORE driver 
> > config introduction and no user-visible.
> > 
> > Roman's patch is obviously cleaner than my hack (i just fixed a single 
> > instantiation of the problem, while he changed the LEDS driver 
> > dependency structure), but it's still a workaround for a Kconfig 
> > subsystem bug and the same problem could reoccur elsewhere. It could hit 
> > anytime dual dependencies are introduced in a driver accidentally.
> 
> Ingo, perhaps it helps if I put it in caps:
> 
> YOU TRIED TO PUSH AN INPUT PATCH FOR AN X86 BUG.

Adrian, your tone is getting more and more abusive, and while i can 
easily ignore your abuse you are not just doing it towards me but 
towards other kernel developers as well. You need to stop that.

Yes, the incomplete (and buggy) select came from an x86 Kconfig file but 
you missed the real argument. Half a dozen other times similar bugs came 
from other portions of the tree so it's a reoccuring pattern of bugs.

And had you read the exchange more carefully you'd notice that the 
discussion was about the Kconfig subsystem bug which is causing all 
these other bugs - which Kconfig subsystem bug is still unfixed. In the 
discussion Dmitry assumed the obvious: that a select on a component will 
also select the sub-components. The problem is - select does not do 
that.

> Roman's patch is better than adding a select, but your patch would 
> have added the select in the completely wrong subsystem.

sure, and that's exactly what i said above: "Roman's patch is obviously 
cleaner than my hack". It avoids this problem by creating a single 
target to select for.

A wrong/buggy select _somewhere_ (this time the bug indeed was in an x86 
subarch Kconfig - but often it was just in a driver that tried to enable 
LEDS support) breaks the build - instead of propagating dependencies or 
at least warning about the problem. That's a Kconfig subsystem design 
bug and it has been known for years.

it's now worked around by Roman's patch by making the LEDS Kconfig 
structure simpler so there's just a single select target. But the root 
cause was not fixed and similar issues could hit the kernel anytime in 
the future. So it's not a real fix - it just prolonges the real fix some 
more.

> Why can't you admit the patch you tried to push was wrong?

how many times do i have to repeat it that yes it was a hack and that it 
was wrong?

> > As Sam said it, fixing that Kconfig design bug would be "nice" - but 
> > unfortunately the Kconfig subsystem is not actively developed 
> > anymore.
> 
> Roman is still active.

great, does this mean we'll see fixes for select's misbehavior, along 
the lines of Sam's suggestions?

at minimum a warning needs to be emitted by the kconfig tool if such 
incomplete selects are used. I've stopped counting the number of times 
such issues have broken the build and have held up kernel development. 

All the information is already in the Kconfig files for the kconfig 
tool/subsystem to make an intelligent decision. It's just not fully 
used, and the burden of fixing these problems is pushed back to the 
developers who create the Kconfig files.

	Ingo
