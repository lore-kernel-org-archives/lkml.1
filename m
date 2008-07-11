Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYGKNsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYGKNsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbYGKNrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:52 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34965 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755734AbYGKNru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:50 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 4/30] W1: w1_process, block or sleep
Date: Fri, 11 Jul 2008 17:51:19 +0400
Message-Id: <1215784305680-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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

