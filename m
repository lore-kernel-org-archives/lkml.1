Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbZE2NQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbZE2NQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759815AbZE2NQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:16:30 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64016 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012AbZE2NQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:16:28 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-fsdevel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 29 May 2009 18:09:44 +0300
Message-Id: <20090529150944.8912.95076.sendpatchset@localhost.localdomain>
In-Reply-To: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>
References: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/2] UBIFS: start using hrtimers
X-OriginalArrivalTime: 29 May 2009 13:15:54.0268 (UTC) FILETIME=[988D45C0:01C9E05F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH 2/2] UBIFS: start using hrtimers

UBIFS uses timers for write-buffer write-back. It is not
crucial for us to write-back exactly on time. We are fine
to write-back a little earlier or later. And this means
we may optimize UBIFS timer so that it could be groped
with a close timer event, so that the CPU would not be
waken up just to do the write back. This is optimization
to lessen power consumption, which is important in
embedded devices UBIFS is used for.

hrtimers have a nice feature: they are effectively range
timers, and we may defind the soft and hard limits for
it. Standard timers do not have these feature. They may
only be made deferrable, but this means there is effectively
no hard limit. So, we will better use hrtimers.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/io.c    |   34 +++++++++++++++++++++-------------
 fs/ubifs/super.c |    6 +++---
 fs/ubifs/ubifs.h |   13 ++++++++-----
 3 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index e8e632a..bc58571 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -293,13 +293,14 @@ void ubifs_prep_grp_node(struct ubifs_info *c, void *node, int len, int last)
  *
  * This function is called when the write-buffer timer expires.
  */
-static void wbuf_timer_callback_nolock(unsigned long data)
+static enum hrtimer_restart wbuf_timer_callback_nolock(struct hrtimer *timer)
 {
-	struct ubifs_wbuf *wbuf = (struct ubifs_wbuf *)data;
+	struct ubifs_wbuf *wbuf = container_of(timer, struct ubifs_wbuf, timer);
 
 	wbuf->need_sync = 1;
 	wbuf->c->need_wbuf_sync = 1;
 	ubifs_wake_up_bgt(wbuf->c);
+	return HRTIMER_NORESTART;
 }
 
 /**
@@ -308,13 +309,12 @@ static void wbuf_timer_callback_nolock(unsigned long data)
  */
 static void new_wbuf_timer_nolock(struct ubifs_wbuf *wbuf)
 {
-	ubifs_assert(!timer_pending(&wbuf->timer));
+	ubifs_assert(!hrtimer_active(&wbuf->timer));
 
-	if (!wbuf->timeout)
+	if (!ktime_to_ns(wbuf->softlimit))
 		return;
-
-	wbuf->timer.expires = jiffies + wbuf->timeout;
-	add_timer(&wbuf->timer);
+	hrtimer_start_range_ns(&wbuf->timer, wbuf->softlimit, wbuf->delta,
+			       HRTIMER_MODE_REL);
 }
 
 /**
@@ -329,7 +329,7 @@ static void cancel_wbuf_timer_nolock(struct ubifs_wbuf *wbuf)
 	 * should be canceled.
 	 */
 	wbuf->need_sync = 0;
