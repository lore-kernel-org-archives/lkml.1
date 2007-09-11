Return-Path: <linux-kernel-owner+w=401wt.eu-S966795AbXIKUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966795AbXIKUOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934242AbXIKUFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:05:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42310 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678AbXIKUFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:05:05 -0400
Date: Tue, 11 Sep 2007 22:04:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [announce] CFS-devel, performance improvements
Message-ID: <20070911200459.GA6974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


fresh back from the Kernel Summit, Peter Zijlstra and me are pleased to 
announce the latest iteration of the CFS scheduler development tree. Our 
main focus has been on simplifications and performance - and as part of 
that we've also picked up some ideas from Roman Zippel's 'Really Fair 
Scheduler' patch as well and integrated them into CFS. We'd like to ask 
people go give these patches a good workout, especially with an eye on 
any interactivity regressions.

The combo patch against 2.6.23-rc6 can be picked up from:

  http://people.redhat.com/mingo/cfs-scheduler/devel/

The sched-devel.git tree can be pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

There are lots of small performance improvements in form of a 
finegrained 29-patch series. We have removed a number of features and 
metrics from CFS that might have been needed but ended up being 
superfluous - while keeping the things that worked out fine, like 
sleeper fairness. On 32-bit x86 there's a ~16% speedup (over -rc6) in 
lmbench (lat_ctx -s 0 2) results:

                                  (microseconds, lower is better)
     ------------------------------------------------------------
        v2.6.22    2.6.23-rc6(CFS)     v2.6.23-rc6-CFS-devel
     ----------------------------------------------------
           0.70          0.75                0.65
           0.62          0.66                0.63
           0.60          0.72                0.69
           0.62          0.74                0.61
           0.69          0.73                0.53
           0.66          0.73                0.63
           0.63          0.69                0.61
           0.63          0.70                0.64
           0.61          0.76                0.61
           0.69          0.74                0.63
     ----------------------------------------------------
      avg: 0.64          0.72 (+12%)         0.62 (-3%)

there is a similar speedup on 64-bit x86 as well. We are now a bit 
faster than the O(1) scheduler was under v2.6.22 - even on 32-bit. The 
main speedup comes from the avoidance of divisions (or shifts) in the 
wakeup and context-switch fastpaths.

there's also a visible reduction in code size:

   text    data     bss     dec     hex filename
  13369     228    2036   15633    3d11 sched.o.before  (UP, nodebug)
  11167     224    1988   13379    3443 sched.o.after   (UP, nodebug)

which obviously helps embedded and is good for performance as well. Even 
on 32-bit we are now within 1% of the size of v2.6.22's sched.o, which 
was:

   text    data     bss     dec     hex filename
   9915      24    3344   13283    33e3 sched.o.v2.6.22

and on SMP the new scheduler is now substantially smaller:

   text    data     bss     dec     hex filename
  24972    4149      24   29145    71d9 sched.o-v2.6.22
  24056    2594      16   26666    682a sched.o-CFS-devel

Changes: besides the many micro-optimizations, one of the changes is 
that se->vruntime (virtual runtime) based scheduling has been introduced 
gradually, step by step - while keeping the wait_runtime metric working 
too. (so that the two methods are comparable side by side, in the same 
scheduler)

The ->vruntime metric is similar to the ->time_norm metric used by 
Roman's patch (and both are losely related to the already existing 
sum_exec_runtime metric in CFS), it's in essence the sum of CPU time 
executed by a task, in nanoseconds - weighted up or down by their nice 
level (or kept the same on the default nice 0 level). Besides this basic 
metric our implementation and math differs from RFS. The two approaches 
should be conceptually more comparable from now on.

We have also picked up two cleanups from RFS (the cfs_rq->curr approach 
and an uninlining optimization) and there's also a cleanup patch from 
Matthias Kaehlcke. We welcome and encourage finegrained patches against 
this patchset. As usual, bugreports, fixes and suggestions are welcome,

	Ingo, Peter

------------------>
Matthias Kaehlcke (1):
      sched: use list_for_each_entry_safe() in __wake_up_common()

Peter Zijlstra (5):
      sched: simplify SCHED_FEAT_* code
      sched: new task placement for vruntime
      sched: simplify adaptive latency
      sched: clean up new task placement
      sched: add tree based averages

Ingo Molnar (23):
      sched: fix new-task method
      sched: small sched_debug cleanup
      sched: debug: track maximum 'slice'
      sched: uniform tunings
      sched: use constants if !CONFIG_SCHED_DEBUG
      sched: remove stat_gran
      sched: remove precise CPU load
      sched: remove precise CPU load calculations #2
      sched: track cfs_rq->curr on !group-scheduling too
      sched: cleanup: simplify cfs_rq_curr() methods
      sched: uninline __enqueue_entity()/__dequeue_entity()
      sched: speed up update_load_add/_sub()
      sched: clean up calc_weighted()
      sched: introduce se->vruntime
      sched: move sched_feat() definitions
      sched: optimize vruntime based scheduling
      sched: simplify check_preempt() methods
      sched: wakeup granularity fix
      sched: add se->vruntime debugging
      sched: debug: update exec_clock only when SCHED_DEBUG
      sched: remove wait_runtime limit
      sched: remove wait_runtime fields and features
      sched: x86: allow single-depth wchan output

 arch/i386/Kconfig     |   11 
 include/linux/sched.h |   17 -
 kernel/sched.c        |  196 ++++-------------
 kernel/sched_debug.c  |   86 +++----
 kernel/sched_fair.c   |  557 +++++++++++++-------------------------------------
 kernel/sysctl.c       |   22 -
 6 files changed, 243 insertions(+), 646 deletions(-)
