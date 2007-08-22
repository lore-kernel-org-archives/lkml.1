Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbXHVI4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbXHVI4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbXHVIwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:50 -0400
Received: from 1wt.eu ([62.212.114.60]:1939 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXHVIws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:48 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083943.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:49 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Ranko Zivojnovic <ranko@spidernet.net>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 05/58] gen estimator deadlock fix
Content-Disposition: inline; filename=0005-gen-estimator-deadlock-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[NET]: gen_estimator deadlock fix

-Fixes ABBA deadlock noted by Patrick McHardy <kaber@trash.net>:

> There is at least one ABBA deadlock, est_timer() does:
> read_lock(&est_lock)
> spin_lock(e->stats_lock) (which is dev->queue_lock)
>
> and qdisc_destroy calls htb_destroy under dev->queue_lock, which
> calls htb_destroy_class, then gen_kill_estimator and this
> write_locks est_lock.

To fix the ABBA deadlock the rate estimators are now kept on an rcu list.

-The est_lock changes the use from protecting the list to protecting
the update to the 'bstat' pointer in order to avoid NULL dereferencing.

-The 'interval' member of the gen_estimator structure removed as it is
not needed.

Signed-off-by: Ranko Zivojnovic <ranko@spidernet.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/gen_estimator.c |   81 ++++++++++++++++++++++++++++------------------
 1 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 33d82bf..acc1ee0 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -79,27 +79,27 @@
 
 struct gen_estimator
 {
-	struct gen_estimator	*next;
+	struct list_head	list;
 	struct gnet_stats_basic	*bstats;
 	struct gnet_stats_rate_est	*rate_est;
 	spinlock_t		*stats_lock;
-	unsigned		interval;
 	int			ewma_log;
 	u64			last_bytes;
 	u32			last_packets;
 	u32			avpps;
 	u32			avbps;
+	struct rcu_head		e_rcu;
 };
 
 struct gen_estimator_head
 {
 	struct timer_list	timer;
-	struct gen_estimator	*list;
+	struct list_head	list;
 };
 
 static struct gen_estimator_head elist[EST_MAX_INTERVAL+1];
 
-/* Estimator array lock */
+/* Protects against NULL dereference */
 static DEFINE_RWLOCK(est_lock);
 
 static void est_timer(unsigned long arg)
@@ -107,13 +107,17 @@ static void est_timer(unsigned long arg)
 	int idx = (int)arg;
 	struct gen_estimator *e;
 
-	read_lock(&est_lock);
-	for (e = elist[idx].list; e; e = e->next) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(e, &elist[idx].list, list) {
 		u64 nbytes;
 		u32 npackets;
 		u32 rate;
 
 		spin_lock(e->stats_lock);
+		read_lock(&est_lock);
+		if (e->bstats == NULL)
+			goto skip;
+
 		nbytes = e->bstats->bytes;
 		npackets = e->bstats->packets;
 		rate = (nbytes - e->last_bytes)<<(7 - idx);
@@ -125,12 +129,14 @@ static void est_timer(unsigned long arg)
 		e->last_packets = npackets;
 		e->avpps += ((long)rate - (long)e->avpps) >> e->ewma_log;
 		e->rate_est->pps = (e->avpps+0x1FF)>>10;
+skip:
+		read_unlock(&est_lock);
 		spin_unlock(e->stats_lock);
 	}
 
-	if (elist[idx].list != NULL)
+	if (!list_empty(&elist[idx].list))
 		mod_timer(&elist[idx].timer, jiffies + ((HZ<<idx)/4));
