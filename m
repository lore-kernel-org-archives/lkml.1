Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbYB0Ase@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbYB0Ase (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932907AbYB0AsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:48:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50946
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932825AbYB0AsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:48:16 -0500
Date: Tue, 26 Feb 2008 16:49:00 -0800 (PST)
Message-Id: <20080226.164900.193701385.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc3 hangs in early boot on Sun Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18371.54294.748777.976300@harpo.it.uu.se>
References: <18371.10207.58819.188510@alkaid.it.uu.se>
	<18371.54294.748777.976300@harpo.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Tue, 26 Feb 2008 09:55:50 +0100

> Minor update: rc2-git7 has the slow initial console behaviour,
> but successfully switches to the framebuffer. rc2-git8 however
> hangs in the console handover. So I'll bisect git7->git8 next.

Between the VT layer registering it's console and the atyfb
driver initializing we get a crash, and it happens on all
sparc64 systems.  It is caused by this commit and I am working
on a fix:

commit a0c1e9073ef7428a14309cba010633a6cd6719ea
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Feb 23 15:23:57 2008 -0800

    futex: runtime enable pi and robust functionality
    
    Not all architectures implement futex_atomic_cmpxchg_inatomic().  The default
    implementation returns -ENOSYS, which is currently not handled inside of the
    futex guts.
    
    Futex PI calls and robust list exits with a held futex result in an endless
    loop in the futex code on architectures which have no support.
    
    Fixing up every place where futex_atomic_cmpxchg_inatomic() is called would
    add a fair amount of extra if/else constructs to the already complex code.  It
    is also not possible to disable the robust feature before user space tries to
    register robust lists.
    
    Compile time disabling is not a good idea either, as there are already
    architectures with runtime detection of futex_atomic_cmpxchg_inatomic support.
    
    Detect the functionality at runtime instead by calling
    cmpxchg_futex_value_locked() with a NULL pointer from the futex initialization
    code.  This is guaranteed to fail, but the call of
    futex_atomic_cmpxchg_inatomic() happens with pagefaults disabled.
    
    On architectures, which use the asm-generic implementation or have a runtime
    CPU feature detection, a -ENOSYS return value disables the PI/robust features.
    
    On architectures with a working implementation the call returns -EFAULT and
    the PI/robust features are enabled.
    
    The relevant syscalls return -ENOSYS and the robust list exit code is blocked,
    when the detection fails.
    
    Fixes http://lkml.org/lkml/2008/2/11/149
    Originally reported by: Lennart Buytenhek
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Cc: Lennert Buytenhek <buytenh@wantstofly.org>
    Cc: Riku Voipio <riku.voipio@movial.fi>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 90048fb..586ab56 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -167,6 +167,7 @@ union futex_key {
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
+extern int futex_cmpxchg_enabled;
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
diff --git a/kernel/futex.c b/kernel/futex.c
index c21f667..06968cd 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -60,6 +60,8 @@
 
 #include "rtmutex_common.h"
 
+int __read_mostly futex_cmpxchg_enabled;
+
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
@@ -469,6 +471,8 @@ void exit_pi_state_list(struct task_struct *curr)
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
@@ -1894,6 +1900,9 @@ sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 	struct robust_list_head __user *head;
 	unsigned long ret;
 
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (!pid)
 		head = current->robust_list;
 	else {
@@ -1997,6 +2006,9 @@ void exit_robust_list(struct task_struct *curr)
 	unsigned long futex_offset;
 	int rc;
 
+	if (!futex_cmpxchg_enabled)
+		return;
+
 	/*
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
@@ -2051,7 +2063,7 @@ void exit_robust_list(struct task_struct *curr)
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int ret;
+	int ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
 	struct rw_semaphore *fshared = NULL;
 
@@ -2083,13 +2095,16 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
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
@@ -2145,8 +2160,23 @@ static struct file_system_type futex_fs_type = {
 
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
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 7d5e4b0..ff90f04 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -54,6 +54,9 @@ void compat_exit_robust_list(struct task_struct *curr)
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
 
@@ -130,6 +136,9 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
 
+	if (!futex_cmpxchg_enabled)
+		return -ENOSYS;
+
 	if (!pid)
 		head = current->compat_robust_list;
 	else {
