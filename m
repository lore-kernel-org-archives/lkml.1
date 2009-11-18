Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZKRWNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZKRWNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbZKRWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:13:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:40038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbZKRWNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:13:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=Sh2+1vg+A3I9TyzJQx8XUl0Ks4/LgB6CE2zVJoC4UWT1UvXtoSlQxSE3x7zllqqdy
	2I3Dqq3voZD0b6x/RXdSQ==
Date: Wed, 18 Nov 2009 14:13:31 -0800
From: Michel Lespinasse <walken@google.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091118221331.GA1300@google.com>
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu> <1258448121.7816.29.camel@laptop> <4B02CC46.4020506@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B02CC46.4020506@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 08:16:06AM -0800, Darren Hart wrote:
>> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
>
> Michael, would you be willing to include a version of this test in the  
> above test suite? If so, then in keeping with the rest of the test suite, 
> I would recommend splitting into two tests, one of each opcode being 
> tested, and  add argument to define thread count. The run.sh script would 
> then run each thread count as a separate test run.

There you go. Hope this helps. Feel free to adapt as needed.

Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/functional/futex_requeue_pi_mismatched_ops.c b/functional/futex_requeue_pi_mismatched_ops.c
index 50bd07b..529f5a8 100644
--- a/functional/futex_requeue_pi_mismatched_ops.c
+++ b/functional/futex_requeue_pi_mismatched_ops.c
@@ -113,7 +113,7 @@ int main(int argc, char *argv[])
 			 * requeue_pi target and aborted. Wake the child with
 			 * FUTEX_WAKE.
 			 */
-			ret = futex_wake(&f1, f1, 1, FUTEX_PRIVATE_FLAG);
+			ret = futex_wake(&f1, 1, FUTEX_PRIVATE_FLAG);
 			if (ret == 1)
 				ret = 0;
 			else if (ret < 0)
diff --git a/include/futextest.h b/include/futextest.h
index 2b64f79..853c3c4 100644
--- a/include/futextest.h
+++ b/include/futextest.h
@@ -78,6 +78,9 @@ int _verbose = VCRITICAL;
 #ifndef FUTEX_CMP_REQUEUE_PI
 #define FUTEX_CMP_REQUEUE_PI		12
 #endif
+#ifndef FUTEX_SET_WAIT
+#define FUTEX_SET_WAIT			13
+#endif
 #ifndef FUTEX_WAIT_REQUEUE_PI_PRIVATE
 #define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
@@ -86,6 +89,9 @@ int _verbose = VCRITICAL;
 #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
 #endif
+#ifndef FUTEX_SET_WAIT_PRIVATE
+#define FUTEX_SET_WAIT_PRIVATE		(FUTEX_SET_WAIT | FUTEX_PRIVATE_FLAG)
+#endif
 
 /** 
  * futex() - SYS_futex syscall wrapper
@@ -106,7 +112,7 @@ int _verbose = VCRITICAL;
  * like-named arguments in the following wrappers except where noted below.
  */
 #define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
-	syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3);
+	syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)
 
 /**
  * futex_wait() - block on uaddr with optional timeout
@@ -119,8 +125,8 @@ int _verbose = VCRITICAL;
  * futex_wake() - wake one or more tasks blocked on uaddr
  * @nr_wake:	wake up to this many tasks
  */
-#define futex_wake(uaddr, val, nr_wake, opflags) \
-	futex(uaddr, FUTEX_WAKE, val, NULL, NULL, nr_wake, opflags)
+#define futex_wake(uaddr, nr_wake, opflags) \
+	futex(uaddr, FUTEX_WAKE, nr_wake, NULL, NULL, 0, opflags)
 
 /**
  * futex_wait_bitset() - block on uaddr with bitset
@@ -133,8 +139,8 @@ int _verbose = VCRITICAL;
  * futex_wake_bitset() - wake one or more tasks blocked on uaddr with bitset
  * @bitset:	bitset to compare with that used in futex_wait_bitset
  */
