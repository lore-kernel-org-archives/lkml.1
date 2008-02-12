Return-Path: <linux-kernel-owner+w=401wt.eu-S1763839AbYBLQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763839AbYBLQ3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759182AbYBLQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:29:46 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54512 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939AbYBLQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:29:45 -0500
Message-Id: <20080212162952.025585905@bull.net>
References: <20080212161340.200976067@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 17:13:46 +0100
From: pierre.peiffer@bull.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-mm1 6/8] (resend) IPC: get rid of the use *_setbuf structure.
Content-Disposition: inline; filename=ipc_remove_all_setbuf_struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Peiffer <pierre.peiffer@bull.net>

All IPCs make use of an intermetiate *_setbuf structure to handle the
IPC_SET command. This is not really needed and, moreover, it complicates
a little bit the code.

This patch get rid of the use of it and uses directly the semid64_ds/
msgid64_ds/shmid64_ds structure.

In addition of removing one struture declaration, it also simplifies
and improves a little bit the common 64-bits path.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 ipc/msg.c |   51 ++++++++++++++++++---------------------------------
 ipc/sem.c |   40 ++++++++++++++--------------------------
 ipc/shm.c |   41 ++++++++++++++---------------------------
 3 files changed, 46 insertions(+), 86 deletions(-)

Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -388,31 +388,14 @@ copy_msqid_to_user(void __user *buf, str
 	}
 }
 
-struct msq_setbuf {
-	unsigned long	qbytes;
-	uid_t		uid;
-	gid_t		gid;
-	mode_t		mode;
-};
-
 static inline unsigned long
