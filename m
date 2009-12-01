Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZLAItY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZLAItY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZLAItX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:49:23 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35713 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbZLAItV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:49:21 -0500
Date: Tue, 1 Dec 2009 14:19:24 +0530
From: Sripathi Kodi <sripathik@in.ibm.com>
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [RFC] [PATCH 1/2] Futex fault injection: Add fault points
Message-ID: <20091201141924.430cff68@sripathi>
In-Reply-To: <20091201141642.398e7b7d@sripathi>
References: <20091201141642.398e7b7d@sripathi>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds fault points into futex code.

Thanks,
Sripathi.


Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

---

Index: linux-2.6.32-rc8/kernel/futex.c
===================================================================
--- linux-2.6.32-rc8.orig/kernel/futex.c	2009-11-30 12:21:49.000000000 +0530
+++ linux-2.6.32-rc8/kernel/futex.c	2009-11-30 14:06:05.000000000 +0530
@@ -59,6 +59,7 @@
 #include <linux/magic.h>
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
+#include <linux/fault-inject.h>
 
 #include <asm/futex.h>
 
@@ -198,6 +199,42 @@
 	}
 }
 
+DECLARE_FAULT_ATTR(fail_futex_efault);
+
+#ifdef CONFIG_FAIL_FUTEX_EFAULT
+
+static int __init setup_fail_futex_efault(char *str)
+{
+	return setup_fault_attr(&fail_futex_efault, str);
+}
+__setup("fail_futex_efault=", setup_fail_futex_efault);
+
+#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
+
+static int __init fail_futex_efault_debugfs(void)
+{
+	return init_fault_attr_dentries(&fail_futex_efault, "fail_futex_efault");
+}
+late_initcall(fail_futex_efault_debugfs);
+
+#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
+
+bool futex_should_fail(struct fault_attr *attr, ssize_t size)
+{
+	if (should_fail(attr, 1))
+		return true;
+
+	return false;
+}
+
+#else /* CONFIG_FAIL_FUTEX_EFAULT */
+inline bool futex_should_fail(struct fault_attr *attr, ssize_t size)
+{
+	return false;
+}
+
+#endif /* CONFIG_FAIL_FUTEX_EFAULT */
+
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
@@ -239,6 +276,10 @@
 	 *        but access_ok() should be faster than find_vma()
 	 */
 	if (!fshared) {
+
+		if (futex_should_fail(&fail_futex_efault, 1))
+			return -EFAULT;
+
 		if (unlikely(!access_ok(rw, uaddr, sizeof(u32))))
 			return -EFAULT;
 		key->private.mm = mm;
@@ -248,6 +289,10 @@
 	}
 
 again:
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	err = get_user_pages_fast(address, 1, rw == VERIFY_WRITE, &page);
 	if (err < 0)
 		return err;
@@ -304,7 +349,12 @@
  */
 static int fault_in_user_writeable(u32 __user *uaddr)
 {
-	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
+	int ret;
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
+	ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
 				 1, 1, 0, NULL, NULL);
 	return ret < 0 ? ret : 0;
 }
@@ -332,6 +382,9 @@
 {
 	u32 curval;
 
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	pagefault_disable();
 	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
 	pagefault_enable();
@@ -343,6 +396,9 @@
 {
 	int ret;
 
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	pagefault_disable();
 	ret = __copy_from_user_inatomic(dest, from, sizeof(u32));
 	pagefault_enable();
@@ -919,7 +975,15 @@
 
 retry_private:
 	double_lock_hb(hb1, hb2);
-	op_ret = futex_atomic_op_inuser(op, uaddr2);
+
+	op_ret = 0;
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		op_ret = -EFAULT;
+
+	if (op_ret == 0)
+		op_ret = futex_atomic_op_inuser(op, uaddr2);
+
 	if (unlikely(op_ret < 0)) {
 
 		double_unlock_hb(hb1, hb2);
@@ -2009,6 +2073,10 @@
 	int ret;
 
 retry:
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	if (get_user(uval, uaddr))
 		return -EFAULT;
 	/*
@@ -2383,6 +2451,10 @@
 		rcu_read_unlock();
 	}
 
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(head, head_ptr);
@@ -2417,6 +2489,10 @@
 		 * userspace.
 		 */
 		mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
+
+		if (futex_should_fail(&fail_futex_efault, 1))
+			return -1;
+
 		nval = futex_atomic_cmpxchg_inatomic(uaddr, uval, mval);
 
 		if (nval == -EFAULT)
@@ -2444,6 +2520,9 @@
 {
 	unsigned long uentry;
 
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	if (get_user(uentry, (unsigned long __user *)head))
 		return -EFAULT;
 
@@ -2479,6 +2558,10 @@
 	/*
 	 * Fetch the relative futex offset:
 	 */
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return;
+
 	if (get_user(futex_offset, &head->futex_offset))
 		return;
 	/*
@@ -2596,6 +2679,10 @@
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
+
+		if (futex_should_fail(&fail_futex_efault, 1))
+			return -EFAULT;
+
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
Index: linux-2.6.32-rc8/kernel/futex_compat.c
===================================================================
--- linux-2.6.32-rc8.orig/kernel/futex_compat.c	2009-11-30 12:21:49.000000000 +0530
+++ linux-2.6.32-rc8/kernel/futex_compat.c	2009-11-30 14:06:05.000000000 +0530
@@ -10,6 +10,7 @@
 #include <linux/compat.h>
 #include <linux/nsproxy.h>
 #include <linux/futex.h>
+#include <linux/fault-inject.h>
 
 #include <asm/uaccess.h>
 
@@ -21,6 +22,10 @@
 fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
 		   compat_uptr_t __user *head, int *pi)
 {
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	if (get_user(*uentry, head))
 		return -EFAULT;
 
@@ -66,6 +71,10 @@
 	/*
 	 * Fetch the relative futex offset:
 	 */
+
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return;
+
 	if (get_user(futex_offset, &head->futex_offset))
 		return;
 	/*
@@ -160,6 +169,9 @@
 		read_unlock(&tasklist_lock);
 	}
 
+	if (futex_should_fail(&fail_futex_efault, 1))
+		return -EFAULT;
+
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(ptr_to_compat(head), head_ptr);
@@ -182,6 +194,10 @@
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
 		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
+
+		if (futex_should_fail(&fail_futex_efault, 1))
+			return -EFAULT;
+
 		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
Index: linux-2.6.32-rc8/include/linux/futex.h
===================================================================
--- linux-2.6.32-rc8.orig/include/linux/futex.h	2009-11-30 12:21:49.000000000 +0530
+++ linux-2.6.32-rc8/include/linux/futex.h	2009-11-30 12:43:14.000000000 +0530
@@ -213,3 +213,6 @@
    | ((oparg & 0xfff) << 12) | (cmparg & 0xfff))
 
 #endif
+
+extern struct fault_attr fail_futex_efault;
+extern bool futex_should_fail(struct fault_attr *attr, ssize_t size);
