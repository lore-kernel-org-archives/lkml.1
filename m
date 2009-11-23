Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZKWQbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZKWQbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZKWQbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:31:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:52686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbZKWQ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:28:09 -0500
From: Tejun Heo <tj@kernel.org>
To: peterz@infradead.org, torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
Subject: [PATCHSET] workqueue: prepare for concurrency managed workqueue, take#3
Date: Tue, 24 Nov 2009 01:26:50 +0900
Message-Id: <1258993624-28735-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset is the third take of prep-for-concurrent-managed-wq
patchset.  Changes from the last take[L] are

* sched_notifier wakeup notification firing location moved so that it
  happens after wake up is complete to allow calling local wake up
  function from wakeup notifier.

* sched-implement-sched_notifier_wake_up_process() replaced with
  sched-refactor-try_to_wake_up-and-implement-try_to_wake_up_local.
  Instead of implementing separately, common part is factored out from
  try_to_wake_up() and used to implement try_to_wake_up_local() as
  suggested by Peter Zijlstra.

* Patch description updated on sched-implement-force_cpus_allowed.

* 0015-0019 dropped from this series.  Updated versions will be posted
  in another patchset with other patches.

This patchset contains the following 14 patches.

  0001-sched-kvm-fix-race-condition-involving-sched_in_pree.patch
  0002-workqueue-Add-debugobjects-support.patch
  0003-sched-rename-preempt_notifier-to-sched_notifier-and-.patch
  0004-sched-update-sched_notifier-and-add-wakeup-sleep-not.patch
  0005-sched-refactor-try_to_wake_up-and-implement-try_to_w.patch
  0006-sched-implement-force_cpus_allowed.patch
  0007-acpi-use-queue_work_on-instead-of-binding-workqueue-.patch
  0008-stop_machine-reimplement-without-using-workqueue.patch
  0009-workqueue-misc-cosmetic-updates.patch
  0010-workqueue-merge-feature-parameters-into-flags.patch
  0011-workqueue-update-cwq-alignement-and-make-one-more-fl.patch
  0012-workqueue-define-both-bit-position-and-mask-for-work.patch
  0013-workqueue-separate-out-process_one_work.patch
  0014-workqueue-temporarily-disable-workqueue-tracing.patch

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-prep

Please note that the above tree is temporary.  It needs to be rebased
once 0001 appears in upstream.

This patchset contains the following changes.

 arch/ia64/kvm/Kconfig        |    1 
 arch/powerpc/kvm/Kconfig     |    1 
 arch/s390/kvm/Kconfig        |    1 
 arch/x86/kernel/smpboot.c    |    4 
 arch/x86/kvm/Kconfig         |    1 
 drivers/acpi/osl.c           |   41 +---
 include/linux/kvm_host.h     |    4 
 include/linux/preempt.h      |   43 ----
 include/linux/sched.h        |   59 +++++-
 include/linux/stop_machine.h |    6 
 include/linux/workqueue.h    |   96 ++++++----
 init/Kconfig                 |    4 
 init/main.c                  |    2 
 kernel/sched.c               |  316 ++++++++++++++++++++------------
 kernel/stop_machine.c        |  151 +++++++++++++--
 kernel/trace/Kconfig         |    4 
 kernel/workqueue.c           |  412 ++++++++++++++++++++++++++++++-------------
 lib/Kconfig.debug            |    8 
 virt/kvm/kvm_main.c          |   28 +-
 19 files changed, 786 insertions(+), 396 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/916333
