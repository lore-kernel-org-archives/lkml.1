Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbZKXOjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbZKXOjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933117AbZKXOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:39:52 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53782 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074AbZKXOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:39:25 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Michel Lespinasse <walken@google.com>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] perf bench: Add new files for futex performance test
Date: Tue, 24 Nov 2009 23:39:14 +0900
Message-Id: <1259073555-7312-3-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091118033741.GB23808@google.com>
References: <20091118033741.GB23808@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new files.

futextest.h provides general wrappers for futex() system call.
This patch containts the line:
typedef volatile u_int32_t futex_t;
I know that new typedef is not a thing to welcome,
but this is useful thing.

futex-wait.c is a new suite to test performance of FUTEX_WAIT.

These files are from Darren Hart's futex test,
and futex-wait.c is based on the program originally
written by Michel Lespinasse.

Example of use:
| % ./perf bench futex wait -t 48 -l 100000000
| # Running futex/wait benchmark...
| # Running 48 threads
| # Total number of iteration: 100000000
|    16233.763636 Kiter/sec
|        6.100000 user sec
|        0.000000 system sec
|        6.160000 wall sec
|        0.990260 cores
| % perf bench --format=simple futex wait
| 16207.455429

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/bench/futex-wait.c |  218 ++++++++++++++++++++++++++++++++
 tools/perf/bench/futextest.h  |  280 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 498 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/futex-wait.c
 create mode 100644 tools/perf/bench/futextest.h

