Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbYI0GS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbYI0GS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 02:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYI0GRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 02:17:50 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:32935 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbYI0GRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 02:17:49 -0400
X-Authority-Analysis: v=1.0 c=1 a=EL4SVHJZKGMA:10 a=qWBTGFuzXRcA:10
 a=qbQrtpIn7OACpFAEgFoA:9 a=aHI419-XwkjZqFOCYe0A:7
 a=7uo0Y6S1I5_h7HcH7flwBes1akkA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=vNGxQsTWjH8A:10
Subject: [RFC PATCH 2/10] relay - Make the relay sub-buffer switch code
	replaceable.
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
Date: Sat, 27 Sep 2008 01:17:56 -0500
Message-Id: <1222496276.6710.73.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the relay sub-buffer switch code replaceable.

With this patch, tracers now have complete control over the relay
write (or reserve) path if they choose to do so, by implementing their
own version of the sub-buffer switch function (switch_subbuf()), in
addition to their own local write/reserve functions.  Tracers who
choose not to do so automatically default to the normal behavior.
---
 include/linux/relay.h |   23 ++++++++++++++++++-----
 kernel/relay.c        |   13 ++++++++-----
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 17f0515..52e4d61 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -168,6 +168,18 @@ struct rchan_callbacks
 	 * want to notify anyone should implement an empty version.
 	 */
         void (*notify_consumers)(struct rchan_buf *buf);
+
+	/*
+	 * switch_subbuf - sub-buffer switch callback
+	 * @buf: the channel buffer
+	 * @length: size of current event
+	 *
+	 * Returns either the length passed in or 0 if full.
+	 *
+	 * Performs sub-buffer-switch tasks such as updating filesize,
+	 * waking up readers, etc.
+	 */
+	size_t (*switch_subbuf)(struct rchan_buf *buf, size_t length);
 };
 
 /*
@@ -191,8 +203,9 @@ extern void relay_subbufs_consumed(struct rchan *chan,
 extern void relay_reset(struct rchan *chan);
 extern int relay_buf_full(struct rchan_buf *buf);
 
-extern size_t relay_switch_subbuf(struct rchan_buf *buf,
-				  size_t length);
+extern size_t switch_subbuf_default_callback(struct rchan_buf *buf,
+					     size_t length);
+
 
 /**
  *	relay_event_toobig - is event too big to fit in a sub-buffer?
@@ -259,7 +272,7 @@ static inline void relay_write(struct rchan *chan,
 	local_irq_save(flags);
 	buf = chan->buf[smp_processor_id()];
 	if (unlikely(buf->offset + length > chan->subbuf_size))
-		length = relay_switch_subbuf(buf, length);
+		length = chan->cb->switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
 	local_irq_restore(flags);
@@ -285,7 +298,7 @@ static inline void __relay_write(struct rchan *chan,
 
 	buf = chan->buf[get_cpu()];
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size))
-		length = relay_switch_subbuf(buf, length);
+		length = chan->cb->switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
 	put_cpu();
@@ -308,7 +321,7 @@ static inline void *relay_reserve(struct rchan *chan, size_t length)
 	struct rchan_buf *buf = chan->buf[smp_processor_id()];
 
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
-		length = relay_switch_subbuf(buf, length);
+		length = chan->cb->switch_subbuf(buf, length);
 		if (!length)
 			return NULL;
 	}
diff --git a/kernel/relay.c b/kernel/relay.c
index 53652f1..e299f49 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -347,6 +347,7 @@ static struct rchan_callbacks default_channel_callbacks = {
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
 	.notify_consumers = notify_consumers_default_callback,
+	.switch_subbuf = switch_subbuf_default_callback,
 };
 
 /**
@@ -526,6 +527,8 @@ static void setup_callbacks(struct rchan *chan,
 		cb->remove_buf_file = remove_buf_file_default_callback;
 	if (!cb->notify_consumers)
 		cb->notify_consumers = notify_consumers_default_callback;
+	if (!cb->switch_subbuf)
+		cb->switch_subbuf = switch_subbuf_default_callback;
 	chan->cb = cb;
 }
 
@@ -730,7 +733,7 @@ int relay_late_setup_files(struct rchan *chan,
 }
 
 /**
- *	relay_switch_subbuf - switch to a new sub-buffer
+ *	switch_subbuf_default_callback - switch to a new sub-buffer
  *	@buf: channel buffer
  *	@length: size of current event
  *
@@ -739,7 +742,7 @@ int relay_late_setup_files(struct rchan *chan,
  *	Performs sub-buffer-switch tasks such as invoking callbacks,
  *	updating padding counts, waking up readers, etc.
  */
-size_t relay_switch_subbuf(struct rchan_buf *buf, size_t length)
+size_t switch_subbuf_default_callback(struct rchan_buf *buf, size_t length)
 {
 	void *old, *new;
 	size_t old_subbuf, new_subbuf;
@@ -777,7 +780,7 @@ toobig:
 	buf->chan->last_toobig = length;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(relay_switch_subbuf);
+EXPORT_SYMBOL_GPL(switch_subbuf_default_callback);
 
 /**
  *	relay_subbufs_consumed - update the buffer's sub-buffers-consumed count
@@ -857,14 +860,14 @@ void relay_flush(struct rchan *chan)
 		return;
 
 	if (chan->is_global && chan->buf[0]) {
-		relay_switch_subbuf(chan->buf[0], 0);
+		chan->cb->switch_subbuf(chan->buf[0], 0);
 		return;
 	}
 
 	mutex_lock(&relay_channels_mutex);
 	for_each_possible_cpu(i)
 		if (chan->buf[i])
-			relay_switch_subbuf(chan->buf[i], 0);
+			chan->cb->switch_subbuf(chan->buf[i], 0);
 	mutex_unlock(&relay_channels_mutex);
 }
 EXPORT_SYMBOL_GPL(relay_flush);
-- 
1.5.3.5



