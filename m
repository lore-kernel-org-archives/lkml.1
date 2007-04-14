Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXDNKhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXDNKhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 06:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXDNKhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 06:37:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbXDNKg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 06:36:59 -0400
Date: Sat, 14 Apr 2007 12:36:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414103639.GA19454@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414080833.GL943@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> > this fix is not complete - because the child runqueue is locked 
> > here, not the parent's. I've fixed this properly in my tree and have 
> > uploaded a new sched-modular+cfs.patch. (the effects of the original 
> > bug are mostly harmless, the rbtree position gets corrected the 
> > first time the parent reschedules. The fix might improve heavy 
> > forker handling.)
> 
> It looks like it did not reach your public dir yet.

oops, forgot to do the last step - should be fixed now.

> BTW, I've given it a try. It seems pretty usable. I have also tried 
> the usual meaningless "glxgears" test with 12 of them at the same 
> time, and they rotate very smoothly, there is absolutely no pause in 
> any of them. But they don't all run at same speed, and top reports 
> their CPU load varying from 3.4 to 10.8%, with what looks like more 
> CPU is assigned to the first processes, and less CPU for the last 
> ones. But this is just a rough observation on a stupid test, I would 
> not call that one scientific in any way (and X has its share in the 
> test too).

ok, i'll try that too - there should be nothing particularly special 
about glxgears.

there's another tweak you could try:

	echo 500000 > /proc/sys/kernel/sched_granularity_ns

note that this causes preemption to be done as fast as the scheduler can 
do it. (in practice it will be mainly driven by CONFIG_HZ, so to get the 
best results a CONFIG_HZ of 1000 is useful.)

plus there's an add-on to CFS at:

  http://redhat.com/~mingo/cfs-scheduler/sched-fair-hog.patch

this makes the 'CPU usage history cutoff' configurable and sets it to a 
default of 100 msecs. This means that CPU hogs (tasks which actively 
kept other tasks from running) will be remembered, for up to 100 msecs 
of their 'hogness'.

Setting this limit back to 0 gives the 'vanilla' CFS scheduler's 
behavior:

     echo 0 > /proc/sys/kernel/sched_max_hog_history_ns

(So when trying this you dont have to reboot with this patch 
applied/unapplied, just set this value.)

> I'll perform other tests when I can rebuild with your fixed patch.

cool, thanks!

	Ingo
