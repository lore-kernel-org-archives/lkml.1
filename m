Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbXJKHcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbXJKHcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbXJKHcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:32:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59146 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXJKHca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:32:30 -0400
Date: Thu, 11 Oct 2007 09:32:22 +0200
From: Pierre Peiffer <Pierre.Peiffer@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] IPC: fix error case when idr-cache is empty in ipcget()
Message-Id: <20071011093222.5600520c.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 09:38:48,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/10/2007 09:38:50,
	Serialize complete at 11/10/2007 09:38:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I resend this patch, by taking into account Nadia's remarks.

With the use of idr to store the ipc, the case where the idr cache is
empty, when idr_get_new is called (this may happen even if we call
idr_pre_get() before), is not well handled: it lets semget()/shmget()/msgget()
return ENOSPC when this cache is empty, what 1. does not reflect the facts
and 2. does not conform to the man(s).

This patch fixes this by retrying the whole process of allocation in this case.

This patch applies on top of 2.6.23-rc8-mm2 and should probably be merged
in 2.6.24 if Nadia's patches are included.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>

---
 ipc/msg.c  |    4 ++--
 ipc/sem.c  |    4 ++--
 ipc/shm.c  |    5 +++--
 ipc/util.c |   16 +++++++++++-----
 4 files changed, 18 insertions(+), 11 deletions(-)

Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -188,10 +188,10 @@ static int newque(struct ipc_namespace *
 	 * ipc_addid() locks msq
 	 */
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
-	if (id == -1) {
+	if (id < 0) {
 		security_msg_queue_free(msq);
 		ipc_rcu_putref(msq);
-		return -ENOSPC;
+		return id;
 	}
 
 	msq->q_perm.id = msg_buildid(ns, id, msq->q_perm.seq);
Index: b/ipc/sem.c
===================================================================
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -269,10 +269,10 @@ static int newary(struct ipc_namespace *
 	}
 
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
-	if(id == -1) {
+	if (id < 0) {
 		security_sem_free(sma);
 		ipc_rcu_putref(sma);
-		return -ENOSPC;
+		return id;
 	}
 	ns->used_sems += nsems;
 
Index: b/ipc/shm.c
===================================================================
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -409,10 +409,11 @@ static int newseg(struct ipc_namespace *
 	if (IS_ERR(file))
 		goto no_file;
 
-	error = -ENOSPC;
 	id = shm_addid(ns, shp);
-	if(id == -1) 
+	if (id < 0) {
+		error = id;
 		goto no_id;
+	}
 
 	shp->shm_cprid = task_tgid_vnr(current);
 	shp->shm_lprid = 0;
Index: b/ipc/util.c
===================================================================
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -261,7 +261,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	Add an entry 'new' to the IPC ids idr. The permissions object is
  *	initialised and the first free entry is set up and the id assigned
  *	is returned. The 'new' entry is returned in a locked state on success.
- *	On failure the entry is not locked and -1 is returned.
+ *	On failure the entry is not locked and a negative err-code is returned.
  *
  *	Called with ipc_ids.mutex held.
  */
@@ -274,11 +274,11 @@ int ipc_addid(struct ipc_ids* ids, struc
 		size = IPCMNI;
 
 	if (ids->in_use >= size)
-		return -1;
+		return -ENOSPC;
 
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
 	if (err)
-		return -1;
+		return err;
 
 	ids->in_use++;
 
@@ -310,7 +310,7 @@ int ipcget_new(struct ipc_namespace *ns,
 		struct ipc_ops *ops, struct ipc_params *params)
 {
 	int err;
-
+retry:
 	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
 	if (!err)
@@ -320,6 +320,9 @@ int ipcget_new(struct ipc_namespace *ns,
 	err = ops->getnew(ns, params);
 	mutex_unlock(&ids->mutex);
 
+	if (err == -EAGAIN)
+		goto retry;
+
 	return err;
 }
 
@@ -373,7 +376,7 @@ int ipcget_public(struct ipc_namespace *
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
 	int err;
-
+retry:
 	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
 	mutex_lock(&ids->mutex);
@@ -406,6 +409,9 @@ int ipcget_public(struct ipc_namespace *
 	}
 	mutex_unlock(&ids->mutex);
 
+	if (err == -EAGAIN)
+		goto retry;
+
 	return err;
 }

-- 
Pierre Peiffer
