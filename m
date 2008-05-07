Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYEGLlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYEGLlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbYEGLiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:38:18 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56446 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbYEGLhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:37:52 -0400
Message-Id: <20080507113737.964082000@bull.net>
References: <20080507113553.395937000@bull.net>
User-Agent: quilt/0.45-1
Date: Wed, 07 May 2008 13:36:01 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 8/9] Call idr_find() without locking in ipc_lock()
Content-Disposition: inline; filename=ipc_fix_ipc_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 08/09]

This patch makes idr_find() called locklessly in ipc_lock(), since the idr
tree is now RCU protected.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/util.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6.25-mm1/ipc/util.c
===================================================================
--- linux-2.6.25-mm1.orig/ipc/util.c	2008-05-06 17:15:10.000000000 +0200
+++ linux-2.6.25-mm1/ipc/util.c	2008-05-07 09:56:20.000000000 +0200
@@ -688,10 +688,6 @@ void ipc64_perm_to_ipc_perm (struct ipc6
  * Look for an id in the ipc ids idr and lock the associated ipc object.
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
 	out = idr_find(&ids->ipcs_idr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
-		up_read(&ids->rw_mutex);
 		return ERR_PTR(-EINVAL);
 	}
 
-	up_read(&ids->rw_mutex);
-
 	spin_lock(&out->lock);
 	
 	/* ipc_rmid() may have already freed the ID while ipc_lock

--
