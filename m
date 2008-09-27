Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYI0GTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYI0GTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 02:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYI0GSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 02:18:07 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:37381 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYI0GSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 02:18:04 -0400
X-Authority-Analysis: v=1.0 c=1 a=snFDob06t5wA:10 a=2ZIZM6jp9IQA:10
 a=hkalZczCN4h1uf0MMtwA:9 a=DJKswTT-K34f7Kw-7P0A:7
 a=2qlBhTu5_FeYuas2OsfRbfZVtEsA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=eZLSmJVMEtUA:10
Subject: [RFC PATCH 6/10] relay - Replace relay_reserve/relay_write with
	non-padded versions.
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
Date: Sat, 27 Sep 2008 01:18:11 -0500
Message-Id: <1222496291.6710.77.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace relay_reserve/relay_write with non-padded versions.

The old versions of relay_reserve/relay_write would write/reserve an
event only if the whole thing could fit in the remaining space of the
current sub-buffer; if it couldn't it would add padding to the current
sub-buffer and reserve in the next.  The new versions don't add
padding but use up all the space in a sub-buffer and write the
remainder in the next sub-buffer.  They won't however write a partial
event - if there's not enough space for the event in the current
sub-buffer and the next sub-buffer isn't free, the whole reserve/write
will fail.
---
 include/linux/relay.h |   41 +++++++++++++++++++----------
 kernel/relay.c        |   68 ++++++++++++++++++++++++++----------------------
 2 files changed, 64 insertions(+), 45 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 978fdea..21eba2a 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -207,9 +207,9 @@ extern void relay_subbufs_consumed(struct rchan *chan,
 extern void relay_reset(struct rchan *chan);
 extern int relay_buf_full(struct rchan_buf *buf);
 
-extern size_t switch_subbuf_default_callback(struct rchan_buf *buf,
-					     size_t length,
-					     void **reserved);
+extern size_t relay_switch_subbuf_default_callback(struct rchan_buf *buf,
+						   size_t length,
+						   void **reserved);
 
 
 /**
@@ -271,17 +271,23 @@ static inline void relay_write(struct rchan *chan,
 			       const void *data,
 			       size_t length)
 {
-	unsigned long flags;
+	size_t remainder = length;
 	struct rchan_buf *buf;
+	unsigned long flags;
 	void *reserved;
 
 	local_irq_save(flags);
 	buf = chan->buf[smp_processor_id()];
 	reserved = buf->data + buf->offset;
-	if (unlikely(buf->offset + length > chan->subbuf_size))
-		length = chan->cb->switch_subbuf(buf, length, &reserved);
+	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
+		remainder = chan->cb->switch_subbuf(buf, length, &reserved);
+		if (unlikely(!reserved)) {
+			local_irq_restore(flags);
+			return;
+		}
+	}
 	memcpy(reserved, data, length);
-	buf->offset += length;
+	buf->offset += remainder;
 	local_irq_restore(flags);
 }
 
@@ -301,15 +307,22 @@ static inline void __relay_write(struct rchan *chan,
 				 const void *data,
 				 size_t length)
 {
+	size_t remainder = length;
 	struct rchan_buf *buf;
+	unsigned long flags;
 	void *reserved;
 
 	buf = chan->buf[get_cpu()];
 	reserved = buf->data + buf->offset;
-	if (unlikely(buf->offset + length > buf->chan->subbuf_size))
-		length = chan->cb->switch_subbuf(buf, length, &reserved);
+	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
+		remainder = chan->cb->switch_subbuf(buf, length, &reserved);
+		if (unlikely(!reserved)) {
+			local_irq_restore(flags);
+			return;
+		}
+	}
 	memcpy(reserved, data, length);
-	buf->offset += length;
+	buf->offset += remainder;
 	put_cpu();
 }
 
@@ -324,15 +337,15 @@ static inline void __relay_write(struct rchan *chan,
  *	Does not protect the buffer at all - caller must provide
  *	appropriate synchronization.
  */
-static inline void *relay_reserve(struct rchan *chan, size_t length)
+static inline void *relay_reserve(struct rchan *chan,
+				  size_t length)
 {
-	void *reserved;
 	struct rchan_buf *buf = chan->buf[smp_processor_id()];
+	void *reserved = buf->data + buf->offset;
 
-	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
 		length = chan->cb->switch_subbuf(buf, length, &reserved);
-		if (!length)
+		if (unlikely(!reserved))
 			return NULL;
 	}
 	buf->offset += length;
diff --git a/kernel/relay.c b/kernel/relay.c
index e9dd976..d382528 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -350,7 +350,7 @@ static struct rchan_callbacks default_channel_callbacks = {
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
 	.notify_consumers = notify_consumers_default_callback,
-	.switch_subbuf = switch_subbuf_default_callback,
+	.switch_subbuf = relay_switch_subbuf_default_callback,
 };
 
 /**
@@ -530,7 +530,7 @@ static void setup_callbacks(struct rchan *chan,
 	if (!cb->notify_consumers)
 		cb->notify_consumers = notify_consumers_default_callback;
 	if (!cb->switch_subbuf)
-		cb->switch_subbuf = switch_subbuf_default_callback;
+		cb->switch_subbuf = relay_switch_subbuf_default_callback;
 	chan->cb = cb;
 }
 
@@ -736,8 +736,20 @@ int relay_late_setup_files(struct rchan *chan,
 	return err;
 }
 
+static inline int next_subbuf_free(struct rchan_buf *buf)
+{
+	size_t full_subbufs;
+
+	if (buf->chan->flags & RCHAN_MODE_OVERWRITE)
+		return 1;
+
+	full_subbufs = buf->subbufs_produced - buf->subbufs_consumed;
+
+	return (full_subbufs < buf->chan->n_subbufs - 1);
+}
+
 /**
- *	switch_subbuf_default_callback - switch to a new sub-buffer
+ *	relay_switch_subbuf_default_callback - switch to a new sub-buffer
  *	@buf: channel buffer
  *	@length: size of current event
  *	@reserved: a pointer to the space reserved
@@ -747,50 +759,44 @@ int relay_late_setup_files(struct rchan *chan,
  *	Performs sub-buffer-switch tasks such as invoking callbacks,
  *	updating padding counts, waking up readers, etc.
  */
-size_t switch_subbuf_default_callback(struct rchan_buf *buf,
-				      size_t length,
-				      void **reserved)
+size_t relay_switch_subbuf_default_callback(struct rchan_buf *buf,
+					    size_t length,
+					    void **reserved)
 {
-	void *old, *new;
-	size_t old_subbuf, new_subbuf;
+	size_t remainder, new_subbuf;
+	void *new_data;
 
 	if (unlikely(relay_event_toobig(buf, length)))
 		goto toobig;
 
-	if (buf->offset != buf->chan->subbuf_size + 1) {
-		buf->prev_padding = buf->chan->subbuf_size - buf->offset;
-		old_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
-		buf->padding[old_subbuf] = buf->prev_padding;
-		relay_inc_produced(buf);
-		relay_update_filesize(buf, buf->chan->subbuf_size -
-				      buf->padding[old_subbuf]);
-		buf->chan->cb->notify_consumers(buf);
+	/* don't write anything unless we can write it all. */
+	if (!next_subbuf_free(buf)) {
+		if (reserved)
+			*reserved = NULL;
+		return 0;
 	}
 
-	old = buf->data;
+	remainder = length - (buf->chan->subbuf_size - buf->offset);
+	relay_inc_produced(buf);
+	relay_update_filesize(buf, buf->chan->subbuf_size + remainder);
+	buf->chan->cb->notify_consumers(buf);
+
 	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
-	new = buf->start + new_subbuf * buf->chan->subbuf_size;
-	buf->offset = 0;
-	if (!buf->chan->cb->subbuf_start(buf, new, old, buf->prev_padding)) {
-		buf->offset = buf->chan->subbuf_size + 1;
-		return 0;
-	}
-	buf->data = new;
-	buf->padding[new_subbuf] = 0;
+	new_data = buf->start + new_subbuf * buf->chan->subbuf_size;
+
+	buf->data = new_data;
+	buf->offset = 0; /* remainder will be added by caller */
+	buf->chan->cb->subbuf_start(buf, new_data, NULL, 0);
 
 	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
 		goto toobig;
 
-	if (reserved)
-		*reserved = buf->data;
-
-	return length;
-
+	return remainder;
 toobig:
 	buf->chan->last_toobig = length;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(switch_subbuf_default_callback);
+EXPORT_SYMBOL_GPL(relay_switch_subbuf_default_callback);
 
 /**
  *	relay_subbufs_consumed - update the buffer's sub-buffers-consumed count
-- 
1.5.3.5