diff --git a/tools/perf/bench/futex-wait.c b/tools/perf/bench/futex-wait.c
new file mode 100644
index 0000000..81335ed
--- /dev/null
+++ b/tools/perf/bench/futex-wait.c
@@ -0,0 +1,218 @@
+/*
+ *
+ * futex-wait.c
+ *
+ * wait: Performance test for wait op of futex()
+ *
+ * Copyright 2009 Google Inc.
+ * Original Author: walken@google.com (Michel Lespinasse)
+ * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ */
+
+#include "../perf.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+#include "../util/header.h"
+#include "../builtin.h"
+#include "bench.h"
+#include "futextest.h"
+#include "../util/include/asm/atomic.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <sys/times.h>
+#include <stdio.h>
+#include <pthread.h>
+
+struct thread_barrier {
+	futex_t threads;
+	futex_t unblock;
+};
+
+struct locktest_shared {
+	struct thread_barrier barrier_before;
+	struct thread_barrier barrier_after;
+	void (*locktest_function)(futex_t *ptr, int loops);
+	int loops;
+	futex_t futex;
+};
+
+/* Called by main thread to initialize barrier */
+static void barrier_init(struct thread_barrier *barrier, int threads)
+{
+	barrier->threads = threads;
+	barrier->unblock = 0;
+}
+
+/* Called by worker threads to synchronize with main thread */
+static int barrier_sync(struct thread_barrier *barrier)
+{
+	futex_dec(&barrier->threads);
+	if (barrier->threads == 0)
+		futex_wake(&barrier->threads, 1, FUTEX_PRIVATE_FLAG);
+	while (barrier->unblock == 0)
+		futex_wait(&barrier->unblock, 0, NULL, FUTEX_PRIVATE_FLAG);
+	return barrier->unblock;
+}
+
+/* Called by main thread to wait for all workers to reach sync point */
+static void barrier_wait(struct thread_barrier *barrier)
+{
+	int threads;
+	while ((threads = barrier->threads) > 0) {
+		futex_wait(&barrier->threads, threads, NULL,
+			   FUTEX_PRIVATE_FLAG);
+	}
+}
+
+/* Called by main thread to unblock worker threads from their sync point */
+static void barrier_unblock(struct thread_barrier *barrier, int value)
+{
+	barrier->unblock = value;
+	futex_wake(&barrier->unblock, INT_MAX, FUTEX_PRIVATE_FLAG);
+}
+
+static void *locktest_thread(void * dummy)
+{
+	struct locktest_shared *shared = dummy;
+	if (barrier_sync(&shared->barrier_before) > 0) {
+		shared->locktest_function(&shared->futex, shared->loops);
+		barrier_sync(&shared->barrier_after);
+	}
+	return NULL;
+}
+
+static void locktest(void locktest_function(futex_t *ptr, int loops),
+		     int num_threads, int iterations)
+{
+	struct locktest_shared shared;
+	pthread_t *thread;
+	int i;
+	clock_t before, after;
+	struct tms tms_before, tms_after;
+	int wall_time, user_time, system_time;
+	double tick;
+
+	thread = calloc(sizeof(pthread_t), num_threads);
+	BUG_ON(!thread);
+	barrier_init(&shared.barrier_before, num_threads);
+	barrier_init(&shared.barrier_after, num_threads);
+	shared.locktest_function = locktest_function;
+	shared.loops = iterations / num_threads;
+	shared.futex = 0;
+
+	for (i = 0; i < num_threads; i++) {
+		BUG_ON(pthread_create(thread + i, NULL,
+				      locktest_thread, &shared));
+	}
+
+	barrier_wait(&shared.barrier_before);
+	before = times(&tms_before);
+	barrier_unblock(&shared.barrier_before, 1);
+	barrier_wait(&shared.barrier_after);
+	after = times(&tms_after);
+	wall_time = after - before;
+	user_time = tms_after.tms_utime - tms_before.tms_utime;
+	system_time = tms_after.tms_stime - tms_before.tms_stime;
+	tick = 1.0 / sysconf(_SC_CLK_TCK);
+
+	switch (bench_format) {
+	case BENCH_FORMAT_DEFAULT:
+		printf(" %14f Kiter/sec\n",
+		       (num_threads * shared.loops)
+		       / (wall_time * tick * 1000));
+		printf(" %14f user sec\n", user_time * tick);
+		printf(" %14f system sec\n", system_time * tick);
+		printf(" %14f wall sec\n", wall_time * tick);
+		printf(" %14f cores\n",
+		       wall_time ?
+		       (user_time + system_time) * 1. / wall_time : 1.);
+		break;
+	case BENCH_FORMAT_SIMPLE:
+		printf("%f\n",
+		       (num_threads * shared.loops)
+		       / (wall_time * tick * 1000));
+		break;
+	default:
+		/* reaching this means there's some disaster: */
+		die("unknown format: %d\n", bench_format);
+		break;
+	}
+
+	barrier_unblock(&shared.barrier_after, 1);
+
+	for (i = 0; i < num_threads; i++)
+		BUG_ON(pthread_join(thread[i], NULL));
+}
+
+static inline void futex_wait_lock(futex_t *futex)
+{
+	int status = *futex;
+
+	if (status == 0)
+		status = futex_cmpxchg(futex, 0, 1);
+
+	while (status != 0) {
+		if (status == 1)
+			status = futex_cmpxchg(futex, 1, 2);
+		if (status != 0) {
+			futex_wait(futex, 2, NULL, FUTEX_PRIVATE_FLAG);
+			status = *futex;
+		}
+		if (status == 0)
+			status = futex_cmpxchg(futex, 0, 2);
+	}
+}
+
+static inline void futex_cmpxchg_unlock(futex_t *futex)
+{
+	int status = *futex;
+
+	if (status == 1)
+		status = futex_cmpxchg(futex, 1, 0);
+
+	if (status == 2) {
+		futex_cmpxchg(futex, 2, 0);
+		futex_wake(futex, 1, FUTEX_PRIVATE_FLAG);
+	}
+}
+
+static void futex_wait_test(futex_t *futex, int loops)
+{
+	while (loops--) {
+		futex_wait_lock(futex);
+		futex_cmpxchg_unlock(futex);
+	}
+}
+
+static int threads = 32;
+static int loops = 100000000;
+
+static const struct option options[] = {
+	OPT_INTEGER('t', "threads", &threads,
+		    "Specify number of threads"),
+	OPT_INTEGER('l', "loops", &loops,
+		    "Specify number of loops"),
+	OPT_END()
+};
+
+static const char * const bench_futex_wait_usage[] = {
+	"perf bench futex wait <options>",
+	NULL
+};
+
+int bench_futex_wait(int argc, const char **argv,
+		    const char *prefix __used)
+{
+	argc = parse_options(argc, argv, options,
+			     bench_futex_wait_usage, 0);
+
+	if (bench_format == BENCH_FORMAT_DEFAULT) {
+		printf("# Running %d threads\n", threads);
+		printf("# Total number of iteration: %d\n", loops);
+	}
+
+	locktest(futex_wait_test, threads, loops);
+	return 0;
+}
diff --git a/tools/perf/bench/futextest.h b/tools/perf/bench/futextest.h
new file mode 100644
index 0000000..09d8b94
--- /dev/null
+++ b/tools/perf/bench/futextest.h
@@ -0,0 +1,280 @@
+/******************************************************************************
+ *
+ *   Copyright © International Business Machines  Corp., 2009
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * NAME
+ *      futextest.h
+ *
+ * DESCRIPTION
+ *      Glibc independent futex library for testing kernel functionality.
+ *
+ * AUTHOR
+ *      Darren Hart <dvhltc@us.ibm.com>
+ *
+ * HISTORY
+ *      2009-Nov-24:
+ *       Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
+ *      2009-Nov-06: Initial version by Darren Hart <dvhltc@us.ibm.com>
+ *
+ *****************************************************************************/
+
+#ifndef _FUTEXTEST_H
+#define _FUTEXTEST_H
+
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <linux/futex.h>
+
+typedef volatile u_int32_t futex_t;
+#define FUTEX_INITIALIZER 0
+
+/* Define the newer op codes if the system header file is not up to date. */
+#ifndef FUTEX_WAIT_BITSET
+#define FUTEX_WAIT_BITSET		9
+#endif
+#ifndef FUTEX_WAKE_BITSET
+#define FUTEX_WAKE_BITSET		10
+#endif
+#ifndef FUTEX_WAIT_REQUEUE_PI
+#define FUTEX_WAIT_REQUEUE_PI		11
+#endif
+#ifndef FUTEX_CMP_REQUEUE_PI
+#define FUTEX_CMP_REQUEUE_PI		12
+#endif
+#ifndef FUTEX_WAIT_REQUEUE_PI_PRIVATE
+#define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#endif
+#ifndef FUTEX_REQUEUE_PI_PRIVATE
+#define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#endif
+
+/**
+ * futex() - SYS_futex syscall wrapper
+ * @uaddr:	address of first futex
+ * @op:		futex op code
+ * @val:	typically expected value of uaddr, but varies by op
+ * @timeout:	typically an absolute struct timespec (except where noted
+ * 		otherwise). Overloaded by some ops
+ * @uaddr2:	address of second futex for some ops\
+ * @val3:	varies by op
+ * @opflags:	flags to be bitwise OR'd with op, such as FUTEX_PRIVATE_FLAG
+ *
+ * futex() is used by all the following futex op wrappers. It can also be
+ * used for misuse and abuse testing. Generally, the specific op wrappers
+ * should be used instead. It is a macro instead of an static inline function as
+ * some of the types over overloaded (timeout is used for nr_requeue for
+ * example).
+ *
+ * These argument descriptions are the defaults for all
+ * like-named arguments in the following wrappers except where noted below.
+ */
+#define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
+	syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
+
+/**
+ * futex_wait() - block on uaddr with optional timeout
+ * @timeout:	relative timeout
+ */
+static inline int
+futex_wait(futex_t *uaddr, futex_t val, struct timespec *timeout, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT, val, timeout, NULL, 0, opflags);
+}
+
+/**
+ * futex_wake() - wake one or more tasks blocked on uaddr
+ * @nr_wake:	wake up to this many tasks
+ */
+static inline int
+futex_wake(futex_t *uaddr, int nr_wake, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags);
+}
+
+/**
+ * futex_wait_bitset() - block on uaddr with bitset
+ * @bitset:	bitset to be used with futex_wake_bitset
+ */
+static inline int
+futex_wait_bitset(futex_t *uaddr, futex_t val, struct timespec *timeout,
+		  u_int32_t bitset, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT_BITSET, val, timeout, NULL, bitset,
+		     opflags);
+}
+
+/**
+ * futex_wake_bitset() - wake one or more tasks blocked on uaddr with bitset
+ * @bitset:	bitset to compare with that used in futex_wait_bitset
+ */
+static inline int
+futex_wake_bitset(futex_t *uaddr, int nr_wake, u_int32_t bitset, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE_BITSET, nr_wake, NULL, NULL, bitset,
+		     opflags);
+}
+
+/**
+ * futex_lock_pi() - block on uaddr as a PI mutex
+ * @detect:	whether (1) or not (0) to perform deadlock detection
+ */
+static inline int
+futex_lock_pi(futex_t *uaddr, struct timespec *timeout, int detect,
+	      int opflags)
+{
+	return futex(uaddr, FUTEX_LOCK_PI, detect, timeout, NULL, 0, opflags);
+}
+
+/**
+ * futex_unlock_pi() - release uaddr as a PI mutex, waking the top waiter
+ */
+static inline int
+futex_unlock_pi(futex_t *uaddr, int opflags)
+{
+	return futex(uaddr, FUTEX_UNLOCK_PI, 0, NULL, NULL, 0, opflags);
+}
+
+/**
+ * futex_wake_op() - FIXME: COME UP WITH A GOOD ONE LINE DESCRIPTION
+ */
+static inline int
+futex_wake_op(futex_t *uaddr, futex_t *uaddr2, int nr_wake, int nr_wake2,
+	      int wake_op, int opflags)
+{
+	return futex(uaddr, FUTEX_WAKE_OP, nr_wake, nr_wake2, uaddr2, wake_op,
+		     opflags);
+}
+
+/**
+ * futex_requeue() - requeue without expected value comparison, deprecated
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ *
+ * Due to its inherently racy implementation, futex_requeue() is deprecated in
+ * favor of futex_cmp_requeue().
+ */
+static inline int
+futex_requeue(futex_t *uaddr, futex_t *uaddr2, int nr_wake, int nr_requeue,
+	      int opflags)
+{
+	return futex(uaddr, FUTEX_REQUEUE, nr_wake, nr_requeue, uaddr2, 0,
+		     opflags);
+}
+
+/**
+ * futex_cmp_requeue() - requeue tasks from uaddr to uaddr2
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ */
+static inline int
+futex_cmp_requeue(futex_t *uaddr, futex_t val, futex_t *uaddr2, int nr_wake,
+		  int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE, nr_wake, nr_requeue, uaddr2,
+		     val, opflags);
+}
+
+/**
+ * futex_wait_requeue_pi() - block on uaddr and prepare to requeue to uaddr2
+ * @uaddr:	non-PI futex source
+ * @uaddr2:	PI futex target
+ *
+ * This is the first half of the requeue_pi mechanism. It shall always be
+ * paired with futex_cmp_requeue_pi().
+ */
+static inline int
+futex_wait_requeue_pi(futex_t *uaddr, futex_t val, futex_t *uaddr2,
+		      struct timespec *timeout, int opflags)
+{
+	return futex(uaddr, FUTEX_WAIT_REQUEUE_PI, val, timeout, uaddr2, 0,
+		     opflags);
+}
+
+/**
+ * futex_cmp_requeue_pi() - requeue tasks from uaddr to uaddr2 (PI aware)
+ * @uaddr:	non-PI futex source
+ * @uaddr2:	PI futex target
+ * @nr_wake:	wake up to this many tasks
+ * @nr_requeue:	requeue up to this many tasks
+ */
+static inline int
+futex_cmp_requeue_pi(futex_t *uaddr, futex_t val, futex_t *uaddr2, int nr_wake,
+		     int nr_requeue, int opflags)
+{
+	return futex(uaddr, FUTEX_CMP_REQUEUE_PI,
+		     nr_wake, nr_requeue, uaddr2, val, opflags);
+}
+
+/**
+ * futex_cmpxchg() - atomic compare and exchange
+ * @uaddr:	The address of the futex to be modified
+ * @oldval:	The expected value of the futex
+ * @newval:	The new value to try and assign the futex
+ *
+ * Implement cmpxchg using gcc atomic builtins.
+ * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
+ *
+ * Return the old futex value.
+ */
+static inline u_int32_t
+futex_cmpxchg(futex_t *uaddr, u_int32_t oldval, u_int32_t newval)
+{
+	return __sync_val_compare_and_swap(uaddr, oldval, newval);
+}
+
+/**
+ * futex_dec() - atomic decrement of the futex value
+ * @uaddr:	The address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_dec(futex_t *uaddr)
+{
+	return __sync_sub_and_fetch(uaddr, 1);
+}
+
+/**
+ * futex_inc() - atomic increment of the futex value
+ * @uaddr:	the address of the futex to be modified
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_inc(futex_t *uaddr)
+{
+	return __sync_add_and_fetch(uaddr, 1);
+}
+
+/**
+ * futex_set() - atomic decrement of the futex value
+ * @uaddr:	the address of the futex to be modified
+ * @newval:	New value for the atomic_t
+ *
+ * Return the new futex value.
+ */
+static inline u_int32_t
+futex_set(futex_t *uaddr, u_int32_t newval)
+{
+	*uaddr = newval;
+	return newval;
+}
+
+#endif
-- 
1.6.5.2

