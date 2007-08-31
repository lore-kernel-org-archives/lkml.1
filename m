Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXHaLWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXHaLWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964837AbXHaLVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:21:03 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43329 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbXHaLU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:20:58 -0400
Message-Id: <20070831112614.742115000@bull.net>
References: <20070831112445.976429000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 31 Aug 2007 13:24:49 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 4/6] Integrating ipc_checkid() into ipc_lock()
Content-Disposition: inline; filename=ipc_lock_and_check.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 04/06]


This patch introduces a new ipc_lock_check() routine interface:
   . each time ipc_checkid() is called, this is done after calling ipc_lock().
     ipc_checkid() is now called from inside ipc_lock_check().
     

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/msg.c  |   62 ++++++++++++++++++++----------------------
 ipc/sem.c  |   70 ++++++++++++++++++++++-------------------------
 ipc/shm.c  |   90 ++++++++++++++++++++++++++++++++-----------------------------
 ipc/util.c |   23 +--------------
 ipc/util.h |   40 ++++++++++++++++++++++++---
 5 files changed, 149 insertions(+), 136 deletions(-)

Index: linux-2.6.23-rc2/ipc/util.h
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.h	2007-08-31 11:59:11.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.h	2007-08-31 12:26:31.000000000 +0200
@@ -103,11 +103,8 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id);
-void ipc_lock_by_ptr(struct kern_ipc_perm *ipcp);
-void ipc_unlock(struct kern_ipc_perm* perm);
+struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
 int ipc_buildid(struct ipc_ids* ids, int id, int seq);
-int ipc_checkid(struct ipc_ids* ids, struct kern_ipc_perm* ipcp, int uid);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
@@ -127,6 +124,41 @@ extern int ipcget_new(struct ipc_namespa
 extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
 			struct ipc_ops *, struct ipc_params *);
 
