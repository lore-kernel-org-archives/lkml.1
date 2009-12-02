Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZLBD5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZLBD5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZLBD5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:57:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:56241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZLBD5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:57:17 -0500
From: Tejun Heo <tj@kernel.org>
To: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       efault@gmx.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [PATCHSET tip/sched/core] sched: concurrency managed workqueue related sched patches
Date: Wed,  2 Dec 2009 12:56:45 +0900
Message-Id: <1259726212-30259-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This patchset contains sched patches necessary for concurrency managed
workqueue and is composed of two parts.  The first four patches are to
be applied to sched/core and other than the implementation of
force_cpus_allowed(), it makes no functional changes.  The purpose of
this part is to reduce unnecessary conflicts between ongoing scheduler
developements and the temporary scheduler notifiers updates added by
the next three patches.

The next three patches are to be applied to a separate branch.  The
latter part adds sched_notifiers for wakeup and sleep and
try_to_wake_up_local() which can be called from those notifiers.
These changes are not acked by Ingo.  For these changes to go
upstream, scheduler notifier framework needs to be unified and cleaned
up.  However, merging these scheduler changes in a separate stable
branch which will only be pulled into linux-next and other testing
trees allows c-m-wq a stable base to be developed upon and tested.

This patchset contains the following patches.

 0001-sched-revert-498657a478c60be092208422fefa9c7b248729c.patch
 0002-sched-rename-preempt_notifiers-to-sched_notifiers-an.patch
 0003-sched-refactor-try_to_wake_up.patch
 0004-sched-implement-force_cpus_allowed.patch
 0005-sched-make-sched_notifiers-unconditional.patch
 0006-sched-add-wakeup-sleep-sched_notifiers-and-allow-NUL.patch
 0007-sched-implement-try_to_wake_up_local.patch

0001 reverts the mis-fix to sched_in notifier.  0002 and 0003 rename
and move code around.  These two patches either don't cause or cause
very minute difference in the final binary output.  0004 implements
force_cpus_allowed().  Although force_cpus_allowed() won't be used in
upstream yet, the implementation touches various parts of sched.c so I
think it's better to include it into upstream code earlier.

0005-0007 always enables sched_notifiers, add wakeup/sleep and
implement try_to_wake_up_local().  As said above, these three can live
in a separate branch which won't be pushed to upstream until sched
notifier framework is improved.

These patches are available in the following git trees.

 First four:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git sched-core-for-ingo

 Rest:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git sched-wq-for-ingo

and contains the following changes.

 First four:

 arch/ia64/kvm/Kconfig    |    2 
 arch/powerpc/kvm/Kconfig |    2 
 arch/s390/kvm/Kconfig    |    2 
 arch/x86/kvm/Kconfig     |    2 
 include/linux/kvm_host.h |    4 
 include/linux/preempt.h  |   43 ------
 include/linux/sched.h    |   60 ++++++++-
 init/Kconfig             |    2 
 kernel/sched.c           |  309 +++++++++++++++++++++++++----------------------
 virt/kvm/kvm_main.c      |   26 +--
 10 files changed, 243 insertions(+), 209 deletions(-)

 Rest:

 arch/ia64/kvm/Kconfig    |    1 
 arch/powerpc/kvm/Kconfig |    1 
 arch/s390/kvm/Kconfig    |    1 
 arch/x86/kvm/Kconfig     |    1 
 include/linux/kvm_host.h |    2 -
 include/linux/sched.h    |   14 ++++----
 init/Kconfig             |    4 --
 kernel/sched.c           |   80 +++++++++++++++++++++++++++++++++++++----------
 8 files changed, 72 insertions(+), 32 deletions(-)

Thanks.

--
tejun
