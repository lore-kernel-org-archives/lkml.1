Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXDGIos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXDGIos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXDGIop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:44:45 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:34292 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXDGIom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:44:42 -0400
Date: Sat, 7 Apr 2007 10:43:39 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>
Cc: "Ulrich Drepper" <drepper@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH, take4] FUTEX : new PRIVATE futexes
Message-Id: <20070407104339.6674336b.dada1@cosmosbay.com>
In-Reply-To: <20070405194942.1414c030.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	<200608090826.28249.dada1@cosmosbay.com>
	<200608090843.52893.dada1@cosmosbay.com>
	<200703152010.35614.dada1@cosmosbay.com>
	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	<20070405194942.1414c030.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 07 Apr 2007 10:43:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Updates on this take4 :

- All remarks from Nick were addressed I hope

- Current mm code have a problem with 64bit futexes, as spoted by Nick :

get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
So it is possible a 64bit futex spans two pages of memory...
I had to change get_futex_key() prototype to be able to do a correct test.

History :

I'm pleased to present this patch which improves linux futexes performance and 
scalability, merely avoiding taking mmap_sem rwlock.

Ulrich agreed with the API and said glibc work could start as soon
as he gets a Fedora kernel with it :)

Andrew, could we get this in mm as well ? This version is against 2.6.21-rc5-mm4
(so supports 64bit futexes)

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
 include/linux/futex.h |   46 +++++
 kernel/futex.c        |  340 ++++++++++++++++++++++++++--------------
 2 files changed, 268 insertions(+), 118 deletions(-)

--- linux-2.6.21-rc5-mm4/include/linux/futex.h
+++ linux-2.6.21-rc5-mm4-ed/include/linux/futex.h
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
+ * We use the two low order bits of offset to tell what is the kind of key :
+ *  00 : Private process futex (PTHREAD_PROCESS_PRIVATE)
+ *       (no reference on an inode or mm)
+ *  01 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *	mapped on a file (reference on the underlying inode)
+ *  10 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *       (but private mapping on an mm, and reference taken on it)
  */