-copy_msqid_from_user(struct msq_setbuf *out, void __user *buf, int version)
+copy_msqid_from_user(struct msqid64_ds *out, void __user *buf, int version)
 {
 	switch(version) {
 	case IPC_64:
-	{
-		struct msqid64_ds tbuf;
-
-		if (copy_from_user(&tbuf, buf, sizeof(tbuf)))
+		if (copy_from_user(out, buf, sizeof(*out)))
 			return -EFAULT;
-
-		out->qbytes		= tbuf.msg_qbytes;
-		out->uid		= tbuf.msg_perm.uid;
-		out->gid		= tbuf.msg_perm.gid;
-		out->mode		= tbuf.msg_perm.mode;
-
 		return 0;
-	}
 	case IPC_OLD:
 	{
 		struct msqid_ds tbuf_old;
@@ -420,14 +403,14 @@ copy_msqid_from_user(struct msq_setbuf *
 		if (copy_from_user(&tbuf_old, buf, sizeof(tbuf_old)))
 			return -EFAULT;
 
-		out->uid		= tbuf_old.msg_perm.uid;
-		out->gid		= tbuf_old.msg_perm.gid;
-		out->mode		= tbuf_old.msg_perm.mode;
+		out->msg_perm.uid      	= tbuf_old.msg_perm.uid;
+		out->msg_perm.gid      	= tbuf_old.msg_perm.gid;
+		out->msg_perm.mode     	= tbuf_old.msg_perm.mode;
 
 		if (tbuf_old.msg_qbytes == 0)
-			out->qbytes	= tbuf_old.msg_lqbytes;
+			out->msg_qbytes	= tbuf_old.msg_lqbytes;
 		else
-			out->qbytes	= tbuf_old.msg_qbytes;
+			out->msg_qbytes	= tbuf_old.msg_qbytes;
 
 		return 0;
 	}
@@ -445,12 +428,12 @@ static int msgctl_down(struct ipc_namesp
 		       struct msqid_ds __user *buf, int version)
 {
 	struct kern_ipc_perm *ipcp;
-	struct msq_setbuf setbuf;
+	struct msqid64_ds msqid64;
 	struct msg_queue *msq;
 	int err;
 
 	if (cmd == IPC_SET) {
-		if (copy_msqid_from_user(&setbuf, buf, version))
+		if (copy_msqid_from_user(&msqid64, buf, version))
 			return -EFAULT;
 	}
 
@@ -468,8 +451,10 @@ static int msgctl_down(struct ipc_namesp
 		goto out_unlock;
 
 	if (cmd == IPC_SET) {
-		err = audit_ipc_set_perm(setbuf.qbytes, setbuf.uid, setbuf.gid,
-					 setbuf.mode);
+		err = audit_ipc_set_perm(msqid64.msg_qbytes,
+					 msqid64.msg_perm.uid,
+					 msqid64.msg_perm.gid,
+					 msqid64.msg_perm.mode);
 		if (err)
 			goto out_unlock;
 	}
@@ -491,18 +476,18 @@ static int msgctl_down(struct ipc_namesp
 		freeque(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		if (setbuf.qbytes > ns->msg_ctlmnb &&
+		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EPERM;
 			goto out_unlock;
 		}
 
-		msq->q_qbytes = setbuf.qbytes;
+		msq->q_qbytes = msqid64.msg_qbytes;
 
-		ipcp->uid = setbuf.uid;
-		ipcp->gid = setbuf.gid;
+		ipcp->uid = msqid64.msg_perm.uid;
+		ipcp->gid = msqid64.msg_perm.gid;
 		ipcp->mode = (ipcp->mode & ~S_IRWXUGO) |
-			     (S_IRWXUGO & setbuf.mode);
+			     (S_IRWXUGO & msqid64.msg_perm.mode);
 		msq->q_ctime = get_seconds();
 		/* sleeping receivers might be excluded by
 		 * stricter permissions.
Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -835,28 +835,14 @@ out_free:
 	return err;
 }
 
-struct sem_setbuf {
-	uid_t	uid;
-	gid_t	gid;
-	mode_t	mode;
-};
-
-static inline unsigned long copy_semid_from_user(struct sem_setbuf *out, void __user *buf, int version)
+static inline unsigned long
+copy_semid_from_user(struct semid64_ds *out, void __user *buf, int version)
 {
 	switch(version) {
 	case IPC_64:
-	    {
-		struct semid64_ds tbuf;
-
-		if(copy_from_user(&tbuf, buf, sizeof(tbuf)))
+		if (copy_from_user(out, buf, sizeof(*out)))
 			return -EFAULT;
-
-		out->uid	= tbuf.sem_perm.uid;
-		out->gid	= tbuf.sem_perm.gid;
-		out->mode	= tbuf.sem_perm.mode;
-
 		return 0;
-	    }
 	case IPC_OLD:
 	    {
 		struct semid_ds tbuf_old;
@@ -864,9 +850,9 @@ static inline unsigned long copy_semid_f
 		if(copy_from_user(&tbuf_old, buf, sizeof(tbuf_old)))
 			return -EFAULT;
 
-		out->uid	= tbuf_old.sem_perm.uid;
-		out->gid	= tbuf_old.sem_perm.gid;
-		out->mode	= tbuf_old.sem_perm.mode;
+		out->sem_perm.uid	= tbuf_old.sem_perm.uid;
+		out->sem_perm.gid	= tbuf_old.sem_perm.gid;
+		out->sem_perm.mode	= tbuf_old.sem_perm.mode;
 
 		return 0;
 	    }
@@ -885,11 +871,11 @@ static int semctl_down(struct ipc_namesp
 {
 	struct sem_array *sma;
 	int err;
-	struct sem_setbuf uninitialized_var(setbuf);
+	struct semid64_ds semid64;
 	struct kern_ipc_perm *ipcp;
 
 	if(cmd == IPC_SET) {
-		if(copy_semid_from_user (&setbuf, arg.buf, version))
+		if (copy_semid_from_user(&semid64, arg.buf, version))
 			return -EFAULT;
 	}
 	down_write(&sem_ids(ns).rw_mutex);
@@ -906,7 +892,9 @@ static int semctl_down(struct ipc_namesp
 		goto out_unlock;
 
 	if (cmd == IPC_SET) {
-		err = audit_ipc_set_perm(0, setbuf.uid, setbuf.gid, setbuf.mode);
+		err = audit_ipc_set_perm(0, semid64.sem_perm.uid,
+					 semid64.sem_perm.gid,
+					 semid64.sem_perm.mode);
 		if (err)
 			goto out_unlock;
 	}
@@ -925,10 +913,10 @@ static int semctl_down(struct ipc_namesp
 		freeary(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		ipcp->uid = setbuf.uid;
-		ipcp->gid = setbuf.gid;
+		ipcp->uid = semid64.sem_perm.uid;
+		ipcp->gid = semid64.sem_perm.gid;
 		ipcp->mode = (ipcp->mode & ~S_IRWXUGO)
-				| (setbuf.mode & S_IRWXUGO);
+				| (semid64.sem_perm.mode & S_IRWXUGO);
 		sma->sem_ctime = get_seconds();
 		break;
 	default:
Index: b/ipc/shm.c
===================================================================
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -512,28 +512,14 @@ static inline unsigned long copy_shmid_t
 	}
 }
 
-struct shm_setbuf {
-	uid_t	uid;
-	gid_t	gid;
-	mode_t	mode;
-};	
-
-static inline unsigned long copy_shmid_from_user(struct shm_setbuf *out, void __user *buf, int version)
+static inline unsigned long
+copy_shmid_from_user(struct shmid64_ds *out, void __user *buf, int version)
 {
 	switch(version) {
 	case IPC_64:
-	    {
-		struct shmid64_ds tbuf;
-
-		if (copy_from_user(&tbuf, buf, sizeof(tbuf)))
+		if (copy_from_user(out, buf, sizeof(*out)))
 			return -EFAULT;
-
-		out->uid	= tbuf.shm_perm.uid;
-		out->gid	= tbuf.shm_perm.gid;
-		out->mode	= tbuf.shm_perm.mode;
-
 		return 0;
-	    }
 	case IPC_OLD:
 	    {
 		struct shmid_ds tbuf_old;
@@ -541,9 +527,9 @@ static inline unsigned long copy_shmid_f
 		if (copy_from_user(&tbuf_old, buf, sizeof(tbuf_old)))
 			return -EFAULT;
 
-		out->uid	= tbuf_old.shm_perm.uid;
-		out->gid	= tbuf_old.shm_perm.gid;
-		out->mode	= tbuf_old.shm_perm.mode;
+		out->shm_perm.uid	= tbuf_old.shm_perm.uid;
+		out->shm_perm.gid	= tbuf_old.shm_perm.gid;
+		out->shm_perm.mode	= tbuf_old.shm_perm.mode;
 
 		return 0;
 	    }
@@ -626,12 +612,12 @@ static int shmctl_down(struct ipc_namesp
 		       struct shmid_ds __user *buf, int version)
 {
 	struct kern_ipc_perm *ipcp;
-	struct shm_setbuf setbuf;
+	struct shmid64_ds shmid64;
 	struct shmid_kernel *shp;
 	int err;
 
 	if (cmd == IPC_SET) {
-		if (copy_shmid_from_user(&setbuf, buf, version))
+		if (copy_shmid_from_user(&shmid64, buf, version))
 			return -EFAULT;
 	}
 
@@ -649,8 +635,9 @@ static int shmctl_down(struct ipc_namesp
 		goto out_unlock;
 
 	if (cmd == IPC_SET) {
-		err = audit_ipc_set_perm(0, setbuf.uid,
-					 setbuf.gid, setbuf.mode);
+		err = audit_ipc_set_perm(0, shmid64.shm_perm.uid,
+					 shmid64.shm_perm.gid,
+					 shmid64.shm_perm.mode);
 		if (err)
 			goto out_unlock;
 	}
@@ -670,10 +657,10 @@ static int shmctl_down(struct ipc_namesp
 		do_shm_rmid(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		ipcp->uid = setbuf.uid;
-		ipcp->gid = setbuf.gid;
+		ipcp->uid = shmid64.shm_perm.uid;
+		ipcp->gid = shmid64.shm_perm.gid;
 		ipcp->mode = (ipcp->mode & ~S_IRWXUGO)
-			| (setbuf.mode & S_IRWXUGO);
+			| (shmid64.shm_perm.mode & S_IRWXUGO);
 		shp->shm_ctim = get_seconds();
 		break;
 	default:

-- 
Pierre Peiffer
