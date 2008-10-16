Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYJPGS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYJPGS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYJPGNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:16 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:43139 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbYJPGNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:13:12 -0400
X-Authority-Analysis: v=1.0 c=1 a=YLGnZZIGIycA:10 a=7E3xctwQIg4A:10
 a=bvnsfeOpY1UewBW1VOEA:9 a=WEs6l3eUuKbZP_G_8AIA:7
 a=kgXtDSQZmfnwvstMY_Wgd2K1_B0A:4 a=v47ZLdibA2YA:10
Subject: [RFC PATCH 18/21]  Add pagewrite_reserve().
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
       David Wilder <dwilder@us.ibm.com>, Jens Axboe <jens.axboe@oracle.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 01:06:45 -0500
Message-Id: <1224137205.16328.237.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also added is a callback named write_padding() which can be used to
write padding events at the end of the page if an event won't fit in
the remaining space.
---
 block/blktrace.c                 |   27 ++++++++++----
 include/linux/blktrace_api.h     |    2 +
 include/linux/relay_pagewriter.h |   73 ++++++++++++++++++++++++++++++++++++++
 kernel/relay_pagewriter.c        |   25 ++++++++++---
 4 files changed, 115 insertions(+), 12 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 8ba7094..f5b745d 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -35,7 +35,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 
-	t = kmalloc(sizeof(*t) + len, GFP_KERNEL);
+	t = pagewriter_reserve(bt->pagewriter, sizeof(*t) + len, sizeof(*t));
 	if (t) {
 		const int cpu = smp_processor_id();
 
@@ -47,8 +47,6 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 		t->cpu = cpu;
 		t->pdu_len = len;
 		memcpy((void *) t + sizeof(*t), data, len);
-		pagewriter_write(bt->pagewriter, t, sizeof(*t) + len);
-		kfree(t);
 	}
 }
 
@@ -168,7 +166,8 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (unlikely(tsk->btrace_seq != blktrace_seq))
 		trace_note_tsk(bt, tsk);
 
-	t = kmalloc(sizeof(*t) + pdu_len, GFP_KERNEL);
+	t = pagewriter_reserve(bt->pagewriter, sizeof(*t) + pdu_len,
+			       sizeof(*t));
 	if (t) {
 		cpu = smp_processor_id();
 		sequence = per_cpu_ptr(bt->sequence, cpu);
@@ -187,8 +186,6 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 		if (pdu_len)
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
-		pagewriter_write(bt->pagewriter, t, sizeof(*t) + pdu_len);
-		kfree(t);
 	}
 
 	local_irq_restore(flags);
@@ -335,6 +332,21 @@ static const struct file_operations blk_msg_fops = {
 	.write =	blk_msg_write,
 };
 
+static void blk_write_padding_callback(struct pagewriter_buf *buf,
+				       size_t length,
+				       void *reserved)
+{
+	struct blk_io_trace *t = reserved;
+
+	t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
+	t->action = BLK_TN_PADDING;
+	t->pdu_len = length - sizeof(*t);
+}
+
+static struct pagewriter_callbacks blk_pagewriter_callbacks = {
+	.write_padding           = blk_write_padding_callback,
+};
+
 /*
  * Setup everything required to start tracing
  */
@@ -392,7 +404,8 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	n_pages = (buts->buf_size * buts->buf_nr) / PAGE_SIZE;
 	n_pages_wakeup = buts->buf_size / PAGE_SIZE;
 	bt->pagewriter = pagewriter_open("trace", dir, n_pages, n_pages_wakeup,
-					 NULL, bt, 0UL);
+					 &blk_pagewriter_callbacks, bt,
+					 PAGEWRITER_PAD_WRITES);
 	if (!bt->pagewriter)
 		goto err;
 
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 59461f2..c9857f1 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -56,6 +56,7 @@ enum blktrace_notify {
 	__BLK_TN_PROCESS = 0,		/* establish pid/name mapping */
 	__BLK_TN_TIMESTAMP,		/* include system clock */
 	__BLK_TN_MESSAGE,		/* Character string message */
+	__BLK_TN_PADDING,		/* Padding message */
 };
 
 
