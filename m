Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbZJJPjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbZJJPjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762016AbZJJPjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:39:10 -0400
Received: from www.tglx.de ([62.245.132.106]:55629 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761860AbZJJPjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:39:02 -0400
Message-Id: <20091010153349.925243928@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:37:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 21/28] bkl: pushdown BKL locking to do_sysctl()
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=push-bkl-to-do-sysctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push lock/unlock_kernel() into do_sysctl() and remove it from all call
sites of do_sysctl().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>

---
 arch/ia64/ia32/sys_ia32.c         |    2 --
 arch/mips/kernel/linux32.c        |    2 --
 arch/parisc/kernel/sys_parisc32.c |    2 --
 arch/powerpc/kernel/sys_ppc32.c   |    2 --
 arch/s390/kernel/compat_linux.c   |    2 --
 arch/sparc/kernel/sys_sparc32.c   |    2 --
 arch/x86/ia32/sys_ia32.c          |    2 --
 kernel/sysctl.c                   |    6 ++++--
 8 files changed, 4 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/arch/ia64/ia32/sys_ia32.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/ia32/sys_ia32.c
+++ linux-2.6-tip/arch/ia64/ia32/sys_ia32.c
@@ -1670,10 +1670,8 @@ sys32_sysctl (struct sysctl32 __user *ar
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *) &oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user (oldlen, (int __user *) compat_ptr(a32.oldlenp)))
Index: linux-2.6-tip/arch/mips/kernel/linux32.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/kernel/linux32.c
+++ linux-2.6-tip/arch/mips/kernel/linux32.c
@@ -302,10 +302,8 @@ SYSCALL_DEFINE1(32_sysctl, struct sysctl
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)A(tmp.name), tmp.nlen, (void __user *)A(tmp.oldval),
 			  oldlenp, (void __user *)A(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
Index: linux-2.6-tip/arch/parisc/kernel/sys_parisc32.c
===================================================================
--- linux-2.6-tip.orig/arch/parisc/kernel/sys_parisc32.c
+++ linux-2.6-tip/arch/parisc/kernel/sys_parisc32.c
@@ -137,11 +137,9 @@ asmlinkage long sys32_sysctl(struct __sy
 		oldlenp = (size_t *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)(u64)tmp.name, tmp.nlen,
 			  (void __user *)(u64)tmp.oldval, oldlenp,
 			  (void __user *)(u64)tmp.newval, tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t *)addr)) {
Index: linux-2.6-tip/arch/powerpc/kernel/sys_ppc32.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/sys_ppc32.c
+++ linux-2.6-tip/arch/powerpc/kernel/sys_ppc32.c
@@ -555,11 +555,9 @@ asmlinkage long compat_sys_sysctl(struct
 			return -EFAULT;
 	}
 
-	lock_kernel();
 	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen,
 			  compat_ptr(tmp.oldval), oldlenp,
 			  compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, oldlenp) ||
Index: linux-2.6-tip/arch/s390/kernel/compat_linux.c
===================================================================
--- linux-2.6-tip.orig/arch/s390/kernel/compat_linux.c
+++ linux-2.6-tip/arch/s390/kernel/compat_linux.c
@@ -562,10 +562,8 @@ asmlinkage long sys32_sysctl(struct __sy
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen, compat_ptr(tmp.oldval),
 			  oldlenp, compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
Index: linux-2.6-tip/arch/sparc/kernel/sys_sparc32.c
===================================================================
--- linux-2.6-tip.orig/arch/sparc/kernel/sys_sparc32.c
+++ linux-2.6-tip/arch/sparc/kernel/sys_sparc32.c
@@ -627,14 +627,12 @@ asmlinkage long sys32_sysctl(struct __sy
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)(unsigned long) tmp.name,
 			  tmp.nlen,
 			  (void __user *)(unsigned long) tmp.oldval,
 			  oldlenp,
 			  (void __user *)(unsigned long) tmp.newval,
 			  tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
Index: linux-2.6-tip/arch/x86/ia32/sys_ia32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/ia32/sys_ia32.c
+++ linux-2.6-tip/arch/x86/ia32/sys_ia32.c
@@ -477,10 +477,8 @@ asmlinkage long sys32_sysctl(struct sysc
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *)&oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user(oldlen, (int __user *)compat_ptr(a32.oldlenp)))
Index: linux-2.6-tip/kernel/sysctl.c
===================================================================
--- linux-2.6-tip.orig/kernel/sysctl.c
+++ linux-2.6-tip/kernel/sysctl.c
@@ -1848,6 +1848,8 @@ int do_sysctl(int __user *name, int nlen
 			return -EFAULT;
 	}
 
+	lock_kernel();
+
 	for (head = sysctl_head_next(NULL); head;
 			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
@@ -1858,6 +1860,8 @@ int do_sysctl(int __user *name, int nlen
 			break;
 		}
 	}
+
+	unlock_kernel();
 	return error;
 }
 
@@ -1873,10 +1877,8 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_
 	if (error)
 		goto out;
 
-	lock_kernel();
 	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
 			  tmp.newval, tmp.newlen);
-	unlock_kernel();
 out:
 	return error;
 }


