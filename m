Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYL2XuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYL2XuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYL2Xt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:49:56 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:34918 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYL2Xtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:49:55 -0500
Message-ID: <e17d46420812291549k6aa27e03qa1bee8ee0b2c2775@mail.gmail.com>
Date: Mon, 29 Dec 2008 15:49:53 -0800
From: "Darren Hart" <darren@dvhart.com>
To: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] futex: make futex_(get|put)_key() calls symmetric
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Rusty Russell" <rusty@au1.ibm.com>, "Darren Hart" <dvhltc@us.ibm.com>
In-Reply-To: <20081229185355.10342.85717.stgit@Aeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081229185238.10342.75651.stgit@Aeon>
	 <20081229185355.10342.85717.stgit@Aeon>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 10:53 AM, Darren Hart <dvhltc@us.ibm.com> wrote:
> Impact: cleanup
>
> This patch makes the calls to futex_get_key_refs() and futex_drop_key_refs()
> explicitly symmetric by only "putting" keys we successfully "got".  Also
> cleanup a couple return points that didn't "put" after a successful "get".
>
> Build and boot tested on an x86_64 system.

Eeek.  Apologies, I thought I had built/booted this one, but a test
for another patch later today shows I must not have as I am missing a
label and the build failed.  Updated patch below, this one DOES build
and boot.  Apologies!


futex: make futex_(get|put)_key() calls symmetric

From: Darren Hart <dvhltc@us.ibm.com>

Impact: cleanup

This patch makes the calls to futex_get_key_refs() and futex_drop_key_refs()
explicitly symmetric by only "putting" keys we successfully "got".  Also
cleanup a couple return points that didn't "put" after a successful "get".

Build and boot tested on an x86_64 system.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@au1.ibm.com>
---

 kernel/futex.c |   67 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 31 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index b4f87ba..c5ac55c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -723,8 +723,8 @@ static int futex_wake(u32 __user *uaddr, int
fshared, int nr_wake, u32 bitset)
 	}

 	spin_unlock(&hb->lock);
-out:
 	put_futex_key(fshared, &key);
+out:
 	return ret;
 }

@@ -748,7 +748,7 @@ retryfull:
 		goto out;
 	ret = get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret != 0))
-		goto out;
+		goto out_put_key1;

 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
@@ -770,12 +770,12 @@ retry:
 		 * but we might get them from range checking
 		 */
 		ret = op_ret;
-		goto out;
+		goto out_put_keys;
 #endif

 		if (unlikely(op_ret != -EFAULT)) {
 			ret = op_ret;
-			goto out;
+			goto out_put_keys;
 		}

 		/*
@@ -789,7 +789,7 @@ retry:
 			ret = futex_handle_fault((unsigned long)uaddr2,
 						 attempt);
 			if (ret)
-				goto out;
+				goto out_put_keys;
 			goto retry;
 		}

@@ -827,10 +827,11 @@ retry:
 	spin_unlock(&hb1->lock);
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
-out:
+out_put_keys:
 	put_futex_key(fshared, &key2);
+out_put_key1:
 	put_futex_key(fshared, &key1);
-
+out:
 	return ret;
 }

@@ -847,13 +848,13 @@ static int futex_requeue(u32 __user *uaddr1, int
fshared, u32 __user *uaddr2,
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;

- retry:
+retry:
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
 	ret = get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret != 0))
-		goto out;
+		goto out_put_key1;

 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
@@ -875,7 +876,7 @@ static int futex_requeue(u32 __user *uaddr1, int
fshared, u32 __user *uaddr2,
 			if (!ret)
 				goto retry;

-			return ret;
+			goto out_put_keys;
 		}
 		if (curval != *cmpval) {
 			ret = -EAGAIN;
@@ -920,9 +921,11 @@ out_unlock:
 	while (--drop_count >= 0)
 		drop_futex_key_refs(&key1);

-out:
+out_put_keys:
 	put_futex_key(fshared, &key2);
+out_put_key1:
 	put_futex_key(fshared, &key1);
+out:
 	return ret;
 }

@@ -983,7 +986,7 @@ static int unqueue_me(struct futex_q *q)
 	int ret = 0;

 	/* In the common case we don't take the spinlock, which is nice. */
- retry:
+retry:
 	lock_ptr = q->lock_ptr;
 	barrier();
 	if (lock_ptr != NULL) {
@@ -1165,11 +1168,11 @@ static int futex_wait(u32 __user *uaddr, int fshared,

 	q.pi_state = NULL;
 	q.bitset = bitset;
- retry:
+retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
-		goto out_release_sem;
+		goto out;

 	hb = queue_lock(&q);

@@ -1197,6 +1200,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,

 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
+		put_futex_key(fshared, &q.key);

 		ret = get_user(uval, uaddr);

@@ -1206,7 +1210,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	}
 	ret = -EWOULDBLOCK;
 	if (uval != val)
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;

 	/* Only actually queue if *uaddr contained val.  */
 	queue_me(&q, hb);
@@ -1298,11 +1302,11 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 		return -ERESTART_RESTARTBLOCK;
 	}

- out_unlock_release_sem:
+out_unlock_put_key:
 	queue_unlock(&q, hb);
-
- out_release_sem:
 	put_futex_key(fshared, &q.key);
+
+out:
 	return ret;
 }

@@ -1351,16 +1355,16 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	}

 	q.pi_state = NULL;
- retry:
+retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
-		goto out_release_sem;
+		goto out;

- retry_unlocked:
+retry_unlocked:
 	hb = queue_lock(&q);

- retry_locked:
+retry_locked:
 	ret = lock_taken = 0;

 	/*
@@ -1381,14 +1385,14 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	 */
 	if (unlikely((curval & FUTEX_TID_MASK) == task_pid_vnr(current))) {
 		ret = -EDEADLK;
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;
 	}

 	/*
 	 * Surprise - we got the lock. Just return to userspace:
 	 */
 	if (unlikely(!curval))
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;

 	uval = curval;

@@ -1424,7 +1428,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	 * We took the lock due to owner died take over.
 	 */
 	if (unlikely(lock_taken))
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;

 	/*
 	 * We dont have the lock. Look up the PI state (or create it if
@@ -1463,7 +1467,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 				goto retry_locked;
 			}
 		default:
-			goto out_unlock_release_sem;
+			goto out_unlock_put_key;
 		}
 	}

@@ -1554,16 +1558,17 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 		destroy_hrtimer_on_stack(&to->timer);
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;

- out_unlock_release_sem:
+out_unlock_put_key:
 	queue_unlock(&q, hb);

- out_release_sem:
+out_put_key:
 	put_futex_key(fshared, &q.key);
+out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
 	return ret;

- uaddr_faulted:
+uaddr_faulted:
 	/*
 	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
 	 * atomically.  Therefore, if we continue to fault after get_user()
@@ -1576,7 +1581,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	if (attempt++) {
 		ret = futex_handle_fault((unsigned long)uaddr, attempt);
 		if (ret)
-			goto out_release_sem;
+			goto out_put_key;
 		goto retry_unlocked;
 	}

@@ -1668,9 +1673,9 @@ retry_unlocked:

 out_unlock:
 	spin_unlock(&hb->lock);
-out:
 	put_futex_key(fshared, &key);

+out:
 	return ret;

 pi_faulted:
