Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbYJXGFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbYJXGFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbYJXGFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:05:36 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37399 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYJXGFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:05:35 -0400
Message-Id: <20081024060040.700343046@bull.net>
References: <20081024060022.897705758@bull.net>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 08:00:23 +0200
From: Nadia.Derbey@bull.net
To: akpm@linux-foundation.org, cboulte@gmail.com
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net
Subject: [PATCH 1/1] (v2) SYSVIPC - Fix the ipc structures initialization
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
It also sets the "deleted" flag to 1 in the window between ipc structure
allocation and its locking in ipc_addid().

Regards,
Nadia


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/util.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6.27/ipc/util.c
===================================================================
--- linux-2.6.27.orig/ipc/util.c	2008-10-23 15:20:46.000000000 +0200
+++ linux-2.6.27/ipc/util.c	2008-10-24 09:03:06.000000000 +0200
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
@@ -280,7 +291,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 		ids->seq = 0;
 
 	new->id = ipc_buildid(id, new->seq);
-	spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);

-- 
