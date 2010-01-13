Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672Ab0AMKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0AMKdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664Ab0AMKdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:33:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:34416 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab0AMKdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:33:13 -0500
Date: Wed, 13 Jan 2010 10:30:03 GMT
From: tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
       npiggin@suse.de, drepper@gmail.com, stable@kernel.org,
       tglx@linutronix.de, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       peterz@infradead.org, npiggin@suse.de, drepper@gmail.com,
       stable@kernel.org, hugh.dickins@tiscali.co.uk, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <20100105162633.45A2.A69D9226@jp.fujitsu.com>
References: <20100105162633.45A2.A69D9226@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futexes: Remove rw parameter from get_futex_key()
Message-ID: <tip-7485d0d3758e8e6491a5c9468114e74dc050785d@git.kernel.org>
Git-Commit-ID: 7485d0d3758e8e6491a5c9468114e74dc050785d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:30:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7485d0d3758e8e6491a5c9468114e74dc050785d
Gitweb:     http://git.kernel.org/tip/7485d0d3758e8e6491a5c9468114e74dc050785d
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Tue, 5 Jan 2010 16:32:43 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:17:36 +0100

futexes: Remove rw parameter from get_futex_key()

Currently, futexes have two problem:

A) The current futex code doesn't handle private file mappings properly.

get_futex_key() uses PageAnon() to distinguish file and
anon, which can cause the following bad scenario:

  1) thread-A call futex(private-mapping, FUTEX_WAIT), it
     sleeps on file mapping object.
  2) thread-B writes a variable and it makes it cow.
  3) thread-B calls futex(private-mapping, FUTEX_WAKE), it
     wakes up blocked thread on the anonymous page. (but it's nothing)

B) Current futex code doesn't handle zero page properly.

Read mode get_user_pages() can return zero page, but current
futex code doesn't handle it at all. Then, zero page makes
infinite loop internally.

The solution is to use write mode get_user_page() always for
page lookup. It prevents the lookup of both file page of private
mappings and zero page.

Performance concerns:

Probaly very little, because glibc always initialize variables
for futex before to call futex(). It means glibc users never see
the overhead of this patch.

Compatibility concerns:

This patch has few compatibility issues. After this patch,
FUTEX_WAIT require writable access to futex variables (read-only
mappings makes EFAULT). But practically it's not a problem,
glibc always initalizes variables for futexes explicitly - nobody
uses read-only mappings.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Darren Hart <dvhltc@us.ibm.com>
Cc: <stable@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Ulrich Drepper <drepper@gmail.com>
LKML-Reference: <20100105162633.45A2.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 8e3c3ff..d9b3a22 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -203,8 +203,6 @@ static void drop_futex_key_refs(union futex_key *key)
  * @uaddr:	virtual address of the futex
  * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
  * @key:	address where result is stored.
- * @rw:		mapping needs to be read/write (values: VERIFY_READ,
- * 		VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -216,7 +214,7 @@ static void drop_futex_key_refs(union futex_key *key)
  * lock_page() might sleep, the caller should not hold a spinlock.
  */
 static int
-get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
+get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -239,7 +237,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	 *        but access_ok() should be faster than find_vma()
 	 */
 	if (!fshared) {
-		if (unlikely(!access_ok(rw, uaddr, sizeof(u32))))
+		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
 			return -EFAULT;
 		key->private.mm = mm;
 		key->private.address = address;
@@ -248,7 +246,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 	}
 
 again:
-	err = get_user_pages_fast(address, 1, rw == VERIFY_WRITE, &page);
+	err = get_user_pages_fast(address, 1, 1, &page);
 	if (err < 0)
 		return err;
 
@@ -867,7 +865,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, fshared, &key, VERIFY_READ);
+	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -913,10 +911,10 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 	int ret, op_ret;
 
 retry:
-	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
+	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
+	ret = get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1175,11 +1173,10 @@ retry:
 		pi_state = NULL;
 	}
 
-	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
+	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2,
-			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
+	ret = get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1738,7 +1735,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
 	 */
 retry:
 	q->key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
+	ret = get_futex_key(uaddr, fshared, &q->key);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1904,7 +1901,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	q.requeue_pi_key = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
+	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2023,7 +2020,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, fshared, &key, VERIFY_WRITE);
+	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2215,7 +2212,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	rt_waiter.task = NULL;
 
 	key2 = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
+	ret = get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
