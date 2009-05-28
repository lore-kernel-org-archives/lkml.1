Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbZE1S2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbZE1S2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZE1S16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:27:58 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54345 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbZE1S15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:27:57 -0400
Date: Fri, 29 May 2009 03:27:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090528182730.GA32767@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090528124207.GA28830@linux-sh.org> <1243515570.6600.96.camel@laptop> <1243527218.28705.35.camel@desktop> <1243528329.6645.77.camel@laptop> <20090528164011.GA30104@linux-sh.org> <1243529547.28705.43.camel@desktop> <20090528165816.GA31688@linux-sh.org> <1243532324.28705.75.camel@desktop> <20090528175341.GA32118@linux-sh.org> <1243534252.28705.86.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243534252.28705.86.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 11:10:52AM -0700, Daniel Walker wrote:
> On Fri, 2009-05-29 at 02:53 +0900, Paul Mundt wrote:
> > Yes, we want to be able to use modular clocksources. The only reason we
> > don't right now is because some more preparatory work is needed first.
> > Any attempt to remove support for modular clocksources means we will just
> > have to add it in back later.
> 
> This is what's difficult to understand.. You have multiple clocks ok,
> fine.. You have multiple clocks that you want the kernel to switch
> between, ok that's fine too.. What's missing is the case where
> clocksource modules being loaded/unload via the user becomes a valuable
> use case..
> 
> If you have a valuable use case for that, fine, I won't stand in the
> way ..
> 
Ah, ok, I suppose I could have explained that better. There are a couple
of different considerations really. The timer blocks are often in
different clock and power domains, meaning that only certain ones can be
used for wakeups. These tend not to be ideal for general use, and so we
only switch to them when we have to.

To make matters more convoluted, the availability of different timer
channels on different CPUs will depend on current pin state, and more
importantly, what sort of states we are able to achieve. It is not
uncommon to have some of the pins required by these channels locked down
by other drivers during regular operation, which we in turn need to
unload before the pin state can be reconfigured and the timer can
succeed, all which needs to happen before certain power state transitions
can take place. We implement dynamic pinmux for most of the SH CPUs
precisely to deal with these sorts of problems. In the case of some of
the microcontrollers that are timer heavy and low on pincount, it is not
uncommon to have upwards of 16 different functions per pin.
