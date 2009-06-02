Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZFBO02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZFBO02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbZFBO0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:26:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:35538 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZFBO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:26:17 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090602141737.GA2449@debian>
References: <20090602071718.GA17710@linux-sh.org>
	 <20090602141737.GA2449@debian>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 16:25:41 +0200
Message-Id: <1243952741.13761.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 19:47 +0530, Rabin Vincent wrote:
> On Tue, Jun 02, 2009 at 04:17:18PM +0900, Paul Mundt wrote:
> > sched: sched_clock() clocksource handling.
> > 
> > There are presently a number of issues and limitations with how the
> > clocksource and sched_clock() interaction works today. Configurations
> > tend to be grouped in to one of the following:
> > 
> >     - Platform provides a clocksource unsuitable for sched_clock()
> >       and prefers to use the generic jiffies-backed implementation.
> > 
> >     - Platform provides its own clocksource and sched_clock() that
> >       wraps in to it.
> > 
> >     - Platform uses a generic clocksource (ie, drivers/clocksource/)
> >       combined with the generic jiffies-backed sched_clock().
> > 
> >     - Platform supports multiple sched_clock()-capable clocksources.
> > 
> > This patch adds a new CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag to address
> > these issues, which can be set for any sched_clock()-capable clocksource.
> > 
> > The generic sched_clock() implementation is likewise switched over to
> > always read from a designated sched_clocksource, which is default
> > initialized to the jiffies clocksource and updated based on the
> > availability of CLOCK_SOURCE_USE_FOR_SCHED_CLOCK sources. As this uses
> > the generic cyc2ns() logic on the clocksource ->read(), most of the
> > platform-specific sched_clock() implementations can subsequently be
> > killed off.
> 
> 80ea3bac3a47bc73efa334d0dd57099d0ff14216 ("ARM: OMAP: sched_clock()
> corrected") seems to have switched omap from cyc2ns() to an open coded
> calculation based on mult_orig because cyc2ns() uses the NTP-adjusted
> mult instead.  Does that apply here or is that change incorrect?

Hmm, that would be a problem, because changing the mult can cause non
monotonic behaviour.
