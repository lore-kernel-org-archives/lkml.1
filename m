Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbXLHDIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbXLHDIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbXLHDIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:08:14 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7816 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753297AbXLHDIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:08:11 -0500
Message-Id: <20071208025623.282441997@mvista.com>
References: <20071208025620.470633411@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 07 Dec 2007 00:00:04 -0800
Subject: [PATCH 4/4] md: dm driver: suspend_lock semaphore to mutex
References: <20071208025608.631609481@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Content-Disposition: inline; filename=md-suspend_lock-semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/md/dm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.23/drivers/md/dm.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm.c
+++ linux-2.6.23/drivers/md/dm.c
@@ -73,7 +73,7 @@ union map_info *dm_get_mapinfo(struct bi
 
 struct mapped_device {
 	struct rw_semaphore io_lock;
-	struct semaphore suspend_lock;
+	struct mutex suspend_lock;
 	spinlock_t pushback_lock;
 	rwlock_t map_lock;
 	atomic_t holders;
@@ -982,7 +982,7 @@ static struct mapped_device *alloc_dev(i
 
 	memset(md, 0, sizeof(*md));
 	init_rwsem(&md->io_lock);
-	init_MUTEX(&md->suspend_lock);
+	mutex_init(&md->suspend_lock);
 	spin_lock_init(&md->pushback_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
@@ -1270,7 +1270,7 @@ int dm_swap_table(struct mapped_device *
 {
 	int r = -EINVAL;
 
-	down(&md->suspend_lock);
+	mutex_lock(&md->suspend_lock);
 
 	/* device must be suspended */
 	if (!dm_suspended(md))
@@ -1285,7 +1285,7 @@ int dm_swap_table(struct mapped_device *
 	r = __bind(md, table);
 
 out:
-	up(&md->suspend_lock);
+	mutex_unlock(&md->suspend_lock);
 	return r;
 }
 
@@ -1341,7 +1341,7 @@ int dm_suspend(struct mapped_device *md,
 	int do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG ? 1 : 0;
 	int noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG ? 1 : 0;
 
-	down(&md->suspend_lock);
+	mutex_lock(&md->suspend_lock);
 
 	if (dm_suspended(md))
 		goto out_unlock;
@@ -1462,7 +1462,7 @@ out:
 	dm_table_put(map);
 
 out_unlock:
-	up(&md->suspend_lock);
+	mutex_unlock(&md->suspend_lock);
 	return r;
 }
 
@@ -1472,7 +1472,7 @@ int dm_resume(struct mapped_device *md)
 	struct bio *def;
 	struct dm_table *map = NULL;
 
-	down(&md->suspend_lock);
+	mutex_lock(&md->suspend_lock);
 	if (!dm_suspended(md))
 		goto out;
 
@@ -1508,7 +1508,7 @@ int dm_resume(struct mapped_device *md)
 
 out:
 	dm_table_put(map);
-	up(&md->suspend_lock);
+	mutex_unlock(&md->suspend_lock);
 
 	return r;
 }

-- 
