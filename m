Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbYD2OlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbYD2OlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761486AbYD2Oh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:58 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49877 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761437AbYD2Oh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:56 -0400
Message-Id: <20080429143732.153670000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:14 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 10/10] Get rid of ipc_lock_down()
Content-Disposition: inline; filename=remove_ipc_lock_down.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 10/10]

With the previous patch ipc_lock() becomes lockless.
So there is no need anymore for ipc_lock_down()-like routines.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/shm.c  |   21 +++------------------
 ipc/util.c |   52 +---------------------------------------------------
 ipc/util.h |    6 ------
 3 files changed, 4 insertions(+), 75 deletions(-)

Index: linux-2.6.25-mm1/ipc/util.c
===================================================================
--- linux-2.6.25-mm1.orig/ipc/util.c	2008-04-29 14:53:14.000000000 +0200
+++ linux-2.6.25-mm1/ipc/util.c	2008-04-29 14:59:06.000000000 +0200
@@ -716,56 +716,6 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	return out;
 }
 
-/**
- * ipc_lock_down - Lock an ipc structure with rw_sem held
- * @ids: IPC identifier set
- * @id: ipc id to look for
- *
- * Look for an id in the ipc ids ridr and lock the associated ipc object.
- *
- * The ipc object is locked on exit.
- *
- * This is the routine that should be called when the rw_mutex is already
- * held, i.e. ridr tree protected.
- */
-
-struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-	int lid = ipcid_to_idx(id);
-
-	rcu_read_lock();
-	out = ridr_find(&ids->ipcs_ridr, lid);
-	if (out == NULL) {
-		rcu_read_unlock();
-		return ERR_PTR(-EINVAL);
-	}
-
-	spin_lock(&out->lock);
-
-	/*
-	 * No need to verify that the structure is still valid since the
-	 * rw_mutex is held.
-	 */
-	return out;
-}
-
-struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-
-	out = ipc_lock_down(ids, id);
-	if (IS_ERR(out))
-		return out;
-
-	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
-		return ERR_PTR(-EIDRM);
-	}
-
-	return out;
-}
-
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
@@ -837,7 +787,7 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 	int err;
 
 	down_write(&ids->rw_mutex);
-	ipcp = ipc_lock_check_down(ids, id);
+	ipcp = ipc_lock_check(ids, id);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
 		goto out_up;
Index: linux-2.6.25-mm1/ipc/util.h
===================================================================
--- linux-2.6.25-mm1.orig/ipc/util.h	2008-04-25 15:29:13.000000000 +0200
+++ linux-2.6.25-mm1/ipc/util.h	2008-04-29 14:59:49.000000000 +0200
@@ -102,11 +102,6 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-/*
- * ipc_lock_down: called with rw_mutex held
- * ipc_lock: called without that lock held
- */
-struct kern_ipc_perm *ipc_lock_down(struct ipc_ids *, int);
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
@@ -155,7 +150,6 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
-struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
Index: linux-2.6.25-mm1/ipc/shm.c
===================================================================
--- linux-2.6.25-mm1.orig/ipc/shm.c	2008-04-29 14:48:26.000000000 +0200
+++ linux-2.6.25-mm1/ipc/shm.c	2008-04-29 15:01:24.000000000 +0200
@@ -112,23 +112,8 @@ void __init shm_init (void)
 }
 
 /*
- * shm_lock_(check_)down routines are called in the paths where the rw_mutex
- * is held to protect access to the idr tree.
- */
-static inline struct shmid_kernel *shm_lock_down(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_down(&shm_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct shmid_kernel *)ipcp;
-
-	return container_of(ipcp, struct shmid_kernel, shm_perm);
-}
-
-/*
  * shm_lock_(check_) routines are called in the paths where the rw_mutex
- * is not held.
+ * is not necessarily held.
  */
 static inline struct shmid_kernel *shm_lock(struct ipc_namespace *ns, int id)
 {
@@ -211,7 +196,7 @@ static void shm_close(struct vm_area_str
 
 	down_write(&shm_ids(ns).rw_mutex);
 	/* remove from the list of attaches of the shm segment */
-	shp = shm_lock_down(ns, sfd->id);
+	shp = shm_lock(ns, sfd->id);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
@@ -933,7 +918,7 @@ invalid:
 
 out_nattch:
 	down_write(&shm_ids(ns).rw_mutex);
-	shp = shm_lock_down(ns, shmid);
+	shp = shm_lock(ns, shmid);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if(shp->shm_nattch == 0 &&

--
