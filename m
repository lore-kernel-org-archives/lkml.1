Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbXDJJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbXDJJtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXDJJtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:49:16 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:37884 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbXDJJtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:49:13 -0400
Date: Tue, 10 Apr 2007 11:21:22 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Peiffer <Pierre.Peiffer@bull.net>
Cc: Dave Jones <davej@redhat.com>, "Ulrich Drepper" <drepper@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
Message-Id: <20070410112122.69701d58.dada1@cosmosbay.com>
In-Reply-To: <20070407151556.4f58cb94.akpm@linux-foundation.org>
References: <20060808070708.GA3931@localhost.localdomain>
	<200608090826.28249.dada1@cosmosbay.com>
	<200608090843.52893.dada1@cosmosbay.com>
	<200703152010.35614.dada1@cosmosbay.com>
	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	<20070405194942.1414c030.dada1@cosmosbay.com>
	<20070407104339.6674336b.dada1@cosmosbay.com>
	<20070407151556.4f58cb94.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 15:15:56 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 7 Apr 2007 10:43:39 +0200 Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> > get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
> > So it is possible a 64bit futex spans two pages of memory...
> > I had to change get_futex_key() prototype to be able to do a correct test.
> > 
> 
> Cold we please have that in a separate patch?  It's logically a part of the
> 64-bit-futex work, is it not?

Yes you probably want this patch to fix 64bit futexes support.

[PATCH] get_futex_key() must check proper alignement for 64bit futexes

get_futex_key() does an alignment check against sizeof(u32) regardless of futex
being 64bits or not.

So it is possible a 64bit futex spans two pages of memory, and some
malicious user code can trigger data corruption.

We must add a 'fsize' parameter to get_futex_key(), telling it the size of the
futex (4 or 8 bytes)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/futex.h |    2 -
 kernel/futex.c        |   78 ++++++++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 28 deletions(-)

--- linux-2.6.21-rc6-mm1/kernel/futex.c
+++ linux-2.6.21-rc6-mm1-ed/kernel/futex.c
@@ -189,19 +189,22 @@ static inline int match_futex(union fute
 		&& key1->both.offset == key2->both.offset);
 }
 
-/*
- * Get parameters which are the keys for a futex.
+/**
+ * get_futex_key - Get parameters which are the keys for a futex.
+ * @uaddr: virtual address of the futex
+ * @size: size of futex (4 or 8)
+ * @key: address where result is stored.
+ *
+ * Returns a negative error code or 0
+ * The key words are stored in *key on success.
  *
  * For shared mappings, it's (page->index, vma->vm_file->f_path.dentry->d_inode,
  * offset_within_page).  For private mappings, it's (uaddr, current->mm).
  * We can usually work out the index without swapping in the page.
  *
- * Returns: 0, or negative error code.
- * The key words are stored in *key on success.
- *
  * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
  */
