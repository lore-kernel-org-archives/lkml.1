Return-Path: <linux-kernel-owner+w=401wt.eu-S965677AbXAZOMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965677AbXAZOMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965678AbXAZOMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:12:48 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46106 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965677AbXAZOMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:12:46 -0500
Message-ID: <45BA0C5A.2040204@hitachi.com>
Date: Fri, 26 Jan 2007 23:12:42 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: akpm@osdl.org, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 1/4] coredump: add an interface to specify omitted memory
    segment types
References: <45BA0A93.30004@hitachi.com>
In-Reply-To: <45BA0A93.30004@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to specify which memory segment types
should be dumped or not.

/proc/<pid>/core_flags file is provided as the interface.
You can change the setting value (which memory segment types are
dumped or not) for a particular process by writing to or reading
from the file.

The setting value is inherited to the child process when it is
created.

The setting value is stored into core_flags member of mm_struct,
which shares bytes with dumpable member because these two are
adjacent bit fields.  In order to avoid write-write race between the
two, we use a global spin lock.

smp_wmb() at updating dumpable is removed because set_dumpable()
includes a pair of spin lock and unlock which has the effect of
memory barrier.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/exec.c             |   11 +++-
 fs/proc/base.c        |   93 ++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h |   30 ++++++++++++
 kernel/fork.c         |    2 
 kernel/sys.c          |   62 +++++++++-----------------
 security/commoncap.c  |    2 
 security/dummy.c      |    2 
 7 files changed, 155 insertions(+), 47 deletions(-)

Index: linux-2.6.20-rc4-mm1/fs/proc/base.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/proc/base.c
+++ linux-2.6.20-rc4-mm1/fs/proc/base.c
@@ -73,6 +73,7 @@
 #include <linux/poll.h>
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
+#include <linux/elf.h>
 #include "internal.h"
 
 /* NOTE:
@@ -912,6 +913,95 @@ static struct file_operations proc_fault
 };
 #endif
 
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+static ssize_t proc_core_flags_read(struct file *file, char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	unsigned int flags;
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
+	flags = mm->core_flags;
+
+	len = snprintf(buffer, sizeof(buffer), "%08x\n", flags);
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
+static ssize_t proc_core_flags_write(struct file *file, const char __user *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	char buffer[PROC_NUMBUF], *end;
+	unsigned int flags;
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
+	flags = (unsigned int)simple_strtoul(buffer, &end, 0);
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
+	if (mm) {
+		set_core_flags(mm, flags);
+		mmput(mm);
+	}
+
+	put_task_struct(task);
+ out_no_task:
+	return ret;
+}
+
+static struct file_operations proc_core_flags_operations = {
+	.read		= proc_core_flags_read,
+	.write		= proc_core_flags_write,
+};
+#endif
+
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
@@ -1876,6 +1966,9 @@ static struct pid_entry tgid_base_stuff[
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
+	REG("core_flags", S_IRUGO|S_IWUSR, core_flags),
+#endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
Index: linux-2.6.20-rc4-mm1/include/linux/sched.h
===================================================================
--- linux-2.6.20-rc4-mm1.orig/include/linux/sched.h
+++ linux-2.6.20-rc4-mm1/include/linux/sched.h
@@ -372,6 +372,9 @@ struct mm_struct {
 
 	unsigned char dumpable:2;
 
+	/* Control the core dump routines.  */
+	unsigned char core_flags:1;
+
 	/* coredumping support */
 	int core_waiters;
 	struct completion *core_startup_done, core_done;
@@ -1710,6 +1713,33 @@ extern int sched_create_sysfs_power_savi
 
 extern void normalize_rt_tasks(void);
 
