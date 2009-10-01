Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZJAIKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZJAIKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbZJAIKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:38305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbZJAIJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:09:59 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: [RFC PATCHSET] workqueue: implement concurrency managed workqueue
Date: Thu,  1 Oct 2009 17:08:59 +0900
Message-Id: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This rather large patchset implements concurrency managed workqueue.
It's not complete yet.  Singlethread workqueue handling needs more
work and workqueue users need to be audited and simplified and async
and slow-work should be reimplemented in terms of workqueue.  Although
this patchset currently adds ~2000 lines of code, I'm fairly
optimistic that after the whole conversion is done, it would be a net
decrease in lines of code.

This patchset reimplements workqueue such that it auto-regulates
concurrency and thus relieves its users from the managing duty.  It
works by managing single shared pool of per-cpu workers and hooking
into the scheduler to get notifications about workers going to sleep
and waking up.  Using the mechanism, workqueue implementation keeps
track of the current level of concurrency and schedules only the
necessary number of workers to keep the cpu occupied.

Concurrency managed workqueue has the following benefits.

* Workqueue users no longer have to worry about managing concurrency
  and, in most cases, deadlocks.  The workqueue will manage it
  automatically and unless the deadlock chain involves many (currently
  127) works, it won't happen.

* There's one single shared pool of workers per cpu and one rescuer
  for each workqueue which requires it, so there are far fewer number
  of kthreads.

* More efficient.  Although it adds considerable amount of code, the
  code added to hot path isn't big and works will be executed on the
  local cpu and in batch as much as possible using minimal number of
  kthreads leading to fewer task switches and lower cache
  footprint. <NEED SOME BACKING NUMBERS>

* As concurrency is no longer a problem, most types of asynchronous
  jobs can be done using generic workqueue and other async mechanisms,
  including slow-work, async and adhoc subsystem custom ones, can be
  removed.  ie. It can serve as the unified async thread pool
  mechanism.

Please read the patch description of the last patch for more details.

This patchset contains the following 19 patches and most of these are
not signed off yet.

  0001-freezer-don-t-get-over-anxious-while-waiting.patch
  0002-scheduler-implement-sched_class_equal.patch
  0003-scheduler-implement-workqueue-scheduler-class.patch
  0004-scheduler-implement-force_cpus_allowed_ptr.patch
  0005-kthread-implement-kthread_data.patch
  0006-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
  0007-stop_machine-reimplement-without-using-workqueue.patch
  0008-workqueue-misc-cosmetic-updates.patch
  0009-workqueue-merge-feature-parametesr-into-flags.patch
  0010-workqueue-update-cwq-alignement-and-make-one-more-fl.patch
  0011-workqueue-define-both-bit-position-and-mask-for-work.patch
  0012-workqueue-separate-out-process_one_work.patch
  0013-workqueue-temporarily-disable-workqueue-tracing.patch
  0014-workqueue-TEMPORARY-kill-singlethread-variant.patch
  0015-workqueue-reimplement-workqueue-flushing-using-color.patch
  0016-workqueue-introduce-worker.patch
  0017-workqueue-reimplement-work-flushing-using-linked-wor.patch
  0018-workqueue-reimplement-workqueue-freeze-using-cwq-fro.patch
  0019-workqueue-implement-concurrency-managed-workqueue.patch

0001 makes freezer less anxious.  It's a mostly unrelated change I did
while looking at the code.

0002-0004 implements scheduler callback for workqueue.

0005 implements kthread_data() which will be used to get back at the
workqueue worker data structure from scheduler callbacks.

0006-0007 kill exotic usages of workqueue.

0008-0010 does misc preparations in workqueue code.

0011-0014 strip out some features from workqueue to prepare for new
implementation.  Please note that 0014 is incorrect and I'm currently
working on proper solution.

0015-0018 reimplement flushing and freezing in a way which is friendly
to multiple workers per cpu.

0019 implements concurrency managed workqueue.

Please note that none of the workqueue users has been updated yet.  It
will work fine but most workqueues which don't need rescuer would
create one.

I'm attaching test-wq source and Makefile which I used to verify each
aspect of the new workqueue.  It's pretty easy to write new test
scenarios using the module so if you're interested in how this
actually work, it is quite useful.

This patchset is on top of the current linus#master
(817b33d38f81c8736d39283c35c886ae4668f1af) and available in the
following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git concurrency-managed-workqueue

and contains the following changes.

 drivers/acpi/osl.c           |   41 
 include/linux/kthread.h      |    1 
 include/linux/sched.h        |    9 
 include/linux/stop_machine.h |    6 
 include/linux/workqueue.h    |   63 -
 init/main.c                  |    2 
 kernel/kthread.c             |   15 
 kernel/power/process.c       |   34 
 kernel/sched.c               |  105 +
 kernel/sched_fair.c          |   62 -
 kernel/sched_idletask.c      |    1 
 kernel/sched_rt.c            |    1 
 kernel/sched_workqueue.c     |  130 ++
 kernel/sched_workqueue.h     |   17 
 kernel/stop_machine.c        |  151 ++
 kernel/trace/Kconfig         |    4 
 kernel/workqueue.c           | 2268 ++++++++++++++++++++++++++++++++++++-------
 17 files changed, 2417 insertions(+), 493 deletions(-)

So, what do you guys think?

PS. I'm still working on it and will probably write up about overall
design under Documentation.

Thanks.

--
tejun
