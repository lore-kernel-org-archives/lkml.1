Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYH0OAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYH0OAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbYH0NvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:51:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbYH0NvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:51:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 49/59] CRED: Wrap task credential accesses in the SYSV IPC
	subsystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>
Date: Wed, 27 Aug 2008 14:49:55 +0100
Message-ID: <20080827134955.19980.39541.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 ipc/mqueue.c |    6 +++---
 ipc/shm.c    |    5 +++--
 ipc/util.c   |   18 +++++++++++++-----
 3 files changed, 19 insertions(+), 10 deletions(-)


diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 96fb36c..51d9588 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -109,8 +109,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb, int mode,
 	inode = new_inode(sb);
 	if (inode) {
 		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
+		inode->i_uid = current_fsuid();
+		inode->i_gid = current_fsgid();
 		inode->i_blocks = 0;
 		inode->i_mtime = inode->i_ctime = inode->i_atime =
 				CURRENT_TIME;
@@ -499,7 +499,7 @@ static void __do_notify(struct mqueue_inode_info *info)
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
 			sig_i.si_pid = task_tgid_vnr(current);
-			sig_i.si_uid = current->uid;
+			sig_i.si_uid = current_uid();
 
 			kill_pid_info(info->notify.sigev_signo,
 				      &sig_i, info->notify_owner);
diff --git a/ipc/shm.c b/ipc/shm.c
index e77ec69..c46a7e6 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -748,9 +748,10 @@ asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
 			goto out_unlock;
 
 		if (!capable(CAP_IPC_LOCK)) {
+			uid_t euid = current_euid();
 			err = -EPERM;
-			if (current->euid != shp->shm_perm.uid &&
-			    current->euid != shp->shm_perm.cuid)
+			if (euid != shp->shm_perm.uid &&
+			    euid != shp->shm_perm.cuid)
 				goto out_unlock;
 			if (cmd == SHM_LOCK &&
 			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
diff --git a/ipc/util.c b/ipc/util.c
index 49b3ea6..c8a7670 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -258,6 +258,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
+	uid_t euid;
+	gid_t egid;
 	int id, err;
 
 	if (size > IPCMNI)
@@ -272,8 +274,9 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 
 	ids->in_use++;
 
-	new->cuid = new->uid = current->euid;
-	new->gid = new->cgid = current->egid;
+	current_euid_egid(&euid, &egid);
+	new->cuid = new->uid = euid;
+	new->gid = new->cgid = egid;
 
 	new->seq = ids->seq++;
 	if(ids->seq > ids->seq_max)
@@ -616,13 +619,15 @@ void ipc_rcu_putref(void *ptr)
  
 int ipcperms (struct kern_ipc_perm *ipcp, short flag)
 {	/* flag will most probably be 0 or S_...UGO from <linux/stat.h> */
+	uid_t euid = current_euid();
 	int requested_mode, granted_mode, err;
 
 	if (unlikely((err = audit_ipc_obj(ipcp))))
 		return err;
 	requested_mode = (flag >> 6) | (flag >> 3) | flag;
 	granted_mode = ipcp->mode;
-	if (current->euid == ipcp->cuid || current->euid == ipcp->uid)
+	if (euid == ipcp->cuid ||
+	    euid == ipcp->uid)
 		granted_mode >>= 6;
 	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
 		granted_mode >>= 3;
@@ -784,6 +789,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
+	uid_t euid;
 	int err;
 
 	down_write(&ids->rw_mutex);
@@ -803,8 +809,10 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 		if (err)
 			goto out_unlock;
 	}
-	if (current->euid == ipcp->cuid ||
-	    current->euid == ipcp->uid || capable(CAP_SYS_ADMIN))
+
+	euid = current_euid();
+	if (euid == ipcp->cuid ||
+	    euid == ipcp->uid  || capable(CAP_SYS_ADMIN))
 		return ipcp;
 
 	err = -EPERM;

