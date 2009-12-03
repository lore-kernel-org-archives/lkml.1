Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZLCXkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZLCXkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZLCXgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:36:39 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36114 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZLCXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:36:20 -0500
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 20/24] ceph: message pools
Date: Thu,  3 Dec 2009 15:41:27 -0800
Message-Id: <1259883691-1042-21-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259883691-1042-20-git-send-email-sage@newdream.net>
References: <1259883691-1042-1-git-send-email-sage@newdream.net>
 <1259883691-1042-2-git-send-email-sage@newdream.net>
 <1259883691-1042-3-git-send-email-sage@newdream.net>
 <1259883691-1042-4-git-send-email-sage@newdream.net>
 <1259883691-1042-5-git-send-email-sage@newdream.net>
 <1259883691-1042-6-git-send-email-sage@newdream.net>
 <1259883691-1042-7-git-send-email-sage@newdream.net>
 <1259883691-1042-8-git-send-email-sage@newdream.net>
 <1259883691-1042-9-git-send-email-sage@newdream.net>
 <1259883691-1042-10-git-send-email-sage@newdream.net>
 <1259883691-1042-11-git-send-email-sage@newdream.net>
 <1259883691-1042-12-git-send-email-sage@newdream.net>
 <1259883691-1042-13-git-send-email-sage@newdream.net>
 <1259883691-1042-14-git-send-email-sage@newdream.net>
 <1259883691-1042-15-git-send-email-sage@newdream.net>
 <1259883691-1042-16-git-send-email-sage@newdream.net>
 <1259883691-1042-17-git-send-email-sage@newdream.net>
 <1259883691-1042-18-git-send-email-sage@newdream.net>
 <1259883691-1042-19-git-send-email-sage@newdream.net>
 <1259883691-1042-20-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The msgpool is a basic mempool_t-like structure to preallocate
messages we expect to receive over the wire.  This ensures we have the
necessary memory preallocated to process replies to requests, or to
process unsolicited messages from various servers.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/msgpool.c |  181 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/msgpool.h |   27 ++++++++
 2 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/msgpool.c
 create mode 100644 fs/ceph/msgpool.h

