Return-Path: <linux-kernel-owner+w=401wt.eu-S964841AbXBPNjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbXBPNjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964840AbXBPNjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:39:40 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50829 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841AbXBPNji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:39:38 -0500
Message-ID: <45D5B411.6030103@hitachi.com>
Date: Fri, 16 Feb 2007 22:39:29 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: [PATCH 1/4] coredump: add an interface to control the core dump
    routine
References: <45D5B2E3.3030607@hitachi.com>
In-Reply-To: <45D5B2E3.3030607@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to set/reset a flag which determines
anonymous shared memory segments should be dumped or not when a core
file is generated.

/proc/<pid>/coredump_omit_anonymous_shared file is provided to access
the flag. You can change the flag status for a particular process by
writing to or reading from the file.

The flag status is inherited to the child process when it is created.

The flag is stored into coredump_omit_anon_shared member of mm_struct,
which shares bytes with dumpable member because these two are adjacent
bit fields. In order to avoid write-write race between the two, we use
a global spin lock.

smp_wmb() at updating dumpable is removed because set_dumpable()
includes a pair of spin lock and unlock which has the effect of
memory barrier.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/exec.c             |   10 ++--
 fs/proc/base.c        |   99 ++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h |   33 +++++++++++++
 kernel/fork.c         |    3 +
 kernel/sys.c          |   62 ++++++++-----------------
 security/commoncap.c  |    2 
 security/dummy.c      |    2 
 7 files changed, 164 insertions(+), 47 deletions(-)

Index: linux-2.6.20-mm1/fs/proc/base.c
===================================================================
--- linux-2.6.20-mm1.orig/fs/proc/base.c
+++ linux-2.6.20-mm1/fs/proc/base.c
@@ -74,6 +74,7 @@
 #include <linux/poll.h>
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
+#include <linux/elf.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1753,6 +1754,100 @@ static const struct inode_operations pro
 
 #endif
 
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+static ssize_t proc_coredump_omit_anon_shared_read(struct file *file,
+						   char __user *buf,
+						   size_t count,
+						   loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	loff_t __ppos = *ppos;
+	int ret;
+
+	ret = -ESRCH;
+	if (!task)
+		goto out_no_task;
+
+	ret = 0;
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_no_mm;
+
+	len = snprintf(buffer, sizeof(buffer), "%u\n",
+		       mm->coredump_omit_anon_shared);
+	if (__ppos >= len)
+		goto out;
+	if (count > len - __ppos)
+		count = len - __ppos;
+
+	ret = -EFAULT;
+	if (copy_to_user(buf, buffer + __ppos, count))
+		goto out;
+
+	ret = count;
+	*ppos = __ppos + count;
+
+ out:
+	mmput(mm);
+ out_no_mm:
+	put_task_struct(task);
+ out_no_task:
+	return ret;
+}
+
+static ssize_t proc_coredump_omit_anon_shared_write(struct file *file,
+						    const char __user *buf,
+						    size_t count,
+						    loff_t *ppos)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF], *end;
+	unsigned int val;
+	int ret;
+
+	ret = -EFAULT;
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		goto out_no_task;
+
+	ret = -EINVAL;
+	val = (unsigned int)simple_strtoul(buffer, &end, 0);
+	if (*end == '\n')
+		end++;
+	if (end - buffer == 0)
+		goto out_no_task;
+
+	ret = -ESRCH;
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task)
+		goto out_no_task;
+
+	ret = end - buffer;
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_no_mm;
+
+	set_coredump_omit_anon_shared(mm, (val != 0));
+
+	mmput(mm);
+ out_no_mm:
+	put_task_struct(task);
+ out_no_task:
+	return ret;
+}
+
+static struct file_operations proc_coredump_omit_anon_shared_operations = {
+	.read		= proc_coredump_omit_anon_shared_read,
+	.write		= proc_coredump_omit_anon_shared_write,
+};
+#endif
+
 /*
  * /proc/self:
  */
