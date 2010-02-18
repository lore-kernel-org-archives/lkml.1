Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0BRSqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:46:11 -0500
Received: from www.tglx.de ([62.245.132.106]:59853 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab0BRSqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:46:09 -0500
Date: Thu, 18 Feb 2010 19:45:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Valdis.Kletnieks@vt.edu
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Stupid futex question - 2.6.33-rc7-mmotm0210
In-Reply-To: <7380.1266511335@localhost>
Message-ID: <alpine.LFD.2.00.1002181934580.2811@localhost.localdomain>
References: <10057.1266501862@localhost>            <1266503879.26719.702.camel@laptop> <7380.1266511335@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010, Valdis.Kletnieks@vt.edu wrote:
> (Adding some cc: to the list)
> 
> On Thu, 18 Feb 2010 15:37:59 +0100, Peter Zijlstra said:
> > On Thu, 2010-02-18 at 09:04 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > Kernel: x86_64 2.6.33-rc7-mmotm0210
> > > 
> > > I'm debugging a problem where pulseaudio is getting killed with a SIGKILL
> > > out of the blue.  It appears to be a problem where pulseaudio sets
> > > RLIMIT_RTTIME and the bound gets exceeded.  Analysis with 'top' shows
> > > a short spike of 96% system time, and the tail end of strace shows this:
> > > 
> > > [pid 25065] 01:50:20.371484 ioctl(28, USBDEVFS_CONTROL, 0x7fd3d76f630c) = 0 <0.000015>
> > > [pid 25065] 01:50:20.371548 ioctl(28, 0x40045532, 0x7fd3d76f636c) = 0 <0.000016>
> > > [pid 25065] 01:50:20.371611 open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_CLOEXEC <unfinished ...>
> > > [pid 25064] 01:50:20.371678 <... write resumed> ) = 8 <0.002104>
> > > [pid 25064] 01:50:20.371718 futex(0xc2ec00, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
> > > [pid 25066] 01:50:21.408392 +++ killed by SIGKILL +++
> > > PANIC: handle_group_exit: 25066 leader 25064
> > > [pid 25065] 01:50:21.408442 +++ killed by SIGKILL +++
> > > PANIC: handle_group_exit: 25065 leader 25064
> > > 01:50:21.420354 +++ killed by SIGKILL +++
> > > 
> > > thread 25064 apparently gets gunned down due to RTTIME because it spent a whole
> > > second in a futex() call - is it reasonable for futex() to not return for that
> > > long?

Well, it's in futex_wait(). If nothing unlocks the futex, then it
stays there forever.
 
> > > In other words - kernel bug because futex() should return, or pulseaudio bug
> > > for not understanding futex() can snooze a while?
> > > 
> > > If a kernel bug, anybody got a better idea than nuking the RLIMIT_RTTIME call,
> > > waiting for it to repeat (takes between 1 minute and 1 hour or so), and
> > > whomping it a few times with sysrq-T?
> > 
> > is that second spend in processing sysrq-t?
> 
> No, currently that second is spent in a futex() syscall - I'm wondering:
> 
> 1) should it get killed for RLIMIT_RTTIME because it's been in a futex()
> for multiple seconds? It seems suspicious - docs say a blocking syscall
> resets RTTIME - so if futex() blocks it shouldn't kill, and if it's in the
> kernel for a second without blocking it's a bug too.

If it schedules out, then the RLIMIT_RTTIME should not be hit.

There are several possibilities why this happens:

 - the futex code has a bug which causes it to busy loop
 - the rlimit code is wreckaged

> 2) Is sysrq-T my best bet here, or should I be trying something else first?

Can you enable the function tracer and check whether it reproduces
with the function tracer. If yes, then we can put a tracing_off() into
the code which handles the rlimit, so we can see in the trace what
happened before it triggered.

Thanks,

	tglx
