Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYAZJxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYAZJxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYAZJxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:53:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45930 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYAZJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:53:04 -0500
Subject: Re: [PATCH 01/23 -v6] printk - dont wakeup klogd with interrupts
	disabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080126091015.GA1794@elf.ucw.cz>
References: <20080126042152.526086719@goodmis.org>
	 <20080126042801.280369398@goodmis.org>  <20080126091015.GA1794@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 26 Jan 2008 10:52:06 +0100
Message-Id: <1201341126.27573.20.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-26 at 10:10 +0100, Pavel Machek wrote:
> On Fri 2008-01-25 23:21:53, Steven Rostedt wrote:
> > [ This patch is added to the series since the wakeup timings trace
> >   may lockup without it. ]
> > 
> > I thought that one could place a printk anywhere without worrying.
> > But it seems that it is not wise to place a printk where the runqueue
> > lock is held.
> > 
> > I just spent two hours debugging why some of my code was locking up,
> > to find that the lockup was caused by some debugging printk's that
> > I had in the scheduler.  The printk's were only in rare paths so
> > they shouldn't be too much of a problem, but after I hit the printk
> > the system locked up.
> > 
> > Thinking that it was locking up on my code I went looking down the
> > wrong path. I finally found (after examining an NMI dump) that
> > the lockup happened because printk was trying to wakeup the klogd
> > daemon, which caused a deadlock when the try_to_wakeup code tries
> > to grab the runqueue lock.
> > 
> > This patch adds a runqueue_is_locked interface in sched.c for other
> > files to see if the current runqueue lock is held. This is used
> > in printk to determine whether it is safe or not to wakeup the klogd.
> > 
> > And with this patch, my code ran fine ;-)
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  include/linux/sched.h |    2 ++
> >  kernel/printk.c       |   14 ++++++++++----
> >  kernel/sched.c        |   18 ++++++++++++++++++
> >  3 files changed, 30 insertions(+), 4 deletions(-)
> > 
> > Index: linux-mcount.git/kernel/printk.c
> > ===================================================================
> > --- linux-mcount.git.orig/kernel/printk.c	2008-01-25 21:46:50.000000000 -0500
> > +++ linux-mcount.git/kernel/printk.c	2008-01-25 21:46:55.000000000 -0500
> > @@ -590,9 +590,11 @@ static int have_callable_console(void)
> >   * @fmt: format string
> >   *
> >   * This is printk().  It can be called from any context.  We want it to work.
> > - * Be aware of the fact that if oops_in_progress is not set, we might try to
> > - * wake klogd up which could deadlock on runqueue lock if printk() is called
> > - * from scheduler code.
> > + *
> > + * Note: if printk() is called with the runqueue lock held, it will not wake
> > + * up the klogd. This is to avoid a deadlock from calling printk() in schedule
> > + * with the runqueue lock held and having the wake_up grab the runqueue lock
> > + * as well.
> >   *
> >   * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
> >   * call the console drivers.  If we fail to get the semaphore we place the output
> > @@ -1003,7 +1005,11 @@ void release_console_sem(void)
> >  	console_locked = 0;
> >  	up(&console_sem);
> >  	spin_unlock_irqrestore(&logbuf_lock, flags);
> > -	if (wake_klogd)
> > +	/*
> > +	 * If we try to wake up klogd while printing with the runqueue lock
> > +	 * held, this will deadlock.
> > +	 */
> > +	if (wake_klogd && !runqueue_is_locked())
> >  		wake_up_klogd();
> >  }
> 
> I guess you are going to kill me... but 
> 
> CPU0					CPU1
> if (!runqueue_is_locked()) {
> 					locks runqueue
> 	wake_up_klogd
> 
> ....and we are dead. What is needed here is
> "wake_up_klogd_if_you_can()" or something, that does trylock (atomic).
> 
> ....but even this version is better than status quo, I'd say.

Well, if cpu1 holds the lock, and cpu0 wants it, there should only be
contention, I'm not seeing how this would deadlock.

The deadlock problem was when cpu0 was already holding the rq->lock and
wants to take it again.

