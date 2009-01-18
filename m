Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbZARIGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbZARIGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 03:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761694AbZARIGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 03:06:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52626 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761626AbZARIGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 03:06:36 -0500
Message-ID: <4972E30A.6080107@cn.fujitsu.com>
Date: Sun, 18 Jan 2009 16:06:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, miaox@cn.fujitsu.com, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cgroup: introduce cgroup_queue_deferred_work()
References: <496FEFCA.9050908@cn.fujitsu.com>	<4970000E.7040902@cn.fujitsu.com> <20090116125738.22c21bf2.akpm@linux-foundation.org>
In-Reply-To: <20090116125738.22c21bf2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we need require a lock to prevent something,
but this lock cannot nest in cgroup_lock. So this work
should be moved out of cgroup_lock's critical region.

Using schedule_work() can move this work out of cgroup_lock's
critical region. But it's a overkill for move a work to
other process. And if we need flush_work() with cgroup_lock
held, schedule_work() can not work for flush_work() will
cause deadlock.

Another solution is that deferring the work, and processing
it after cgroup_lock released. This patch introduces
cgroup_queue_deferred_work() for queue a cgroup_deferred_work.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e267e62..6d3e6dc 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -437,6 +437,19 @@ void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
+struct cgroup_deferred_work {
+	struct list_head list;
+	void (*func)(struct cgroup_deferred_work *);
+};
+
+#define CGROUP_DEFERRED_WORK(name, function)		\
+	struct cgroup_deferred_work name = {		\
+		.list = LIST_HEAD_INIT((name).list),	\
+		.func = (function),			\
+	};
+
+int cgroup_queue_deferred_work(struct cgroup_deferred_work *deferred_work);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c298310..75a352b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -540,6 +540,7 @@ void cgroup_lock(void)
 	mutex_lock(&cgroup_mutex);
 }
 
+static void cgroup_flush_deferred_work_locked(void);
 /**
  * cgroup_unlock - release lock on cgroup changes
  *
@@ -547,9 +548,80 @@ void cgroup_lock(void)
  */
 void cgroup_unlock(void)
 {
+	cgroup_flush_deferred_work_locked();
 	mutex_unlock(&cgroup_mutex);
 }
 
+/* deferred_work_list is protected by cgroup_mutex */
+static LIST_HEAD(deferred_work_list);
+
+/* flush deferred works with cgroup_lock released */
+static void cgroup_flush_deferred_work_locked(void)
+{
+	static bool running_deferred_work;
+
+	if (likely(list_empty(&deferred_work_list)))
+		return;
+
+	/*
+	 * Ensure it's not recursive and also
+	 * ensure deferred works are run orderly.
+	 */
+	if (running_deferred_work)
+		return;
+	running_deferred_work = true;
+
+	for ( ; ; ) {
+		struct cgroup_deferred_work *deferred_work;
+
+		/* dequeue the first work, and mark it dequeued */
+		deferred_work = list_first_entry(&deferred_work_list,
+				struct cgroup_deferred_work, list);
+		list_del_init(&deferred_work->list);
+
+		mutex_unlock(&cgroup_mutex);
+
+		/*
+		 * cgroup_mutex is released. The callback function can use
+		 * cgroup_lock()/cgroup_unlock(). This behavior is safe
+		 * for running_deferred_work is set to 'true'.
+		 */
+		deferred_work->func(deferred_work);
+
+		/*
+		 * regain cgroup_mutex to access deferred_work_list
+		 * and running_deferred_work.
+		 */
+		mutex_lock(&cgroup_mutex);
+
+		if (list_empty(&deferred_work_list))
+			break;
+	}
+
+	running_deferred_work = false;
+}
+
+/**
+ * cgroup_queue_deferred_work - queue a deferred work
+ * @deferred_work: work to queue.
+ *
+ * Returns 0 if @deferred_work was already on the queue, non-zero otherwise.
+ *
+ * Must be called when cgroup_lock held.
+ * The deferred work will be run after cgroup_lock released.
+ */
+int cgroup_queue_deferred_work(struct cgroup_deferred_work *deferred_work)
+{
+	int ret = 0;
+
+	if (list_empty(&deferred_work->list)) {
+		list_add_tail(&deferred_work->list, &deferred_work_list);
+		ret = 1;
+	}
+
+	return ret;
+}
+
 /*
  * A couple of forward declarations required, due to cyclic reference loop:
  * cgroup_mkdir -> cgroup_create -> cgroup_populate_dir ->




