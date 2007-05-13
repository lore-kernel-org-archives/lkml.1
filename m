Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbXEMPkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbXEMPkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 11:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbXEMPkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 11:40:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758480AbXEMPkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 11:40:00 -0400
Date: Sun, 13 May 2007 17:38:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: [patch] CFS scheduler, -v12
Message-ID: <20070513153853.GA19846@elte.hu>
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


i'm pleased to announce release -v12 of the CFS scheduler patchset.

The CFS patch against v2.6.22-rc1, v2.6.21.1 or v2.6.20.10 can be 
downloaded from the usual place:
  
    http://people.redhat.com/mingo/cfs-scheduler/

-v12 fixes the '3D bug' that caused trivial latencies in 3D games: it 
turns out that the problem was not resulting out of any core quality of 
CFS, it was caused by 3D userspace growing dependent on the current 
inefficiency of the vanilla scheduler's sys_sched_yield() 
implementation, and CFS's "make yield work well" changes broke it.

Even a simple 3D app like glxgears does a sys_sched_yield() for every 
frame it generates (!) on certain 3D cards, which in essence punishes 
any scheduler that implements sys_sched_yield() in a sane manner. This 
interaction of CFS's yield implementation with this user-space bug could 
be the main reason why some testers reported SD to be handling 3D games 
better than CFS. (SD uses a yield implementation similar to the vanilla 
scheduler.)

So i've added a yield workaround to -v12, which makes it work similar to 
how the vanilla scheduler and SD does it. (Xorg has been notified and 
this bug should be fixed there too. This took some time to debug because 
the 3D driver i'm using for testing does not use sys_sched_yield().) The 
workaround is activated by default so -v12 should work 'out of the box'.

Mike Galbraith has fixed a bug related to nice levels - the fix should 
make negative nice levels more potent again.

Changes since -v10:

 - nice level calculation fixes (Mike Galbraith)

 - load-balancing improvements (this should fix the SMP performance 
   problem reported by Michael Gerdau)

 - remove the sched_sleep_history_max tunable.

 - more debugging fields.

 - various cleanups, fixlets and code reorganization

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
