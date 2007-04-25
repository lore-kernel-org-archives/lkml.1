Return-Path: <linux-kernel-owner+w=401wt.eu-S1422769AbXDYVr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422769AbXDYVr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422768AbXDYVr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:47:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55380 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422769AbXDYVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:47:57 -0400
Date: Wed, 25 Apr 2007 23:47:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: [patch] CFS scheduler, -v6
Message-ID: <20070425214704.GA32572@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce release -v6 of the CFS scheduler patchset. The 
main goal of CFS is to implement "high quality desktop scheduling" as 
well as technically possible.

The CFS patch against v2.6.21-rc7 or against v2.6.20.7 can be downloaded 
from the usual place:

    http://redhat.com/~mingo/cfs-scheduler/

i got lots of -v5 feedback (thanks and please keep the reports coming!) 
so the -v6 release includes many bugfixes and improvements:

    19 files changed, 317 insertions(+), 744 deletions(-)

the biggest user-visible changes in -v6 are various refinements to the 
precise-scheduling infrastructure that should result in generally better 
interactivity and a smoother desktop. In particular a number of "movie 
playback lags/stutters" and "firefox lags under load" type of 
regressions have been resolved. (Please re-report any regression that 
might not be fixed yet.)

Changes since -v5:

 - feature: increase the preemption granularity value on SMP systems. 
   Idea and code comes from the SD scheduler of Con Kolivas, with Con's
   kind permission. (thanks Con!)

 - fix: the "privileged_nice_level=X" boot option should convert signed
   integers. (Mike Galbraith)

 - build fix: yield_to unistd.h fix (Srivatsa Vaddagiri)

 - build fix: CONFIG_HEADERS_CHECK complained about sched.h.
   (reported by Zach Carter)

 - build fix: normalize_rt_tasks() UP build fix. (Mike Galbraith)

 - interactivity fix: sched_clock() accuracy fixes. This should resolve 
   certain types of interactivity regressions reported on systems that
   change their CPU frequencies. (mainly laptops)

 - default settings tweak: changed the X renicing default from -19 to 
   -10, based on tester feedback. (Might still be too much - more 
   feedback is needed.)

 - feature: introduced "wakeup granularity" and added the 
   /proc/sys/kernel/sched_wakeup_granularity_ns tunable, set to 0 by 
   default for now. This is now distinct from the sched_granularity_ns
   'preemption granularity' property of the scheduler - allowing a
   more agressive increase in the preemption granularity without
   jeopardizing interactivity.

 - debugging feature: SysRq-T now also shows the /proc/sched_debug 
   output - useful to generate a dump of all relevant scheduler state in 
   one easy step.

 - debugging feature: make SysRq-Nice normalize negative nice level 
   tasks too and reset the CFS state.

 - debugging: extend /proc/sched_debug with a few more clock related 
   fields, to be able to better debug problems caused by unstable 
   clocks.

 - upstream fix: SysRq-T should show runnable tasks

 - optimization: introduce p->load_shift to simplify the 64-bit math on 
   32-bit systems and avoid expensive 64-bit divisions.

 - cleanup: renamed CONFIG_RENICE_X to CONFIG_BOOST_X.

 - cleanup: got rid of more unused code from sched.c

 - lots of other smaller stuff i forgot :)

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
