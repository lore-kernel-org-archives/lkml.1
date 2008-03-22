Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYCVOmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYCVOmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 10:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYCVOmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 10:42:11 -0400
Received: from www.tglx.de ([62.245.132.106]:45080 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYCVOmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 10:42:11 -0400
Date: Sat, 22 Mar 2008 15:41:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Gabriel C <crazy@frugalware.org>, Gabriel C <nix.or.die@googlemail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <20080322142502.GA10687@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803221530290.3781@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org>
 <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de>
 <20080322142502.GA10687@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Andi Kleen wrote:
> > CPU0 runs the watchdog timer and schedules it on CPU1.
> > 
> > With NO_HZ enabled CPU1 is in a long idle sleep. At this point of the
> > boot process there is probably no timer pending on CPU1, which means
> > the idle sleep is infinite.
> > 
> > Now some time later CPU1 gets woken by an interrupt/IPI and runs the
> > timer wheel. At this point the pm_timer which is the reference clock
> > has already wrapped around, so the watchdog thinks that there is a
> 
> In my old original own noidletick code I simply limited all sleeps 
> to below the wrap around of the primary timer.  Wouldn't something 
> like that work?

No, it does not solve the real problem of not reevaluating the timer
wheel on the idle CPU when a timer gets added from some other CPU. We
would paper over the watchdog issue, but postponing a timer event,
which was added cross CPU to some artifical expiry time is simply
wrong.

> I'm not sure just doing this for add_timer_on() only is correct.
> After all it could affect any other code not run by add_timer_on()
> couldn't it?

No, it's limited to add_timer_on() simply because no other code can
add a new timer (timer_list or hrtimer) which modifies the next event
on another CPU. There is also the rare case, when one CPU runs the
timer callback and the other one modifies the timer, but that's not
relevant for the NOHZ problem because the CPU which runs the callback
is not idle at this point.

All other timer operations are CPU local and reevaluated before the
CPU goes idle again.

Thanks,

	tglx
