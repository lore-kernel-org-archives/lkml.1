Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094Ab0AEHct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0AEHct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483Ab0AEHcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:32:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48204 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0AEHcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:32:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [PATCH v2] futex: remove rw parameter from get_futex_key()
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <alpine.LSU.2.00.0912301437420.3369@sister.anvils>
References: <20091225083305.AA78.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.0912301437420.3369@sister.anvils>
Message-Id: <20100105162633.45A2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  5 Jan 2010 16:32:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

sorry very delayed responce, I've review futex code again.


> > Hm. probably we need to discuss more.
> > 
> > Firstly, if we assume current glibc implimentation, you are right,
> > we can assume userland always initialize the page explicitly before using
> > futex. then we never seen zero page in futex.
> > 
> > but, I don't think futex itself assume it now. at least man page
> > doesn't describe such limilation. so, if you prefer bail and man fix,
> > I'm acceptable maybe.
> 
> Here's another worry with the current futex implementation,
> which might help me to decide which way to jump on the ZERO_PAGE.
> 
> Originally, a futex on a MAP_PRIVATE (!VM_MAYSHARE) area was necessarily
> FUT_OFF_MMSHARED.  Nowadays, with the get_user_pages_fast implementation,
> we have no idea whether the vma is VM_MAYSHARE or not.  So if a futex is
> placed in a private area backed by a file, then it could be regarded as
> FUT_OFF_INODE at futex_wait() time, but FUT_OFF_MMSHARED at futex_wake()
> time.

very true!


> Perhaps that's no problem at all, it's a long time since I was involved
> with futexes, I think you and Peter will grasp the consequences quicker
> than I shall.
> 
> But it seems no more improbable than the ZERO_PAGE case: some app
> might place its futexes in the .data section of the executable,
> which is a private mapping of the executable file.
> 
> If this case is also an issue, then perhaps we just need to update
> the man page to say that whatever is responsible for initializing a
> futex does need to write to it (or the page it's in) before it's used,
> otherwise behaviour is undefined.  (But we should then use the -EFAULT
> patch above, we'd all prefer an error to busylooping.)

I have a question. Why can't we use write mode get_user_pages_fast()?
I mean glibc always mekes write access before calling futex. it mean
write mode get_user_pages() doesn't mekes cow on practical usage.

Following patch is implemented such policy. What do you think?




>From c3e2dfdff84b9b720e646fd6dd3c38fff293c7e6 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 5 Jan 2010 11:33:00 +0900
Subject: [PATCH] futex: remove rw parameter from get_futex_key()

Currently, futex have two problem.

A) current futex doesn't handle private file mappings properly.

get_futex_key() use PageAnon() to distinguish file and anon. it can
makes following bad scenario.

  1) thread-A call futex(private-mapping, FUTEX_WAIT). it makes to
     sleep on file mapping object.
  2) thread-B write a variable and it makes cow.
  3) thread-B call futex(private-mapping, FUTEX_WAKE). it wake up
     sleeped thread on the anonymous page. (but it's nothing)

following testcase reproduce this issue.

actual result)
       FUTEX_WAIT thread never wake up.

expect result)
       FUTEX_WAIT thread wake up by FUTEX_WAKE.

--------------------------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <syscall.h>
 #include <unistd.h>
 #include <errno.h>
 #include <linux/futex.h>
 #include <pthread.h>

char pad[4096] = {1};
int val = 1;
char pad2[4096] = {1};

void * futex_wait(void *arg)
{
	int ret;

	fprintf(stderr, "futex wait\n");
	ret = syscall( SYS_futex, &val, FUTEX_WAIT, 1, NULL, NULL, NULL);
	if (ret != 0 && errno != EWOULDBLOCK) {
		perror("futex error.\n");
		exit(1);
	}
	fprintf(stderr, "futex_wait: ret = %d, errno = %d\n", ret, errno);

	return NULL;
}

int main(int argc, char **argv)
{
	pthread_t thr;
	int ret;

	ret = pthread_create(&thr, NULL, futex_wait, NULL);
	if (ret < 0) {
		fprintf(stderr, "pthread_create error\n");
		exit(1);
	}

	sleep(10);

	fprintf(stderr, "futex wake\n");
	val = 2;
	ret = syscall( SYS_futex, &val, FUTEX_WAKE, 1, NULL, NULL, NULL);
	fprintf(stderr, "futex_wake: ret = %d, errno = %d\n", ret, errno);

	fprintf(stderr, "join\n");
	pthread_join(thr, NULL);

	return 0;
}
--------------------------------------------------------------------

B) current futex doesn't handle zero page properly.

read mode get_user_pages() can return zero page. but current futex code doesn't
handle it at all. Then, zero page makes infinite loop internally.

following testcase can reproduce this issue.

actual result)
	FUTEX_WAIT never return and waste cpu time 100%.

expected result)
	FUTEX_WAIT return immediately.

------------------------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <syscall.h>
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <errno.h>
 #include <linux/futex.h>
 #include <pthread.h>

int main(int argc, char **argv)
{
	long page_size;
	int ret;
	void *buf;

	page_size = sysconf(_SC_PAGESIZE);

	buf = mmap(NULL, page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
	if (buf == (void *)-1) {
		perror("mmap error.\n");
		exit(1);
	}

	fprintf(stderr, "futex wait\n");
	ret = syscall( SYS_futex, buf, FUTEX_WAIT, 1, NULL, NULL, NULL);
	if (ret != 0 && errno != EWOULDBLOCK) {
		perror("futex error.\n");
		exit(1);
	}
	fprintf(stderr, "futex_wait: ret = %d, errno = %d\n", ret, errno);

	return 0;
}
------------------------------------------------------------------

The solution is to use write mode get_user_page() always for page lookup.
It prevent to lookup both file page of private mappings and zero page.

performance concern:

Probaly very little. because glibc always initialize variables for futex
before to call futex(). It mean glibc user never seen the overhead of this
patch.

compatibility concern:

This patch have few compatibility break. After this patch, FUTEX_WAIT require
writable access to futex variables (read-only mappings makes EFAULT).
But practically it's no problem. again glibc always initalize variables for futex
explicitly. nobody use read-only mappings.

Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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
 
-- 
1.6.5.2




