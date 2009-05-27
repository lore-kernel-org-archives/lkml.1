Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZE0AWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZE0AWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZE0AV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:21:58 -0400
Received: from www.tglx.de ([62.245.132.106]:49192 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbZE0AV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:21:57 -0400
Date: Wed, 27 May 2009 02:18:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: john stultz <johnstul@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <20090526234425.GB6295@linux-sh.org>
Message-ID: <alpine.LFD.2.00.0905270206300.1762@localhost.localdomain>
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org>
 <1243380303.3275.40.camel@localhost> <20090526234425.GB6295@linux-sh.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Paul Mundt wrote:
> > Yea. So this is a little better. There's still a few other issues to
> > consider:
> > 
> > 1) What if a clocksource is registered that has the _SCHED_CLOCK bit
> > set, but is not selected for timekeeping due it being unstable like the
> > TSC?
> > 
> See, this is what I thought the rating information was useful for, as the
> rating is subsequently dropped if it is not usable. But perhaps it makes
> more sense to just clear the bit at the same time that the rating is
> lowered once it turns out to be unstable.

Stop worrying about TSC please. The x86 f*cked up timers need special
handling which is definitely not required for most of arch/*. x86
overrides that anyway and handles the TSC f*ckup in the
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK section of sched_clock.c which is
completely irrelevant to any architecture which has a sane set of
timers.

The only extra magic which is required to avoid that (sub)arch
maintainers need to specify a sched_clock() implementation to override
the weak generic one is really the simple

    if (clock && (clock->flags & CLOCKSOURCE_USE_FOR_SCHED_CLOCK))
       return ....

We need no locking there at all.

We have a workaround in place, which overrides the weak sched_clock()
implementation, to make x86 efficient, so why do we want to impose all
that x86 crap on folks which deal with architectures which got the
timers right ?

Thanks,

	tglx