+
+#define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
+#define FUT_OFF_MMSHARED 2 /* We set bit 1 if key has a reference on mm */
+
 union futex_key {
 	unsigned long __user *uaddr;
 	struct {
@@ -135,8 +157,28 @@ union futex_key {
 		int offset;
 	} both;
 };
-int get_futex_key(void __user *uaddr, union futex_key *key);
+
+/**
+ * get_futex_key - Get parameters which are the keys for a futex.
+ * @uaddr: virtual address of the futex
+ * @size: size of futex (4 or 8)
+ * @shared: NULL for a PROCESS_PRIVATE futex,
+ *	&current->mm->mmap_sem for a PROCESS_SHARED futex
+ * @key: address where result is stored.
+ *
+ * Returns an error code or 0
+ */
+int get_futex_key(void __user *uaddr, int size, struct rw_semaphore *shared,
+		  union futex_key *key);
+
+/**
+ * get_futex_key_refs - Take a reference to the resource addressed by a key
+ */
 void get_futex_key_refs(union futex_key *key);
+
+/**
+ * drop_futex_key_refs - Drop a reference to the resource addressed by a key.
+ */
 void drop_futex_key_refs(union futex_key *key);
 
 #ifdef CONFIG_FUTEX
--- linux-2.6.21-rc5-mm4/kernel/futex.c
+++ linux-2.6.21-rc5-mm4-ed/kernel/futex.c
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
@@ -199,11 +202,14 @@ static inline int match_futex(union fute
  * Returns: 0, or negative error code.
  * The key words are stored in *key on success.
  *
- * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
+ * fshared is NULL for PROCESS_PRIVATE futexes
+ * For other futexes, it points to &current->mm->mmap_sem and
+ * caller must have taken the reader lock. but NOT any spinlocks.
  */
-int get_futex_key(void __user *uaddr, union futex_key *key)
+int get_futex_key(void __user *fuaddr, int fsize, struct rw_semaphore *fshared,
+	union futex_key *key)
 {
-	unsigned long address = (unsigned long)uaddr;
+	unsigned long address = (unsigned long)fuaddr;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct page *page;
@@ -213,11 +219,29 @@ int get_futex_key(void __user *uaddr, un
 	 * The futex address must be "naturally" aligned.
 	 */
 	key->both.offset = address % PAGE_SIZE;
-	if (unlikely((key->both.offset % sizeof(u32)) != 0))
+	if (unlikely((key->both.offset & (fsize - 1)) != 0))
 		return -EINVAL;
 	address -= key->both.offset;
 
 	/*
+	 * PROCESS_PRIVATE futexes are fast.
+	 * As the mm cannot disappear under us and the 'key' only needs
+	 * virtual address, we dont even have to find the underlying vma.
+	 * Note : We do have to check 'address' is a valid user address,
+	 *        but access_ok() should be faster than find_vma()
+	 */
+	if (!fshared) {
+		/*
+		 * Note : At this point, address points to the start of page,
+		 *        not the real futex address, this is OK.
+		 */
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
@@ -232,7 +256,7 @@ int get_futex_key(void __user *uaddr, un
 		return (vma->vm_flags & VM_IO) ? -EPERM : -EACCES;
 
 	/* Save the user address in the ley */
-	key->uaddr = uaddr;
+	key->uaddr = fuaddr;
 
 	/*
 	 * Private mappings are handled in a simple way.
@@ -244,6 +268,7 @@ int get_futex_key(void __user *uaddr, un
 	 * mappings of _writable_ handles.
 	 */
 	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
+		key->both.offset |= FUT_OFF_MMSHARED; /* reference taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
 		return 0;
@@ -253,7 +278,7 @@ int get_futex_key(void __user *uaddr, un
 	 * Linear file mappings are also simple.
 	 */
 	key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
-	key->both.offset++; /* Bit 0 of offset indicates inode-based key. */
+	key->both.offset |= FUT_OFF_INODE; /* inode-based key. */
 	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
 		key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
 				     + vma->vm_pgoff);
@@ -281,17 +306,19 @@ EXPORT_SYMBOL_GPL(get_futex_key);
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
-	}
+			break;
+  	}
 }
 EXPORT_SYMBOL_GPL(get_futex_key_refs);
 
@@ -301,11 +328,15 @@ EXPORT_SYMBOL_GPL(get_futex_key_refs);
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
@@ -339,28 +370,38 @@ get_futex_value_locked(unsigned long *de
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
-
-	switch (handle_mm_fault(mm, vma, address, 1)) {
-	case VM_FAULT_MINOR:
-		current->min_flt++;
-		break;
-	case VM_FAULT_MAJOR:
-		current->maj_flt++;
-		break;
-	default:
-		return -EFAULT;
+	if (attempt > 2)
+		return ret;
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
@@ -702,20 +743,22 @@ double_lock_hb(struct futex_hash_bucket 
 }
 
 /*
- * Wake up all waiters hashed on the physical page that is mapped
- * to this virtual address:
+ * Wake up all waiters on a futex (fuaddr, futex64, fshared)
  */
-static int futex_wake(unsigned long __user *uaddr, int nr_wake)
+static int futex_wake(unsigned long __user *fuaddr, int futex64,
+		      struct rw_semaphore *fshared, int nr_wake)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	struct plist_head *head;
 	union futex_key key;
 	int ret;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(fuaddr, fsize, fshared, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -737,7 +780,8 @@ static int futex_wake(unsigned long __us
 
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -807,7 +851,8 @@ retry:
  */
 static int
 futex_requeue_pi(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-		 int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64)
+		 int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64,
+		 struct rw_semaphore *fshared)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -817,6 +862,7 @@ futex_requeue_pi(unsigned long __user *u
 	struct rt_mutex_waiter *waiter, *top_waiter = NULL;
 	struct rt_mutex *lock2 = NULL;
 	int ret, drop_count = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -825,12 +871,13 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -998,21 +1045,24 @@ out:
  */
 static int
 futex_wake_op(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-	      int nr_wake, int nr_wake2, int op, int futex64)
+	      int nr_wake, int nr_wake2, int op, int futex64,
+		struct rw_semaphore *fshared)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 retryfull:
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1055,15 +1105,14 @@ retry:
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
+						fshared, attempt);
+			if (ret)
 				goto out;
-			}
 			goto retry;
 		}
 
@@ -1071,7 +1120,8 @@ retry:
 		 * If we would have faulted, release mmap_sem,
 		 * fault it in and start all over again.
 		 */
-		up_read(&current->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
 
 		ret = futex_get_user(&dummy, uaddr2, futex64);
 		if (ret)
@@ -1108,7 +1158,8 @@ retry:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -1118,21 +1169,23 @@ out:
  */
 static int
 futex_requeue(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-	      int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64)
+	      int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64,
+		struct rw_semaphore *fshared)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head1;
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;
-
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
  retry:
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, fshared, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1155,7 +1208,8 @@ futex_requeue(unsigned long __user *uadd
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			up_read(&current->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
 
 			ret = futex_get_user(&curval, uaddr1, futex64);
 
@@ -1208,7 +1262,8 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -1390,9 +1445,17 @@ static int fixup_pi_state_owner(unsigned
 	return ret;
 }
 
+/*
+ * In case we must use restart_block to restart a futex_wait,
+ * we encode in the 'arg3' both futex64 and shared capabilities
+ */
+#define ARG3_FUTEX64 1
+#define ARG3_SHARED  2
+
 static long futex_wait_restart(struct restart_block *restart);
-static int futex_wait(unsigned long __user *uaddr, unsigned long val,
-		      ktime_t *abs_time, int futex64)
+static int futex_wait(unsigned long __user *uaddr, int futex64,
+		      struct rw_semaphore *fshared,
+		      unsigned long val, ktime_t *abs_time)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1402,12 +1465,14 @@ static int futex_wait(unsigned long __us
 	int ret;
 	struct hrtimer_sleeper t, *to = NULL;
 	int rem = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	q.pi_state = NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, fsize, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1430,8 +1495,8 @@ static int futex_wait(unsigned long __us
 	 * a wakeup when *uaddr != val on entry to the syscall.  This is
 	 * rare, but normal.
 	 *
-	 * We hold the mmap semaphore, so the mapping cannot have changed
-	 * since we looked it up in get_futex_key.
+	 * for shared futexes, we hold the mmap semaphore, so the mapping
+	 * cannot have changed since we looked it up in get_futex_key.
 	 */
 	ret = get_futex_value_locked(&uval, uaddr, futex64);
 
@@ -1442,7 +1507,8 @@ static int futex_wait(unsigned long __us
 		 * If we would have faulted, release mmap_sem, fault it in and
 		 * start all over again.
 		 */
-		up_read(&curr->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
 		ret = futex_get_user(&uval, uaddr, futex64);
 
 		if (!ret)
@@ -1468,7 +1534,8 @@ static int futex_wait(unsigned long __us
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	/*
 	 * There might have been scheduling since the queue_me(), as we
@@ -1568,7 +1635,8 @@ static int futex_wait(unsigned long __us
 			}
 			/* Unqueue and drop the lock */
 			unqueue_me_pi(&q);
-			up_read(&curr->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
 		}
 
 		debug_rt_mutex_free_waiter(&q.waiter);
@@ -1597,7 +1665,13 @@ static int futex_wait(unsigned long __us
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = val;
 		restart->arg2 = (unsigned long)abs_time;
-		restart->arg3 = (unsigned long)futex64;
+		restart->arg3 = 0;
+#ifdef CONFIG_64BIT
+		if (futex64)
+			restart->arg3 |= ARG3_FUTEX64;
+#endif
+		if (fshared)
+			restart->arg3 |= ARG3_SHARED;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1605,7 +1679,8 @@ static int futex_wait(unsigned long __us
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
 
@@ -1615,10 +1690,17 @@ static long futex_wait_restart(struct re
 	unsigned long __user *uaddr = (unsigned long __user *)restart->arg0;
 	unsigned long val = restart->arg1;
 	ktime_t *abs_time = (ktime_t *)restart->arg2;
-	int futex64 = (int)restart->arg3;
+	int futex64 = 0;
+	struct rw_semaphore *fshared = NULL;
 
+#ifdef CONFIG_64BIT
+	if (restart->arg3 & ARG3_FUTEX64)
+		futex64 = 1;
+#endif
+	if (restart->arg3 & ARG3_SHARED)
+		fshared = &current->mm->mmap_sem;
 	restart->fn = do_no_restart_syscall;
-	return (long)futex_wait(uaddr, val, abs_time, futex64);
+	return (long)futex_wait(uaddr, futex64, fshared, val, abs_time);
 }
 
 
@@ -1674,7 +1756,7 @@ static void set_pi_futex_owner(struct fu
  * races the kernel might see a 0 value of the futex too.)
  */
 static int futex_lock_pi(unsigned long __user *uaddr, int detect, ktime_t *time,
-			 int trylock, int futex64)
+			 int trylock, int futex64, struct rw_semaphore *fshared)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
@@ -1682,6 +1764,7 @@ static int futex_lock_pi(unsigned long _
 	unsigned long uval, newval, curval;
 	struct futex_q q;
 	int ret, lock_held, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1695,9 +1778,10 @@ static int futex_lock_pi(unsigned long _
 
 	q.pi_state = NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, fsize, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1818,7 +1902,8 @@ static int futex_lock_pi(unsigned long _
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	WARN_ON(!q.pi_state);
 	/*
@@ -1832,7 +1917,8 @@ static int futex_lock_pi(unsigned long _
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
 
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 	spin_lock(q.lock_ptr);
 
 	/*
@@ -1854,7 +1940,8 @@ static int futex_lock_pi(unsigned long _
 		}
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q);
-		up_read(&curr->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
 	}
 
 	if (!detect && ret == -EDEADLK && 0)
@@ -1866,7 +1953,8 @@ static int futex_lock_pi(unsigned long _
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 
  uaddr_faulted:
@@ -1877,15 +1965,16 @@ static int futex_lock_pi(unsigned long _
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
@@ -1899,7 +1988,8 @@ static int futex_lock_pi(unsigned long _
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(unsigned long __user *uaddr, int futex64)
+static int futex_unlock_pi(unsigned long __user *uaddr, int futex64,
+	struct rw_semaphore *fshared)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -1907,6 +1997,7 @@ static int futex_unlock_pi(unsigned long
 	struct plist_head *head;
 	union futex_key key;
 	int ret, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 retry:
 	if (futex_get_user(&uval, uaddr, futex64))
@@ -1919,9 +2010,10 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(uaddr, fsize, fshared, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1980,7 +2072,8 @@ retry_locked:
 out_unlock:
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 
 	return ret;
 
@@ -1992,15 +2085,16 @@ pi_faulted:
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
@@ -2052,6 +2146,7 @@ static int futex_fd(u32 __user *uaddr, i
 	struct futex_q *q;
 	struct file *filp;
 	int ret, err;
+	struct rw_semaphore *fshared;
 	static unsigned long printk_interval;
 
 	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
@@ -2093,11 +2188,12 @@ static int futex_fd(u32 __user *uaddr, i
 	}
 	q->pi_state = NULL;
 
-	down_read(&current->mm->mmap_sem);
-	err = get_futex_key(uaddr, &q->key);
+	fshared = &current->mm->mmap_sem;
+	down_read(fshared);
+	err = get_futex_key(uaddr, sizeof(u32), fshared, &q->key);
 
 	if (unlikely(err != 0)) {
-		up_read(&current->mm->mmap_sem);
+		up_read(fshared);
 		kfree(q);
 		goto error;
 	}
@@ -2109,7 +2205,7 @@ static int futex_fd(u32 __user *uaddr, i
 	filp->private_data = q;
 
 	queue_me(q, ret, filp);
-	up_read(&current->mm->mmap_sem);
+	up_read(fshared);
 
 	/* Now we map fd to filp, so userspace can access it */
 	fd_install(ret, filp);
@@ -2238,7 +2334,8 @@ retry:
 		 */
 		if (!pi) {
 			if (uval & FUTEX_WAITERS)
-				futex_wake((unsigned long __user *)uaddr, 1);
+				futex_wake((unsigned long __user *)uaddr,
+					   0, &curr->mm->mmap_sem, 1);
 		}
 	}
 	return 0;
@@ -2326,13 +2423,18 @@ long do_futex(unsigned long __user *uadd
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
-		ret = futex_wait(uaddr, val, timeout, fut64);
+		ret = futex_wait(uaddr, fut64, fshared, val, timeout);
 		break;
 	case FUTEX_WAKE:
-		ret = futex_wake(uaddr, val);
+		ret = futex_wake(uaddr, fut64, fshared, val);
 		break;
 	case FUTEX_FD:
 		if (fut64)
@@ -2342,25 +2444,29 @@ long do_futex(unsigned long __user *uadd
 			ret = futex_fd((u32 __user *)uaddr, val);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL, fut64);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL, fut64,
+				    fshared);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, fut64);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, fut64,
+				    fshared);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3, fut64);
+		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3, fut64,
+				    fshared);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, val, timeout, 0, fut64);
+		ret = futex_lock_pi(uaddr, val, timeout, 0, fut64, fshared);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret = futex_unlock_pi(uaddr, fut64);
+		ret = futex_unlock_pi(uaddr, fut64, fshared);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, 0, timeout, 1, fut64);
+		ret = futex_lock_pi(uaddr, 0, timeout, 1, fut64, fshared);
 		break;
 	case FUTEX_CMP_REQUEUE_PI:
-		ret = futex_requeue_pi(uaddr, uaddr2, val, val2, &val3, fut64);
+		ret = futex_requeue_pi(uaddr, uaddr2, val, val2, &val3, fut64,
+				       fshared);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -2377,23 +2483,24 @@ sys_futex64(u64 __user *uaddr, int op, u
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
 	u64 val2 = 0;
+	cmd opm = op & FUTEX_CMD_MASK;
 
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
@@ -2409,23 +2516,24 @@ asmlinkage long sys_futex(u32 __user *ua
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
 	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
 	 */
-	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
-	    || op == FUTEX_CMP_REQUEUE_PI)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE
+	    || cmd == FUTEX_CMP_REQUEUE_PI)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex((unsigned long __user*)uaddr, op, val, tp,
