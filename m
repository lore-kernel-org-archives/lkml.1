Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbXIONHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbXIONHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXIONG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:06:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44724 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbXIONGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:06:55 -0400
Date: Sat, 15 Sep 2007 15:06:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070915130636.GA17223@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The latest sched-devel.git tree can be pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

people were busy sending patches, so there's lots of updates since the 
first announcement of the cfs-devel.git tree four days ago:

  include/linux/sched.h   |    4 
  init/Kconfig            |    9 +
  kernel/sched.c          |  374 +++++++++++++++++++++++++++++++++++++++++++-----
  kernel/sched_debug.c    |   22 +-
  kernel/sched_fair.c     |  191 ++++++++++++++++++++----
  kernel/sched_idletask.c |    5 
  kernel/sched_rt.c       |    5 
  kernel/sysctl.c         |   19 ++
  8 files changed, 552 insertions(+), 77 deletions(-)

the most user-noticeable improvement should be the latency/interactivity 
fixes from Mike Galbraith and Peter Zijlstra. The biggest (and most 
complex) item is the new group scheduler code from Srivatsa Vaddagiri. 
There's also speedups from Dmitry Adamushko and various cleanups and 
fixes. Also added in the yield workaround that should address the 
regression reported by Antoine Martin.

Changes:

- the biggest item is the addition of the group scheduler from Srivatsa 
  Vaddagiri - this is not configurable yet, it depends on
  CONFIG_CONTAINERS. It causes no overhead on !CONFIG_CONTAINERS. This
  code clearly seems mature now, hopefully the container bits go
  upstream in 2.6.24 too. Srivatsa did lots of heavy lifting in the past 
  few months, and this final bit of code that moves in all the 
  infrastructure changes almost nothing in the core scheduler.

- a triplet of nice simplifications from Dmitry Adamushko. Most notably
  Dmitry got rid of se->fair_key which shaves 8 bytes of task_struct and
  gives further speedup. Thanks Dmitry!

- continued refinements to the SMP ->vruntime code and timeslicing by 
  Peter Zijstra and Mike Galbraith.

As usual, bugreports, fixes and suggestions are welcome and please 
holler if some patch went missing in action.

	Ingo

------------------>
Dmitry Adamushko (3):
      sched: clean up struct load_stat
      sched: clean up schedstat block in dequeue_entity()
      sched: optimize away ->fair_key

Matthias Kaehlcke (1):
      sched: use list_for_each_entry_safe() in __wake_up_common()

Mike Galbraith (1):
      sched: fix SMP migration latencies

Peter Zijlstra (7):
      sched: simplify SCHED_FEAT_* code
      sched: new task placement for vruntime
      sched: simplify adaptive latency
      sched: clean up new task placement
      sched: add tree based averages
      sched: handle vruntime overflow
      sched: better min_vruntime tracking

Srivatsa Vaddagiri (1):
      sched: group-scheduler core

Ingo Molnar (27):
      sched: fix new-task method
      sched: resched task in task_new_fair()
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
      sched: sync up ->min_vruntime when going idle
      sched: add more vruntime statistics
      sched: debug: update exec_clock only when SCHED_DEBUG
      sched: remove wait_runtime limit
      sched: remove wait_runtime fields and features
      sched: x86: allow single-depth wchan output
      sched: yield workaround

 arch/i386/Kconfig       |   11 
 include/linux/sched.h   |   21 -
 init/Kconfig            |    9 
 kernel/sched.c          |  558 +++++++++++++++++++++++++------------
 kernel/sched_debug.c    |  100 +++---
 kernel/sched_fair.c     |  716 +++++++++++++++++++-----------------------------
 kernel/sched_idletask.c |    5 
 kernel/sched_rt.c       |    5 
 kernel/sysctl.c         |   33 +-
 9 files changed, 765 insertions(+), 693 deletions(-)
