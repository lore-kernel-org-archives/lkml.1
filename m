Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYKMXlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYKMXlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYKMXlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:41:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35930 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbYKMXlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:41:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.28-rc4: inconsistent lock state durin s2ram
Date: Fri, 14 Nov 2008 00:45:47 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <1226616324.3343.58.camel@calx>
In-Reply-To: <1226616324.3343.58.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811140045.48068.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of November 2008, Matt Mackall wrote:
> Just noticed this while looking to see if my iwlagn regression was still
> around (doesn't seem to be):

Is this reproducible?

It seems to be related to the scheduler.

> [112342.899610] SMP alternatives: switching to UP code
> [112343.045933] 
> [112343.045935] =================================
> [112343.045937] [ INFO: inconsistent lock state ]
> [112343.045941] 2.6.28-rc4 #40
> [112343.045943] ---------------------------------
> [112343.045945] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> [112343.045949] ksoftirqd/0/4 [HC0[0]:SC1[1]:HE1:SE0] takes:
> [112343.045951]  (&rq->lock){++..}, at: [<ffffffff802493f5>]
> sched_rt_period_timer+0xb9/0x1c7
> [112343.045961] {in-hardirq-W} state was registered at:
> [112343.045963]   [<ffffffffffffffff>] 0xffffffffffffffff
> [112343.045969] irq event stamp: 4112884
> [112343.045972] hardirqs last  enabled at (4112884):
> [<ffffffff804ed8ca>] _spin_unlock_irq+0x24/0x2e
> [112343.045978] hardirqs last disabled at (4112883):
> [<ffffffff804eda92>] _spin_lock_irq+0x15/0x41
> [112343.045983] softirqs last  enabled at (4112876):
> [<ffffffff8022674c>] call_softirq+0x1c/0x28
> [112343.045989] softirqs last disabled at (4112881):
> [<ffffffff8022674c>] call_softirq+0x1c/0x28
> [112343.045994] 
> [112343.045995] other info that might help us debug this:
> [112343.045997] no locks held by ksoftirqd/0/4.
> [112343.045999] 
> [112343.046000] stack backtrace:
> [112343.046003] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.28-rc4 #40
> [112343.046006] Call Trace:
> [112343.046008]  <IRQ>  [<ffffffff8026e41f>] print_usage_bug+0x1a3/0x1b2
> [112343.046019]  [<ffffffff8022f1dd>] save_stack_trace+0x22/0x3e
> [112343.046023]  [<ffffffff8026ee45>] mark_lock+0x5a9/0x91f
> [112343.046028]  [<ffffffff80270369>] __lock_acquire+0x6c2/0x14b2
> [112343.046032]  [<ffffffff802711e6>] lock_acquire+0x8d/0xba
> [112343.046037]  [<ffffffff802493f5>] sched_rt_period_timer+0xb9/0x1c7
> [112343.046041]  [<ffffffff804eda37>] _spin_lock+0x29/0x36
> [112343.046045]  [<ffffffff802493f5>] sched_rt_period_timer+0xb9/0x1c7
> [112343.046050]  [<ffffffff80355db7>] __next_cpu+0x19/0x26
> [112343.046054]  [<ffffffff802493f5>] sched_rt_period_timer+0xb9/0x1c7
> [112343.046058]  [<ffffffff804ed8ca>] _spin_unlock_irq+0x24/0x2e
> [112343.046063]  [<ffffffff8024933c>] sched_rt_period_timer+0x0/0x1c7
> [112343.046068]  [<ffffffff80264c82>] run_hrtimer_pending+0x61/0x10b
> [112343.046073]  [<ffffffff80254c83>] __do_softirq+0x8e/0x163
> [112343.046077]  [<ffffffff8022674c>] call_softirq+0x1c/0x28
> [112343.046079]  <EOI>  [<ffffffff80227db5>] do_softirq+0x45/0xa5
> [112343.046086]  [<ffffffff8025452f>] ksoftirqd+0x56/0xcc
> [112343.046090]  [<ffffffff802544d9>] ksoftirqd+0x0/0xcc
> [112343.046095]  [<ffffffff8026257e>] kthread+0x47/0x73
> [112343.046101]  [<ffffffff804ed511>] trace_hardirqs_on_thunk+0x3a/0x3f
> [112343.046105]  [<ffffffff80226259>] child_rip+0xa/0x11
> [112343.046109]  [<ffffffff80225463>] restore_args+0x0/0x30
> [112343.046114]  [<ffffffff80262512>] kthreadd+0x187/0x1ac
> [112343.046118]  [<ffffffff80262537>] kthread+0x0/0x73
> [112343.046122]  [<ffffffff8022624f>] child_rip+0x0/0x11
> 



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
