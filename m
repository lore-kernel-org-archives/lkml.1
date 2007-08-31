Return-Path: <linux-kernel-owner+w=401wt.eu-S965130AbXHaLV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130AbXHaLV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964812AbXHaLVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:21:01 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43305 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbXHaLUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:20:54 -0400
Message-Id: <20070831112613.957469000@bull.net>
References: <20070831112445.976429000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 31 Aug 2007 13:24:47 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 2/6] Unifying the syscalls code
Content-Disposition: inline; filename=ipc_syscalls.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/06]


This patch introduces a change into the sys_msgget(), sys_semget() and
sys_shmget() routines: they now share a common code, which is better for
maintainability.


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/msg.c  |   61 ++++++++++--------------------------
 ipc/sem.c  |   78 ++++++++++++++++++-----------------------------
 ipc/shm.c  |   75 ++++++++++++++++-----------------------------
 ipc/util.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ipc/util.h |   43 +++++++++++++++++++++++++
 5 files changed, 217 insertions(+), 141 deletions(-)

Index: linux-2.6.23-rc2/ipc/util.h
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.h	2007-08-31 11:29:21.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.h	2007-08-31 11:38:50.000000000 +0200
@@ -35,6 +35,35 @@ struct ipc_ids {
 	struct idr ipcs_idr;
 };
 
+/*
+ * Structure that holds the parameters needed by the ipc operations
+ * (see after)
+ */
+struct ipc_params {
+	key_t key;
+	int flg;
+	union {
+		size_t size;	/* for shared memories */
+		int nsems;	/* for semaphores */
+	} u;			/* holds the getnew() specific param */
+};
+
+/*
+ * Structure that holds some ipc operations. This structure is used to unify
+ * the calls to sys_msgget(), sys_semget(), sys_shmget()
+ *      . routine to call to create a new ipc object. Can be one of newque,
+ *        newary, newseg
+ *      . routine to call to call to check permissions for a new ipc object.
+ *        Can be one of security_msg_associate, security_sem_associate,
+ *        security_shm_associate
+ *      . routine to call for an extra check if needed
+ */
+struct ipc_ops {
+	int (*getnew) (struct ipc_namespace *, struct ipc_params *);
+	int (*associate) (void *, int);
+	int (*more_checks) (void *, struct ipc_params *);
+};
+
 struct seq_file;
 
 void ipc_init_ids(struct ipc_ids *);
@@ -50,7 +79,6 @@ void __init ipc_init_proc_interface(cons
 #define IPC_SHM_IDS	2
 
 /* must be called with ids->mutex acquired.*/
-struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key);
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
 int ipc_get_maxid(struct ipc_ids *);
 
@@ -95,5 +123,18 @@ int ipc_parse_version (int *cmd);
 extern void free_msg(struct msg_msg *msg);
 extern struct msg_msg *load_msg(const void __user *src, int len);
 extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
+extern int ipcget_new(struct ipc_namespace *, struct ipc_ids *,
+			struct ipc_ops *, struct ipc_params *);
+extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
+			struct ipc_ops *, struct ipc_params *);
+
+static inline int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
+			struct ipc_ops *ops, struct ipc_params *params)
+{
+	if (params->key == IPC_PRIVATE)
+		return ipcget_new(ns, ids, ops, params);
+	else
+		return ipcget_public(ns, ids, ops, params);
+}
 
 #endif
