Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZFWJ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZFWJ6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZFWJ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:58:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41708 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZFWJ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:58:03 -0400
Date: Tue, 23 Jun 2009 11:57:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090623095745.GC30634@elte.hu>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost> <1245253102.6067.94.camel@jstultz-laptop> <20090617172325.GA32332@localhost> <20090617172601.GA3493@elte.hu> <20090618121320.GA13025@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618121320.GA13025@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miroslav Lichvar <mlichvar@redhat.com> wrote:

> On Wed, Jun 17, 2009 at 07:26:01PM +0200, Ingo Molnar wrote:
> > * Miroslav Lichvar <mlichvar@redhat.com> wrote:
> > 
> > > Still, I'd really like to see the original behavior restored. 
> > > Most of the users complaining about slow convergence are 
> > > probably just hitting the calibration problem, which needs to 
> > > be fixed by other means than making PLL faster. Also, users of 
> > > other systems seem to be happy with their slow convergence. At 
> > > least that's the impression I have from NTP lists.
> > 
> > Wouldnt the goal be to calibrate as fast as possible? (Without 
> > any bad oscillation)
> 
> Not really. It depends on how noisy is the input signal. On an 
> idle LAN the jitter is just few microseconds, but over internet it 
> easily reaches miliseconds. Over a certain point faster PLL will 
> just make things worse.

That is what i called 'bad oscillation' - a 'too fast' PLL that 
over-compensates and does not converge well enough.

Is there a claim that this change causes that? (John's testing 
suggested that there's no such effect)

> PLL is mainly about handling the signal noise, frequency adjusting 
> is secondary. When the noise is very low or the update interval is 
> long enough, the frequency variations caused by temperature 
> changes will dominate the signal noise and this is where FLL 
> should kick in.
> 
> The PLL/FLL switching is controlled by update interval. Ideally it 
> would be adaptive, but NTP is not that sophisticated. By default, 
> FLL is enabled when the interval is longer than 2048 seconds. This 
> is of course not the optimal value for all systems.
> 
> Unfortunately in kernel it can be configured only to 2048 or 256 
> and NTP never uses the shorter one. The NTP daemon has its own 
> loop which can be used instead and it allows to use arbitrary 
> values though.

How about going towards the ideal, adaptive design, to which ntpd 
passes in time samples and which observes noise and converges as 
quickly as possible (given the noise level) and stays stable once 
there? I guess we need extensions to the NTP syscall for that.

The NTP code in kernel/time/ntp.c is now reasonably clean for 
efforts like that.

It would also pave the way to properly support PPS devices in the 
kernel. Would you be interested in things like this?

	Ingo
