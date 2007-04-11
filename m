Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbXDKJfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbXDKJfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXDKJfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:35:25 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:60976 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXDKJfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:35:23 -0400
Date: Wed, 11 Apr 2007 11:19:13 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, "Ulrich Drepper" <drepper@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org, Rusty Russel <rusty@rustcorp.com.au>
Subject: [PATCH, take5] FUTEX : new PRIVATE futexes
Message-Id: <20070411111913.6115dac8.dada1@cosmosbay.com>
In-Reply-To: <20070407104339.6674336b.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	<200608090826.28249.dada1@cosmosbay.com>
	<200608090843.52893.dada1@cosmosbay.com>
	<200703152010.35614.dada1@cosmosbay.com>
	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	<20070405194942.1414c030.dada1@cosmosbay.com>
	<20070407104339.6674336b.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

Update on this take5 :

- Rebased on linux-2.6.21-rc6-mm1 + get_futex_key() must check proper alignement for 64bit futexes
- compile test on x86_64 (one minor typo)
- Added Rusty in CC since he may have to change drivers/lguest/io.c again, since get_futex_key() have yet another parameter (fshared). (I couldnt find this file in 2.6.21-rc6-mm1 tree)

Thank you

History :

take4 :

- All remarks from Nick were addressed I hope

- Current mm code have a problem with 64bit futexes, as spoted by Nick :

get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
So it is possible a 64bit futex spans two pages of memory...
I had to change get_futex_key() prototype to be able to do a correct test.

take3:

I'm pleased to present this patch which improves linux futexes performance and 
scalability, merely avoiding taking mmap_sem rwlock.

Ulrich agreed with the API and said glibc work could start as soon
as he gets a Fedora kernel with it :)

In this third version I dropped the NUMA optims and process private hash table,
to let new API come in and be tested.

Thank you

[PATCH] FUTEX : new PRIVATE futexes

Analysis of current linux futex code :
--------------------------------------

A central hash table futex_queues[] holds all contexts (futex_q) of waiting 
threads.
Each futex_wait()/futex_wait() has to obtain a spinlock on a hash slot to 
perform lookups or insert/deletion of a futex_q.

When a futex_wait() is done, calling thread has to :


1) - Obtain a read lock on mmap_sem to be able to validate the user pointer
     (calling find_vma()). This validation tells us if the futex uses
     an inode based store (mapped file), or mm based store (anonymous mem)

2) - compute a hash key

3) - Atomic increment of reference counter on an inode or a mm_struct

4) - lock part of futex_queues[] hash table

5) - perform the test on value of futex.
                (rollback is value != expected_value, returns EWOULDBLOCK)
        (various loops if test triggers mm faults)

6) queue the context into hash table, release the lock got in 4)

7) - release the read_lock on mmap_sem

   <block>

8) Eventually unqueue the context (but rarely, as this part
 may be done by the futex_wake())

Futexes were designed to improve scalability but current implementation
has various problems :

- Central hashtable :
 This means scalability problems if many processes/threads want to use
 futexes at the same time.
 This means NUMA unbalance because this hashtable is located on one node.

- Using mmap_sem on every futex() syscall :

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

Most of these scalability problems come from the fact that futexes are in
one global namespace. As we use a central hash table, we must make sure
they are all using the same reference (given by the mm subsystem).
We chose to force all futexes be 'shared'. This has a cost.

But fact is POSIX defined PRIVATE and SHARED, allowing clear separation, and
optimal performance if carefuly implemented. Time has come for linux to have 
better threading performance.

The goal is to permit new futex commands to avoid :
 - Taking the mmap_sem semaphore, conflicting with other subsystems.
 - Modifying a ref_count on mm or an inode, still conflicting with mm or fs.

This is possible because, for one process using PTHREAD_PROCESS_PRIVATE
futexes, we only need to distinguish futexes by their virtual address, no
matter the underlying mm storage is.



If glibc wants to exploit this new infrastructure, it should use new
_PRIVATE futex subcommands for PTHREAD_PROCESS_PRIVATE futexes. And
be prepared to fallback on old subcommands for old kernels. Using one
global variable with the FUTEX_PRIVATE_FLAG or 0 value should be OK.

PTHREAD_PROCESS_SHARED futexes should still use the old subcommands.

Compatibility with old applications is preserved, they still hit the
scalability problems, but new applications can fly :)

