Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYIYGIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYIYGIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYIYGHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:07:33 -0400
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:39625
	"EHLO QMTA08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbYIYGHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:07:31 -0400
X-Authority-Analysis: v=1.0 c=1 a=e8jT977c570A:10 a=yIoM5he2LSMA:10
 a=NOA-Z5FfUGEXPFHkR2cA:9 a=Vjs4J1O0yG5KeXTQHekA:7
 a=roHbVQ1523IhtkH6bx8dzkQ6N0wA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=vNGxQsTWjH8A:10
Subject: [RFC PATCH 2/8] relay - Make the relay sub-buffer switch code
	replaceable.
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
Date: Thu, 25 Sep 2008 01:07:27 -0500
Message-Id: <1222322847.6435.57.camel@charm-linux>
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
 include/linux/relay.h |   22 +++++++++++++++++-----
 kernel/relay.c        |   13 ++++++++-----
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 2242004..a1dcfc1 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -168,6 +168,18 @@ struct rchan_callbacks
 	 * wakeups should implement an empty version.
 	 */
         void (*wakeup_readers)(struct rchan_buf *buf);
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
@@ -191,8 +203,8 @@ extern void relay_subbufs_consumed(struct rchan *chan,
 extern void relay_reset(struct rchan *chan);
 extern int relay_buf_full(struct rchan_buf *buf);
 
-extern size_t relay_switch_subbuf(struct rchan_buf *buf,
-				  size_t length);
+extern size_t switch_subbuf_default_callback(struct rchan_buf *buf,
+					     size_t length);
 
 /**
  *	relay_event_toobig - is event too big to fit in a sub-buffer?
@@ -259,7 +271,7 @@ static inline void relay_write(struct rchan *chan,
 	local_irq_save(flags);
 	buf = chan->buf[smp_processor_id()];
 	if (unlikely(buf->offset + length > chan->subbuf_size))
-		length = relay_switch_subbuf(buf, length);
+		length = chan->cb->switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
 	local_irq_restore(flags);
@@ -285,7 +297,7 @@ static inline void __relay_write(struct rchan *chan,
 
 	buf = chan->buf[get_cpu()];
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size))
-		length = relay_switch_subbuf(buf, length);
+		length = chan->cb->switch_subbuf(buf, length);
 	memcpy(buf->data + buf->offset, data, length);
 	buf->offset += length;
 	put_cpu();
@@ -308,7 +320,7 @@ static inline void *relay_reserve(struct rchan *chan, size_t length)
 	struct rchan_buf *buf = chan->buf[smp_processor_id()];
 
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
-		length = relay_switch_subbuf(buf, length);
+		length = chan->cb->switch_subbuf(buf, length);
 		if (!length)
 			return NULL;
 	}
diff --git a/kernel/relay.c b/kernel/relay.c
index 7d588fe..f1f55ae 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -347,6 +347,7 @@ static struct rchan_callbacks default_channel_callbacks = {
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
 	.wakeup_readers = wakeup_readers_default_callback,
+	.switch_subbuf = switch_subbuf_default_callback,
 };
 
 /**
@@ -526,6 +527,8 @@ static void setup_callbacks(struct rchan *chan,
 		cb->remove_buf_file = remove_buf_file_default_callback;
 	if (!cb->wakeup_readers)
 		cb->wakeup_readers = wakeup_readers_default_callback;
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



