Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYEaB2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYEaB2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYEaB1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:27:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYEaB13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:27:29 -0400
Date: Fri, 30 May 2008 21:27:21 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805310127.m4V1RL96013813@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] 64-bit futexes: generic code
Cc: akpm@linux-foundation.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the architecture independent changes.  For this it has to
adjust the futex_atomic_op_inuser function in arch-specific code but this
in no real code change.  That function is inlined for most architectures.

The real changes depend on the definition of a single type: futex_val_t.
If the arcitecture defines this type to something at least as large as u64
then all the 64-bit futex code is automagically enabled.  If the type is
not defined sufficiently using the FUTEX_64_FLAG flag triggers an ENOSYS
error.

We already have a flag supported for futexes, the private flag.  When it
was introduced a pointer to a semaphore for the memory handling was passed
around.  I changed that.  Now the flags are passed in a word and the
semaphore is located in every function.  This might have added a minute
fraction of code but

- there is no runtime difference for this since the semaphore address
  is still only computed once

- the compiler now has more insight into when no semaphore is used and
  it can perform more optimization (see the futex_lock_mm definition).

- the restart handling is cleaned up a bit as well, as a consequence

The overall code size increase is minute, as can be guessed from the diffstat
numbers below.  Must of the changes are changes to existing code and not
new code.


 arch/frv/kernel/futex.c     |    2 
 include/asm-frv/futex.h     |    2 
 include/asm-generic/futex.h |    2 
 include/asm-ia64/futex.h    |    2 
 include/asm-mips/futex.h    |    2 
 include/asm-parisc/futex.h  |    2 
 include/asm-powerpc/futex.h |    3 
 include/asm-s390/futex.h    |    3 
 include/asm-sh/futex.h      |    3 
 include/asm-sparc64/futex.h |    3 
 include/asm-x86/futex.h     |    3 
 include/linux/futex.h       |   16 +++
 include/linux/syscalls.h    |    6 -
 include/linux/thread_info.h |    6 -
 include/linux/types.h       |    4 
 kernel/futex.c              |  180 +++++++++++++++++++++++++-------------------
 kernel/futex_compat.c       |    5 +
 17 files changed, 149 insertions(+), 95 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/frv/kernel/futex.c b/arch/frv/kernel/futex.c
index 14f64b0..272cbd5 100644
--- a/arch/frv/kernel/futex.c
+++ b/arch/frv/kernel/futex.c
@@ -186,7 +186,7 @@ static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr, int *_o
 /*
  * do the futex operations
  */
-int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+int futex_atomic_op_inuser(int encoded_op, int __user *uaddr, int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-frv/futex.h b/include/asm-frv/futex.h
index 08b3d1d..4b4579e 100644
--- a/include/asm-frv/futex.h
+++ b/include/asm-frv/futex.h
@@ -7,7 +7,7 @@
 #include <asm/errno.h>
 #include <asm/uaccess.h>
 
-extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr);
+extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr, int flags);
 
 static inline int
 futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
index 3c2344f..3bc5c6a 100644
--- a/include/asm-generic/futex.h
+++ b/include/asm-generic/futex.h
@@ -6,7 +6,7 @@
 #include <asm/errno.h>
 
 static inline int
-futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser (int encoded_op, int __user *uaddr, int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-ia64/futex.h b/include/asm-ia64/futex.h
index c7f0f06..aedc609 100644
--- a/include/asm-ia64/futex.h
+++ b/include/asm-ia64/futex.h
@@ -46,7 +46,7 @@ do {									\
 } while (0)
 
 static inline int
-futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser (int encoded_op, int __user *uaddr, int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-mips/futex.h b/include/asm-mips/futex.h
index b9cce90..9fc8ab2 100644
--- a/include/asm-mips/futex.h
+++ b/include/asm-mips/futex.h
@@ -75,7 +75,7 @@
 }
 
 static inline int
-futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser(int encoded_op, int __user *uaddr, int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-parisc/futex.h b/include/asm-parisc/futex.h
index 0c705c3..b485a89 100644
--- a/include/asm-parisc/futex.h
+++ b/include/asm-parisc/futex.h
@@ -8,7 +8,7 @@
 #include <asm/errno.h>
 
 static inline int
-futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser (int encoded_op, int __user *uaddr, int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-powerpc/futex.h b/include/asm-powerpc/futex.h
index 6d406c5..b830055 100644
--- a/include/asm-powerpc/futex.h
+++ b/include/asm-powerpc/futex.h
@@ -30,7 +30,8 @@
 	: "b" (uaddr), "i" (-EFAULT), "1" (oparg) \
 	: "cr0", "memory")
 
-static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr,
+					  int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-s390/futex.h b/include/asm-s390/futex.h
index 5c5d02d..81cb5cf 100644
--- a/include/asm-s390/futex.h
+++ b/include/asm-s390/futex.h
@@ -7,7 +7,8 @@
 #include <linux/uaccess.h>
 #include <asm/errno.h>
 
-static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr,
+					  int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-sh/futex.h b/include/asm-sh/futex.h
index 68256ec..70656d0 100644
--- a/include/asm-sh/futex.h
+++ b/include/asm-sh/futex.h
@@ -10,7 +10,8 @@
 /* XXX: UP variants, fix for SH-4A and SMP.. */
 #include <asm/futex-irq.h>
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr,
+					 int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-sparc64/futex.h b/include/asm-sparc64/futex.h
index d837893..235dd57 100644
--- a/include/asm-sparc64/futex.h
+++ b/include/asm-sparc64/futex.h
@@ -30,7 +30,8 @@
 	: "r" (uaddr), "r" (oparg), "i" (-EFAULT)	\
 	: "memory")
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr,
+					 int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/asm-x86/futex.h b/include/asm-x86/futex.h
index e7a76b3..7c53d4c 100644
--- a/include/asm-x86/futex.h
+++ b/include/asm-x86/futex.h
@@ -37,7 +37,8 @@
 		       "+m" (*uaddr), "=&r" (tem)		\
 		     : "r" (oparg), "i" (-EFAULT), "1" (0))
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr,
+					 int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 586ab56..1658df4 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -25,7 +25,8 @@ union ktime;
 #define FUTEX_WAKE_BITSET	10
 
 #define FUTEX_PRIVATE_FLAG	128
-#define FUTEX_CMD_MASK		~FUTEX_PRIVATE_FLAG
+#define FUTEX_64_FLAG		256
+#define FUTEX_CMD_MASK		~(FUTEX_PRIVATE_FLAG | FUTEX_64_FLAG)
 
 #define FUTEX_WAIT_PRIVATE	(FUTEX_WAIT | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAKE_PRIVATE	(FUTEX_WAKE | FUTEX_PRIVATE_FLAG)
@@ -38,6 +39,9 @@ union ktime;
 #define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
 
+#define FUTEX_64_P(op) \
+	(sizeof(futex_val_t) >= sizeof(u64) && (op & FUTEX_64_FLAG))
+
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.
@@ -122,8 +126,8 @@ struct robust_list_head {
 #define FUTEX_BITSET_MATCH_ANY	0xffffffff
 
 #ifdef __KERNEL__
-long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
-	      u32 __user *uaddr2, u32 val2, u32 val3);
+long do_futex(void __user *uaddr, int op, futex_val_t val, ktime_t *timeout,
+	      void __user *uaddr2, u32 val2, futex_val_t val3);
 
 extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
@@ -183,6 +187,12 @@ static inline void exit_pi_state_list(struct task_struct *curr)
 #define FUTEX_OP_OR		2	/* *(int *)UADDR2 |= OPARG; */
 #define FUTEX_OP_ANDN		3	/* *(int *)UADDR2 &= ~OPARG; */
 #define FUTEX_OP_XOR		4	/* *(int *)UADDR2 ^= OPARG; */
