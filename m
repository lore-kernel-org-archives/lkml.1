Return-Path: <linux-kernel-owner+w=401wt.eu-S965093AbXHHUae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093AbXHHUae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764376AbXHHUa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:30:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763392AbXHHUaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:30:25 -0400
Date: Wed, 8 Aug 2007 22:30:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull request] scheduler updates
Message-ID: <20070808203008.GA3249@elte.hu>
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


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

the high commit count is scary, but it's all low-risk items: the main 
reason is the safe and gradual elimination of a widely used 64-bit 
function argument: the 64-bit "now" timestamp. About 40 of those commits 
are identity transformations that prepare the real change in a safe way, 
and the rest is obvious and safe as well. Besides the obvious and nice 
cleanup factor, these changes are necessary for 3 reasons: firstly they 
address the "there's too much 64-bit stuff in the scheduler" 
observation. Secondly, it's not directly visible but these changes also 
act as a correctness fix for an obscure (and minor) but 
not-too-pretty-to-fix accounting bug: idle_balance() had its own 
internal notion of 'now', separate from that of schedule(). Thirdly, 
this debloats sched.o quite significantly:

on 32-bit (smp, nondebug), it's almost 1k less code:

   text    data     bss     dec     hex filename
  34869    3066      20   37955    9443 sched.o.before
  33972    3066      24   37062    90c6 sched.o.after

but even on 64-bit platforms it's noticeable:

   text    data     bss     dec     hex filename
  28652    4162      24   32838    8046 sched.o.before
  28064    4162      24   32250    7dfa sched.o.after

and that's a speedup as well, because these parameters were passed all 
around the fastpath.

It was the safest to do it this way (considering that we are post -rc2 
already), together in one commit these changes would have been much less 
obvious to validate and apply. (It's of course all fully bisectable and 
every step builds and boots fine.)

besides this elimination of the 64-bit timestamp parameter passing 
between (almost all) scheduler functions, there are 8 other fixes that 
are not identity transformations:

 - Peter Williams reviewed the smpnice load-balancer and noticed a few 
   leftover items that are unnecessary now (i have re-tested 
   load-balancing behavior and it's all still fine)

 - binary sysctl cleanup from Alexey Dobriyan

 - two small accounting fixes

 - reniced tasks fixes: a key calculation fix (i re-checked key nice
   workloads and this has no real impact [other than improving them 
   slightly] - the other side of the branch fixed up the effects of this 
   - otherwise we'd have noticed this sooner), and two rounding 
   precision improvements that act against error accumulation.

 - sleeper_bonus should be batched by sched_granularity and not by 
   stat_granularity. (this has almost no effect in practice, but a 
   speedup that pushes the only 64-bit division in CFS into a slowpath.)

then are are also two non-code documentation updates and minor cleanups 
and uninlining.

Nevertheless, to be safe i have also done over 200 'make randconfig; 
make -j bzImage' build tests:

   #define UTS_VERSION "#231 SMP Wed Aug 8 21:34:24 CEST 2007"

all of which passed fine. Booted (and extensively tested) on x86-32 and 
x64-32 as well, both UP and SMP - UP, 2-way to 8-way systems.

	Ingo

------------------>

Alexey Dobriyan (1):
      sched: remove binary sysctls from kernel.sched_domain

Josh Triplett (1):
      sched: mark print_cfs_stats static

Peter Williams (2):
      sched: simplify move_tasks()
      sched: fix bug in balance_tasks()

Thomas Voegtle (1):
      sched: mention CONFIG_SCHED_DEBUG in documentation

Ulrich Drepper (1):
      sched: clean up sched_getaffinity()

Ingo Molnar (55):
      sched: batch sleeper bonus
      sched: reorder update_cpu_load(rq) with the ->task_tick() call
      sched: uninline rq_clock()
      sched: schedule() speedup
      sched: clean up delta_mine
      sched: delta_exec accounting fix
      sched: document nice levels
      sched: add [__]update_rq_clock(rq)
      sched: eliminate rq_clock() use
      sched: remove rq_clock()
      sched: eliminate __rq_clock() use
      sched: remove __rq_clock()
      sched: remove 'now' use from assignments
      sched: remove the 'u64 now' parameter from print_cfs_rq()
      sched: remove the 'u64 now' parameter from update_curr()
      sched: remove the 'u64 now' parameter from update_stats_wait_start()
      sched: remove the 'u64 now' parameter from update_stats_enqueue()
      sched: remove the 'u64 now' parameter from __update_stats_wait_end()
      sched: remove the 'u64 now' parameter from update_stats_wait_end()
      sched: remove the 'u64 now' parameter from update_stats_curr_start()
      sched: remove the 'u64 now' parameter from update_stats_dequeue()
      sched: remove the 'u64 now' parameter from update_stats_curr_end()
      sched: remove the 'u64 now' parameter from __enqueue_sleeper()
      sched: remove the 'u64 now' parameter from enqueue_sleeper()
      sched: remove the 'u64 now' parameter from enqueue_entity()
      sched: remove the 'u64 now' parameter from dequeue_entity()
      sched: remove the 'u64 now' parameter from set_next_entity()
      sched: remove the 'u64 now' parameter from pick_next_entity()
      sched: remove the 'u64 now' parameter from put_prev_entity()
      sched: remove the 'u64 now' parameter from update_curr_rt()
      sched: remove the 'u64 now' parameter from ->enqueue_task()
      sched: remove the 'u64 now' parameter from ->dequeue_task()
      sched: remove the 'u64 now' parameter from ->pick_next_task()
      sched: remove the 'u64 now' parameter from pick_next_task()
      sched: remove the 'u64 now' parameter from ->put_prev_task()
      sched: remove the 'u64 now' parameter from ->task_new()
      sched: remove the 'u64 now' parameter from update_curr_load()
      sched: remove the 'u64 now' parameter from inc_load()
      sched: remove the 'u64 now' parameter from dec_load()
      sched: remove the 'u64 now' parameter from inc_nr_running()
      sched: remove the 'u64 now' parameter from dec_nr_running()
      sched: remove the 'u64 now' parameter from enqueue_task()
      sched: remove the 'u64 now' parameter from dequeue_task()
      sched: remove the 'u64 now' parameter from deactivate_task()
      sched: remove the 'u64 now' local variables
      sched debug: remove the 'u64 now' parameter from print_task()/_rq()
      sched: move the __update_rq_clock() call to scheduler_tick()
      sched: remove __update_rq_clock() call from entity_tick()
      sched: clean up set_curr_task_fair()
      sched: optimize activate_task()
      sched: optimize update_rq_clock() calls in the load-balancer
      sched: make the multiplication table more accurate
      sched: round a bit better
      sched: fix update_stats_enqueue() reniced codepath
      sched: refine negative nice level granularity

 Documentation/sched-design-CFS.txt  |    2 
 Documentation/sched-nice-design.txt |  108 +++++++++++
 include/linux/sched.h               |   20 --
 kernel/sched.c                      |  339 ++++++++++++++++++------------------
 kernel/sched_debug.c                |   16 -
 kernel/sched_fair.c                 |  212 ++++++++++------------
 kernel/sched_idletask.c             |   10 -
 kernel/sched_rt.c                   |   48 +----
 8 files changed, 421 insertions(+), 334 deletions(-)
