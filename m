Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZKFAnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZKFAnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbZKFAnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:43:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43425 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253AbZKFAmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:11 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 08/11] sysctl: sparc Use the compat_sys_sysctl
Date: Thu,  5 Nov 2009 16:41:51 -0800
Message-Id: <1257468114-6823-8-git-send-email-ebiederm@xmission.com>
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
there is no need for sparc to implement it's own.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/sparc/kernel/sys_sparc32.c |   57 ---------------------------------------
 arch/sparc/kernel/systbls_64.S  |    2 +-
 2 files changed, 1 insertions(+), 58 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index 04e28b2..f862372 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -591,63 +591,6 @@ out:
 	return ret;       
 }
 
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
-	size_t oldlen, __user *oldlenp = NULL;
-	unsigned long addr = (((unsigned long)&args->__unused[0]) + 7UL) & ~7UL;
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
-		if (get_user(oldlen, (u32 __user *)(unsigned long)tmp.oldlenp) ||
-		    put_user(oldlen, (size_t __user *)addr))
-			return -EFAULT;
-		oldlenp = (size_t __user *)addr;
-	}
-
-	lock_kernel();
-	error = do_sysctl((int __user *)(unsigned long) tmp.name,
-			  tmp.nlen,
-			  (void __user *)(unsigned long) tmp.oldval,
-			  oldlenp,
-			  (void __user *)(unsigned long) tmp.newval,
-			  tmp.newlen);
-	unlock_kernel();
-	if (oldlenp) {
-		if (!error) {
-			if (get_user(oldlen, (size_t __user *)addr) ||
-			    put_user(oldlen, (u32 __user *)(unsigned long) tmp.oldlenp))
-				error = -EFAULT;
-		}
-		if (copy_to_user(args->__unused, tmp.__unused, sizeof(tmp.__unused)))
-			error = -EFAULT;
-	}
-	return error;
-#endif
-}
-
 long sys32_lookup_dcookie(unsigned long cookie_high,
 			  unsigned long cookie_low,
 			  char __user *buf, size_t len)
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 009825f..034b10e 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -68,7 +68,7 @@ sys_call_table32:
 	.word compat_sys_fstatfs64, sys_llseek, sys_mlock, sys_munlock, sys32_mlockall
 /*240*/	.word sys_munlockall, sys32_sched_setparam, sys32_sched_getparam, sys32_sched_setscheduler, sys32_sched_getscheduler
 	.word sys_sched_yield, sys32_sched_get_priority_max, sys32_sched_get_priority_min, sys32_sched_rr_get_interval, compat_sys_nanosleep
-/*250*/	.word sys32_mremap, sys32_sysctl, sys32_getsid, sys_fdatasync, sys32_nfsservctl
+/*250*/	.word sys32_mremap, compat_sys_sysctl, sys32_getsid, sys_fdatasync, sys32_nfsservctl
 	.word sys32_sync_file_range, compat_sys_clock_settime, compat_sys_clock_gettime, compat_sys_clock_getres, sys32_clock_nanosleep
 /*260*/	.word compat_sys_sched_getaffinity, compat_sys_sched_setaffinity, sys32_timer_settime, compat_sys_timer_gettime, sys_timer_getoverrun
 	.word sys_timer_delete, compat_sys_timer_create, sys_ni_syscall, compat_sys_io_setup, sys_io_destroy
-- 
1.6.5.2.143.g8cc62

