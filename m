Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbYBHQfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbYBHQfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbYBHQfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:35:13 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57407 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301AbYBHQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:35:11 -0500
Date: Fri, 8 Feb 2008 17:35:15 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-mm1] IPC: use ipc_buildid() directly from ipc_addid()
Message-Id: <20080208173515.e4545838.pierre.peiffer@bull.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 08/02/2008 17:44:02,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 08/02/2008 17:44:03,
	Serialize complete at 08/02/2008 17:44:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

By continuing to consolidate a little the IPC code, each id can be built
directly in ipc_addid() instead of having it built from each callers of
ipc_addid()

And I also remove shm_addid() in order to have, as much as possible, the
same code for shm/sem/msg.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
---
 ipc/msg.c  |    2 --
 ipc/sem.c  |    2 --
 ipc/shm.c  |   10 +---------
 ipc/util.c |    1 +
 4 files changed, 2 insertions(+), 13 deletions(-)

Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -70,7 +70,6 @@ struct msg_sender {
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
 #define msg_unlock(msq)		ipc_unlock(&(msq)->q_perm)
-#define msg_buildid(id, seq)	ipc_buildid(id, seq)
 
 static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
 static int newque(struct ipc_namespace *, struct ipc_params *);
@@ -186,7 +185,6 @@ static int newque(struct ipc_namespace *
 		return id;
 	}
 
-	msq->q_perm.id = msg_buildid(id, msq->q_perm.seq);
 	msq->q_stime = msq->q_rtime = 0;
 	msq->q_ctime = get_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -91,7 +91,6 @@
 
 #define sem_unlock(sma)		ipc_unlock(&(sma)->sem_perm)
 #define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
-#define sem_buildid(id, seq)	ipc_buildid(id, seq)
 
 static int newary(struct ipc_namespace *, struct ipc_params *);
 static void freeary(struct ipc_namespace *, struct kern_ipc_perm *);
@@ -268,7 +267,6 @@ static int newary(struct ipc_namespace *
 	}
 	ns->used_sems += nsems;
 
-	sma->sem_perm.id = sem_buildid(id, sma->sem_perm.seq);
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
Index: b/ipc/shm.c
===================================================================
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -60,7 +60,6 @@ static struct vm_operations_struct shm_v
 
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
-#define shm_buildid(id, seq)	ipc_buildid(id, seq)
 
 static int newseg(struct ipc_namespace *, struct ipc_params *);
 static void shm_open(struct vm_area_struct *vma);
@@ -169,12 +168,6 @@ static inline void shm_rmid(struct ipc_n
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
 }
 
-static inline int shm_addid(struct ipc_namespace *ns, struct shmid_kernel *shp)
-{
-	return ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
-}
-
-
 
 /* This is called by fork, once for every shm attach. */
 static void shm_open(struct vm_area_struct *vma)
@@ -417,7 +410,7 @@ static int newseg(struct ipc_namespace *
 	if (IS_ERR(file))
 		goto no_file;
 
-	id = shm_addid(ns, shp);
+	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
 		error = id;
 		goto no_id;
@@ -429,7 +422,6 @@ static int newseg(struct ipc_namespace *
 	shp->shm_ctim = get_seconds();
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
-	shp->shm_perm.id = shm_buildid(id, shp->shm_perm.seq);
 	shp->shm_file = file;
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
Index: b/ipc/util.c
===================================================================
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -231,6 +231,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if(ids->seq > ids->seq_max)
 		ids->seq = 0;
 
+	new->id =  ipc_buildid(id, new->seq);
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();

-- 
Pierre Peiffer
