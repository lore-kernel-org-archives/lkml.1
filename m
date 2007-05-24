Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbXEXTix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbXEXTix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXEXTiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:38:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbXEXTio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:38:44 -0400
Date: Thu, 24 May 2007 21:37:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian =?iso-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070524193740.GA6787@elte.hu>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Looks like this is in DRM code:
> > 
> > BUG: at include/linux/slub_def.h:88 kmalloc_index()
> 
> I'm going to change that "BUG:" to "WARNING:".
> 
> I know some people disagreed with it (ie Ingo), but I think that's 
> total and utter bullshit.
> 
> It's a warning. Right now that "BUG:" message makes people all scared 
> about something that is not fatal at all, just a note that something 
> hasn't been converted, but is expected to work absolutely fine.
> 
> Calling it a bug is idiotic.

i very much agree that this kmalloc_index() one shouldnt be called a 
"BUG: ", but if you look at the majority of WARN_ON() instances they are 
checks for clear, serious kernel bugs. Very often we use WARN_ON() not 
to signal that it's just a harmless warning, but because we do not want 
to bring the system down via a BUG_ON(). The API is misnamed for sure, 
but still, the purpose and current practice is clear: to signal kernel 
bugs.

To quantify this a bit more objectively i just did a "grep WARN_ON 
kernel/*.c" and randomly picked 10 out of the 113 WARN_ON()'s:

 kernel/cpu.c:			WARN_ON(1);
 kernel/exit.c:	WARN_ON(atomic_read(&tsk->fs_excl));
 kernel/fork.c:	WARN_ON(!(tsk->exit_state & (EXIT_DEAD | EXIT_ZOMBIE)));
 kernel/futex.c:	WARN_ON(!pi_state);
 kernel/hrtimer.c:		WARN_ON_ONCE(timer->cb_mode ==  HRTIMER_CB_IRQSAFE_NO_SOFTIRQ);
 kernel/lockdep.c:		WARN_ON(1);
 kernel/mutex-debug.c:	DEBUG_LOCKS_WARN_ON(list_empty(&waiter->list));
 kernel/rtmutex.c:	WARN_ON(rt_mutex_is_locked(lock));
 kernel/sched.c:	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 kernel/softirq.c:       WARN_ON_ONCE(in_irq());

and reviewed each instance, each and every one of these warnings is a 
serious kernel bug that i would not 'warn' about, but what i'd like to 
see reported ASAP. [ In fact i added 5 of these WARN_ON()s :-/ ] But 
maybe that's just me?

now regarding the naming of this API, i'd very much agree to do this 
rename:

   WARN_ON  =>  BUG_ON
   BUG_ON   =>  CRASH_ON

and make WARN_ON() print a "WARNING: ".

and i signalled this in the original discussion too a few months ago 
when i opposed the watering-down of the WARN_ON printk.

OTOH i dont feel that strongly about all this :-)

	Ingo
