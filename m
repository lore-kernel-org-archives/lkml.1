Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZKFAnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZKFAnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759245AbZKFAnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:43:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39328 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247AbZKFAmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:09 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 05/11] sysctl: mips Use the compat_sys_sysctl
Date: Thu,  5 Nov 2009 16:41:48 -0800
Message-Id: <1257468114-6823-5-git-send-email-ebiederm@xmission.com>
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
there is no need for mips to implement it's own.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/mips/kernel/linux32.c     |   61 ----------------------------------------
 arch/mips/kernel/scall64-n32.S |    2 +-
 arch/mips/kernel/scall64-o32.S |    2 +-
 3 files changed, 2 insertions(+), 63 deletions(-)

diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index b77fefa..1a2793e 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -265,67 +265,6 @@ SYSCALL_DEFINE5(n32_msgrcv, int, msqid, u32, msgp, size_t, msgsz,
 }
 #endif
 
-struct sysctl_args32
-{
-	compat_caddr_t name;
-	int nlen;
-	compat_caddr_t oldval;
-	compat_caddr_t oldlenp;
-	compat_caddr_t newval;
-	compat_size_t newlen;
-	unsigned int __unused[4];
-};
-
-#ifdef CONFIG_SYSCTL_SYSCALL
-
-SYSCALL_DEFINE1(32_sysctl, struct sysctl_args32 __user *, args)
-{
-	struct sysctl_args32 tmp;
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
-		if (get_user(oldlen, (u32 __user *)A(tmp.oldlenp)) ||
-		    put_user(oldlen, (size_t __user *)addr))
-			return -EFAULT;
-		oldlenp = (size_t __user *)addr;
-	}
-
-	lock_kernel();
-	error = do_sysctl((int __user *)A(tmp.name), tmp.nlen, (void __user *)A(tmp.oldval),
-			  oldlenp, (void __user *)A(tmp.newval), tmp.newlen);
-	unlock_kernel();
-	if (oldlenp) {
-		if (!error) {
-			if (get_user(oldlen, (size_t __user *)addr) ||
-			    put_user(oldlen, (u32 __user *)A(tmp.oldlenp)))
-				error = -EFAULT;
-		}
-		copy_to_user(args->__unused, tmp.__unused, sizeof(tmp.__unused));
-	}
-	return error;
-}
-
-#else
-
-SYSCALL_DEFINE1(32_sysctl, struct sysctl_args32 __user *, args)
-{
-	return -ENOSYS;
-}
-
-#endif /* CONFIG_SYSCTL_SYSCALL */
-
 SYSCALL_DEFINE1(32_newuname, struct new_utsname __user *, name)
 {
 	int ret = 0;
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index 6ebc079..8a0be0b 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -272,7 +272,7 @@ EXPORT(sysn32_call_table)
 	PTR	sys_munlockall
 	PTR	sys_vhangup			/* 6150 */
 	PTR	sys_pivot_root
-	PTR	sys_32_sysctl
+	PTR	compat_sys_sysctl
 	PTR	sys_prctl
 	PTR	compat_sys_adjtimex
 	PTR	compat_sys_setrlimit		/* 6155 */
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 14dde4c..41dbdb7 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -356,7 +356,7 @@ sys_call_table:
 	PTR	sys_ni_syscall			/* 4150 */
 	PTR	sys_getsid
 	PTR	sys_fdatasync
-	PTR	sys_32_sysctl
+	PTR	compat_sys_sysctl
 	PTR	sys_mlock
 	PTR	sys_munlock			/* 4155 */
 	PTR	sys_mlockall
-- 
1.6.5.2.143.g8cc62

