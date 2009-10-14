Return-Path: <linux-kernel-owner+w=401wt.eu-S934607AbZJNPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbZJNPqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934574AbZJNPqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:46:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:33919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934251AbZJNPqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:46:15 -0400
Date: Wed, 14 Oct 2009 15:45:01 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com, davem@davemloft.net,
       benh@kernel.crashing.org, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, tony.luck@intel.com, davem@davemloft.net,
       benh@kernel.crashing.org, ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20091010153349.925243928@linutronix.de>
References: <20091010153349.925243928@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/core] bkl: pushdown BKL locking to do_sysctl()
Message-ID: <tip-e362106d6dcf6607906eff2260837748b1d6c8d5@git.kernel.org>
Git-Commit-ID: e362106d6dcf6607906eff2260837748b1d6c8d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:45:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e362106d6dcf6607906eff2260837748b1d6c8d5
Gitweb:     http://git.kernel.org/tip/e362106d6dcf6607906eff2260837748b1d6c8d5
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:37:06 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 15:31:41 +0200

bkl: pushdown BKL locking to do_sysctl()

Push lock/unlock_kernel() into do_sysctl() and remove it from all call
sites of do_sysctl().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
LKML-Reference: <20091010153349.925243928@linutronix.de>
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

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index 625ed8f..c0ed49c 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -1670,10 +1670,8 @@ sys32_sysctl (struct sysctl32 __user *args)
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *) &oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user (oldlen, (int __user *) compat_ptr(a32.oldlenp)))
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 6242bc6..3744608 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -302,10 +302,8 @@ SYSCALL_DEFINE1(32_sysctl, struct sysctl_args32 __user *, args)
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)A(tmp.name), tmp.nlen, (void __user *)A(tmp.oldval),
 			  oldlenp, (void __user *)A(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index 561388b..0d3bff2 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -137,11 +137,9 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
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
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index b97c2d6..934c0f9 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -555,11 +555,9 @@ asmlinkage long compat_sys_sysctl(struct __sysctl_args32 __user *args)
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
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 0debcec..ef9c2c1 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -562,10 +562,8 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen, compat_ptr(tmp.oldval),
 			  oldlenp, compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index 04e28b2..6266ef0 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -627,14 +627,12 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
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
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 9f55271..32a88e4 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -477,10 +477,8 @@ asmlinkage long sys32_sysctl(struct sysctl_ia32 __user *args32)
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *)&oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user(oldlen, (int __user *)compat_ptr(a32.oldlenp)))
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..72040e5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1848,6 +1848,8 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
 			return -EFAULT;
 	}
 
+	lock_kernel();
+
 	for (head = sysctl_head_next(NULL); head;
 			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
@@ -1858,6 +1860,8 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
 			break;
 		}
 	}
+
+	unlock_kernel();
 	return error;
 }
 
@@ -1873,10 +1877,8 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 	if (error)
 		goto out;
 
-	lock_kernel();
 	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
 			  tmp.newval, tmp.newlen);
-	unlock_kernel();
 out:
 	return error;
 }
