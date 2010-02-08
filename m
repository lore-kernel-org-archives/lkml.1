Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0BHJhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:37:22 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45864 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0BHJhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:37:20 -0500
Date: Mon, 8 Feb 2010 10:37:19 +0100
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100208093719.GA15428@rhlx01.hs-esslingen.de>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 10:13:00AM +0100, Thomas Gleixner wrote:
> On Mon, 8 Feb 2010, Andreas Mohr wrote:
> > 
> > And then a cat current_clocksource managed to hang again.
> 
> Well, that's not surprising at all. If one task is stuck on clocksource_mutex,
> then the next one will be stuck as well.

I believe here you are pointing at the initial bootup acpi_pm lockup which NMI
watchdog detected. And not some thought that I somehow simply executed
cat current_clocksource twice, given my wording which might erroneously
hint at that.


So you'd think that we have a clocksource_mutex problem even before
the initial bootup switch to acpi_pm?

However I don't see how this could be the case, given that in some instances
boot does continue after acpi_pm selection, albeit after a delay.

> > (NOTE that the - now complete! - SysRq-T list does NOT show any backtraces
> > of kwatchdog any more, only many other processes)
> > Could it be that the (rather disruptive) NMI watchdog confuses the current state at
> > change_clocksource and causes that stuff to get left with
> > clocksource_mutex remaining taken?
> 
> Nope, the NMI watchdog is not involved. It merily tells us that the
> task is stuck.

OK.
And after that message debug_locks is zeroed and kwatchdog is gone
from the process list (probably during debug_locks change).



I still can't make much reason of this behaviour.
If we have a problem during acpi_pm selection on boot, then by all
accounts it should get stuck completely (plus yielding watchdog's lockup
message), not continue booting after some weird delay.
OK, this particular delay phenomenon could still be explained
by a pretty severe contention,
but then after successfully having gotten the mutex it certainly
shouldn't happen that then even after bootup the mutex remains blocked
(as witnessed by the cat current_clocksource issue).
After all all mutex use is fully symmetric, no surprises IMHO - unless
NMI / SMI or so are involved.



I'll explain what I think might be happening:
bootup switches to acpi_pm, timekeeping gets borked, NMI watchdog complains
due to timekeeping issues, brutally yanks the waiting acpi_pm switchover
(thereby NOT releasing clocksource_mutex),
and the result is that I have cat current_clocksource stuck in my userspace.

Andreas Mohr