-#define futex_wake_bitset(uaddr, val, nr_wake, bitset, opflags) \
-	futex(uaddr, FUTEX_WAKE_BITSET, val, NULL, NULL, bitset, opflags)
+#define futex_wake_bitset(uaddr, nr_wake, bitset, opflags) \
+	futex(uaddr, FUTEX_WAKE_BITSET, nr_wake, NULL, NULL, bitset, opflags)
 
 /**
  * futex_lock_pi() - block on uaddr as a PI mutex
@@ -198,6 +204,14 @@ int _verbose = VCRITICAL;
 	      opflags)
 
 /**
+ * futex_set_wait() - block on uaddr with bitset
+ * @setval:	value to set futex to if blocking
+ * @bitset:	bitset to be used with futex_wake_bitset
+ */
+#define futex_set_wait(uaddr, val, setval, timeout, bitset, opflags) \
+	futex(uaddr, FUTEX_SET_WAIT, val, timeout, setval, bitset, opflags)
+
+/**
  * futex_cmpxchg() - Atomic compare and exchange
  * @uaddr:	The address of the futex to be modified
  * @oldval:	The expected value of the futex
diff --git a/performance/Makefile b/performance/Makefile
index 9589e49..c4999a8 100644
--- a/performance/Makefile
+++ b/performance/Makefile
@@ -3,7 +3,7 @@ CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE $(INCLUDES)
 LDFLAGS := $(LDFLAGS) -lpthread -lrt
 
 HEADERS := ../include/futextest.h
-TARGETS :=
+TARGETS := futex_wait_test futex_setwait_test
 
 .PHONY: all clean
 all: $(TARGETS)
diff --git a/performance/futex_setwait_test.c b/performance/futex_setwait_test.c
new file mode 100644
index 0000000..0d09365
--- /dev/null
+++ b/performance/futex_setwait_test.c
@@ -0,0 +1,71 @@
+// Copyright 2009 Google Inc.
+// Author: walken@google.com (Michel Lespinasse)
+
+#include "futextest.h"
+#include "harness.h"
+
+#include <stdio.h>
+#include <errno.h>
+
+
+static inline void futex_setwait_lock(futex_t *futex)
+{
+	int status = *futex;
+	if (status == 0)
+		status = futex_cmpxchg(futex, 0, 1);
+	if (status != 0) {
+		int desired_status = 1;
+		do {
+			if (futex_set_wait(futex, 1, 2, NULL, ~0,
+					   FUTEX_PRIVATE_FLAG) == 0) {
+				/* We absorbed a wakeup; so make sure to
+				   unblock next thread */
+				desired_status = 2;
+			}
+			status = *futex;
+			if (status == 0)
+				status = futex_cmpxchg(futex, 0,
+						       desired_status);
+		} while (status != 0);
+	}
+}
+
+static inline void futex_cmpxchg_unlock(futex_t *futex)
+{
+	int status = *futex;
+	if (status == 1)
+		status = futex_cmpxchg(futex, 1, 0);
+	if (status == 2) {
+		futex_cmpxchg(futex, 2, 0);
+		futex_wake(futex, 1, FUTEX_PRIVATE_FLAG);
+	}
+}
+
+static void * futex_setwait_test(void * dummy)
+{
+	struct locktest_shared * shared = dummy;
+	int i = shared->loops;
+	barrier_sync(&shared->barrier_before);
+	while (i--) {
+		futex_setwait_lock(&shared->futex);
+		futex_cmpxchg_unlock(&shared->futex);
+	}
+	barrier_sync(&shared->barrier_after);
+	return NULL;
+}
+
+static int futex_setwait_supported(void)
+{
+	int futex = 0;
+	futex_set_wait(futex, 1, 2, NULL, ~0, FUTEX_PRIVATE_FLAG);
+	return errno == EWOULDBLOCK;
+}
+
+int main (void)
+{
+	if (futex_setwait_supported()) {
+		printf("\nFUTEX_SET_WAIT test\n");
+		locktest(futex_setwait_test, 100000000);
+	}
+	return 0;
+}
diff --git a/performance/futex_wait_test.c b/performance/futex_wait_test.c
new file mode 100644
index 0000000..88ce2f2
--- /dev/null
+++ b/performance/futex_wait_test.c
@@ -0,0 +1,56 @@
+// Copyright 2009 Google Inc.
+// Author: walken@google.com (Michel Lespinasse)
+
+#include "futextest.h"
+#include "harness.h"
+
+#include <stdio.h>
+
+
+static inline void futex_wait_lock(futex_t *futex)
+{
+	int status = *futex;
+	if (status == 0)
+		status = futex_cmpxchg(futex, 0, 1);
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
+	if (status == 1)
+		status = futex_cmpxchg(futex, 1, 0);
+	if (status == 2) {
+		futex_cmpxchg(futex, 2, 0);
+		futex_wake(futex, 1, FUTEX_PRIVATE_FLAG);
+	}
+}
+
+static void * futex_wait_test(void * dummy)
+{
+	struct locktest_shared * shared = dummy;
+	int i = shared->loops;
+	barrier_sync(&shared->barrier_before);
+	while (i--) {
+		futex_wait_lock(&shared->futex);
+		futex_cmpxchg_unlock(&shared->futex);
+	}
+	barrier_sync(&shared->barrier_after);
+	return NULL;
+}
+
+int main (void)
+{
+	printf("FUTEX_WAIT test\n");
+	locktest(futex_wait_test, 100000000);
+	return 0;
+}
diff --git a/performance/harness.h b/performance/harness.h
new file mode 100644
index 0000000..9d74d17
--- /dev/null
+++ b/performance/harness.h
@@ -0,0 +1,103 @@
+// Copyright 2009 Google Inc.
+// Author: walken@google.com (Michel Lespinasse)
+
+#include <limits.h>
+#include <sys/times.h>
+#include <stdio.h>
+#include <pthread.h>
+
+
+struct thread_barrier {
+	futex_t threads;
+	futex_t unblock;
+};
+
+struct locktest_shared {
+	struct thread_barrier barrier_before;
+	struct thread_barrier barrier_after;
+	int loops;
+	futex_t futex;
+};
+
+static inline void decrement(futex_t *ptr)
+{
+	__sync_fetch_and_add(ptr, -1);
+}
+
+/* Called by main thread to initialize barrier */
+static void barrier_init(struct thread_barrier *barrier, int threads)
+{
+	barrier->threads = threads;
+	barrier->unblock = 0;
+}
+
+/* Called by worker threads to synchronize with main thread */
+static void barrier_sync(struct thread_barrier *barrier)
+{
+	decrement(&barrier->threads);
+	if (barrier->threads == 0)
+		futex_wake(&barrier->threads, 1, FUTEX_PRIVATE_FLAG);
+	while (barrier->unblock == 0)
+		futex_wait(&barrier->unblock, 0, NULL, FUTEX_PRIVATE_FLAG);
+}
+
+/* Called by main thread to wait for all workers to reach sync point */
+static void barrier_wait(struct thread_barrier *barrier)
+{
+	int threads;
+	while ((threads = barrier->threads) > 0)
+		futex_wait(&barrier->threads, threads, NULL,
+			   FUTEX_PRIVATE_FLAG);
+}
+
+/* Called by main thread to unblock worker threads from their sync point */
+static void barrier_unblock(struct thread_barrier *barrier)
+{
+	barrier->unblock = 1;
+	futex_wake(&barrier->unblock, INT_MAX, FUTEX_PRIVATE_FLAG);
+}
+
+
+static void locktest(void * thread_function(void *), int iterations)
+{
+	int threads[] = { 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 24, 32,
+			  64, 128, 256, 512, 1024, 0 };
+	int t;
+	for (t = 0; threads[t]; t++) {
+		int num_threads = threads[t];
+		struct locktest_shared shared;
+		pthread_t thread[num_threads];
+		int i;
+		clock_t before, after;
+		struct tms tms_before, tms_after;
+		int wall, user, system;
+		double tick;
+
+		barrier_init(&shared.barrier_before, num_threads);
+		barrier_init(&shared.barrier_after, num_threads);
+		shared.loops = iterations / num_threads;
+		shared.futex = 0;
+
+		for (i = 0; i < num_threads; i++)
+			pthread_create(thread + i, NULL, thread_function,
+				       &shared);
+		barrier_wait(&shared.barrier_before);
+		before = times(&tms_before);
+		barrier_unblock(&shared.barrier_before);
+		barrier_wait(&shared.barrier_after);
+		after = times(&tms_after);
+		wall = after - before;
+		user = tms_after.tms_utime - tms_before.tms_utime;
+		system = tms_after.tms_stime - tms_before.tms_stime;
+		tick = 1.0 / sysconf(_SC_CLK_TCK);
+		printf("%d threads: %.0f Kiter/s "
+		       "(%.2fs user %.2fs system %.2fs wall %.2f cores)\n",
+		       num_threads,
+		       (num_threads * shared.loops) / (wall * tick * 1000),
+		       user * tick, system * tick, wall * tick,
+		       wall ? (user + system) * 1. / wall : 1.);
+		barrier_unblock(&shared.barrier_after);
+		for (i = 0; i < num_threads; i++)
+			pthread_join(thread[i], NULL);
+	}
+}


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
