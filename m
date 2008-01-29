Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbYA2QQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbYA2QQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764326AbYA2QPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:15:54 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43772 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763920AbYA2QPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:15:53 -0500
Message-Id: <20080129161555.916992860@bull.net>
References: <20080129160229.612172683@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 17:02:30 +0100
From: pierre.peiffer@bull.net
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 2.6.24-rc8-mm1 01/15] IPC/semaphores: code factorisation
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 17:24:31,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 17:24:34,
	Serialize complete at 29/01/2008 17:24:34
Content-Disposition: inline; filename=ipc_sem_code_factorization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Peiffer <pierre.peiffer@bull.net>

Trivial patch which adds some small locking functions and makes use of them
to factorize some part of code and makes it cleaner.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 ipc/sem.c |   61 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -181,6 +181,25 @@ static inline struct sem_array *sem_lock
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
@@ -700,19 +719,15 @@ static int semctl_main(struct ipc_namesp
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
@@ -733,38 +748,30 @@ static int semctl_main(struct ipc_namesp
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
@@ -1044,14 +1051,11 @@ static struct sem_undo *find_undo(struct
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
@@ -1062,13 +1066,10 @@ static struct sem_undo *find_undo(struct
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
