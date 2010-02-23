Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0BWPwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:52:21 -0500
Received: from mail.openrapids.net ([64.15.138.104]:38041 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753183Ab0BWPwT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:52:19 -0500
Date: Tue, 23 Feb 2010 10:52:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: LTTng 0.193 fixes RT kernel support
Message-ID: <20100223155217.GA7210@Krystal>
References: <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain> <20100216164744.GA25115@Krystal> <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain> <20100216170540.GA28039@Krystal> <f5a7b3811002170236i6c560eadp2de7deb10082db4f@mail.gmail.com> <20100217230854.GA25636@Krystal> <f5a7b3811002220737r502e75c1w5ab5a64b6cc27b68@mail.gmail.com> <f5a7b3811002230329w64cabac9lff95a40cb5e7dfa5@mail.gmail.com> <20100223123016.GA12857@Krystal> <f5a7b3811002230735p2eb90904l33e8090ade66fc14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <f5a7b3811002230735p2eb90904l33e8090ade66fc14@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:49:32 up 31 days, 18:27,  5 users,  load average: 0.48, 0.50,
	0.45
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* naresh kamboju (naresh.kernel@gmail.com) wrote:
> On Tue, Feb 23, 2010 at 6:00 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > * naresh kamboju (naresh.kernel@gmail.com) wrote:
> >> On Mon, Feb 22, 2010 at 9:07 PM, naresh kamboju <naresh.kernel@gmail.com> wrote:
> >> > On Thu, Feb 18, 2010 at 4:38 AM, Mathieu Desnoyers
> >> > <mathieu.desnoyers@efficios.com> wrote:
> >> >> * naresh kamboju (naresh.kernel@gmail.com) wrote:
> >> >>> On Tue, Feb 16, 2010 at 10:35 PM, Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> >> >>> > Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
> >> >>> > saner del_timer_sync() scheme to delete the timers.
> >>
> >> patch trace-clock-32-to-64-use-del-timer-sync.patch is causing above
> >> problem on SMP.
> >>
> >> with out this patch on SMP reported the previous bug as BUG: sleeping
> >> function called from invalid context at kernel/rtmutex.c:685
> >>
> >> However, i'll investigate.
> >
> > Hrm, we should turn the arch/{arm/mach-omap2,x86/kernel}/trace-clock.c:
> > trace_clock_lock into a mutex, and kernel/trace/trace-clock-32-to-64.c:
> > synthetic_tsc_lock into a mutex too.
> 
> I have modified kernel/trace/trace-clock-32-to-64.c spin_lock to
> mutex_lock to all the calls
> 
> -static DEFINE_SPINLOCK(synthetic_tsc_lock);
> +static DEFINE_MUTEX(synthetic_tsc_lock);
> 
> -       spin_lock(&synthetic_tsc_lock);
> +       mutex_lock(&synthetic_tsc_lock);
> 
> for arch/{arm/mach-omap2/kernel}/trace-clock.c is already modified as
> above from the patch
> omap-trace-clock-fix-mutex.patch
> from LTTng patches 02-Feb-2009.
> this patch was prepared by you to fix
> BUG: sleeping function called from invalid context at kernel/mutex.c:207.
> 
> Still reporting same bug at my end :-(
> 
> let me try in all possible ways.

Please note that at the end of 2009, I moved the ARM LTTng omap trace clock to a
neater per-cpu design. So it's possible that the old implementation you use has
problems with the mutex. This could be fixed with the newer implementation.

If you can tell us more about the BUG you get with the mutex-based synthetic tsc
(what the callers are) I could tell you if this problem really goes away in
newer version.

Thanks,

Mathieu

> 
> Best regards
> Naresh Kamboju
> >
> > I used a spinlock previously on ARM because it was called from power
> > management resume, but now that the data structures touched by this code
> > path are per-cpu, this lock is not taken there, so it should be OK to
> > turn it into a mutex.
> >
> > Can you try that and tell me if that fixes your issues ?
> >
> > Thanks,
> >
> > Mathieu
> >
> >>
> >> Best regards,
> >> Naresh Kamboju
> >> >> Thanks,
> >> >>
> >> >> Mathieu
> >> >>
> >> >> --
> >> >> Mathieu Desnoyers
> >> >> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> >> >>
> >> >
> >>
> >> _______________________________________________
> >> ltt-dev mailing list
> >> ltt-dev@lists.casi.polymtl.ca
> >> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> >>
> >
> > --
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> >
