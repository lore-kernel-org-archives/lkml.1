Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYI2Fmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYI2Fmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 01:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYI2Fkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 01:40:43 -0400
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:41821
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbYI2Fkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 01:40:41 -0400
X-Authority-Analysis: v=1.0 c=1 a=_Yg9kB5gHV0A:10 a=9GjJjcx-SZcA:10
 a=NV3SuoleZSrqj-6SQUEA:9 a=0aJN58iPEVYugMcQS98A:7
 a=Dyhf9eTqFRBVdk9QPq2crisvJFwA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=si9q_4b84H0A:10 a=eZLSmJVMEtUA:10
Subject: [RFC PATCH 9/11] relay - Replace subbuf_start and notify_consumers
	callbacks with new_subbuf.
From: Tom Zanussi <zanussi@comcast.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 00:40:39 -0500
Message-Id: <1222666839.7637.182.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace subbuf_start and notify_consumers callbacks with new_subbuf.

The subbuf_start callback was too confusing and there's no reason to
have a separate callback to notify consumers; this patch combines them
both and simplifies the interface.  It's only called when there
actually has been a switch to a new sub-buffer and there's now no
return value saying whether the buffer is full or not - that's now
handled internally.  Keeping a count of dropped events is also now
done internally, so the user doesn't have to do that any more either.

Signed-off-by: Tom Zanussi <zanussi@comcast.net>

---
 block/blktrace.c             |   22 +-----------------
 include/linux/blktrace_api.h |    1 -
 include/linux/relay.h        |   51 ++++++++++++++++++++++++++++-------------
 kernel/relay.c               |   44 ++++++++++--------------------------
 virt/kvm/kvm_trace.c         |   43 ++++++++++++++--------------------
 5 files changed, 66 insertions(+), 95 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 271b7b7..c04168b 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -281,7 +281,7 @@ static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
 	struct blk_trace *bt = filp->private_data;
 	char buf[16];
 
-	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&bt->dropped));
+	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&bt->rchan->dropped));
 
 	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
 }
@@ -330,24 +330,6 @@ static const struct file_operations blk_msg_fops = {
 	.write =	blk_msg_write,
 };
 
-/*
- * Keep track of how many times we encountered a full subbuffer, to aid
- * the user space app in telling how many lost events there were.
- */
-static int blk_subbuf_start_callback(struct rchan_buf *buf,
-				     void *subbuf,
-				     int first_subbuf)
-{
-	struct blk_trace *bt;
-
-	if (!relay_buf_full(buf))
-		return 1;
-
-	bt = buf->chan->private_data;
-	atomic_inc(&bt->dropped);
-	return 0;
-}
-
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
 	debugfs_remove(dentry);
@@ -364,7 +346,6 @@ static struct dentry *blk_create_buf_file_callback(const char *filename,
 }
 
 static struct rchan_callbacks blk_relay_callbacks = {
-	.subbuf_start		= blk_subbuf_start_callback,
 	.create_buf_file	= blk_create_buf_file_callback,
 	.remove_buf_file	= blk_remove_buf_file_callback,
 };
@@ -412,7 +393,6 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 
 	bt->dir = dir;
 	bt->dev = dev;
-	atomic_set(&bt->dropped, 0);
 
 	ret = -EIO;
 	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt, &blk_dropped_fops);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index d084b8d..628cf3c 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -130,7 +130,6 @@ struct blk_trace {
 	struct dentry *dir;
 	struct dentry *dropped_file;
 	struct dentry *msg_file;
-	atomic_t dropped;
 };
 
 /*
diff --git a/include/linux/relay.h b/include/linux/relay.h
index 172c904..dd51caf 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -75,6 +75,7 @@ struct rchan
 	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
 	unsigned long flags;		/* relay flags for this channel */
+	atomic_t dropped;		/* dropped events due to buffer-full */
 };
 
 /*
@@ -83,20 +84,25 @@ struct rchan
 struct rchan_callbacks
 {
 	/*
-	 * subbuf_start - called on buffer-switch to a new sub-buffer
+	 * new_subbuf - called on buffer-switch to a new sub-buffer
 	 * @buf: the channel buffer containing the new sub-buffer
 	 * @subbuf: the start of the new sub-buffer
-	 * @first_subbuf: boolean, is this the first subbuf?
 	 *
-	 * The client should return 1 to continue logging, 0 to stop
-	 * logging.
+	 * This is simply a notification that a new sub-buffer has
+	 * been started.  The default version does nothing but call
+	 * relay_wakeup_readers().  Clients who override this callback
+	 * should also call relay_wakeup_readers() to get that default
+	 * behavior in addition to whatever they add.  Clients who
+	 * don't want to wake up readers should just not call it.
+	 * Clients can use the channel private_data to track previous
+	 * sub-buffers, determine whether this is the first
+	 * sub-buffer, etc.
 	 *
 	 * NOTE: the client can reserve bytes at the beginning of the new
 	 *       sub-buffer by calling subbuf_start_reserve() in this callback.
 	 */
