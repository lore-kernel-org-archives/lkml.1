Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbZKFAmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbZKFAmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbZKFAmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:42:12 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39322 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191AbZKFAmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:06 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 02/11] sysctl: Refactor the binary sysctl handling to remove duplicate code
Date: Thu,  5 Nov 2009 16:41:45 -0800
Message-Id: <1257468114-6823-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1tyx8trik.fsf@fess.ebiederm.org>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Read in the binary sysctl path once, instead of reread it
from user space each time the code needs to access a path
element.

The deprecated sysctl warning is moved to do_sysctl so
that the compat_sysctl entries syscalls will also warn.

The return of -ENOSYS when !CONFIG_SYSCTL_SYSCALL is moved
to binary_sysctl.  Always leaving a do_sysctl available
that handles !CONFIG_SYSCTL_SYSCALL and printing the
deprecated sysctl warning allows for a single defitition
of the sysctl syscall.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl_binary.c |  123 ++++++++++++++++++++++-------------------------
 1 files changed, 58 insertions(+), 65 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 2431653..c5cc393 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -13,8 +13,6 @@
 #include <linux/file.h>
 #include <linux/ctype.h>
 
-static int deprecated_sysctl_warning(struct __sysctl_args *args);
-
 #ifdef CONFIG_SYSCTL_SYSCALL
 
 /* Perform the actual read/write of a sysctl table entry. */
@@ -50,7 +48,7 @@ static int do_sysctl_strategy(struct ctl_table_root *root,
 	return 0;
 }
 
-static int parse_table(int __user *name, int nlen,
+static int parse_table(const int *name, int nlen,
 		       void __user *oldval, size_t __user *oldlenp,
 		       void __user *newval, size_t newlen,
 		       struct ctl_table_root *root,
@@ -60,8 +58,7 @@ static int parse_table(int __user *name, int nlen,
 repeat:
 	if (!nlen)
 		return -ENOTDIR;
-	if (get_user(n, name))
-		return -EFAULT;
+	n = *name;
 	for ( ; table->ctl_name || table->procname; table++) {
 		if (!table->ctl_name)
 			continue;
@@ -84,19 +81,13 @@ repeat:
 	return -ENOTDIR;
 }
 
-int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
-	       void __user *newval, size_t newlen)
+static ssize_t binary_sysctl(const int *name, int nlen,
+	void __user *oldval, size_t __user *oldlenp,
+	void __user *newval, size_t newlen)
+
 {
 	struct ctl_table_header *head;
-	int error = -ENOTDIR;
-
-	if (nlen <= 0 || nlen >= CTL_MAXNAME)
-		return -ENOTDIR;
-	if (oldval) {
-		int old_len;
-		if (!oldlenp || get_user(old_len, oldlenp))
-			return -EFAULT;
-	}
+	ssize_t error = -ENOTDIR;
 
 	for (head = sysctl_head_next(NULL); head;
 			head = sysctl_head_next(head)) {
@@ -111,74 +102,76 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
 	return error;
 }
 
-SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
-{
-	struct __sysctl_args tmp;
-	int error;
-
-	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		return -EFAULT;
-
-	error = deprecated_sysctl_warning(&tmp);
-	if (error)
-		goto out;
-
-	lock_kernel();
-	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
-			  tmp.newval, tmp.newlen);
-	unlock_kernel();
-out:
-	return error;
-}
-
 #else /* CONFIG_SYSCTL_SYSCALL */
 
-SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
+static ssize_t binary_sysctl(const int *ctl_name, int nlen,
+	void __user *oldval, size_t __user *oldlenp,
+	void __user *newval, size_t newlen)
 {
-	struct __sysctl_args tmp;
-	int error;
-
-	if (copy_from_user(&tmp, args, sizeof(tmp)))
-		return -EFAULT;
-
-	error = deprecated_sysctl_warning(&tmp);
-
-	/* If no error reading the parameters then just -ENOSYS ... */
-	if (!error)
-		error = -ENOSYS;
-
-	return error;
+	return -ENOSYS;
 }
 
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
-static int deprecated_sysctl_warning(struct __sysctl_args *args)
+static void deprecated_sysctl_warning(const int *name, int nlen)
 {
 	static int msg_count;
-	int name[CTL_MAXNAME];
 	int i;
 
-	/* Check args->nlen. */
-	if (args->nlen < 0 || args->nlen > CTL_MAXNAME)
-		return -ENOTDIR;
-
-	/* Read in the sysctl name for better debug message logging */
-	for (i = 0; i < args->nlen; i++)
-		if (get_user(name[i], args->name + i))
-			return -EFAULT;
-
 	/* Ignore accesses to kernel.version */
-	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
-		return 0;
+	if ((nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
+		return;
 
 	if (msg_count < 5) {
 		msg_count++;
 		printk(KERN_INFO
 			"warning: process `%s' used the deprecated sysctl "
 			"system call with ", current->comm);
-		for (i = 0; i < args->nlen; i++)
+		for (i = 0; i < nlen; i++)
 			printk("%d.", name[i]);
 		printk("\n");
 	}
-	return 0;
+	return;
+}
+
+int do_sysctl(int __user *args_name, int nlen,
+	void __user *oldval, size_t __user *oldlenp,
+	void __user *newval, size_t newlen)
+{
+	int name[CTL_MAXNAME];
+	size_t oldlen = 0;
+	int i;
+
+	if (nlen <= 0 || nlen >= CTL_MAXNAME)
+		return -ENOTDIR;
+	if (oldval && !oldlenp)
+		return -EFAULT;
+	if (oldlenp && get_user(oldlen, oldlenp))
+		return -EFAULT;
+
+	/* Read in the sysctl name for simplicity */
+	for (i = 0; i < nlen; i++)
+		if (get_user(name[i], args_name + i))
+			return -EFAULT;
+
+	deprecated_sysctl_warning(name, nlen);
+
+	return binary_sysctl(name, nlen, oldval, oldlenp, newval, newlen);
+}
+
+
+SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
+{
+	struct __sysctl_args tmp;
+	int error;
+
+	if (copy_from_user(&tmp, args, sizeof(tmp)))
+		return -EFAULT;
+
+	lock_kernel();
+	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
+			  tmp.newval, tmp.newlen);
+	unlock_kernel();
+
+	return error;
 }
-- 
1.6.5.2.143.g8cc62

