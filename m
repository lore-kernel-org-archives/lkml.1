Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXLIRQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXLIRQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXLIRQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:16:19 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:12016 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbXLIRQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=kJZeot644tvV3dTZhI6w0YRUbxooyImDVc49KlJlyg4pQ5T+V3gg/iBvwAEWpd+SGHqZxqVXJKf6hYJRA3H/OyYREZvZPFPc1Y/JyG/P2VSo2dh5MyMAx6JSBLpr67UJ8vYAYv24+ZddMYoOcmNw8xwZPf0J/ms1xwWufd2Kv0M=
Message-Id: <20071209171613.670807836@gmail.com>
References: <20071209171509.601451827@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 09 Dec 2007 13:15:11 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kevin Winchester <kjwinchester@gmail.com>
Subject: [patch 2/2] 9p util semaphore to mutex
Content-Disposition: inline; filename=9p-util-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the semaphore to a mutex in net/9p/util.c

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>

---
 net/9p/util.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: v2.6.24-rc4/net/9p/util.c
===================================================================
--- v2.6.24-rc4.orig/net/9p/util.c
+++ v2.6.24-rc4/net/9p/util.c
@@ -33,7 +33,7 @@
 #include <net/9p/9p.h>
 
 struct p9_idpool {
-	struct semaphore lock;
+	struct mutex lock;
 	struct idr pool;
 };
 
@@ -45,7 +45,7 @@ struct p9_idpool *p9_idpool_create(void)
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
-	init_MUTEX(&p->lock);
+	mutex_init(&p->lock);
 	idr_init(&p->pool);
 
 	return p;
@@ -76,14 +76,14 @@ retry:
 	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
 		return 0;
 
-	if (down_interruptible(&p->lock) == -EINTR) {
+	if (mutex_lock_interruptible(&p->lock) == -EINTR) {
 		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
 		return -1;
 	}
 
 	/* no need to store exactly p, we just need something non-null */
 	error = idr_get_new(&p->pool, p, &i);
-	up(&p->lock);
+	mutex_unlock(&p->lock);
 
 	if (error == -EAGAIN)
 		goto retry;
@@ -104,12 +104,12 @@ EXPORT_SYMBOL(p9_idpool_get);
 
 void p9_idpool_put(int id, struct p9_idpool *p)
 {
-	if (down_interruptible(&p->lock) == -EINTR) {
+	if (mutex_lock_interruptible(&p->lock) == -EINTR) {
 		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
 		return;
 	}
 	idr_remove(&p->pool, id);
-	up(&p->lock);
+	mutex_unlock(&p->lock);
 }
 EXPORT_SYMBOL(p9_idpool_put);
 

-- 
