Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbYD2Oku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbYD2Oku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbYD2Oh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49869 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYD2Ohz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:55 -0400
Message-Id: <20080429143731.697064000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:13 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 09/10] Integrate the ridr code into IPC code
Content-Disposition: inline; filename=ipc_use_ridr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 09/10]

This patche makes the ipc ode use the ridr API.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ipc_namespace.h |    4 ++--
 ipc/namespace.c               |    2 +-
 ipc/shm.c                     |    2 +-
 ipc/util.c                    |   41 ++++++++++++++++-------------------------
 4 files changed, 20 insertions(+), 29 deletions(-)

Index: linux-2.6.25-mm1/include/linux/ipc_namespace.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/ipc_namespace.h	2008-04-25 15:29:00.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/ipc_namespace.h	2008-04-29 14:46:34.000000000 +0200
@@ -2,7 +2,7 @@
 #define __IPC_NAMESPACE_H__
 
 #include <linux/err.h>
-#include <linux/idr.h>
+#include <linux/ridr.h>
 #include <linux/rwsem.h>
 #include <linux/notifier.h>
 
@@ -21,7 +21,7 @@ struct ipc_ids {
 	unsigned short seq;
 	unsigned short seq_max;
 	struct rw_semaphore rw_mutex;
-	struct idr ipcs_idr;
+	struct ridr ipcs_ridr;
 };
 
 struct ipc_namespace {
Index: linux-2.6.25-mm1/ipc/namespace.c
===================================================================
--- linux-2.6.25-mm1.orig/ipc/namespace.c	2008-04-25 15:29:13.000000000 +0200
+++ linux-2.6.25-mm1/ipc/namespace.c	2008-04-29 14:47:25.000000000 +0200
@@ -74,7 +74,7 @@ void free_ipcs(struct ipc_namespace *ns,
 	in_use = ids->in_use;
 
 	for (total = 0, next_id = 0; total < in_use; next_id++) {
-		perm = idr_find(&ids->ipcs_idr, next_id);
+		perm = ridr_find(&ids->ipcs_ridr, next_id);
 		if (perm == NULL)
 			continue;
 		ipc_lock_by_ptr(perm);
Index: linux-2.6.25-mm1/ipc/shm.c
===================================================================
--- linux-2.6.25-mm1.orig/ipc/shm.c	2008-04-25 15:29:13.000000000 +0200
+++ linux-2.6.25-mm1/ipc/shm.c	2008-04-29 14:48:26.000000000 +0200
@@ -569,7 +569,7 @@ static void shm_get_stat(struct ipc_name
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
+		shp = ridr_find(&shm_ids(ns).ipcs_ridr, next_id);
 		if (shp == NULL)
 			continue;
 
Index: linux-2.6.25-mm1/ipc/util.c
===================================================================
--- linux-2.6.25-mm1.orig/ipc/util.c	2008-04-25 15:29:13.000000000 +0200
+++ linux-2.6.25-mm1/ipc/util.c	2008-04-29 14:53:14.000000000 +0200
@@ -122,7 +122,7 @@ __initcall(ipc_init);
  *	@ids: Identifier set
  *
  *	Set up the sequence range to use for the ipc identifier range (limited
- *	below IPCMNI) then initialise the ids idr.
+ *	below IPCMNI) then initialise the ids ridr.
  */
  
 void ipc_init_ids(struct ipc_ids *ids)
@@ -139,7 +139,7 @@ void ipc_init_ids(struct ipc_ids *ids)
 		 	ids->seq_max = seq_limit;
 	}
 
-	idr_init(&ids->ipcs_idr);
+	ridr_init(&ids->ipcs_ridr);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -194,7 +194,7 @@ static struct kern_ipc_perm *ipc_findkey
 	int total;
 
 	for (total = 0, next_id = 0; total < ids->in_use; next_id++) {
-		ipc = idr_find(&ids->ipcs_idr, next_id);
+		ipc = ridr_find(&ids->ipcs_ridr, next_id);
 
 		if (ipc == NULL)
 			continue;
@@ -233,7 +233,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
 	/* Look for the last assigned id */
 	total = 0;
 	for (id = 0; id < IPCMNI && total < ids->in_use; id++) {
-		ipc = idr_find(&ids->ipcs_idr, id);
+		ipc = ridr_find(&ids->ipcs_ridr, id);
 		if (ipc != NULL) {
 			max_id = id;
 			total++;
@@ -248,7 +248,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	@new: new IPC permission set
  *	@size: limit for the number of used ids
  *
- *	Add an entry 'new' to the IPC ids idr. The permissions object is
+ *	Add an entry 'new' to the IPC ids ridr. The permissions object is
  *	initialised and the first free entry is set up and the id assigned
  *	is returned. The 'new' entry is returned in a locked state on success.
  *	On failure the entry is not locked and a negative err-code is returned.
@@ -266,7 +266,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
-	err = idr_get_new(&ids->ipcs_idr, new, &id);
+	err = ridr_get_new(&ids->ipcs_ridr, new, &id);
 	if (err)
 		return err;
 
@@ -302,7 +302,7 @@ static int ipcget_new(struct ipc_namespa
 {
 	int err;
 retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
+	err = ridr_pre_get(&ids->ipcs_ridr, GFP_KERNEL);
 
 	if (!err)
 		return -ENOMEM;
@@ -368,7 +368,7 @@ static int ipcget_public(struct ipc_name
 	int flg = params->flg;
 	int err;
 retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
+	err = ridr_pre_get(&ids->ipcs_ridr, GFP_KERNEL);
 
 	/*
 	 * Take the lock as a writer since we are potentially going to add
@@ -424,7 +424,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
 {
 	int lid = ipcid_to_idx(ipcp->id);
 
-	idr_remove(&ids->ipcs_idr, lid);
+	ridr_remove(&ids->ipcs_ridr, lid);
 
 	ids->in_use--;
 
@@ -685,13 +685,9 @@ void ipc64_perm_to_ipc_perm (struct ipc6
  * @ids: IPC identifier set
  * @id: ipc id to look for
  *
- * Look for an id in the ipc ids idr and lock the associated ipc object.
+ * Look for an id in the ipc ids ridr and lock the associated ipc object.
  *
  * The ipc object is locked on exit.
- *
- * This is the routine that should be called when the rw_mutex is not already
- * held, i.e. idr tree not protected: it protects the idr tree in read mode
- * during the idr_find().
  */
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
@@ -699,18 +695,13 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
 
-	down_read(&ids->rw_mutex);
-
 	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
+	out = ridr_find(&ids->ipcs_ridr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
-		up_read(&ids->rw_mutex);
 		return ERR_PTR(-EINVAL);
 	}
 
-	up_read(&ids->rw_mutex);
-
 	spin_lock(&out->lock);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock
@@ -730,12 +721,12 @@ struct kern_ipc_perm *ipc_lock(struct ip
  * @ids: IPC identifier set
  * @id: ipc id to look for
  *
- * Look for an id in the ipc ids idr and lock the associated ipc object.
+ * Look for an id in the ipc ids ridr and lock the associated ipc object.
  *
  * The ipc object is locked on exit.
  *
  * This is the routine that should be called when the rw_mutex is already
- * held, i.e. idr tree protected.
+ * held, i.e. ridr tree protected.
  */
 
 struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *ids, int id)
@@ -744,7 +735,7 @@ struct kern_ipc_perm *ipc_lock_down(stru
 	int lid = ipcid_to_idx(id);
 
 	rcu_read_lock();
-	out = idr_find(&ids->ipcs_idr, lid);
+	out = ridr_find(&ids->ipcs_ridr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
@@ -915,7 +906,7 @@ static struct kern_ipc_perm *sysvipc_fin
 
 	total = 0;
 	for (id = 0; id < pos && total < ids->in_use; id++) {
-		ipc = idr_find(&ids->ipcs_idr, id);
+		ipc = ridr_find(&ids->ipcs_ridr, id);
 		if (ipc != NULL)
 			total++;
 	}
@@ -924,7 +915,7 @@ static struct kern_ipc_perm *sysvipc_fin
 		return NULL;
 
 	for ( ; pos < IPCMNI; pos++) {
-		ipc = idr_find(&ids->ipcs_idr, pos);
+		ipc = ridr_find(&ids->ipcs_ridr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
 			ipc_lock_by_ptr(ipc);

--
