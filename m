Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786Ab0AZKh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0AZKh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641Ab0AZKh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:37:59 -0500
Received: from www.tglx.de ([62.245.132.106]:35536 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab0AZKh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:37:58 -0500
Date: Tue, 26 Jan 2010 11:37:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dongdong Deng <libfetion@gmail.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel
 debugger
In-Reply-To: <ce2c83091001260201j62a770d2r2379a9293f909d87@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001261108410.5926@localhost.localdomain>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>  <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>  <20100126092234.77b363d4@mschwide.boeblingen.de.ibm.com>  <alpine.LFD.2.00.1001260946530.5926@localhost.localdomain>
 <ce2c83091001260201j62a770d2r2379a9293f909d87@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2091829694-1264502240=:5926"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2091829694-1264502240=:5926
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 26 Jan 2010, Dongdong Deng wrote:
> On Tue, Jan 26, 2010 at 4:50 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 26 Jan 2010, Martin Schwidefsky wrote:
> >> On Mon, 25 Jan 2010 22:26:39 -0600
> >> Jason Wessel <jason.wessel@windriver.com> wrote:
> >>
> >> > This is a regression fix against: 0f8e8ef7c204988246da5a42d576b7fa5277a8e4
> >> >
> >> > Spin locks were added to the clocksource_resume_watchdog() which cause
> >> > the kernel debugger to deadlock on an SMP system frequently.
> >> >
> >> > The kernel debugger can try for the lock, but if it fails it should
> >> > continue to touch the clocksource watchdog anyway, else it will trip
> >> > if the general kernel execution has been paused for too long.
> >> >
> >> > This introduces an possible race condition where the kernel debugger
> >> > might not process the list correctly if a clocksource is being added
> >> > or removed at the time of this call.  This race is sufficiently rare vs
> >> > having the kernel debugger hang the kernel
> >> >
> >> > CC: Thomas Gleixner <tglx@linutronix.de>
> >> > CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> >> > CC: John Stultz <johnstul@us.ibm.com>
> >> > CC: Andrew Morton <akpm@linux-foundation.org>
> >> > CC: Magnus Damm <damm@igel.co.jp>
> >> > Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> >>
> >> The first question I would ask is why does the kernel deadlock? Can we
> >> have a backchain of a deadlock please?
> >
> > The problem arises when the kernel is stopped inside the watchdog code
> > with watchdog_lock held. When kgdb restarts execution then it touches
> > the watchdog to avoid that TSC gets marked unstable.
> >
> >> Hmm, there are all kinds of races if the watchdog code gets interrupted
> >> by the kernel debugger. Wouldn't it be better to just disable the
> >> watchdog while the kernel debugger is active?
> >
> > No, we can keep it and in most cases it clocksource_touch_watchdog()
> > helps to keep TSC alive. A simple "if (!trylock) return;" should solve
> > the deadlock problem for kgdb without opening a can of worms.
> 
> Is it possible that we reset the clocksource watchdog during in
> clocksource_watchdog() ?
> 
> >From the code view, The action of reset clocksource watchdog is just
> set the CLOCK_SOURCE_WATCHDOG flag.
> thus if we reset it before using, I think the logic will be right.

No, it's not. It just brings back the old flag based logic which we
removed.

The correct way to solve this is a documented 

    if (!trylock())
       return;

in clocksource_touch_watchdog(). And that's what I'm going to push
linuswards.

There is no sane way to reliably prevent TSC from becoming unstable
when kgdb stops the kernel inside the watchdog code. And I do not care
about that at all.

I'm not going to clutter code with crazy workarounds just because some
people believe that using a kernel debugger is a good idea. If people
insist on using kgdb then the possible "TSC becomes unstable" side
effect is the least of their problems.

Thanks,

	tglx
--8323328-2091829694-1264502240=:5926--
