Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbXHaLWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbXHaLWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964886AbXHaLVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:21:07 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43386 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbXHaLU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:20:59 -0400
Message-Id: <20070831112614.354186000@bull.net>
References: <20070831112445.976429000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 31 Aug 2007 13:24:48 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: matthltc@us.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 3/6] Removing the ipc_get() routine
Content-Disposition: inline; filename=ipc_get.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/06]


This is a trivial patch that removes the ipc_get() routine: it is replaced
by a call to idr_find().
     
     
Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/shm.c  |   16 +++++++++++++---
 ipc/util.c |   19 -------------------
 ipc/util.h |    1 -
 3 files changed, 13 insertions(+), 23 deletions(-)

Index: linux-2.6.23-rc2/ipc/util.h
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.h	2007-08-31 11:38:50.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.h	2007-08-31 11:59:11.000000000 +0200
@@ -103,7 +103,6 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-struct kern_ipc_perm* ipc_get(struct ipc_ids* ids, int id);
 struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id);
 void ipc_lock_by_ptr(struct kern_ipc_perm *ipcp);
 void ipc_unlock(struct kern_ipc_perm* perm);
Index: linux-2.6.23-rc2/ipc/util.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/util.c	2007-08-31 11:40:03.000000000 +0200
+++ linux-2.6.23-rc2/ipc/util.c	2007-08-31 11:59:46.000000000 +0200
@@ -669,25 +669,6 @@ void ipc64_perm_to_ipc_perm (struct ipc6
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
-struct kern_ipc_perm *ipc_get(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-	int lid = id % SEQ_MULTIPLIER;
-	out = idr_find(&ids->ipcs_idr, lid);
-	return out;
-}
-
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
Index: linux-2.6.23-rc2/ipc/shm.c
===================================================================
--- linux-2.6.23-rc2.orig/ipc/shm.c	2007-08-31 11:45:57.000000000 +0200
+++ linux-2.6.23-rc2/ipc/shm.c	2007-08-31 12:13:27.000000000 +0200
@@ -63,8 +63,6 @@ static struct ipc_ids init_shm_ids;
 	((struct shmid_kernel*)ipc_lock(&shm_ids(ns),id))
 #define shm_unlock(shp)			\
 	ipc_unlock(&(shp)->shm_perm)
-#define shm_get(ns, id)			\
-	((struct shmid_kernel*)ipc_get(&shm_ids(ns),id))
 #define shm_buildid(ns, id, seq)	\
 	ipc_buildid(&shm_ids(ns), id, seq)
 
@@ -562,7 +560,19 @@ static void shm_get_stat(struct ipc_name
 		struct shmid_kernel *shp;
 		struct inode *inode;
 
-		shp = shm_get(ns, next_id);
+		/*
+		 * idr_find() is called via shm_get(), so with shm_ids.mutex
+		 * locked. Since ipc_addid() is also called with
+		 * shm_ids.mutex down, there is no need to add read barriers
+		 * here to gurantee the writes in ipc_addid() are seen in
+		 * order here (for Alpha).
+		 * However idr_find() itself does not necessary require
+		 * ipc_ids.mutex down. So if idr_find() is used by other
+		 * places without ipc_ids.mutex down, then it needs read
+		 * read memory barriers as ipc_lock() does.
+		 */
+
+		shp = idr_find(&shm_ids(ns).ipcs_idr, next_id);
 		if (shp == NULL)
 			continue;
 

--