-	int (*subbuf_start) (struct rchan_buf *buf,
-			     void *subbuf,
-			     int first_subbuf);
+	void (*new_subbuf) (struct rchan_buf *buf,
+			    void *subbuf);
 
 	/*
 	 * buf_mapped - relay buffer mmap notification
@@ -153,20 +159,15 @@ struct rchan_callbacks
 	int (*remove_buf_file)(struct dentry *dentry);
 
 	/*
-	 * notify_consumers - new sub-buffer available, let consumers know
-	 * @buf: the channel buffer
-	 *
-	 * Called during sub-buffer switch.  Applications which don't
-	 * want to notify anyone should implement an empty version.
-	 */
-        void (*notify_consumers)(struct rchan_buf *buf);
-
-	/*
 	 * switch_subbuf - sub-buffer switch callback
 	 * @buf: the channel buffer
 	 * @length: size of current event
 	 * @reserved: a pointer to the space reserved
 	 *
+	 * This callback can be used to replace the complete write
+	 * path.  Normally clients wouldn't override this and would
+	 * use the default version instead.
+	 *
 	 * Returns either the length passed in or 0 if full.
 	 *
 	 * Performs sub-buffer-switch tasks such as updating filesize,
@@ -203,6 +204,24 @@ extern size_t relay_switch_subbuf_default_callback(struct rchan_buf *buf,
 						   size_t length,
 						   void **reserved);
 
+/**
+ *	relay_wakeup_readers - wake up readers if applicable
+ *	@buf: relay channel buffer
+ *
+ *	Called by new_subbuf() default implementation, pulled out for
+ *	the conveiennce of user-defined new_subbuf() implementations.
+ */
+static inline void relay_wakeup_readers(struct rchan_buf *buf)
+{
+	if (waitqueue_active(&buf->read_wait))
+		/*
+		 * Calling wake_up_interruptible() from here
+		 * will deadlock if we happen to be logging
+		 * from the scheduler (trying to re-grab
+		 * rq->lock), so defer it.
+		 */
+		__mod_timer(&buf->timer, jiffies + 1);
+}
 
 /**
  *	relay_event_toobig - is event too big to fit in a sub-buffer?
diff --git a/kernel/relay.c b/kernel/relay.c
index 5392833..3d06970 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -273,19 +273,6 @@ EXPORT_SYMBOL_GPL(relay_buf_full);
  */
 
 /*
- * subbuf_start() default callback.  Does nothing.
- */
-static int subbuf_start_default_callback (struct rchan_buf *buf,
-					  void *subbuf,
-					  int first_subbuf)
-{
-	if (relay_buf_full(buf))
-		return 0;
-
-	return 1;
-}
-
-/*
  * buf_mapped() default callback.  Does nothing.
  */
 static void buf_mapped_default_callback(struct rchan_buf *buf,
@@ -321,28 +308,21 @@ static int remove_buf_file_default_callback(struct dentry *dentry)
 }
 
 /*
- * notify_consumers() default callback.
+ * new_subbuf() default callback.
  */
-static void notify_consumers_default_callback(struct rchan_buf *buf)
+static void new_subbuf_default_callback(struct rchan_buf *buf,
+					void *subbuf)
 {
-	if (waitqueue_active(&buf->read_wait))
-		/*
-		 * Calling wake_up_interruptible() from here
-		 * will deadlock if we happen to be logging
-		 * from the scheduler (trying to re-grab
-		 * rq->lock), so defer it.
-		 */
-		__mod_timer(&buf->timer, jiffies + 1);
+	relay_wakeup_readers(buf);
 }
 
 /* relay channel default callbacks */
 static struct rchan_callbacks default_channel_callbacks = {
-	.subbuf_start = subbuf_start_default_callback,
+	.new_subbuf = new_subbuf_default_callback,
 	.buf_mapped = buf_mapped_default_callback,
 	.buf_unmapped = buf_unmapped_default_callback,
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
-	.notify_consumers = notify_consumers_default_callback,
 	.switch_subbuf = relay_switch_subbuf_default_callback,
 };
 
@@ -381,7 +361,7 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 	buf->data = buf->start;
 	buf->offset = 0;
 
