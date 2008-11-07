Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYKGX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYKGX20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYKGXXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:23:12 -0500
Received: from kroah.org ([198.145.64.141]:59324 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752999AbYKGXXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:23:08 -0500
Date: Fri, 7 Nov 2008 15:15:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/23] net: Fix netdev_run_todo dead-lock
Message-ID: <20081107231553.GP1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-net-Fix-netdev_run_todo-dead-lock.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 58ec3b4db9eb5a28e3aec5f407a54e28f7039c19 ]

Benjamin Thery tracked down a bug that explains many instances
of the error

unregister_netdevice: waiting for %s to become free. Usage count = %d

It turns out that netdev_run_todo can dead-lock with itself if
a second instance of it is run in a thread that will then free
a reference to the device waited on by the first instance.

The problem is really quite silly.  We were trying to create
parallelism where none was required.  As netdev_run_todo always
follows a RTNL section, and that todo tasks can only be added
with the RTNL held, by definition you should only need to wait
for the very ones that you've added and be done with it.

There is no need for a second mutex or spinlock.

This is exactly what the following patch does.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c       |   27 ++++++---------------------
 net/core/rtnetlink.c |    2 +-
 2 files changed, 7 insertions(+), 22 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3624,14 +3624,11 @@ static int dev_new_index(struct net *net
 }
 
 /* Delayed registration/unregisteration */
-static DEFINE_SPINLOCK(net_todo_list_lock);
 static LIST_HEAD(net_todo_list);
 
 static void net_set_todo(struct net_device *dev)
 {
-	spin_lock(&net_todo_list_lock);
 	list_add_tail(&dev->todo_list, &net_todo_list);
-	spin_unlock(&net_todo_list_lock);
 }
 
 static void rollback_registered(struct net_device *dev)
@@ -3941,33 +3938,24 @@ static void netdev_wait_allrefs(struct n
  *	free_netdev(y1);
  *	free_netdev(y2);
  *
- * We are invoked by rtnl_unlock() after it drops the semaphore.
+ * We are invoked by rtnl_unlock().
  * This allows us to deal with problems:
  * 1) We can delete sysfs objects which invoke hotplug
  *    without deadlocking with linkwatch via keventd.
  * 2) Since we run with the RTNL semaphore not held, we can sleep
  *    safely in order to wait for the netdev refcnt to drop to zero.
+ *
+ * We must not return until all unregister events added during
+ * the interval the lock was held have been completed.
  */
-static DEFINE_MUTEX(net_todo_run_mutex);
 void netdev_run_todo(void)
 {
 	struct list_head list;
 
-	/* Need to guard against multiple cpu's getting out of order. */
-	mutex_lock(&net_todo_run_mutex);
-
-	/* Not safe to do outside the semaphore.  We must not return
-	 * until all unregister events invoked by the local processor
-	 * have been completed (either by this todo run, or one on
-	 * another cpu).
-	 */
-	if (list_empty(&net_todo_list))
-		goto out;
-
 	/* Snapshot list, allow later requests */
-	spin_lock(&net_todo_list_lock);
 	list_replace_init(&net_todo_list, &list);
-	spin_unlock(&net_todo_list_lock);
+
+	__rtnl_unlock();
 
 	while (!list_empty(&list)) {
 		struct net_device *dev
@@ -3997,9 +3985,6 @@ void netdev_run_todo(void)
 		/* Free network device */
 		kobject_put(&dev->dev.kobj);
 	}
-
-out:
-	mutex_unlock(&net_todo_run_mutex);
 }
 
 static struct net_device_stats *internal_stats(struct net_device *dev)
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -73,7 +73,7 @@ void __rtnl_unlock(void)
 
 void rtnl_unlock(void)
 {
-	mutex_unlock(&rtnl_mutex);
+	/* This fellow will unlock it for us. */
 	netdev_run_todo();
 }
 

-- 
