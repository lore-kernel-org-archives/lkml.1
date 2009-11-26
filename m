Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZKZF5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZKZF5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZKZF5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:57:32 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:65240 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZKZF5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:57:31 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] futextest: Make locktest() in harness.h more general
Date: Thu, 26 Nov 2009 14:56:57 +0900
Message-Id: <1259215017-30305-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091126.145338.189277946042751963.mitake@dcl.info.waseda.ac.jp>
References: <20091126.145338.189277946042751963.mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new function locktest_preset() to harness.h,
which is a wrapper for locktest().
Current locktest() has array of threads number for test,
but this makes usefulness of harness.h less.
So preset arrays should go to outside of locktest().
locktest_preset() has preset array now.

And every output has gone to locktest_preset() too.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 performance/futex_wait.c |    2 +-
 performance/harness.h    |   98 +++++++++++++++++++++++++++-------------------
 2 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/performance/futex_wait.c b/performance/futex_wait.c
index bcbca77..62a7330 100644
--- a/performance/futex_wait.c
+++ b/performance/futex_wait.c
@@ -46,6 +46,6 @@ static void futex_wait_test(futex_t *futex, int loops)
 int main (void)
 {
 	printf("FUTEX_WAIT test\n");
-	locktest(futex_wait_test, 100000000);
+	locktest_preset(futex_wait_test, 100000000);
 	return 0;
 }
diff --git a/performance/harness.h b/performance/harness.h
index 7b23bdc..d08d31d 100644
--- a/performance/harness.h
+++ b/performance/harness.h
@@ -4,8 +4,9 @@
 #include <limits.h>
 #include <sys/times.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <pthread.h>
-
+#include <string.h>
 
 struct thread_barrier {
 	futex_t threads;
@@ -64,54 +65,71 @@ static void * locktest_thread(void * dummy)
 	return NULL;
 }
 
-static void locktest(void locktest_function(futex_t * ptr, int loops),
-		     int iterations)
+static int locktest(void locktest_function(futex_t * ptr, int loops),
+			int num_threads, int iterations,
+			struct tms *tms_before, struct tms *tms_after)
+{
+	struct locktest_shared shared;
+	pthread_t thread[num_threads];
+	int i;
+	clock_t before, after;
+
+	barrier_init(&shared.barrier_before, num_threads);
+	barrier_init(&shared.barrier_after, num_threads);
+	shared.locktest_function = locktest_function;
+	shared.loops = iterations / num_threads;
+	shared.futex = 0;
+
+	for (i = 0; i < num_threads; i++)
+		if (pthread_create(thread + i, NULL, locktest_thread,
+				   &shared)) {
+			/* Could not create thread; abort */
+			barrier_unblock(&shared.barrier_before, -1);
+			while (--i >= 0)
+				pthread_join(thread[i], NULL);
+			return -1;
+		}
+	barrier_wait(&shared.barrier_before);
+	before = times(tms_before);
+	barrier_unblock(&shared.barrier_before, 1);
+	barrier_wait(&shared.barrier_after);
+	after = times(tms_after);
+	barrier_unblock(&shared.barrier_after, 1);
+	for (i = 0; i < num_threads; i++)
+		pthread_join(thread[i], NULL);
+	return after - before;
+}
+
+static void locktest_preset(void locktest_function(futex_t * ptr, int loops),
+			    int iterations)
 {
 	int threads[] = { 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 24, 32,
 			  64, 128, 256, 512, 1024, 0 };
 	int t;
+	struct tms before, after;
+	int wall, user, system;
+	double tick;
+
 	for (t = 0; threads[t]; t++) {
-		int num_threads = threads[t];
-		struct locktest_shared shared;
-		pthread_t thread[num_threads];
-		int i;
-		clock_t before, after;
-		struct tms tms_before, tms_after;
-		int wall, user, system;
-		double tick;
-
-		barrier_init(&shared.barrier_before, num_threads);
-		barrier_init(&shared.barrier_after, num_threads);
-		shared.locktest_function = locktest_function;
-		shared.loops = iterations / num_threads;
-		shared.futex = 0;
-
-		for (i = 0; i < num_threads; i++)
-			if (pthread_create(thread + i, NULL, locktest_thread,
-					   &shared)) {
-				/* Could not create thread; abort */
-				barrier_unblock(&shared.barrier_before, -1);
-				while (--i >= 0)
-					pthread_join(thread[i], NULL);
-				return;
-			}
-		barrier_wait(&shared.barrier_before);
-		before = times(&tms_before);
-		barrier_unblock(&shared.barrier_before, 1);
-		barrier_wait(&shared.barrier_after);
-		after = times(&tms_after);
-		wall = after - before;
-		user = tms_after.tms_utime - tms_before.tms_utime;
-		system = tms_after.tms_stime - tms_before.tms_stime;
+		bzero(&before, sizeof(struct tms));
+		bzero(&after, sizeof(struct tms));
+		wall = locktest(locktest_function, threads[t], iterations,
+			 &before, &after);
+
+		if (wall < 0) {
+			fprintf(stderr, "locktest() failed.\n");
+			exit(1);
+		}
+
+		user = after.tms_utime - before.tms_utime;
+		system = after.tms_stime - before.tms_stime;
 		tick = 1.0 / sysconf(_SC_CLK_TCK);
 		printf("%d threads: %.0f Kiter/s "
 		       "(%.2fs user %.2fs system %.2fs wall %.2f cores)\n",
-		       num_threads,
-		       (num_threads * shared.loops) / (wall * tick * 1000),
+		       threads[t],
+		       iterations / (wall * tick * 1000),
 		       user * tick, system * tick, wall * tick,
 		       wall ? (user + system) * 1. / wall : 1.);
-		barrier_unblock(&shared.barrier_after, 1);
-		for (i = 0; i < num_threads; i++)
-			pthread_join(thread[i], NULL);
+
 	}
 }
-- 
1.6.5.2

