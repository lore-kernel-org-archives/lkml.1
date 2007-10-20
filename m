Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbXJUByk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbXJUByk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbXJUBwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:52:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56848 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbXJUBw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:52:29 -0400
Date: Sun, 21 Oct 2007 01:53:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/4] MultiAdmin 1.0.7
In-Reply-To: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710210152520.1997@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 4/4] MultiAdmin module

    -   Add the MultiAdmin to the mainline tree.
        I hope the rest is self-explanatory :)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, May 01 2006
Modified July 11 2006

---
 security/Kconfig    |   17 +
 security/Makefile   |    3 
 security/multiadm.c |  628 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 648 insertions(+)

Index: linux-2.6.23.1/security/Kconfig
===================================================================
--- linux-2.6.23.1.orig/security/Kconfig
+++ linux-2.6.23.1/security/Kconfig
@@ -81,6 +81,23 @@ config SECURITY_NETWORK_XFRM
 	  IPSec.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_MULTIADM
+	tristate "MultiAdmin security module"
+	depends on SECURITY
+	select SECURITY_CAPABILITIES
+	---help---
+        The MultiAdmin security kernel module provides means to have multiple
+        "root" users with unique UIDs. This fixes collation order problems
+        which for example appear with NSCD, allows to have files with
+        determinable owner and allows to track the quota usage for every
+        user, since they now have a unique uid.
+
+        It also implements a "sub-admin", a partially restricted root user
+        (or enhanced normal user, depending on the way you see it), who has
+        full read-only access to most subsystems, and additional write rights
+        only to a limited subset, e.g. writing to files or killing processes
+        only of certain users.
+
 config SECURITY_CAPABILITIES
 	tristate "Default Linux Capabilities"
 	depends on SECURITY
Index: linux-2.6.23.1/security/Makefile
===================================================================
--- linux-2.6.23.1.orig/security/Makefile
+++ linux-2.6.23.1/security/Makefile
@@ -2,6 +2,9 @@
 # Makefile for the kernel security code
 #
 
+obj-$(CONFIG_SECURITY_MULTIADM)		+= multiadm.o
+CFLAGS_multiadm.o += $(if $(wildcard security/apparmor),-DAPPARMOR,)
+
 obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 