Index: linux-2.6.23-rc2/ipc/util.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.c	2007-08-31 11:34:17.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.c	2007-08-31 11:40:03.000000000 +0200
@@ -197,7 +197,7 @@ void __init ipc_init_proc_interface(cons
  *	If key is found ipc contains its ipc structure
  */
  
-struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
+static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 {
 	struct kern_ipc_perm *ipc;
 	int next_id;
@@ -301,6 +301,105 @@ int ipc_addid(struct ipc_ids* ids, struc
 }
 
 /**
+ *	ipcget_new	-	create a new ipc object
+ *	@ns: namespace
+ *	@ids: identifer set
+ *	@ops: the actual creation routine to call
+ *	@params: its parameters
+ *
+ *	This routine is called sys_msgget, sys_semget() and sys_shmget() when
+ *	the key is IPC_PRIVATE
+ */
+int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
+		struct ipc_ops *ops, struct ipc_params *params)
+{
+	int err;
+
+	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
+
+	if (!err)
+		return -ENOMEM;
+
+	mutex_lock(&ids->mutex);
+	err = ops->getnew(ns, params);
+	mutex_unlock(&ids->mutex);
+
+	return err;
+}
+
+/**
+ *	ipc_check_perms	-	check security and permissions for an IPC
+ *	@ipcp: ipc permission set
+ *	@ids: identifer set
+ *	@ops: the actual security routine to call
+ *	@params: its parameters
+ */
+static int ipc_check_perms(struct kern_ipc_perm *ipcp, struct ipc_ops *ops,
+			struct ipc_params *params)
+{
+	int err;
+
+	if (ipcperms(ipcp, params->flg))
+		err = -EACCES;
+	else {
+		err = ops->associate(ipcp, params->flg);
+		if (!err)
+			err = ipcp->id;
+	}
+
+	return err;
+}
+
+/**
+ *	ipcget_public	-	get an ipc object or create a new one
+ *	@ns: namespace
+ *	@ids: identifer set
+ *	@ops: the actual creation routine to call
+ *	@params: its parameters
+ *
+ *	This routine is called sys_msgget, sys_semget() and sys_shmget() when
+ *	the key is not IPC_PRIVATE
+ */
+int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
+		struct ipc_ops *ops, struct ipc_params *params)
+{
+	struct kern_ipc_perm *ipcp;
+	int flg = params->flg;
+	int err;
+
+	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
+
+	mutex_lock(&ids->mutex);
+	ipcp = ipc_findkey(ids, params->key);
+	if (ipcp == NULL) {
+		/* key not used */
+		if (!(flg & IPC_CREAT))
+			err = -ENOENT;
+		else if (!err)
+			err = -ENOMEM;
+		else
+			err = ops->getnew(ns, params);
+	} else {
+		/* ipc object has been locked by ipc_findkey() */
+
+		if (flg & IPC_CREAT && flg & IPC_EXCL)
+			err = -EEXIST;
+		else {
+			err = 0;
+			if (ops->more_checks)
+				err = ops->more_checks(ipcp, params);
+			if (!err)
+				err = ipc_check_perms(ipcp, ops, params);
+		}
+		ipc_unlock(ipcp);
+	}
+	mutex_unlock(&ids->mutex);
+
+	return err;
+}
+
+
+/**
  *	ipc_rmid	-	remove an IPC identifier
  *	@ids: identifier set
  *	@id: ipc perm structure containing the identifier to remove
Index: linux-2.6.23-rc2/ipc/msg.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/msg.c	2007-08-31 11:29:21.000000000 +0200
+++ linux-2.6.23-rc2/ipc/msg.c	2007-08-31 11:42:10.000000000 +0200
@@ -81,7 +81,7 @@ static struct ipc_ids init_msg_ids;
 	ipc_buildid(&msg_ids(ns), id, seq)
 
 static void freeque(struct ipc_namespace *, struct msg_queue *);
-static int newque (struct ipc_namespace *ns, key_t key, int msgflg);
+static int newque(struct ipc_namespace *, struct ipc_params *);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
 #endif
@@ -144,10 +144,12 @@ static inline void msg_rmid(struct ipc_n
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
 }
 
-static int newque (struct ipc_namespace *ns, key_t key, int msgflg)
+static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	struct msg_queue *msq;
 	int id, retval;
+	key_t key = params->key;
+	int msgflg = params->flg;
 
 	msq = ipc_rcu_alloc(sizeof(*msq));
 	if (!msq)
@@ -264,56 +266,27 @@ static void freeque(struct ipc_namespace
 	ipc_rcu_putref(msq);
 }
 
+static inline int msg_security(void *msq, int msgflg)
+{
+	return security_msg_queue_associate((struct msg_queue *) msq, msgflg);
+}
+
 asmlinkage long sys_msgget(key_t key, int msgflg)
 {
-	struct msg_queue *msq;
-	int ret;
 	struct ipc_namespace *ns;
+	struct ipc_ops msg_ops;
+	struct ipc_params msg_params;
 
 	ns = current->nsproxy->ipc_ns;
 
-	ret = idr_pre_get(&msg_ids(ns).ipcs_idr, GFP_KERNEL);
-
-	if (key == IPC_PRIVATE)  {
-		if (!ret)
-			ret = -ENOMEM;
-		else {
-			mutex_lock(&msg_ids(ns).mutex);
-			ret = newque(ns, key, msgflg);
-			mutex_unlock(&msg_ids(ns).mutex);
-		}
-	} else {
-		mutex_lock(&msg_ids(ns).mutex);
-		msq = (struct msg_queue *) ipc_findkey(&msg_ids(ns), key);
-		if (msq == NULL) {
-			/* key not used */
-			if (!(msgflg & IPC_CREAT))
-				ret = -ENOENT;
-			else if (!ret)
-				ret = -ENOMEM;
-			else
-				ret = newque(ns, key, msgflg);
-		} else {
-			/* msq has been locked by ipc_findkey() */
+	msg_ops.getnew = newque;
+	msg_ops.associate = msg_security;
+	msg_ops.more_checks = NULL;
 
-			if (msgflg & IPC_CREAT && msgflg & IPC_EXCL)
-				ret = -EEXIST;
-			else {
-				if (ipcperms(&msq->q_perm, msgflg))
-					ret = -EACCES;
-				else {
-					ret = security_msg_queue_associate(
-								msq, msgflg);
-					if (!ret)
-						ret = msq->q_perm.id;
-				}
-			}
-			msg_unlock(msq);
-		}
-		mutex_unlock(&msg_ids(ns).mutex);
-	}
+	msg_params.key = key;
+	msg_params.flg = msgflg;
 
