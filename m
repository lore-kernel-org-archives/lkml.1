Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYJ1PBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYJ1PBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYJ1PBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:01:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47197 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYJ1PBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:01:31 -0400
Message-Id: <20081028150041.857635775@bull.net>
References: <20081028145952.620752409@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 28 Oct 2008 15:59:53 +0100
From: Nadia.Derbey@bull.net
To: cboulte@gmail.com, manfred@colorfullife.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Nadia.Derbey@bull.net
Subject: [PATCH] SYSVIPC - Fix the ipc structures initialization
Content-Disposition: inline; filename=ipc-fix-sysvipc_structures_initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A problem was found while reviewing the code after Bugzilla bug
http://bugzilla.kernel.org/show_bug.cgi?id=11796.

In ipc_addid(), the newly allocated ipc structure is inserted into the ipcs
tree (i.e made visible to readers) without locking it.
This is not correct since its initialization continues after it has been
inserted in the tree.

This patch moves the ipc structure lock initialization + locking before
the actual insertion.

Regards,
Nadia


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/util.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6.27/ipc/util.c
===================================================================
--- linux-2.6.27.orig/ipc/util.c	2008-10-23 15:20:46.000000000 +0200
+++ linux-2.6.27/ipc/util.c	2008-10-28 16:52:17.000000000 +0100
@@ -266,9 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
+	spin_lock_init(&new->lock);
+	new->deleted = 0;
+	rcu_read_lock();
+	spin_lock(&new->lock);
+
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
-	if (err)
+	if (err) {
+		spin_unlock(&new->lock);
+		rcu_read_unlock();
 		return err;
+	}
 
 	ids->in_use++;
 
@@ -280,10 +288,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 		ids->seq = 0;
 
 	new->id = ipc_buildid(id, new->seq);
-	spin_lock_init(&new->lock);
-	new->deleted = 0;
-	rcu_read_lock();
-	spin_lock(&new->lock);
 	return id;
 }
 

-- 
