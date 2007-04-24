Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXDXIJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXDXIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXDXIJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:09:56 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53856 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXDXIJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:09:53 -0400
Message-ID: <462DBABB.6090302@bull.net>
Date: Tue, 24 Apr 2007 10:07:23 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
Cc: Jakub Jelinek <jakub@redhat.com>, akpm@linux-foundation.org, mingo@elte.hu,
       drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
Subject: [PATCH -mm take2] 64bit-futex - provide new commands instead of new
 syscall
References: <20070321095432.207136068@bull.net>	 <20070321100542.438317770@bull.net>	 <20070327110757.GY355@devserv.devel.redhat.com>	 <462CC449.6090004@bull.net> <a36005b50704230830p2a4d55e2i61627b00788cd4d2@mail.gmail.com>
In-Reply-To: <a36005b50704230830p2a4d55e2i61627b00788cd4d2@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/04/2007 10:12:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/04/2007 10:12:35,
	Serialize complete at 24/04/2007 10:12:35
Content-Type: multipart/mixed;
 boundary="------------060409020701080109040803"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060409020701080109040803
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Ulrich Drepper a écrit :
> 
> It looks mostly good.  I wouldn't use the high bit to differentiate
> the 64-bit operations, though.  Since we do not allow to apply it to
> all operations the only effect will be that the compiler has a harder
> time generating the code for the switch statement.  If you use
> continuous values a simple jump table can be used and no conditionals.
> Smaller and faster.
> 

Something like that may be...

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>


-- 
Pierre

--------------060409020701080109040803
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="futex-64bits-command.patch"
Content-Disposition: inline;
 filename="futex-64bits-command.patch"

---
 include/asm-ia64/futex.h    |    8 -
 include/asm-powerpc/futex.h |    6 -
 include/asm-s390/futex.h    |    8 -
 include/asm-sparc64/futex.h |    8 -
 include/asm-um/futex.h      |    9 -
 include/asm-x86_64/futex.h  |   86 ------------------
 include/asm-x86_64/unistd.h |    2 
 include/linux/futex.h       |    6 +
 include/linux/syscalls.h    |    3 
 kernel/futex.c              |  203 ++++++++++++++++++--------------------------
 kernel/futex_compat.c       |    2 
 kernel/sys_ni.c             |    1 
 12 files changed, 95 insertions(+), 247 deletions(-)

Index: b/include/asm-ia64/futex.h
===================================================================
--- a/include/asm-ia64/futex.h
+++ b/include/asm-ia64/futex.h
@@ -124,13 +124,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 static inline u64
 futex_atomic_cmpxchg_inatomic64(u64 __user *uaddr, u64 oldval, u64 newval)
 {
-	return 0;
-}
-
-static inline int
-futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
-{
-	return 0;
+	return -ENOSYS;
 }
 
 #endif /* _ASM_FUTEX_H */
Index: b/include/asm-powerpc/futex.h
===================================================================
--- a/include/asm-powerpc/futex.h
+++ b/include/asm-powerpc/futex.h
@@ -119,11 +119,5 @@ futex_atomic_cmpxchg_inatomic64(u64 __us
 	return 0;
 }
 
-static inline int
-futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
-{
-	return 0;
-}
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_FUTEX_H */
Index: b/include/asm-s390/futex.h
===================================================================
--- a/include/asm-s390/futex.h
+++ b/include/asm-s390/futex.h
@@ -51,13 +51,7 @@ static inline int futex_atomic_cmpxchg_i
 static inline u64
 futex_atomic_cmpxchg_inatomic64(u64 __user *uaddr, u64 oldval, u64 newval)
 {
-	return 0;
-}
-
-static inline int
-futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
-{
-	return 0;
+	return -ENOSYS;
 }
 
 #endif /* __KERNEL__ */