-	return ret;
+	return ipcget(ns, &msg_ids(ns), &msg_ops, &msg_params);
 }
 
 static inline unsigned long
Index: linux-2.6.23-rc2/ipc/sem.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/sem.c	2007-08-31 11:29:21.000000000 +0200
+++ linux-2.6.23-rc2/ipc/sem.c	2007-08-31 11:43:58.000000000 +0200
@@ -97,7 +97,7 @@
 
 static struct ipc_ids init_sem_ids;
 
-static int newary(struct ipc_namespace *, key_t, int, int);
+static int newary(struct ipc_namespace *, struct ipc_params *);
 static void freeary(struct ipc_namespace *, struct sem_array *);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
@@ -214,12 +214,15 @@ static inline void sem_rmid(struct ipc_n
  */
 #define IN_WAKEUP	1
 
-static int newary (struct ipc_namespace *ns, key_t key, int nsems, int semflg)
+static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	int id;
 	int retval;
 	struct sem_array *sma;
 	int size;
+	key_t key = params->key;
+	int nsems = params->u.nsems;
+	int semflg = params->flg;
 
 	if (!nsems)
 		return -EINVAL;
@@ -263,61 +266,40 @@ static int newary (struct ipc_namespace 
 	return sma->sem_perm.id;
 }
 
-asmlinkage long sys_semget (key_t key, int nsems, int semflg)
+
+static inline int sem_security(void *sma, int semflg)
+{
+	return security_sem_associate((struct sem_array *) sma, semflg);
+}
+
+static inline int sem_more_checks(void *sma, struct ipc_params *params)
+{
+	if (params->u.nsems > ((struct sem_array *)sma)->sem_nsems)
+		return -EINVAL;
+
+	return 0;
+}
+
+asmlinkage long sys_semget(key_t key, int nsems, int semflg)
 {
-	int err;
-	struct sem_array *sma;
 	struct ipc_namespace *ns;
+	struct ipc_ops sem_ops;
+	struct ipc_params sem_params;
 
 	ns = current->nsproxy->ipc_ns;
 
 	if (nsems < 0 || nsems > ns->sc_semmsl)
 		return -EINVAL;
 
-	err = idr_pre_get(&sem_ids(ns).ipcs_idr, GFP_KERNEL);
+	sem_ops.getnew = newary;
+	sem_ops.associate = sem_security;
+	sem_ops.more_checks = sem_more_checks;
+
+	sem_params.key = key;
+	sem_params.flg = semflg;
+	sem_params.u.nsems = nsems;
 
-	if (key == IPC_PRIVATE) {
-		if (!err)
-			err = -ENOMEM;
-		else {
-			mutex_lock(&sem_ids(ns).mutex);
-			err = newary(ns, key, nsems, semflg);
-			mutex_unlock(&sem_ids(ns).mutex);
-		}
-	} else {
-		mutex_lock(&sem_ids(ns).mutex);
-		sma = (struct sem_array *) ipc_findkey(&sem_ids(ns), key);
-		if (sma == NULL) {
-			/* key not used */
-			if (!(semflg & IPC_CREAT))
-				err = -ENOENT;
-			else if (!err)
-				err = -ENOMEM;
-			else
-				err = newary(ns, key, nsems, semflg);
-		} else {
-			/* sma has been locked by ipc_findkey() */
-
-			if (semflg & IPC_CREAT && semflg & IPC_EXCL)
-				err = -EEXIST;
-			else {
-				if (nsems > sma->sem_nsems)
-					err = -EINVAL;
-				else if (ipcperms(&sma->sem_perm, semflg))
-					err = -EACCES;
-				else {
-					err = security_sem_associate(sma,
-								semflg);
-					if (!err)
-						err = sma->sem_perm.id;
-				}
-			}
-			sem_unlock(sma);
-		}
-		mutex_unlock(&sem_ids(ns).mutex);
-	}
-
-	return err;
+	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
 }
 
 /* Manage the doubly linked list sma->sem_pending as a FIFO:
Index: linux-2.6.23-rc2/ipc/shm.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/shm.c	2007-08-31 11:29:21.000000000 +0200
+++ linux-2.6.23-rc2/ipc/shm.c	2007-08-31 11:45:57.000000000 +0200
@@ -68,8 +68,7 @@ static struct ipc_ids init_shm_ids;
 #define shm_buildid(ns, id, seq)	\
 	ipc_buildid(&shm_ids(ns), id, seq)
 
-static int newseg (struct ipc_namespace *ns, key_t key,
-		int shmflg, size_t size);
+static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
 static void shm_close(struct vm_area_struct *vma);
 static void shm_destroy (struct ipc_namespace *ns, struct shmid_kernel *shp);
@@ -340,8 +339,11 @@ static struct vm_operations_struct shm_v
 #endif
 };
 
-static int newseg (struct ipc_namespace *ns, key_t key, int shmflg, size_t size)
+static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 {
+	key_t key = params->key;
+	int shmflg = params->flg;
+	size_t size = params->u.size;
 	int error;
 	struct shmid_kernel *shp;
 	int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
@@ -422,57 +424,36 @@ no_file:
 	return error;
 }
 
+static inline int shm_security(void *shp, int shmflg)
+{
+	return security_shm_associate((struct shmid_kernel *) shp, shmflg);
+}
+
+static inline int shm_more_checks(void *shp, struct ipc_params *params)
+{
+	if (((struct shmid_kernel *)shp)->shm_segsz < params->u.size)
+		return -EINVAL;
+
+	return 0;
+}
+
 asmlinkage long sys_shmget (key_t key, size_t size, int shmflg)
 {
-	struct shmid_kernel *shp;
-	int err;
 	struct ipc_namespace *ns;
+	struct ipc_ops shm_ops;
+	struct ipc_params shm_params;
 
 	ns = current->nsproxy->ipc_ns;
 
-	err = idr_pre_get(&shm_ids(ns).ipcs_idr, GFP_KERNEL);
+	shm_ops.getnew = newseg;
+	shm_ops.associate = shm_security;
+	shm_ops.more_checks = shm_more_checks;
+
+	shm_params.key = key;
+	shm_params.flg = shmflg;
+	shm_params.u.size = size;
 
-	if (key == IPC_PRIVATE) {
-		if (!err)
-			err = -ENOMEM;
-		else {
-			mutex_lock(&shm_ids(ns).mutex);
-			err = newseg(ns, key, shmflg, size);
-			mutex_unlock(&shm_ids(ns).mutex);
-		}
-	} else {
-		mutex_lock(&shm_ids(ns).mutex);
-		shp = (struct shmid_kernel *) ipc_findkey(&shm_ids(ns), key);
-		if (shp == NULL) {
-			if (!(shmflg & IPC_CREAT))
-				err = -ENOENT;
-			else if (!err)
-				err = -ENOMEM;
-			else
-				err = newseg(ns, key, shmflg, size);
-		} else {
-			/* shp has been locked by ipc_findkey() */
-
-			if ((shmflg & IPC_CREAT) && (shmflg & IPC_EXCL))
-				err = -EEXIST;
-			else {
-				if (shp->shm_segsz < size)
-					err = -EINVAL;
-				else if (ipcperms(&shp->shm_perm, shmflg))
-					err = -EACCES;
-				else {
-					err = security_shm_associate(shp,
-								shmflg);
-					if (!err)
-						err = shp->shm_perm.id;
-				}
-			}
-			shm_unlock(shp);
-		}
-		mutex_unlock(&shm_ids(ns).mutex);
-	}
-
-	return err;
+	return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
 }
 
 static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_ds *in, int version)

--
