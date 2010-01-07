Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004Ab0AGKkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab0AGKkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 05:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914Ab0AGKkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 05:40:05 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52152 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0AGKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 05:40:04 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 0/5] lockdep: Add information of file and line to lockdep_map
Date: Thu,  7 Jan 2010 19:39:50 +0900
Message-Id: <1262860795-5745-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a lot of lock instances with same names (e.g. port_lock).
This patch series add __FILE__ and __LINE__ to lockdep_map,
and these will be used for trace lock events.

Example use from perf lock map:

| 0xffffea0004c992b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
| 0xffffea0004b112b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
| 0xffffea0004a3f2b8: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
| 0xffffea0004cd5228: __pte_lockptr(page) (src: include/linux/mm.h, line: 952)
| 0xffff8800b91e2b28: &sb->s_type->i_lock_key (src: fs/inode.c, line: 166)
| 0xffff8800bb9d7ae0: key (src: kernel/wait.c, line: 16)
| 0xffff8800aa07dae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
| 0xffff8800b07fbae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
| 0xffff8800b07f3ae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
| 0xffff8800bf15fae0: &sighand->siglock (src: kernel/fork.c, line: 1490)
| 0xffff8800b90f7ae0: &dentry->d_lock (src: fs/dcache.c, line: 944)
| ...

(This output of perf lock map is produced by my local version,
 I'll send this later.)

And sadly, as Peter Zijlstra predicted, this produces certain overhead.

Before appling this series:
| % sudo ./perf lock rec perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 3.834 [sec]
After:
 sudo ./perf lock rec perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 5.415 [sec]
| [ perf record: Woken up 0 times to write data ]
| [ perf record: Captured and wrote 53.512 MB perf.data (~2337993 samples) ]

But raw exec of perf bench sched messaging is this:
| % perf bench sched messaging
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 0.498 [sec]

Tracing lock events already produces amount of overhead.
I think the overhead produced by this series is not a fatal problem,
radically optimization is required...

Could you merge this into perf/lock branch, Ingo?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

Hitoshi Mitake (5):
  lockdep: Add file and line to initialize sequence of spin and rw lock
  lockdep:  Add file and line to initialize sequence of rwsem
  lockdep:  Add file and line to initialize sequence of rwsem
  lockdep: Add file and line to initialize sequence of mutex
  lockdep: Fix the way to initialize class_mutex for information of
    file and line

 arch/x86/include/asm/rwsem.h   |    9 +++++++--
 drivers/base/class.c           |    3 ++-
 include/linux/mutex-debug.h    |    2 +-
 include/linux/mutex.h          |   12 +++++++++---
 include/linux/rwsem-spinlock.h |   11 ++++++++---
 include/linux/spinlock.h       |   12 ++++++++----
 include/linux/spinlock_types.h |   12 ++++++++++--
 kernel/mutex-debug.c           |    5 +++--
 kernel/mutex-debug.h           |    3 ++-
 kernel/mutex.c                 |    5 +++--
 kernel/mutex.h                 |    2 +-
 lib/rwsem-spinlock.c           |    5 +++--
 lib/rwsem.c                    |    5 +++--
 lib/spinlock_debug.c           |   10 ++++++----
 14 files changed, 66 insertions(+), 30 deletions(-)