Index: b/include/asm-sparc64/futex.h
===================================================================
--- a/include/asm-sparc64/futex.h
+++ b/include/asm-sparc64/futex.h
@@ -108,13 +108,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 static inline u64
 futex_atomic_cmpxchg_inatomic64(u64 __user *uaddr, u64 oldval, u64 newval)
 {
-	return 0;
-}
-
-static inline int
-futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
-{
-	return 0;
+	return -ENOSYS;
 }
 
 #endif /* !(_SPARC64_FUTEX_H) */
Index: b/include/asm-um/futex.h
===================================================================
--- a/include/asm-um/futex.h
+++ b/include/asm-um/futex.h
@@ -6,14 +6,7 @@
 static inline u64
 futex_atomic_cmpxchg_inatomic64(u64 __user *uaddr, u64 oldval, u64 newval)
 {
-	return 0;
+	return -ENOSYS;
 }
 
-static inline int
-futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
-{
-	return 0;
-}
-
-
 #endif
Index: b/include/asm-x86_64/futex.h
===================================================================
--- a/include/asm-x86_64/futex.h
+++ b/include/asm-x86_64/futex.h
@@ -41,38 +41,6 @@
 	  "=&r" (tem)						\
 	: "r" (oparg), "i" (-EFAULT), "m" (*uaddr), "1" (0))
 
-#define __futex_atomic_op1_64(insn, ret, oldval, uaddr, oparg) \
-  __asm__ __volatile (						\
-"1:	" insn "\n"						\
-"2:	.section .fixup,\"ax\"\n\
-3:	movq	%3, %1\n\
-	jmp	2b\n\
-	.previous\n\
-	.section __ex_table,\"a\"\n\
-	.align	8\n\
-	.quad	1b,3b\n\
-	.previous"						\
-	: "=r" (oldval), "=r" (ret), "=m" (*uaddr)		\
-	: "i" (-EFAULT), "m" (*uaddr), "0" (oparg), "1" (0))
-
-#define __futex_atomic_op2_64(insn, ret, oldval, uaddr, oparg) \
-  __asm__ __volatile (						\
-"1:	movq	%2, %0\n\
-	movq	%0, %3\n"					\
-	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgq %3, %2\n\
-	jnz	1b\n\
-3:	.section .fixup,\"ax\"\n\
-4:	movq	%5, %1\n\
-	jmp	3b\n\
-	.previous\n\
-	.section __ex_table,\"a\"\n\
-	.align	8\n\
-	.quad	1b,4b,2b,4b\n\
-	.previous"						\
-	: "=&a" (oldval), "=&r" (ret), "=m" (*uaddr),		\
-	  "=&r" (tem)						\
-	: "r" (oparg), "i" (-EFAULT), "m" (*uaddr), "1" (0))
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
@@ -128,60 +96,6 @@ futex_atomic_op_inuser (int encoded_op, 
 }
 
 static inline int
-futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
-{
-	int op = (encoded_op >> 28) & 7;
-	int cmp = (encoded_op >> 24) & 15;
-	u64 oparg = (encoded_op << 8) >> 20;
-	u64 cmparg = (encoded_op << 20) >> 20;
-	u64 oldval = 0, ret, tem;
-
-	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
-		oparg = 1 << oparg;
-
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u64)))
-		return -EFAULT;
-
-	inc_preempt_count();
-
-	switch (op) {
-	case FUTEX_OP_SET:
-		__futex_atomic_op1_64("xchgq %0, %2", ret, oldval, uaddr, oparg);
-		break;
-	case FUTEX_OP_ADD:
-		__futex_atomic_op1_64(LOCK_PREFIX "xaddq %0, %2", ret, oldval,
-				   uaddr, oparg);
-		break;
-	case FUTEX_OP_OR:
-		__futex_atomic_op2_64("orq %4, %3", ret, oldval, uaddr, oparg);
-		break;
-	case FUTEX_OP_ANDN:
-		__futex_atomic_op2_64("andq %4, %3", ret, oldval, uaddr, ~oparg);
-		break;
-	case FUTEX_OP_XOR:
-		__futex_atomic_op2_64("xorq %4, %3", ret, oldval, uaddr, oparg);
-		break;
-	default:
-		ret = -ENOSYS;
-	}
-
-	dec_preempt_count();
-
-	if (!ret) {
-		switch (cmp) {
-		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
-		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
-		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
-		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
-		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
-		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
-		default: ret = -ENOSYS;
-		}
-	}
-	return ret;
-}
-
-static inline int
 futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 {
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
Index: b/include/asm-x86_64/unistd.h
===================================================================
--- a/include/asm-x86_64/unistd.h
+++ b/include/asm-x86_64/unistd.h
@@ -619,8 +619,6 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
-#define __NR_futex64		280
-__SYSCALL(__NR_futex64, sys_futex64)
 #define __NR_signalfd		281
 __SYSCALL(__NR_signalfd, sys_signalfd)
 #define __NR_timerfd		282
Index: b/include/linux/futex.h
===================================================================
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -18,6 +18,10 @@ union ktime;
 #define FUTEX_UNLOCK_PI		7
 #define FUTEX_TRYLOCK_PI	8
 #define FUTEX_CMP_REQUEUE_PI	9
+#ifdef CONFIG_64BIT
+#define FUTEX_WAIT64		10
+#define FUTEX_CMP_REQUEUE64	11
+#endif
 
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
@@ -104,7 +108,7 @@ struct robust_list_head {
 #ifdef __KERNEL__
 long do_futex(unsigned long __user *uaddr, int op, unsigned long val,
 	      union ktime *timeout, unsigned long __user *uaddr2,
-	      unsigned long val2, unsigned long val3, int futex64);
+	      unsigned long val2, unsigned long val3);
 
 extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
Index: b/include/linux/syscalls.h
===================================================================
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -178,9 +178,6 @@ asmlinkage long sys_set_tid_address(int 
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 			struct timespec __user *utime, u32 __user *uaddr2,
 			u32 val3);
-asmlinkage long sys_futex64(u64 __user *uaddr, int op, u64 val,
-			struct timespec __user *utime, u64 __user *uaddr2,
-			u64 val3);
 
 asmlinkage long sys_init_module(void __user *umod, unsigned long len,
 				const char __user *uargs);
Index: b/kernel/futex.c
===================================================================
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -62,20 +62,6 @@
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 #ifdef CONFIG_64BIT
-static inline unsigned long
-futex_cmpxchg_inatomic(unsigned long __user *uaddr, unsigned long oldval,
-		       unsigned long newval, int futex64)
-{
-	if (futex64)
-		return futex_atomic_cmpxchg_inatomic64((u64 __user *)uaddr,
-						       oldval, newval);
-	else {
-		u32 ov = oldval, nv = newval;
-		return futex_atomic_cmpxchg_inatomic((int __user *)uaddr, ov,
-						     nv);
-	}
-}
-
 static inline int
 futex_get_user(unsigned long *val, unsigned long __user *uaddr, int futex64)
 {
@@ -92,11 +78,7 @@ futex_get_user(unsigned long *val, unsig
 }
 
 #else
-#define futex_cmpxchg_inatomic(uaddr, oldval, newval, futex64)	\
-	futex_atomic_cmpxchg_inatomic((u32*)uaddr, oldval, newval)
-
 #define futex_get_user(val, uaddr, futex64) get_user(*val, uaddr)
-
 #endif
 
 /*
@@ -606,12 +588,12 @@ static void wake_futex(struct futex_q *q
 	q->lock_ptr = NULL;
 }
 
-static int wake_futex_pi(unsigned long __user *uaddr, unsigned long uval,
-			 struct futex_q *this, int futex64)
+static int wake_futex_pi(u32 __user *uaddr, unsigned long uval,
+			 struct futex_q *this)
 {
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
-	unsigned long curval, newval;
+	u32 curval, newval;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -639,7 +621,7 @@ static int wake_futex_pi(unsigned long _
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
 
 		pagefault_disable();
-		curval = futex_cmpxchg_inatomic(uaddr, uval, newval, futex64);
+		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
 		pagefault_enable();
 		if (curval == -EFAULT)
 			return -EFAULT;
@@ -664,17 +646,16 @@ static int wake_futex_pi(unsigned long _
 	return 0;
 }
 
-static int unlock_futex_pi(unsigned long __user *uaddr, unsigned long uval,
-			   int futex64)
+static int unlock_futex_pi(u32 __user *uaddr, unsigned long uval)
 {
-	unsigned long oldval;
+	u32 oldval;
 
 	/*
 	 * There is no waiter, so we unlock the futex. The owner died
 	 * bit has not to be preserved here. We are the owner:
 	 */
 	pagefault_disable();
-	oldval = futex_cmpxchg_inatomic(uaddr, uval, 0, futex64);
+	oldval = futex_atomic_cmpxchg_inatomic(uaddr, uval, 0);
 	pagefault_enable();
 
 	if (oldval == -EFAULT)
@@ -748,19 +729,20 @@ out:
  * or create a new one without owner.
  */
 static inline int
-lookup_pi_state_for_requeue(unsigned long __user *uaddr,
+lookup_pi_state_for_requeue(u32 __user *uaddr,
 			    struct futex_hash_bucket *hb,
 			    union futex_key *key,
-			    struct futex_pi_state **pi_state, int futex64)
+			    struct futex_pi_state **pi_state)
 {
-	unsigned long curval, uval, newval;
+	u32 curval, uval, newval;
 
 retry:
 	/*
 	 * We can't handle a fault cleanly because we can't
 	 * release the locks here. Simply return the fault.
 	 */
-	if (get_futex_value_locked(&curval, uaddr, futex64))
+	if (get_futex_value_locked((unsigned long *)&curval,
+				   (unsigned long __user *)uaddr, 0))
 		return -EFAULT;
 
 	/* set the flags FUTEX_WAITERS and FUTEX_WAITER_REQUEUED */
@@ -774,7 +756,7 @@ retry:
 		newval = uval | FUTEX_WAITERS | FUTEX_WAITER_REQUEUED;
 
 		pagefault_disable();
-		curval = futex_cmpxchg_inatomic(uaddr, uval, newval, futex64);
+		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
 		pagefault_enable();
 
 		if (unlikely(curval == -EFAULT))
@@ -806,8 +788,8 @@ retry:
  * one physical page to another physical page (PI-futex uaddr2)
  */
 static int
-futex_requeue_pi(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-		 int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64)
+futex_requeue_pi(u32 __user *uaddr1, u32 __user *uaddr2,
+		 int nr_wake, int nr_requeue, unsigned long *cmpval)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -840,9 +822,10 @@ retry:
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
-		unsigned long curval;
+		u32 curval;
 
-		ret = get_futex_value_locked(&curval, uaddr1, futex64);
+		ret = get_futex_value_locked((unsigned long*)&curval,
+					     (unsigned long __user *)uaddr1, 0);
 
 		if (unlikely(ret)) {
 			spin_unlock(&hb1->lock);
@@ -855,7 +838,7 @@ retry:
 			 */
 			up_read(&current->mm->mmap_sem);
 
-			ret = futex_get_user(&curval, uaddr1, futex64);
+			ret = get_user(curval, uaddr1);
 
 			if (!ret)
 				goto retry;
@@ -882,8 +865,7 @@ retry:
 				int s;
 				/* do this only the first time we requeue someone */
 				s = lookup_pi_state_for_requeue(uaddr2, hb2,
-								&key2, &pi_state2,
-								futex64);
+								&key2, &pi_state2);
 				if (s) {
 					ret = s;
 					goto out_unlock;
@@ -998,7 +980,7 @@ out:
  */
 static int
 futex_wake_op(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
-	      int nr_wake, int nr_wake2, int op, int futex64)
+	      int nr_wake, int nr_wake2, int op)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -1022,16 +1004,10 @@ retryfull:
 retry:
 	double_lock_hb(hb1, hb2);
 
-#ifdef CONFIG_64BIT
-	if (futex64)
-		op_ret = futex_atomic_op_inuser64(op, (u64 __user *)uaddr2);
-	else
-		op_ret = futex_atomic_op_inuser(op, (int __user *)uaddr2);
-#else
 	op_ret = futex_atomic_op_inuser(op, (int __user *)uaddr2);
-#endif
+
 	if (unlikely(op_ret < 0)) {
-		unsigned long dummy;
+		u32 dummy;
 
 		spin_unlock(&hb1->lock);
 		if (hb1 != hb2)
@@ -1073,7 +1049,7 @@ retry:
 		 */
 		up_read(&current->mm->mmap_sem);
 
-		ret = futex_get_user(&dummy, uaddr2, futex64);
+		ret = get_user(dummy, uaddr2);
 		if (ret)
 			return ret;
 
@@ -1379,8 +1355,18 @@ static int fixup_pi_state_owner(unsigned
 	while (!ret) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
-		curval = futex_cmpxchg_inatomic(uaddr,uval,
-						newval, futex64);
+#ifdef CONFIG_64BIT
+		if (futex64)
+			curval = futex_atomic_cmpxchg_inatomic64(
+				                       (u64 __user *)uaddr,
+						       uval, newval);
+		else
+#endif
+			curval = futex_atomic_cmpxchg_inatomic(
+				                       (u32 __user *)uaddr,
+						       (u32)uval,
+						       (u32)newval);
+
 		if (curval == -EFAULT)
  			ret = -EFAULT;
 		if (curval == uval)
@@ -1673,13 +1659,13 @@ static void set_pi_futex_owner(struct fu
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(unsigned long __user *uaddr, int detect, ktime_t *time,
-			 int trylock, int futex64)
+static int futex_lock_pi(u32 __user *uaddr, int detect, ktime_t *time,
+			 int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
-	unsigned long uval, newval, curval;
+	u32 uval, newval, curval;
 	struct futex_q q;
 	int ret, lock_held, attempt = 0;
 
@@ -1714,7 +1700,7 @@ static int futex_lock_pi(unsigned long _
 	newval = current->pid;
 
 	pagefault_disable();
-	curval = futex_cmpxchg_inatomic(uaddr, 0, newval, futex64);
+	curval = futex_atomic_cmpxchg_inatomic(uaddr, 0, newval);
 	pagefault_enable();
 
 	if (unlikely(curval == -EFAULT))
@@ -1759,7 +1745,7 @@ static int futex_lock_pi(unsigned long _
 		newval = curval | FUTEX_WAITERS;
 
 	pagefault_disable();
-	curval = futex_cmpxchg_inatomic(uaddr, uval, newval, futex64);
+	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
 	pagefault_enable();
 
 	if (unlikely(curval == -EFAULT))
@@ -1796,8 +1782,8 @@ static int futex_lock_pi(unsigned long _
 				FUTEX_OWNER_DIED | FUTEX_WAITERS;
 
 			pagefault_disable();
-			curval = futex_cmpxchg_inatomic(uaddr, uval,
-							newval, futex64);
+			curval = futex_atomic_cmpxchg_inatomic(uaddr, uval,
+							       newval);
 			pagefault_enable();
 
 			if (unlikely(curval == -EFAULT))
@@ -1841,7 +1827,8 @@ static int futex_lock_pi(unsigned long _
 	 */
 	if (!ret && q.pi_state->owner != curr)
 		/* mmap_sem is unlocked at return of this function */
-		ret = fixup_pi_state_owner(uaddr, &q, hb, curr, futex64);
+		ret = fixup_pi_state_owner((unsigned long  __user *)uaddr,
+					   &q, hb, curr, 0);
 	else {
 		/*
 		 * Catch the rare case, where the lock was released
@@ -1887,7 +1874,7 @@ static int futex_lock_pi(unsigned long _
 	queue_unlock(&q, hb);
 	up_read(&curr->mm->mmap_sem);
 
-	ret = futex_get_user(&uval, uaddr, futex64);
+	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
@@ -1899,17 +1886,17 @@ static int futex_lock_pi(unsigned long _
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(unsigned long __user *uaddr, int futex64)
+static int futex_unlock_pi(u32 __user *uaddr)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	unsigned long uval;
+	u32 uval;
 	struct plist_head *head;
 	union futex_key key;
 	int ret, attempt = 0;
 
 retry:
-	if (futex_get_user(&uval, uaddr, futex64))
+	if (get_user(uval, uaddr))
 		return -EFAULT;
 	/*
 	 * We release only a lock we actually own:
@@ -1936,7 +1923,7 @@ retry_locked:
 	 */
 	if (!(uval & FUTEX_OWNER_DIED)) {
 		pagefault_disable();
-		uval = futex_cmpxchg_inatomic(uaddr, current->pid, 0, futex64);
+		uval = futex_atomic_cmpxchg_inatomic(uaddr, current->pid, 0);
 		pagefault_enable();
 	}
 
@@ -1958,7 +1945,7 @@ retry_locked:
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (!match_futex (&this->key, &key))
 			continue;
-		ret = wake_futex_pi(uaddr, uval, this, futex64);
+		ret = wake_futex_pi(uaddr, uval, this);
 		/*
 		 * The atomic access to the futex value
 		 * generated a pagefault, so retry the
@@ -1972,7 +1959,7 @@ retry_locked:
 	 * No waiters - kernel unlocks the futex:
 	 */
 	if (!(uval & FUTEX_OWNER_DIED)) {
-		ret = unlock_futex_pi(uaddr, uval, futex64);
+		ret = unlock_futex_pi(uaddr, uval);
 		if (ret == -EFAULT)
 			goto pi_faulted;
 	}
@@ -2002,7 +1989,7 @@ pi_faulted:
 	spin_unlock(&hb->lock);
 	up_read(&current->mm->mmap_sem);
 
-	ret = futex_get_user(&uval, uaddr, futex64);
+	ret = get_user(uval, uaddr);
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
@@ -2323,94 +2310,71 @@ void exit_robust_list(struct task_struct
 
 long do_futex(unsigned long __user *uaddr, int op, unsigned long val,
 	      ktime_t *timeout, unsigned long __user *uaddr2,
-	      unsigned long val2, unsigned long val3, int fut64)
+	      unsigned long val2, unsigned long val3)
 {
 	int ret;
 
 	switch (op) {
 	case FUTEX_WAIT:
-		ret = futex_wait(uaddr, val, timeout, fut64);
+		ret = futex_wait(uaddr, val, timeout, 0);
 		break;
 	case FUTEX_WAKE:
 		ret = futex_wake(uaddr, val);
 		break;
 	case FUTEX_FD:
-		if (fut64)
-			ret = -ENOSYS;
-		else
-			/* non-zero val means F_SETOWN(getpid())&F_SETSIG(val) */
-			ret = futex_fd((u32 __user *)uaddr, val);
+		/* non-zero val means F_SETOWN(getpid())&F_SETSIG(val) */
+		ret = futex_fd((u32 __user *)uaddr, val);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL, fut64);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL, 0);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, fut64);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, 0);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3, fut64);
+		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, val, timeout, 0, fut64);
+		ret = futex_lock_pi((u32 __user *)uaddr, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret = futex_unlock_pi(uaddr, fut64);
+		ret = futex_unlock_pi((u32 __user *)uaddr);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, 0, timeout, 1, fut64);
+		ret = futex_lock_pi((u32 __user *)uaddr, 0, timeout, 1);
 		break;
 	case FUTEX_CMP_REQUEUE_PI:
-		ret = futex_requeue_pi(uaddr, uaddr2, val, val2, &val3, fut64);
+		ret = futex_requeue_pi((u32 __user *)uaddr,
+				       (u32 __user *)uaddr2,
+				       val, val2, &val3);
+		break;
+#ifdef CONFIG_64BIT
+	case FUTEX_WAIT64:
+		ret = futex_wait(uaddr, val, timeout, 1);
+		break;
+	case FUTEX_CMP_REQUEUE64:
+		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, 1);
 		break;
+#endif
 	default:
 		ret = -ENOSYS;
 	}
 	return ret;
 }
 
-#ifdef CONFIG_64BIT
-
-asmlinkage long
-sys_futex64(u64 __user *uaddr, int op, u64 val,
-	    struct timespec __user *utime, u64 __user *uaddr2, u64 val3)
-{
-	struct timespec ts;
-	ktime_t t, *tp = NULL;
-	u64 val2 = 0;
-
-	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
-		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
-			return -EFAULT;
-		if (!timespec_valid(&ts))
-			return -EINVAL;
-
-		t = timespec_to_ktime(ts);
-		if (op == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), t);
-		tp = &t;
-	}
-	/*
-	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
-	 */
-	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
-	    || op == FUTEX_CMP_REQUEUE_PI)
-		val2 = (unsigned long) utime;
-
-	return do_futex((unsigned long __user*)uaddr, op, val, tp,
-			(unsigned long __user*)uaddr2, val2, val3, 1);
-}
-
-#endif
-
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 			  struct timespec __user *utime, u32 __user *uaddr2,
 			  u32 val3)
 {
 	struct timespec ts;
 	ktime_t t, *tp = NULL;
-	u32 val2 = 0;
+	unsigned long val2 = 0;
 
-	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
+	if (utime && (op == FUTEX_WAIT
+#ifdef CONFIG_64BIT
+		      || op == FUTEX_WAIT64
+#endif
+		      || op == FUTEX_LOCK_PI)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
@@ -2425,11 +2389,14 @@ asmlinkage long sys_futex(u32 __user *ua
 	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
 	 */
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
+#ifdef CONFIG_64BIT
+	    || op == FUTEX_CMP_REQUEUE64
+#endif
 	    || op == FUTEX_CMP_REQUEUE_PI)
-		val2 = (u32) (unsigned long) utime;
+		val2 = (unsigned long) utime;
 
 	return do_futex((unsigned long __user*)uaddr, op, val, tp,
-			(unsigned long __user*)uaddr2, val2, val3, 0);
+			(unsigned long __user*)uaddr2, val2, val3);
 }
 
 static int futexfs_get_sb(struct file_system_type *fs_type,
Index: b/kernel/futex_compat.c
===================================================================
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -161,5 +161,5 @@ asmlinkage long compat_sys_futex(u32 __u
 		val2 = (int) (unsigned long) utime;
 
 	return do_futex((unsigned long __user*)uaddr, op, val, tp,
-			(unsigned long __user*)uaddr2, val2, val3, 0);
+			(unsigned long __user*)uaddr2, val2, val3);
 }
Index: b/kernel/sys_ni.c
===================================================================
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -41,7 +41,6 @@ cond_syscall(sys_sendmsg);
 cond_syscall(sys_recvmsg);
 cond_syscall(sys_socketcall);
 cond_syscall(sys_futex);
-cond_syscall(sys_futex64);
 cond_syscall(compat_sys_futex);
 cond_syscall(sys_set_robust_list);
 cond_syscall(compat_sys_set_robust_list);

--------------060409020701080109040803--
