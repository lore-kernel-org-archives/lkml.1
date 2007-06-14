Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbXFNPZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbXFNPZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXFNPZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:25:31 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51053
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXFNPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:25:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 2] move seccomp from /proc to a prctl
X-Mercurial-Node: 8d75c4aa7185fcdcc2e99f3fe0f1ec68cbd78a43
Message-Id: <8d75c4aa7185fcdcc2e9.1181833734@v2.random>
In-Reply-To: <patchbomb.1181833733@v2.random>
Date: Thu, 14 Jun 2007 17:08:54 +0200
From: Andrea Arcangeli <andrea@cpushare.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@cpushare.com>
# Date 1181833362 -7200
# Node ID 8d75c4aa7185fcdcc2e99f3fe0f1ec68cbd78a43
# Parent  6416ccf1c2fa5f990695b38c8a692fa9e109a223
move seccomp from /proc to a prctl

This reduces the memory footprint and it enforces that only the current
task can enable seccomp on itself (this is a requirement for a
strightforward [modulo preempt ;) ] TIF_NOTSC implementation).

Signed-off-by: Andrea Arcangeli <andrea@cpushare.com>

diff --git a/fs/proc/base.c b/fs/proc/base.c
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -67,7 +67,6 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
-#include <linux/seccomp.h>
 #include <linux/cpuset.h>
 #include <linux/audit.h>
 #include <linux/poll.h>
@@ -811,71 +810,6 @@ static const struct file_operations proc
 	.write		= proc_loginuid_write,
 };
 #endif
-
-#ifdef CONFIG_SECCOMP
-static ssize_t seccomp_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
-{
-	struct task_struct *tsk = get_proc_task(file->f_dentry->d_inode);
-	char __buf[20];
-	size_t len;
-
-	if (!tsk)
-		return -ESRCH;
-	/* no need to print the trailing zero, so use only len */
-	len = sprintf(__buf, "%u\n", tsk->seccomp.mode);
-	put_task_struct(tsk);
-
-	return simple_read_from_buffer(buf, count, ppos, __buf, len);
-}
-
-static ssize_t seccomp_write(struct file *file, const char __user *buf,
-			     size_t count, loff_t *ppos)
-{
-	struct task_struct *tsk = get_proc_task(file->f_dentry->d_inode);
-	char __buf[20], *end;
-	unsigned int seccomp_mode;
-	ssize_t result;
-
-	result = -ESRCH;
-	if (!tsk)
-		goto out_no_task;
-
-	/* can set it only once to be even more secure */
-	result = -EPERM;
-	if (unlikely(tsk->seccomp.mode))
-		goto out;
-
-	result = -EFAULT;
-	memset(__buf, 0, sizeof(__buf));
-	count = min(count, sizeof(__buf) - 1);
-	if (copy_from_user(__buf, buf, count))
-		goto out;
-
-	seccomp_mode = simple_strtoul(__buf, &end, 0);
-	if (*end == '\n')
-		end++;
-	result = -EINVAL;
-	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
-		tsk->seccomp.mode = seccomp_mode;
-		set_tsk_thread_flag(tsk, TIF_SECCOMP);
-	} else
-		goto out;
-	result = -EIO;
-	if (unlikely(!(end - __buf)))
-		goto out;
-	result = end - __buf;
-out:
-	put_task_struct(tsk);
-out_no_task:
-	return result;
-}
-
-static const struct file_operations proc_seccomp_operations = {
-	.read		= seccomp_read,
-	.write		= seccomp_write,
-};
-#endif /* CONFIG_SECCOMP */
 
 #ifdef CONFIG_FAULT_INJECTION
 static ssize_t proc_fault_inject_read(struct file * file, char __user * buf,
@@ -1971,9 +1905,6 @@ static const struct pid_entry tgid_base_
 	REG("numa_maps",  S_IRUGO, numa_maps),
 #endif
 	REG("mem",        S_IRUSR|S_IWUSR, mem),
-#ifdef CONFIG_SECCOMP
-	REG("seccomp",    S_IRUSR|S_IWUSR, seccomp),
-#endif
 	LNK("cwd",        cwd),
 	LNK("root",       root),
 	LNK("exe",        exe),
@@ -2255,9 +2186,6 @@ static const struct pid_entry tid_base_s
 	REG("numa_maps", S_IRUGO, numa_maps),
 #endif
 	REG("mem",       S_IRUSR|S_IWUSR, mem),
-#ifdef CONFIG_SECCOMP
-	REG("seccomp",   S_IRUSR|S_IWUSR, seccomp),
-#endif
 	LNK("cwd",       cwd),
 	LNK("root",      root),
 	LNK("exe",       exe),
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -59,4 +59,8 @@
 # define PR_ENDIAN_LITTLE	1	/* True little endian mode */
 # define PR_ENDIAN_PPC_LITTLE	2	/* "PowerPC" pseudo little endian */
 
+/* Get/set process seccomp mode */
+#define PR_GET_SECCOMP	21
+#define PR_SET_SECCOMP	22
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -3,8 +3,6 @@
 
 
 #ifdef CONFIG_SECCOMP
-
-#define NR_SECCOMP_MODES 1
 
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
@@ -23,6 +21,9 @@ static inline int has_secure_computing(s
 	return unlikely(test_ti_thread_flag(ti, TIF_SECCOMP));
 }
 
+extern long prctl_get_seccomp(void);
+extern long prctl_set_seccomp(unsigned long);
+
 #else /* CONFIG_SECCOMP */
 
 typedef struct { } seccomp_t;
@@ -34,6 +35,16 @@ static inline int has_secure_computing(s
 	return 0;
 }
 
+static inline long prctl_get_seccomp(void)
+{
+	return -EINVAL;
+}
+
+static inline long prctl_set_seccomp(unsigned long arg2)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_SECCOMP */
 
 #endif /* _LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 
 /* #define SECCOMP_DEBUG 1 */
+#define NR_SECCOMP_MODES 1
 
 /*
  * Secure computing mode 1 allows only read/write/exit/sigreturn.
@@ -54,3 +55,28 @@ void __secure_computing(int this_syscall
 #endif
 	do_exit(SIGKILL);
 }
+
+long prctl_get_seccomp(void)
+{
+	return current->seccomp.mode;
+}
+
+long prctl_set_seccomp(unsigned long seccomp_mode)
+{
+	long ret;
+
+	/* can set it only once to be even more secure */
+	ret = -EPERM;
+	if (unlikely(current->seccomp.mode))
+		goto out;
+
+	ret = -EINVAL;
+	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
+		current->seccomp.mode = seccomp_mode;
+		set_thread_flag(TIF_SECCOMP);
+		ret = 0;
+	}
+
+ out:
+	return ret;
+}
diff --git a/kernel/sys.c b/kernel/sys.c
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -31,6 +31,7 @@
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/seccomp.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -2241,6 +2242,13 @@ asmlinkage long sys_prctl(int option, un
 			error = SET_ENDIAN(current, arg2);
 			break;
 
+		case PR_GET_SECCOMP:
+			error = prctl_get_seccomp();
+			break;
+		case PR_SET_SECCOMP:
+			error = prctl_set_seccomp(arg2);
+			break;
+
 		default:
 			error = -EINVAL;
 			break;
