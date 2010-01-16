Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0APRBo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890Ab0APRBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:01:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0APRBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:01:43 -0500
Date: Sat, 16 Jan 2010 18:01:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] futex fix
Message-ID: <20100116170133.GA13055@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
KOSAKI Motohiro (1):
      futexes: Remove rw parameter from get_futex_key()


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
 
