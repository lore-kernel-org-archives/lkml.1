Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbXCOTNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbXCOTNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbXCOTNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:13:17 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42454 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbXCOTNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:13:13 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/3] FUTEX : introduce PROCESS_PRIVATE semantic
Date: Thu, 15 Mar 2007 20:13:16 +0100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com>
In-Reply-To: <200608090843.52893.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NrZ+FL/0qYhw6dF"
Message-Id: <200703152013.17178.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_NrZ+FL/0qYhw6dF
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH 1/3] FUTEX : introduce PROCESS_PRIVATE semantic

This first patch introduces XXX_PRIVATE futexes operations.

When a process uses a XXX_PRIVATE futex primitive, kernel can avoid
to take a read lock on mmap_sem, to find the vma that contains the futex,
to learn if it is associated to an inode (shared) or the mm (private to 
process)

We also avoid taking a reference on the found inode or the mm.

Even if mmap_sem is a rw_semaphore, up_read()/down_read() are doing atomic
 ops on mmap_sem, dirtying cache line :
        - lot of cache line ping pongs on SMP configurations.

 mmap_sem is also extensively used by mm code (page faults, mmap()/munmap())
 Highly threaded processes might suffer from mmap_sem contention.

 mmap_sem is also used by oprofile code. Enabling oprofile hurts threaded
programs because of contention on the mmap_sem cache line.

- Using an atomic_inc()/atomic_dec() on inode ref counter or mm ref counter:
 It's also a cache line ping pong on SMP. It also increases mmap_sem hold time
 because of cache misses.

This first patch is possible because, for one process using 
PTHREAD_PROCESS_PRIVATE futexes, we only need to distinguish futexes by their 
virtual address, no matter the underlying mm storage is. The case of multiple 
virtual addresses mapped on the same physical address is just insane : "Dont 
do it on PROCESS_PRIVATE futexes, please ?"

If glibc wants to exploit this new infrastructure, it should use new
_PRIVATE futex subcommands for PTHREAD_PROCESS_PRIVATE futexes. And
be prepared to fallback on old subcommands for old kernels. Using one
global variable with the FUTEX_PRIVATE_FLAG or 0 value should be OK, so that 
only one syscall might fail.

Compatibility with old applications is preserved, they still hit the
scalability problems, but new applications can fly :)

Note : SHARED futexes can be used by old binaries *and* new binaries,
because both binaries will use the old subcommands.

Note : Vast majority of futexes should be using PROCESS_PRIVATE semantic,
as this is the default semantic. Almost all applications should benefit
of this changes (new kernel and updated libc)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/futex.h |   12 +
 kernel/futex.c        |  273 +++++++++++++++++++++++++---------------
 2 files changed, 188 insertions(+), 97 deletions(-)

--Boundary-00=_NrZ+FL/0qYhw6dF
Content-Type: text/plain;
  charset="utf-8";
  name="futex_p1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="futex_p1.patch"

--- linux-2.6.21-rc3/kernel/futex.c	2007-03-13 13:22:31.000000000 +0100
+++ linux-2.6.21-rc3-ed/kernel/futex.c	2007-03-15 18:30:15.000000000 +0100
@@ -16,6 +16,9 @@
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *  Copyright (C) 2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
  *
+ *  Introduction of PRIVATE futexes by Eric Dumazet
+ *  Copyright (C) 2007 Eric Dumazet <dada1@cosmosbay.com>
+ *
  *  Thanks to Ben LaHaise for yelling "hashed waitqueues" loudly
  *  enough at me, Linus for the original (flawed) idea, Matthew
  *  Kirkwood for proof-of-concept implementation.
@@ -60,8 +63,18 @@
  * Don't rearrange members without looking at hash_futex().
  *
  * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