-	read_unlock(&est_lock);
+	rcu_read_unlock();
 }
 
 /**
@@ -147,12 +153,17 @@ static void est_timer(unsigned long arg)
  * &rate_est with the statistics lock grabed during this period.
  * 
  * Returns 0 on success or a negative error code.
+ *
+ * NOTE: Called under rtnl_mutex
  */
 int gen_new_estimator(struct gnet_stats_basic *bstats,
-	struct gnet_stats_rate_est *rate_est, spinlock_t *stats_lock, struct rtattr *opt)
+		      struct gnet_stats_rate_est *rate_est,
+		      spinlock_t *stats_lock,
+		      struct rtattr *opt)
 {
 	struct gen_estimator *est;
 	struct gnet_estimator *parm = RTA_DATA(opt);
+	int idx;
 
 	if (RTA_PAYLOAD(opt) < sizeof(*parm))
 		return -EINVAL;
@@ -164,7 +175,7 @@ int gen_new_estimator(struct gnet_stats_basic *bstats,
 	if (est == NULL)
 		return -ENOBUFS;
 
-	est->interval = parm->interval + 2;
+	idx = parm->interval + 2;
 	est->bstats = bstats;
 	est->rate_est = rate_est;
 	est->stats_lock = stats_lock;
@@ -174,20 +185,25 @@ int gen_new_estimator(struct gnet_stats_basic *bstats,
 	est->last_packets = bstats->packets;
 	est->avpps = rate_est->pps<<10;
 
-	est->next = elist[est->interval].list;
-	if (est->next == NULL) {
-		init_timer(&elist[est->interval].timer);
-		elist[est->interval].timer.data = est->interval;
-		elist[est->interval].timer.expires = jiffies + ((HZ<<est->interval)/4);
-		elist[est->interval].timer.function = est_timer;
-		add_timer(&elist[est->interval].timer);
+	if (!elist[idx].timer.function) {
+		INIT_LIST_HEAD(&elist[idx].list);
+		setup_timer(&elist[idx].timer, est_timer, idx);
 	}
-	write_lock_bh(&est_lock);
-	elist[est->interval].list = est;
-	write_unlock_bh(&est_lock);
+
+	if (list_empty(&elist[idx].list))
+		mod_timer(&elist[idx].timer, jiffies + ((HZ<<idx)/4));
+
+	list_add_rcu(&est->list, &elist[idx].list);
 	return 0;
 }
 
+static void __gen_kill_estimator(struct rcu_head *head)
+{
+	struct gen_estimator *e = container_of(head,
+					struct gen_estimator, e_rcu);
+	kfree(e);
+}
+
 /**
  * gen_kill_estimator - remove a rate estimator
  * @bstats: basic statistics
@@ -195,31 +211,32 @@ int gen_new_estimator(struct gnet_stats_basic *bstats,
  *
  * Removes the rate estimator specified by &bstats and &rate_est
  * and deletes the timer.
+ *
+ * NOTE: Called under rtnl_mutex
  */
 void gen_kill_estimator(struct gnet_stats_basic *bstats,
 	struct gnet_stats_rate_est *rate_est)
 {
 	int idx;
-	struct gen_estimator *est, **pest;
+	struct gen_estimator *e, *n;
 
 	for (idx=0; idx <= EST_MAX_INTERVAL; idx++) {
-		int killed = 0;
-		pest = &elist[idx].list;
-		while ((est=*pest) != NULL) {
-			if (est->rate_est != rate_est || est->bstats != bstats) {
-				pest = &est->next;
+
+		/* Skip non initialized indexes */
+		if (!elist[idx].timer.function)
+			continue;
+
+		list_for_each_entry_safe(e, n, &elist[idx].list, list) {
+			if (e->rate_est != rate_est || e->bstats != bstats)
 				continue;
-			}
 
 			write_lock_bh(&est_lock);
-			*pest = est->next;
+			e->bstats = NULL;
 			write_unlock_bh(&est_lock);
 
-			kfree(est);
-			killed++;
+			list_del_rcu(&e->list);
+			call_rcu(&e->e_rcu, __gen_kill_estimator);
 		}
-		if (killed && elist[idx].list == NULL)
-			del_timer(&elist[idx].timer);
 	}
 }
 
-- 
1.5.2.5

-- 