-int get_futex_key(void __user *uaddr, union futex_key *key)
+int get_futex_key(void __user *uaddr, int size, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -213,7 +216,7 @@ int get_futex_key(void __user *uaddr, un
 	 * The futex address must be "naturally" aligned.
 	 */
 	key->both.offset = address % PAGE_SIZE;
-	if (unlikely((key->both.offset % sizeof(u32)) != 0))
+	if (unlikely((key->both.offset & (size - 1)) != 0))
 		return -EINVAL;
 	address -= key->both.offset;
 
@@ -705,17 +708,18 @@ double_lock_hb(struct futex_hash_bucket 
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
-static int futex_wake(unsigned long __user *uaddr, int nr_wake)
+static int futex_wake(unsigned long __user *uaddr, int futex64, int nr_wake)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	struct plist_head *head;
 	union futex_key key;
 	int ret;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(uaddr, fsize, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -817,6 +821,7 @@ futex_requeue_pi(unsigned long __user *u
 	struct rt_mutex_waiter *waiter, *top_waiter = NULL;
 	struct rt_mutex *lock2 = NULL;
 	int ret, drop_count = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -827,10 +832,10 @@ retry:
 	 */
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1005,14 +1010,15 @@ futex_wake_op(unsigned long __user *uadd
 	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 retryfull:
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1125,14 +1131,15 @@ futex_requeue(unsigned long __user *uadd
 	struct plist_head *head1;
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
  retry:
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1390,9 +1397,15 @@ static int fixup_pi_state_owner(unsigned
 	return ret;
 }
 
+/*
+ * In case we must use restart_block to restart a futex_wait,
+ * we encode in the 'arg3' futex64 capability
+ */
+#define ARG3_FUTEX64 1
+
 static long futex_wait_restart(struct restart_block *restart);
-static int futex_wait(unsigned long __user *uaddr, unsigned long val,
-		      ktime_t *abs_time, int futex64)
+static int futex_wait(unsigned long __user *uaddr, int futex64,
+		      unsigned long val, ktime_t *abs_time)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1402,12 +1415,13 @@ static int futex_wait(unsigned long __us
 	int ret;
 	struct hrtimer_sleeper t, *to = NULL;
 	int rem = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	q.pi_state = NULL;
  retry:
 	down_read(&curr->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, fsize, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1597,7 +1611,11 @@ static int futex_wait(unsigned long __us
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = val;
 		restart->arg2 = (unsigned long)abs_time;
-		restart->arg3 = (unsigned long)futex64;
+		restart->arg3 = 0;
+#ifdef CONFIG_64BIT
+		if (futex64)
+			restart->arg3 |= ARG3_FUTEX64;
+#endif
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1615,10 +1633,14 @@ static long futex_wait_restart(struct re
 	unsigned long __user *uaddr = (unsigned long __user *)restart->arg0;
 	unsigned long val = restart->arg1;
 	ktime_t *abs_time = (ktime_t *)restart->arg2;
-	int futex64 = (int)restart->arg3;
+	int futex64 = 0;
 
+#ifdef CONFIG_64BIT
+	if (restart->arg3 & ARG3_FUTEX64)
+		futex64 = 1;
+#endif
 	restart->fn = do_no_restart_syscall;
-	return (long)futex_wait(uaddr, val, abs_time, futex64);
+	return (long)futex_wait(uaddr, futex64, val, abs_time);
 }
 
 
@@ -1682,6 +1704,7 @@ static int futex_lock_pi(unsigned long _
 	unsigned long uval, newval, curval;
 	struct futex_q q;
 	int ret, lock_held, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1697,7 +1720,7 @@ static int futex_lock_pi(unsigned long _
  retry:
 	down_read(&curr->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, fsize, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1907,6 +1930,7 @@ static int futex_unlock_pi(unsigned long
 	struct plist_head *head;
 	union futex_key key;
 	int ret, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 retry:
 	if (futex_get_user(&uval, uaddr, futex64))
@@ -1921,7 +1945,7 @@ retry:
 	 */
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(uaddr, fsize, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2094,7 +2118,7 @@ static int futex_fd(u32 __user *uaddr, i
 	q->pi_state = NULL;
 
 	down_read(&current->mm->mmap_sem);
-	err = get_futex_key(uaddr, &q->key);
+	err = get_futex_key(uaddr, sizeof(u32), &q->key);
 
 	if (unlikely(err != 0)) {
 		up_read(&current->mm->mmap_sem);
@@ -2238,7 +2262,7 @@ retry:
 		 */
 		if (!pi) {
 			if (uval & FUTEX_WAITERS)
-				futex_wake((unsigned long __user *)uaddr, 1);
+				futex_wake((unsigned long __user *)uaddr, 0, 1);
 		}
 	}
 	return 0;
@@ -2329,10 +2353,10 @@ long do_futex(unsigned long __user *uadd
 
 	switch (op) {
 	case FUTEX_WAIT:
-		ret = futex_wait(uaddr, val, timeout, fut64);
+		ret = futex_wait(uaddr, fut64, val, timeout);
 		break;
 	case FUTEX_WAKE:
-		ret = futex_wake(uaddr, val);
+		ret = futex_wake(uaddr, fut64, val);
 		break;
 	case FUTEX_FD:
 		if (fut64)
--- linux-2.6.21-rc6-mm1/include/linux/futex.h
+++ linux-2.6.21-rc6-mm1-ed/include/linux/futex.h
@@ -135,7 +135,7 @@ union futex_key {
 		int offset;
 	} both;
 };
-int get_futex_key(void __user *uaddr, union futex_key *key);
+int get_futex_key(void __user *uaddr, int size, union futex_key *key);
 void get_futex_key_refs(union futex_key *key);
 void drop_futex_key_refs(union futex_key *key);
 