@@ -1972,6 +2067,10 @@ static struct pid_entry tgid_base_stuff[
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+	REG("coredump_omit_anonymous_shared", S_IRUGO|S_IWUSR,
+	    coredump_omit_anon_shared),
+#endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
Index: linux-2.6.20-mm1/include/linux/sched.h
===================================================================
--- linux-2.6.20-mm1.orig/include/linux/sched.h
+++ linux-2.6.20-mm1/include/linux/sched.h
@@ -366,7 +366,13 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
+	/*
+	 * Writing to these bit fields can cause race condition.  To avoid
+	 * the race, use dump_bits_lock.  You may also use set_dumpable() or
+	 * set_coredump_*() macros to set a value.
+	 */
 	unsigned char dumpable:2;
+	unsigned char coredump_omit_anon_shared:1;  /* don't dump anon shm */
 
 	/* coredumping support */
 	int core_waiters;
@@ -1721,6 +1727,33 @@ static inline void inc_syscw(struct task
 }
 #endif
 
+#include <linux/elf.h>
+/*
+ * These macros are used to protect dumpable and coredump_omit_anon_shared bit
+ * fields in mm_struct from write race between the two.
+ */
+extern spinlock_t dump_bits_lock;
+#define __set_dump_bits(dest, val) \
+	do {					\
+		spin_lock(&dump_bits_lock);	\
+		(dest) = (val);			\
+		spin_unlock(&dump_bits_lock);	\
+	} while (0)
+
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+# define set_dumpable(mm, val) \
+	__set_dump_bits((mm)->dumpable, val)
+# define set_coredump_omit_anon_shared(mm, val) \
+	__set_dump_bits((mm)->coredump_omit_anon_shared, val)
+#else
+# define set_dumpable(mm, val) \
+	do {				\
+		(mm)->dumpable = (val);	\
+		smp_wmb();		\
+	} while (0)
+# define set_coredump_omit_anon_shared(mm, val)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6.20-mm1/fs/exec.c
===================================================================
--- linux-2.6.20-mm1.orig/fs/exec.c
+++ linux-2.6.20-mm1/fs/exec.c
@@ -62,6 +62,8 @@ int core_uses_pid;
 char core_pattern[128] = "core";
 int suid_dumpable = 0;
 
+DEFINE_SPINLOCK(dump_bits_lock);
+
 EXPORT_SYMBOL(suid_dumpable);
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
@@ -853,9 +855,9 @@ int flush_old_exec(struct linux_binprm *
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (current->euid == current->uid && current->egid == current->gid)
-		current->mm->dumpable = 1;
+		set_dumpable(current->mm, 1);
 	else
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 	name = bprm->filename;
 
@@ -883,7 +885,7 @@ int flush_old_exec(struct linux_binprm *
 	    file_permission(bprm->file, MAY_READ) ||
 	    (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 	}
 
 	/* An exec changes our domain. We are no longer part of the thread
@@ -1477,7 +1479,7 @@ int do_coredump(long signr, int exit_cod
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		current->fsuid = 0;	/* Dump root private */
 	}
-	mm->dumpable = 0;
+	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
Index: linux-2.6.20-mm1/kernel/fork.c
===================================================================
--- linux-2.6.20-mm1.orig/kernel/fork.c
+++ linux-2.6.20-mm1/kernel/fork.c
@@ -333,6 +333,9 @@ static struct mm_struct * mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
+	/* don't need to use set_coredump_omit_anon_shared() */
+	mm->coredump_omit_anon_shared =
+		(current->mm) ?	current->mm->coredump_omit_anon_shared : 0;
 	mm->core_waiters = 0;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
Index: linux-2.6.20-mm1/kernel/sys.c
===================================================================
--- linux-2.6.20-mm1.orig/kernel/sys.c
+++ linux-2.6.20-mm1/kernel/sys.c
@@ -1022,10 +1022,8 @@ asmlinkage long sys_setregid(gid_t rgid,
 		else
 			return -EPERM;
 	}
-	if (new_egid != old_egid) {
-		current->mm->dumpable = suid_dumpable;
-		smp_wmb();
-	}
+	if (new_egid != old_egid)
+		set_dumpable(current->mm, suid_dumpable);
 	if (rgid != (gid_t) -1 ||
 	    (egid != (gid_t) -1 && egid != old_rgid))
 		current->sgid = new_egid;
@@ -1052,16 +1050,12 @@ asmlinkage long sys_setgid(gid_t gid)
 		return retval;
 
 	if (capable(CAP_SETGID)) {
-		if (old_egid != gid) {
-			current->mm->dumpable = suid_dumpable;
-			smp_wmb();
-		}
+		if (old_egid != gid)
+			set_dumpable(current->mm, suid_dumpable);
 		current->gid = current->egid = current->sgid = current->fsgid = gid;
 	} else if ((gid == current->gid) || (gid == current->sgid)) {
-		if (old_egid != gid) {
-			current->mm->dumpable = suid_dumpable;
-			smp_wmb();
-		}
+		if (old_egid != gid)
+			set_dumpable(current->mm, suid_dumpable);
 		current->egid = current->fsgid = gid;
 	}
 	else
@@ -1089,10 +1083,8 @@ static int set_user(uid_t new_ruid, int 
 
 	switch_uid(new_user);
 
-	if (dumpclear) {
-		current->mm->dumpable = suid_dumpable;
-		smp_wmb();
-	}
+	if (dumpclear)
+		set_dumpable(current->mm, suid_dumpable);
 	current->uid = new_ruid;
 	return 0;
 }
@@ -1145,10 +1137,8 @@ asmlinkage long sys_setreuid(uid_t ruid,
 	if (new_ruid != old_ruid && set_user(new_ruid, new_euid != old_euid) < 0)
 		return -EAGAIN;
 
-	if (new_euid != old_euid) {
-		current->mm->dumpable = suid_dumpable;
-		smp_wmb();
-	}
+	if (new_euid != old_euid)
+		set_dumpable(current->mm, suid_dumpable);
 	current->fsuid = current->euid = new_euid;
 	if (ruid != (uid_t) -1 ||
 	    (euid != (uid_t) -1 && euid != old_ruid))
@@ -1195,10 +1185,8 @@ asmlinkage long sys_setuid(uid_t uid)
 	} else if ((uid != current->uid) && (uid != new_suid))
 		return -EPERM;
 
-	if (old_euid != uid) {
-		current->mm->dumpable = suid_dumpable;
-		smp_wmb();
-	}
+	if (old_euid != uid)
+		set_dumpable(current->mm, suid_dumpable);
 	current->fsuid = current->euid = uid;
 	current->suid = new_suid;
 
@@ -1240,10 +1228,8 @@ asmlinkage long sys_setresuid(uid_t ruid
 			return -EAGAIN;
 	}
 	if (euid != (uid_t) -1) {
-		if (euid != current->euid) {
-			current->mm->dumpable = suid_dumpable;
-			smp_wmb();
-		}
+		if (euid != current->euid)
+			set_dumpable(current->mm, suid_dumpable);
 		current->euid = euid;
 	}
 	current->fsuid = current->euid;
@@ -1290,10 +1276,8 @@ asmlinkage long sys_setresgid(gid_t rgid
 			return -EPERM;
 	}
 	if (egid != (gid_t) -1) {
-		if (egid != current->egid) {
-			current->mm->dumpable = suid_dumpable;
-			smp_wmb();
-		}
+		if (egid != current->egid)
+			set_dumpable(current->mm, suid_dumpable);
 		current->egid = egid;
 	}
 	current->fsgid = current->egid;
@@ -1336,10 +1320,8 @@ asmlinkage long sys_setfsuid(uid_t uid)
 	if (uid == current->uid || uid == current->euid ||
 	    uid == current->suid || uid == current->fsuid || 
 	    capable(CAP_SETUID)) {
-		if (uid != old_fsuid) {
-			current->mm->dumpable = suid_dumpable;
-			smp_wmb();
-		}
+		if (uid != old_fsuid)
+			set_dumpable(current->mm, suid_dumpable);
 		current->fsuid = uid;
 	}
 
@@ -1365,10 +1347,8 @@ asmlinkage long sys_setfsgid(gid_t gid)
 	if (gid == current->gid || gid == current->egid ||
 	    gid == current->sgid || gid == current->fsgid || 
 	    capable(CAP_SETGID)) {
-		if (gid != old_fsgid) {
-			current->mm->dumpable = suid_dumpable;
-			smp_wmb();
-		}
+		if (gid != old_fsgid)
+			set_dumpable(current->mm, suid_dumpable);
 		current->fsgid = gid;
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
@@ -2163,7 +2143,7 @@ asmlinkage long sys_prctl(int option, un
 				error = -EINVAL;
 				break;
 			}
-			current->mm->dumpable = arg2;
+			set_dumpable(current->mm, arg2);
 			break;
 
 		case PR_SET_UNALIGN:
Index: linux-2.6.20-mm1/security/commoncap.c
===================================================================
--- linux-2.6.20-mm1.orig/security/commoncap.c
+++ linux-2.6.20-mm1/security/commoncap.c
@@ -244,7 +244,7 @@ void cap_bprm_apply_creds (struct linux_
 
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset (new_permitted, current->cap_permitted)) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
Index: linux-2.6.20-mm1/security/dummy.c
===================================================================
--- linux-2.6.20-mm1.orig/security/dummy.c
+++ linux-2.6.20-mm1/security/dummy.c
@@ -130,7 +130,7 @@ static void dummy_bprm_free_security (st
 static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if ((unsafe & ~LSM_UNSAFE_PTRACE_CAP) && !capable(CAP_SETUID)) {
 			bprm->e_uid = current->uid;


