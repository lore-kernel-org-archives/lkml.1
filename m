Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYFYG0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYFYG0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYFYG0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:26:06 -0400
Received: from www.tglx.de ([62.245.132.106]:44428 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbYFYG0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:26:05 -0400
Date: Wed, 25 Jun 2008 08:13:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Roman Zippel <zippel@linux-m68k.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
In-Reply-To: <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0806250809030.3297@apollo.tec.linutronix.de>
References: <485E00CD.9060503@gmail.com>  <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>  <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>  <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
 <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, Michael Kerrisk wrote:
> > If you check the man page for clock_settime, it specifically
> > mentions that pending relative timer (including nanosleep) aren't affected
> > by the changed time, thus if CLOCK_MONOTONIC and CLOCK_REALTIME advance
> > equally, it doesn't matter which you use for relative timer.
> 
> Well, I was going to say that that's just a man page, and man page
> authors are fallible ;-).  But then I went and had a look at the POSIX
> spec for clock_settime().  It includes the following paragraph:
> 
>        Setting the value of the CLOCK_REALTIME  clock  via  clock_set-
>        time() shall have no effect on threads that are blocked waiting
>        for a relative time service based upon  this  clock,  including
>        the  nanosleep()  function;  nor  on the expiration of relative
>        timers  based  upon  this  clock.   Consequently,  these   time
>        services  shall  expire  when  the  requested relative interval
>        elapses, independently of the new or old value of the clock.
> 
> So that rather flatly contradicts the alternative semantics that I
> suggested were possible in my reply to Bart a few minutes ago.
> 
> So in my reading of things now, it looks as though the Linux
> implementation is probably fine, since the fact that relative
> timers/sleeps are explicitly unaffected by jumps in CLOCK_REALTIME
> means that the semantics are effectively the same as if the relative
> interval was measured against CLOCK_MONOTONIC (unless the two clocks
> counted time at different rates; not sure if that  would be possible
> in theory, but certainly seems very unlikely in practice).

We use CLOCK_MONOTONIC for the relative timeouts simply to avoid
trickery vs. clock_settime(CLOCK_REALTIME). That's an kernel internal
implementation detail which does not have any visible effect to the
user space interface.

CLOCK_MONOTONIC and CLOCK_REALTIME are using the same timebase
internally and therefor we can safely use CLOCK_MONOTONIC for the
relative timeouts.

Thanks,

	tglx
