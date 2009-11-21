Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZKUCgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZKUCgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 21:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZKUCgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 21:36:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:15432 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbZKUCgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 21:36:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=WBalIompNGtGhwY7iWosPYmQFjP67StqXhm725N/oZspySGzjJHL6iHSlBL5kcGBn
	dVhL3QJrJ8fjjo6smgvrw==
Date: Fri, 20 Nov 2009 18:36:36 -0800
From: Michel Lespinasse <walken@google.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091121023636.GA13763@google.com>
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu> <1258448121.7816.29.camel@laptop> <4B02CC46.4020506@us.ibm.com> <20091118221331.GA1300@google.com> <4B057A7C.80300@us.ibm.com> <8d20b11a0911191325u49624854u6132594f13b0718c@mail.gmail.com> <4B05D124.6020808@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B05D124.6020808@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 03:13:40PM -0800, Darren Hart wrote:
>> This is not supposed to require any particular number of CPUs, so I am  
>> concerned about the hang.
>>
>> How reproducible is this for you ? Do you know if the original test code 
>> I sent hanged in the same way ?
>
> I'm basically 2 for 2 on each version of the futex_wait_test. I haven't  
> seen it run to completion yet. This is on a stock Ubuntu kernel  
> (2.6.31-15-generic) on my core duo laptop (32 bit).

As we found out in private email conversation before, this was due to hitting
resource allocation limits while creating the threads. The patch below
(relative to your set_wait branch) should fix this.

Patch summary:
* Added FUTEX_WAIT_BITSET/FUTEX_WAKE_BITSET definitions - I do have
  old enough headers that this was a problem now that you use
  inline functions in futextest.h
* Changed futex_cmpxchg return type to int - I dont really like this change,
  but otherwise gcc complains about the volatile keyword being ignored in
  the returned function type. Feel free to ignore this if you like.
* futex_setwait_lock: changed to a more compact & faster implementation
  (same algorithm but wrote the loop in a different way)
* test harness: look at pthread_create return code; if thread creation fails
  then join with existing threads and exit. Also moved the before/after
  barrier logic into the test harness rather than the futex_[set]wait_test
  functions.

Hope this helps.

Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/include/futextest.h b/include/futextest.h
index 835867e..77d6a72 100644
--- a/include/futextest.h
+++ b/include/futextest.h
@@ -39,6 +39,12 @@ typedef volatile u_int32_t futex_t;
 #define FUTEX_INITIALIZER 0
 
 /* Define the newer op codes if the system header file is not up to date. */
+#ifndef FUTEX_WAIT_BITSET
+#define FUTEX_WAIT_BITSET		9
+#endif
+#ifndef FUTEX_WAKE_BITSET
+#define FUTEX_WAKE_BITSET		10
+#endif
 #ifndef FUTEX_WAIT_REQUEUE_PI
 #define FUTEX_WAIT_REQUEUE_PI		11
 #endif
@@ -239,7 +245,7 @@ futex_set_wait(futex_t *uaddr, futex_t val, u_int32_t setval,
  * Implement cmpxchg using gcc atomic builtins.
  * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
  */
-static inline futex_t
+static inline int
 futex_cmpxchg(futex_t *uaddr, u_int32_t oldval, u_int32_t newval)
 {
 	return __sync_val_compare_and_swap(uaddr, oldval, newval);
diff --git a/performance/futex_set_wait.c b/performance/futex_set_wait.c
index 4f89e40..d804778 100644
--- a/performance/futex_set_wait.c
+++ b/performance/futex_set_wait.c
@@ -10,23 +10,14 @@
 
 static inline void futex_setwait_lock(futex_t *futex)
 {
-	int status = *futex;
-	if (status == 0)
-		status = futex_cmpxchg(futex, 0, 1);
-	if (status != 0) {
-		int desired_status = 1;
-		do {
-			if (futex_set_wait(futex, 1, 2, NULL, ~0,
-					   FUTEX_PRIVATE_FLAG) == 0) {
-				/* We absorbed a wakeup; so make sure to
-				   unblock next thread */
-				desired_status = 2;
-			}
-			status = *futex;
-			if (status == 0)
-				status = futex_cmpxchg(futex, 0,
-						       desired_status);
-		} while (status != 0);
+	int desired_status = 1;
+	while (*futex != 0 || futex_cmpxchg(futex, 0, desired_status) != 0) {
+		if (futex_set_wait(futex, 1, 2, NULL, ~0,
+				   FUTEX_PRIVATE_FLAG) == 0) {
+			/* We absorbed a wakeup; so make sure to
+			   unblock next thread */
+			desired_status = 2;
+		}
 	}
 }
 
@@ -41,17 +32,12 @@ static inline void futex_cmpxchg_unlock(futex_t *futex)
 	}
 }
 
-static void * futex_setwait_test(void * dummy)
+static void futex_setwait_test(futex_t *futex, int loops)
 {
-	struct locktest_shared * shared = dummy;
-	int i = shared->loops;
-	barrier_sync(&shared->barrier_before);
-	while (i--) {
-		futex_setwait_lock(&shared->futex);
-		futex_cmpxchg_unlock(&shared->futex);
+	while (loops--) {
+		futex_setwait_lock(futex);
+		futex_cmpxchg_unlock(futex);
 	}
-	barrier_sync(&shared->barrier_after);
-	return NULL;
 }
 
 static int futex_setwait_supported(void)
diff --git a/performance/futex_wait.c b/performance/futex_wait.c
index 88ce2f2..bcbca77 100644
--- a/performance/futex_wait.c
+++ b/performance/futex_wait.c
@@ -35,17 +35,12 @@ static inline void futex_cmpxchg_unlock(futex_t *futex)
 	}
 }
 
