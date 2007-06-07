Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXFGQwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXFGQwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761821AbXFGQvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:51:19 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46453 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbXFGQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:51:16 -0400
Message-Id: <20070607165556.202788000@bull.net>
References: <20070607165302.917616000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 07 Jun 2007 18:53:05 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 3/6] Changing the loops on a single ipcid into radix_tree_gang_lookup() calls
Content-Disposition: inline; filename=ipc_gang_lookups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/06]


This patch introduces the changes to the routines like *_exit_ns():
   . instead of looping on each id, trying to lock it and do the job if the
     id exists, they now call radix_tree_gang_lookup(): we are sure all the
     returned ipc structures exist, so we directly can do the job.


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 ipc/msg.c  |   24 ++++++++++++++---
 ipc/sem.c  |   25 ++++++++++++++----
 ipc/shm.c  |   82 +++++++++++++++++++++++++++++++++++++++++--------------------
 ipc/util.c |   21 ---------------
 ipc/util.h |    1 
 5 files changed, 95 insertions(+), 58 deletions(-)

Index: linux-2.6.21/ipc/msg.c
===================================================================
--- linux-2.6.21.orig/ipc/msg.c	2007-06-07 12:39:05.000000000 +0200
+++ linux-2.6.21/ipc/msg.c	2007-06-07 14:03:15.000000000 +0200
@@ -112,14 +112,28 @@ void msg_exit_ns(struct ipc_namespace *n
 {
 	int i;
 	struct msg_queue *msq;
+	struct msg_queue *msqs[IPCS_MAX_SCAN_ENTRIES];
+	int nb_msqs, next_id;
+	int total, in_use;
 
 	mutex_lock(&msg_ids(ns).mutex);
-	for (i = 0; i <= msg_ids(ns).max_id; i++) {
-		msq = msg_lock(ns, i);
-		if (msq == NULL)
-			continue;
 
-		freeque(ns, msq);
+	in_use = msg_ids(ns).in_use;
+
+	next_id = 0;
+	for (total = 0; total < in_use; total += nb_msqs) {
+		nb_msqs = radix_tree_gang_lookup(&(msg_ids(ns).id_tree),
+			(void **) msqs, next_id, IPCS_MAX_SCAN_ENTRIES);
+		if (nb_msqs <= 0)
+			break;
+		for (i = 0; i < nb_msqs; i++) {
+			msq = msqs[i];
+			ipc_lock_by_ptr(&msq->q_perm);
+			freeque(ns, msq);
+		}
+
+		/* prepare for next id gang lookup */
+		next_id = (msqs[nb_msqs - 1]->q_perm.id % SEQ_MULTIPLIER) + 1;
 	}
 	mutex_unlock(&msg_ids(ns).mutex);
 
Index: linux-2.6.21/ipc/sem.c
===================================================================
--- linux-2.6.21.orig/ipc/sem.c	2007-06-07 12:41:28.000000000 +0200
+++ linux-2.6.21/ipc/sem.c	2007-06-07 14:05:27.000000000 +0200
@@ -149,14 +149,29 @@ void sem_exit_ns(struct ipc_namespace *n
 {
 	int i;
 	struct sem_array *sma;
+	struct sem_array *smas[IPCS_MAX_SCAN_ENTRIES];
+	int nb_smas, next_id;
+	int total, in_use;
 
 	mutex_lock(&sem_ids(ns).mutex);
-	for (i = 0; i <= sem_ids(ns).max_id; i++) {
-		sma = sem_lock(ns, i);
-		if (sma == NULL)
-			continue;
 
-		freeary(ns, sma);
+	in_use = sem_ids(ns).in_use;
+
+	next_id = 0;
+	for (total = 0; total < in_use; total += nb_smas) {
+		nb_smas = radix_tree_gang_lookup(&(sem_ids(ns).id_tree),
+			(void **) smas, next_id, IPCS_MAX_SCAN_ENTRIES);
+		if (nb_smas <= 0)
+			break;
+		for (i = 0; i < nb_smas; i++) {
+			sma = smas[i];
+			ipc_lock_by_ptr(&sma->sem_perm);
+			freeary(ns, sma);
+		}
+
+		/* prepare for next id gang lookup */
+		next_id = (smas[nb_smas - 1]->sem_perm.id % SEQ_MULTIPLIER)
+				+ 1;
 	}
 	mutex_unlock(&sem_ids(ns).mutex);
 
Index: linux-2.6.21/ipc/shm.c
===================================================================
--- linux-2.6.21.orig/ipc/shm.c	2007-06-07 12:43:42.000000000 +0200
+++ linux-2.6.21/ipc/shm.c	2007-06-07 14:09:46.000000000 +0200
@@ -63,8 +63,6 @@ static struct ipc_ids init_shm_ids;
 	((struct shmid_kernel*)ipc_lock(&shm_ids(ns),id))
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
-#define shm_get(ns, id)			\
-	((struct shmid_kernel*)ipc_get(&shm_ids(ns),id))
 #define shm_buildid(ns, id, seq)	\
 	ipc_buildid(&shm_ids(ns), id, seq)
 
@@ -115,14 +113,29 @@ void shm_exit_ns(struct ipc_namespace *n
 {
 	int i;
 	struct shmid_kernel *shp;
+	struct shmid_kernel *shps[IPCS_MAX_SCAN_ENTRIES];
+	int nb_shps, next_id;
+	int total, in_use;
 
 	mutex_lock(&shm_ids(ns).mutex);
-	for (i = 0; i <= shm_ids(ns).max_id; i++) {
-		shp = shm_lock(ns, i);
-		if (shp == NULL)
-			continue;
 
-		do_shm_rmid(ns, shp);
+	in_use = shm_ids(ns).in_use;
+
+	next_id = 0;
+	for (total = 0; total < in_use; total += nb_shps) {
+		nb_shps = radix_tree_gang_lookup(&(shm_ids(ns).id_tree),
+			(void **) shps, next_id, IPCS_MAX_SCAN_ENTRIES);
+		if (nb_shps <= 0)
+			break;
+		for (i = 0; i < nb_shps; i++) {
+			shp = shps[i];
+			ipc_lock_by_ptr(&shp->shm_perm);
+			do_shm_rmid(ns, shp);
+		}
+
+		/* prepare for next id gang lookup */
+		next_id = (shps[nb_shps - 1]->shm_perm.id % SEQ_MULTIPLIER)
+				+ 1;
 	}
 	mutex_unlock(&shm_ids(ns).mutex);
 
@@ -548,30 +561,47 @@ static void shm_get_stat(struct ipc_name
 		unsigned long *swp)
 {
 	int i;
+	struct shmid_kernel *shps[IPCS_MAX_SCAN_ENTRIES];
+	int nb_shps, next_id;
+	int total, in_use;
 
 	*rss = 0;
 	*swp = 0;
 
-	for (i = 0; i <= shm_ids(ns).max_id; i++) {
-		struct shmid_kernel *shp;
-		struct inode *inode;
-
-		shp = shm_get(ns, i);
-		if(!shp)
-			continue;
-
-		inode = shp->shm_file->f_path.dentry->d_inode;
-
-		if (is_file_hugepages(shp->shm_file)) {
-			struct address_space *mapping = inode->i_mapping;
-			*rss += (HPAGE_SIZE/PAGE_SIZE)*mapping->nrpages;
-		} else {
-			struct shmem_inode_info *info = SHMEM_I(inode);
-			spin_lock(&info->lock);
-			*rss += inode->i_mapping->nrpages;
-			*swp += info->swapped;
-			spin_unlock(&info->lock);
+	in_use = shm_ids(ns).in_use;
+	next_id = 0;
+	for (total = 0; total < in_use; total += nb_shps) {
+		nb_shps = radix_tree_gang_lookup(&(shm_ids(ns).id_tree),
+			(void **) shps, next_id, IPCS_MAX_SCAN_ENTRIES);
+		if (nb_shps <= 0)
+			break;
+		for (i = 0; i < nb_shps; i++) {
+			struct shmid_kernel *shp;
+			struct inode *inode;
+
+			shp = shps[i];
+			inode = shp->shm_file->f_path.dentry->d_inode;
+
+			if (is_file_hugepages(shp->shm_file)) {
+				struct address_space *mapping;
+
+				mapping = inode->i_mapping;
+				*rss += (HPAGE_SIZE / PAGE_SIZE)
+					* mapping->nrpages;
+			} else {
+				struct shmem_inode_info *info;
+
+				info = SHMEM_I(inode);
+				spin_lock(&info->lock);
+				*rss += inode->i_mapping->nrpages;
+				*swp += info->swapped;
+				spin_unlock(&info->lock);
+			}
 		}
+
+		/* prepare for next id gang lookup */
+		next_id = (shps[nb_shps - 1]->shm_perm.id % SEQ_MULTIPLIER)
+				+ 1;
 	}
 }
 
Index: linux-2.6.21/ipc/util.c
===================================================================
--- linux-2.6.21.orig/ipc/util.c	2007-06-07 12:46:16.000000000 +0200
+++ linux-2.6.21/ipc/util.c	2007-06-07 14:31:00.000000000 +0200
@@ -667,27 +667,6 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 	out->seq	= in->seq;
 }
 
-/*
- * So far only shm_get_stat() calls ipc_get() via shm_get(), so ipc_get()
- * is called with shm_ids.mutex locked.  Since grow_ary() is also called with
- * shm_ids.mutex down(for Shared Memory), there is no need to add read
- * barriers here to gurantee the writes in grow_ary() are seen in order 
- * here (for Alpha).
- *
- * However ipc_get() itself does not necessary require ipc_ids.mutex down. So
- * if in the future ipc_get() is used by other places without ipc_ids.mutex
- * down, then ipc_get() needs read memery barriers as ipc_lock() does.
- */
-struct kern_ipc_perm* ipc_get(struct ipc_ids* ids, int id)
-{
-	struct kern_ipc_perm* out;
-	int lid = id % SEQ_MULTIPLIER;
-	if (lid > ids->max_id)
-		return NULL;
-	out = radix_tree_lookup(&ids->id_tree, lid);
-	return out;
-}
-
 struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id)
 {
 	struct kern_ipc_perm* out;
Index: linux-2.6.21/ipc/util.h
===================================================================
--- linux-2.6.21.orig/ipc/util.h	2007-06-07 12:32:20.000000000 +0200
+++ linux-2.6.21/ipc/util.h	2007-06-07 14:13:42.000000000 +0200
@@ -81,7 +81,6 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-struct kern_ipc_perm* ipc_get(struct ipc_ids* ids, int id);
 struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id);
 void ipc_lock_by_ptr(struct kern_ipc_perm *ipcp);
 void ipc_unlock(struct kern_ipc_perm* perm);

--
