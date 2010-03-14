Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0CNKiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:38:54 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52825 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0CNKiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:52 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 00/11] lock monitor: Separate features related to lock
Date: Sun, 14 Mar 2010 19:38:37 +0900
Message-Id: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current lockdep is too complicated because,
 * dependency validation
 * statistics
 * event tracing
are all implemented by it.
This cause problem of overhead.
If user enables one of them, overhead of rests part is not avoidable.
(tracing is exception. If user enables validation or stat,
overhead of tracing doesn't occur.)

So I suggest new subsystem "lock monitor".
This is a general purpose lock event hooking mechanism.

lock monitor will be enable easy implementing and running
these features related to lock.

And I'm hoping that lock monitor will reduce overhead of perf lock.
Because lock monitor separates dependency validation and event tracing clearly,
so calling of functions of lockdep (e.g. lock_acquire()) only for validation
will not occur lock events.

I implemented it on the branch perf/inject of Frederic's random-tracing tree.
Because the branch is hottest place of lock and tracing :)

CAUTION!
This patch is very very beta, if you test it, please be careful!

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>

Hitoshi Mitake (11):
  lock monitor: New subsystem for lock event hooking
  Adopt lockdep to lock monitor
  Adopt spinlock to lock monitor
  Adopt rwlock to lock monitor
  Adopt arch dependent rwsem to lock monitor
  Adopt rwsem of x86 to lock monitor
  Adopt the way of initializing semaphore to lock monitor
  Adopt mutex to lock monitor
  Adopt rcu_read_lock() to lock monitor
  Adopt kernel/sched.c to lock monitor
  Very dirty temporal solution for testing lock monitor

 arch/x86/include/asm/rwsem.h     |   12 ++--
 fs/inode.c                       |    1 -
 fs/sysfs/dir.c                   |   24 +++++-
 include/linux/lock_monitor.h     |  171 ++++++++++++++++++++++++++++++++++++++
 include/linux/lockdep.h          |  138 ++++++-------------------------
 include/linux/mutex.h            |   14 ++--
 include/linux/rcupdate.h         |    4 +-
 include/linux/rwlock_api_smp.h   |   36 ++++----
 include/linux/rwlock_types.h     |   12 ++--
 include/linux/rwsem-spinlock.h   |   12 ++--
 include/linux/rwsem.h            |    2 +
 include/linux/semaphore.h        |    2 +-
 include/linux/spinlock.h         |    4 +-
 include/linux/spinlock_api_smp.h |   22 +++---
 include/linux/spinlock_types.h   |   16 ++--
 kernel/Makefile                  |    1 +
 kernel/lock_monitor.c            |  132 +++++++++++++++++++++++++++++
 kernel/lockdep.c                 |   51 ++++++++++--
 kernel/mutex-debug.c             |    2 +-
 kernel/mutex.c                   |   14 ++--
 kernel/rwsem.c                   |   16 ++--
 kernel/sched.c                   |    8 +-
 kernel/spinlock.c                |    8 +-
 lib/Kconfig.debug                |   16 +++-
 lib/rwsem-spinlock.c             |    2 +-
 lib/rwsem.c                      |    2 +-
 lib/spinlock_debug.c             |    4 +-
 net/core/sock.c                  |   15 ++++
 28 files changed, 515 insertions(+), 226 deletions(-)
 create mode 100644 include/linux/lock_monitor.h
 create mode 100644 kernel/lock_monitor.c

