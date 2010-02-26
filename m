Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936130Ab0BZMVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:21:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:43354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935927Ab0BZMOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:31 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: [PATCHSET] workqueue: concurrency managed workqueue, take#4
Date: Fri, 26 Feb 2010 21:22:37 +0900
Message-Id: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the fourth take of cmwq (concurrency managed workqueue)
patchset.  It's on top of 60b341b778cc2929df16c0a504c91621b3c6a4ad
(v2.6.33).  Git tree is available at

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

Quilt series is available at

  http://master.kernel.org/~tj/patches/review-cmwq.tar.gz

I tested the fscache changes with nfs + cachefiles and it works well
for me but the workload wasn't enough to put the yielding logic to the
test so it needs to be verified.

Please note that the scheduler patches need description update.  I'll
do that when establishing scheduler merge tree.

Depending on how you look at the result, the perf test from the last
take[L] showed no performance regression or insignificant improvement.
I'm quite happy with libata conversion.  Async works well with the
backend replaced with cmwq.  Fscache conversion is still in progress
but fscache workers are mostly used to issue and wait for IOs and I
think conversion so far shows that with some more impedence matching,
there shouldn't be major issues.

Now with non-reentrant and debugfs support, the whole series add about
800 lines but a lot are for cold-path things like CPU hotplug,
freezing and debugging.  Given that further conversions are likely to
simplify other workqueue users and the added capability, I don't think
800 more lines at this point is much.

Unless there still are major objections, I'd really like to go forward
with setting up a stable devel tree.  Ingo, do you still have
reservations about setting up a scheduler devel branch for cmwq?

The following patches have been added/updated since the last take[L].

 0008-workqueue-change-cancel_work_sync-to-clear-work-data.patch
 0013-workqueue-define-masks-for-work-flags-and-conditiona.patch
 0028-workqueue-carry-cpu-number-in-work-data-once-executi.patch
 0029-workqueue-implement-WQ_NON_REENTRANT.patch
 0033-workqueue-add-system_wq-system_long_wq-and-system_nr.patch
 0034-workqueue-implement-DEBUGFS-workqueue.patch
 0035-workqueue-implement-several-utility-APIs.patch
 0038-fscache-convert-object-to-use-workqueue-instead-of-s.patch
 0039-fscache-convert-operation-to-use-workqueue-instead-o.patch

* Oleg's 0008-workqueue-change-cancel_work_sync-to-clear-work-data
  added.  It clears work->data after cancel_work_sync().  cmwq patches
  updated accordingly.

* 0013 updated such that WORK_STRUCT_STATIC bit is used iff
  CONFIG_DEBUG_OBJECTS_WORK is enabled.  This reduces cwq alignment to
  64bytes with debug objects disabled.

* 0028-0029 added to implement non-reentrant workqueue.  A workqueue
  can be made non-reentrant by specifying WQ_NON_REENTRANT on
  creation.

  When a work starts executing, the data part of work->data is set to
  the CPU number so that NRT workqueue can reliably determine where
  the work was last on on the next queue.  Once the last CPU is known,
  the queueing code looks up the busy worker hash and determines
  whether the work is still running there in which case the work is
  queued on that cpu.  As workqueue guarantees non-reentrance on
  single CPU, this extra affining makes it globally non-reentrant.

  Delayed queueing path is updated to preserve the CPU number recorded
  in wq->data and flush and cancel code paths are updated to first
  look up the gcwq for a work rather than cwq which no longer is
  available once a work starts executing.

* In 0033, system_single_workqueue replaced with system_nrt_workqueue.

* 0034 adds debugfs support.  If CONFIG_WORKQUEUE_DEBUGFS is enabled,
  <debugfs>/workqueue lists all workers and works.  The output is
  pretty similar to that of slow-work debugfs and also has per-wq
  custom show method mechanism copied from slow-work.

* 0035 is what used to be 0030-workqueue-implement-work_busy.
  work_busy() is extended to check both pending and running states and
  other utility functions are added too - workqueue_set_max_active(),
  workqueue_congested() and work_cpu().

* fscache conversion patches 0038-0039 updated so that
  - non-reentrant workqueues are used instead of single workqueues.
  - sysctl knobs added to control max_active.
  - object worker yielding mechanism is implemented in fscache proper
    using workqueue_congested().
  - debug information remains equivalent.

* Other misc tweaks.

