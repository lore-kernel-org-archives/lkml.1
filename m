Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYAWRf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYAWRf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbYAWRc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:32:56 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:48002 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755597AbYAWRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:32:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKQIl0dMQWYq/2dsb2JhbACBV6xk
Date: Wed, 23 Jan 2008 12:32:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Walker <dwalker@mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
	disabled
Message-ID: <20080123173249.GA23503@Krystal>
References: <20080123160236.969334052@goodmis.org> <20080123160441.236562634@goodmis.org> <1201107978.13596.16.camel@imap.mvista.com> <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:29:31 up 80 days, 22:34,  5 users,  load average: 0.56, 0.46,
	0.40
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 23 Jan 2008, Daniel Walker wrote:
> 
> >
> > On Wed, 2008-01-23 at 11:02 -0500, Steven Rostedt wrote:
> >
> > > +	if (!irqs_disabled() && wake_klogd)
> > >  		wake_up_klogd();
> >
> > This causes a regression .. When printk is called during an OOPS in
> > kernels without this change then the OOPS will get logged, since the
> > logging process (klogd) is woken to handle the messages.. If you apply
> > this change klogd doesn't wakeup, and hence doesn't log the oops.. So if
> > you remove the wakeup here you have to add it someplace else to maintain
> > the logging ..
> >
> > (I'm not theorizing here, I have defects logged against this specific
> > piece of code..)
> 
> It wont get woken up anyway. Did you look at wake_up_klogd?
> 
> void wake_up_klogd(void)
> {
> 	if (!oops_in_progress && waitqueue_active(&log_wait))
> 		wake_up_interruptible(&log_wait);
> }
> 
> 
> So if oops_in_progress is set, then it still wont get woken. Perhaps it
> got woken some other way? Or is oops_in_progress not set in these oops?
> 
> One other solution is to make the runqueue locks visible externally. Like:
> 
> in sched.c:
> 
> int runqueue_is_locked(void)
> {
> 	int cpu = get_cpu();
> 	struct rq *rq = cpu_rq(cpu);
> 	int ret;
> 
> 	ret = spin_is_locked(&rq->lock);
> 	put_cpu();
> 	return ret;
> }
> 
> And in printk we could do:
> 
> 	if (wake_klogd && !runqueue_is_locked())
> 		wake_up_klogd();
> 
> This probably is the cleanest solution since it simply prevents the
> deadlock from occurring.
> 


FYI :

kernel/panic.c

NORET_TYPE void panic(const char * fmt, ...)
{
....
bust_spinlocks(1);
...
bust_spinlocks(0);
...

In bust_spinlocks :


void __attribute__((weak)) bust_spinlocks(int yes)
{
        if (yes) {
                ++oops_in_progress;
        } else {
#ifdef CONFIG_VT
                unblank_screen();
#endif
                if (--oops_in_progress == 0)
                        wake_up_klogd();
        }
}

Where the final wake_up happens while oops_in_progress is 0, but
interrupts are still disabled.

So about my previous email, proposing testing oops_in_progress, it just
won't work.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
