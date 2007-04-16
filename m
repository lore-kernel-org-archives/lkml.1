Return-Path: <linux-kernel-owner+w=401wt.eu-S1030997AbXDPWHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030997AbXDPWHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031006AbXDPWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:07:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55360 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030997AbXDPWHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:07:54 -0400
Date: Tue, 17 Apr 2007 00:07:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070416220715.GA4071@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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


this is the second release of the CFS (Completely Fair Scheduler) 
patchset, against v2.6.21-rc7:

   http://redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.patch

i'd like to thank everyone for the tremendous amount of feedback and 
testing the v1 patch got - i could hardly keep up with just reading the 
mails! Some of the stuff people addressed i couldnt implement yet, i 
mostly concentrated on bugs, regressions and debuggability.

there's a fair amount of churn:

   15 files changed, 456 insertions(+), 241 deletions(-)

But it's an encouraging sign that there was no crash bug found in v1, 
all the bugs were related to scheduling-behavior details. The code was 
tested on 3 architectures so far: i686, x86_64 and ia64. Most of the 
code size increase in -v2 is due to debugging helpers, they'll be 
removed later. (The new /proc/sched_debug file can be used to see the 
fine details of CFS scheduling.)

Changes since -v1:

 - make nice levels less starvable. (reported by Willy Tarreau)

 - fixed child-runs first. A /proc/sys/kernel/sched_child_runs_first 
   flag can be used to turn it on/off. (This might fix the Kaffeine bug
   reported by S.Çağlar Onur <)

 - changed SCHED_FAIR back to SCHED_NORMAL (suggested by Con Kolivas)

 - UP build fix. (reported by Gabriel C)

 - timer tick micro-optimization (Dmitry Adamushko)

 - preemption fix: sched_class->check_preempt_curr method to decide 
   whether to preempt after a wakeup (or at a timer tick). (Found via a
   fairness-test-utility written for CFS by Mike Galbraith)

 - start forked children with neutral statistics instead of trying to 
   inherit them from the parent: Willy Tarreau reported that this 
   results in better behavior on extreme workloads, and it also 
   simplifies the code quite nicely. Removed sched_exit() and the 
   ->task_exit() methods.

 - make nice levels independent of the sched_granularity value

 - new /proc/sched_debug file listing runqueue details and the rbtree

 - new SCH-* fields in /proc/<NR>/status to see scheduling details

 - new cpu-hog feature (off by default) and sysctl tunable to set it: 
   /proc/sys/kernel/sched_max_hog_history_ns tunable defaults to
   0 (off). Positive values are meant the maximum 'memory' that the 
   scheduler has of CPU hogs.

 - various code cleanups

 - added more statistics temporarily: sum_exec_runtime, 
   sum_wait_runtime.

 - added -CFS-v2 to EXTRAVERSION

as usual, any sort of feedback, bugreports, fixes and suggestions are 
more than welcome,

	Ingo
