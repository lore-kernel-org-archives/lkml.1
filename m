Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZKPRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZKPRRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZKPRRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:17:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:33351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbZKPRRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:17:38 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Subject: [PATCHSET] workqueue: prepare for concurrency managed workqueue
Date: Tue, 17 Nov 2009 02:15:05 +0900
Message-Id: <1258391726-30264-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset is updated version of patches 01-18 (everything except
for the actual concurrency amanged workqueue implementation) of
implement-concurrency-managed-workqueue RFC patchset[1].  Changes are

* Schedule class override trick dropped in favor of generic scheduler
  notifier mechanism which replaces preempt notifiers.

* SINGLE_THREAD workqueues reimplemented using per-workqueue mutex.
  Long term goal is to remove most of single threaded workqueues.

* Colored workqueue flushing reimplemented to support multi color
  flushing.  It currently uses 16 colors.  As flushers are processed
  in batch once colors are used up, the effect of limited number of
  colors shouldn't be too noticeable even when there are many
  concurrent flushers.

* insert_wq_barrier() fixed to take @cwq from caller.  @target may
  change underneath leading so the caller needs to specify @cwq
  explicitly.

* Workers on a cpu now gets assigned unique number using ida.

This patchset contains the following patches.

 0001-workqueue-fix-race-condition-in-schedule_on_each_cpu.patch
 0002-sched-kvm-fix-race-condition-involving-sched_in_pree.patch
 0003-workqueue-Add-debugobjects-support.patch
 0004-sched-implement-scheduler-notifiers.patch
 0005-kvm-convert-kvm-to-use-new-scheduler-notifiers.patch
 0006-sched-drop-preempt-notifiers.patch
 0007-sched-implement-sched_notifier_wake_up_process.patch
 0008-scheduler-implement-force_cpus_allowed_ptr.patch
 0009-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
 0010-stop_machine-reimplement-without-using-workqueue.patch
 0011-workqueue-misc-cosmetic-updates.patch
 0012-workqueue-merge-feature-parametesr-into-flags.patch
 0013-workqueue-update-cwq-alignement-and-make-one-more-fl.patch
 0014-workqueue-define-both-bit-position-and-mask-for-work.patch
 0015-workqueue-separate-out-process_one_work.patch
 0016-workqueue-temporarily-disable-workqueue-tracing.patch
 0017-workqueue-simple-reimplementation-of-SINGLE_THREAD-w.patch
 0018-workqueue-reimplement-workqueue-flushing-using-color.patch
 0019-workqueue-introduce-worker.patch
 0020-workqueue-reimplement-work-flushing-using-linked-wor.patch
 0021-workqueue-reimplement-workqueue-freeze-using-cwq-fro.patch

0001-0002 are bug fixes to existing code.  They have been acked and
are currently in subsystem trees queued for 2.6.32.

0003 currently is in wq#for-next tree.

0004-0006 implement scheduler notifiers and replace preempt notifiers
with it.  0007 implements wake up function which can be used from
notifiers.

0017 replaces 0014 of [1] and reimplements SINGLE_THREAD so that it
behaves the same as mutl thread ones except that it uses mutex for
exclusion when actually executing the work.

0018 implements the new multi-color workqueue flushing.

Other than the above, patches remain mostly the same as the previous
posting except for minor bug fixes and updates.

If there's no objection (especially the scheduler notifier part), I
want to push the patches into linux-next and wait a while before
pushing concurrency managed workqueue.  This prep patchset already
contains a lot of changes so I think it would be helpful to verify
things are okay at this point.

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-prep

Please note that the above tree is temporary.  It needs to be rebased
once the fix patches appear upstream.

This patchset contains the following changes.

 arch/ia64/kvm/Kconfig        |    1 
 arch/powerpc/kvm/Kconfig     |    1 
 arch/s390/kvm/Kconfig        |    1 
 arch/x86/kernel/smpboot.c    |    4 
 arch/x86/kvm/Kconfig         |    1 
 drivers/acpi/osl.c           |   41 -
 include/linux/kvm_host.h     |    5 
 include/linux/preempt.h      |   43 -
 include/linux/sched.h        |   45 +
 include/linux/stop_machine.h |    6 
 include/linux/workqueue.h    |  110 ++-
 init/Kconfig                 |    4 
 init/main.c                  |    2 
 kernel/power/process.c       |   22 
 kernel/sched.c               |  245 ++++---
 kernel/stop_machine.c        |  151 +++-
 kernel/trace/Kconfig         |    4 
 kernel/workqueue.c           | 1387 +++++++++++++++++++++++++++++++++----------
 lib/Kconfig.debug            |    8 
 virt/kvm/kvm_main.c          |   51 -
 20 files changed, 1544 insertions(+), 588 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/896268
