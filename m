Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbZLIRpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbZLIRpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZLIRpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:45:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50875 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZLIRpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:45:34 -0500
Date: Wed, 9 Dec 2009 17:45:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async resume patch (was: Re: [GIT PULL] PM updates for 2.6.33)
Message-ID: <20091209174537.GJ9018@sirena.org.uk>
References: <20091209160256.GA3229@rakim.wolfsonmicro.main> <Pine.LNX.4.44L0.0912091117080.4120-100000@iolanthe.rowland.org> <20091209164653.GI9018@sirena.org.uk> <alpine.LFD.2.00.0912090851540.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912090851540.3560@localhost.localdomain>
X-Cookie: Include me out.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 08:57:32AM -0800, Linus Torvalds wrote:
> On Wed, 9 Dec 2009, Mark Brown wrote:

> > Worst case is about a second for both resume and suspend which means two
> > seconds total but it's very hardware dependant.  

> I would seriously suggest just looking at the code itself.

> Maybe the code is just plain sh*t? If we're talking embedded audio, we're 
> generally talking SoC chips (maybe some external audio daughtercard), and 

Yes, usually this is a SoC plus one or more external devices handling
the mixed signal parts of things all soldered down onto a board.

> quite frankly, it sounds to me like you're just wasting your own time. 
> There is no way that kind of hardware really needs that much time.

Some of the older hardware really does need that much time, sadly.
More recent hardware got that down much lower (into the low hundreds of
ms where it's much less of an issue but still present) and current
generations basically don't have the problem any more but for worst case
a second is a good approximation.

The problem comes when you've got audio outputs referenced to something
other than ground which used to happen because no negative supplies were
available in these systems.  To bring these up from cold you need to
bring the outputs up to the reference level but if you do that by just
turning on the power you get an audible (often loud) noise in the output
from the square(ish) waveform that results which users don't find
acceptable.

The initial solution was to ramp the voltage on the outputs in such a
way that the waveform that appears on the outputs isn't audible, which
broadly boils down to ramping it slowly.  People were very aware of the
problems so later generations of devices added features which allowed
this to happen much more quickly than the original implementations had,
but still noticably slow in terms of the timescales people need.

Current generation hardware solves the problem by using charge pumps to
provide a negative supply, allowing ground referenced outputs which are
just a win all round for this and other reasons.  They're fast enough to
allow the power up to be brought completely in line with the start of
the audio stream, taking this out of suspend and resume entirely.

> Now, I can easily see one-second delays in code that simply has never been 
> thought about or cared about it. We used to have things like that in the 
> serial code where just probing for non-existent serial ports took half a 
> second per port because there was a timeout. 

It's a deliberate delay waiting for the voltages to ramp, there's plenty
of things that need to be fixed or optimised in the code but those that
are causing issues these days really are just explicitly inserted delays
waiting for things to happen in hardware that do actually take that long.

> Because bad coding is much more likely to be the real reason.

Would that it were - you wouldn't believe the amount of time that's been
spent over the years tuning for this.
