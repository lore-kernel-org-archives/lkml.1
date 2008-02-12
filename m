Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbYBLQ10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbYBLQ10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbYBLQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:27:14 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53577 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325AbYBLQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:27:13 -0500
Message-Id: <20080212162720.306787485@bull.net>
References: <20080212161340.200976067@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 12 Feb 2008 17:13:41 +0100
From: pierre.peiffer@bull.net
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24-mm1 1/8] (resend) IPC/semaphores: code factorisation
Content-Disposition: inline; filename=ipc_sem_code_factorization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Peiffer <pierre.peiffer@bull.net>

Trivial patch which adds some small locking functions and makes use of them
to factorize some part of the code and to make it cleaner.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 ipc/sem.c |   61 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -180,6 +180,25 @@ static inline struct sem_array *sem_lock
 	return container_of(ipcp, struct sem_array, sem_perm);
 }
 
+static inline void sem_lock_and_putref(struct sem_array *sma)
+{
+	ipc_lock_by_ptr(&sma->sem_perm);
+	ipc_rcu_putref(sma);
+}
+
+static inline void sem_getref_and_unlock(struct sem_array *sma)
+{
+	ipc_rcu_getref(sma);
+	ipc_unlock(&(sma)->sem_perm);
+}
+
+static inline void sem_putref(struct sem_array *sma)
+{
+	ipc_lock_by_ptr(&sma->sem_perm);
+	ipc_rcu_putref(sma);
+	ipc_unlock(&(sma)->sem_perm);
+}
+
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
 {
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
@@ -698,19 +717,15 @@ static int semctl_main(struct ipc_namesp
 		int i;
 
 		if(nsems > SEMMSL_FAST) {
-			ipc_rcu_getref(sma);
-			sem_unlock(sma);			
+			sem_getref_and_unlock(sma);
 
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
-				ipc_lock_by_ptr(&sma->sem_perm);
-				ipc_rcu_putref(sma);
-				sem_unlock(sma);
+				sem_putref(sma);
 				return -ENOMEM;
 			}
 
-			ipc_lock_by_ptr(&sma->sem_perm);
-			ipc_rcu_putref(sma);
+			sem_lock_and_putref(sma);
 			if (sma->sem_perm.deleted) {
 				sem_unlock(sma);
 				err = -EIDRM;
@@ -731,38 +746,30 @@ static int semctl_main(struct ipc_namesp
 		int i;
 		struct sem_undo *un;
 
-		ipc_rcu_getref(sma);
-		sem_unlock(sma);
+		sem_getref_and_unlock(sma);
 
 		if(nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if(sem_io == NULL) {
-				ipc_lock_by_ptr(&sma->sem_perm);
-				ipc_rcu_putref(sma);
-				sem_unlock(sma);
+				sem_putref(sma);
 				return -ENOMEM;
 			}
 		}
 
 		if (copy_from_user (sem_io, arg.array, nsems*sizeof(ushort))) {
-			ipc_lock_by_ptr(&sma->sem_perm);
-			ipc_rcu_putref(sma);
-			sem_unlock(sma);
+			sem_putref(sma);
 			err = -EFAULT;
 			goto out_free;
 		}
 
 		for (i = 0; i < nsems; i++) {
 			if (sem_io[i] > SEMVMX) {
-				ipc_lock_by_ptr(&sma->sem_perm);
-				ipc_rcu_putref(sma);
-				sem_unlock(sma);
+				sem_putref(sma);
 				err = -ERANGE;
 				goto out_free;
 			}
 		}
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
+		sem_lock_and_putref(sma);
 		if (sma->sem_perm.deleted) {
 			sem_unlock(sma);
 			err = -EIDRM;
@@ -1042,14 +1049,11 @@ static struct sem_undo *find_undo(struct
 		return ERR_PTR(PTR_ERR(sma));
 
 	nsems = sma->sem_nsems;
-	ipc_rcu_getref(sma);
-	sem_unlock(sma);
+	sem_getref_and_unlock(sma);
 
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
-		sem_unlock(sma);
+		sem_putref(sma);
 		return ERR_PTR(-ENOMEM);
 	}
 	new->semadj = (short *) &new[1];
@@ -1060,13 +1064,10 @@ static struct sem_undo *find_undo(struct
 	if (un) {
 		spin_unlock(&ulp->lock);
 		kfree(new);
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
-		sem_unlock(sma);
+		sem_putref(sma);
 		goto out;
 	}
-	ipc_lock_by_ptr(&sma->sem_perm);
-	ipc_rcu_putref(sma);
+	sem_lock_and_putref(sma);
 	if (sma->sem_perm.deleted) {
 		sem_unlock(sma);
 		spin_unlock(&ulp->lock);

-- 
Pierre Peiffer