Note : the same SHARED futex (mapped on a file) can be used by old binaries 
*and* new binaries, because both binaries will use the old subcommands.

Note : Vast majority of futexes should be using PROCESS_PRIVATE semantic,
as this is the default semantic. Almost all applications should benefit
of this changes (new kernel and updated libc)

Some bench results on a Pentium M 1.6 GHz (SMP kernel on a UP machine)

/* calling futex_wait(addr, value) with value != *addr */
434 cycles per futex(FUTEX_WAIT) call (mixing 2 futexes)
427 cycles per futex(FUTEX_WAIT) call (using one futex)
345 cycles per futex(FUTEX_WAIT_PRIVATE) call (mixing 2 futexes)
345 cycles per futex(FUTEX_WAIT_PRIVATE) call (using one futex)
For reference :
187 cycles per getppid() call
188 cycles per umask() call
183 cycles per ni_syscall() call

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/futex.h |   29 +++
 kernel/futex.c        |  339 +++++++++++++++++++++++++---------------
 2 files changed, 245 insertions(+), 123 deletions(-)

--- linux-2.6.21-rc6-mm1/kernel/futex.c
+++ linux-2.6.21-rc6-mm1-ed/kernel/futex.c
@@ -16,6 +16,9 @@
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *  Copyright (C) 2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
  *
+ *  PRIVATE futexes by Eric Dumazet
+ *  Copyright (C) 2007 Eric Dumazet <dada1@cosmosbay.com>
+ *
  *  Thanks to Ben LaHaise for yelling "hashed waitqueues" loudly
  *  enough at me, Linus for the original (flawed) idea, Matthew
  *  Kirkwood for proof-of-concept implementation.
