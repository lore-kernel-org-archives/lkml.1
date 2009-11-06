Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbZKFAnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbZKFAnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbZKFAmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:42:10 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43409 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245AbZKFAmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:07 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 03/11] sysctl: Introduce a generic compat sysctl sysctl
Date: Thu,  5 Nov 2009 16:41:46 -0800
Message-Id: <1257468114-6823-3-git-send-email-ebiederm@xmission.com>
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

This uses compat_alloc_userspace to remove the various
hacks to allow do_sysctl to write to throuh oldlenp.

The rest of our mature compat syscall helper facitilies
are used as well to ensure we have a nice clean maintainable
compat syscall that can be used on all architectures.

The motiviation for a generic compat sysctl (besides the
obvious hack removal) is to reduce the number of compat
sysctl defintions out there so I can refactor the
binary sysctl implementation.

ppc already used the name compat_sys_sysctl so I remove the
ppcs version here.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/powerpc/kernel/sys_ppc32.c |   52 ---------------------------------------
 kernel/sysctl_binary.c          |   50 +++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index b97c2d6..c5a4732 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -520,58 +520,6 @@ asmlinkage long compat_sys_umask(u32 mask)
 	return sys_umask((int)mask);
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
-asmlinkage long compat_sys_sysctl(struct __sysctl_args32 __user *args)
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
-		oldlenp = (size_t __user *)addr;
-		if (get_user(oldlen, (compat_size_t __user *)compat_ptr(tmp.oldlenp)) ||
-		    put_user(oldlen, oldlenp))
-			return -EFAULT;
-	}
-
-	lock_kernel();
-	error = do_sysctl(compat_ptr(tmp.name), tmp.nlen,
-			  compat_ptr(tmp.oldval), oldlenp,
-			  compat_ptr(tmp.newval), tmp.newlen);
-	unlock_kernel();
-	if (oldlenp) {
-		if (!error) {
-			if (get_user(oldlen, oldlenp) ||
-			    put_user(oldlen, (compat_size_t __user *)compat_ptr(tmp.oldlenp)))
-				error = -EFAULT;
-		}
-		copy_to_user(args->__unused, tmp.__unused, sizeof(tmp.__unused));
-	}
-	return error;
-}
-#endif
-
 unsigned long compat_sys_mmap2(unsigned long addr, size_t len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff)
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index c5cc393..a2fed5b 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -175,3 +175,53 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 
 	return error;
 }
+
+#ifdef CONFIG_COMPAT
+#include <asm/compat.h>
+
+struct compat_sysctl_args {
+	compat_uptr_t	name;
+	int		nlen;
+	compat_uptr_t	oldval;
+	compat_uptr_t	oldlenp;
+	compat_uptr_t	newval;
+	compat_size_t	newlen;
+	compat_ulong_t	__unused[4];
+};
+
+asmlinkage long compat_sys_sysctl(struct compat_sysctl_args __user *args)
+{
+	struct compat_sysctl_args tmp;
+	compat_size_t __user *compat_oldlenp;
+	size_t __user *oldlenp = NULL;
+	size_t oldlen = 0;
+	ssize_t result;
+
+	if (copy_from_user(&tmp, args, sizeof(tmp)))
+		return -EFAULT;
+
+	compat_oldlenp = compat_ptr(tmp.oldlenp);
+	if (compat_oldlenp) {
+		oldlenp = compat_alloc_user_space(sizeof(*compat_oldlenp));
+
+		if (get_user(oldlen, compat_oldlenp) ||
+		    put_user(oldlen, oldlenp))
+			return -EFAULT;
+	}
+
+	lock_kernel();
+	result = do_sysctl(compat_ptr(tmp.name), tmp.nlen,
+			   compat_ptr(tmp.oldval), oldlenp,
+			   compat_ptr(tmp.newval), tmp.newlen);
+	unlock_kernel();
+
+	if (oldlenp && !result) {
+		if (get_user(oldlen, oldlenp) ||
+		    put_user(oldlen, compat_oldlenp))
+			return -EFAULT;
+	}
+
+	return result;
+}
+
+#endif /* CONFIG_COMPAT */
-- 
1.6.5.2.143.g8cc62

