Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYGaCtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYGaCtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYGaCst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:48:49 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60529 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbYGaCss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:48:48 -0400
Date: Wed, 30 Jul 2008 21:48:13 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/30] W1: don't delay search start
Message-ID: <20080731024813.GD12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:48:14 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the creation of the w1_process thread to after the device has
been initialized.  This way w1_process doesn't have to check to see if
it has been initialized and the bus search can proceed without
sleeping.  That also eliminates two checks in the w1_process loop.
The sleep now happens at the end of the loop not the beginning.

Also added a comment for why the atomic_set was 2.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c     |   19 ++++++-------------
 drivers/w1/w1_int.c |   26 +++++++++++++++++---------
 2 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index aac03f1..730faa4 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -813,21 +813,14 @@ int w1_process(void *data)
 	struct w1_master *dev = (struct w1_master *) data;
 
 	while (!kthread_should_stop() && !test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+		if (dev->search_count) {
+			mutex_lock(&dev->mutex);
+			w1_search_process(dev, W1_SEARCH);
+			mutex_unlock(&dev->mutex);
+		}
+
 		try_to_freeze();
 		msleep_interruptible(w1_timeout * 1000);
-
-		if (kthread_should_stop() || test_bit(W1_MASTER_NEED_EXIT, &dev->flags))
-			break;
-
-		if (!dev->initialized)
-			continue;
-
-		if (dev->search_count == 0)
-			continue;
-
-		mutex_lock(&dev->mutex);
-		w1_search_process(dev, W1_SEARCH);
-		mutex_unlock(&dev->mutex);
 	}
 
 	atomic_dec(&dev->refcnt);
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index ed32280..36ff402 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -61,6 +61,9 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	dev->slave_ttl		= slave_ttl;
         dev->search_count	= -1; /* continual scan */
 
+	/* 1 for w1_process to decrement
+	 * 1 for __w1_remove_master_device to decrement
+	 */
 	atomic_set(&dev->refcnt, 2);
 
 	INIT_LIST_HEAD(&dev->slist);
@@ -109,23 +112,23 @@ int w1_add_master_device(struct w1_bus_master *master)
 	if (!dev)
 		return -ENOMEM;
 
+	retval =  w1_create_master_attributes(dev);
+	if (retval)
+		goto err_out_free_dev;
+
+	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
+
+	dev->initialized = 1;
+
 	dev->thread = kthread_run(&w1_process, dev, "%s", dev->name);
 	if (IS_ERR(dev->thread)) {
 		retval = PTR_ERR(dev->thread);
 		dev_err(&dev->dev,
 			 "Failed to create new kernel thread. err=%d\n",
 			 retval);
-		goto err_out_free_dev;
+		goto err_out_rm_attr;
 	}
 
-	retval =  w1_create_master_attributes(dev);
-	if (retval)
-		goto err_out_kill_thread;
-
-	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
-
-	dev->initialized = 1;
-
 	mutex_lock(&w1_mlock);
 	list_add(&dev->w1_master_entry, &w1_masters);
 	mutex_unlock(&w1_mlock);
@@ -137,8 +140,13 @@ int w1_add_master_device(struct w1_bus_master *master)
 
 	return 0;
 
+#if 0 /* Thread cleanup code, not required currently. */
 err_out_kill_thread:
+	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
+#endif
+err_out_rm_attr:
+	w1_destroy_master_attributes(dev);
 err_out_free_dev:
 	w1_free_dev(dev);
 
-- 
1.4.4.4
