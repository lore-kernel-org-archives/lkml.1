Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbXI0O3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbXI0O3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbXI0O3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:29:18 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34299 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbXI0O3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:29:17 -0400
Message-Id: <20070927143459.186581000@bull.net>
References: <20070927143354.663489000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 27 Sep 2007 16:33:56 +0200
From: Nadia.Derbey@bull.net
To: jarkao2@o2.pl
Cc: akpm@linux-foundation.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH -mm1 2/2] Removing unneeded parameters
Content-Disposition: inline; filename=ipc_remove_unneeded_params.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 02/02]


This is a trivial patch that removes the unneeded parameters from
ipc_checkid() and ipc_buildid() interfaces.


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---

This patch applies on top of the 2.6.23-rc6-mm1


 ipc/msg.c  |    5 ++---
 ipc/sem.c  |   10 ++++------
 ipc/shm.c  |    5 ++---
 ipc/util.h |    9 ++++-----
 4 files changed, 12 insertions(+), 17 deletions(-)

Index: linux-2.6.23-rc6-mm1/ipc/util.h
===================================================================
--- linux-2.6.23-rc6-mm1.orig/ipc/util.h	2007-09-27 10:13:18.000000000 +0200
+++ linux-2.6.23-rc6-mm1/ipc/util.h	2007-09-27 15:09:51.000000000 +0200
@@ -134,7 +134,7 @@ extern int ipcget_new(struct ipc_namespa
 extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
 			struct ipc_ops *, struct ipc_params *);
 
-static inline int ipc_buildid(struct ipc_ids *ids, int id, int seq)
+static inline int ipc_buildid(int id, int seq)
 {
 	return SEQ_MULTIPLIER * seq + id;
 }
@@ -142,8 +142,7 @@ static inline int ipc_buildid(struct ipc
 /*
  * Must be called with ipcp locked
  */
-static inline int ipc_checkid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp,
-				int uid)
+static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 {
 	if (uid / SEQ_MULTIPLIER != ipcp->seq)
 		return 1;
@@ -171,7 +170,7 @@ static inline struct kern_ipc_perm *ipc_
 	if (IS_ERR(out))
 		return out;
 
-	if (ipc_checkid(ids, out, id)) {
+	if (ipc_checkid(out, id)) {
 		ipc_unlock(out);
 		return ERR_PTR(-EIDRM);
 	}
@@ -188,7 +187,7 @@ static inline struct kern_ipc_perm *ipc_
 	if (IS_ERR(out))
 		return out;
 
-	if (ipc_checkid(ids, out, id)) {
+	if (ipc_checkid(out, id)) {
 		ipc_unlock(out);
 		return ERR_PTR(-EIDRM);
 	}
Index: linux-2.6.23-rc6-mm1/ipc/msg.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/ipc/msg.c	2007-09-27 10:34:25.000000000 +0200
+++ linux-2.6.23-rc6-mm1/ipc/msg.c	2007-09-27 15:03:26.000000000 +0200
@@ -74,8 +74,7 @@ static struct ipc_ids init_msg_ids;
 #define msg_ids(ns)	(*((ns)->ids[IPC_MSG_IDS]))
 
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_buildid(ns, id, seq) \
-	ipc_buildid(&msg_ids(ns), id, seq)
+#define msg_buildid(id, seq)	ipc_buildid(id, seq)
 
 static void freeque(struct ipc_namespace *, struct msg_queue *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
@@ -211,7 +210,7 @@ static int newque(struct ipc_namespace *
 		return -ENOSPC;
 	}
 
-	msq->q_perm.id = msg_buildid(ns, id, msq->q_perm.seq);
+	msq->q_perm.id = msg_buildid(id, msq->q_perm.seq);
 	msq->q_stime = msq->q_rtime = 0;
 	msq->q_ctime = get_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
Index: linux-2.6.23-rc6-mm1/ipc/sem.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/ipc/sem.c	2007-09-27 10:35:40.000000000 +0200
+++ linux-2.6.23-rc6-mm1/ipc/sem.c	2007-09-27 15:10:48.000000000 +0200
@@ -89,10 +89,8 @@
 #define sem_ids(ns)	(*((ns)->ids[IPC_SEM_IDS]))
 
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
-#define sem_checkid(ns, sma, semid)	\
-	ipc_checkid(&sem_ids(ns),&sma->sem_perm,semid)
-#define sem_buildid(ns, id, seq) \
-	ipc_buildid(&sem_ids(ns), id, seq)
+#define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
+#define sem_buildid(id, seq)	ipc_buildid(id, seq)
 
 static struct ipc_ids init_sem_ids;
 
@@ -292,7 +290,7 @@ static int newary(struct ipc_namespace *
 	}
 	ns->used_sems += nsems;
 
-	sma->sem_perm.id = sem_buildid(ns, id, sma->sem_perm.seq);
+	sma->sem_perm.id = sem_buildid(id, sma->sem_perm.seq);
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
@@ -1386,7 +1384,7 @@ void exit_sem(struct task_struct *tsk)
 		if (u->semid == -1)
 			goto next_entry;
 
-		BUG_ON(sem_checkid(ns,sma,u->semid));
+		BUG_ON(sem_checkid(sma, u->semid));
 
 		/* remove u from the sma->undo list */
 		for (unp = &sma->undo; (un = *unp); unp = &un->id_next) {
Index: linux-2.6.23-rc6-mm1/ipc/shm.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/ipc/shm.c	2007-09-27 10:30:30.000000000 +0200
+++ linux-2.6.23-rc6-mm1/ipc/shm.c	2007-09-27 15:08:41.000000000 +0200
@@ -61,8 +61,7 @@ static struct ipc_ids init_shm_ids;
 
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
-#define shm_buildid(ns, id, seq)	\
-	ipc_buildid(&shm_ids(ns), id, seq)
+#define shm_buildid(id, seq)	ipc_buildid(id, seq)
 
 static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
@@ -445,7 +444,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_ctim = get_seconds();
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
-	shp->shm_perm.id = shm_buildid(ns, id, shp->shm_perm.seq);
+	shp->shm_perm.id = shm_buildid(id, shp->shm_perm.seq);
 	shp->shm_file = file;
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.

--