+static inline int ipc_checkid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp,
+				int uid)
+{
+	if (uid / SEQ_MULTIPLIER != ipcp->seq)
+		return 1;
+	return 0;
+}
+
+static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
+{
+	spin_lock(&perm->lock);
+}
+
+static inline void ipc_unlock(struct kern_ipc_perm *perm)
+{
+	spin_unlock(&perm->lock);
+}
+
+static inline struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids,
+						int id)
+{
+	struct kern_ipc_perm *out;
+
+	out = ipc_lock(ids, id);
+	if (IS_ERR(out))
+		return out;
+
+	if (ipc_checkid(ids, out, id)) {
+		spin_unlock(&out->lock);
+		return ERR_PTR(-EIDRM);
+	}
+
+	return out;
+}
+
 static inline int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params)
 {
Index: linux-2.6.23-rc2/ipc/util.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.c	2007-08-31 11:59:46.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.c	2007-08-31 12:29:32.000000000 +0200
@@ -678,7 +678,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	out = idr_find(&ids->ipcs_idr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	spin_lock(&out->lock);
@@ -689,36 +689,17 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	if (out->deleted) {
 		spin_unlock(&out->lock);
 		rcu_read_unlock();
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	return out;
 }
 
-void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
-{
-	rcu_read_lock();
-	spin_lock(&perm->lock);
-}
-
-void ipc_unlock(struct kern_ipc_perm* perm)
-{
-	spin_unlock(&perm->lock);
-	rcu_read_unlock();
-}
-
 int ipc_buildid(struct ipc_ids* ids, int id, int seq)
 {
 	return SEQ_MULTIPLIER*seq + id;
 }
 
-int ipc_checkid(struct ipc_ids* ids, struct kern_ipc_perm* ipcp, int uid)
-{
-	if(uid/SEQ_MULTIPLIER != ipcp->seq)
-		return 1;
-	return 0;
-}
-
 #ifdef __ARCH_WANT_IPC_PARSE_VERSION
 
 
Index: linux-2.6.23-rc2/ipc/msg.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/msg.c	2007-08-31 11:42:10.000000000 +0200
+++ linux-2.6.23-rc2/ipc/msg.c	2007-08-31 12:33:38.000000000 +0200
@@ -73,10 +73,7 @@ static struct ipc_ids init_msg_ids;
 
 #define msg_ids(ns)	(*((ns)->ids[IPC_MSG_IDS]))
 
-#define msg_lock(ns, id)	((struct msg_queue*)ipc_lock(&msg_ids(ns), id))
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_checkid(ns, msq, msgid)	\
-	ipc_checkid(&msg_ids(ns), &msq->q_perm, msgid)
 #define msg_buildid(ns, id, seq) \
 	ipc_buildid(&msg_ids(ns), id, seq)
 
@@ -139,6 +136,17 @@ void __init msg_init(void)
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
 }
 
+static inline struct msg_queue *msg_lock(struct ipc_namespace *ns, int id)
+{
+	return (struct msg_queue *) ipc_lock(&msg_ids(ns), id);
+}
+
+static inline struct msg_queue *msg_lock_check(struct ipc_namespace *ns,
+						int id)
+{
+	return (struct msg_queue *) ipc_lock_check(&msg_ids(ns), id);
+}
+
 static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
 {
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
@@ -445,18 +453,15 @@ asmlinkage long sys_msgctl(int msqid, in
 		if (!buf)
 			return -EFAULT;
 
-		memset(&tbuf, 0, sizeof(tbuf));
-
-		msq = msg_lock(ns, msqid);
-		if (msq == NULL)
-			return -EINVAL;
-
 		if (cmd == MSG_STAT) {
+			msq = msg_lock(ns, msqid);
+			if (IS_ERR(msq))
+				return PTR_ERR(msq);
 			success_return = msq->q_perm.id;
 		} else {
-			err = -EIDRM;
-			if (msg_checkid(ns, msq, msqid))
-				goto out_unlock;
+			msq = msg_lock_check(ns, msqid);
+			if (IS_ERR(msq))
+				return PTR_ERR(msq);
 			success_return = 0;
 		}
 		err = -EACCES;
@@ -467,6 +472,8 @@ asmlinkage long sys_msgctl(int msqid, in
 		if (err)
 			goto out_unlock;
 
+		memset(&tbuf, 0, sizeof(tbuf));
+
 		kernel_to_ipc64_perm(&msq->q_perm, &tbuf.msg_perm);
 		tbuf.msg_stime  = msq->q_stime;
 		tbuf.msg_rtime  = msq->q_rtime;
@@ -494,14 +501,12 @@ asmlinkage long sys_msgctl(int msqid, in
 	}
 
 	mutex_lock(&msg_ids(ns).mutex);
-	msq = msg_lock(ns, msqid);
-	err = -EINVAL;
-	if (msq == NULL)
+	msq = msg_lock_check(ns, msqid);
+	if (IS_ERR(msq)) {
+		err = PTR_ERR(msq);
 		goto out_up;
+	}
 
-	err = -EIDRM;
-	if (msg_checkid(ns, msq, msqid))
-		goto out_unlock_up;
 	ipcp = &msq->q_perm;
 
 	err = audit_ipc_obj(ipcp);
@@ -644,14 +649,11 @@ long do_msgsnd(int msqid, long mtype, vo
 	msg->m_type = mtype;
 	msg->m_ts = msgsz;
 
-	msq = msg_lock(ns, msqid);
-	err = -EINVAL;
-	if (msq == NULL)
+	msq = msg_lock_check(ns, msqid);
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
@@ -758,13 +760,9 @@ long do_msgrcv(int msqid, long *pmtype, 
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
 
-	msq = msg_lock(ns, msqid);
-	if (msq == NULL)
-		return -EINVAL;
-
-	msg = ERR_PTR(-EIDRM);
-	if (msg_checkid(ns, msq, msqid))
-		goto out_unlock;
+	msq = msg_lock_check(ns, msqid);
+	if (IS_ERR(msq))
+		return PTR_ERR(msq);
 
 	for (;;) {
 		struct msg_receiver msr_d;
Index: linux-2.6.23-rc2/ipc/sem.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/sem.c	2007-08-31 11:43:58.000000000 +0200
+++ linux-2.6.23-rc2/ipc/sem.c	2007-08-31 12:38:20.000000000 +0200
@@ -88,7 +88,6 @@
 
 #define sem_ids(ns)	(*((ns)->ids[IPC_SEM_IDS]))
 
-#define sem_lock(ns, id)	((struct sem_array*)ipc_lock(&sem_ids(ns), id))
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(ns, sma, semid)	\
 	ipc_checkid(&sem_ids(ns),&sma->sem_perm,semid)
@@ -175,6 +174,17 @@ void __init sem_init (void)
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
 }
 
+static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
+{
+	return (struct sem_array *) ipc_lock(&sem_ids(ns), id);
+}
+
+static inline struct sem_array *sem_lock_check(struct ipc_namespace *ns,
+						int id)
+{
+	return (struct sem_array *) ipc_lock_check(&sem_ids(ns), id);
+}
+
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
@@ -599,11 +609,9 @@ static int semctl_nolock(struct ipc_name
 		struct semid64_ds tbuf;
 		int id;
 
-		memset(&tbuf,0,sizeof(tbuf));
-
 		sma = sem_lock(ns, semid);
-		if(sma == NULL)
-			return -EINVAL;
+		if (IS_ERR(sma))
+			return PTR_ERR(sma);
 
 		err = -EACCES;
 		if (ipcperms (&sma->sem_perm, S_IRUGO))
@@ -615,6 +623,8 @@ static int semctl_nolock(struct ipc_name
 
 		id = sma->sem_perm.id;
 
+		memset(&tbuf, 0, sizeof(tbuf));
+
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
 		tbuf.sem_otime  = sma->sem_otime;
 		tbuf.sem_ctime  = sma->sem_ctime;
@@ -643,16 +653,12 @@ static int semctl_main(struct ipc_namesp
 	ushort* sem_io = fast_sem_io;
 	int nsems;
 
-	sma = sem_lock(ns, semid);
-	if(sma==NULL)
-		return -EINVAL;
+	sma = sem_lock_check(ns, semid);
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
@@ -864,14 +870,10 @@ static int semctl_down(struct ipc_namesp
 		if(copy_semid_from_user (&setbuf, arg.buf, version))
 			return -EFAULT;
 	}
-	sma = sem_lock(ns, semid);
-	if(sma==NULL)
-		return -EINVAL;
+	sma = sem_lock_check(ns, semid);
+	if (IS_ERR(sma))
+		return PTR_ERR(sma);
 
-	if (sem_checkid(ns,sma,semid)) {
-		err=-EIDRM;
-		goto out_unlock;
-	}	
 	ipcp = &sma->sem_perm;
 
 	err = audit_ipc_obj(ipcp);
@@ -1055,15 +1057,10 @@ static struct sem_undo *find_undo(struct
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
+	sma = sem_lock_check(ns, semid);
+	if (IS_ERR(sma))
+		return ERR_PTR(PTR_ERR(sma));
+
 	nsems = sma->sem_nsems;
 	ipc_rcu_getref(sma);
 	sem_unlock(sma);
@@ -1169,15 +1166,14 @@ retry_undos:
 	} else
 		un = NULL;
 
-	sma = sem_lock(ns, semid);
-	error=-EINVAL;
-	if(sma==NULL)
+	sma = sem_lock_check(ns, semid);
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
@@ -1243,7 +1239,7 @@ retry_undos:
 	}
 
 	sma = sem_lock(ns, semid);
-	if(sma==NULL) {
+	if (IS_ERR(sma)) {
 		BUG_ON(queue.prev != NULL);
 		error = -EIDRM;
 		goto out_free;
@@ -1343,7 +1339,7 @@ void exit_sem(struct task_struct *tsk)
 		if(semid == -1)
 			continue;
 		sma = sem_lock(ns, semid);
-		if (sma == NULL)
+		if (IS_ERR(sma))
 			continue;
 
 		if (u->semid == -1)
Index: linux-2.6.23-rc2/ipc/shm.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/shm.c	2007-08-31 12:13:27.000000000 +0200
+++ linux-2.6.23-rc2/ipc/shm.c	2007-08-31 12:43:28.000000000 +0200
@@ -59,8 +59,6 @@ static struct ipc_ids init_shm_ids;
 
 #define shm_ids(ns)	(*((ns)->ids[IPC_SHM_IDS]))
 
-#define shm_lock(ns, id)		\
-	((struct shmid_kernel*)ipc_lock(&shm_ids(ns),id))
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
 #define shm_buildid(ns, id, seq)	\
@@ -139,12 +137,15 @@ void __init shm_init (void)
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
 
-static inline int shm_checkid(struct ipc_namespace *ns,
-		struct shmid_kernel *s, int id)
+static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 {
-	if (ipc_checkid(&shm_ids(ns), &s->shm_perm, id))
-		return -EIDRM;
-	return 0;
+	return (struct shmid_kernel *) ipc_lock(&shm_ids(ns), id);
+}
+
+static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
+						int id)
+{
+	return (struct shmid_kernel *) ipc_lock_check(&shm_ids(ns), id);
 }
 
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
@@ -167,7 +168,7 @@ static void shm_open(struct vm_area_stru
 	struct shmid_kernel *shp;
 
 	shp = shm_lock(sfd->ns, sfd->id);
-	BUG_ON(!shp);
+	BUG_ON(IS_ERR(shp));
 	shp->shm_atim = get_seconds();
 	shp->shm_lprid = current->tgid;
 	shp->shm_nattch++;
@@ -213,7 +214,7 @@ static void shm_close(struct vm_area_str
 	mutex_lock(&shm_ids(ns).mutex);
 	/* remove from the list of attaches of the shm segment */
 	shp = shm_lock(ns, sfd->id);
-	BUG_ON(!shp);
+	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = current->tgid;
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
@@ -661,17 +662,25 @@ asmlinkage long sys_shmctl (int shmid, i
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
-		} else if (cmd == SHM_STAT) {
+		}
+
+		if (cmd == SHM_STAT) {
+			shp = shm_lock(ns, shmid);
+			if (IS_ERR(shp)) {
+				err = PTR_ERR(shp);
+				goto out;
+			}
 			result = shp->shm_perm.id;
 		} else {
-			err = shm_checkid(ns, shp,shmid);
-			if(err)
-				goto out_unlock;
+			shp = shm_lock_check(ns, shmid);
+			if (IS_ERR(shp)) {
+				err = PTR_ERR(shp);
+				goto out;
+			}
 			result = 0;
 		}
 		err=-EACCES;
@@ -680,6 +689,7 @@ asmlinkage long sys_shmctl (int shmid, i
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
 			goto out_unlock;
+		memset(&tbuf, 0, sizeof(tbuf));
 		kernel_to_ipc64_perm(&shp->shm_perm, &tbuf.shm_perm);
 		tbuf.shm_segsz	= shp->shm_segsz;
 		tbuf.shm_atime	= shp->shm_atim;
@@ -698,14 +708,11 @@ asmlinkage long sys_shmctl (int shmid, i
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	{
-		shp = shm_lock(ns, shmid);
-		if(shp==NULL) {
-			err = -EINVAL;
+		shp = shm_lock_check(ns, shmid);
+		if (IS_ERR(shp)) {
+			err = PTR_ERR(shp);
 			goto out;
 		}
-		err = shm_checkid(ns, shp,shmid);
-		if(err)
-			goto out_unlock;
 
 		err = audit_ipc_obj(&(shp->shm_perm));
 		if (err)
@@ -755,13 +762,11 @@ asmlinkage long sys_shmctl (int shmid, i
 		 *	the name away when the usage hits zero.
 		 */
 		mutex_lock(&shm_ids(ns).mutex);
-		shp = shm_lock(ns, shmid);
-		err = -EINVAL;
-		if (shp == NULL) 
+		shp = shm_lock_check(ns, shmid);
+		if (IS_ERR(shp)) {
+			err = PTR_ERR(shp);
 			goto out_up;
-		err = shm_checkid(ns, shp, shmid);
-		if(err)
-			goto out_unlock_up;
+		}
 
 		err = audit_ipc_obj(&(shp->shm_perm));
 		if (err)
@@ -785,18 +790,21 @@ asmlinkage long sys_shmctl (int shmid, i
 
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
+		shp = shm_lock_check(ns, shmid);
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
@@ -902,13 +910,11 @@ long do_shmat(int shmid, char __user *sh
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
-	shp = shm_lock(ns, shmid);
-	if(shp == NULL)
+	shp = shm_lock_check(ns, shmid);
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
@@ -971,7 +977,7 @@ invalid:
 out_nattch:
 	mutex_lock(&shm_ids(ns).mutex);
 	shp = shm_lock(ns, shmid);
-	BUG_ON(!shp);
+	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if(shp->shm_nattch == 0 &&
 	   shp->shm_perm.mode & SHM_DEST)

--
