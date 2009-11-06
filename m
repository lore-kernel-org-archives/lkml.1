Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbZKFAnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbZKFAnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbZKFAnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:43:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43421 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245AbZKFAmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:11 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Carsten Otte <cotte@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 07/11] sysctl: s390 Use the compat_sys_sysctl
Date: Thu,  5 Nov 2009 16:41:50 -0800
Message-Id: <1257468114-6823-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1tyx8trik.fsf@fess.ebiederm.org>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that we have a generic 32bit compatibility implementation
there is no need for s390 to implement it's own.

Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/s390/kernel/compat_linux.c   |   53 -------------------------------------
 arch/s390/kernel/compat_linux.h   |    2 -
 arch/s390/kernel/compat_wrapper.S |    6 +---
 3 files changed, 2 insertions(+), 59 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 0debcec..fda1a81 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -527,59 +527,6 @@ asmlinkage long sys32_sendfile64(int out_fd, int in_fd,
 	return ret;
 }
 
-#ifdef CONFIG_SYSCTL_SYSCALL
-struct __sysctl_args32 {
-	u32 name;
-	int nlen;
-	u32 oldval;
-	u32 oldlenp;
-	u32 newval;
-	u32 newlen;
-	u32 __unused[4];
-};
-
-asmlinkage long sys32_sysctl(struct __sysctl_args32 __user *args)
-{
-	struct __sysctl_args32 tmp;
-	int error;
-	size_t oldlen;
-	size_t __user *oldlenp = NULL;
-	unsigned long addr = (((unsigned long)&args->__unused[0]) + 7) & ~7;
-
-	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		return -EFAULT;
-
-	if (tmp.oldval && tmp.oldlenp) {
-		/* Duh, this is ugly and might not work if sysctl_args
-		   is in read-only memory, but do_sysctl does indirectly
-		   a lot of uaccess in both directions and we'd have to
-		   basically copy the whole sysctl.c here, and
-		   glibc's __sysctl uses rw memory for the structure
-		   anyway.  */
-		if (get_user(oldlen, (u32 __user *)compat_ptr(tmp.oldlenp)) ||
-		    put_user(oldlen, (size_t __user *)addr))
-			return -EFAULT;
-		oldlenp = (size_t __user *)addr;
-	}
-
-	lock_kernel();
-	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen, compat_ptr(tmp.oldval),
-			  oldlenp, compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
-	if (oldlenp) {
-		if (!error) {
-			if (get_user(oldlen, (size_t __user *)addr) ||
-			    put_user(oldlen, (u32 __user *)compat_ptr(tmp.oldlenp)))
-				error = -EFAULT;
-		}
-		if (copy_to_user(args->__unused, tmp.__unused,
-				 sizeof(tmp.__unused)))
-			error = -EFAULT;
-	}
-	return error;
-}
-#endif
-
 struct stat64_emu31 {
 	unsigned long long  st_dev;
 	unsigned int    __pad1;
diff --git a/arch/s390/kernel/compat_linux.h b/arch/s390/kernel/compat_linux.h
index c07f9ca..45e9092 100644
--- a/arch/s390/kernel/compat_linux.h
+++ b/arch/s390/kernel/compat_linux.h
@@ -162,7 +162,6 @@ struct ucontext32 {
 	compat_sigset_t		uc_sigmask;	/* mask last for extensibility */
 };
 
-struct __sysctl_args32;
 struct stat64_emu31;
 struct mmap_arg_struct_emu31;
 struct fadvise64_64_args;
@@ -212,7 +211,6 @@ long sys32_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
 		    size_t count);
 long sys32_sendfile64(int out_fd, int in_fd, compat_loff_t __user *offset,
 		      s32 count);
-long sys32_sysctl(struct __sysctl_args32 __user *args);
 long sys32_stat64(char __user * filename, struct stat64_emu31 __user * statbuf);
 long sys32_lstat64(char __user * filename,
 		   struct stat64_emu31 __user * statbuf);
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index cbd9901..30de2d0 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -689,8 +689,6 @@ sys32_fdatasync_wrapper:
 	llgfr	%r2,%r2			# unsigned int
 	jg	sys_fdatasync		# branch to system call
 
-#sys32_sysctl_wrapper			# tbd
-
 	.globl	sys32_mlock_wrapper
 sys32_mlock_wrapper:
 	llgfr	%r2,%r2			# unsigned long
@@ -1087,8 +1085,8 @@ sys32_stime_wrapper:
 
 	.globl	sys32_sysctl_wrapper
 sys32_sysctl_wrapper:
-	llgtr	%r2,%r2 		# struct __sysctl_args32 *
-	jg	sys32_sysctl
+	llgtr	%r2,%r2 		# struct compat_sysctl_args *
+	jg	compat_sys_sysctl
 
 	.globl	sys32_fstat64_wrapper
 sys32_fstat64_wrapper:
-- 
1.6.5.2.143.g8cc62