This patchset contains the following patches.

 0001-sched-consult-online-mask-instead-of-active-in-selec.patch
 0002-sched-rename-preempt_notifiers-to-sched_notifiers-an.patch
 0003-sched-refactor-try_to_wake_up.patch
 0004-sched-implement-__set_cpus_allowed.patch
 0005-sched-make-sched_notifiers-unconditional.patch
 0006-sched-add-wakeup-sleep-sched_notifiers-and-allow-NUL.patch
 0007-sched-implement-try_to_wake_up_local.patch
 0008-workqueue-change-cancel_work_sync-to-clear-work-data.patch
 0009-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
 0010-stop_machine-reimplement-without-using-workqueue.patch
 0011-workqueue-misc-cosmetic-updates.patch
 0012-workqueue-merge-feature-parameters-into-flags.patch
 0013-workqueue-define-masks-for-work-flags-and-conditiona.patch
 0014-workqueue-separate-out-process_one_work.patch
 0015-workqueue-temporarily-disable-workqueue-tracing.patch
 0016-workqueue-kill-cpu_populated_map.patch
 0017-workqueue-update-cwq-alignement.patch
 0018-workqueue-reimplement-workqueue-flushing-using-color.patch
 0019-workqueue-introduce-worker.patch
 0020-workqueue-reimplement-work-flushing-using-linked-wor.patch
 0021-workqueue-implement-per-cwq-active-work-limit.patch
 0022-workqueue-reimplement-workqueue-freeze-using-max_act.patch
 0023-workqueue-introduce-global-cwq-and-unify-cwq-locks.patch
 0024-workqueue-implement-worker-states.patch
 0025-workqueue-reimplement-CPU-hotplugging-support-using-.patch
 0026-workqueue-make-single-thread-workqueue-shared-worker.patch
 0027-workqueue-add-find_worker_executing_work-and-track-c.patch
 0028-workqueue-carry-cpu-number-in-work-data-once-executi.patch
 0029-workqueue-implement-WQ_NON_REENTRANT.patch
 0030-workqueue-use-shared-worklist-and-pool-all-workers-p.patch
 0031-workqueue-implement-concurrency-managed-dynamic-work.patch
 0032-workqueue-increase-max_active-of-keventd-and-kill-cu.patch
 0033-workqueue-add-system_wq-system_long_wq-and-system_nr.patch
 0034-workqueue-implement-DEBUGFS-workqueue.patch
 0035-workqueue-implement-several-utility-APIs.patch
 0036-libata-take-advantage-of-cmwq-and-remove-concurrency.patch
 0037-async-use-workqueue-for-worker-pool.patch
 0038-fscache-convert-object-to-use-workqueue-instead-of-s.patch
 0039-fscache-convert-operation-to-use-workqueue-instead-o.patch
 0040-fscache-drop-references-to-slow-work.patch
 0041-cifs-use-workqueue-instead-of-slow-work.patch
 0042-gfs2-use-workqueue-instead-of-slow-work.patch
 0043-slow-work-kill-it.patch

diffstat follows.

 Documentation/filesystems/caching/fscache.txt |   10 
 Documentation/slow-work.txt                   |  322 --
 arch/ia64/kernel/smpboot.c                    |    2 
 arch/ia64/kvm/Kconfig                         |    1 
 arch/powerpc/kvm/Kconfig                      |    1 
 arch/s390/kvm/Kconfig                         |    1 
 arch/x86/kernel/smpboot.c                     |    2 
 arch/x86/kvm/Kconfig                          |    1 
 drivers/acpi/osl.c                            |   41 
 drivers/ata/libata-core.c                     |   19 
 drivers/ata/libata-eh.c                       |    4 
 drivers/ata/libata-scsi.c                     |   10 
 drivers/ata/libata.h                          |    1 
 fs/cachefiles/namei.c                         |   14 
 fs/cachefiles/rdwr.c                          |    4 
 fs/cifs/Kconfig                               |    1 
 fs/cifs/cifsfs.c                              |    6 
 fs/cifs/cifsglob.h                            |    8 
 fs/cifs/dir.c                                 |    2 
 fs/cifs/file.c                                |   30 
 fs/cifs/misc.c                                |   20 
 fs/fscache/Kconfig                            |    1 
 fs/fscache/internal.h                         |    8 
 fs/fscache/main.c                             |  141 +
 fs/fscache/object-list.c                      |   11 
 fs/fscache/object.c                           |  106 
 fs/fscache/operation.c                        |   67 
 fs/fscache/page.c                             |   36 
 fs/gfs2/Kconfig                               |    1 
 fs/gfs2/incore.h                              |    3 
 fs/gfs2/main.c                                |   14 
 fs/gfs2/ops_fstype.c                          |    8 
 fs/gfs2/recovery.c                            |   54 
 fs/gfs2/recovery.h                            |    6 
 fs/gfs2/sys.c                                 |    3 
 include/linux/fscache-cache.h                 |   46 
 include/linux/kvm_host.h                      |    4 
 include/linux/libata.h                        |    2 
 include/linux/preempt.h                       |   48 
 include/linux/sched.h                         |   71 
 include/linux/slow-work.h                     |  163 -
 include/linux/stop_machine.h                  |    6 
 include/linux/workqueue.h                     |  145 -
 init/Kconfig                                  |   28 
 init/main.c                                   |    2 
 kernel/Makefile                               |    2 
 kernel/async.c                                |  140 -
 kernel/power/process.c                        |   21 
 kernel/sched.c                                |  334 +-
 kernel/slow-work-debugfs.c                    |  227 -
 kernel/slow-work.c                            | 1068 --------
 kernel/slow-work.h                            |   72 
 kernel/stop_machine.c                         |  151 -
 kernel/sysctl.c                               |    8 
 kernel/trace/Kconfig                          |    4 
 kernel/workqueue.c                            | 3283 ++++++++++++++++++++++----
 lib/Kconfig.debug                             |    7 
 virt/kvm/kvm_main.c                           |   26 
 58 files changed, 3807 insertions(+), 3010 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/939353