-	buf->chan->cb->subbuf_start(buf, buf->data, 1);
+	buf->chan->cb->new_subbuf(buf, buf->data);
 }
 
 /**
@@ -505,8 +485,6 @@ static void setup_callbacks(struct rchan *chan,
 		return;
 	}
 
-	if (!cb->subbuf_start)
-		cb->subbuf_start = subbuf_start_default_callback;
 	if (!cb->buf_mapped)
 		cb->buf_mapped = buf_mapped_default_callback;
 	if (!cb->buf_unmapped)
@@ -515,8 +493,8 @@ static void setup_callbacks(struct rchan *chan,
 		cb->create_buf_file = create_buf_file_default_callback;
 	if (!cb->remove_buf_file)
 		cb->remove_buf_file = remove_buf_file_default_callback;
-	if (!cb->notify_consumers)
-		cb->notify_consumers = notify_consumers_default_callback;
+	if (!cb->new_subbuf)
+		cb->new_subbuf = new_subbuf_default_callback;
 	if (!cb->switch_subbuf)
 		cb->switch_subbuf = relay_switch_subbuf_default_callback;
 	chan->cb = cb;
@@ -604,6 +582,8 @@ struct rchan *relay_open(const char *base_filename,
 	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
 	chan->parent = parent;
 	chan->flags = rchan_flags;
+	atomic_set(&chan->dropped, 0);
+
 	chan->private_data = private_data;
 	if (base_filename) {
 		chan->has_base_filename = 1;
@@ -761,20 +741,20 @@ size_t relay_switch_subbuf_default_callback(struct rchan_buf *buf,
 	if (!next_subbuf_free(buf)) {
 		if (reserved)
 			*reserved = NULL;
+		atomic_inc(&buf->chan->dropped);
 		return 0;
 	}
 
 	remainder = length - (buf->chan->subbuf_size - buf->offset);
 	relay_inc_produced(buf);
 	relay_update_filesize(buf, buf->chan->subbuf_size + remainder);
-	buf->chan->cb->notify_consumers(buf);
 
 	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 	new_data = buf->start + new_subbuf * buf->chan->subbuf_size;
 
 	buf->data = new_data;
 	buf->offset = 0; /* remainder will be added by caller */
-	buf->chan->cb->subbuf_start(buf, new_data, 0);
+	buf->chan->cb->new_subbuf(buf, new_data);
 
 	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
 		goto toobig;
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 4626caa..293a3c2 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -28,7 +28,7 @@ struct kvm_trace {
 	int trace_state;
 	struct rchan *rchan;
 	struct dentry *lost_file;
-	atomic_t lost_records;
+	int first_subbuf;
 };
 static struct kvm_trace *kvm_trace;
 
@@ -94,7 +94,7 @@ static int lost_records_get(void *data, u64 *val)
 {
 	struct kvm_trace *kt = data;
 
-	*val = atomic_read(&kt->lost_records);
+	*val = atomic_read(&kt->rchan->dropped);
 	return 0;
 }
 
@@ -105,29 +105,22 @@ DEFINE_SIMPLE_ATTRIBUTE(kvm_trace_lost_ops, lost_records_get, NULL, "%llu\n");
  *  many times we encountered a full subbuffer, to tell user space app the
  *  lost records there were.
  */
-static int kvm_subbuf_start_callback(struct rchan_buf *buf,
-				     void *subbuf,
-				     int first_subbuf)
+static void kvm_new_subbuf_callback(struct rchan_buf *buf,
+				    void *subbuf)
 {
-	struct kvm_trace *kt;
-
-	if (!relay_buf_full(buf)) {
-		if (first_subbuf) {
-			/*
-			 * executed only once when the channel is opened
-			 * save metadata as first record
-			 */
-			subbuf_start_reserve(buf, sizeof(u32));
-			*(u32 *)subbuf = 0x12345678;
-		}
-
-		return 1;
+	struct kvm_trace *kt = buf->chan->private_data;
+
+	relay_wakeup_readers(buf);
+
+	if (kt->first_subbuf) {
+		/*
+		 * executed only once when the channel is opened
+		 * save metadata as first record
+		 */
+		subbuf_start_reserve(buf, sizeof(u32));
+		*(u32 *)subbuf = 0x12345678;
+		kt->first_subbuf = 0;
 	}
-
-	kt = buf->chan->private_data;
-	atomic_inc(&kt->lost_records);
-
-	return 0;
 }
 
 static struct dentry *kvm_create_buf_file_callack(const char *filename,
@@ -146,7 +139,7 @@ static int kvm_remove_buf_file_callback(struct dentry *dentry)
 }
 
 static struct rchan_callbacks kvm_relay_callbacks = {
-	.subbuf_start 		= kvm_subbuf_start_callback,
+	.new_subbuf		= kvm_new_subbuf_callback,
 	.create_buf_file 	= kvm_create_buf_file_callack,
 	.remove_buf_file 	= kvm_remove_buf_file_callback,
 };
@@ -164,7 +157,7 @@ static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
 		goto err;
 
 	r = -EIO;
-	atomic_set(&kt->lost_records, 0);
+	kt->first_subbuf = 1;
 	kt->lost_file = debugfs_create_file("lost_records", 0444, kvm_debugfs_dir,
 					    kt, &kvm_trace_lost_ops);
 	if (!kt->lost_file)
-- 
1.5.3.5



