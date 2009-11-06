Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbZKFAmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbZKFAmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbZKFAmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:42:13 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43418 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251AbZKFAmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:11 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Thibaut Varene <T-Bone@parisc-linux.org>
Subject: [PATCH 06/11] sysctl: parisc Use the compat_sys_sysctl
Date: Thu,  5 Nov 2009 16:41:49 -0800
Message-Id: <1257468114-6823-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1tyx8trik.fsf@fess.ebiederm.org>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that we have a generic 32bit compatibility implementation
there is no need for parisc to implement it's own.

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Thibaut Varene <T-Bone@parisc-linux.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/parisc/kernel/sys_parisc32.c  |   71 ------------------------------------
 arch/parisc/kernel/syscall_table.S |    2 +-
 2 files changed, 1 insertions(+), 72 deletions(-)

diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index 561388b..76d23ec 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -90,77 +90,6 @@ asmlinkage long sys32_unimplemented(int r26, int r25, int r24, int r23,
     return -ENOSYS;
 }
 
-#ifdef CONFIG_SYSCTL
-
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
-#ifndef CONFIG_SYSCTL_SYSCALL
-	return -ENOSYS;
-#else
-	struct __sysctl_args32 tmp;
-	int error;
-	unsigned int oldlen32;
-	size_t oldlen, __user *oldlenp = NULL;
-	unsigned long addr = (((long __force)&args->__unused[0]) + 7) & ~7;
-
-	DBG(("sysctl32(%p)\n", args));
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
-		/* a possibly better hack than this, which will avoid the
-		 * problem if the struct is read only, is to push the
-		 * 'oldlen' value out to the user's stack instead. -PB
-		 */
-		if (get_user(oldlen32, (u32 *)(u64)tmp.oldlenp))
-			return -EFAULT;
-		oldlen = oldlen32;
-		if (put_user(oldlen, (size_t *)addr))
-			return -EFAULT;
-		oldlenp = (size_t *)addr;
-	}
-
-	lock_kernel();
-	error = do_sysctl((int __user *)(u64)tmp.name, tmp.nlen,
-			  (void __user *)(u64)tmp.oldval, oldlenp,
-			  (void __user *)(u64)tmp.newval, tmp.newlen);
-	unlock_kernel();
-	if (oldlenp) {
-		if (!error) {
-			if (get_user(oldlen, (size_t *)addr)) {
-				error = -EFAULT;
-			} else {
-				oldlen32 = oldlen;
-				if (put_user(oldlen32, (u32 *)(u64)tmp.oldlenp))
-					error = -EFAULT;
-			}
-		}
-		if (copy_to_user(args->__unused, tmp.__unused, sizeof(tmp.__unused)))
-			error = -EFAULT;
-	}
-	return error;
-#endif
-}
-
-#endif /* CONFIG_SYSCTL */
-
 asmlinkage long sys32_sched_rr_get_interval(pid_t pid,
 	struct compat_timespec __user *interval)
 {
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index 843f423..01c4fcf 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -234,7 +234,7 @@
 	ENTRY_SAME(getsid)
 	ENTRY_SAME(fdatasync)
 	/* struct __sysctl_args is a mess */
-	ENTRY_DIFF(sysctl)
+	ENTRY_COMP(sysctl)
 	ENTRY_SAME(mlock)		/* 150 */
 	ENTRY_SAME(munlock)
 	ENTRY_SAME(mlockall)
-- 
1.6.5.2.143.g8cc62

