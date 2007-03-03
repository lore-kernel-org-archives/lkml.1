Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbXCCI4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbXCCI4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 03:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXCCI4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 03:56:31 -0500
Received: from www.osadl.org ([213.239.205.134]:57330 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267AbXCCI4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 03:56:30 -0500
Subject: Re: [PATCH] dynticks: don't unlock spinlock twice
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <45E8E2F8.1030102@debian.org>
References: <45E8E2F8.1030102@debian.org>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 10:02:20 +0100
Message-Id: <1172912540.24738.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 21:52 -0500, Andres Salomon wrote:
> During boot with dynticks enabled, we would sometimes get:
> 
> [   35.271900] Switched to high resolution mode on CPU 0
> [   35.304468] BUG: spinlock already unlocked on CPU#0, swapper/1
> [   35.338099]  lock: c06428a0, .magic: dead4ead, .owner: <none>/-1,
> .owner_cpu:
>  -1
> [   35.373597]  [<c04d7cf0>] _raw_spin_unlock+0x28/0x67
> [   35.406647]  [<c05ba279>] _spin_unlock+0x5/0x23
> [   35.439369]  [<c04255f7>] tick_sched_timer+0x4e/0xa7
> [   35.472388]  [<c04255a9>] tick_sched_timer+0x0/0xa7
> [   35.504833]  [<c0422528>] hrtimer_run_queues+0x199/0x1ec
> [   35.537617]  [<c0416b72>] run_timer_softirq+0x12/0x166
> [   35.570019]  [<c04144d9>] __do_softirq+0x40/0x85
> 
> [   35.601542]  [<c0405494>] do_softirq+0x53/0xa9
> ...
> 
> This appears to be caused by run_hrtimer_queue() (called by
> hrtimer_run_queues) calling spin_unlock_irq(&cpu_base->lock) before
> calling timer->function(timer).  The callback function
> (tick_sched_timer) expects cpu_base->lock to be held when it is called,
> and attempts to unlock it.  Since it doesn't seem like anything within
> tick_sched_timer really needs to hold the lock (afaict), the attached
> patch simply removes the lock handling from tick_sched_timer.  Things
> called by tick_sched_timer may grab the base->lock, but that's fine (and
> their responsibility).  Let me know if there's some reason why the lock
> should be held, and I can rework this.

The BUG is somewhere else. the tick timer should never be seen in
hrtimer_run_queues. The tick timer is operated solely from the timer
interrupt. 

The question is, how the tick timer gets enqueued in the softirq queue.
Can you isolate the codepath, where this happens ?

	tglx



	

