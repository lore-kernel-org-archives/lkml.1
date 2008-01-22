Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbYAVU1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbYAVU1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYAVU1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:27:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:11877 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYAVU1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=BmIFI14rjZD1o/qtUbuB9yJNAsaY+8i9itVLKG0m/YuWUHwuXLXNOoP1AtUruXaNjFM3sBwpNOD+c3IwfZzfmNP9nltW7MViCEwUv/tHzhLz34vqHqB2PMRQDdqDMsVxFiN4l/22rjnSKG6Eup+41gPom2jcyBgCkPavLMfJSm0=
Date: Tue, 22 Jan 2008 23:27:27 +0300
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove BKL from sysctl(2)
Message-ID: <20080122202727.GB1975@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/sys part of sysctl code runs without BKL held, so BKL during
sysctl(2) is useless. Remove misleading comment and "protection" around
coredumping code -- kernel.core_pattern can be written without BKL.

do_sysctl() and lookup in /proc/sys use identical iterators, so any locking
bug BKL supposedly fixed in sysctl(2) code we should have in /proc/sys
code anyway.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/ia64/ia32/sys_ia32.c         |    2 --
 arch/mips/kernel/linux32.c        |    3 ---
 arch/parisc/kernel/sys_parisc32.c |    3 ---
 arch/powerpc/kernel/sys_ppc32.c   |    3 ---
 arch/s390/kernel/compat_linux.c   |    3 ---
 arch/sparc64/kernel/sys_sparc32.c |    3 ---
 arch/x86/ia32/sys_ia32.c          |    3 ---
 fs/exec.c                         |    7 -------
 kernel/sysctl.c                   |    3 ---
 9 files changed, 30 deletions(-)

--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -1991,10 +1991,8 @@ sys32_sysctl (struct sysctl32 __user *args)
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *) &oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user (oldlen, (int __user *) compat_ptr(a32.oldlenp)))
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <linux/highuid.h>
 #include <linux/dirent.h>
 #include <linux/resource.h>
@@ -440,10 +439,8 @@ asmlinkage long sys32_sysctl(struct sysctl_args32 __user *args)
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl((int __user *)A(tmp.name), tmp.nlen, (void __user *)A(tmp.oldval),
 			  oldlenp, (void __user *)A(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -21,7 +21,6 @@
 #include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
@@ -144,11 +143,9 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
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
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -24,7 +24,6 @@
 #include <linux/times.h>
 #include <linux/utsname.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
@@ -714,11 +713,9 @@ asmlinkage long compat_sys_sysctl(struct __sysctl_args32 __user *args)
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
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -26,7 +26,6 @@
 #include <linux/times.h>
 #include <linux/utsname.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
@@ -715,10 +714,8 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
 		oldlenp = (size_t __user *)addr;
 	}
 
-	lock_kernel();
 	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen, compat_ptr(tmp.oldval),
 			  oldlenp, compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
 	if (oldlenp) {
 		if (!error) {
 			if (get_user(oldlen, (size_t __user *)addr) ||
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -18,7 +18,6 @@
 #include <linux/times.h>
 #include <linux/utsname.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
@@ -989,14 +988,12 @@ asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
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
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -30,7 +30,6 @@
 #include <linux/times.h>
 #include <linux/utsname.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/mm.h>
@@ -630,10 +629,8 @@ sys32_sysctl(struct sysctl_ia32 __user *args32)
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-	lock_kernel();
 	ret = do_sysctl(namep, a32.nlen, oldvalp, (size_t __user *)&oldlen,
 			newvalp, (size_t) a32.newlen);
-	unlock_kernel();
 	set_fs(old_fs);
 
 	if (oldvalp && put_user (oldlen, (int __user *)compat_ptr(a32.oldlenp)))
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -28,7 +28,6 @@
 #include <linux/a.out.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -1720,13 +1719,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	/*
-	 * lock_kernel() because format_corename() is controlled by sysctl, which
-	 * uses lock_kernel()
-	 */
- 	lock_kernel();
 	ispipe = format_corename(corename, core_pattern, signr);
-	unlock_kernel();
 	/*
 	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
 	 * to a pipe.  Since we're not writing directly to the filesystem
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -27,7 +27,6 @@
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -1366,10 +1365,8 @@ asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
 	if (error)
 		goto out;
 
-	lock_kernel();
 	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
 			  tmp.newval, tmp.newlen);
-	unlock_kernel();
 out:
 	return error;
 }
