Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYGRImS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYGRImS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYGRImJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:42:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53886 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYGRImH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:42:07 -0400
Date: Fri, 18 Jul 2008 10:41:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] tracing fixes
Message-ID: <20080718084152.GJ6875@elte.hu>
References: <20080717173210.GA12828@elte.hu> <Pine.LNX.4.58.0807172249230.22792@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807172249230.22792@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 17 Jul 2008, Ingo Molnar wrote:
> >
> > Ingo Molnar (4):
> >       ftrace: fix merge buglet
> >       ftrace: fix lockup with MAXSMP
> >       ftrace: do not trace scheduler functions
> >       ftrace: do not trace library functions
> >
> 
> [...]
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -11,8 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
> >  	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
> >  	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
> >
> > -CFLAGS_REMOVE_sched.o = -mno-spe
> > -
> >  ifdef CONFIG_FTRACE
> >  # Do not trace debug files and internal ftrace files
> >  CFLAGS_REMOVE_lockdep.o = -pg
> > @@ -21,6 +19,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
> >  CFLAGS_REMOVE_rtmutex-debug.o = -pg
> >  CFLAGS_REMOVE_cgroup-debug.o = -pg
> >  CFLAGS_REMOVE_sched_clock.o = -pg
> > +CFLAGS_REMOVE_sched.o = -mno-spe -pg
> >  endif
> >
> 
> Ingo,
> 
> Why not trace the scheduler functions? I found a lot of useful 
> information from seeing what functions are being called (namely the 
> latencies caused by the fair scheduler balancing). Not being able to 
> trace sched.c seems to keep a lot of useful data from being accessed.

i agree in general, but it was causing lockups with:

      http://redhat.com/~mingo/misc/config-Thu_Jul_17_13_34_52_CEST_2008

note the MAXSMP in the config which sets NR_CPUS to 4096:

      CONFIG_NR_CPUS=4096

our randconfig testing stumbled on it. That is a debug helper to "tune 
up the kernel for as large systems as possible" and can bring in 
regressions not normally seen.

after i spent a good 4 hours on figuring out the lib/*.o details i didnt 
have the stamina to find the exact reason within sched.o :-)

One thing that needs looking at is that ftrace's self-recursion checks 
are not as robust as they used to be, and this is a recent regression 
(as in: last 1-2 weeks). Why do we have to exclude tsc.o from tracing 
for example? Why isnt cpu_clock() called inside a recursion-protected 
section? Why are all the trace function callbacks called outside of 
recursion checks? Why arent ftrace lockups debuggable via the NMI 
watchdog + early printk? I think it would be more robust to do a 
recursion check ASAP.

> also, is the '-mno-spe' safe when ftrace is not configured?

Why was the -mno-spe added exactly? I havent seen it explained in the 
commit that added its removal:

| commit 6ec562328fda585be2d7f472cfac99d3b44d362a
| Author: Steven Rostedt <rostedt@goodmis.org>
| Date:   Wed May 14 21:30:30 2008 -0400
|
|    ftrace: use the new kbuild CFLAGS_REMOVE for kernel directory

it talks about a cleanup but also adds -mno-spe removal that wasnt there 
before. This seems to be a powerpc special and the exact context is not 
clear to me.

	Ingo
