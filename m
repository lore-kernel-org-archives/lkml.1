Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbZEHSS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbZEHSS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZEHSR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:17:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZEHSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:17:56 -0400
Message-Id: <20090508170028.837558214@chello.nl>
References: <20090508165219.469818319@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:52:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] perf_counter: rework ioctl()s
Content-Disposition: inline; filename=perf_counter-family.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey noticed that ioctl()s on grouped counters didn't work on the whole group.
This extends the ioctl() interface to take a second argument that is
interpreted as a flags field. We then provide PERF_IOC_FLAG_GROUP to toggle
the behaviour.

Having this flag gives the greatest flexibility, allowing you to individually
enable/disable/reset counters in a group, or all together.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   10 ++--
 kernel/perf_counter.c        |  104 +++++++++++++++++++++++--------------------
 2 files changed, 65 insertions(+), 49 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -82,7 +82,7 @@ list_add_counter(struct perf_counter *co
 	 * add it straight to the context's counter list, or to the group
 	 * leader's sibling list:
 	 */
-	if (counter->group_leader == counter)
+	if (group_leader == counter)
 		list_add_tail(&counter->list_entry, &ctx->counter_list);
 	else {
 		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
@@ -385,24 +385,6 @@ static void perf_counter_disable(struct 
 	spin_unlock_irq(&ctx->lock);
 }
 
-/*
- * Disable a counter and all its children.
- */
-static void perf_counter_disable_family(struct perf_counter *counter)
-{
-	struct perf_counter *child;
-
-	perf_counter_disable(counter);
-
-	/*
-	 * Lock the mutex to protect the list of children
-	 */
-	mutex_lock(&counter->mutex);
-	list_for_each_entry(child, &counter->child_list, child_list)
-		perf_counter_disable(child);
-	mutex_unlock(&counter->mutex);
-}
-
 static int
 counter_sched_in(struct perf_counter *counter,
 		 struct perf_cpu_context *cpuctx,
@@ -753,24 +735,6 @@ static int perf_counter_refresh(struct p
 	return 0;
 }
 
-/*
- * Enable a counter and all its children.
- */
-static void perf_counter_enable_family(struct perf_counter *counter)
-{
-	struct perf_counter *child;
-
-	perf_counter_enable(counter);
-
-	/*
-	 * Lock the mutex to protect the list of children
-	 */
-	mutex_lock(&counter->mutex);
-	list_for_each_entry(child, &counter->child_list, child_list)
-		perf_counter_enable(child);
-	mutex_unlock(&counter->mutex);
-}
-
 void __perf_counter_sched_out(struct perf_counter_context *ctx,
 			      struct perf_cpu_context *cpuctx)
 {
@@ -1307,31 +1271,79 @@ static unsigned int perf_poll(struct fil
 
 static void perf_counter_reset(struct perf_counter *counter)
 {
+	(void)perf_counter_read(counter);
 	atomic_set(&counter->count, 0);
+	perf_counter_update_userpage(counter);
+}
+
+static void perf_counter_for_each_sibling(struct perf_counter *counter,
+					  void (*func)(struct perf_counter *))
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *sibling;
+
+	spin_lock_irq(&ctx->lock);
+	counter = counter->group_leader;
+
+	func(counter);
+	list_for_each_entry(sibling, &counter->sibling_list, list_entry)
+		func(sibling);
+	spin_unlock_irq(&ctx->lock);
+}
+
+static void perf_counter_for_each_child(struct perf_counter *counter,
+					void (*func)(struct perf_counter *))
+{
+	struct perf_counter *child;
+
+	mutex_lock(&counter->mutex);
+	func(counter);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		func(child);
+	mutex_unlock(&counter->mutex);
+}
+
+static void perf_counter_for_each(struct perf_counter *counter,
+				  void (*func)(struct perf_counter *))
+{
+	struct perf_counter *child;
+
+	mutex_lock(&counter->mutex);
+	perf_counter_for_each_sibling(counter, func);
+	list_for_each_entry(child, &counter->child_list, child_list)
+		perf_counter_for_each_sibling(child, func);
+	mutex_unlock(&counter->mutex);
 }
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_counter *counter = file->private_data;
-	int err = 0;
+	void (*func)(struct perf_counter *);
+	u32 flags = arg;
 
 	switch (cmd) {
 	case PERF_COUNTER_IOC_ENABLE:
-		perf_counter_enable_family(counter);
+		func = perf_counter_enable;
 		break;
 	case PERF_COUNTER_IOC_DISABLE:
-		perf_counter_disable_family(counter);
-		break;
-	case PERF_COUNTER_IOC_REFRESH:
-		err = perf_counter_refresh(counter, arg);
+		func = perf_counter_disable;
 		break;
 	case PERF_COUNTER_IOC_RESET:
-		perf_counter_reset(counter);
+		func = perf_counter_reset;
 		break;
+
+	case PERF_COUNTER_IOC_REFRESH:
+		return perf_counter_refresh(counter, arg);
 	default:
-		err = -ENOTTY;
+		return -ENOTTY;
 	}
-	return err;
+
+	if (flags & PERF_IOC_FLAG_GROUP)
+		perf_counter_for_each(counter, func);
+	else
+		perf_counter_for_each_child(counter, func);
+
+	return 0;
 }
 
 /*
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -157,10 +157,14 @@ struct perf_counter_hw_event {
 /*
  * Ioctls that can be done on a perf counter fd:
  */
-#define PERF_COUNTER_IOC_ENABLE		_IO ('$', 0)
-#define PERF_COUNTER_IOC_DISABLE	_IO ('$', 1)
+#define PERF_COUNTER_IOC_ENABLE		_IOW('$', 0, u32)
+#define PERF_COUNTER_IOC_DISABLE	_IOW('$', 1, u32)
 #define PERF_COUNTER_IOC_REFRESH	_IOW('$', 2, u32)
-#define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
+#define PERF_COUNTER_IOC_RESET		_IOW('$', 3, u32)
+
+enum perf_counter_ioc_flags {
+	PERF_IOC_FLAG_GROUP		= 1U << 0,
+};
 
 /*
  * Structure of the page that can be mapped via mmap

-- 

