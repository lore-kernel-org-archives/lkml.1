Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbXIRUcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbXIRUcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXIRUcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:32:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbXIRUcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:32:13 -0400
Date: Tue, 18 Sep 2007 22:22:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dimm <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070918202243.GD1632@elte.hu>
References: <1190144190.5204.24.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190144190.5204.24.camel@earth>
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


* dimm <dmitry.adamushko@gmail.com> wrote:

> [ well, don't expect to find here anything like RDCFS (no, 'D' does 
> not stand for 'dumb'!). I was focused on more prosaic things in the 
> mean time so just didn't have time for writing it.. ]
> 
> here is a few cleanup/simplification/optimization(s) based on the 
> recent modifications in the sched-dev tree.
> 
> (1) optimize task_new_fair()
> (2) simplify yield_task()
> (3) rework enqueue/dequeue_entity() to get rid of
>     sched_class::set_curr_task()

the queue with your enhancements and simplifications applied looks good 
here, and it booted fine on two testboxes. I've updated the 
sched-devel.git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

(below is the full shortlog over current upstream.)

(I have not tested the group scheduling bits but perhaps Srivatsa would 
like to do that?)

	Ingo

------------------>
Dmitry Adamushko (9):
      sched: clean up struct load_stat
      sched: clean up schedstat block in dequeue_entity()
      sched: sched_setscheduler() fix
      sched: add set_curr_task() calls
      sched: do not keep current in the tree and get rid of sched_entity::fair_key
      sched: yield-workaround update
      sched: optimize task_new_fair()
      sched: simplify sched_class::yield_task()
      sched: rework enqueue/dequeue_entity() to get rid of set_curr_task()

Ingo Molnar (29):
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
      sched: fix delay accounting performance regression
      sched: disable START_DEBIT

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

 arch/i386/Kconfig     |   11 
 include/linux/sched.h |   24 -
 init/Kconfig          |    9 
 kernel/sched.c        |  544 ++++++++++++++++++++++++------------
 kernel/sched_debug.c  |  100 ++----
 kernel/sched_fair.c   |  752 ++++++++++++++++++++------------------------------
 kernel/sched_rt.c     |    4 
 kernel/sched_stats.h  |    4 
 kernel/sysctl.c       |   35 +-
 9 files changed, 763 insertions(+), 720 deletions(-)
