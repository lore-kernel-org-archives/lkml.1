Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZKTEsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZKTEsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 23:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZKTEsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 23:48:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:45099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbZKTEsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 23:48:08 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Subject: [PATCHSET] workqueue: prepare for concurrency managed workqueue, take#2
Date: Fri, 20 Nov 2009 13:46:28 +0900
Message-Id: <1258692407-8985-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset is the second take of prep-for-concurrent-managed-wq
patchset.  Changes from the last take[L] are

* sched_notifier implementation redone such that it's more similar to
  preempt_notifier and activate/deactivate ops are replaced with
  wakeup/sleep.

  I thought about doing state based callback[s] - three callbacks for
  the three states - run, ready, sleep but it makes things more
  complicated for the caller and there are only four transition edges
  among the states anyway.

  Another alternative to the current wakeup/sleep/in/out would be
  wakeup/sleep/run/preempted where the only difference would be
  preempted is not called after sleep is called while out is called
  even after sleep is called.  Either is not much better than the
  other and the current use case fits in/out better, so I left it as
  was.

* cpu_populated_map is killed but single thread implementation is now
  left largely unchanged.  I'll follow up with further patches on
  this.

* force_cpus_allowed_ptr() renamed to force_cpus_allowed().

* Locking bug in introduce-worker fixed.

This patchset contains the following patches.

0001-sched-kvm-fix-race-condition-involving-sched_in_pree.patch
0002-workqueue-Add-debugobjects-support.patch
0003-sched-rename-preempt_notifier-to-sched_notifier-and-.patch
0004-sched-update-sched_notifier-and-add-wakeup-sleep-not.patch
0005-sched-implement-sched_notifier_wake_up_process.patch
0006-scheduler-implement-force_cpus_allowed.patch
0007-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
0008-stop_machine-reimplement-without-using-workqueue.patch
0009-workqueue-misc-cosmetic-updates.patch
0010-workqueue-merge-feature-parametesr-into-flags.patch
0011-workqueue-update-cwq-alignement-and-make-one-more-fl.patch
0012-workqueue-define-both-bit-position-and-mask-for-work.patch
0013-workqueue-separate-out-process_one_work.patch
0014-workqueue-temporarily-disable-workqueue-tracing.patch
0015-workqueue-kill-cpu_populated_map.patch
0016-workqueue-reimplement-workqueue-flushing-using-color.patch
0017-workqueue-introduce-worker.patch
0018-workqueue-reimplement-work-flushing-using-linked-wor.patch
0019-workqueue-reimplement-workqueue-freeze-using-cwq-fro.patch

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
 include/linux/kvm_host.h     |    4 
 include/linux/preempt.h      |   43 -
 include/linux/sched.h        |   58 +
 include/linux/stop_machine.h |    6 
 include/linux/workqueue.h    |  110 ++-
 init/Kconfig                 |    4 
 init/main.c                  |    2 
 kernel/power/process.c       |   22 
 kernel/sched.c               |  194 +++---
 kernel/stop_machine.c        |  151 +++-
 kernel/trace/Kconfig         |    4 
 kernel/workqueue.c           | 1362 +++++++++++++++++++++++++++++++++----------
 lib/Kconfig.debug            |    8 
 virt/kvm/kvm_main.c          |   28 
 20 files changed, 1507 insertions(+), 538 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/914545
