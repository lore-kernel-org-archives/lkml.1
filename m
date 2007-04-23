Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXDWBNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXDWBNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 21:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXDWBNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 21:13:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35356 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030308AbXDWBNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 21:13:41 -0400
Date: Mon, 23 Apr 2007 03:12:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: [patch] CFS scheduler, -v5
Message-ID: <20070423011229.GA20367@elte.hu>
References: <20070420140457.GA14017@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420140457.GA14017@elte.hu>
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


i'm pleased to announce release -v5 of the CFS scheduler patchset. The 
patch against v2.6.21-rc7 and v2.6.20.7 can be downloaded from:

    http://redhat.com/~mingo/cfs-scheduler/

this CFS release mainly fixes regressions and improves interactivity:

    13 files changed, 211 insertions(+), 199 deletions(-)

the biggest user-visible change in -v5 are various interactivity 
improvements (especially under higher load) to fix reported regressions, 
and an improved way of handling nice levels. There's also a new 
sys_sched_yield_to() syscall implementation for i686 and x86_64.

All known regressions have been fixed. (knock on wood)

[ Note: while CFS's default preemption granularity is currently set to 5 
  msecs, this value does not directly transform into timeslices: for 
  example two CPU-intense tasks will have effective timeslices of 10 
  msecs with this setting. ]

Changes since -v4:

 - interactivity bugfix: fix xterm latencies and general desktop delays 
   and child task startup delays under load. (reported by Willy Tarreau 
   and Caglar Onur)

 - bugfix: the in_atomic_preempt_off() call on !PREEMPT_BKL was buggy
   and spammed the console with bogus warnings.

 - implementation fix: make the nice levels implementation
   starvation-free and smpnice-friendly. Remove the nice_offset hack.

 - feature: add initial sys_sched_yield_to() implementation. Not hooked 
   into the futex code yet, but testers are encouraged to give the 
   syscalls a try, on i686 the new syscall is __NR_yield_to==320, on 
   x86_64 it's __NR_yield_to==280. The prototype is 
   sys_sched_yield_to(pid_t), as suggested by Ulrich Drepper.

 - usability feature: add CONFIG_RENICE_X: those who dont want the 
   kernel to renice X should disable this option. (the boot option and 
   the sysctl is still available too)

 - removed my home-made "Con was right about scheduling fairness" 
   attribution to Con's scheduler interactivity work - some have 
   suggested that Con might want to see another text there. Con,
   please feel free to fill it in!

 - feature: make the CPU usage of nice levels logarithmic instead of 
   linear. This is more usable and more intuitive. (Going four nice 
   levels forward/backwards give half/twice the CPU power) [ This was
   requested a number of times in the past few years and is 
   straightforward under CFS because there nice levels are not tied to 
   any timeslice distribution mechanism. ]

 - cleanup: removed the stupid "Ingo was here" banner printk from 
   sched_init(), the -cfs EXTRAVERSION serves the purpose (of 
   identifying a booted up kernel as a CFS one) equally well.

 - various other code cleanups

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
