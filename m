Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbZFWNQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbZFWNQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZFWNQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:16:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbZFWNQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:16:41 -0400
Date: Tue, 23 Jun 2009 15:16:28 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090623131628.GA11827@localhost>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost> <1245253102.6067.94.camel@jstultz-laptop> <20090617172325.GA32332@localhost> <20090617172601.GA3493@elte.hu> <20090618121320.GA13025@localhost> <20090623095745.GC30634@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623095745.GC30634@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:57:45AM +0200, Ingo Molnar wrote:
> > > Wouldnt the goal be to calibrate as fast as possible? (Without 
> > > any bad oscillation)
> > 
> > Not really. It depends on how noisy is the input signal. On an 
> > idle LAN the jitter is just few microseconds, but over internet it 
> > easily reaches miliseconds. Over a certain point faster PLL will 
> > just make things worse.
> 
> That is what i called 'bad oscillation' - a 'too fast' PLL that 
> over-compensates and does not converge well enough.
> 
> Is there a claim that this change causes that? (John's testing 
> suggested that there's no such effect)

I think John's tests were done on LAN and in an environment with
sudden temperature changes. This is the case where frequency
variations strongly dominate the noise and faster PLL performs better.

On the opposite side is an idle machine in a room with stable
temperature syncing over wireless or dial-up. I don't have access to
such machine, but in simulations (noise with exponential distribution)
I see that offset RMS doubles when the time constant is decreased by 2.

Maybe for most of the users the change would be an improvement. I
don't have any statistics to back it up or claim otherwise. However,
if the constant needs to be adjusted, it's better to do it in NTP.

> > PLL is mainly about handling the signal noise, frequency adjusting 
> > is secondary. When the noise is very low or the update interval is 
> > long enough, the frequency variations caused by temperature 
> > changes will dominate the signal noise and this is where FLL 
> > should kick in.
> > 
> > The PLL/FLL switching is controlled by update interval. Ideally it 
> > would be adaptive, but NTP is not that sophisticated. By default, 
> > FLL is enabled when the interval is longer than 2048 seconds. This 
> > is of course not the optimal value for all systems.
> > 
> > Unfortunately in kernel it can be configured only to 2048 or 256 
> > and NTP never uses the shorter one. The NTP daemon has its own 
> > loop which can be used instead and it allows to use arbitrary 
> > values though.
> 
> How about going towards the ideal, adaptive design, to which ntpd 
> passes in time samples and which observes noise and converges as 
> quickly as possible (given the noise level) and stays stable once 
> there? I guess we need extensions to the NTP syscall for that.

Not sure how hard that would be. The ntp-hackers list is a better
place to discuss such modifications.

Other NTP clients don't have to use the PLL interface. For example,
chrony uses only the SINGLESHOT mode and sets the frequency directly.
It has an adaptive model using linear regression, it converges really
fast and in my tests performs better than NTP.

> The NTP code in kernel/time/ntp.c is now reasonably clean for 
> efforts like that.
> 
> It would also pave the way to properly support PPS devices in the 
> kernel. Would you be interested in things like this?

I'm not very familiar with the PPS API, is there something wrong with
it?

-- 
Miroslav Lichvar