- * We set bit 0 to indicate if it's an inode-based key.
+ * We use the two low order bits of offset to tell what is the kind of key :
+ *  00 : Private process futex (PTHREAD_PROCESS_PRIVATE)
+ *       (no reference on an inode or mm)
+ *  01 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *	mapped on a file (reference on the underlying inode)
+ *  10 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *       (but private mapping on an mm, and reference taken on it)
  */
+
+#define OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
+#define OFF_MMSHARED 2 /* We set bit 1 if key has a reference on mm */
+
 union futex_key {
 	struct {
 		unsigned long pgoff;
@@ -129,9 +142,6 @@ struct futex_q {
 	struct task_struct *task;
 };
 
-/*
- * Split the global futex_lock into every hash list lock.
- */
 struct futex_hash_bucket {
        spinlock_t              lock;
        struct list_head       chain;
@@ -175,7 +185,8 @@ static inline int match_futex(union fute
  *
  * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
  */
-static int get_futex_key(u32 __user *uaddr, union futex_key *key)
+static int get_futex_key(u32 __user *uaddr, union futex_key *key,
+		struct rw_semaphore *shared)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -192,6 +203,22 @@ static int get_futex_key(u32 __user *uad
 	address -= key->both.offset;
 
 	/*
+	 * PROCESS_PRIVATE futexes are fast.
+	 * As the mm cannot disappear under us and the 'key' only needs
+	 * virtual address, we dont even have to find the underlying vma.
+	 * Note : We do have to check 'address' is a valid user address,
+	 *        but access_ok() should be faster than find_vma()
+	 * Note : At this point, address points to the start of page,
+	 *        not the real futex address, this is ok.
+	 */
+	if (!shared) {
+		if (!access_ok(VERIFY_WRITE, address, sizeof(int)))
+			return -EFAULT;
+		key->private.mm = mm;
+		key->private.address = address;
+		return 0;
+	}
+	/*
 	 * The futex is hashed differently depending on whether
 	 * it's in a shared or private mapping.  So check vma first.
 	 */
@@ -215,6 +242,7 @@ static int get_futex_key(u32 __user *uad
 	 * mappings of _writable_ handles.
 	 */
 	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
+		key->both.offset += OFF_MMSHARED; /* reference taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
 		return 0;
@@ -224,7 +252,7 @@ static int get_futex_key(u32 __user *uad
 	 * Linear file mappings are also simple.
 	 */
 	key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
-	key->both.offset++; /* Bit 0 of offset indicates inode-based key. */
+	key->both.offset += OFF_INODE; /* inode-based key. */
 	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
 		key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
 				     + vma->vm_pgoff);
@@ -251,16 +279,21 @@ static int get_futex_key(u32 __user *uad
  * Take a reference to the resource addressed by a key.
  * Can be called while holding spinlocks.
  *
- * NOTE: mmap_sem MUST be held between get_futex_key() and calling this
- * function, if it is called at all.  mmap_sem keeps key->shared.inode valid.
+ * NOTE: for SHARED futexes, mmap_sem MUST be held between get_futex_key()
+ * and calling this function, if it is called at all.  mmap_sem keeps 
+ * key->shared.inode valid.
  */
 static inline void get_key_refs(union futex_key *key)
 {
-	if (key->both.ptr != 0) {
-		if (key->both.offset & 1)
+	switch (key->both.offset & (OFF_INODE|OFF_MMSHARED)) {
+		case OFF_INODE:
 			atomic_inc(&key->shared.inode->i_count);
-		else
+			break;
+		case OFF_MMSHARED:
 			atomic_inc(&key->private.mm->mm_count);
+			break;
+		default:
+			break;
 	}
 }
 
@@ -270,11 +303,15 @@ static inline void get_key_refs(union fu
  */
 static void drop_key_refs(union futex_key *key)
 {
-	if (key->both.ptr != 0) {
-		if (key->both.offset & 1)
+	switch (key->both.offset & (OFF_INODE|OFF_MMSHARED)) {
+		case OFF_INODE:
 			iput(key->shared.inode);
-		else
+			break;
+		case OFF_MMSHARED:
 			mmdrop(key->private.mm);
+			break;
+		default:
+			break;
 	}
 }
 
@@ -286,32 +323,44 @@ static inline int get_futex_value_locked
 	ret = __copy_from_user_inatomic(dest, from, sizeof(u32));
 	pagefault_enable();
 
-	return ret ? -EFAULT : 0;
+	return ret;
 }
 
 /*
- * Fault handling. Called with current->mm->mmap_sem held.
+ * Fault handling.
+ * if shared is non NULL, current->mm->mmap_sem is held
  */
-static int futex_handle_fault(unsigned long address, int attempt)
+static int futex_handle_fault(unsigned long address, int attempt,
+	struct rw_semaphore *shared)
 {
 	struct vm_area_struct * vma;
 	struct mm_struct *mm = current->mm;
+	int ret = 0;
 
-	if (attempt > 2 || !(vma = find_vma(mm, address)) ||
-	    vma->vm_start > address || !(vma->vm_flags & VM_WRITE))
+	if (attempt > 2)
 		return -EFAULT;
 
-	switch (handle_mm_fault(mm, vma, address, 1)) {
-	case VM_FAULT_MINOR:
-		current->min_flt++;
-		break;
-	case VM_FAULT_MAJOR:
-		current->maj_flt++;
-		break;
-	default:
-		return -EFAULT;
-	}
-	return 0;
+	if (!shared)
+		down_read(&mm->mmap_sem);
+
+	if (!(vma = find_vma(mm, address)) ||
+	    vma->vm_start > address || !(vma->vm_flags & VM_WRITE))
+		ret = -EFAULT;
+
+	else
+		switch (handle_mm_fault(mm, vma, address, 1)) {
+		case VM_FAULT_MINOR:
+			current->min_flt++;
+			break;
+		case VM_FAULT_MAJOR:
+			current->maj_flt++;
+			break;
+		default:
+			ret = -EFAULT;
+		}
+	if (!shared)
+		up_read(&current->mm->mmap_sem);
+	return ret;
 }
 
 /*
@@ -649,7 +698,8 @@ double_lock_hb(struct futex_hash_bucket 
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
-static int futex_wake(u32 __user *uaddr, int nr_wake)
+static int futex_wake(u32 __user *uaddr, int nr_wake,
+	struct rw_semaphore *shared)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -657,9 +707,10 @@ static int futex_wake(u32 __user *uaddr,
 	union futex_key key;
 	int ret;
 
-	down_read(&current->mm->mmap_sem);
+	if (shared)
+		down_read(shared);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(uaddr, &key, shared);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -681,7 +732,8 @@ static int futex_wake(u32 __user *uaddr,
 
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 	return ret;
 }
 
@@ -691,7 +743,7 @@ out:
  */
 static int
 futex_wake_op(u32 __user *uaddr1, u32 __user *uaddr2,
-	      int nr_wake, int nr_wake2, int op)
+	      int nr_wake, int nr_wake2, int op, struct rw_semaphore *shared)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -700,12 +752,13 @@ futex_wake_op(u32 __user *uaddr1, u32 __
 	int ret, op_ret, attempt = 0;
 
 retryfull:
-	down_read(&current->mm->mmap_sem);
+	if (shared)
+		down_read(shared);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, &key1, shared);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, &key2, shared);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -741,15 +794,14 @@ retry:
 		 * futex_atomic_op_inuser needs to both read and write
 		 * *(int __user *)uaddr2, but we can't modify it
 		 * non-atomically.  Therefore, if get_user below is not
-		 * enough, we need to handle the fault ourselves, while
-		 * still holding the mmap_sem.
+		 * enough, we need to handle the fault ourselves. Make 
+		 * sure we hold mmap_sem.
 		 */
 		if (attempt++) {
-			if (futex_handle_fault((unsigned long)uaddr2,
-						attempt)) {
-				ret = -EFAULT;
+			ret = futex_handle_fault((unsigned long)uaddr2,
+						attempt, shared);
+			if (ret)
 				goto out;
-			}
 			goto retry;
 		}
 
@@ -757,7 +809,8 @@ retry:
 		 * If we would have faulted, release mmap_sem,
 		 * fault it in and start all over again.
 		 */
-		up_read(&current->mm->mmap_sem);
+		if (shared)
+			up_read(shared);
 
 		ret = get_user(dummy, uaddr2);
 		if (ret)
@@ -794,7 +847,8 @@ retry:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 	return ret;
 }
 
@@ -803,7 +857,8 @@ out:
  * physical page.
  */
 static int futex_requeue(u32 __user *uaddr1, u32 __user *uaddr2,
-			 int nr_wake, int nr_requeue, u32 *cmpval)
+			 int nr_wake, int nr_requeue, u32 *cmpval,
+			 struct rw_semaphore *shared)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -812,12 +867,13 @@ static int futex_requeue(u32 __user *uad
 	int ret, drop_count = 0;
 
  retry:
-	down_read(&current->mm->mmap_sem);
+	if (shared)
+		down_read(shared);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, &key1, shared);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, &key2, shared);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -840,7 +896,8 @@ static int futex_requeue(u32 __user *uad
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			up_read(&current->mm->mmap_sem);
+			if (shared)
+				up_read(shared);
 
 			ret = get_user(curval, uaddr1);
 
@@ -889,7 +946,8 @@ out_unlock:
 		drop_key_refs(&key1);
 
 out:
-	up_read(&current->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 	return ret;
 }
 
@@ -1000,7 +1058,8 @@ static void unqueue_me_pi(struct futex_q
 	drop_key_refs(&q->key);
 }
 
-static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
+static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time,
+			struct rw_semaphore *shared)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1011,9 +1070,10 @@ static int futex_wait(u32 __user *uaddr,
 
 	q.pi_state = NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (shared)
+		down_read(shared);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, &q.key, shared);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1036,8 +1096,8 @@ static int futex_wait(u32 __user *uaddr,
 	 * a wakeup when *uaddr != val on entry to the syscall.  This is
 	 * rare, but normal.
 	 *
-	 * We hold the mmap semaphore, so the mapping cannot have changed
-	 * since we looked it up in get_futex_key.
+	 * for shared futexes, we hold the mmap semaphore, so the mapping
+	 * cannot have changed since we looked it up in get_futex_key.
 	 */
 	ret = get_futex_value_locked(&uval, uaddr);
 
@@ -1048,7 +1108,8 @@ static int futex_wait(u32 __user *uaddr,
 		 * If we would have faulted, release mmap_sem, fault it in and
 		 * start all over again.
 		 */
-		up_read(&curr->mm->mmap_sem);
+		if (shared)
+			up_read(shared);
 
 		ret = get_user(uval, uaddr);
 
@@ -1067,7 +1128,8 @@ static int futex_wait(u32 __user *uaddr,
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 
 	/*
 	 * There might have been scheduling since the queue_me(), as we
@@ -1109,7 +1171,8 @@ static int futex_wait(u32 __user *uaddr,
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 	return ret;
 }
 
@@ -1120,7 +1183,7 @@ static int futex_wait(u32 __user *uaddr,
  * races the kernel might see a 0 value of the futex too.)
  */
 static int futex_lock_pi(u32 __user *uaddr, int detect, unsigned long sec,
-			 long nsec, int trylock)
+			 long nsec, int trylock, struct rw_semaphore *shared)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
@@ -1141,9 +1204,10 @@ static int futex_lock_pi(u32 __user *uad
 
 	q.pi_state = NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (shared)
+		down_read(shared);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, &q.key, shared);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1237,7 +1301,8 @@ static int futex_lock_pi(u32 __user *uad
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 
 	WARN_ON(!q.pi_state);
 	/*
@@ -1251,7 +1316,8 @@ static int futex_lock_pi(u32 __user *uad
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
 
-	down_read(&curr->mm->mmap_sem);
+	if (shared)
+		down_read(shared);
 	spin_lock(q.lock_ptr);
 
 	/*
@@ -1279,7 +1345,8 @@ static int futex_lock_pi(u32 __user *uad
 
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q, hb);
-		up_read(&curr->mm->mmap_sem);
+		if (shared)
+			up_read(shared);
 		/*
 		 * We own it, so we have to replace the pending owner
 		 * TID. This must be atomic as we have preserve the
@@ -1308,7 +1375,8 @@ static int futex_lock_pi(u32 __user *uad
 		}
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q, hb);
-		up_read(&curr->mm->mmap_sem);
+		if (shared)
+			up_read(shared);
 	}
 
 	if (!detect && ret == -EDEADLK && 0)
@@ -1320,7 +1388,8 @@ static int futex_lock_pi(u32 __user *uad
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 	return ret;
 
  uaddr_faulted:
@@ -1331,15 +1400,15 @@ static int futex_lock_pi(u32 __user *uad
 	 * still holding the mmap_sem.
 	 */
 	if (attempt++) {
-		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
-			ret = -EFAULT;
+		ret = futex_handle_fault((unsigned long)uaddr, attempt, shared);
+		if (ret)
 			goto out_unlock_release_sem;
-		}
 		goto retry_locked;
 	}
 
 	queue_unlock(&q, hb);
-	up_read(&curr->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 
 	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
@@ -1353,7 +1422,7 @@ static int futex_lock_pi(u32 __user *uad
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(u32 __user *uaddr)
+static int futex_unlock_pi(u32 __user *uaddr, struct rw_semaphore *shared)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -1373,9 +1442,10 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	down_read(&current->mm->mmap_sem);
+	if (shared)
+		down_read(shared);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(uaddr, &key, shared);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1434,7 +1504,8 @@ retry_locked:
 out_unlock:
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 
 	return ret;
 
@@ -1446,15 +1517,15 @@ pi_faulted:
 	 * still holding the mmap_sem.
 	 */
 	if (attempt++) {
-		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
-			ret = -EFAULT;
+		ret = futex_handle_fault((unsigned long)uaddr, attempt, shared);
+		if (ret)
 			goto out_unlock;
-		}
 		goto retry_locked;
 	}
 
 	spin_unlock(&hb->lock);
-	up_read(&current->mm->mmap_sem);
+	if (shared)
+		up_read(shared);
 
 	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
@@ -1506,6 +1577,7 @@ static int futex_fd(u32 __user *uaddr, i
 	struct futex_q *q;
 	struct file *filp;
 	int ret, err;
+	struct rw_semaphore *shared;
 	static unsigned long printk_interval;
 
 	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
@@ -1547,11 +1619,12 @@ static int futex_fd(u32 __user *uaddr, i
 	}
 	q->pi_state = NULL;
 
-	down_read(&current->mm->mmap_sem);
-	err = get_futex_key(uaddr, &q->key);
+	shared = &current->mm->mmap_sem;
+	down_read(shared);
+	err = get_futex_key(uaddr, &q->key, shared);
 
 	if (unlikely(err != 0)) {
-		up_read(&current->mm->mmap_sem);
+		up_read(shared);
 		kfree(q);
 		goto error;
 	}
@@ -1563,7 +1636,7 @@ static int futex_fd(u32 __user *uaddr, i
 	filp->private_data = q;
 
 	queue_me(q, ret, filp);
-	up_read(&current->mm->mmap_sem);
+	up_read(shared);
 
 	/* Now we map fd to filp, so userspace can access it */
 	fd_install(ret, filp);
@@ -1690,7 +1763,7 @@ retry:
 		 */
 		if (!pi) {
 			if (uval & FUTEX_WAITERS)
-				futex_wake(uaddr, 1);
+				futex_wake(uaddr, 1, &curr->mm->mmap_sem);
 		}
 	}
 	return 0;
@@ -1776,35 +1849,40 @@ long do_futex(u32 __user *uaddr, int op,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
 	int ret;
+	int opm = op & FUTEX_CMD_MASK;
+	struct rw_semaphore *shared = NULL;
+
+	if (op & FUTEX_PRIVATE_FLAG)
+		shared = &current->mm->mmap_sem;
 
-	switch (op) {
+	switch (opm) {
 	case FUTEX_WAIT:
-		ret = futex_wait(uaddr, val, timeout);
+		ret = futex_wait(uaddr, val, timeout, shared);
 		break;
 	case FUTEX_WAKE:
-		ret = futex_wake(uaddr, val);
+		ret = futex_wake(uaddr, val, shared);
 		break;
 	case FUTEX_FD:
 		/* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
 		ret = futex_fd(uaddr, val);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL, shared);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, shared);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3);
+		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3, shared);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, val, timeout, val2, 0);
+		ret = futex_lock_pi(uaddr, val, timeout, val2, 0, shared);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret = futex_unlock_pi(uaddr);
+		ret = futex_unlock_pi(uaddr, shared);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, 0, timeout, val2, 1);
+		ret = futex_lock_pi(uaddr, 0, timeout, val2, 1, shared);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -1820,8 +1898,9 @@ asmlinkage long sys_futex(u32 __user *ua
 	struct timespec t;
 	unsigned long timeout = MAX_SCHEDULE_TIMEOUT;
 	u32 val2 = 0;
+	int opm = op & FUTEX_CMD_MASK;
 
-	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
+	if (utime && (opm == FUTEX_WAIT || opm == FUTEX_LOCK_PI)) {
 		if (copy_from_user(&t, utime, sizeof(t)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&t))
@@ -1834,9 +1913,9 @@ asmlinkage long sys_futex(u32 __user *ua
 		}
 	}
 	/*
-	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
+	 * requeue parameter in 'utime' if opm == FUTEX_REQUEUE.
 	 */
-	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE)
+	if (opm == FUTEX_REQUEUE || opm == FUTEX_CMP_REQUEUE)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, timeout, uaddr2, val2, val3);
--- linux-2.6.21-rc3/include/linux/futex.h	2007-03-13 13:22:31.000000000 +0100
+++ linux-2.6.21-rc3-ed/include/linux/futex.h	2007-03-15 18:08:37.000000000 +0100
@@ -16,6 +16,18 @@
 #define FUTEX_UNLOCK_PI		7
 #define FUTEX_TRYLOCK_PI	8
 
+#define FUTEX_PRIVATE_FLAG 128
+#define FUTEX_CMD_MASK     ~FUTEX_PRIVATE_FLAG
+
+#define FUTEX_WAIT_PRIVATE	(FUTEX_WAIT | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAKE_PRIVATE	(FUTEX_WAKE | FUTEX_PRIVATE_FLAG)
+#define FUTEX_REQUEUE_PRIVATE	(FUTEX_REQUEUE | FUTEX_PRIVATE_FLAG)
+#define FUTEX_CMP_REQUEUE_PRIVATE (FUTEX_CMP_REQUEUE | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAKE_OP_PRIVATE	(FUTEX_WAKE_OP | FUTEX_PRIVATE_FLAG)
+#define FUTEX_LOCK_PI_PRIVATE	(FUTEX_LOCK_PI | FUTEX_PRIVATE_FLAG)
+#define FUTEX_UNLOCK_PI_PRIVATE	(FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG)
+#define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
+
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.

--Boundary-00=_NrZ+FL/0qYhw6dF--
