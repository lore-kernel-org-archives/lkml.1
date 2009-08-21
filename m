Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZHUMaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZHUMaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 08:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbZHUMaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 08:30:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:48710 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbZHUMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 08:30:10 -0400
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses from
	kgdb
From: DDD <Dongdong.deng@windriver.com>
To: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090804145909.GO7746@elte.hu>
References: <4A6E0825.3020604@windriver.com>
	 <1248725893.6987.2055.camel@twins> <4A6F139C.6070806@windriver.com>
	 <20090804141623.GD7746@elte.hu> <4A784B78.2020801@windriver.com>
	 <20090804145909.GO7746@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Aug 2009 20:42:21 +0800
Message-Id: <1250858541.24178.15.camel@dengdd-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 21 Aug 2009 12:29:45.0886 (UTC) FILETIME=[112AB3E0:01CA225B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason & Ingo,

If we apply Peter's patch which was send out just a moment ago,
I believe this issue will gone.  :-) 

Thanks,
Dongdong


[PATCH -rt] timer: delay waking softirqs from the jiffy tick
...
...
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 8137cce..96ac1b4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1221,10 +1221,10 @@ void update_process_times(int user_tick)

       /* Note: this timer irq context must be accounted for as well. */
       account_process_tick(p, user_tick);
+       scheduler_tick();
       run_local_timers();
       if (rcu_pending(cpu))
               rcu_check_callbacks(cpu, user_tick);
-       scheduler_tick();
       run_posix_cpu_timers(p);
 }



On Tue, 2009-08-04 at 16:59 +0200, Ingo Molnar wrote: 
> * Jason Wessel <jason.wessel@windriver.com> wrote:
> 
> > Ingo Molnar wrote:
> > > * Jason Wessel <jason.wessel@windriver.com> wrote:
> > > 
> > >> -----
> > >> From: Jason Wessel <jason.wessel@windriver.com>
> > >> Subject: [PATCH] softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume
> > >>
> > >> When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set sched_clock() gets the
> > >> time from hardware, such as from TSC.  In this configuration kgdb will
> > >> report a softlock warning messages on resuming or detaching from a
> > >> debug session.
> > >>
> > > 
> > > Hm, this looks quite ugly. Peter, Thomas, can you think of a 
> > > cleaner solution?
> > > 
> > 
> > Below was a more specific test case I received from Dongdong Deng 
> > which did not require kgdb.  The test case is not something to 
> > merge, it is just a simple module to build to demonstrate the 
> > problem outside of kgdb.
> > 
> > The patch I submitted might have been on the "ugly" side, but 
> > there was not an obvious way to solve the problem without making 
> > changes in kernel/sched*.  I opted for something that was entirely 
> > self contained to the softlockup code.
> 
> it's not really the fault of your patch really - all these 
> integrations along dynticks, scheduler time and softlockup feel a 
> bit awkward. Wondering whether there's some nicer way.
> 
> 	Ingo
