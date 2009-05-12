Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZELXC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZELXC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZELXCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:02:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52065 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZELXCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:02:47 -0400
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain>
References: <1242094321.7214.156.camel@localhost.localdomain>
	 <4A095139.30347.48783F@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
	 <1242167171.3462.13.camel@localhost>
	 <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 12 May 2009 16:02:46 -0700
Message-Id: <1242169366.3462.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 00:42 +0200, Thomas Gleixner wrote:
> On Tue, 12 May 2009, john stultz wrote:
> > > stored or accumulated before. For the TSC calibaration one could build the average 
> > > of previous calibration values (if the value jumps between different numbers).
> > > That would require a sysctl (or equivalent) interface however.
> > 
> > I still feel that a sysctrl or /sys/ interface for this sort of thing is
> > overkill. It creates yet another interface we have to manage, and really
> > doesn't improve the situation more then the boot option would.
> > Additionally it would require quite a bit of work at the clocksource
> > level to allow for re-calibration (currently we avoid this by
> > disqualifying the TSC if it changes freq). 
> > 
> > That said, I've gotten very few positive comments from my patch, so I'm
> > going to give it one more spin (to address Serge's point) and if folks
> > are still feeling blah about it I'll stop pushing it.
> 
> I'm fine with the command line option, but I refuse to add some sys/
> thingy which makes us add extra calibration stuff.
> 
> Honestly all this is just the futile attempt to fix the flaws of NTP
> via (super)user interaction.
> 
> Darn, it can not be that hard to adjust the math to do what you think
> it should do. I'm not an expert on that NTP stuff, but blindly
> stuffing the last known value into the kernel and expect that the
> calibration value did not change is nonsense.

Well, only nonsense when using the TSC. Given that every other bit of
hardware either sticks to a fixed freq or provides its frequency to the
OS.

And the fact that boot-to-boot the TSC calibration code provides such
varying results illustrates how poor our calibration is, or how poor the
TSC's interface is for not providing its freq.

That said, the TSC is fast and fine grained, so its hard to tell folks
not to use it. Hard enough to convince people to avoid it when its
halting and changing frequency, and really can't be used for
timekeeping.

> You know the calibration value which created the last known parameters
> and you want an extra interface to inject this last known calibration
> value into the kernel instead of doing the math of adjusting the NTP
> parameters according to the change of calibration values ?

Again, I'd really not suggest NTP try to handle TSC calibration error
compensation itself. Either through the kernel or internally.

A) It would have to add linux-x86 specific kludge code
B) It would have to know to look at which clocksource was being used and
decide what to do from there (since ACPI_PM, HPET, PIT and even jiffies
doesn't need this extra tweaking).

Instead I propose, 
1) Improving the calibration code as best we can, given the time
constraints at boot-up.

A neat idea from Miroslav Lichvar: Round the TSC calibration results to
the nearest 100ppm. Although I suspect we already see variations beyond
100ppm, so some tweaking would probably be necessary. I'll be looking at
this option soon.

2) Provide a workaround (that doesn't create some sort of userland API
we have to manage forever) for users who really care about the
super-fine details of tsc calibration and its interactions with NTP.

This patch only provides #2 above.

thanks
-john


