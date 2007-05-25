Return-Path: <linux-kernel-owner+w=401wt.eu-S1762137AbXEYNHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762137AbXEYNHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXEYNG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:06:58 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50208 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXEYNG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:06:57 -0400
Message-ID: <4656DF5D.5090909@hitachi.com>
Date: Fri, 25 May 2007 22:06:37 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 2/7] reimplementation of dumpable using two flags
References: <4656DBFB.2050501@hitachi.com>
In-Reply-To: <4656DBFB.2050501@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes mm_struct.dumpable to a pair of bit flags.

set_dumpable() converts three-value dumpable to two flags and
stores it into lower two bits of mm_struct.flags instead of
mm_struct.dumpable.  get_dumpable() behaves in the opposite way.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/exec.c                    |   61 +++++++++++++++++++++++++++++----
 fs/proc/base.c               |    2 -
 include/asm-ia64/processor.h |    4 +-
 include/linux/sched.h        |    9 ++++
 kernel/ptrace.c              |    2 -
 kernel/sys.c                 |   24 ++++++------
 security/commoncap.c         |    2 -
 security/dummy.c             |    2 -
 8 files changed, 81 insertions(+), 25 deletions(-)

Index: linux-2.6.22-rc2-mm1/fs/exec.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/fs/exec.c
+++ linux-2.6.22-rc2-mm1/fs/exec.c
@@ -864,9 +864,9 @@ int flush_old_exec(struct linux_binprm *
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (current->euid == current->uid && current->egid == current->gid)
-		current->mm->dumpable = 1;
+		set_dumpable(current->mm, 1);
 	else
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 	name = bprm->filename;
 
@@ -894,7 +894,7 @@ int flush_old_exec(struct linux_binprm *
 	    file_permission(bprm->file, MAY_READ) ||
 	    (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 	}
 
 	/* An exec changes our domain. We are no longer part of the thread
@@ -1484,6 +1484,55 @@ fail:
 	return core_waiters;
 }
 
+/*
+ * set_dumpable converts traditional three-value dumpable to two flags and
+ * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
+ * these bits are not changed atomically.  So get_dumpable can observe the
+ * intermediate state.  To avoid doing unexpected behavior, get get_dumpable
+ * return either old dumpable or new one by paying attention to the order of
+ * modifying the bits.
+ *
+ * dumpable |   mm->flags (binary)
+ * old  new | initial interim  final
+ * ---------+-----------------------
+ *  0    1  |   00      01      01
+ *  0    2  |   00      10(*)   11
+ *  1    0  |   01      00      00
+ *  1    2  |   01      11      11
+ *  2    0  |   11      10(*)   00
+ *  2    1  |   11      11      01
+ *
+ * (*) get_dumpable regards interim value of 10 as 11.
+ */
+void set_dumpable(struct mm_struct *mm, int value)
+{
+	switch (value) {
+	case 0:
+		clear_bit(MMF_DUMPABLE, &mm->flags);
+		smp_wmb();
+		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
+		break;
+	case 1:
+		set_bit(MMF_DUMPABLE, &mm->flags);
+		smp_wmb();
+		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
+		break;
+	case 2:
+		set_bit(MMF_DUMP_SECURELY, &mm->flags);
+		smp_wmb();
+		set_bit(MMF_DUMPABLE, &mm->flags);
+		break;
+	}
+}
+
+int get_dumpable(struct mm_struct *mm)
+{
+	int ret;
+
+	ret = mm->flags & 0x3;
+	return (ret >= 2) ? 2 : ret;
+}
+
 int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 {
 	char corename[CORENAME_MAX_SIZE + 1];
@@ -1502,7 +1551,7 @@ int do_coredump(long signr, int exit_cod
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
 	down_write(&mm->mmap_sem);
-	if (!mm->dumpable) {
+	if (!get_dumpable(mm)) {
 		up_write(&mm->mmap_sem);
 		goto fail;
 	}
@@ -1512,11 +1561,11 @@ int do_coredump(long signr, int exit_cod
 	 *	process nor do we know its entire history. We only know it
 	 *	was tainted so we dump it as root in mode 2.
 	 */
-	if (mm->dumpable == 2) {	/* Setuid core dump mode */
+	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		current->fsuid = 0;	/* Dump root private */
 	}
-	mm->dumpable = 0;
+	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
 	if (retval < 0)
Index: linux-2.6.22-rc2-mm1/include/linux/sched.h
===================================================================
--- linux-2.6.22-rc2-mm1.orig/include/linux/sched.h
+++ linux-2.6.22-rc2-mm1/include/linux/sched.h
@@ -324,6 +324,13 @@ typedef unsigned long mm_counter_t;
 		(mm)->hiwater_vm = (mm)->total_vm;	\
 } while (0)
 
+extern void set_dumpable(struct mm_struct *mm, int value);
+extern int get_dumpable(struct mm_struct *mm);
+
+/* mm flags */
+#define MMF_DUMPABLE      0  /* core dump is permitted */
+#define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -381,7 +388,7 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
-	unsigned char dumpable:2;
+	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
 	int core_waiters;
Index: linux-2.6.22-rc2-mm1/fs/proc/base.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/fs/proc/base.c
+++ linux-2.6.22-rc2-mm1/fs/proc/base.c
@@ -1037,7 +1037,7 @@ static int task_dumpable(struct task_str
 	task_lock(task);
 	mm = task->mm;
 	if (mm)
-		dumpable = mm->dumpable;
+		dumpable = get_dumpable(mm);
 	task_unlock(task);
 	if(dumpable == 1)
 		return 1;
Index: linux-2.6.22-rc2-mm1/include/asm-ia64/processor.h
===================================================================
--- linux-2.6.22-rc2-mm1.orig/include/asm-ia64/processor.h
+++ linux-2.6.22-rc2-mm1/include/asm-ia64/processor.h
@@ -295,9 +295,9 @@ struct thread_struct {
 	regs->ar_bspstore = current->thread.rbs_bot;						\
 	regs->ar_fpsr = FPSR_DEFAULT;								\
 	regs->loadrs = 0;									\
-	regs->r8 = current->mm->dumpable;	/* set "don't zap registers" flag */		\
+	regs->r8 = get_dumpable(current->mm);	/* set "don't zap registers" flag */		\
 	regs->r12 = new_sp - 16;	/* allocate 16 byte scratch area */			\
-	if (unlikely(!current->mm->dumpable)) {							\
+	if (unlikely(!get_dumpable(current->mm))) {							\
 		/*										\
 		 * Zap scratch regs to avoid leaking bits between processes with different	\
 		 * uid/privileges.								\
Index: linux-2.6.22-rc2-mm1/kernel/ptrace.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/kernel/ptrace.c
+++ linux-2.6.22-rc2-mm1/kernel/ptrace.c
@@ -142,7 +142,7 @@ static int may_attach(struct task_struct
 		return -EPERM;
 	smp_rmb();
 	if (task->mm)
-		dumpable = task->mm->dumpable;
+		dumpable = get_dumpable(task->mm);
 	if (!dumpable && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
Index: linux-2.6.22-rc2-mm1/kernel/sys.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/kernel/sys.c
+++ linux-2.6.22-rc2-mm1/kernel/sys.c
@@ -1025,7 +1025,7 @@ asmlinkage long sys_setregid(gid_t rgid,
 			return -EPERM;
 	}
 	if (new_egid != old_egid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	if (rgid != (gid_t) -1 ||
@@ -1055,13 +1055,13 @@ asmlinkage long sys_setgid(gid_t gid)
 
 	if (capable(CAP_SETGID)) {
 		if (old_egid != gid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->gid = current->egid = current->sgid = current->fsgid = gid;
 	} else if ((gid == current->gid) || (gid == current->sgid)) {
 		if (old_egid != gid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->egid = current->fsgid = gid;
@@ -1092,7 +1092,7 @@ static int set_user(uid_t new_ruid, int 
 	switch_uid(new_user);
 
 	if (dumpclear) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	current->uid = new_ruid;
@@ -1148,7 +1148,7 @@ asmlinkage long sys_setreuid(uid_t ruid,
 		return -EAGAIN;
 
 	if (new_euid != old_euid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	current->fsuid = current->euid = new_euid;
@@ -1198,7 +1198,7 @@ asmlinkage long sys_setuid(uid_t uid)
 		return -EPERM;
 
 	if (old_euid != uid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 		smp_wmb();
 	}
 	current->fsuid = current->euid = uid;
@@ -1243,7 +1243,7 @@ asmlinkage long sys_setresuid(uid_t ruid
 	}
 	if (euid != (uid_t) -1) {
 		if (euid != current->euid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->euid = euid;
@@ -1293,7 +1293,7 @@ asmlinkage long sys_setresgid(gid_t rgid
 	}
 	if (egid != (gid_t) -1) {
 		if (egid != current->egid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->egid = egid;
@@ -1339,7 +1339,7 @@ asmlinkage long sys_setfsuid(uid_t uid)
 	    uid == current->suid || uid == current->fsuid || 
 	    capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->fsuid = uid;
@@ -1368,7 +1368,7 @@ asmlinkage long sys_setfsgid(gid_t gid)
 	    gid == current->sgid || gid == current->fsgid || 
 	    capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
-			current->mm->dumpable = suid_dumpable;
+			set_dumpable(current->mm, suid_dumpable);
 			smp_wmb();
 		}
 		current->fsgid = gid;
@@ -2165,14 +2165,14 @@ asmlinkage long sys_prctl(int option, un
 			error = put_user(current->pdeath_signal, (int __user *)arg2);
 			break;
 		case PR_GET_DUMPABLE:
-			error = current->mm->dumpable;
+			error = get_dumpable(current->mm);
 			break;
 		case PR_SET_DUMPABLE:
 			if (arg2 < 0 || arg2 > 1) {
 				error = -EINVAL;
 				break;
 			}
-			current->mm->dumpable = arg2;
+			set_dumpable(current->mm, arg2);
 			break;
 
 		case PR_SET_UNALIGN:
Index: linux-2.6.22-rc2-mm1/security/commoncap.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/security/commoncap.c
+++ linux-2.6.22-rc2-mm1/security/commoncap.c
@@ -241,7 +241,7 @@ void cap_bprm_apply_creds (struct linux_
 
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
 	    !cap_issubset (new_permitted, current->cap_permitted)) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 			if (!capable(CAP_SETUID)) {
Index: linux-2.6.22-rc2-mm1/security/dummy.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/security/dummy.c
+++ linux-2.6.22-rc2-mm1/security/dummy.c
@@ -130,7 +130,7 @@ static void dummy_bprm_free_security (st
 static void dummy_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 {
 	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid) {
-		current->mm->dumpable = suid_dumpable;
+		set_dumpable(current->mm, suid_dumpable);
 
 		if ((unsafe & ~LSM_UNSAFE_PTRACE_CAP) && !capable(CAP_SETUID)) {
 			bprm->e_uid = current->uid;