+#include <linux/elf.h>
+/*
+ * These macros are used to protect dumpable and core_flags bit fields in
+ * mm_struct from write race between the two.
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
+# define set_core_flags(mm, val) \
+	__set_dump_bits((mm)->core_flags, val)
+#else
+# define set_dumpable(mm, val) \
+	do {				\
+		(mm)->dumpable = (val);	\
+		smp_wmb();		\
+	} while (0)
+# define set_core_flags(mm, val)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6.20-rc4-mm1/fs/exec.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/fs/exec.c
+++ linux-2.6.20-rc4-mm1/fs/exec.c
@@ -62,6 +62,9 @@ int core_uses_pid;
 char core_pattern[128] = "core";
 int suid_dumpable = 0;
 
+/* Protect dumpable and core_flags in each mm_struct from race condition.  */
+DEFINE_SPINLOCK(dump_bits_lock);
+
 EXPORT_SYMBOL(suid_dumpable);
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
@@ -853,9 +856,9 @@ int flush_old_exec(struct linux_binprm *
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (current->euid == current->uid && current->egid == current->gid)
-		current->mm->dumpable = 1;
+		set_dumpable(current->mm, 1);
 	else
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 	name = bprm->filename;
 
@@ -883,7 +886,7 @@ int flush_old_exec(struct linux_binprm *
 	    file_permission(bprm->file, MAY_READ) ||
 	    (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 	}
 
 	/* An exec changes our domain. We are no longer part of the thread
@@ -1482,7 +1485,7 @@ int do_coredump(long signr, int exit_cod
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		current->fsuid = 0;	/* Dump root private */
 	}
-	mm->dumpable = 0;
+	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
Index: linux-2.6.20-rc4-mm1/kernel/fork.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/kernel/fork.c
+++ linux-2.6.20-rc4-mm1/kernel/fork.c
@@ -332,6 +332,8 @@ static struct mm_struct * mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
+	/* don't need to use set_core_flags() */
+	mm->core_flags = (current->mm) ? current->mm->core_flags : 0;
 	mm->core_waiters = 0;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
Index: linux-2.6.20-rc4-mm1/kernel/sys.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/kernel/sys.c
+++ linux-2.6.20-rc4-mm1/kernel/sys.c
@@ -1017,10 +1017,8 @@ asmlinkage long sys_setregid(gid_t rgid,
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
@@ -1047,16 +1045,12 @@ asmlinkage long sys_setgid(gid_t gid)
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
@@ -1084,10 +1078,8 @@ static int set_user(uid_t new_ruid, int 
 
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
@@ -1140,10 +1132,8 @@ asmlinkage long sys_setreuid(uid_t ruid,
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
@@ -1190,10 +1180,8 @@ asmlinkage long sys_setuid(uid_t uid)
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
 
@@ -1235,10 +1223,8 @@ asmlinkage long sys_setresuid(uid_t ruid
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
@@ -1285,10 +1271,8 @@ asmlinkage long sys_setresgid(gid_t rgid
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
@@ -1331,10 +1315,8 @@ asmlinkage long sys_setfsuid(uid_t uid)
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
 
@@ -1360,10 +1342,8 @@ asmlinkage long sys_setfsgid(gid_t gid)
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
@@ -2158,7 +2138,7 @@ asmlinkage long sys_prctl(int option, un
 				error = -EINVAL;
 				break;
 			}
-			current->mm->dumpable = arg2;
+			set_dumpable(current->mm, arg2);
 			break;
 
 		case PR_SET_UNALIGN:
Index: linux-2.6.20-rc4-mm1/security/commoncap.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/security/commoncap.c
+++ linux-2.6.20-rc4-mm1/security/commoncap.c
@@ -244,7 +244,7 @@ void cap_bprm_apply_creds (struct linux_
 
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset (new_permitted, current->cap_permitted)) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
Index: linux-2.6.20-rc4-mm1/security/dummy.c
===================================================================
--- linux-2.6.20-rc4-mm1.orig/security/dummy.c
+++ linux-2.6.20-rc4-mm1/security/dummy.c
@@ -130,7 +130,7 @@ static void dummy_bprm_free_security (st
 static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if ((unsafe & ~LSM_UNSAFE_PTRACE_CAP) && !capable(CAP_SETUID)) {
 			bprm->e_uid = current->uid;