+/* Similar for 64-bit futexes (if supported).  */
+#define FUTEX_OP64_SET		(FUTEX_OP_SET | 8)
+#define FUTEX_OP64_ADD		(FUTEX_OP_ADD | 8)
+#define FUTEX_OP64_OR		(FUTEX_OP_OR | 8)
+#define FUTEX_OP64_ANDN		(FUTEX_OP_ANDN | 8)
+#define FUTEX_OP64_XOR		(FUTEX_OP_XOR | 8)
 
 #define FUTEX_OP_OPARG_SHIFT	8	/* Use (1 << OPARG) instead of OPARG.  */
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..9744533 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -174,9 +174,9 @@ asmlinkage long sys_waitid(int which, pid_t pid,
 			   int options, struct rusage __user *ru);
 asmlinkage long sys_waitpid(pid_t pid, int __user *stat_addr, int options);
 asmlinkage long sys_set_tid_address(int __user *tidptr);
-asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
-			struct timespec __user *utime, u32 __user *uaddr2,
-			u32 val3);
+asmlinkage long sys_futex(void __user *uaddr, int op, unsigned long val,
+			struct timespec __user *utime, void __user *uaddr2,
+			unsigned long val3);
 
 asmlinkage long sys_init_module(void __user *umod, unsigned long len,
 				const char __user *uargs);
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 38a5647..02bfd14 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -23,9 +23,9 @@ struct restart_block {
 		};
 		/* For futex_wait */
 		struct {
-			u32 *uaddr;
-			u32 val;
-			u32 flags;
+			void __user *uaddr;
+			futex_val_t val;
+			int flags;
 			u32 bitset;
 			u64 time;
 		} futex;
diff --git a/include/linux/types.h b/include/linux/types.h
index d4a9ce6..32681fb 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -206,4 +206,8 @@ struct ustat {
 
 #endif	/* __KERNEL__ */
 
+#ifndef __have_futex_val_t
+typedef u32 futex_val_t;
+#endif
+
 #endif /* _LINUX_TYPES_H */
diff --git a/kernel/futex.c b/kernel/futex.c
index 449def8..c3b6dff 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -179,20 +179,21 @@ static inline int match_futex(union futex_key *key1, union futex_key *key2)
  * For other futexes, it points to &current->mm->mmap_sem and
  * caller must have taken the reader lock. but NOT any spinlocks.
  */
-static int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
-			 union futex_key *key)
+static int get_futex_key(void __user *uaddr, struct rw_semaphore *fshared,
+			 union futex_key *key, int flags)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct page *page;
 	int err;
+	const size_t size = FUTEX_64_P(flags) ? sizeof(u64) : sizeof(u32);
 
 	/*
 	 * The futex address must be "naturally" aligned.
 	 */
 	key->both.offset = address % PAGE_SIZE;
-	if (unlikely((address % sizeof(u32)) != 0))
+	if (unlikely((address % size) != 0))
 		return -EINVAL;
 	address -= key->both.offset;
 
@@ -204,7 +205,7 @@ static int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
 	 *        but access_ok() should be faster than find_vma()
 	 */
 	if (!fshared) {
-		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
+		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, size)))
 			return -EFAULT;
 		key->private.mm = mm;
 		key->private.address = address;
@@ -315,12 +316,24 @@ static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
 	return curval;
 }
 
