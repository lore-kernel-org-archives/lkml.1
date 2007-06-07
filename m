Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXFGQxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXFGQxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbXFGQvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:51:21 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46471 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbXFGQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:51:18 -0400
Message-Id: <20070607165557.060773000@bull.net>
References: <20070607165302.917616000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 07 Jun 2007 18:53:07 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 5/6] Introducing the ipcid_to_idx macro
Content-Disposition: inline; filename=ipcid_to_idx.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 05/06]


This is a trivial patch that changes all the (id % SEQ_MULTIPLIER) into a call
to the ipcid_to_idx(id) macro.


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 ipc/msg.c  |    2 +-
 ipc/sem.c  |    3 +--
 ipc/shm.c  |    6 ++----
 ipc/util.c |   10 +++++-----
 ipc/util.h |    2 ++
 5 files changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6.21/ipc/util.h
===================================================================
--- linux-2.6.21.orig/ipc/util.h	2007-06-07 14:57:07.000000000 +0200
+++ linux-2.6.21/ipc/util.h	2007-06-07 15:15:37.000000000 +0200
@@ -58,6 +58,8 @@ void __init ipc_init_proc_interface(cons
 #define IPC_MSG_IDS	1
 #define IPC_SHM_IDS	2
 
+#define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
+
 /* must be called with ids->mutex acquired.*/
 struct kern_ipc_perm *ipc_findkey(struct ipc_ids *, key_t);
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
Index: linux-2.6.21/ipc/util.c
===================================================================
--- linux-2.6.21.orig/ipc/util.c	2007-06-07 14:57:34.000000000 +0200
+++ linux-2.6.21/ipc/util.c	2007-06-07 15:17:31.000000000 +0200
@@ -270,7 +270,7 @@ struct kern_ipc_perm *ipc_findkey(struct
 		}
 
 		/* prepare for next id gang lookup */
-		next_id = (ipcs[nb_ipcs - 1]->id % SEQ_MULTIPLIER) + 1;
+		next_id = ipcid_to_idx(ipcs[nb_ipcs - 1]->id) + 1;
 	}
 
 	return NULL;
@@ -396,7 +396,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	struct kern_ipc_perm* p;
-	int lid = ipcp->id % SEQ_MULTIPLIER;
+	int lid = ipcid_to_idx(ipcp->id);
 	BUG_ON(lid > ids->max_id);
 
 	/* 
@@ -670,7 +670,7 @@ void ipc64_perm_to_ipc_perm (struct ipc6
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id, int checkid)
 {
 	struct kern_ipc_perm* out;
-	int lid = id % SEQ_MULTIPLIER;
+	int lid = ipcid_to_idx(id);
 
 	rcu_read_lock();
 	if (lid > ids->max_id) {
@@ -781,7 +781,7 @@ static void *sysvipc_proc_next(struct se
 
 	ipc = ipcs[0];
 	ipc_lock_by_ptr(ipc);
-	*pos = (ipc->id % SEQ_MULTIPLIER) + 1;
+	*pos = ipcid_to_idx(ipc->id) + 1;
 
 	return ipc;
 }
@@ -823,7 +823,7 @@ static void *sysvipc_proc_start(struct s
 
 	ipc = ipcs[0];
 	ipc_lock_by_ptr(ipc);
-	*pos = (ipc->id % SEQ_MULTIPLIER) + 1;
+	*pos = ipcid_to_idx(ipc->id) + 1;
 
 	return ipc;
 }
Index: linux-2.6.21/ipc/msg.c
===================================================================
--- linux-2.6.21.orig/ipc/msg.c	2007-06-07 14:40:08.000000000 +0200
+++ linux-2.6.21/ipc/msg.c	2007-06-07 15:18:32.000000000 +0200
@@ -130,7 +130,7 @@ void msg_exit_ns(struct ipc_namespace *n
 		}
 
 		/* prepare for next id gang lookup */
-		next_id = (msqs[nb_msqs - 1]->q_perm.id % SEQ_MULTIPLIER) + 1;
+		next_id = ipcid_to_idx(msqs[nb_msqs - 1]->q_perm.id) + 1;
 	}
 	mutex_unlock(&msg_ids(ns).mutex);
 
Index: linux-2.6.21/ipc/sem.c
===================================================================
--- linux-2.6.21.orig/ipc/sem.c	2007-06-07 14:56:36.000000000 +0200
+++ linux-2.6.21/ipc/sem.c	2007-06-07 15:19:21.000000000 +0200
@@ -169,8 +169,7 @@ void sem_exit_ns(struct ipc_namespace *n
 		}
 
 		/* prepare for next id gang lookup */
-		next_id = (smas[nb_smas - 1]->sem_perm.id % SEQ_MULTIPLIER)
-				+ 1;
+		next_id = ipcid_to_idx(smas[nb_smas - 1]->sem_perm.id) + 1;
 	}
 	mutex_unlock(&sem_ids(ns).mutex);
 
Index: linux-2.6.21/ipc/shm.c
===================================================================
--- linux-2.6.21.orig/ipc/shm.c	2007-06-07 14:55:28.000000000 +0200
+++ linux-2.6.21/ipc/shm.c	2007-06-07 15:20:20.000000000 +0200
@@ -132,8 +132,7 @@ void shm_exit_ns(struct ipc_namespace *n
 		}
 
 		/* prepare for next id gang lookup */
-		next_id = (shps[nb_shps - 1]->shm_perm.id % SEQ_MULTIPLIER)
-				+ 1;
+		next_id = ipcid_to_idx(shps[nb_shps - 1]->shm_perm.id) + 1;
 	}
 	mutex_unlock(&shm_ids(ns).mutex);
 
@@ -596,8 +595,7 @@ static void shm_get_stat(struct ipc_name
 		}
 
 		/* prepare for next id gang lookup */
-		next_id = (shps[nb_shps - 1]->shm_perm.id % SEQ_MULTIPLIER)
-				+ 1;
+		next_id = ipcid_to_idx(shps[nb_shps - 1]->shm_perm.id) + 1;
 	}
 }
 

--