-static void * futex_wait_test(void * dummy)
+static void futex_wait_test(futex_t *futex, int loops)
 {
-	struct locktest_shared * shared = dummy;
-	int i = shared->loops;
-	barrier_sync(&shared->barrier_before);
-	while (i--) {
-		futex_wait_lock(&shared->futex);
-		futex_cmpxchg_unlock(&shared->futex);
+	while (loops--) {
+		futex_wait_lock(futex);
+		futex_cmpxchg_unlock(futex);
 	}
-	barrier_sync(&shared->barrier_after);
-	return NULL;
 }
 
 int main (void)
diff --git a/performance/harness.h b/performance/harness.h
index 9d74d17..d0dd392 100644
--- a/performance/harness.h
+++ b/performance/harness.h
@@ -15,13 +15,14 @@ struct thread_barrier {
 struct locktest_shared {
 	struct thread_barrier barrier_before;
 	struct thread_barrier barrier_after;
+	void (* locktest_function)(futex_t * ptr, int loops);
 	int loops;
 	futex_t futex;
 };
 
 static inline void decrement(futex_t *ptr)
 {
-	__sync_fetch_and_add(ptr, -1);
+	__sync_sub_and_fetch(ptr, 1);
 }
 
 /* Called by main thread to initialize barrier */
@@ -32,13 +33,14 @@ static void barrier_init(struct thread_barrier *barrier, int threads)
 }
 
 /* Called by worker threads to synchronize with main thread */
-static void barrier_sync(struct thread_barrier *barrier)
+static int barrier_sync(struct thread_barrier *barrier)
 {
 	decrement(&barrier->threads);
 	if (barrier->threads == 0)
 		futex_wake(&barrier->threads, 1, FUTEX_PRIVATE_FLAG);
 	while (barrier->unblock == 0)
 		futex_wait(&barrier->unblock, 0, NULL, FUTEX_PRIVATE_FLAG);
+	return barrier->unblock;
 }
 
 /* Called by main thread to wait for all workers to reach sync point */
@@ -51,14 +53,24 @@ static void barrier_wait(struct thread_barrier *barrier)
 }
 
 /* Called by main thread to unblock worker threads from their sync point */
-static void barrier_unblock(struct thread_barrier *barrier)
+static void barrier_unblock(struct thread_barrier *barrier, int value)
 {
-	barrier->unblock = 1;
+	barrier->unblock = value;
 	futex_wake(&barrier->unblock, INT_MAX, FUTEX_PRIVATE_FLAG);
 }
 
+static void * locktest_thread(void * dummy)
+{
+	struct locktest_shared * shared = dummy;
+	if (barrier_sync(&shared->barrier_before) > 0) {
+		shared->locktest_function(&shared->futex, shared->loops);
+		barrier_sync(&shared->barrier_after);
+	}
+	return NULL;
+}
 
-static void locktest(void * thread_function(void *), int iterations)
+static void locktest(void locktest_function(futex_t * ptr, int loops),
+		     int iterations)
 {
 	int threads[] = { 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 24, 32,
 			  64, 128, 256, 512, 1024, 0 };
@@ -75,15 +87,22 @@ static void locktest(void * thread_function(void *), int iterations)
 
 		barrier_init(&shared.barrier_before, num_threads);
 		barrier_init(&shared.barrier_after, num_threads);
+		shared.locktest_function = locktest_function;
 		shared.loops = iterations / num_threads;
 		shared.futex = 0;
 
 		for (i = 0; i < num_threads; i++)
-			pthread_create(thread + i, NULL, thread_function,
-				       &shared);
+			if (pthread_create(thread + i, NULL, locktest_thread,
+					   &shared)) {
+				/* Could not create thread; abort */
+				barrier_unblock(&shared.barrier_before, -1);
+				while (--i >= 0)
+					pthread_join(thread[i], NULL);
+				return;
+			}
 		barrier_wait(&shared.barrier_before);
 		before = times(&tms_before);
-		barrier_unblock(&shared.barrier_before);
+		barrier_unblock(&shared.barrier_before, 1);
 		barrier_wait(&shared.barrier_after);
 		after = times(&tms_after);
 		wall = after - before;
@@ -96,7 +115,7 @@ static void locktest(void * thread_function(void *), int iterations)
 		       (num_threads * shared.loops) / (wall * tick * 1000),
 		       user * tick, system * tick, wall * tick,
 		       wall ? (user + system) * 1. / wall : 1.);
-		barrier_unblock(&shared.barrier_after);
+		barrier_unblock(&shared.barrier_after, 1);
 		for (i = 0; i < num_threads; i++)
 			pthread_join(thread[i], NULL);
 	}


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