-static int get_futex_value_locked(u32 *dest, u32 __user *from)
+static int get_futex_value_locked(futex_val_t *dest, void __user *from,
+				  int flags)
 {
 	int ret;
 
 	pagefault_disable();
-	ret = __copy_from_user_inatomic(dest, from, sizeof(u32));
+	if (FUTEX_64_P(flags))
+		ret = __copy_from_user_inatomic(dest, (u64 __user *) from,
+						sizeof(u64));
+	else if (sizeof(futex_val_t) == sizeof(u32))
+		ret = __copy_from_user_inatomic(dest, (u32 __user *) from,
+						sizeof(u32));
+	else {
+		u32 d32;
+		ret = __copy_from_user_inatomic(&d32, (u32 __user *) from,
+						sizeof(u32));
+		*dest = d32;
+	}
 	pagefault_enable();
 
 	return ret ? -EFAULT : 0;
@@ -719,21 +732,23 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
-static int futex_wake(u32 __user *uaddr, struct rw_semaphore *fshared,
-		      int nr_wake, u32 bitset)
+static int futex_wake(void __user *uaddr, int flags, int nr_wake, u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	struct plist_head *head;
 	union futex_key key;
+	struct rw_semaphore *fshared;
 	int ret;
 
 	if (!bitset)
 		return -EINVAL;
 
+	fshared = (flags & FUTEX_PRIVATE_FLAG) ? NULL : &current->mm->mmap_sem;
+
 	futex_lock_mm(fshared);
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, fshared, &key, flags);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -769,23 +784,24 @@ out:
  * to this virtual address:
  */
 static int
-futex_wake_op(u32 __user *uaddr1, struct rw_semaphore *fshared,
-	      u32 __user *uaddr2,
+futex_wake_op(void __user *uaddr1, int flags, void __user *uaddr2,
 	      int nr_wake, int nr_wake2, int op)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head;
 	struct futex_q *this, *next;
+	struct rw_semaphore *fshared;
 	int ret, op_ret, attempt = 0;
 
+	fshared = (flags & FUTEX_PRIVATE_FLAG) ? NULL : &current->mm->mmap_sem;
 retryfull:
 	futex_lock_mm(fshared);
 
-	ret = get_futex_key(uaddr1, fshared, &key1);
+	ret = get_futex_key(uaddr1, fshared, &key1, flags);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, fshared, &key2, flags);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -795,7 +811,7 @@ retryfull:
 retry:
 	double_lock_hb(hb1, hb2);
 
-	op_ret = futex_atomic_op_inuser(op, uaddr2);
+	op_ret = futex_atomic_op_inuser(op, uaddr2, flags);
 	if (unlikely(op_ret < 0)) {
 		u32 dummy;
 
@@ -838,7 +854,12 @@ retry:
 		 */
 		futex_unlock_mm(fshared);
 
-		ret = get_user(dummy, uaddr2);
+		/*
+		 * It does not matter here if we are accessing the futex with
+		 * a 32-bit or 64-bit read.  The futex is "naturally" aligned
+		 * and all of it is on the same page.
+		 */
+		ret = get_user(dummy, (u32 __user *) uaddr2);
 		if (ret)
 			return ret;
 
@@ -882,23 +903,24 @@ out:
  * Requeue all waiters hashed on one physical page to another
  * physical page.
  */
-static int futex_requeue(u32 __user *uaddr1, struct rw_semaphore *fshared,
-			 u32 __user *uaddr2,
-			 int nr_wake, int nr_requeue, u32 *cmpval)
+static int futex_requeue(void __user *uaddr1, int flags, void __user *uaddr2,
+			 int nr_wake, int nr_requeue, futex_val_t *cmpval)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head1;
 	struct futex_q *this, *next;
+	struct rw_semaphore *fshared;
 	int ret, drop_count = 0;
 
+	fshared = (flags & FUTEX_PRIVATE_FLAG) ? NULL : &current->mm->mmap_sem;
  retry:
 	futex_lock_mm(fshared);
 
-	ret = get_futex_key(uaddr1, fshared, &key1);
+	ret = get_futex_key(uaddr1, fshared, &key1, flags);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, fshared, &key2, flags);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -908,9 +930,9 @@ static int futex_requeue(u32 __user *uaddr1, struct rw_semaphore *fshared,
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
-		u32 curval;
+		futex_val_t curval;
 
-		ret = get_futex_value_locked(&curval, uaddr1);
+		ret = get_futex_value_locked(&curval, uaddr1, flags);
 
 		if (unlikely(ret)) {
 			spin_unlock(&hb1->lock);
@@ -923,7 +945,13 @@ static int futex_requeue(u32 __user *uaddr1, struct rw_semaphore *fshared,
 			 */
 			futex_unlock_mm(fshared);
 
-			ret = get_user(curval, uaddr1);
+			/*
+			 * It does not matter here if we are accessing
+			 * the futex with a 32-bit or 64-bit read.
+			 * The futex is "naturally" aligned and all of
+			 * it is on the same page.
+			 */
+			ret = get_user(curval, (u32 __user *) uaddr1);
 
 			if (!ret)
 				goto retry;
@@ -1100,7 +1128,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 {
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
-	u32 uval, curval, newval;
+	futex_val_t uval;
 	int ret;
 
 	/* Owner died? */
@@ -1124,9 +1152,11 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	 * TID. This must be atomic as we have preserve the
 	 * owner died bit here.
 	 */
-	ret = get_futex_value_locked(&uval, uaddr);
+	ret = get_futex_value_locked(&uval, uaddr, 0);
 
 	while (!ret) {
+		u32 curval, newval;
+
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 
 		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
@@ -1140,35 +1170,31 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	return ret;
 }
 
-/*
- * In case we must use restart_block to restart a futex_wait,
- * we encode in the 'flags' shared capability
- */
-#define FLAGS_SHARED  1
-
 static long futex_wait_restart(struct restart_block *restart);
 
-static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset)
+static int futex_wait(void __user *uaddr, int flags, futex_val_t val,
+		      ktime_t *abs_time, u32 bitset)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
-	u32 uval;
+	futex_val_t uval;
 	int ret;
 	struct hrtimer_sleeper t;
 	int rem = 0;
+	struct rw_semaphore *fshared;
 
 	if (!bitset)
 		return -EINVAL;
 
 	q.pi_state = NULL;
 	q.bitset = bitset;
+	fshared = (flags & FUTEX_PRIVATE_FLAG) ? NULL : &current->mm->mmap_sem;
  retry:
 	futex_lock_mm(fshared);
 
-	ret = get_futex_key(uaddr, fshared, &q.key);
+	ret = get_futex_key(uaddr, fshared, &q.key, flags);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1194,7 +1220,7 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 	 * for shared futexes, we hold the mmap semaphore, so the mapping
 	 * cannot have changed since we looked it up in get_futex_key.
 	 */
-	ret = get_futex_value_locked(&uval, uaddr);
+	ret = get_futex_value_locked(&uval, uaddr, flags);
 
 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
@@ -1205,7 +1231,12 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		 */
 		futex_unlock_mm(fshared);
 
-		ret = get_user(uval, uaddr);
+		/*
+		 * It does not matter here if we are accessing the futex with
+		 * a 32-bit or 64-bit read.  The futex is "naturally" aligned
+		 * and all of it is on the same page.
+		 */
+		ret = get_user(uval, (u32 __user *) uaddr);
 
 		if (!ret)
 			goto retry;
@@ -1293,14 +1324,12 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		struct restart_block *restart;
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
-		restart->futex.uaddr = (u32 *)uaddr;
+		restart->futex.uaddr = uaddr;
 		restart->futex.val = val;
 		restart->futex.time = abs_time->tv64;
 		restart->futex.bitset = bitset;
-		restart->futex.flags = 0;
+		restart->futex.flags = flags;
 
-		if (fshared)
-			restart->futex.flags |= FLAGS_SHARED;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1315,15 +1344,12 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 static long futex_wait_restart(struct restart_block *restart)
 {
-	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
-	struct rw_semaphore *fshared = NULL;
 	ktime_t t;
 
 	t.tv64 = restart->futex.time;
 	restart->fn = do_no_restart_syscall;
-	if (restart->futex.flags & FLAGS_SHARED)
-		fshared = &current->mm->mmap_sem;
-	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t,
+	return (long)futex_wait(restart->futex.uaddr, restart->futex.flags,
+				restart->futex.val, &t,
 				restart->futex.bitset);
 }
 
@@ -1334,14 +1360,16 @@ static long futex_wait_restart(struct restart_block *restart)
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
+static int futex_lock_pi(u32 __user *uaddr, int flags,
 			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
-	u32 uval, newval, curval;
+	u32 uval, newval;
+	futex_val_t curval;
 	struct futex_q q;
+	struct rw_semaphore *fshared;
 	int ret, lock_taken, ownerdied = 0, attempt = 0;
 
 	if (refill_pi_state_cache())
@@ -1356,10 +1384,11 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 	}
 
 	q.pi_state = NULL;
+	fshared = (flags & FUTEX_PRIVATE_FLAG) ? NULL : &current->mm->mmap_sem;
  retry:
 	futex_lock_mm(fshared);
 
-	ret = get_futex_key(uaddr, fshared, &q.key);
+	ret = get_futex_key(uaddr, fshared, &q.key, 0);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1457,7 +1486,7 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 			 * OWNER_DIED bit is set to figure out whether
 			 * this is a robust futex or not.
 			 */
-			if (get_futex_value_locked(&curval, uaddr))
+		  if (get_futex_value_locked(&curval, uaddr, 0))
 				goto uaddr_faulted;
 
 			/*
@@ -1612,15 +1641,17 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(u32 __user *uaddr, struct rw_semaphore *fshared)
+static int futex_unlock_pi(u32 __user *uaddr, int op)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	u32 uval;
 	struct plist_head *head;
 	union futex_key key;
+	struct rw_semaphore *fshared;
 	int ret, attempt = 0;
 
+	fshared = (op & FUTEX_PRIVATE_FLAG) ? NULL : &current->mm->mmap_sem;
 retry:
 	if (get_user(uval, uaddr))
 		return -EFAULT;
@@ -1634,7 +1665,7 @@ retry:
 	 */
 	futex_lock_mm(fshared);
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, fshared, &key, 0);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1842,8 +1873,7 @@ retry:
 		 * PI futexes happens in exit_pi_state():
 		 */
 		if (!pi && (uval & FUTEX_WAITERS))
-			futex_wake(uaddr, &curr->mm->mmap_sem, 1,
-				   FUTEX_BITSET_MATCH_ANY);
+			futex_wake(uaddr, 0, 1, FUTEX_BITSET_MATCH_ANY);
 	}
 	return 0;
 }
@@ -1934,47 +1964,43 @@ void exit_robust_list(struct task_struct *curr)
 				   curr, pip);
 }
 
