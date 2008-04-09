Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYDIVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYDIVbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYDIVbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:31:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:30698 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYDIVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:31:11 -0400
Message-ID: <47FD359D.8030409@ct.jp.nec.com>
Date: Wed, 09 Apr 2008 14:31:09 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ipc: add shm_locked for IPC shm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Shared memory users probably don't think the shared memory is
swapped out. But actually shared memory could be swapped out under
memory pressure.
Linux has SHM_LOCK feature for prevent shared memory swapping,
and it can be used by shmctl() after create the shared memory.
There are some needs that SHM_LOCK is default behavior.

This patch adds shm_locked sysctl to turn SHM_LOCK on when creating.
kernel.shm_locked = 0, is default and the behavior is not changed.
kernel.shm_locked = 1, means shared memory will be locked when
it's created.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/ipc_namespace.h |    1 +
 include/linux/sysctl.h        |    1 +
 ipc/ipc_sysctl.c              |    9 +++++
 ipc/shm.c                     |   70 ++++++++++++++++++++++++----------------
 kernel/sysctl_check.c         |    2 +
 5 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index e4451d1..1323985 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -29,6 +29,7 @@ struct ipc_namespace {
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
+	int		shm_ctllocked;
 	int		shm_tot;
 };
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 571f01d..434c207 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -163,6 +163,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_SHMLOCKED=77,	/* int: make shared memory locked */
 };
 
 
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 7f4235b..00d43b2 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -123,6 +123,15 @@ static struct ctl_table ipc_kern_table[] = {
 		.strategy	= sysctl_ipc_data,
 	},
 	{
+		.ctl_name	= KERN_SHMLOCKED,
+		.procname	= "shm_locked",
+		.data		= &init_ipc_ns.shm_ctllocked,
+		.maxlen		= sizeof (init_ipc_ns.shm_ctllocked),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
+	},
+	{
 		.ctl_name	= KERN_MSGMAX,
 		.procname	= "msgmax",
 		.data		= &init_ipc_ns.msg_ctlmax,
diff --git a/ipc/shm.c b/ipc/shm.c
index cc63fae..6078477 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -66,6 +66,7 @@ static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
 static void shm_close(struct vm_area_struct *vma);
 static void shm_destroy (struct ipc_namespace *ns, struct shmid_kernel *shp);
+static int do_shmlock(struct shmid_kernel *shp, int cmd);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
@@ -75,6 +76,7 @@ void shm_init_ns(struct ipc_namespace *ns)
 	ns->shm_ctlmax = SHMMAX;
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
+	ns->shm_ctllocked = 0;
 	ns->shm_tot = 0;
 	ipc_init_ids(&ns->ids[IPC_SHM_IDS]);
 }
@@ -438,6 +440,9 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	 */
 	file->f_dentry->d_inode->i_ino = shp->shm_perm.id;
 
+	if (ns->shm_ctllocked)
+		do_shmlock(shp, SHM_LOCK);
+
 	ns->shm_tot += numpages;
 	error = shp->shm_perm.id;
 	shm_unlock(shp);
@@ -626,6 +631,42 @@ static void shm_get_stat(struct ipc_namespace *ns, unsigned long *rss,
 	}
 }
 
+static int do_shmlock(struct shmid_kernel *shp, int cmd)
+{
+	int err;
+
+	if (!capable(CAP_IPC_LOCK)) {
+		err = -EPERM;
+		if (current->euid != shp->shm_perm.uid &&
+		    current->euid != shp->shm_perm.cuid)
+			goto out;
+		if (cmd == SHM_LOCK &&
+		    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+			goto out;
+	}
+
+	err = security_shm_shmctl(shp, cmd);
+	if (err)
+		goto out;
+
+	if (cmd == SHM_LOCK) {
+		struct user_struct * user = current->user;
+		if (!is_file_hugepages(shp->shm_file)) {
+			err = shmem_lock(shp->shm_file, 1, user);
+			if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
+				shp->shm_perm.mode |= SHM_LOCKED;
+				shp->mlock_user = user;
+			}
+		}
+	} else if (!is_file_hugepages(shp->shm_file)) {
+		shmem_lock(shp->shm_file, 0, shp->mlock_user);
+		shp->shm_perm.mode &= ~SHM_LOCKED;
+		shp->mlock_user = NULL;
+	}
+out:
+	return err;
+}
+
 asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 {
 	struct shm_setbuf setbuf;
@@ -753,34 +794,7 @@ asmlinkage long sys_shmctl (int shmid, int cmd, struct shmid_ds __user *buf)
 		if (err)
 			goto out_unlock;
 
-		if (!capable(CAP_IPC_LOCK)) {
-			err = -EPERM;
-			if (current->euid != shp->shm_perm.uid &&
-			    current->euid != shp->shm_perm.cuid)
-				goto out_unlock;
-			if (cmd == SHM_LOCK &&
-			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
-				goto out_unlock;
-		}
-
-		err = security_shm_shmctl(shp, cmd);
-		if (err)
-			goto out_unlock;
-		
-		if(cmd==SHM_LOCK) {
-			struct user_struct * user = current->user;
-			if (!is_file_hugepages(shp->shm_file)) {
-				err = shmem_lock(shp->shm_file, 1, user);
-				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
-					shp->shm_perm.mode |= SHM_LOCKED;
-					shp->mlock_user = user;
-				}
-			}
-		} else if (!is_file_hugepages(shp->shm_file)) {
-			shmem_lock(shp->shm_file, 0, shp->mlock_user);
-			shp->shm_perm.mode &= ~SHM_LOCKED;
-			shp->mlock_user = NULL;
-		}
+		err = do_shmlock(shp, cmd);
 		shm_unlock(shp);
 		goto out;
 	}
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index c09350d..3d13649 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -104,6 +104,8 @@ static const struct trans_ctl_table trans_kern_table[] = {
 	{ KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
 	{ KERN_NMI_WATCHDOG,		"nmi_watchdog" },
 	{ KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
+
+	{ KERN_SHMLOCKED,		"shm_locked" },
 	{}
 };
 
-- 
1.5.4.1

