Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZKFAmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZKFAmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbZKFAmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:42:02 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39307 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189AbZKFAmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:42:00 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 01/11] sysctl: Separate the binary sysctl logic into it's own file.
Date: Thu,  5 Nov 2009 16:41:44 -0800
Message-Id: <1257468114-6823-1-git-send-email-ebiederm@xmission.com>
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

In preparation for more invasive cleanups separate the core
binary sysctl logic into it's own file.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/Makefile        |    2 +-
 kernel/sysctl.c        |  164 ------------------------------------------
 kernel/sysctl_binary.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+), 165 deletions(-)
 create mode 100644 kernel/sysctl_binary.c

diff --git a/kernel/Makefile b/kernel/Makefile
index b8d4cd8..986a5c1 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -4,7 +4,7 @@
 
 obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
-	    sysctl.o capability.o ptrace.o timer.o user.o \
+	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..34c8dbc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -60,7 +60,6 @@
 #include <asm/io.h>
 #endif
 
-static int deprecated_sysctl_warning(struct __sysctl_args *args);
 
 #if defined(CONFIG_SYSCTL)
 
@@ -1766,122 +1765,6 @@ void register_sysctl_root(struct ctl_table_root *root)
 	spin_unlock(&sysctl_lock);
 }
 
-#ifdef CONFIG_SYSCTL_SYSCALL
-/* Perform the actual read/write of a sysctl table entry. */
-static int do_sysctl_strategy(struct ctl_table_root *root,
-			struct ctl_table *table,
-			void __user *oldval, size_t __user *oldlenp,
-			void __user *newval, size_t newlen)
-{
-	int op = 0, rc;
-
-	if (oldval)
-		op |= MAY_READ;
-	if (newval)
-		op |= MAY_WRITE;
-	if (sysctl_perm(root, table, op))
-		return -EPERM;
-
-	if (table->strategy) {
-		rc = table->strategy(table, oldval, oldlenp, newval, newlen);
-		if (rc < 0)
-			return rc;
-		if (rc > 0)
-			return 0;
-	}
-
-	/* If there is no strategy routine, or if the strategy returns
-	 * zero, proceed with automatic r/w */
-	if (table->data && table->maxlen) {
-		rc = sysctl_data(table, oldval, oldlenp, newval, newlen);
-		if (rc < 0)
-			return rc;
-	}
-	return 0;
-}
-
-static int parse_table(int __user *name, int nlen,
-		       void __user *oldval, size_t __user *oldlenp,
-		       void __user *newval, size_t newlen,
-		       struct ctl_table_root *root,
-		       struct ctl_table *table)
-{
-	int n;
-repeat:
-	if (!nlen)
-		return -ENOTDIR;
-	if (get_user(n, name))
-		return -EFAULT;
-	for ( ; table->ctl_name || table->procname; table++) {
-		if (!table->ctl_name)
-			continue;
-		if (n == table->ctl_name) {
-			int error;
-			if (table->child) {
-				if (sysctl_perm(root, table, MAY_EXEC))
-					return -EPERM;
-				name++;
-				nlen--;
-				table = table->child;
-				goto repeat;
-			}
-			error = do_sysctl_strategy(root, table,
-						   oldval, oldlenp,
-						   newval, newlen);
-			return error;
-		}
-	}
-	return -ENOTDIR;
-}
-
-int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
-	       void __user *newval, size_t newlen)
-{
-	struct ctl_table_header *head;
-	int error = -ENOTDIR;
-
-	if (nlen <= 0 || nlen >= CTL_MAXNAME)
-		return -ENOTDIR;
-	if (oldval) {
-		int old_len;
-		if (!oldlenp || get_user(old_len, oldlenp))
-			return -EFAULT;
-	}
-
-	for (head = sysctl_head_next(NULL); head;
-			head = sysctl_head_next(head)) {
-		error = parse_table(name, nlen, oldval, oldlenp, 
-					newval, newlen,
-					head->root, head->ctl_table);
-		if (error != -ENOTDIR) {
-			sysctl_head_finish(head);
-			break;
-		}
-	}
-	return error;
-}
-
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
-#endif /* CONFIG_SYSCTL_SYSCALL */
-
 /*
  * sysctl_perm does NOT grant the superuser all rights automatically, because
  * some sysctl variables are readonly even to root.
@@ -3148,23 +3031,6 @@ int sysctl_ms_jiffies(struct ctl_table *table,
 #else /* CONFIG_SYSCTL_SYSCALL */
 
 
-SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
-{
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
-}
-
 int sysctl_data(struct ctl_table *table,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
@@ -3202,36 +3068,6 @@ int sysctl_ms_jiffies(struct ctl_table *table,
 
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
-static int deprecated_sysctl_warning(struct __sysctl_args *args)
-{
-	static int msg_count;
-	int name[CTL_MAXNAME];
-	int i;
-
-	/* Check args->nlen. */
-	if (args->nlen < 0 || args->nlen > CTL_MAXNAME)
-		return -ENOTDIR;
-
-	/* Read in the sysctl name for better debug message logging */
-	for (i = 0; i < args->nlen; i++)
-		if (get_user(name[i], args->name + i))
-			return -EFAULT;
-
-	/* Ignore accesses to kernel.version */
-	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
-		return 0;
-
-	if (msg_count < 5) {
-		msg_count++;
-		printk(KERN_INFO
-			"warning: process `%s' used the deprecated sysctl "
-			"system call with ", current->comm);
-		for (i = 0; i < args->nlen; i++)
-			printk("%d.", name[i]);
-		printk("\n");
-	}
-	return 0;
-}
 
 /*
  * No sense putting this after each symbol definition, twice,
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
new file mode 100644
index 0000000..2431653
--- /dev/null
+++ b/kernel/sysctl_binary.c
@@ -0,0 +1,184 @@
+#include <linux/stat.h>
+#include <linux/sysctl.h>
+#include "../fs/xfs/linux-2.6/xfs_sysctl.h"
+#include <linux/sunrpc/debug.h>
+#include <linux/string.h>
+#include <net/ip_vs.h>
+#include <linux/syscalls.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/fs.h>
+#include <linux/nsproxy.h>
+#include <linux/pid_namespace.h>
+#include <linux/file.h>
+#include <linux/ctype.h>
+
+static int deprecated_sysctl_warning(struct __sysctl_args *args);
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+
+/* Perform the actual read/write of a sysctl table entry. */
+static int do_sysctl_strategy(struct ctl_table_root *root,
+			struct ctl_table *table,
+			void __user *oldval, size_t __user *oldlenp,
+			void __user *newval, size_t newlen)
+{
+	int op = 0, rc;
+
+	if (oldval)
+		op |= MAY_READ;
+	if (newval)
+		op |= MAY_WRITE;
+	if (sysctl_perm(root, table, op))
+		return -EPERM;
+
+	if (table->strategy) {
+		rc = table->strategy(table, oldval, oldlenp, newval, newlen);
+		if (rc < 0)
+			return rc;
+		if (rc > 0)
+			return 0;
+	}
+
+	/* If there is no strategy routine, or if the strategy returns
+	 * zero, proceed with automatic r/w */
+	if (table->data && table->maxlen) {
+		rc = sysctl_data(table, oldval, oldlenp, newval, newlen);
+		if (rc < 0)
+			return rc;
+	}
+	return 0;
+}
+
+static int parse_table(int __user *name, int nlen,
+		       void __user *oldval, size_t __user *oldlenp,
+		       void __user *newval, size_t newlen,
+		       struct ctl_table_root *root,
+		       struct ctl_table *table)
+{
+	int n;
+repeat:
+	if (!nlen)
+		return -ENOTDIR;
+	if (get_user(n, name))
+		return -EFAULT;
+	for ( ; table->ctl_name || table->procname; table++) {
+		if (!table->ctl_name)
+			continue;
+		if (n == table->ctl_name) {
+			int error;
+			if (table->child) {
+				if (sysctl_perm(root, table, MAY_EXEC))
+					return -EPERM;
+				name++;
+				nlen--;
+				table = table->child;
+				goto repeat;
+			}
+			error = do_sysctl_strategy(root, table,
+						   oldval, oldlenp,
+						   newval, newlen);
+			return error;
+		}
+	}
+	return -ENOTDIR;
+}
+
+int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
+	       void __user *newval, size_t newlen)
+{
+	struct ctl_table_header *head;
+	int error = -ENOTDIR;
+
+	if (nlen <= 0 || nlen >= CTL_MAXNAME)
+		return -ENOTDIR;
+	if (oldval) {
+		int old_len;
+		if (!oldlenp || get_user(old_len, oldlenp))
+			return -EFAULT;
+	}
+
+	for (head = sysctl_head_next(NULL); head;
+			head = sysctl_head_next(head)) {
+		error = parse_table(name, nlen, oldval, oldlenp, 
+					newval, newlen,
+					head->root, head->ctl_table);
+		if (error != -ENOTDIR) {
+			sysctl_head_finish(head);
+			break;
+		}
+	}
+	return error;
+}
+
+SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
+{
+	struct __sysctl_args tmp;
+	int error;
+
+	if (copy_from_user(&tmp, args, sizeof(tmp)))
+		return -EFAULT;
+
+	error = deprecated_sysctl_warning(&tmp);
+	if (error)
+		goto out;
+
+	lock_kernel();
+	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
+			  tmp.newval, tmp.newlen);
+	unlock_kernel();
+out:
+	return error;
+}
+
+#else /* CONFIG_SYSCTL_SYSCALL */
+
+SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
+{
+	struct __sysctl_args tmp;
+	int error;
+
+	if (copy_from_user(&tmp, args, sizeof(tmp)))
+		return -EFAULT;
+
+	error = deprecated_sysctl_warning(&tmp);
+
+	/* If no error reading the parameters then just -ENOSYS ... */
+	if (!error)
+		error = -ENOSYS;
+
+	return error;
+}
+
+#endif /* CONFIG_SYSCTL_SYSCALL */
+
+static int deprecated_sysctl_warning(struct __sysctl_args *args)
+{
+	static int msg_count;
+	int name[CTL_MAXNAME];
+	int i;
+
+	/* Check args->nlen. */
+	if (args->nlen < 0 || args->nlen > CTL_MAXNAME)
+		return -ENOTDIR;
+
+	/* Read in the sysctl name for better debug message logging */
+	for (i = 0; i < args->nlen; i++)
+		if (get_user(name[i], args->name + i))
+			return -EFAULT;
+
+	/* Ignore accesses to kernel.version */
+	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
+		return 0;
+
+	if (msg_count < 5) {
+		msg_count++;
+		printk(KERN_INFO
+			"warning: process `%s' used the deprecated sysctl "
+			"system call with ", current->comm);
+		for (i = 0; i < args->nlen; i++)
+			printk("%d.", name[i]);
+		printk("\n");
+	}
+	return 0;
+}
-- 
1.6.5.2.143.g8cc62