Index: linux-2.6.23.1/security/multiadm.c
===================================================================
--- /dev/null
+++ linux-2.6.23.1/security/multiadm.c
@@ -0,0 +1,628 @@
+/*
+ *	MultiAdmin Security Module
+ *	Copyright © Jan Engelhardt <jengelh [at] gmx de>, 2005 - 2007
+ *	v1.0.7, July 2007
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	version 2 or 3 as published by the Free Software Foundation.
+ */
+#include <linux/binfmts.h>
+#include <linux/capability.h>
+#include <linux/dcache.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/ipc.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/namei.h>
+#include <linux/sched.h>
+#include <linux/securebits.h>
+#include <linux/security.h>
+#include <linux/sem.h>
+#include <linux/types.h>
+#include <asm/siginfo.h>
+
+/* Out of tree helper */
+#if !defined(CONFIG_SECURITY_CAPABILITIES) && \
+    !defined(CONFIG_SECURITY_CAPABILITIES_MODULE)
+#	error You need to have CONFIG_SECURITY_CAPABILITIES=y or =m \
+		for MultiAdmin to compile successfully.
+#endif
+
+#define BASENAME "multiadm"
+#define PREFIX   BASENAME ": "
+
+static gid_t Supergid         = -1;
+static gid_t Subgid           = -1;
+static uid_t Superuid_start   = 0;
+static uid_t Superuid_end     = 0;
+static uid_t Subuid_start     = -1;
+static uid_t Subuid_end       = -1;
+static uid_t Wrtuid_start     = -1;
+static uid_t Wrtuid_end       = -1;
+static unsigned int Secondary = 0;
+
+module_param(Supergid,       int, S_IRUSR | S_IWUSR);
+module_param(Superuid_start, int, S_IRUSR | S_IWUSR);
+module_param(Superuid_end,   int, S_IRUSR | S_IWUSR);
+module_param(Subuid_start,   int, S_IRUSR | S_IWUSR);
+module_param(Subuid_end,     int, S_IRUSR | S_IWUSR);
+module_param(Subgid,         int, S_IRUSR | S_IWUSR);
+module_param(Wrtuid_start,   int, S_IRUGO | S_IWUSR);
+module_param(Wrtuid_end,     int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(Wrtuid_start,   "First UID of the write-enabled user range");
+MODULE_PARM_DESC(Wrtuid_end,     "Last UID of the write-enabled user range");
+MODULE_PARM_DESC(Superuid_start, "First UIDs of the superadmin range");
+MODULE_PARM_DESC(Superuid_end,   "Last UID of the superadmin range");
+MODULE_PARM_DESC(Supergid,       "Superadmin GID");
+MODULE_PARM_DESC(Subuid_start,   "First UIDs of the subadmin range");
+MODULE_PARM_DESC(Subuid_end,     "Last UID of the subadmin range");
+MODULE_PARM_DESC(Subgid,         "Subadmin GID");
+
+static inline void chg2_superadm(kernel_cap_t *c)
+{
+	cap_set_full(*c);
+	cap_lower(*c, CAP_SETPCAP);
+	/* Flag 31 is unused, but set */
+	cap_lower(*c, 31);
+	printk(KERN_WARNING "Changed to superadm\n");
+	return;
+}
+
+static inline void chg2_subadm(kernel_cap_t *c)
+{
+	cap_clear(*c);
+	cap_raise(*c, CAP_CHOWN);
+	cap_raise(*c, CAP_DAC_OVERRIDE);
+	cap_raise(*c, CAP_DAC_READ_SEARCH);
+	cap_raise(*c, CAP_FOWNER);
+	cap_raise(*c, CAP_KILL);
+	cap_raise(*c, CAP_SETUID);
+	cap_raise(*c, CAP_IPC_OWNER);
+	cap_raise(*c, CAP_SYS_PTRACE);
+	cap_raise(*c, CAP_SYS_ADMIN);
+	cap_raise(*c, CAP_SYS_NICE);
+	return;
+}
+
+static inline bool __is_uid_superadm(uid_t u)
+{
+	return (!issecure(SECURE_NOROOT) && u == 0) ||
+	       (Superuid_start != -1 && Superuid_end != -1 &&
+	       u >= Superuid_start && u <= Superuid_end);
+}
+
+static inline bool is_uid_superadm(uid_t u)
+{
+	bool r = __is_uid_superadm(u);
+	printk(KERN_WARNING "You are uid_superadm=%d\n", (int)r);
+	return r;
+}
+
+static inline bool is_gid_superadm(gid_t g)
+{
+	return Supergid != -1 && g == Supergid;
+}
+
+static inline bool is_any_superadm(uid_t u, gid_t g)
+{
+	return is_uid_superadm(u) || is_gid_superadm(g);
+}
+
+static inline bool is_uid_subadm(uid_t u)
+{
+	return Subuid_start != -1 && Subuid_end != -1 &&
+	       u >= Subuid_start && u <= Subuid_end;
+}
+
+static inline bool is_gid_subadm(gid_t g)
+{
+	return Subgid != -1 && g == Subgid;
+}
+
+static inline bool is_any_subadm(uid_t u, gid_t g)
+{
+	return is_uid_subadm(u) || is_gid_subadm(g);
+}
+
+static inline bool is_uid_user(uid_t u)
+{
+	/*
+	 * Special case Wrtuid_end == (unsigned) -1 means what it means:
+	 * everything until the end. This is why there is no
+	 * Wrtuid_end != -1 check.
+	 */
+	return Wrtuid_start != -1 && u >= Wrtuid_start && u <= Wrtuid_end;
+}
+
+static inline bool is_task1_user(const struct task_struct *task)
+{
+	return is_uid_user(task->uid) || is_uid_user(task->suid);
+}
+
+static inline bool is_task_user(const struct task_struct *task)
+{
+	return is_uid_user(task->euid) && is_uid_user(task->uid) &&
+	       is_uid_user(task->suid);
+}
+
+static inline bool range_intersect(uid_t as, uid_t ae, uid_t bs, uid_t be)
+{
+	if(as == -1 || ae == -1 || bs == -1 || be == -1)
+		return 0;
+	return (long)ae >= (long)bs && (long)as <= (long)be;
+}
+
+static inline bool range_intersect_wrt(uid_t as, uid_t ae, uid_t bs, uid_t be)
+{
+	if(as == -1 || ae == -1 || bs == -1)
+		return 0;
+	return (long)ae >= (long)bs && (long)as <= (long)be;
+}
+
+static int mt_bprm_set_security(struct linux_binprm *bp)
+{
+	/*
+	 * In the function chain of exec(), we eventually get here, which is
+	 * the place to set up new privileges.
+	 */
+	cap_bprm_set_security(bp);
+
+	/*
+	 * All of the following is nicely inlined. The capability raising is
+	 * resolved to only one instruction for each set.
+	 */
+	if(is_any_superadm(bp->e_uid, bp->e_gid)) {
+		chg2_superadm(&bp->cap_permitted);
+		chg2_superadm(&bp->cap_effective);
+	} else if(is_any_superadm(current->uid, current->gid)) {
+		chg2_superadm(&bp->cap_permitted);
+	} else if(is_any_subadm(bp->e_uid, bp->e_gid)) {
+		chg2_subadm(&bp->cap_permitted);
+		chg2_subadm(&bp->cap_effective);
+	} else if(is_any_subadm(current->uid, current->gid)) {
+		chg2_subadm(&bp->cap_permitted);
+	}
+	return 0;
+}
+
+static int mt_cap_extra(struct task_struct *task, unsigned int capability)
+{
+	/*
+	 * Subadmin also has CAP_SYS_ADMIN, but if we get here, we did so by
+	 * capable() -- not capable_light().
+	 */
+	if (capability != CAP_SYS_ADMIN)
+		return 0;
+	if (!is_any_superadm(current->euid, current->egid))
+		return -EPERM;
+	return 0;
+}
+
+static int mt_inode_permission(struct inode *inode, int mask,
+    struct nameidata *nd)
+{
+	/*
+	 * Check for superadmin is not done, since the only users that can get
+	 * here is either superadmin or subadmin. By omitting the check for
+	 * superadmin, only two comparisons need to be done for the subadmin
+	 * case. This method is done almost throughout the entire module.
+	 */
+	int ret;
+
+	if (is_any_subadm(current->euid, current->egid) &&
+	    (mask & MAY_WRITE)) {
+		if (inode->i_uid == current->fsuid ||
+		    is_uid_user(inode->i_uid))
+			return 0;
+
+		/*
+		 * Since we practically jumped over the checks to get here
+		 * (because of CAP_DAC_OVERRIDE), we need to do it again.
+		 * Without CAP_DAC_OVERRIDE this time. Temporarily drop it.
+		 */
+		cap_lower(current->cap_effective, CAP_DAC_OVERRIDE);
+
+		/* Copied from fs/namei.c */
+		if (inode->i_op != NULL && inode->i_op->permission != NULL)
+			ret = inode->i_op->permission(inode,
+			      mask & ~MAY_APPEND, nd);
+		else
+			ret = generic_permission(inode,
+			      mask & ~MAY_APPEND, NULL);
+
+		cap_raise(current->cap_effective, CAP_DAC_OVERRIDE);
+		return ret;
+	}
+	return 0;
+}
+
+#ifdef APPARMOR
+static int mt_inode_setattr(struct dentry *dentry, struct vfsmount *vfs,
+    struct iattr *attr)
+#else
+static int mt_inode_setattr(struct dentry *dentry, struct iattr *attr)
+#endif
+{
+	const struct inode *inode;
+
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+
+	/*
+	 * Change is only allowed if either the inode belongs to us, or
+	 * does belond, _and_ will belong in case of ATTR_UID, to a WRT
+	 * user.
+	 */
+	inode = dentry->d_inode;
+
+	if (inode->i_uid != current->fsuid && !is_uid_user(inode->i_uid))
+		return -EPERM;
+
+	if ((attr->ia_valid & ATTR_UID) && attr->ia_uid != current->fsuid &&
+	    !is_uid_user(attr->ia_uid))
+		return -EPERM;
+
+	return 0;
+}
+
+static int mt_ipc_permission(struct kern_ipc_perm *perm, short flag)
+{
+	int req, grant;
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+
+	if (perm->uid == current->euid || perm->cuid == current->euid ||
+	    is_uid_user(perm->uid) || is_uid_user(perm->cuid))
+		return 0;
+
+	/*
+	 * Copied and modified from ipc/util.c. Subadmin always has read
+	 * permission so add S_IRUGO to granted. Checking the owner permission
+	 * part is not done anymore, because it is done above.
+	 */
+	req   = (flag >> 6) | (flag >> 3) | flag;
+	grant = (perm->mode | S_IRUGO) >> 3;
+	if(in_group_p(perm->gid) || in_group_p(perm->cgid))
+		grant >>= 3;
+	if(req & ~grant & 0007)
+		return -EPERM;
+	return 0;
+}
+
+static int mt_msq_msgctl(struct msg_queue *msq, int cmd)
+{
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+
+	if (cmd == MSG_INFO || cmd == MSG_STAT ||
+	    cmd == IPC_INFO || cmd == IPC_STAT)
+		return 0;
+
+	/* UID or CUID (creator UID) must fit */
+	if (msq != NULL && msq->q_perm.uid != current->euid &&
+	    msq->q_perm.cuid != current->euid &&
+	    !is_uid_user(msq->q_perm.uid) && !is_uid_user(msq->q_perm.cuid))
+		return -EPERM;
+
+	return 0;
+}
+
+static int mt_ptrace(struct task_struct *tracer, struct task_struct *task)
+{
+	if (!is_any_subadm(tracer->euid, tracer->egid))
+		return 0;
+
+	/*
+	 * Ownership check according to kernel/ptrace.c:
+	 * all of [RES][UG]ID must match the tracer's R[UG]ID.
+	 */
+	if (task->euid == tracer->uid && task->uid == tracer->uid &&
+	    task->suid == tracer->uid && task->egid == tracer->gid &&
+	    task->gid == tracer->gid && task->sgid == tracer->gid)
+		return 0;
+
+	/* ...or all [RES]UIDs must match a WRT user */
+	if (!is_task_user(task))
+		return -EPERM;
+	return 0;
+}
+
+static int mt_quotactl(int cmd, int type, int id, struct super_block *sb)
+{
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+
+	switch(cmd) {
+		case Q_SYNC:
+		case Q_GETFMT:
+		case Q_GETINFO:
+		case Q_GETQUOTA:
+		case Q_XGETQUOTA:
+		case Q_XGETQSTAT:
+		case Q_XQUOTASYNC:
+			return 0;
+	}
+	return -EPERM;
+}
+
+static int mt_sem_semctl(struct sem_array *sem, int cmd)
+{
+	if (!is_any_subadm(current->euid, current->euid))
+		return 0;
+
+	if (cmd == SEM_INFO || cmd == IPC_INFO || cmd == SEM_STAT)
+		return 0;
+	if (sem != NULL) {
+		const struct kern_ipc_perm *perm = &sem->sem_perm;
+
+		if (perm->uid != current->euid &&
+		    perm->cuid != current->euid &&
+		    !is_uid_user(perm->uid) && !is_uid_user(perm->cuid))
+			return -EPERM;
+	}
+	return 0;
+}
+
+static int mt_shm_shmctl(struct shmid_kernel *shp, int cmd)
+{
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+
+	if (cmd == SHM_INFO || cmd == SHM_STAT ||
+	    cmd == IPC_INFO || cmd == IPC_STAT)
+		return 0;
+	if (shp != NULL) {
+		const struct kern_ipc_perm *perm = &shp->shm_perm;
+
+		if (perm->uid != current->euid &&
+		    perm->cuid != current->euid &&
+		    !is_uid_user(perm->uid) && !is_uid_user(perm->cuid))
+			return -EPERM;
+	}
+	return 0;
+}
+
+static int mt_task_kill(struct task_struct *task, struct siginfo *si,
+    int sig, u32 secid)
+{
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+
+	/* As tricky as the ptrace() permission net. */
+	if(is_uid_user(task->uid) || is_uid_user(task->suid))
+		return 0;
+
+	/* Subadmin's own process */
+	if (task->uid == current->euid || task->suid == current->euid ||
+	    task->uid == current->uid || task->suid == current->uid)
+		return 0;
+
+	/* SIG_IGN or a kernel-generated signal */
+	if (si != NULL && ((long)si == 1 || (long)si == 2 || !SI_FROMUSER(si)))
+		return 0;
+
+	/* For the case of a privileged subshell, but with the same tty */
+	if (sig == SIGCONT &&
+	    task->signal->__session == current->signal->__session)
+		return 0;
+
+	return -EPERM;
+}
+
+static int mt_task_post_setuid(uid_t old_ruid, uid_t old_euid,
+    uid_t old_suid, int flags)
+{
+	int ret = cap_task_post_setuid(old_ruid, old_euid, old_suid, flags);
+
+	if (ret != 0)
+		return ret;
+
+	switch (flags) {
+		case LSM_SETID_ID:
+		case LSM_SETID_RE:
+		case LSM_SETID_RES:
+			/*
+			 * Unlike bprm_set_security(), effective must be set
+			 * independently.
+			 */
+			if (is_uid_superadm(current->uid))
+				chg2_superadm(&current->cap_permitted);
+			else if (is_uid_subadm(current->uid))
+				chg2_subadm(&current->cap_permitted);
+
+			if (is_uid_superadm(current->euid))
+				chg2_superadm(&current->cap_effective);
+			else if (is_uid_subadm(current->euid))
+				chg2_subadm(&current->cap_effective);
+			break;
+	}
+	return 0;
+}
+
+static int mt_task_post_setgid(gid_t old_rgid, gid_t old_egid,
+    gid_t old_sgid, unsigned int flags)
+{
+	switch (flags) {
+		case LSM_SETID_ID:
+		case LSM_SETID_RE:
+		case LSM_SETID_RES:
+			if (is_gid_superadm(current->gid))
+				chg2_superadm(&current->cap_permitted);
+			else if (is_gid_subadm(current->gid))
+				chg2_subadm(&current->cap_permitted);
+
+			if (is_gid_superadm(current->egid))
+				chg2_superadm(&current->cap_effective);
+			else if (is_gid_subadm(current->egid))
+				chg2_subadm(&current->cap_effective);
+			break;
+	}
+	return 0;
+}
+
+static int mt_task_setuid(uid_t ruid, uid_t euid, uid_t suid, int flags)
+{
+	if (is_any_superadm(current->euid, current->egid))
+		return 0;
+
+	if (is_any_subadm(current->euid, current->egid))
+		if ((ruid == -1 || is_uid_user(ruid)) &&
+		    (euid == -1 || is_uid_user(euid)) &&
+		    (suid == -1 || is_uid_user(suid)))
+			return 0;
+
+	switch (flags) {
+		case LSM_SETID_ID:
+			if (current->uid == ruid || current->suid == ruid)
+				return 0;
+			break;
+		case LSM_SETID_RE:
+			if (current->euid == ruid || current->euid == euid ||
+			    current->uid == ruid || current->uid == euid ||
+			    current->suid == euid)
+				return 0;
+			break;
+		case LSM_SETID_RES:
+			if (current->euid == ruid || current->euid == euid ||
+			    current->euid == suid || current->uid == ruid ||
+			    current->uid == euid || current->uid == suid ||
+			    current->suid == ruid || current->suid == euid ||
+			    current->suid == suid)
+				return 0;
+			break;
+		case LSM_SETID_FS:
+			if (current->euid == ruid)
+				return 0;
+			break;
+		default:
+			WARN_ON(1);
+			break;
+	}
+	return -EPERM;
+}
+
+static int mt_task_setnice(struct task_struct *task, int nice)
+{
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+	if (task->euid != current->euid && task->uid != current->euid &&
+	    !is_task1_user(task))
+		return -EPERM;
+	if (nice < 0)
+		return -EACCES;
+	return 0;
+}
+
+static int mt_task_setscheduler(struct task_struct *task, int policy,
+    struct sched_param *param)
+{
+	/*
+	 * Return 0 for superuser and normal users. The latters' checks are
+	 * performed in sched.c.
+	 */
+	if (!is_any_subadm(current->euid, current->egid))
+		return 0;
+
+	/* Copied from kernel/sched.c:sched_setscheduler() */
+	if (task->policy != policy)
+		return -EPERM;
+
+	if (policy != SCHED_NORMAL &&
+	    param->sched_priority > task->rt_priority &&
+	    param->sched_priority > task->signal->rlim[RLIMIT_RTPRIO].rlim_cur)
+		return -EPERM;
+
+	if (task->uid != current->euid && task->suid != current->euid &&
+	    !is_task1_user(task))
+		return -EPERM;
+
+	return 0;
+}
+
+static struct security_operations mt_secops = {
+	.bprm_apply_creds      = cap_bprm_apply_creds,
+	.bprm_set_security     = mt_bprm_set_security,
+	.cap_extra             = mt_cap_extra,
+	.capable               = cap_capable,
+	.capget                = cap_capget,
+	.capset_check          = cap_capset_check,
+	.capset_set            = cap_capset_set,
+	.inode_permission      = mt_inode_permission,
+	.inode_setattr         = mt_inode_setattr,
+	.ipc_permission        = mt_ipc_permission,
+	.msg_queue_msgctl      = mt_msq_msgctl,
+	.ptrace                = mt_ptrace,
+	.quotactl              = mt_quotactl,
+	.sem_semctl            = mt_sem_semctl,
+	.shm_shmctl            = mt_shm_shmctl,
+	.task_kill             = mt_task_kill,
+	.task_post_setuid      = mt_task_post_setuid,
+	.task_post_setgid      = mt_task_post_setgid,
+	.task_setnice          = mt_task_setnice,
+	.task_setscheduler     = mt_task_setscheduler,
+	.task_setuid           = mt_task_setuid,
+};
+
+static __init int multiadm_init(void)
+{
+	int ret, ret2;
+
+	if ((ret = register_security(&mt_secops)) != 0) {
+		if ((ret2 = mod_reg_security(BASENAME, &mt_secops)) != 0) {
+			printk(KERN_WARNING PREFIX "Could not register with "
+			       "kernel: %d, %d\n", ret, ret2);
+			return ret2;
+		}
+		Secondary = 1;
+	}
+
+	if (range_intersect(Superuid_start, Superuid_end,
+	    Subuid_start, Subuid_end))
+		printk(KERN_WARNING PREFIX
+		       "Superadmin and Subadmin ranges intersect! "
+		       "Unpredictable behavior may result: some operations "
+		       "may classify you as a superadmin, others as a "
+		       "subadmin. Security leak: subadmin could possibly "
+		       "change into superadmin!\n");
+
+	if (range_intersect(Superuid_start, Superuid_end,
+	    Wrtuid_start, Wrtuid_end))
+		printk(KERN_WARNING PREFIX
+		       "Superadmin and write-enabled user range intersect! "
+		       "A subadmin could setuid() into a superadmin!\n");
+
+	if (range_intersect_wrt(Subuid_start, Subuid_end,
+	    Wrtuid_start, Wrtuid_end))
+		printk(KERN_WARNING PREFIX
+		       "Subadmin and write-enabled user range intersect! "
+		       "Subadmins are able to poke on other subadmins!\n");
+
+	printk(KERN_INFO "MultiAdmin loaded\n");
+	return 0;
+}
+
+static __exit void multiadm_exit(void)
+{
+	int ret = 0;
+
+	if(Secondary)
+		ret = mod_unreg_security(BASENAME, &mt_secops);
+	else
+		ret = unregister_security(&mt_secops);
+
+	if(ret != 0)
+		printk(KERN_WARNING PREFIX
+			   "Could not unregister with kernel: %d\n", ret);
+
+	return;
+}
+
+module_init(multiadm_init);
+module_exit(multiadm_exit);
+MODULE_DESCRIPTION("MultiAdmin Security Module");
+MODULE_AUTHOR("Jan Engelhardt <jengelh [at] gmx de>");
+MODULE_LICENSE("GPL");