diff --git a/fs/ceph/msgpool.c b/fs/ceph/msgpool.c
new file mode 100644
index 0000000..7599b33
--- /dev/null
+++ b/fs/ceph/msgpool.c
@@ -0,0 +1,181 @@
+#include "ceph_debug.h"
+
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include "msgpool.h"
+
+/*
+ * We use msg pools to preallocate memory for messages we expect to
+ * receive over the wire, to avoid getting ourselves into OOM
+ * conditions at unexpected times.  We take use a few different
+ * strategies:
+ *
+ *  - for request/response type interactions, we preallocate the
+ * memory needed for the response when we generate the request.
+ *
+ *  - for messages we can receive at any time from the MDS, we preallocate
+ * a pool of messages we can re-use.
+ *
+ *  - for writeback, we preallocate some number of messages to use for
+ * requests and their replies, so that we always make forward
+ * progress.
+ *
+ * The msgpool behaves like a mempool_t, but keeps preallocated
+ * ceph_msgs strung together on a list_head instead of using a pointer
+ * vector.  This avoids vector reallocation when we adjust the number
+ * of preallocated items (which happens frequently).
+ */
+
+
+/*
+ * Allocate or release as necessary to meet our target pool size.
+ */
+static int __fill_msgpool(struct ceph_msgpool *pool)
+{
+	struct ceph_msg *msg;
+
+	while (pool->num < pool->min) {
+		dout("fill_msgpool %p %d/%d allocating\n", pool, pool->num,
+		     pool->min);
+		spin_unlock(&pool->lock);
+		msg = ceph_msg_new(0, pool->front_len, 0, 0, NULL);
+		spin_lock(&pool->lock);
+		if (IS_ERR(msg))
+			return PTR_ERR(msg);
+		msg->pool = pool;
+		list_add(&msg->list_head, &pool->msgs);
+		pool->num++;
+	}
+	while (pool->num > pool->min) {
+		msg = list_first_entry(&pool->msgs, struct ceph_msg, list_head);
+		dout("fill_msgpool %p %d/%d releasing %p\n", pool, pool->num,
+		     pool->min, msg);
+		list_del_init(&msg->list_head);
+		pool->num--;
+		ceph_msg_kfree(msg);
+	}
+	return 0;
+}
+
+int ceph_msgpool_init(struct ceph_msgpool *pool,
+		      int front_len, int min, bool blocking)
+{
+	int ret;
+
+	dout("msgpool_init %p front_len %d min %d\n", pool, front_len, min);
+	spin_lock_init(&pool->lock);
+	pool->front_len = front_len;
+	INIT_LIST_HEAD(&pool->msgs);
+	pool->num = 0;
+	pool->min = min;
+	pool->blocking = blocking;
+	init_waitqueue_head(&pool->wait);
+
+	spin_lock(&pool->lock);
+	ret = __fill_msgpool(pool);
+	spin_unlock(&pool->lock);
+	return ret;
+}
+
+void ceph_msgpool_destroy(struct ceph_msgpool *pool)
+{
+	dout("msgpool_destroy %p\n", pool);
+	spin_lock(&pool->lock);
+	pool->min = 0;
+	__fill_msgpool(pool);
+	spin_unlock(&pool->lock);
+}
+
+int ceph_msgpool_resv(struct ceph_msgpool *pool, int delta)
+{
+	int ret;
+
+	spin_lock(&pool->lock);
+	dout("msgpool_resv %p delta %d\n", pool, delta);
+	pool->min += delta;
+	ret = __fill_msgpool(pool);
+	spin_unlock(&pool->lock);
+	return ret;
+}
+
+struct ceph_msg *ceph_msgpool_get(struct ceph_msgpool *pool, int front_len)
+{
+	wait_queue_t wait;
+	struct ceph_msg *msg;
+
+	if (front_len && front_len > pool->front_len) {
+		pr_err("msgpool_get pool %p need front %d, pool size is %d\n",
+		       pool, front_len, pool->front_len);
+		WARN_ON(1);
+
+		/* try to alloc a fresh message */
+		msg = ceph_msg_new(0, front_len, 0, 0, NULL);
+		if (!IS_ERR(msg))
+			return msg;
+	}
+
+	if (!front_len)
+		front_len = pool->front_len;
+
+	if (pool->blocking) {
+		/* mempool_t behavior; first try to alloc */
+		msg = ceph_msg_new(0, front_len, 0, 0, NULL);
+		if (!IS_ERR(msg))
+			return msg;
+	}
+
+	while (1) {
+		spin_lock(&pool->lock);
+		if (likely(pool->num)) {
+			msg = list_entry(pool->msgs.next, struct ceph_msg,
+					 list_head);
+			list_del_init(&msg->list_head);
+			pool->num--;
+			dout("msgpool_get %p got %p, now %d/%d\n", pool, msg,
+			     pool->num, pool->min);
+			spin_unlock(&pool->lock);
+			return msg;
+		}
+		pr_err("msgpool_get %p now %d/%d, %s\n", pool, pool->num,
+		       pool->min, pool->blocking ? "waiting" : "failing");
+		spin_unlock(&pool->lock);
+
+		if (!pool->blocking) {
+			WARN_ON(1);
+
+			/* maybe we can allocate it now? */
+			msg = ceph_msg_new(0, front_len, 0, 0, NULL);
+			if (!IS_ERR(msg))
+				return msg;
+
+			return ERR_PTR(-ENOMEM);
+		}
+
+		init_wait(&wait);
+		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+		schedule();
+		finish_wait(&pool->wait, &wait);
+	}
+}
+
+void ceph_msgpool_put(struct ceph_msgpool *pool, struct ceph_msg *msg)
+{
+	spin_lock(&pool->lock);
+	if (pool->num < pool->min) {
+		ceph_msg_get(msg);   /* retake a single ref */
+		list_add(&msg->list_head, &pool->msgs);
+		pool->num++;
+		dout("msgpool_put %p reclaim %p, now %d/%d\n", pool, msg,
+		     pool->num, pool->min);
+		spin_unlock(&pool->lock);
+		wake_up(&pool->wait);
+	} else {
+		dout("msgpool_put %p drop %p, at %d/%d\n", pool, msg,
+		     pool->num, pool->min);
+		spin_unlock(&pool->lock);
+		ceph_msg_kfree(msg);
+	}
+}
diff --git a/fs/ceph/msgpool.h b/fs/ceph/msgpool.h
new file mode 100644
index 0000000..bc834bf
--- /dev/null
+++ b/fs/ceph/msgpool.h
@@ -0,0 +1,27 @@
+#ifndef _FS_CEPH_MSGPOOL
+#define _FS_CEPH_MSGPOOL
+
+#include "messenger.h"
+
+/*
+ * we use memory pools for preallocating messages we may receive, to
+ * avoid unexpected OOM conditions.
+ */
+struct ceph_msgpool {
+	spinlock_t lock;
+	int front_len;          /* preallocated payload size */
+	struct list_head msgs;  /* msgs in the pool; each has 1 ref */
+	int num, min;           /* cur, min # msgs in the pool */
+	bool blocking;
+	wait_queue_head_t wait;
+};
+
+extern int ceph_msgpool_init(struct ceph_msgpool *pool,
+			     int front_len, int size, bool blocking);
+extern void ceph_msgpool_destroy(struct ceph_msgpool *pool);
+extern int ceph_msgpool_resv(struct ceph_msgpool *, int delta);
+extern struct ceph_msg *ceph_msgpool_get(struct ceph_msgpool *,
+					 int front_len);
+extern void ceph_msgpool_put(struct ceph_msgpool *, struct ceph_msg *);
+
+#endif
-- 
1.6.5

