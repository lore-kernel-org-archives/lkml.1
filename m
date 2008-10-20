Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYJTX3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYJTX3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYJTX3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:29:46 -0400
Received: from www.tglx.de ([62.245.132.106]:37481 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYJTX3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:29:45 -0400
Date: Tue, 21 Oct 2008 01:29:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] range hrtimers for .28
Message-ID: <alpine.LFD.2.00.0810202345570.3301@apollo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull range-hrtimers from

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git v28-range-hrtimers-for-linus

These patches provide the following new functionality:

    - convert select/poll to hrtimers
    - introduce range_hrtimers which allow to apply slack on an hrtimer
      in order to allow batching of hrtimers
    - add a prctrl to modify the per process slack value
    - convert the user space interfaces to use the range(slack) interfaces

a detailed description is available here: http://lwn.net/Articles/296578/

Full patch is available from: http://userweb.kernel.org/~tglx/v28-range-hrtimers-for-linus.patch

Thanks,

        tglx
---

Arjan van de Ven (30):
      select: Introduce a hrtimeout function
      select: switch select() and poll() over to hrtimers
      hrtimer: add abstraction functions for accessing the "expires" member
      hrtimer: convert kvm to the new hrtimer apis
      hrtimer: convert timerfd to the new hrtimer apis
      hrtimer: convert net::sched_cbq to the new hrtimer apis
      hrtimer: convert kernel/* to the new hrtimer apis
      hrtimer: convert powerpc/oprofile to the new hrtimer apis
      hrtimer: convert kvm-ia64 to the new hrtimer apis
      hrtimer: convert s390 to the new hrtimer apis
      hrtimer: convert sound/ to the new hrtimer apis
      hrtimer: rename the "expires" struct member to avoid accidental usage
      hrtimer: turn hrtimers into range timers
      hrtimer: create a "timer_slack" field in the task struct
      hrtimer: make select() and poll() use the hrtimer range feature
      hrtimer: fix build bug found by Ingo
      hrtimer: another build fix
      hrtimer: add a hrtimer_start_range() function
      hrtimer: incorporate feedback from Peter Zijlstra
      hrtimer: show the timer ranges in /proc/timer_list
      hrtimer: fix signed/unsigned bug in slack estimator
      hrtimer: make the nanosleep() syscall use the per process slack
      hrtimer: make the futex() system call use the per process slack value
      hrtimer: peek at the timer queue just before going idle
      select: fix alpha OSF wrapper
      select: fix alpha OSF wrapper
      rangetimer: fix x86 build failure for the !HRTIMERS case
      rangetimer: fix BUG_ON reported by Ingo
      rangetimers: fix the bug reported by Ingo for real
      Merge commit 'linus/master' into merge-linus

Ingo Molnar (2):
      Merge branch 'master' of git://git.kernel.org/.../arjan/linux-2.6-hrtimer into timers/range-hrtimers
      hrtimers: fix typo

Stephen Rothwell (1):
      DECLARE_PER_CPU needs linux/percpu.h

Thomas Gleixner (8):
      select: add a timespec_add_safe() function
      select: add poll_select_set_timeout() and poll_select_copy_remaining() helpers
      select: add a poll specific struct to the restart_block union
      Merge branch 'for-linus' of git://git.kernel.org/.../arjan/linux-2.6-hrtimer into timers/range-hrtimers
      hrtimers: fix docbook comments
      hrtimers: simplify hrtimer_peek_ahead_timers()
      hrtimers: add missing docbook comments to struct hrtimer
      Merge branch 'timers/range-hrtimers' into v28-timers-for-linus

 arch/alpha/kernel/osf_sys.c               |   13 +-
 arch/ia64/kvm/kvm-ia64.c                  |    2 +-
 arch/powerpc/oprofile/cell/spu_profiler.c |    2 +-
 arch/x86/kvm/i8254.c                      |    8 +-
 arch/x86/kvm/lapic.c                      |    6 +-
 drivers/cpuidle/cpuidle.c                 |    7 +
 drivers/s390/crypto/ap_bus.c              |    6 +-
 fs/compat.c                               |  187 +++++---------
 fs/select.c                               |  396 ++++++++++++++++-------------
 fs/timerfd.c                              |    8 +-
 include/linux/hrtimer.h                   |  105 ++++++++-
 include/linux/init_task.h                 |    1 +
 include/linux/poll.h                      |    8 +-
 include/linux/prctl.h                     |    7 +
 include/linux/sched.h                     |    6 +
 include/linux/thread_info.h               |    8 +
 include/linux/time.h                      |    4 +
 kernel/fork.c                             |    2 +
 kernel/futex.c                            |   11 +-
 kernel/hrtimer.c                          |  206 ++++++++++++++--
 kernel/posix-timers.c                     |   10 +-
 kernel/rtmutex.c                          |    3 +-
 kernel/sched.c                            |    7 +-
 kernel/sys.c                              |   10 +
 kernel/time.c                             |   18 ++
 kernel/time/ntp.c                         |    3 +-
 kernel/time/tick-sched.c                  |   25 +-
 kernel/time/timer_list.c                  |    8 +-
 net/sched/sch_cbq.c                       |    7 +-
 sound/drivers/pcsp/pcsp_lib.c             |    5 +-
 30 files changed, 710 insertions(+), 379 deletions(-)