@@ -81,6 +82,7 @@ enum blktrace_notify {
 #define BLK_TN_PROCESS		(__BLK_TN_PROCESS | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_TIMESTAMP	(__BLK_TN_TIMESTAMP | BLK_TC_ACT(BLK_TC_NOTIFY))
 #define BLK_TN_MESSAGE		(__BLK_TN_MESSAGE | BLK_TC_ACT(BLK_TC_NOTIFY))
+#define BLK_TN_PADDING		(__BLK_TN_PADDING | BLK_TC_ACT(BLK_TC_NOTIFY))
 
 #define BLK_IO_TRACE_MAGIC	0x65617400
 #define BLK_IO_TRACE_VERSION	0x07
diff --git a/include/linux/relay_pagewriter.h b/include/linux/relay_pagewriter.h
index 2476ef6..12378e5 100644
--- a/include/linux/relay_pagewriter.h
+++ b/include/linux/relay_pagewriter.h
@@ -22,6 +22,11 @@
 #include <linux/relay.h>
 
 /*
+ * pagewriter flags
+ */
+#define PAGEWRITER_PAD_WRITES		0x00010000	/* don't cross pages */
+
+/*
  * Per-cpu pagewriter buffer
  */
 struct pagewriter_buf {
@@ -48,6 +53,7 @@ struct pagewriter {
 	struct pagewriter_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
 	struct list_head list;		/* for channel list */
 	atomic_t dropped;		/* dropped events due to buffer-full */
+	unsigned long flags;		/* pagewriter flags for this channel */
 };
 
 extern size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *b,
@@ -106,6 +112,21 @@ struct pagewriter_callbacks {
 	size_t (*switch_page)(struct pagewriter_buf *buf,
 			      size_t length,
 			      void **reserved);
+
+	/*
+	 * write_padding - callback for writing padding events
+	 * @buf: the channel buffer
+	 * @length: the length of the padding
+	 * @reserved: a pointer to the start of padding
+	 *
+	 * This callback can be used to write a padding event when
+	 * pagewriter_reserve can't write a complete event.  The
+	 * length of the padding is guaranteed to be at least as large
+	 * as the end_reserve size passed into pagewriter_reserve().
+	 */
+	void (*write_padding)(struct pagewriter_buf *buf,
+			      size_t length,
+			      void *reserved);
 };
 
 /**
@@ -186,6 +207,58 @@ static inline void __pagewriter_write(struct pagewriter *pagewriter,
 }
 
 /**
+ *	pagewriter_reserve - reserve slot in channel buffer
+ *	@pagewriter: pagewriter
+ *	@length: number of bytes to reserve
+ *	@end_reserve: reserve at least this much for a padding event, if needed
+ *
+ *	Returns pointer to reserved slot, NULL if full.
+ *
+ *	Reserves a slot in the current cpu's channel buffer.
+ *	Does not protect the buffer at all - caller must provide
+ *	appropriate synchronization.
+ *
+ *	If the event won't fit, at least end_reserve bytes are
+ *	reserved for a padding event, and the write_padding() callback
+ *	function is called to allow the client to write the padding
+ *	event before switching to the next page.  The write_padding()
+ *	callback is passed a pointer to the start of the padding along
+ *	with its length.
+ */
+
+static inline void *pagewriter_reserve(struct pagewriter *pagewriter,
+				       size_t length,
+				       size_t end_reserve)
+{
+	struct pagewriter_buf *buf;
+	unsigned long flags;
+	void *reserved;
+
+	local_irq_save(flags);
+	buf = pagewriter->buf[smp_processor_id()];
+	reserved = buf->data + buf->offset;
+	if (unlikely(buf->offset + length + end_reserve > PAGE_SIZE)) {
+		void *prev_reserved = reserved;
+		size_t new_offset = buf->offset + length;
+		if (likely(new_offset != PAGE_SIZE)) {
+			size_t padding = PAGE_SIZE - buf->offset;
+			pagewriter->cb->write_padding(buf, padding, reserved);
+		}
+		pagewriter->cb->switch_page(buf, length, &reserved);
+		if (unlikely(!reserved))
+			length = 0;
+		if (unlikely(new_offset == PAGE_SIZE)) {
+			reserved = prev_reserved;
+			length = 0;
+		}
+	}
+	buf->offset += length;
+	local_irq_restore(flags);
+
+	return reserved;
+}
+
+/**
  *	page_start_reserve - reserve bytes at the start of a page
  *	@buf: pagewriter channel buffer
  *	@length: number of bytes to reserve
diff --git a/kernel/relay_pagewriter.c b/kernel/relay_pagewriter.c
index 4b79274..d27267f 100644
--- a/kernel/relay_pagewriter.c
+++ b/kernel/relay_pagewriter.c
@@ -54,7 +54,7 @@ static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init);
  *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
  *	@cb: client callback functions
  *	@private_data: user-defined data
- *	@rchan_flags: relay flags, passed on to relay
+ *	@flags: channel flags, top half for pagewriter, bottom half for relay
  *
  *	Returns pagewriter pointer if successful, %NULL otherwise.
  *
@@ -67,7 +67,7 @@ struct pagewriter *pagewriter_open(const char *base_filename,
 				   size_t n_pages_wakeup,
 				   struct pagewriter_callbacks *cb,
 				   void *private_data,
-				   unsigned long rchan_flags)
+				   unsigned long flags)
 {
 	unsigned int i;
 	struct pagewriter *pagewriter;
@@ -77,7 +77,7 @@ struct pagewriter *pagewriter_open(const char *base_filename,
 		return NULL;
 
 	rchan = relay_open(base_filename, parent, n_pages_wakeup, NULL,
-			   private_data, rchan_flags);
+			   private_data, flags);
 	if (!rchan)
 		return NULL;
 
@@ -88,6 +88,7 @@ struct pagewriter *pagewriter_open(const char *base_filename,
 	}
 
 	pagewriter->rchan = rchan;
+	pagewriter->flags = flags;
 	pagewriter->n_pages = n_pages;
 	atomic_set(&pagewriter->dropped, 0);
 
@@ -414,10 +415,20 @@ static void new_page_default_callback(struct pagewriter_buf *buf,
 {
 }
 
+/*
+ * write_padding() default callback.
+ */
+void pagewriter_write_padding_default_callback(struct pagewriter_buf *buf,
+					       size_t length,
+					       void *reserved)
+{
+}
+
 /* pagewriter default callbacks */
 static struct pagewriter_callbacks default_pagewriter_callbacks = {
 	.new_page = new_page_default_callback,
 	.switch_page = pagewriter_switch_page_default_callback,
+	.write_padding = pagewriter_write_padding_default_callback,
 };
 
 static void setup_callbacks(struct pagewriter *pagewriter,
@@ -432,6 +443,9 @@ static void setup_callbacks(struct pagewriter *pagewriter,
 		cb->new_page = new_page_default_callback;
 	if (!cb->switch_page)
 		cb->switch_page = pagewriter_switch_page_default_callback;
+	if (!cb->write_padding)
+		cb->write_padding = pagewriter_write_padding_default_callback;
+
 	pagewriter->cb = cb;
 }
 
@@ -502,7 +516,7 @@ size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
 					       size_t length,
 					       void **reserved)
 {
-	size_t remainder;
+	size_t remainder = length;
 	struct relay_page *new_page;
 
 	if (unlikely(pagewriter_event_toobig(buf, length)))
@@ -517,7 +531,8 @@ size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
 		return 0;
 	}
 
-	remainder = length - (PAGE_SIZE - buf->offset);
+	if (!(buf->pagewriter->flags & PAGEWRITER_PAD_WRITES))
+		remainder = length - (PAGE_SIZE - buf->offset);
 
 	relay_add_page(buf->pagewriter->rchan, buf->page->page,
 		       &pagewriter_relay_page_callbacks, (void *)buf);
-- 
1.5.3.5



