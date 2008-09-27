Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYI0GR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYI0GR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 02:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYI0GRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 02:17:46 -0400
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:49442
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbYI0GRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 02:17:44 -0400
X-Authority-Analysis: v=1.0 c=1 a=rOYW_XQown0A:10 a=VUHG25hbLOcA:10
 a=rWksiQT5POXiWDQ99I4A:9 a=tItLvzN1Sn8TOh1a5NAA:7
 a=OR6H6BSU_OAIvqHTfaXjYVQS1vcA:4 a=955elKCOoL8A:10
Subject: [RFC PATCH 1/10] relay - Clean up relay_switch_subbuf() and make
	waking up consumers optional.
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
Date: Sat, 27 Sep 2008 01:17:53 -0500
Message-Id: <1222496273.6710.72.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up relay_switch_subbuf() and make waking up consumers optional.

Over time, relay_switch_subbuf() has accumulated some cruft - this
patch cleans it up and at the same time makes available some of it
available as common functions that any subbuf-switch implementor would
need (this is partially in preparation for the next patch, which makes
the subbuf-switch function completely replaceable).  It also removes
the hard-coded reader wakeup and moves it into a replaceable callback
called notify_consumers(); this allows any given tracer to implement
consumer notification as it sees fit.
---
 include/linux/relay.h |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/relay.c        |   43 +++++++++++++++++++++++------------------
 2 files changed, 75 insertions(+), 19 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 953fc05..17f0515 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -159,6 +159,15 @@ struct rchan_callbacks
 	 * The callback should return 0 if successful, negative if not.
 	 */
 	int (*remove_buf_file)(struct dentry *dentry);
+
+	/*
+	 * notify_consumers - new sub-buffer available, let consumers know
+	 * @buf: the channel buffer
+	 *
+	 * Called during sub-buffer switch.  Applications which don't
+	 * want to notify anyone should implement an empty version.
+	 */
+        void (*notify_consumers)(struct rchan_buf *buf);
 };
 
 /*
@@ -186,6 +195,48 @@ extern size_t relay_switch_subbuf(struct rchan_buf *buf,
 				  size_t length);
 
 /**
+ *	relay_event_toobig - is event too big to fit in a sub-buffer?
+ *	@buf: relay channel buffer
+ *	@length: length of event
+ *
+ *	Returns 1 if too big, 0 otherwise.
+ *
+ *	switch_subbuf() helper function.
+ */
+static inline int relay_event_toobig(struct rchan_buf *buf, size_t length)
+{
+	return length > buf->chan->subbuf_size;
+}
+
+/**
+ *	relay_update_filesize - increase relay file i_size by length
+ *	@buf: relay channel buffer
+ *	@length: length to add
+ *
+ *	switch_subbuf() helper function.
+ */
+static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
+{
+	if (buf->dentry)
+		buf->dentry->d_inode->i_size +=	length;
+	else
+		buf->early_bytes += length;
+
+	smp_mb();
+}
+
+/**
+ *	relay_inc_produced - increase number of sub-buffers produced by 1
+ *	@buf: relay channel buffer
+ *
+ *	switch_subbuf() helper function.
+ */
+static inline void relay_inc_produced(struct rchan_buf *buf)
+{
+	buf->subbufs_produced++;
+}
+
+/**
  *	relay_write - write data into the channel
  *	@chan: relay channel
  *	@data: data to be written
diff --git a/kernel/relay.c b/kernel/relay.c
index 8d13a78..53652f1 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -324,6 +324,21 @@ static int remove_buf_file_default_callback(struct dentry *dentry)
 	return -EINVAL;
 }
 
+/*
+ * notify_consumers() default callback.
+ */
+static void notify_consumers_default_callback(struct rchan_buf *buf)
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
+
 /* relay channel default callbacks */
 static struct rchan_callbacks default_channel_callbacks = {
 	.subbuf_start = subbuf_start_default_callback,
@@ -331,6 +346,7 @@ static struct rchan_callbacks default_channel_callbacks = {
 	.buf_unmapped = buf_unmapped_default_callback,
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
+	.notify_consumers = notify_consumers_default_callback,
 };
 
 /**
@@ -508,6 +524,8 @@ static void setup_callbacks(struct rchan *chan,
 		cb->create_buf_file = create_buf_file_default_callback;
 	if (!cb->remove_buf_file)
 		cb->remove_buf_file = remove_buf_file_default_callback;
+	if (!cb->notify_consumers)
+		cb->notify_consumers = notify_consumers_default_callback;
 	chan->cb = cb;
 }
 
@@ -726,30 +744,17 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 	void *old, *new;
 	size_t old_subbuf, new_subbuf;
 
-	if (unlikely(length > buf->chan->subbuf_size))
+	if (unlikely(relay_event_toobig(buf, length)))
 		goto toobig;
 
 	if (buf->offset != buf->chan->subbuf_size + 1) {
 		buf->prev_padding = buf->chan->subbuf_size - buf->offset;
 		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
 		buf->padding[old_subbuf] = buf->prev_padding;
-		buf->subbufs_produced++;
-		if (buf->dentry)
-			buf->dentry->d_inode->i_size +=
-				buf->chan->subbuf_size -
-				buf->padding[old_subbuf];
-		else
-			buf->early_bytes += buf->chan->subbuf_size -
-					    buf->padding[old_subbuf];
-		smp_mb();
-		if (waitqueue_active(&buf->read_wait))
-			/*
-			 * Calling wake_up_interruptible() from here
-			 * will deadlock if we happen to be logging
-			 * from the scheduler (trying to re-grab
-			 * rq->lock), so defer it.
-			 */
-			__mod_timer(&buf->timer, jiffies + 1);
+		relay_inc_produced(buf);
+		relay_update_filesize(buf, buf->chan->subbuf_size -
+				      buf->padding[old_subbuf]);
+		buf->chan->cb->notify_consumers(buf);
 	}
 
 	old = buf->data;
@@ -763,7 +768,7 @@ size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
 	buf->data = new;
 	buf->padding[new_subbuf] = 0;
 
-	if (unlikely(length + buf->offset > buf->chan->subbuf_size))
+	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
 		goto toobig;
 
 	return length;
-- 
1.5.3.5



