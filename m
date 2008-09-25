Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYIYGIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYIYGIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYIYGHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:07:49 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48418 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616AbYIYGHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:07:48 -0400
X-Authority-Analysis: v=1.0 c=1 a=s-ej4CedQcEA:10 a=jTWYxA_bob8A:10
 a=OOGyXFxl7UeznH3UHA4A:9 a=VRBy7VVbKTdvgD9kqVwA:7
 a=A7NJ1Mbo4Zw8aCeDCJsdZxLQ0kAA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=eqxxFxNu-gsA:10
Subject: [RFC PATCH 4/8] relay - Add reserved param to switch-subbuf, in
	preparation for non-pad write/reserve.
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
Date: Thu, 25 Sep 2008 01:07:40 -0500
Message-Id: <1222322860.6435.59.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reserved param to switch-subbuf, in preparation for non-pad write/reserve.

Because a write/reserve can now cross sub-buffer boundaries, we use
the length returned as a remainder for the new sub-buffer, and use the
reserved param to return a pointer to the reserved space, or NULL if
it couldn't be reserved.  This patch also changes write/reserve to
preserve their current behavior despite that change.  This all goes
away in a future patch, but is here now so things don't break.
---
 include/linux/relay.h |   24 ++++++++++++++++--------
 kernel/relay.c        |   12 +++++++++---
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 648b4da..13163b0 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -173,13 +173,16 @@ struct rchan_callbacks
 	 * switch_subbuf - sub-buffer switch callback
 	 * @buf: the channel buffer
 	 * @length: size of current event
+	 * @reserved: a pointer to the space reserved
 	 *
 	 * Returns either the length passed in or 0 if full.
 	 *
 	 * Performs sub-buffer-switch tasks such as updating filesize,
 	 * waking up readers, etc.
 	 */
-	size_t (*switch_subbuf)(struct rchan_buf *buf, size_t length);
+	size_t (*switch_subbuf)(struct rchan_buf *buf,
+				size_t length,
+				void **reserved);
 };
 
 /*
@@ -205,7 +208,8 @@ extern void relay_reset(struct rchan *chan);
 extern int relay_buf_full(struct rchan_buf *buf);
 
 extern size_t switch_subbuf_default_callback(struct rchan_buf *buf,
-					     size_t length);
+					     size_t length,
+					     void **reserved);
 
 /**
  *	relay_event_toobig - is event too big to fit in a sub-buffer?
@@ -268,12 +272,14 @@ static inline void relay_write(struct rchan *chan,
 {
 	unsigned long flags;
 	struct rchan_buf *buf;
+	void *reserved;
 
 	local_irq_save(flags);
 	buf = chan->buf[smp_processor_id()];
+	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > chan->subbuf_size))
-		length = chan->cb->switch_subbuf(buf, length);
-	memcpy(buf->data + buf->offset, data, length);
+		length = chan->cb->switch_subbuf(buf, length, &reserved);
+	memcpy(reserved, data, length);
 	buf->offset += length;
 	local_irq_restore(flags);
 }
@@ -295,11 +301,13 @@ static inline void __relay_write(struct rchan *chan,
 				 size_t length)
 {
 	struct rchan_buf *buf;
+	void *reserved;
 
 	buf = chan->buf[get_cpu()];
+	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size))
-		length = chan->cb->switch_subbuf(buf, length);
-	memcpy(buf->data + buf->offset, data, length);
+		length = chan->cb->switch_subbuf(buf, length, &reserved);
+	memcpy(reserved, data, length);
 	buf->offset += length;
 	put_cpu();
 }
@@ -320,12 +328,12 @@ static inline void *relay_reserve(struct rchan *chan, size_t length)
 	void *reserved;
 	struct rchan_buf *buf = chan->buf[smp_processor_id()];
 
+	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
-		length = chan->cb->switch_subbuf(buf, length);
+		length = chan->cb->switch_subbuf(buf, length, &reserved);
 		if (!length)
 			return NULL;
 	}
-	reserved = buf->data + buf->offset;
 	buf->offset += length;
 
 	return reserved;
diff --git a/kernel/relay.c b/kernel/relay.c
index d7a6458..9ea9240 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -736,13 +736,16 @@ int relay_late_setup_files(struct rchan *chan,
  *	switch_subbuf_default_callback - switch to a new sub-buffer
  *	@buf: channel buffer
  *	@length: size of current event
+ *	@reserved: a pointer to the space reserved
  *
  *	Returns either the length passed in or 0 if full.
  *
  *	Performs sub-buffer-switch tasks such as invoking callbacks,
  *	updating padding counts, waking up readers, etc.
  */
-size_t switch_subbuf_default_callback(struct rchan_buf *buf, size_t length)
+size_t switch_subbuf_default_callback(struct rchan_buf *buf,
+				      size_t length,
+				      void **reserved)
 {
 	void *old, *new;
 	size_t old_subbuf, new_subbuf;
@@ -774,6 +777,9 @@ size_t switch_subbuf_default_callback(struct rchan_buf *buf, size_t length)
 	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
 		goto toobig;
 
+	if (reserved)
+		*reserved = buf->data;
+
 	return length;
 
 toobig:
@@ -860,14 +866,14 @@ void relay_flush(struct rchan *chan)
 		return;
 
 	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
-		chan->cb->switch_subbuf(chan->buf[0], 0);
+		chan->cb->switch_subbuf(chan->buf[0], 0, NULL);
 		return;
 	}
 
 	mutex_lock(&relay_channels_mutex);
 	for_each_possible_cpu(i)
 		if (chan->buf[i])
-			chan->cb->switch_subbuf(chan->buf[i], 0);
+			chan->cb->switch_subbuf(chan->buf[i], 0, NULL);
 	mutex_unlock(&relay_channels_mutex);
 }
 EXPORT_SYMBOL_GPL(relay_flush);
-- 
1.5.3.5



