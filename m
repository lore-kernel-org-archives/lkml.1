Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbYBOBiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbYBOBiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYBOBhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:37:51 -0500
Received: from www.tglx.de ([62.245.132.106]:37064 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYBOBhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:37:50 -0500
Date: Fri, 15 Feb 2008 02:36:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: adrian.bunk@movial.fi, mingo@elte.hu, linux-kernel@vger.kernel.org,
       riku.voipio@movial.fi, mikpe@it.uu.se, buytenh@wantstofly.org,
       rusty@rustcorp.com.au, stable@kernel.org
Subject: [PATCH 2/2] futex: runtime enable pi and robust functionality
In-Reply-To: <alpine.LFD.1.00.0802150216350.12988@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0802150223390.12988@apollo.tec.linutronix.de>
References: <20080211130700.GF27537@movial.fi> <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de> <20080214134642.600282f1.akpm@linux-foundation.org> <alpine.LFD.1.00.0802150216350.12988@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all architectures implement futex_atomic_cmpxchg_inatomic(). The
default implementation returns -ENOSYS, which is currently not handled
inside of the futex guts. 

Futex PI calls and robust list exits with a held futex result in an
endless loop in the futex code on architectures which have no support.

Fixing up every place where futex_atomic_cmpxchg_inatomic() is called
would add a fair amount of extra if/else constructs to the already
complex code. It is also not possible to disable the robust feature
before user space tries to register robust lists.

Compile time disabling is not a good idea either, as there are already
architectures with runtime detection of futex_atomic_cmpxchg_inatomic
support.

Detect the functionality at runtime instead by calling
cmpxchg_futex_value_locked() with a NULL pointer from the futex
initialization code. This is guaranteed to fail, but the call of
futex_atomic_cmpxchg_inatomic() happens with pagefaults disabled. 

On architectures, which use the asm-generic implementation or have a
runtime CPU feature detection, a -ENOSYS return value disables the
PI/robust features.

On architectures with a working implementation the call returns
-EFAULT and the PI/robust features are enabled.

The relevant syscalls return -ENOSYS and the robust list exit code is
blocked, when the detection fails.

Fixes http://lkml.org/lkml/2008/2/11/149
Originally reported by: Lennart Buytenhek

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org

---
 include/linux/futex.h |    1 +
 kernel/futex.c        |   38 ++++++++++++++++++++++++++++++++++----
 kernel/futex_compat.c |    9 +++++++++
 3 files changed, 44 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/futex.h
===================================================================
--- linux-2.6.orig/include/linux/futex.h
+++ linux-2.6/include/linux/futex.h
@@ -167,6 +167,7 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
+extern int futex_cmpxchg_enabled;
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -60,6 +60,8 @@
 
 #include "rtmutex_common.h"
 
+int __read_mostly futex_cmpxchg_enabled;
+
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
@@ -469,6 +471,8 @@ void exit_pi_state_list(struct task_stru
 	struct futex_hash_bucket *hb;
 	union futex_key key;
 
+	if (!futex_cmpxchg_enabled)
+		return;
 	/*
 	 * We are a ZOMBIE and nobody can enqueue itself on
 	 * pi_state_list anymore, but we have to be careful
@@ -1870,6 +1874,8 @@ asmlinkage long
 sys_set_robust_list(struct robust_list_head __user *head,
 		    size_t len)
 {
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
 	/*
 	 * The kernel knows only one size for now:
 	 */
@@ -1894,6 +1900,9 @@ sys_get_robust_list(int pid, struct robu
 	struct robust_list_head __user *head;
 	unsigned long ret;
 
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (!pid)
 		head = current->robust_list;
 	else {
@@ -1997,6 +2006,9 @@ void exit_robust_list(struct task_struct
 	unsigned long futex_offset;
 	int rc;
 
+	if (!futex_cmpxchg_enabled)
+		return;
+
 	/*
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
@@ -2051,7 +2063,7 @@ void exit_robust_list(struct task_struct
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int ret;
+	int ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
 	struct rw_semaphore *fshared = NULL;
 
@@ -2083,13 +2095,16 @@ long do_futex(u32 __user *uaddr, int op,
 		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
+		if (futex_cmpxchg_enabled)
+			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret = futex_unlock_pi(uaddr, fshared);
+		if (futex_cmpxchg_enabled)
+			ret = futex_unlock_pi(uaddr, fshared);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
+		if (futex_cmpxchg_enabled)
+			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -2145,8 +2160,23 @@ static struct file_system_type futex_fs_
 
 static int __init init(void)
 {
+	u32 curval;
 	int i;
 
+	/*
+	 * This will fail and we want it. Some arch implementations do
+	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
+	 * functionality. We want to know that before we call in any
+	 * of the complex code paths. Also we want to prevent
+	 * registration of robust lists in that case. NULL is
+	 * guaranteed to fault and we get -EFAULT on functional
+	 * implementation, the non functional ones will return
+	 * -ENOSYS.
+	 */
+	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
+	if (curval == -EFAULT)
+		futex_cmpxchg_enabled = 1;
+
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
 		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
 		spin_lock_init(&futex_queues[i].lock);
Index: linux-2.6/kernel/futex_compat.c
===================================================================
--- linux-2.6.orig/kernel/futex_compat.c
+++ linux-2.6/kernel/futex_compat.c
@@ -54,6 +54,9 @@ void compat_exit_robust_list(struct task
 	compat_long_t futex_offset;
 	int rc;
 
+	if (!futex_cmpxchg_enabled)
+		return;
+
 	/*
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
@@ -115,6 +118,9 @@ asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 			   compat_size_t len)
 {
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (unlikely(len != sizeof(*head)))
 		return -EINVAL;
 
@@ -130,6 +136,9 @@ compat_sys_get_robust_list(int pid, comp
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
 
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (!pid)
 		head = current->compat_robust_list;
 	else {
