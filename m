Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbXFGQwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbXFGQwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761378AbXFGQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:51:18 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46447 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbXFGQvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:51:15 -0400
Message-Id: <20070607165555.638427000@bull.net>
References: <20070607165302.917616000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 07 Jun 2007 18:53:04 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 2/6] Changing ipc_rmid() interface
Content-Disposition: inline; filename=ipc_rmid.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/06]


This patch introduces the change to ipc_rmid() routine interface:
   . there is no need for this routine to return the pointer passed in as
     argument: it is now declared as a void
   . since the id is now part of the kern_ipc_perm structure, no need to
     have it as an argument to the routine


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 ipc/msg.c  |   16 ++++++++++------
 ipc/sem.c  |   16 ++++++++++------
 ipc/shm.c  |    6 +++---
 ipc/util.c |   15 +++++++--------
 ipc/util.h |    2 +-
 5 files changed, 31 insertions(+), 24 deletions(-)

Index: linux-2.6.21/ipc/util.h
===================================================================
--- linux-2.6.21.orig/ipc/util.h	2007-06-07 11:07:22.000000000 +0200
+++ linux-2.6.21/ipc/util.h	2007-06-07 12:32:20.000000000 +0200
@@ -61,7 +61,7 @@ struct kern_ipc_perm *ipc_findkey(struct
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
 
 /* must be called with both locks acquired. */
-struct kern_ipc_perm* ipc_rmid(struct ipc_ids* ids, int id);
+void ipc_rmid(struct ipc_ids *, struct kern_ipc_perm *);
 
 int ipcperms (struct kern_ipc_perm *ipcp, short flg);
 
Index: linux-2.6.21/ipc/util.c
===================================================================
--- linux-2.6.21.orig/ipc/util.c	2007-06-07 11:29:43.000000000 +0200
+++ linux-2.6.21/ipc/util.c	2007-06-07 12:46:16.000000000 +0200
@@ -384,20 +384,19 @@ int ipc_addid(struct ipc_ids* ids, struc
 /**
  *	ipc_rmid	-	remove an IPC identifier
  *	@ids: identifier set
- *	@id: Identifier to remove
+ *	@id: ipc perm structure containing the identifier to remove
  *
  *	The identifier must be valid, and in use. The kernel will panic if
  *	fed an invalid identifier. The entry is removed and internal
- *	variables recomputed. The object associated with the identifier
- *	is returned.
- *	ipc_ids.mutex and the spinlock for this ID is hold before this function
+ *	variables recomputed.
+ *	ipc_ids.mutex and the spinlock for this ID is held before this function
  *	is called, and remain locked on the exit.
  */
  
-struct kern_ipc_perm* ipc_rmid(struct ipc_ids* ids, int id)
+void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	struct kern_ipc_perm* p;
-	int lid = id % SEQ_MULTIPLIER;
+	int lid = ipcp->id % SEQ_MULTIPLIER;
 	BUG_ON(lid > ids->max_id);
 
 	/* 
@@ -405,7 +404,7 @@ struct kern_ipc_perm* ipc_rmid(struct ip
 	 * on Alpha, since the ipc_ids.mutex is held.
 	 */	
 	p = radix_tree_delete(&ids->id_tree, lid);
-	BUG_ON(p == NULL);
+	BUG_ON(p == NULL || p != ipcp);
 
 	BUG_ON(ids->in_use <= 0);
 	ids->in_use--;
@@ -419,7 +418,7 @@ struct kern_ipc_perm* ipc_rmid(struct ip
 
 	p->deleted = 1;
 
-	return p;
+	return;
 }
 
 /**
Index: linux-2.6.21/ipc/msg.c
===================================================================
--- linux-2.6.21.orig/ipc/msg.c	2007-06-07 11:28:16.000000000 +0200
+++ linux-2.6.21/ipc/msg.c	2007-06-07 12:39:05.000000000 +0200
@@ -75,13 +75,12 @@ static struct ipc_ids init_msg_ids;
 
 #define msg_lock(ns, id)	((struct msg_queue*)ipc_lock(&msg_ids(ns), id))
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_rmid(ns, id)	((struct msg_queue*)ipc_rmid(&msg_ids(ns), id))
 #define msg_checkid(ns, msq, msgid)	\
 	ipc_checkid(&msg_ids(ns), &msq->q_perm, msgid)
 #define msg_buildid(ns, id, seq) \
 	ipc_buildid(&msg_ids(ns), id, seq)
 
-static void freeque (struct ipc_namespace *ns, struct msg_queue *msq, int id);
+static void freeque(struct ipc_namespace *, struct msg_queue *);
 static int newque (struct ipc_namespace *ns, key_t key, int msgflg);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
@@ -120,7 +119,7 @@ void msg_exit_ns(struct ipc_namespace *n
 		if (msq == NULL)
 			continue;
 
-		freeque(ns, msq, i);
+		freeque(ns, msq);
 	}
 	mutex_unlock(&msg_ids(ns).mutex);
 
@@ -137,6 +136,11 @@ void __init msg_init(void)
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
 }
 
+static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
+{
+	ipc_rmid(&msg_ids(ns), &s->q_perm);
+}
+
 static int newque (struct ipc_namespace *ns, key_t key, int msgflg)
 {
 	struct msg_queue *msq;
@@ -231,13 +235,13 @@ static void expunge_all(struct msg_queue
  * msg_ids.mutex and the spinlock for this message queue are held
  * before freeque() is called. msg_ids.mutex remains locked on exit.
  */
-static void freeque(struct ipc_namespace *ns, struct msg_queue *msq, int id)
+static void freeque(struct ipc_namespace *ns, struct msg_queue *msq)
 {
 	struct list_head *tmp;
 
 	expunge_all(msq, -EIDRM);
 	ss_wakeup(&msq->q_senders, 1);
-	msq = msg_rmid(ns, id);
+	msg_rmid(ns, msq);
 	msg_unlock(msq);
 
 	tmp = msq->q_messages.next;
@@ -558,7 +562,7 @@ asmlinkage long sys_msgctl(int msqid, in
 		break;
 	}
 	case IPC_RMID:
-		freeque(ns, msq, msqid);
+		freeque(ns, msq);
 		break;
 	}
 	err = 0;
Index: linux-2.6.21/ipc/sem.c
===================================================================
--- linux-2.6.21.orig/ipc/sem.c	2007-06-07 11:25:20.000000000 +0200
+++ linux-2.6.21/ipc/sem.c	2007-06-07 12:41:28.000000000 +0200
@@ -91,7 +91,6 @@
 
 #define sem_lock(ns, id)	((struct sem_array*)ipc_lock(&sem_ids(ns), id))
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
-#define sem_rmid(ns, id)	((struct sem_array*)ipc_rmid(&sem_ids(ns), id))
 #define sem_checkid(ns, sma, semid)	\
 	ipc_checkid(&sem_ids(ns),&sma->sem_perm,semid)
 #define sem_buildid(ns, id, seq) \
@@ -100,7 +99,7 @@
 static struct ipc_ids init_sem_ids;
 
 static int newary(struct ipc_namespace *, key_t, int, int);
-static void freeary(struct ipc_namespace *ns, struct sem_array *sma, int id);
+static void freeary(struct ipc_namespace *, struct sem_array *);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #endif
@@ -157,7 +156,7 @@ void sem_exit_ns(struct ipc_namespace *n
 		if (sma == NULL)
 			continue;
 
-		freeary(ns, sma, i);
+		freeary(ns, sma);
 	}
 	mutex_unlock(&sem_ids(ns).mutex);
 
@@ -174,6 +173,11 @@ void __init sem_init (void)
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
 }
 
+static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
+{
+	ipc_rmid(&sem_ids(ns), &s->sem_perm);
+}
+
 /*
  * Lockless wakeup algorithm:
  * Without the check/retry algorithm a lockless wakeup is possible:
@@ -499,7 +503,7 @@ static int count_semzcnt (struct sem_arr
  * the spinlock for this semaphore set hold. sem_ids.mutex remains locked
  * on exit.
  */
-static void freeary (struct ipc_namespace *ns, struct sem_array *sma, int id)
+static void freeary(struct ipc_namespace *ns, struct sem_array *sma)
 {
 	struct sem_undo *un;
 	struct sem_queue *q;
@@ -526,7 +530,7 @@ static void freeary (struct ipc_namespac
 	}
 
 	/* Remove the semaphore set from the ID radix tree */
-	sma = sem_rmid(ns, id);
+	sem_rmid(ns, sma);
 	sem_unlock(sma);
 
 	ns->used_sems -= sma->sem_nsems;
@@ -900,7 +904,7 @@ static int semctl_down(struct ipc_namesp
 
 	switch(cmd){
 	case IPC_RMID:
-		freeary(ns, sma, semid);
+		freeary(ns, sma);
 		err = 0;
 		break;
 	case IPC_SET:
Index: linux-2.6.21/ipc/shm.c
===================================================================
--- linux-2.6.21.orig/ipc/shm.c	2007-06-07 11:20:50.000000000 +0200
+++ linux-2.6.21/ipc/shm.c	2007-06-07 12:43:42.000000000 +0200
@@ -147,9 +147,9 @@ static inline int shm_checkid(struct ipc
 	return 0;
 }
 
-static inline struct shmid_kernel *shm_rmid(struct ipc_namespace *ns, int id)
+static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
-	return (struct shmid_kernel *)ipc_rmid(&shm_ids(ns), id);
+	ipc_rmid(&shm_ids(ns), &s->shm_perm);
 }
 
 static inline int shm_addid(struct ipc_namespace *ns, struct shmid_kernel *shp)
@@ -185,7 +185,7 @@ static void shm_open(struct vm_area_stru
 static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	shm_rmid(ns, shp->shm_perm.id);
+	shm_rmid(ns, shp);
 	shm_unlock(shp);
 	if (!is_file_hugepages(shp->shm_file))
 		shmem_lock(shp->shm_file, 0, shp->mlock_user);

--
