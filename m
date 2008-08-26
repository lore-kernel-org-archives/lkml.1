Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYHZKaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYHZKaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYHZKaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:30:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbYHZKaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:30:05 -0400
Date: Tue, 26 Aug 2008 12:29:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080826102937.GA25732@elte.hu>
References: <20080819103301.787700742@chello.nl> <200808261900.07383.nickpiggin@yahoo.com.au> <20080826093059.GA471@elte.hu> <200808261944.47176.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808261944.47176.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > So... no reply to this? I'm really wondering how it's OK to break
> > > documented standards and previous Linux behaviour by default for
> > > something that it is trivial to solve in userspace? [...]
> >
> > I disagree 
> 
> Disagree with what? That it's a problem to basically break the 
> guarantee realtime SCHED_ policies have previously provided?

I think you are sticking to the rigid letter of some standard without 
seeing the bigger picture.

Firstly, please realize that to do a "successful" POSIX or other 
conformance run a default Linux distribution has to be tweaked and often 
crippled literally dozens and often hundreds of ways. In this case you 
also have to add one more entry to /etc/sysctl.conf, to allow RT tasks 
to monopolize CPU time. So you can still get the POSIX sticker if you 
want to - nothing changed about that.

Secondly, my big picture point is that our task is to make Linux more 
useful and more usable by default. You seem to be arguing that RT tasks 
should be allowed by default to monopolize all CPU time forever, and i 
disagree with that proposition.

But do _you_ actually use such runaway CPU-monopolizing RT tasks? Try it 
one day and you'll quickly meet various practical problems. Let a 
SCHED_FIFO:99 RT task run long enough and on all the main distributions 
you will get:

  BUG: soft lockup - CPU#1 stuck for 61s! [bash:3659]

But monopolizing any resource in a 100% way (which you are arguing for) 
is just not a generic Linux system and for years (seeing all the 
practical problems with it) we tried various methods to contain 
SCHED_FIFO tasks in the scheduler, none was really acceptable for 
mainline.

Peter's changes were clean and useful at last. There's lots of apps that 
use SCHED_FIFO for a short burst of activity, and 100% of the ones i 
know do not want to run for longer than 10 seconds.

Thirdly, your argument can only be consistent if you also argue for the 
softlockup watchdog to be disabled. Do you make that point?

> > and what do you mean by "trivial to solve in user-space"?
> 
> I mean that if some distro has turned on the RT scheduling ulimit by 
> default and now finds themselves with a local DoS for unpriviliged 
> users as a result, then either that distro should just make their init 
> scripts set the throttle and break the API themselves, or they should 
> start a watchdog at a higher priority than unprivileged user can set.

... but that's by far not the only usecase. Very frequently i've seen 
bugreports from people with runaway RT tasks (which tasks were running 
as root) where that runaway behavior was completely unintended. Audio 
apps or other apps getting into a loop and locking up the system.

Worse than that, such bugs prevented the system from being debugged by 
plain users. A runaway RT task that monopolizes the CPU will lock it up 
completely, requiring a hard reset or a power cycle. That can lose data, 
etc. If we allow it to lock up the CPU for up to 10 seconds it will 
still be noticed if that is unintentional (the system is very slow), but 
the problem can be debugged.

By making RT tasks not lock up like that by default and allowing them to 
'only' monopolize the CPU up to 10 seconds, we make the system more 
debuggable and more useful in general. It is a quite reasonable 
proposition that makes Linux useful in general, and you seem to be 
ignoring that practical angle altogether. It's not about allowing 
user-space rtprio-rlimit driven apps to not run away, it's about 
allowing _any_ RT task to be throttled by default if they run away. 

On the other side of the equation, what exact application do you know 
that absolutely relies on being able to monopolize all CPU time in 
excess of 10 seconds? I havent heard much about that usecase. Why does 
that particular RT app do it, because that behavior sounds _very_ weird 
to me.

If it's some embedded system or other special-purpose app then it can 
tweak the sysctl no problem. (it will have to do it anyway, to turn off 
the softlockup watchdog)

If it's some general purpose Linux app, exactly which one is it? If it's 
an OSS app please give me an URL to its source code, we need to fix it 
urgently. Running for more than 10 seconds wastes power like mad and is 
generally a very un-nice thing to do.

All in one, since the 'buggy RT app runs into a loop and monopolizes the 
CPU' case is much more common, i do think that supporting that usecase 
is the better choice for a default.

... and in any case, i agree with some of the observations in this 
thread, in particular that the 1 second default limit was too low 
(_occasional_ spurts of a couple of seconds activities by RT tasks ought 
to be OK) - that's why we upped it to 10 seconds already in sched/devel 
tree, a week ago or so.

	Ingo