-long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
-		u32 __user *uaddr2, u32 val2, u32 val3)
+long do_futex(void __user *uaddr, int op, futex_val_t val, ktime_t *timeout,
+	      void __user *uaddr2, u32 val2, futex_val_t val3)
 {
 	int ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
-	struct rw_semaphore *fshared = NULL;
-
-	if (!(op & FUTEX_PRIVATE_FLAG))
-		fshared = &current->mm->mmap_sem;
 
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
-		ret = futex_wait(uaddr, fshared, val, timeout, val3);
+		ret = futex_wait(uaddr, op, val, timeout, val3);
 		break;
 	case FUTEX_WAKE:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAKE_BITSET:
-		ret = futex_wake(uaddr, fshared, val, val3);
+		ret = futex_wake(uaddr, op, val, val3);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
+		ret = futex_requeue(uaddr, op, uaddr2, val, val2, NULL);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3);
+		ret = futex_requeue(uaddr, op, uaddr2, val, val2, &val3);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
+		ret = futex_wake_op(uaddr, op, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
+		if (futex_cmpxchg_enabled || (op & FUTEX_64_FLAG))
+			ret = futex_lock_pi(uaddr, op, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_unlock_pi(uaddr, fshared);
+		if (futex_cmpxchg_enabled || (op & FUTEX_64_FLAG))
+			ret = futex_unlock_pi(uaddr, op);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
+		if (futex_cmpxchg_enabled || (op & FUTEX_64_FLAG))
+			ret = futex_lock_pi(uaddr, op, 0, timeout, 1);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -1983,15 +2009,19 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 }
 
 
-asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
-			  struct timespec __user *utime, u32 __user *uaddr2,
-			  u32 val3)
+asmlinkage long sys_futex(void __user *uaddr, int op, unsigned long val,
+			  struct timespec __user *utime, void __user *uaddr2,
+			  unsigned long val3)
 {
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
-	u32 val2 = 0;
+	unsigned long val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
 
+	if ((sizeof(unsigned long) < sizeof(u64) ||
+	     sizeof(futex_val_t) < sizeof(u64)) && (op & FUTEX_64_FLAG))
+		return -ENOSYS;
+
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 04ac3a9..cc36d3b 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -176,6 +176,11 @@ asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 	int val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
 
+	/* The compatibility interface is used for 32-bit entry points.
+	   Therefore it is not possible to support 64-bit futexes here.  */
+	if (op & FUTEX_64_FLAG)
+		return -ENOSYS;
+
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET)) {
 		if (get_compat_timespec(&ts, utime))
