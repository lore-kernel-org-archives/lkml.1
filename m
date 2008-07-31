Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYGaCuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYGaCuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758136AbYGaCsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:48:54 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60530 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbYGaCsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:48:52 -0400
Date: Wed, 30 Jul 2008 21:48:18 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/30] W1: w1_process, block or sleep
Message-ID: <20080731024818.GE12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:48:19 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The w1_process thread's sleeping and termination has been modified.
msleep_interruptible was replaced by schedule_timeout and schedule to
allow for kthread_stop and wake_up_process to interrupt the sleep and
the unbounded sleeping when a bus search is disabled.  The
W1_MASTER_NEED_EXIT and flags variable were removed as they were
redundant with kthread_should_stop and kthread_stop.  If w1_process is
sleeping, requesting a search will immediately wake it up rather than
waiting for the end of msleep_interruptible previously.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c     |   20 +++++++++++++++++---
 drivers/w1/w1.h     |    4 ----
 drivers/w1/w1_int.c |    2 --
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 730faa4..9b5c117 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -251,6 +251,7 @@ static ssize_t w1_master_attribute_store_search(struct device * dev,
 	mutex_lock(&md->mutex);
 	md->search_count = simple_strtol(buf, NULL, 0);
 	mutex_unlock(&md->mutex);
+	wake_up_process(md->thread);
 
 	return count;
 }
@@ -773,7 +774,7 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
 
-			if (test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+			if (kthread_should_stop()) {
 				printk(KERN_INFO "Abort w1_search (exiting)\n");
 				return;
 			}
@@ -811,8 +812,12 @@ void w1_search_process(struct w1_master *dev, u8 search_type)
 int w1_process(void *data)
 {
 	struct w1_master *dev = (struct w1_master *) data;
+	/* As long as w1_timeout is only set by a module parameter the sleep
+	 * time can be calculated in jiffies once.
+	 */
+	const unsigned long jtime = msecs_to_jiffies(w1_timeout * 1000);
 
-	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+	while (!kthread_should_stop()) {
 		if (dev->search_count) {
 			mutex_lock(&dev->mutex);
 			w1_search_process(dev, W1_SEARCH);
@@ -820,7 +825,16 @@ int w1_process(void *data)
 		}
 
 		try_to_freeze();
-		msleep_interruptible(w1_timeout * 1000);
+		__set_current_state(TASK_INTERRUPTIBLE);
+
+		if (kthread_should_stop())
+			break;
+
+		/* Only sleep when the search is active. */
+		if (dev->search_count)
+			schedule_timeout(jtime);
+		else
+			schedule();
 	}
 
 	atomic_dec(&dev->refcnt);
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 13e0ea8..34ee01e 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -149,8 +149,6 @@ struct w1_bus_master
 		u8, w1_slave_found_callback);
 };
 
-#define W1_MASTER_NEED_EXIT		0
-
 struct w1_master
 {
 	struct list_head	w1_master_entry;
@@ -169,8 +167,6 @@ struct w1_master
 	void			*priv;
 	int			priv_size;
 
-	long			flags;
-
 	struct task_struct	*thread;
 	struct mutex		mutex;
 
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 36ff402..bd877b2 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -142,7 +142,6 @@ int w1_add_master_device(struct w1_bus_master *master)
 
 #if 0 /* Thread cleanup code, not required currently. */
 err_out_kill_thread:
-	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
 #endif
 err_out_rm_attr:
@@ -158,7 +157,6 @@ void __w1_remove_master_device(struct w1_master *dev)
 	struct w1_netlink_msg msg;
 	struct w1_slave *sl, *sln;
 
-	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
 
 	mutex_lock(&w1_mlock);
-- 
1.4.4.4
