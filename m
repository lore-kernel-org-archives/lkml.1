Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYIYGHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYIYGHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYIYGHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:07:23 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:41448 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339AbYIYGHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:07:21 -0400
X-Authority-Analysis: v=1.0 c=1 a=OZyuvza53jQA:10 a=wWYf5i0UQxsA:10
 a=rWksiQT5POXiWDQ99I4A:9 a=Kow7_lAeZ5J3S3jculkA:7
 a=3ofcIju1NgDKhpFam3lIlt0p3lgA:4 a=955elKCOoL8A:10
Subject: [RFC PATCH 1/8] relay - Clean up relay_switch_subbuf() and make
	waking up consumers optional.
From: Tom Zanussi <zanussi@comcast.net>
To: Martin Bligh <mbligh@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <1222228215.7761.0.camel@charm-linux>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
	 <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
	 <1222228215.7761.0.camel@charm-linux>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 01:07:18 -0500
Message-Id: <1222322838.6435.56.camel@charm-linux>
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
index 953fc05..2242004 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -159,6 +159,15 @@ struct rchan_callbacks
 	 * The callback should return 0 if successful, negative if not.
 	 */
 	int (*remove_buf_file)(struct dentry *dentry);
+
+	/*
+	 * wakeup_readers - sub-buffer was switched, let readers know
+	 * @buf: the channel buffer
+	 *
+	 * Called during sub-buffer switch.  Users who don't want any
+	 * wakeups should implement an empty version.
+	 */
+        void (*wakeup_readers)(struct rchan_buf *buf);
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
+ *	switch_subbuf() helper function
+ */
+static inline int relay_event_toobig(struct rchan_buf *buf, size_t length)
+{
+	return length > buf->chan->subbuf_size;
+}
+
+/**
+ *	relay_update_filesize - add to filesize of relay file
+ *	@buf: relay channel buffer
+ *	@length: length to add
+ *
+ *	switch_subbuf() helper function
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
+ *	relay_inc_produced - add 1 to buf->produced
+ *	@buf: relay channel buffer
+ *
+ *	switch_subbuf() helper function
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
index 8d13a78..7d588fe 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -324,6 +324,21 @@ static int remove_buf_file_default_callback(struct dentry *dentry)
 	return -EINVAL;
 }
 
+/*
+ * wakeup_readers() default callback.
+ */
+static void wakeup_readers_default_callback(struct rchan_buf *buf)
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
+	.wakeup_readers = wakeup_readers_default_callback,
 };
 
 /**
@@ -508,6 +524,8 @@ static void setup_callbacks(struct rchan *chan,
 		cb->create_buf_file = create_buf_file_default_callback;
 	if (!cb->remove_buf_file)
 		cb->remove_buf_file = remove_buf_file_default_callback;
+	if (!cb->wakeup_readers)
+		cb->wakeup_readers = wakeup_readers_default_callback;
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
+		buf->chan->cb->wakeup_readers(buf);
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



