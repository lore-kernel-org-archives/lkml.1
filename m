Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXFGQwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXFGQwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762116AbXFGQvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:51:20 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46464 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761174AbXFGQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:51:18 -0400
Message-Id: <20070607165556.585056000@bull.net>
References: <20070607165302.917616000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 07 Jun 2007 18:53:06 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 4/6] Integrating ipc_checkid() into ipc_lock()
Content-Disposition: inline; filename=ipc_lock_and_check.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 04/06]


This patch introduces the a change to the ipc_lock() routine interface:
   . each time ipc_checkid() is called, this done after calling ipc_lock().
     So a new paramameter is added to ipc_lock(). It tells whether or not
     a ipc_checkid() is needed, and ipc_checkid() is now called from inside
     ipc_lock().


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 ipc/msg.c  |   65 ++++++++++++++++++-------------------------
 ipc/sem.c  |   74 ++++++++++++++++++++-----------------------------
 ipc/shm.c  |   92 ++++++++++++++++++++++++++++++-------------------------------
 ipc/util.c |   16 +++++++---
 ipc/util.h |    6 ++-
 5 files changed, 121 insertions(+), 132 deletions(-)

Index: linux-2.6.21/ipc/util.c
===================================================================
--- linux-2.6.21.orig/ipc/util.c	2007-06-07 14:31:00.000000000 +0200
+++ linux-2.6.21/ipc/util.c	2007-06-07 14:57:34.000000000 +0200
@@ -667,7 +667,7 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 	out->seq	= in->seq;
 }
 
-struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id)
+struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id, int checkid)
 {
 	struct kern_ipc_perm* out;
 	int lid = id % SEQ_MULTIPLIER;
@@ -675,12 +675,12 @@ struct kern_ipc_perm* ipc_lock(struct ip
 	rcu_read_lock();
 	if (lid > ids->max_id) {
 		rcu_read_unlock();
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	out = radix_tree_lookup(&ids->id_tree, lid);
 	if(out == NULL) {
 		rcu_read_unlock();
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	spin_lock(&out->lock);
 	
@@ -690,8 +690,16 @@ struct kern_ipc_perm* ipc_lock(struct ip
 	if (out->deleted) {
 		spin_unlock(&out->lock);
 		rcu_read_unlock();
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
+
+	if (checkid)
+		if (ipc_checkid(ids, out, id)) {
+			spin_unlock(&out->lock);
+			rcu_read_unlock();
+			return ERR_PTR(-EIDRM);
+		}
+
 	return out;
 }
 
Index: linux-2.6.21/ipc/util.h
===================================================================
--- linux-2.6.21.orig/ipc/util.h	2007-06-07 14:13:42.000000000 +0200
+++ linux-2.6.21/ipc/util.h	2007-06-07 14:57:07.000000000 +0200
@@ -12,9 +12,11 @@
 
 #define USHRT_MAX 0xffff
 #define SEQ_MULTIPLIER	(IPCMNI)
-
 #define IPCS_MAX_SCAN_ENTRIES 256
 
+#define IPC_CHECKID 1
+#define NO_IPC_CHECKID 0
+
 void sem_init (void);
 void msg_init (void);
 void shm_init (void);
@@ -81,7 +83,7 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id);
+struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int, int);
 void ipc_lock_by_ptr(struct kern_ipc_perm *ipcp);
 void ipc_unlock(struct kern_ipc_perm* perm);
 int ipc_buildid(struct ipc_ids* ids, int id, int seq);
Index: linux-2.6.21/ipc/msg.c
===================================================================
--- linux-2.6.21.orig/ipc/msg.c	2007-06-07 14:03:15.000000000 +0200
+++ linux-2.6.21/ipc/msg.c	2007-06-07 14:40:08.000000000 +0200
@@ -73,10 +73,7 @@ static struct ipc_ids init_msg_ids;
 
 #define msg_ids(ns)	(*((ns)->ids[IPC_MSG_IDS]))
 
-#define msg_lock(ns, id)	((struct msg_queue*)ipc_lock(&msg_ids(ns), id))
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_checkid(ns, msq, msgid)	\
-	ipc_checkid(&msg_ids(ns), &msq->q_perm, msgid)
 #define msg_buildid(ns, id, seq) \
 	ipc_buildid(&msg_ids(ns), id, seq)
 
@@ -150,6 +147,12 @@ void __init msg_init(void)
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
 }
 
+static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id,
+						int chk)
+{
+	return (struct msg_queue *) ipc_lock(&msg_ids(ns), id, chk);
+}
+
 static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
 {
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
@@ -460,7 +463,7 @@ asmlinkage long sys_msgctl(int msqid, in
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
-	case MSG_STAT:
+	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
 	case IPC_STAT:
 	{
 		struct msqid64_ds tbuf;
@@ -468,21 +471,16 @@ asmlinkage long sys_msgctl(int msqid, in
 
 		if (!buf)
 			return -EFAULT;
-		if (cmd == MSG_STAT && msqid > msg_ids(ns).max_id)
-			return -EINVAL;
-
-		memset(&tbuf, 0, sizeof(tbuf));
 
-		msq = msg_lock(ns, msqid);
-		if (msq == NULL)
-			return -EINVAL;
-
-		if (cmd == MSG_STAT)
+		if (cmd == MSG_STAT) {
+			msq = msg_lock(ns, msqid, NO_IPC_CHECKID);
+			if (IS_ERR(msq) && PTR_ERR(msq) == -EINVAL)
+				return -EINVAL;
 			success_return = msq->q_perm.id;
-		else {
-			err = -EIDRM;
-			if (msg_checkid(ns, msq, msqid))
-				goto out_unlock;
+		} else {
+			msq = msg_lock(ns, msqid, IPC_CHECKID);
+			if (IS_ERR(msq))
+				return PTR_ERR(msq);
 			success_return = 0;
 		}
 		err = -EACCES;
@@ -493,6 +491,8 @@ asmlinkage long sys_msgctl(int msqid, in
 		if (err)
 			goto out_unlock;
 
+		memset(&tbuf, 0, sizeof(tbuf));
+
 		kernel_to_ipc64_perm(&msq->q_perm, &tbuf.msg_perm);
 		tbuf.msg_stime  = msq->q_stime;
 		tbuf.msg_rtime  = msq->q_rtime;
@@ -520,14 +520,12 @@ asmlinkage long sys_msgctl(int msqid, in
 	}
 
 	mutex_lock(&msg_ids(ns).mutex);
-	msq = msg_lock(ns, msqid);
-	err = -EINVAL;
-	if (msq == NULL)
+	msq = msg_lock(ns, msqid, IPC_CHECKID);
+	if (IS_ERR(msq)) {
+		err = PTR_ERR(msq);
 		goto out_up;
+	}
 
-	err = -EIDRM;
-	if (msg_checkid(ns, msq, msqid))
-		goto out_unlock_up;
 	ipcp = &msq->q_perm;
 
 	err = audit_ipc_obj(ipcp);
@@ -670,14 +668,11 @@ long do_msgsnd(int msqid, long mtype, vo
 	msg->m_type = mtype;
 	msg->m_ts = msgsz;
 
-	msq = msg_lock(ns, msqid);
-	err = -EINVAL;
-	if (msq == NULL)
+	msq = msg_lock(ns, msqid, IPC_CHECKID);
+	if (IS_ERR(msq)) {
+		err = PTR_ERR(msq);
 		goto out_free;
-
-	err= -EIDRM;
-	if (msg_checkid(ns, msq, msqid))
-		goto out_unlock_free;
+	}
 
 	for (;;) {
 		struct msg_sender s;
@@ -784,13 +779,9 @@ long do_msgrcv(int msqid, long *pmtype, 
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
 
-	msq = msg_lock(ns, msqid);
-	if (msq == NULL)
-		return -EINVAL;
-
-	msg = ERR_PTR(-EIDRM);
-	if (msg_checkid(ns, msq, msqid))
-		goto out_unlock;
+	msq = msg_lock(ns, msqid, IPC_CHECKID);
+	if (IS_ERR(msq))
+		return PTR_ERR(msq);
 
 	for (;;) {
 		struct msg_receiver msr_d;
Index: linux-2.6.21/ipc/sem.c
===================================================================
--- linux-2.6.21.orig/ipc/sem.c	2007-06-07 14:05:27.000000000 +0200
+++ linux-2.6.21/ipc/sem.c	2007-06-07 14:56:36.000000000 +0200
@@ -89,7 +89,6 @@
 
 #define sem_ids(ns)	(*((ns)->ids[IPC_SEM_IDS]))
 
-#define sem_lock(ns, id)	((struct sem_array*)ipc_lock(&sem_ids(ns), id))
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(ns, sma, semid)	\
 	ipc_checkid(&sem_ids(ns),&sma->sem_perm,semid)
@@ -188,6 +187,12 @@ void __init sem_init (void)
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
 }
 
+static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id,
+						int chk)
+{
+	return (struct sem_array *) ipc_lock(&sem_ids(ns), id, chk);
+}
+
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
@@ -620,14 +625,9 @@ static int semctl_nolock(struct ipc_name
 		struct semid64_ds tbuf;
 		int id;
 
-		if (semid > sem_ids(ns).max_id)
-			return -EINVAL;
-
-		memset(&tbuf,0,sizeof(tbuf));
-
-		sma = sem_lock(ns, semid);
-		if(sma == NULL)
-			return -EINVAL;
+		sma = sem_lock(ns, semid, NO_IPC_CHECKID);
+		if (IS_ERR(sma))
+			return PTR_ERR(sma);
 
 		err = -EACCES;
 		if (ipcperms (&sma->sem_perm, S_IRUGO))
@@ -639,6 +639,8 @@ static int semctl_nolock(struct ipc_name
 
 		id = sma->sem_perm.id;
 
+		memset(&tbuf, 0, sizeof(tbuf));
+
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
 		tbuf.sem_otime  = sma->sem_otime;
 		tbuf.sem_ctime  = sma->sem_ctime;
@@ -667,16 +669,12 @@ static int semctl_main(struct ipc_namesp
 	ushort* sem_io = fast_sem_io;
 	int nsems;
 
-	sma = sem_lock(ns, semid);
-	if(sma==NULL)
-		return -EINVAL;
+	sma = sem_lock(ns, semid, IPC_CHECKID);
+	if (IS_ERR(sma))
+		return PTR_ERR(sma);
 
 	nsems = sma->sem_nsems;
 
-	err=-EIDRM;
-	if (sem_checkid(ns,sma,semid))
-		goto out_unlock;
-
 	err = -EACCES;
 	if (ipcperms (&sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
 		goto out_unlock;
@@ -888,14 +886,10 @@ static int semctl_down(struct ipc_namesp
 		if(copy_semid_from_user (&setbuf, arg.buf, version))
 			return -EFAULT;
 	}
-	sma = sem_lock(ns, semid);
-	if(sma==NULL)
-		return -EINVAL;
+	sma = sem_lock(ns, semid, IPC_CHECKID);
+	if (IS_ERR(sma))
+		return PTR_ERR(sma);
 
-	if (sem_checkid(ns,sma,semid)) {
-		err=-EIDRM;
-		goto out_unlock;
-	}	
 	ipcp = &sma->sem_perm;
 
 	err = audit_ipc_obj(ipcp);
@@ -1079,15 +1073,10 @@ static struct sem_undo *find_undo(struct
 		goto out;
 
 	/* no undo structure around - allocate one. */
-	sma = sem_lock(ns, semid);
-	un = ERR_PTR(-EINVAL);
-	if(sma==NULL)
-		goto out;
-	un = ERR_PTR(-EIDRM);
-	if (sem_checkid(ns,sma,semid)) {
-		sem_unlock(sma);
-		goto out;
-	}
+	sma = sem_lock(ns, semid, IPC_CHECKID);
+	if (IS_ERR(sma))
+		return ERR_PTR(PTR_ERR(sma));
+
 	nsems = sma->sem_nsems;
 	ipc_rcu_getref(sma);
 	sem_unlock(sma);
@@ -1193,15 +1182,14 @@ retry_undos:
 	} else
 		un = NULL;
 
-	sma = sem_lock(ns, semid);
-	error=-EINVAL;
-	if(sma==NULL)
+	sma = sem_lock(ns, semid, IPC_CHECKID);
+	if (IS_ERR(sma)) {
+		error = PTR_ERR(sma);
 		goto out_free;
-	error = -EIDRM;
-	if (sem_checkid(ns,sma,semid))
-		goto out_unlock_free;
+	}
+
 	/*
-	 * semid identifies are not unique - find_undo may have
+	 * semid identifiers are not unique - find_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
 	 * and now a new array with received the same id. Check and retry.
 	 */
@@ -1266,8 +1254,8 @@ retry_undos:
 		goto out_free;
 	}
 
-	sma = sem_lock(ns, semid);
-	if(sma==NULL) {
+	sma = sem_lock(ns, semid, NO_IPC_CHECKID);
+	if (IS_ERR(sma)) {
 		BUG_ON(queue.prev != NULL);
 		error = -EIDRM;
 		goto out_free;
@@ -1366,8 +1354,8 @@ void exit_sem(struct task_struct *tsk)
 
 		if(semid == -1)
 			continue;
-		sma = sem_lock(ns, semid);
-		if (sma == NULL)
+		sma = sem_lock(ns, semid, NO_IPC_CHECKID);
+		if (IS_ERR(sma))
 			continue;
 
 		if (u->semid == -1)
Index: linux-2.6.21/ipc/shm.c
===================================================================
--- linux-2.6.21.orig/ipc/shm.c	2007-06-07 14:09:46.000000000 +0200
+++ linux-2.6.21/ipc/shm.c	2007-06-07 14:55:28.000000000 +0200
@@ -59,8 +59,6 @@ static struct ipc_ids init_shm_ids;
 
 #define shm_ids(ns)	(*((ns)->ids[IPC_SHM_IDS]))
 
-#define shm_lock(ns, id)		\
-	((struct shmid_kernel*)ipc_lock(&shm_ids(ns),id))
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
 #define shm_buildid(ns, id, seq)	\
@@ -152,12 +150,10 @@ void __init shm_init (void)
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
 
-static inline int shm_checkid(struct ipc_namespace *ns,
-		struct shmid_kernel *s, int id)
+static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id,
+						int chk)
 {
-	if (ipc_checkid(&shm_ids(ns), &s->shm_perm, id))
-		return -EIDRM;
-	return 0;
+	return (struct shmid_kernel *) ipc_lock(&shm_ids(ns), id, chk);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -179,8 +175,8 @@ static void shm_open(struct vm_area_stru
 	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
 
-	shp = shm_lock(sfd->ns, sfd->id);
-	BUG_ON(!shp);
+	shp = shm_lock(sfd->ns, sfd->id, NO_IPC_CHECKID);
+	BUG_ON(IS_ERR(shp));
 	shp->shm_atim = get_seconds();
 	shp->shm_lprid = current->tgid;
 	shp->shm_nattch++;
@@ -225,8 +221,8 @@ static void shm_close(struct vm_area_str
 
 	mutex_lock(&shm_ids(ns).mutex);
 	/* remove from the list of attaches of the shm segment */
-	shp = shm_lock(ns, sfd->id);
-	BUG_ON(!shp);
+	shp = shm_lock(ns, sfd->id, NO_IPC_CHECKID);
+	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = current->tgid;
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
@@ -673,18 +669,25 @@ asmlinkage long sys_shmctl (int shmid, i
 	{
 		struct shmid64_ds tbuf;
 		int result;
-		memset(&tbuf, 0, sizeof(tbuf));
-		shp = shm_lock(ns, shmid);
-		if(shp==NULL) {
-			err = -EINVAL;
+
+		if (!buf) {
+			err = -EFAULT;
 			goto out;
-		} else if(cmd==SHM_STAT) {
-			err = -EINVAL;
+		}
+
+		if (cmd == SHM_STAT) {
+			shp = shm_lock(ns, shmid, NO_IPC_CHECKID);
+			if (IS_ERR(shp)) {
+				err = PTR_ERR(shp);
+				goto out;
+			}
 			result = shp->shm_perm.id;
 		} else {
-			err = shm_checkid(ns, shp,shmid);
-			if(err)
-				goto out_unlock;
+			shp = shm_lock(ns, shmid, IPC_CHECKID);
+			if (IS_ERR(shp)) {
+				err = PTR_ERR(shp);
+				goto out;
+			}
 			result = 0;
 		}
 		err=-EACCES;
@@ -693,6 +696,7 @@ asmlinkage long sys_shmctl (int shmid, i
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
 			goto out_unlock;
+		memset(&tbuf, 0, sizeof(tbuf));
 		kernel_to_ipc64_perm(&shp->shm_perm, &tbuf.shm_perm);
 		tbuf.shm_segsz	= shp->shm_segsz;
 		tbuf.shm_atime	= shp->shm_atim;
@@ -711,14 +715,11 @@ asmlinkage long sys_shmctl (int shmid, i
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
-		shp = shm_lock(ns, shmid);
-		if(shp==NULL) {
-			err = -EINVAL;
+		shp = shm_lock(ns, shmid, IPC_CHECKID);
+		if (IS_ERR(shp)) {
+			err = PTR_ERR(shp);
 			goto out;
 		}
-		err = shm_checkid(ns, shp,shmid);
-		if(err)
-			goto out_unlock;
 
 		err = audit_ipc_obj(&(shp->shm_perm));
 		if (err)
@@ -768,13 +769,11 @@ asmlinkage long sys_shmctl (int shmid, i
 		 *	the name away when the usage hits zero.
 		 */
 		mutex_lock(&shm_ids(ns).mutex);
-		shp = shm_lock(ns, shmid);
-		err = -EINVAL;
-		if (shp == NULL) 
+		shp = shm_lock(ns, shmid, IPC_CHECKID);
+		if (IS_ERR(shp)) {
+			err = PTR_ERR(shp);
 			goto out_up;
-		err = shm_checkid(ns, shp, shmid);
-		if(err)
-			goto out_unlock_up;
+		}
 
 		err = audit_ipc_obj(&(shp->shm_perm));
 		if (err)
@@ -798,18 +797,21 @@ asmlinkage long sys_shmctl (int shmid, i
 
 	case IPC_SET:
 	{
+		if (!buf) {
+			err = -EFAULT;
+			goto out;
+		}
+
 		if (copy_shmid_from_user (&setbuf, buf, version)) {
 			err = -EFAULT;
 			goto out;
 		}
 		mutex_lock(&shm_ids(ns).mutex);
-		shp = shm_lock(ns, shmid);
-		err=-EINVAL;
-		if(shp==NULL)
+		shp = shm_lock(ns, shmid, IPC_CHECKID);
+		if (IS_ERR(shp)) {
+			err = PTR_ERR(shp);
 			goto out_up;
-		err = shm_checkid(ns, shp,shmid);
-		if(err)
-			goto out_unlock_up;
+		}
 		err = audit_ipc_obj(&(shp->shm_perm));
 		if (err)
 			goto out_unlock_up;
@@ -915,13 +917,11 @@ long do_shmat(int shmid, char __user *sh
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
-	shp = shm_lock(ns, shmid);
-	if(shp == NULL)
+	shp = shm_lock(ns, shmid, IPC_CHECKID);
+	if (IS_ERR(shp)) {
+		err = PTR_ERR(shp);
 		goto out;
-
-	err = shm_checkid(ns, shp,shmid);
-	if (err)
-		goto out_unlock;
+	}
 
 	err = -EACCES;
 	if (ipcperms(&shp->shm_perm, acc_mode))
@@ -983,8 +983,8 @@ invalid:
 
 out_nattch:
 	mutex_lock(&shm_ids(ns).mutex);
-	shp = shm_lock(ns, shmid);
-	BUG_ON(!shp);
+	shp = shm_lock(ns, shmid, NO_IPC_CHECKID);
+	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if(shp->shm_nattch == 0 &&
 	   shp->shm_perm.mode & SHM_DEST)

--