-	del_timer(&wbuf->timer);
+	hrtimer_cancel(&wbuf->timer);
 }
 
 /**
@@ -825,6 +825,7 @@ out:
 int ubifs_wbuf_init(struct ubifs_info *c, struct ubifs_wbuf *wbuf)
 {
 	size_t size;
+	ktime_t hardlimit;
 
 	wbuf->buf = kmalloc(c->min_io_size, GFP_KERNEL);
 	if (!wbuf->buf)
@@ -845,14 +846,21 @@ int ubifs_wbuf_init(struct ubifs_info *c, struct ubifs_wbuf *wbuf)
 	wbuf->sync_callback = NULL;
 	mutex_init(&wbuf->io_mutex);
 	spin_lock_init(&wbuf->lock);
-
 	wbuf->c = c;
-	init_timer(&wbuf->timer);
-	wbuf->timer.function = wbuf_timer_callback_nolock;
-	wbuf->timer.data = (unsigned long)wbuf;
-	wbuf->timeout = DEFAULT_WBUF_TIMEOUT;
 	wbuf->next_ino = 0;
 
+	hrtimer_init(&wbuf->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	wbuf->timer.function = wbuf_timer_callback_nolock;
+	/*
+	 * Make write-buffer soft limit to be 20% of the hard limit. The
+	 * write-buffer timer is allowed to expire any time between the soft
+	 * and hard limits.
+	 */
+	hardlimit = ktime_set(DEFAULT_WBUF_TIMEOUT_SECS, 0);
+	wbuf->delta = (DEFAULT_WBUF_TIMEOUT_SECS * NSEC_PER_SEC) * 2 / 10;
+	wbuf->softlimit = ktime_sub_ns(hardlimit, wbuf->delta);
+	hrtimer_set_expires_range_ns(&wbuf->timer,  wbuf->softlimit,
+				     wbuf->delta);
 	return 0;
 }
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 2ba4e83..3513cad 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -799,7 +799,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 	 * does not need to be synchronized by timer.
 	 */
 	c->jheads[GCHD].wbuf.dtype = UBI_LONGTERM;
-	c->jheads[GCHD].wbuf.timeout = 0;
+	c->jheads[GCHD].wbuf.softlimit = ktime_set(0, 0);
 
 	return 0;
 }
@@ -1695,7 +1695,7 @@ static void ubifs_remount_ro(struct ubifs_info *c)
 
 	for (i = 0; i < c->jhead_cnt; i++) {
 		ubifs_wbuf_sync(&c->jheads[i].wbuf);
-		del_timer_sync(&c->jheads[i].wbuf.timer);
+		hrtimer_cancel(&c->jheads[i].wbuf.timer);
 	}
 
 	c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_DIRTY);
@@ -1755,7 +1755,7 @@ static void ubifs_put_super(struct super_block *sb)
 		if (c->jheads)
 			for (i = 0; i < c->jhead_cnt; i++) {
 				ubifs_wbuf_sync(&c->jheads[i].wbuf);
-				del_timer_sync(&c->jheads[i].wbuf.timer);
+				hrtimer_cancel(&c->jheads[i].wbuf.timer);
 			}
 
 		/*
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 0a8341e..1bf01d8 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -95,8 +95,8 @@
  */
 #define BGT_NAME_PATTERN "ubifs_bgt%d_%d"
 
-/* Default write-buffer synchronization timeout (5 secs) */
-#define DEFAULT_WBUF_TIMEOUT (5 * HZ)
+/* Default write-buffer synchronization timeout in seconds */
+#define DEFAULT_WBUF_TIMEOUT_SECS 5
 
 /* Maximum possible inode number (only 32-bit inodes are supported now) */
 #define MAX_INUM 0xFFFFFFFF
@@ -650,8 +650,10 @@ typedef int (*ubifs_lpt_scan_callback)(struct ubifs_info *c,
  * @io_mutex: serializes write-buffer I/O
  * @lock: serializes @buf, @lnum, @offs, @avail, @used, @next_ino and @inodes
  *        fields
+ * @softlimit: soft write-buffer timeout interval
+ * @delta: hard and soft timeouts delta (the timer expire inteval is @softlimit
+ *         and @softlimit + @delta)
  * @timer: write-buffer timer
- * @timeout: timer expire interval in jiffies
  * @need_sync: it is set if its timer expired and needs sync
  * @next_ino: points to the next position of the following inode number
  * @inodes: stores the inode numbers of the nodes which are in wbuf
@@ -678,8 +680,9 @@ struct ubifs_wbuf {
 	int (*sync_callback)(struct ubifs_info *c, int lnum, int free, int pad);
 	struct mutex io_mutex;
 	spinlock_t lock;
-	struct timer_list timer;
-	int timeout;
+	ktime_t softlimit;
+	unsigned long long delta;
+	struct hrtimer timer;
 	int need_sync;
 	int next_ino;
 	ino_t *inodes;
-- 
1.6.0.6