@@ -193,6 +196,8 @@ static inline int match_futex(union fute
  * get_futex_key - Get parameters which are the keys for a futex.
  * @uaddr: virtual address of the futex
  * @size: size of futex (4 or 8)
+ * @shared: NULL for a PROCESS_PRIVATE futex,
+ *	&current->mm->mmap_sem for a PROCESS_SHARED futex
  * @key: address where result is stored.
  *
  * Returns a negative error code or 0
@@ -202,9 +207,12 @@ static inline int match_futex(union fute
  * offset_within_page).  For private mappings, it's (uaddr, current->mm).
  * We can usually work out the index without swapping in the page.
  *
- * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
+ * fshared is NULL for PROCESS_PRIVATE futexes
+ * For other futexes, it points to &current->mm->mmap_sem and
+ * caller must have taken the reader lock. but NOT any spinlocks.
  */
-int get_futex_key(void __user *uaddr, int size, union futex_key *key)
+int get_futex_key(void __user *uaddr, int size, struct rw_semaphore *fshared,
+		  union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -221,6 +229,20 @@ int get_futex_key(void __user *uaddr, in
 	address -= key->both.offset;
 
 	/*
+	 * PROCESS_PRIVATE futexes are fast.
+	 * As the mm cannot disappear under us and the 'key' only needs
+	 * virtual address, we dont even have to find the underlying vma.
+	 * Note : We do have to check 'uaddr' is a valid user address,
+	 *        but access_ok() should be faster than find_vma()
+	 */
+	if (!fshared) {
+		if (!access_ok(VERIFY_WRITE, uaddr, size))
+			return -EFAULT;
+		key->private.mm = mm;
+		key->private.address = address;
+		return 0;
+	}
+	/*
 	 * The futex is hashed differently depending on whether
 	 * it's in a shared or private mapping.  So check vma first.
 	 */
@@ -247,6 +269,7 @@ int get_futex_key(void __user *uaddr, in
 	 * mappings of _writable_ handles.
 	 */
 	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
+		key->both.offset |= FUT_OFF_MMSHARED; /* reference taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
 		return 0;
@@ -256,7 +279,7 @@ int get_futex_key(void __user *uaddr, in
 	 * Linear file mappings are also simple.
 	 */
 	key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
-	key->both.offset++; /* Bit 0 of offset indicates inode-based key. */
+	key->both.offset |= FUT_OFF_INODE; /* inode-based key. */
 	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
 		key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
 				     + vma->vm_pgoff);
@@ -284,16 +307,18 @@ EXPORT_SYMBOL_GPL(get_futex_key);
  * Take a reference to the resource addressed by a key.
  * Can be called while holding spinlocks.
  *
- * NOTE: mmap_sem MUST be held between get_futex_key() and calling this
- * function, if it is called at all.  mmap_sem keeps key->shared.inode valid.
  */
 inline void get_futex_key_refs(union futex_key *key)
 {
-	if (key->both.ptr != 0) {
-		if (key->both.offset & 1)
+	if (key->both.ptr == 0)
+		return;
+	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
+		case FUT_OFF_INODE:
 			atomic_inc(&key->shared.inode->i_count);
-		else
+			break;
+		case FUT_OFF_MMSHARED:
 			atomic_inc(&key->private.mm->mm_count);
+			break;
 	}
 }
 EXPORT_SYMBOL_GPL(get_futex_key_refs);
@@ -304,11 +329,15 @@ EXPORT_SYMBOL_GPL(get_futex_key_refs);
  */
 void drop_futex_key_refs(union futex_key *key)
 {
-	if (key->both.ptr != 0) {
-		if (key->both.offset & 1)
+	if (key->both.ptr == 0)
+		return;
+	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
+		case FUT_OFF_INODE:
 			iput(key->shared.inode);
-		else
+			break;
+		case FUT_OFF_MMSHARED:
 			mmdrop(key->private.mm);
+			break;
 	}
 }
 EXPORT_SYMBOL_GPL(drop_futex_key_refs);
@@ -342,28 +371,39 @@ get_futex_value_locked(unsigned long *de
 }
 
 /*
- * Fault handling. Called with current->mm->mmap_sem held.
+ * Fault handling.
+ * if fshared is non NULL, current->mm->mmap_sem is already held
  */
-static int futex_handle_fault(unsigned long address, int attempt)
+static int futex_handle_fault(unsigned long address,
+			      struct rw_semaphore *fshared, int attempt)
 {
 	struct vm_area_struct * vma;
 	struct mm_struct *mm = current->mm;
+	int ret = -EFAULT;
 
-	if (attempt > 2 || !(vma = find_vma(mm, address)) ||
-	    vma->vm_start > address || !(vma->vm_flags & VM_WRITE))
-		return -EFAULT;
+	if (attempt > 2)
+		return ret;
 
-	switch (handle_mm_fault(mm, vma, address, 1)) {
-	case VM_FAULT_MINOR:
-		current->min_flt++;
-		break;
-	case VM_FAULT_MAJOR:
-		current->maj_flt++;
-		break;
-	default:
-		return -EFAULT;
+	if (!fshared)
+		down_read(&mm->mmap_sem);
+	vma = find_vma(mm, address);
+	if (vma &&
+	    address >= vma->vm_start &&
+	    (vma->vm_flags & VM_WRITE)) {
+		switch (handle_mm_fault(mm, vma, address, 1)) {
+		case VM_FAULT_MINOR:
+			ret = 0;
+			current->min_flt++;
+			break;
+		case VM_FAULT_MAJOR:
+			ret = 0;
+			current->maj_flt++;
+			break;
+		}
 	}
-	return 0;
+	if (!fshared)
+		up_read(&mm->mmap_sem);
+	return ret;
 }
 
 /*
@@ -705,10 +745,10 @@ double_lock_hb(struct futex_hash_bucket 
 }
 
 /*
- * Wake up all waiters hashed on the physical page that is mapped
- * to this virtual address:
+ * Wake up all waiters on a futex (fuaddr, futex64, fshared)
  */
-static int futex_wake(unsigned long __user *uaddr, int futex64, int nr_wake)
+static int futex_wake(unsigned long __user *uaddr, int futex64,
+		      struct rw_semaphore *fshared, int nr_wake)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -717,9 +757,10 @@ static int futex_wake(unsigned long __us
 	int ret;
 	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, fsize, &key);
+	ret = get_futex_key(uaddr, fsize, fshared, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -741,7 +782,8 @@ static int futex_wake(unsigned long __us
 
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -810,8 +852,10 @@ retry:
  * one physical page to another physical page (PI-futex uaddr2)
  */
 static int
-futex_requeue_pi(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-		 int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64)
+futex_requeue_pi(unsigned long __user *uaddr1,
+		 int futex64, struct rw_semaphore *fshared,
+		 unsigned long __user *uaddr2,
+		 int nr_wake, int nr_requeue, unsigned long *cmpval)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -830,12 +874,13 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr1, fsize, &key1);
+	ret = get_futex_key(uaddr1, fsize, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fsize, &key2);
+	ret = get_futex_key(uaddr2, fsize, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -858,7 +903,8 @@ retry:
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			up_read(&current->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
 
 			ret = futex_get_user(&curval, uaddr1, futex64);
 
@@ -993,7 +1039,8 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -1002,8 +1049,10 @@ out:
  * to this virtual address:
  */
 static int
-futex_wake_op(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-	      int nr_wake, int nr_wake2, int op, int futex64)
+futex_wake_op(unsigned long __user *uaddr1,
+	      int futex64, struct rw_semaphore *fshared,
+	      unsigned long __user *uaddr2,
+	      int nr_wake, int nr_wake2, int op)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -1013,12 +1062,13 @@ futex_wake_op(unsigned long __user *uadd
 	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 retryfull:
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr1, fsize, &key1);
+	ret = get_futex_key(uaddr1, fsize, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fsize, &key2);
+	ret = get_futex_key(uaddr2, fsize, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1065,11 +1115,10 @@ retry:
 		 * still holding the mmap_sem.
 		 */
 		if (attempt++) {
-			if (futex_handle_fault((unsigned long)uaddr2,
-						attempt)) {
-				ret = -EFAULT;
+			ret = futex_handle_fault((unsigned long)uaddr2,
+						fshared, attempt);
+			if (ret)
 				goto out;
-			}
 			goto retry;
 		}
 
@@ -1077,7 +1126,8 @@ retry:
 		 * If we would have faulted, release mmap_sem,
 		 * fault it in and start all over again.
 		 */
-		up_read(&current->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
 
 		ret = futex_get_user(&dummy, uaddr2, futex64);
 		if (ret)
@@ -1114,7 +1164,8 @@ retry:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -1123,8 +1174,10 @@ out:
  * physical page.
  */
 static int
-futex_requeue(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-	      int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64)
+futex_requeue(unsigned long __user *uaddr1,
+	      int futex64, struct rw_semaphore *fshared,
+	      unsigned long __user *uaddr2,
+	      int nr_wake, int nr_requeue, unsigned long *cmpval)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -1134,12 +1187,13 @@ futex_requeue(unsigned long __user *uadd
 	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
  retry:
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr1, fsize, &key1);
+	ret = get_futex_key(uaddr1, fsize, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fsize, &key2);
+	ret = get_futex_key(uaddr2, fsize, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1162,7 +1216,8 @@ futex_requeue(unsigned long __user *uadd
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			up_read(&current->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
 
 			ret = futex_get_user(&curval, uaddr1, futex64);
 
@@ -1215,7 +1270,8 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -1346,12 +1402,14 @@ static void unqueue_me_pi(struct futex_q
 /*
  * Fixup the pi_state owner with current.
  *
- * The cur->mm semaphore must be  held, it is released at return of this
- * function.
+ * for PROCESS_SHARED futexes, cur->mm semaphore must be  held, it is
+ * released at return of this function.
  */
-static int fixup_pi_state_owner(unsigned long  __user *uaddr, struct futex_q *q,
+static int fixup_pi_state_owner(unsigned long  __user *uaddr, int futex64,
+				struct rw_semaphore *fshared,
+				struct futex_q *q,
 				struct futex_hash_bucket *hb,
-				struct task_struct *curr, int futex64)
+				struct task_struct *curr)
 {
 	unsigned long newtid = curr->pid | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
@@ -1376,7 +1434,8 @@ static int fixup_pi_state_owner(unsigned
 
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(q);
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	/*
 	 * We own it, so we have to replace the pending owner
 	 * TID. This must be atomic as we have preserve the
@@ -1399,12 +1458,14 @@ static int fixup_pi_state_owner(unsigned
 
 /*
  * In case we must use restart_block to restart a futex_wait,
- * we encode in the 'arg3' futex64 capability
+ * we encode in the 'arg3' both futex64 and shared capabilities
  */
 #define ARG3_FUTEX64 1
+#define ARG3_SHARED  2
 
 static long futex_wait_restart(struct restart_block *restart);
 static int futex_wait(unsigned long __user *uaddr, int futex64,
+		      struct rw_semaphore *fshared,
 		      unsigned long val, ktime_t *abs_time)
 {
 	struct task_struct *curr = current;
@@ -1419,9 +1480,10 @@ static int futex_wait(unsigned long __us
 
 	q.pi_state = NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, fsize, &q.key);
+	ret = get_futex_key(uaddr, fsize, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1444,8 +1506,8 @@ static int futex_wait(unsigned long __us
 	 * a wakeup when *uaddr != val on entry to the syscall.  This is
 	 * rare, but normal.
 	 *
-	 * We hold the mmap semaphore, so the mapping cannot have changed
-	 * since we looked it up in get_futex_key.
+	 * for shared futexes, we hold the mmap semaphore, so the mapping
+	 * cannot have changed since we looked it up in get_futex_key.
 	 */
 	ret = get_futex_value_locked(&uval, uaddr, futex64);
 
@@ -1456,7 +1518,8 @@ static int futex_wait(unsigned long __us
 		 * If we would have faulted, release mmap_sem, fault it in and
 		 * start all over again.
 		 */
-		up_read(&curr->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
 		ret = futex_get_user(&uval, uaddr, futex64);
 
 		if (!ret)
@@ -1482,7 +1545,8 @@ static int futex_wait(unsigned long __us
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	/*
 	 * There might have been scheduling since the queue_me(), as we
@@ -1552,7 +1616,8 @@ static int futex_wait(unsigned long __us
 		else
 			ret = rt_mutex_timed_lock(lock, to, 1);
 
-		down_read(&curr->mm->mmap_sem);
+		if (fshared)
+			down_read(fshared);
 		spin_lock(q.lock_ptr);
 
 		/*
@@ -1569,7 +1634,8 @@ static int futex_wait(unsigned long __us
 
 			/* mmap_sem and hash_bucket lock are unlocked at
 			   return of this function */
-			ret = fixup_pi_state_owner(uaddr, &q, hb, curr, futex64);
+			ret = fixup_pi_state_owner(uaddr, futex64, fshared,
+						   &q, hb, curr);
 		} else {
 			/*
 			 * Catch the rare case, where the lock was released
@@ -1582,7 +1648,8 @@ static int futex_wait(unsigned long __us
 			}
 			/* Unqueue and drop the lock */
 			unqueue_me_pi(&q);
-			up_read(&curr->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
 		}
 
 		debug_rt_mutex_free_waiter(&q.waiter);
@@ -1616,6 +1683,8 @@ static int futex_wait(unsigned long __us
 		if (futex64)
 			restart->arg3 |= ARG3_FUTEX64;
 #endif
+		if (fshared)
+			restart->arg3 |= ARG3_SHARED;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1623,7 +1692,8 @@ static int futex_wait(unsigned long __us
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -1634,13 +1704,16 @@ static long futex_wait_restart(struct re
 	unsigned long val = restart->arg1;
 	ktime_t *abs_time = (ktime_t *)restart->arg2;
 	int futex64 = 0;
+	struct rw_semaphore *fshared = NULL;
 
 #ifdef CONFIG_64BIT
 	if (restart->arg3 & ARG3_FUTEX64)
 		futex64 = 1;
 #endif
+	if (restart->arg3 & ARG3_SHARED)
+		fshared = &current->mm->mmap_sem;
 	restart->fn = do_no_restart_syscall;
-	return (long)futex_wait(uaddr, futex64, val, abs_time);
+	return (long)futex_wait(uaddr, futex64, fshared, val, abs_time);
 }
 
 
@@ -1695,8 +1768,9 @@ static void set_pi_futex_owner(struct fu
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(unsigned long __user *uaddr, int detect, ktime_t *time,
-			 int trylock, int futex64)
+static int futex_lock_pi(unsigned long __user *uaddr,
+			 int futex64, struct rw_semaphore *fshared,
+			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
@@ -1718,9 +1792,10 @@ static int futex_lock_pi(unsigned long _
 
 	q.pi_state = NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, fsize, &q.key);
+	ret = get_futex_key(uaddr, fsize, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1841,7 +1916,8 @@ static int futex_lock_pi(unsigned long _
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	WARN_ON(!q.pi_state);
 	/*
@@ -1855,7 +1931,8 @@ static int futex_lock_pi(unsigned long _
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
 
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 	spin_lock(q.lock_ptr);
 
 	/*
@@ -1864,7 +1941,8 @@ static int futex_lock_pi(unsigned long _
 	 */
 	if (!ret && q.pi_state->owner != curr)
 		/* mmap_sem is unlocked at return of this function */
-		ret = fixup_pi_state_owner(uaddr, &q, hb, curr, futex64);
+		ret = fixup_pi_state_owner(uaddr, futex64, fshared,
+					   &q, hb, curr);
 	else {
 		/*
 		 * Catch the rare case, where the lock was released
@@ -1877,7 +1955,8 @@ static int futex_lock_pi(unsigned long _
 		}
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q);
-		up_read(&curr->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
 	}
 
 	if (!detect && ret == -EDEADLK && 0)
@@ -1889,7 +1968,8 @@ static int futex_lock_pi(unsigned long _
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 
  uaddr_faulted:
@@ -1900,15 +1980,16 @@ static int futex_lock_pi(unsigned long _
 	 * still holding the mmap_sem.
 	 */
 	if (attempt++) {
-		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
-			ret = -EFAULT;
+		ret = futex_handle_fault((unsigned long)uaddr, fshared,
+					 attempt);
+		if (ret)
 			goto out_unlock_release_sem;
-		}
 		goto retry_locked;
 	}
 
 	queue_unlock(&q, hb);
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	ret = futex_get_user(&uval, uaddr, futex64);
 	if (!ret && (uval != -EFAULT))
@@ -1922,7 +2003,8 @@ static int futex_lock_pi(unsigned long _
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(unsigned long __user *uaddr, int futex64)
+static int futex_unlock_pi(unsigned long __user *uaddr, int futex64,
+			   struct rw_semaphore *fshared)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -1943,9 +2025,10 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, fsize, &key);
+	ret = get_futex_key(uaddr, fsize, fshared, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2004,7 +2087,8 @@ retry_locked:
 out_unlock:
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	return ret;
 
@@ -2016,15 +2100,16 @@ pi_faulted:
 	 * still holding the mmap_sem.
 	 */
 	if (attempt++) {
-		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
-			ret = -EFAULT;
+		ret = futex_handle_fault((unsigned long)uaddr, fshared,
+					 attempt);
+		if (ret)
 			goto out_unlock;
-		}
 		goto retry_locked;
 	}
 
 	spin_unlock(&hb->lock);
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	ret = futex_get_user(&uval, uaddr, futex64);
 	if (!ret && (uval != -EFAULT))
@@ -2076,6 +2161,7 @@ static int futex_fd(u32 __user *uaddr, i
 	struct futex_q *q;
 	struct file *filp;
 	int ret, err;
+	struct rw_semaphore *fshared;
 	static unsigned long printk_interval;
 
 	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
@@ -2117,11 +2203,12 @@ static int futex_fd(u32 __user *uaddr, i
 	}
 	q->pi_state = NULL;
 
-	down_read(&current->mm->mmap_sem);
-	err = get_futex_key(uaddr, sizeof(u32), &q->key);
+	fshared = &current->mm->mmap_sem;
+	down_read(fshared);
+	err = get_futex_key(uaddr, sizeof(u32), fshared, &q->key);
 
 	if (unlikely(err != 0)) {
-		up_read(&current->mm->mmap_sem);
+		up_read(fshared);
 		kfree(q);
 		goto error;
 	}
@@ -2133,7 +2220,7 @@ static int futex_fd(u32 __user *uaddr, i
 	filp->private_data = q;
 
 	queue_me(q, ret, filp);
-	up_read(&current->mm->mmap_sem);
+	up_read(fshared);
 
 	/* Now we map fd to filp, so userspace can access it */
 	fd_install(ret, filp);
@@ -2262,7 +2349,8 @@ retry:
 		 */
 		if (!pi) {
 			if (uval & FUTEX_WAITERS)
-				futex_wake((unsigned long __user *)uaddr, 0, 1);
+				futex_wake((unsigned long __user *)uaddr, 0,
+					   &curr->mm->mmap_sem, 1);
 		}
 	}
 	return 0;
@@ -2350,13 +2438,18 @@ long do_futex(unsigned long __user *uadd
 	      unsigned long val2, unsigned long val3, int fut64)
 {
 	int ret;
+	int cmd = op & FUTEX_CMD_MASK;
+	struct rw_semaphore *fshared = NULL;
+
+	if (!(op & FUTEX_PRIVATE_FLAG))
+		fshared = &current->mm->mmap_sem;
 
-	switch (op) {
+	switch (cmd) {
 	case FUTEX_WAIT:
-		ret = futex_wait(uaddr, fut64, val, timeout);
+		ret = futex_wait(uaddr, fut64, fshared, val, timeout);
 		break;
 	case FUTEX_WAKE:
-		ret = futex_wake(uaddr, fut64, val);
+		ret = futex_wake(uaddr, fut64, fshared, val);
 		break;
 	case FUTEX_FD:
 		if (fut64)
@@ -2366,25 +2459,29 @@ long do_futex(unsigned long __user *uadd
 			ret = futex_fd((u32 __user *)uaddr, val);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL, fut64);
+		ret = futex_requeue(uaddr, fut64, fshared,
+				    uaddr2, val, val2, NULL);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, fut64);
+		ret = futex_requeue(uaddr, fut64, fshared,
+				    uaddr2, val, val2, &val3);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3, fut64);
+		ret = futex_wake_op(uaddr, fut64, fshared,
+				    uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, val, timeout, 0, fut64);
+		ret = futex_lock_pi(uaddr, fut64, fshared, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret = futex_unlock_pi(uaddr, fut64);
+		ret = futex_unlock_pi(uaddr, fut64, fshared);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, 0, timeout, 1, fut64);
+		ret = futex_lock_pi(uaddr, fut64, fshared, 0, timeout, 1);
 		break;
 	case FUTEX_CMP_REQUEUE_PI:
-		ret = futex_requeue_pi(uaddr, uaddr2, val, val2, &val3, fut64);
+		ret = futex_requeue_pi(uaddr, fut64, fshared,
+				       uaddr2, val, val2, &val3);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -2401,23 +2498,24 @@ sys_futex64(u64 __user *uaddr, int op, u
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
 	u64 val2 = 0;
+	int cmd = op & FUTEX_CMD_MASK;
 
-	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
 
 		t = timespec_to_ktime(ts);
-		if (op == FUTEX_WAIT)
+		if (cmd == FUTEX_WAIT)
 			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
 	/*
-	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
+	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
 	 */
-	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
-	    || op == FUTEX_CMP_REQUEUE_PI)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE
+	    || cmd == FUTEX_CMP_REQUEUE_PI)
 		val2 = (unsigned long) utime;
 
 	return do_futex((unsigned long __user*)uaddr, op, val, tp,
@@ -2433,23 +2531,24 @@ asmlinkage long sys_futex(u32 __user *ua
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
 	u32 val2 = 0;
+	int cmd = op & FUTEX_CMD_MASK;
 
-	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
 
 		t = timespec_to_ktime(ts);
-		if (op == FUTEX_WAIT)
+		if (cmd == FUTEX_WAIT)
 			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
 	/*
-	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
+	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
 	 */
-	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
-	    || op == FUTEX_CMP_REQUEUE_PI)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE
+	    || cmd == FUTEX_CMP_REQUEUE_PI)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex((unsigned long __user*)uaddr, op, val, tp,
--- linux-2.6.21-rc6-mm1/include/linux/futex.h
+++ linux-2.6.21-rc6-mm1-ed/include/linux/futex.h
@@ -19,6 +19,18 @@ union ktime;
 #define FUTEX_TRYLOCK_PI	8
 #define FUTEX_CMP_REQUEUE_PI	9
 
+#define FUTEX_PRIVATE_FLAG	128
+#define FUTEX_CMD_MASK		~FUTEX_PRIVATE_FLAG
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
@@ -115,8 +127,18 @@ handle_futex_death(u32 __user *uaddr, st
  * Don't rearrange members without looking at hash_futex().
  *
  * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
- * We set bit 0 to indicate if it's an inode-based key.
- */
+ * We use the two low order bits of offset to tell what is the kind of key :
+ *  00 : Private process futex (PTHREAD_PROCESS_PRIVATE)
+ *       (no reference on an inode or mm)
+ *  01 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *	mapped on a file (reference on the underlying inode)
+ *  10 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *       (but private mapping on an mm, and reference taken on it)
+*/
+
+#define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
+#define FUT_OFF_MMSHARED 2 /* We set bit 1 if key has a reference on mm */
+
 union futex_key {
 	unsigned long __user *uaddr;
 	struct {
@@ -135,7 +157,8 @@ union futex_key {
 		int offset;
 	} both;
 };
-int get_futex_key(void __user *uaddr, int size, union futex_key *key);
+int get_futex_key(void __user *uaddr, int size, struct rw_semaphore *shared,
+		  union futex_key *key);
 void get_futex_key_refs(union futex_key *key);
 void drop_futex_key_refs(union futex_key *key);
 
