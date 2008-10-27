Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbYJ0HcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbYJ0HcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYJ0HcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:32:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52865 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYJ0HcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:32:10 -0400
Message-Id: <20081027072836.438113395@bull.net>
References: <20081027072826.266777838@bull.net>
User-Agent: quilt/0.46-1
Date: Mon, 27 Oct 2008 08:28:27 +0100
From: Nadia.Derbey@bull.net
To: akpm@linux-foundation.org, cboulte@gmail.com
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net
Subject: [PATCH 1/1] (v3) SYSVIPC - Fix the ipc structures initialization
Content-Disposition: inline; filename=ipc-fix-sysvipc_structures_initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is a fix for Bugzilla bug
http://bugzilla.kernel.org/show_bug.cgi?id=11796.

To summarize, a simple testcase is concurrently running an infinite loop on
msgctl(IPC_STAT) and a call to msgget():

while (1)
   msgctl(id, IPC_STAT)    1
                           |
                           |
                           |
                           2 id = msgget(key, IPC_CREAT)
                           |
                           |
                           |

In the interval [1-2], the id doesn't exist yet.

In that test, the problem is the following:
When we are calling ipc_addid() from msgget() the msq structure is not
completely initialized. So idr_get_new() is inserting a pointer into the
idr tree, and the structure which is pointed to has, among other fields,
its lock uninitialized.

Since msgctl(IPC_STAT) is looping while (1), idr_find() returns the
pointer as soon as it is inserted into the IDR tree. And ipc_lock()
calls spin_lock(&mqs->lock), while we have not initialized that lock
yet.

This patch moves the spin_lock_init() before the call to ipc_addid().
It also sets the "deleted" flag to 1 in the window between msg structure
allocation and msg structure locking in ipc_addid().


Regards,
Nadia


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/util.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6.27/ipc/util.c
===================================================================
--- linux-2.6.27.orig/ipc/util.c	2008-10-23 15:20:46.000000000 +0200
+++ linux-2.6.27/ipc/util.c	2008-10-24 17:48:33.000000000 +0200
@@ -266,6 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
+	spin_lock_init(&new->lock);
+
+	/*
+	 * We have a window between the time new is inserted into the idr
+	 * tree and the time it is actually locked.
+	 * In order to be safe during that window set the new ipc structure
+	 * as deleted: a concurrent ipc_lock() will see it as not present
+	 * until the initialization phase is complete.
+	 */
+	new->deleted = 1;
+
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
 	if (err)
 		return err;
@@ -280,10 +291,11 @@ int ipc_addid(struct ipc_ids* ids, struc
 		ids->seq = 0;
 
 	new->id = ipc_buildid(id, new->seq);
-	spin_lock_init(&new->lock);
-	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
+
+	new->deleted = 0;
+
 	return id;
 }
 

-- 
