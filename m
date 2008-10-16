Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYJPGRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYJPGRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYJPGNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:00 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:46405 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755874AbYJPGM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:12:56 -0400
X-Authority-Analysis: v=1.0 c=1 a=JDssNIb45HwA:10 a=stu35GUsY0QA:10
 a=VwGl7nD8_HcgXLN32NsA:9 a=iJ3kyCsXfqibv6XNfYsA:7
 a=I-0-hcwhM7kj5SeGzsJ7aboT3XwA:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=X-lDvSGlWgMA:10 a=MSl-tDqOz04A:10 a=rPt6xJ-oxjAA:10
Subject: [RFC PATCH 14/21]  Separate into relay + pagewriter
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
Date: Thu, 16 Oct 2008 01:06:27 -0500
Message-Id: <1224137187.16328.233.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 block/blktrace.c                 |   41 +--
 include/linux/blktrace_api.h     |    4 +-
 include/linux/relay.h            |  246 ++++--------------
 include/linux/relay_pagewriter.h |  220 +++++++++++++++
 kernel/Makefile                  |    2 +-
 kernel/relay.c                   |  376 ++++++++++++---------------
 kernel/relay_pagewriter.c        |  545 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_trace.c             |   48 +---
 8 files changed, 1008 insertions(+), 474 deletions(-)
 create mode 100644 include/linux/relay_pagewriter.h
 create mode 100644 kernel/relay_pagewriter.c

diff --git a/block/blktrace.c b/block/blktrace.c
index f60665e..8ba7094 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -47,7 +47,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 		t->cpu = cpu;
 		t->pdu_len = len;
 		memcpy((void *) t + sizeof(*t), data, len);
-		relay_write(bt->rchan, t, sizeof(*t) + len);
+		pagewriter_write(bt->pagewriter, t, sizeof(*t) + len);
 		kfree(t);
 	}
 }
@@ -187,7 +187,7 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 		if (pdu_len)
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
-		relay_write(bt->rchan, t, sizeof(*t) + pdu_len);
+		pagewriter_write(bt->pagewriter, t, sizeof(*t) + pdu_len);
 		kfree(t);
 	}
 
@@ -247,7 +247,7 @@ err:
 
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
-	relay_close(bt->rchan);
+	pagewriter_close(bt->pagewriter);
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
 	blk_remove_tree(bt->dir);
@@ -285,7 +285,8 @@ static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
 	struct blk_trace *bt = filp->private_data;
 	char buf[16];
 
-	snprintf(buf, sizeof(buf), "%u\n", atomic_read(&bt->rchan->dropped));
+	snprintf(buf, sizeof(buf), "%u\n",
+		 atomic_read(&bt->pagewriter->dropped));
 
 	return simple_read_from_buffer(buffer, count, ppos, buf, strlen(buf));
 }
@@ -334,26 +335,6 @@ static const struct file_operations blk_msg_fops = {
 	.write =	blk_msg_write,
 };
 
-static int blk_remove_buf_file_callback(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-	return 0;
-}
-
-static struct dentry *blk_create_buf_file_callback(const char *filename,
-						   struct dentry *parent,
-						   int mode,
-						   struct rchan_buf *buf)
-{
-	return debugfs_create_file(filename, mode, parent, buf,
-					&relay_file_operations);
-}
-
-static struct rchan_callbacks blk_relay_callbacks = {
-	.create_buf_file	= blk_create_buf_file_callback,
-	.remove_buf_file	= blk_remove_buf_file_callback,
-};
-
 /*
  * Setup everything required to start tracing
  */
@@ -410,9 +391,9 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 
 	n_pages = (buts->buf_size * buts->buf_nr) / PAGE_SIZE;
 	n_pages_wakeup = buts->buf_size / PAGE_SIZE;
-	bt->rchan = relay_open("trace", dir, n_pages, n_pages_wakeup,
-			       &blk_relay_callbacks, bt, 0UL);
-	if (!bt->rchan)
+	bt->pagewriter = pagewriter_open("trace", dir, n_pages, n_pages_wakeup,
+					 NULL, bt, 0UL);
+	if (!bt->pagewriter)
 		goto err;
 
 	bt->act_mask = buts->act_mask;
@@ -445,8 +426,8 @@ err:
 			debugfs_remove(bt->dropped_file);
 		free_percpu(bt->sequence);
 		free_percpu(bt->msg_data);
-		if (bt->rchan)
-			relay_close(bt->rchan);
+		if (bt->pagewriter)
+			pagewriter_close(bt->pagewriter);
 		kfree(bt);
 	}
 	return ret;
@@ -499,7 +480,7 @@ int blk_trace_startstop(struct request_queue *q, int start)
 	} else {
 		if (bt->trace_state == Blktrace_running) {
 			bt->trace_state = Blktrace_stopped;
-			relay_flush(bt->rchan);
+			pagewriter_flush(bt->pagewriter);
 			ret = 0;
 		}
 	}
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 628cf3c..59461f2 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -2,7 +2,7 @@
 #define BLKTRACE_H
 
 #include <linux/blkdev.h>
-#include <linux/relay.h>
+#include <linux/relay_pagewriter.h>
 
 /*
  * Trace categories
@@ -119,7 +119,7 @@ enum {
 
 struct blk_trace {
 	int trace_state;
-	struct rchan *rchan;
+	struct pagewriter *pagewriter;
 	unsigned long *sequence;
 	unsigned char *msg_data;
 	u16 act_mask;
diff --git a/include/linux/relay.h b/include/linux/relay.h
index 91e253f..b23ba90 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2002, 2003 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
  * Copyright (C) 1999, 2000, 2001, 2002 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
  *
  * CONFIG_RELAY definitions and declarations
  */
@@ -20,11 +21,6 @@
 #include <linux/kref.h>
 
 /*
- * Tracks changes to rchan/rchan_buf structs
- */
-#define RELAYFS_CHANNEL_VERSION		8
-
-/*
  * relay channel flags
  */
 #define RCHAN_GLOBAL_BUFFER		0x00000001	/* not using per-cpu */
@@ -33,6 +29,8 @@ struct relay_page
 {
 	struct page *page;
 	struct list_head list;
+	struct relay_page_callbacks *cb;
+	void *private_data;
 };
 
 /*
@@ -40,18 +38,15 @@ struct relay_page
  */
 struct rchan_buf
 {
-	void *data;			/* address of current page */
-	struct relay_page *page;	/* current write page */
-	size_t offset;			/* current offset into page */
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
 	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
 	struct list_head pages;		/* current set of unconsumed pages */
+	spinlock_t lock;		/* protect pages list */
 	size_t consumed_offset;		/* bytes consumed in cur page */
 	size_t nr_pages;		/* number of unconsumed pages */
-	struct list_head pool;		/* current set of unused pages */
 	unsigned int finalized;		/* buffer has been finalized */
 	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
@@ -62,20 +57,16 @@ struct rchan_buf
  */
 struct rchan
 {
-	u32 version;			/* the version of this struct */
-	size_t n_pages;			/* number of pages per buffer */
 	size_t n_pages_wakeup;		/* wake up readers after filling n */
 	struct rchan_callbacks *cb;	/* client callbacks */
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
-	size_t last_toobig;		/* tried to log event > page size */
 	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
 	int has_base_filename;		/* has a filename associated? */
 	char base_filename[NAME_MAX];	/* saved base filename */
 	unsigned long flags;		/* relay flags for this channel */
-	atomic_t dropped;		/* dropped events due to buffer-full */
 };
 
 /*
@@ -84,26 +75,6 @@ struct rchan
 struct rchan_callbacks
 {
 	/*
-	 * new_page - called on switch to a new page
-	 * @buf: the channel buffer containing the new page
-	 * @page_data: the start of the new page
-	 *
-	 * This is simply a notification that a new page has been
-	 * switched to.  The default version does nothing but call
-	 * relay_wakeup_readers().  Clients who override this callback
-	 * should also call relay_wakeup_readers() to get that default
-	 * behavior in addition to whatever they add.  Clients who
-	 * don't want to wake up readers should just not call it.
-	 * Clients can use the channel private_data to track previous
-	 * pages, determine whether this is the first page, etc.
-	 *
-	 * NOTE: the client can reserve bytes at the beginning of the new
-	 *       page by calling page_start_reserve() in this callback.
-	 */
-	void (*new_page) (struct rchan_buf *buf,
-			  void *page_data);
-
-	/*
 	 * create_buf_file - create file to represent a relay channel buffer
 	 * @filename: the name of the file to create
 	 * @parent: the parent of the file to create
@@ -137,25 +108,50 @@ struct rchan_callbacks
 	 * The callback should return 0 if successful, negative if not.
 	 */
 	int (*remove_buf_file)(struct dentry *dentry);
+};
 
+/*
+ * Relay page callbacks
+ */
+struct relay_page_callbacks
+{
 	/*
-	 * switch_page - page switch callback
-	 * @buf: the channel buffer
-	 * @length: size of current event
-	 * @reserved: a pointer to the space reserved
+	 * page_released - called on switch to a new page
+	 * @buf: the channel buffer containing the new page
+	 * @page_data: the start of the new page
 	 *
-	 * This callback can be used to replace the complete write
-	 * path.  Normally clients wouldn't override this and would
-	 * use the default version instead.
+	 * This is simply a notification that a new page has been
+	 * switched to.  The default version does nothing but call
+	 * relay_wakeup_readers().  Clients who override this callback
+	 * should also call relay_wakeup_readers() to get that default
+	 * behavior in addition to whatever they add.  Clients who
+	 * don't want to wake up readers should just not call it.
+	 * Clients can use the channel private_data to track previous
+	 * pages, determine whether this is the first page, etc.
+	 *
+	 * NOTE: the client can reserve bytes at the beginning of the new
+	 *       page by calling page_start_reserve() in this callback.
+	 */
+	void (*page_released) (struct page *page, void *private_data);
+
+	/*
+	 * page_stolen - called on switch to a new page
+	 * @buf: the channel buffer containing the new page
+	 * @page_data: the start of the new page
 	 *
-	 * Returns either the length passed in or 0 if full.
+	 * This is simply a notification that a new page has been
+	 * switched to.  The default version does nothing but call
+	 * relay_wakeup_readers().  Clients who override this callback
+	 * should also call relay_wakeup_readers() to get that default
+	 * behavior in addition to whatever they add.  Clients who
+	 * don't want to wake up readers should just not call it.
+	 * Clients can use the channel private_data to track previous
+	 * pages, determine whether this is the first page, etc.
 	 *
-	 * Performs page-switch tasks such as updating filesize,
-	 * waking up readers, etc.
+	 * NOTE: the client can reserve bytes at the beginning of the new
+	 *       page by calling page_start_reserve() in this callback.
 	 */
-	size_t (*switch_page)(struct rchan_buf *buf,
-			      size_t length,
-			      void **reserved);
+	void (*page_stolen) (struct page *page, void *private_data);
 };
 
 /*
@@ -164,7 +160,6 @@ struct rchan_callbacks
 
 extern struct rchan *relay_open(const char *base_filename,
 				struct dentry *parent,
-				size_t n_pages,
 				size_t n_pages_wakeup,
 				struct rchan_callbacks *cb,
 				void *private_data,
@@ -172,164 +167,15 @@ extern struct rchan *relay_open(const char *base_filename,
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
 extern void relay_reset(struct rchan *chan);
-extern void relay_add_page(struct rchan_buf *buf, struct page *page);
+extern void relay_add_page(struct rchan *chan,
+			   struct page *page,
+			   struct relay_page_callbacks *cb,
+			   void *private_data);
 
 extern int relay_late_setup_files(struct rchan *chan,
 				  const char *base_filename,
 				  struct dentry *parent);
 
-extern size_t relay_switch_page_default_callback(struct rchan_buf *buf,
-						 size_t length,
-						 void **reserved);
-
-/**
- *	relay_wakeup_readers - wake up readers if applicable
- *	@buf: relay channel buffer
- *
- *	Called by new_page() default implementation, pulled out for
- *	the convenience of user-defined new_page() implementations.
- *
- *	Will wake up readers after each buf->n_pages_wakeup pages have
- *	been produced.  To do no waking up, simply pass 0 into relay
- *	open for this value.
- */
-static inline void relay_wakeup_readers(struct rchan_buf *buf)
-{
-	size_t wakeup = buf->chan->n_pages_wakeup;
-
-	if (wakeup && (buf->nr_pages % wakeup == 0) &&
-	    (waitqueue_active(&buf->read_wait)))
-		/*
-		 * Calling wake_up_interruptible() from here
-		 * will deadlock if we happen to be logging
-		 * from the scheduler (trying to re-grab
-		 * rq->lock), so defer it.
-		 */
-		__mod_timer(&buf->timer, jiffies + 1);
-}
-
-/**
- *	relay_event_toobig - is event too big to fit in a page?
- *	@buf: relay channel buffer
- *	@length: length of event
- *
- *	Returns 1 if too big, 0 otherwise.
- *
- *	switch_page() helper function.
- */
-static inline int relay_event_toobig(struct rchan_buf *buf, size_t length)
-{
-	return length > PAGE_SIZE;
-}
-
-/**
- *	relay_update_filesize - increase relay file i_size by length
- *	@buf: relay channel buffer
- *	@length: length to add
- *
- *	switch_page() helper function.
- */
-static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
-{
-	if (buf->dentry)
-		buf->dentry->d_inode->i_size +=	length;
-	else
-		buf->early_bytes += length;
-
-	smp_mb();
-}
-
-/**
- *	relay_write - write data into the channel
- *	@chan: relay channel
- *	@data: data to be written
- *	@length: number of bytes to write
- *
- *	Writes data into the current cpu's channel buffer.
- *
- *	Protects the buffer by disabling interrupts.  Use this
- *	if you might be logging from interrupt context.  Try
- *	__relay_write() if you know you	won't be logging from
- *	interrupt context.
- */
-static inline void relay_write(struct rchan *chan,
-			       const void *data,
-			       size_t length)
-{
-	size_t remainder = length;
-	struct rchan_buf *buf;
-	unsigned long flags;
-	void *reserved, *reserved2;
-
-	local_irq_save(flags);
-	buf = chan->buf[smp_processor_id()];
-	reserved = buf->data + buf->offset;
-	if (unlikely(buf->offset + length > PAGE_SIZE)) {
-		remainder = chan->cb->switch_page(buf, length, &reserved2);
-		if (unlikely(!reserved2)) {
-			local_irq_restore(flags);
-			return;
-		}
-		length -= remainder;
-		memcpy(reserved2, data + length, remainder);
-	}
-	memcpy(reserved, data, length);
-	buf->offset += remainder;
-	local_irq_restore(flags);
-}
-
-/**
- *	__relay_write - write data into the channel
- *	@chan: relay channel
- *	@data: data to be written
- *	@length: number of bytes to write
- *
- *	Writes data into the current cpu's channel buffer.
- *
- *	Protects the buffer by disabling preemption.  Use
- *	relay_write() if you might be logging from interrupt
- *	context.
- */
-static inline void __relay_write(struct rchan *chan,
-				 const void *data,
-				 size_t length)
-{
-	size_t remainder = length;
-	struct rchan_buf *buf;
-	unsigned long flags;
-	void *reserved, *reserved2;
-
-	buf = chan->buf[get_cpu()];
-	reserved = buf->data + buf->offset;
-	if (unlikely(buf->offset + length > PAGE_SIZE)) {
-		remainder = chan->cb->switch_page(buf, length, &reserved2);
-		if (unlikely(!reserved2)) {
-			local_irq_restore(flags);
-			return;
-		}
-		length -= remainder;
-		memcpy(reserved2, data + length, remainder);
-	}
-	memcpy(reserved, data, length);
-	buf->offset += remainder;
-	put_cpu();
-}
-
-/**
- *	page_start_reserve - reserve bytes at the start of a page
- *	@buf: relay channel buffer
- *	@length: number of bytes to reserve
- *
- *	Helper function used to reserve bytes at the beginning of
- *	a page in the new_page() callback.
- */
-static inline void page_start_reserve(struct rchan_buf *buf,
-				      size_t length)
-{
-	BUG_ON(length >= PAGE_SIZE - 1);
-	buf->offset = length;
-}
-
 /*
  * exported relay file operations, kernel/relay.c
  */
diff --git a/include/linux/relay_pagewriter.h b/include/linux/relay_pagewriter.h
new file mode 100644
index 0000000..8bd230a
--- /dev/null
+++ b/include/linux/relay_pagewriter.h
@@ -0,0 +1,220 @@
+/*
+ * linux/include/linux/relay_pagewriter.h
+ *
+ * Copyright (C) 2002, 2003 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
+ * Copyright (C) 1999, 2000, 2001, 2002 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
+ *
+ * CONFIG_RELAY definitions and declarations
+ */
+
+#ifndef _LINUX_RELAY_PAGEWRITER_H
+#define _LINUX_RELAY_PAGEWRITER_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/kref.h>
+#include <linux/relay.h>
+
+/*
+ * Per-cpu pagewriter buffer
+ */
+struct pagewriter_buf
+{
+	void *data;			/* address of current page */
+	struct relay_page *page;	/* current write page */
+	size_t offset;			/* current offset into page */
+	struct pagewriter *pagewriter;	/* associated channel */
+	struct kref kref;		/* channel buffer refcount */
+	struct list_head pool;		/* current set of unused pages */
+	struct list_head empty_rpage_structs;		/* current set of unused pages */
+	unsigned int cpu;		/* this buf's cpu */
+} ____cacheline_aligned;
+
+/*
+ * Pagewriter data structure
+ */
+struct pagewriter
+{
+	struct rchan *rchan;		/* associated relay channel */
+	struct pagewriter_callbacks *cb;	/* client callbacks */
+	size_t n_pages;			/* number of pages per buffer */
+	struct kref kref;		/* channel refcount */
+	void *private_data;		/* for user-defined data */
+	size_t last_toobig;		/* tried to log event > page size */
+	struct pagewriter_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
+	struct list_head list;		/* for channel list */
+	atomic_t dropped;		/* dropped events due to buffer-full */
+};
+
+extern size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
+						      size_t length,
+						      void **reserved);
+
+/**
+ *	pagewriter_event_toobig - is event too big to fit in a page?
+ *	@buf: relay channel buffer
+ *	@length: length of event
+ *
+ *	Returns 1 if too big, 0 otherwise.
+ *
+ *	switch_page() helper function.
+ */
+static inline int pagewriter_event_toobig(struct pagewriter_buf *buf, size_t length)
+{
+	return length > PAGE_SIZE;
+}
+
+/*
+ * Pagewriter client callbacks
+ */
+struct pagewriter_callbacks
+{
+	/*
+	 * new_page - called on switch to a new page
+	 * @buf: the channel buffer containing the new page
+	 * @page_data: the start of the new page
+	 *
+	 * This is simply a notification that a new page has been
+	 * switched to.  The default version does nothing but call
+	 * relay_wakeup_readers().  Clients who override this callback
+	 * should also call relay_wakeup_readers() to get that default
+	 * behavior in addition to whatever they add.  Clients who
+	 * don't want to wake up readers should just not call it.
+	 * Clients can use the channel private_data to track previous
+	 * pages, determine whether this is the first page, etc.
+	 *
+	 * NOTE: the client can reserve bytes at the beginning of the new
+	 *       page by calling page_start_reserve() in this callback.
+	 */
+	void (*new_page) (struct pagewriter_buf *buf,
+			  void *page_data);
+
+	/*
+	 * switch_page - page switch callback
+	 * @buf: the channel buffer
+	 * @length: size of current event
+	 * @reserved: a pointer to the space reserved
+	 *
+	 * This callback can be used to replace the complete write
+	 * path.  Normally clients wouldn't override this and would
+	 * use the default version instead.
+	 *
+	 * Returns either the length passed in or 0 if full.
+	 *
+	 * Performs page-switch tasks such as updating filesize,
+	 * waking up readers, etc.
+	 */
+	size_t (*switch_page)(struct pagewriter_buf *buf,
+			      size_t length,
+			      void **reserved);
+};
+
+/**
+ *	relay_write - write data into the channel
+ *	@chan: relay channel
+ *	@data: data to be written
+ *	@length: number of bytes to write
+ *
+ *	Writes data into the current cpu's channel buffer.
+ *
+ *	Protects the buffer by disabling interrupts.  Use this
+ *	if you might be logging from interrupt context.  Try
+ *	__relay_write() if you know you	won't be logging from
+ *	interrupt context.
+ */
+static inline void pagewriter_write(struct pagewriter *pagewriter,
+				    const void *data,
+				    size_t length)
+{
+	size_t remainder = length;
+	struct pagewriter_buf *buf;
+	unsigned long flags;
+	void *reserved, *reserved2;
+
+	local_irq_save(flags);
+	buf = pagewriter->buf[smp_processor_id()];
+	reserved = buf->data + buf->offset;
+	if (unlikely(buf->offset + length > PAGE_SIZE)) {
+		remainder = pagewriter->cb->switch_page(buf, length, &reserved2);
+		if (unlikely(!reserved2)) {
+			local_irq_restore(flags);
+			return;
+		}
+		length -= remainder;
+		memcpy(reserved2, data + length, remainder);
+	}
+	memcpy(reserved, data, length);
+	buf->offset += remainder;
+	local_irq_restore(flags);
+}
+
+/**
+ *	__pagewriter_write - write data into the channel
+ *	@chan: relay channel
+ *	@data: data to be written
+ *	@length: number of bytes to write
+ *
+ *	Writes data into the current cpu's channel buffer.
+ *
+ *	Protects the buffer by disabling preemption.  Use
+ *	relay_write() if you might be logging from interrupt
+ *	context.
+ */
+static inline void __pagewriter_write(struct pagewriter *pagewriter,
+				      const void *data,
+				      size_t length)
+{
+	size_t remainder = length;
+	struct pagewriter_buf *buf;
+	unsigned long flags;
+	void *reserved, *reserved2;
+
+	buf = pagewriter->buf[get_cpu()];
+	reserved = buf->data + buf->offset;
+	if (unlikely(buf->offset + length > PAGE_SIZE)) {
+		remainder = pagewriter->cb->switch_page(buf, length, &reserved2);
+		if (unlikely(!reserved2)) {
+			local_irq_restore(flags);
+			return;
+		}
+		length -= remainder;
+		memcpy(reserved2, data + length, remainder);
+	}
+	memcpy(reserved, data, length);
+	buf->offset += remainder;
+	put_cpu();
+}
+
+/**
+ *	page_start_reserve - reserve bytes at the start of a page
+ *	@buf: relay channel buffer
+ *	@length: number of bytes to reserve
+ *
+ *	Helper function used to reserve bytes at the beginning of
+ *	a page in the new_page() callback.
+ */
+static inline void page_start_reserve(struct pagewriter_buf *buf,
+				      size_t length)
+{
+	BUG_ON(length >= PAGE_SIZE - 1);
+	buf->offset = length;
+}
+
+extern struct pagewriter *pagewriter_open(const char *base_filename,
+					  struct dentry *parent,
+					  size_t n_pages,
+					  size_t n_pages_wakeup,
+					  struct pagewriter_callbacks *cb,
+					  void *private_data,
+					  unsigned long rchan_flags);
+extern void pagewriter_close(struct pagewriter *pagewriter);
+extern void pagewriter_flush(struct pagewriter *pagewriter);
+extern void pagewriter_reset(struct pagewriter *pagewriter);
+
+#endif /* _LINUX_RELAY_PAGEWRITER_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 4e1d7df..42f867e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -78,7 +78,7 @@ obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
 endif
-obj-$(CONFIG_RELAY) += relay.o
+obj-$(CONFIG_RELAY) += relay.o relay_pagewriter.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
diff --git a/kernel/relay.c b/kernel/relay.c
index 574b995..e53e729 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2002-2005 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
  * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
  *
  * Moved to kernel/relay.c by Paul Mundt, 2006.
  * November 2006 - CPU hotplug support by Mathieu Desnoyers
@@ -22,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/splice.h>
+#include <linux/debugfs.h>
 
 /* list of open channels, for cpu hotplug */
 static DEFINE_MUTEX(relay_channels_mutex);
@@ -37,98 +39,130 @@ struct relay_page *__relay_get_rpage(struct rchan_buf *buf)
 }
 
 /**
- *	__relay_remove_page - remove a page from relay and add to free pool
+ *	__relay_release_page - remove page from relay and notify owner
  *	@buf: the buffer struct
  *	@rpage: struct relay_page
  */
-static void __relay_remove_page(struct rchan_buf *buf,
-				struct relay_page *rpage)
+static void __relay_release_page(struct rchan_buf *buf,
+				 struct relay_page *rpage)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
 	list_del(&rpage->list);
 	buf->nr_pages--;
-	list_add_tail(&rpage->list, &buf->pool);
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	if (rpage->cb && rpage->cb->page_released)
+		rpage->cb->page_released(rpage->page, rpage->private_data);
+	kfree(rpage);
 }
 
 /**
- *	__relay_add_page - add a relay page to relay
+ *	__relay_remove_page - remove a page from relay
  *	@buf: the buffer struct
  *	@rpage: struct relay_page
  */
-static void __relay_add_page(struct rchan_buf *buf, struct relay_page *rpage)
+static void __relay_remove_page(struct rchan_buf *buf,
+				struct relay_page *rpage)
 {
-	list_add_tail(&rpage->list, &buf->pages);
-	buf->nr_pages++;
-	relay_update_filesize(buf, PAGE_SIZE);
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	list_del(&rpage->list);
+	buf->nr_pages--;
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	kfree(rpage);
 }
 
 /**
- *	relay_add_page - add a page to relay
- *	@buf: the buffer struct
- *	@page: struct page
+ *	relay_update_filesize - increase relay file i_size by length
+ *	@buf: relay channel buffer
+ *	@length: length to add
  *
- *	relay now owns the page.
+ *	switch_page() helper function.
  */
-void relay_add_page(struct rchan_buf *buf, struct page *page)
+static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
 {
-	struct relay_page *rpage = __relay_get_rpage(buf);
+	if (buf->dentry)
+		buf->dentry->d_inode->i_size +=	length;
+	else
+		buf->early_bytes += length;
+}
 
-	if (likely(rpage)) {
-		rpage->page = page;
-		__relay_add_page(buf, rpage);
-	}
+/**
+ *	relay_wakeup_readers - wake up readers if applicable
+ *	@buf: relay channel buffer
+ *
+ *	Called by new_page() default implementation, pulled out for
+ *	the convenience of user-defined new_page() implementations.
+ *
+ *	Will wake up readers after each buf->n_pages_wakeup pages have
+ *	been produced.  To do no waking up, simply pass 0 into relay
+ *	open for this value.
+ */
+static inline void relay_wakeup_readers(struct rchan_buf *buf)
+{
+	size_t wakeup = buf->chan->n_pages_wakeup;
+
+	if (wakeup && (buf->nr_pages % wakeup == 0) &&
+	    (waitqueue_active(&buf->read_wait)))
+		/*
+		 * Calling wake_up_interruptible() from here
+		 * will deadlock if we happen to be logging
+		 * from the scheduler (trying to re-grab
+		 * rq->lock), so defer it.
+		 */
+		__mod_timer(&buf->timer, jiffies + 1);
 }
-EXPORT_SYMBOL_GPL(relay_add_page);
 
 /**
- *	relay_get_page - get a free relay page from the pool
+ *	__relay_add_page - add a relay page to relay
  *	@buf: the buffer struct
- *
- *	Returns relay page if successful, NULL if not.
+ *	@rpage: struct relay_page
  */
-static struct relay_page *relay_get_free_page(struct rchan_buf *buf)
+static void __relay_add_page(struct rchan_buf *buf, struct relay_page *rpage)
 {
-	struct relay_page *rpage = NULL;
+	unsigned long flags;
 
-	if (!list_empty(&buf->pool)) {
-		rpage = list_first_entry(&buf->pool, struct relay_page, list);
-		list_del(&rpage->list);
-	}
+	spin_lock_irqsave(&buf->lock, flags);
+	list_add_tail(&rpage->list, &buf->pages);
+	buf->nr_pages++;
+	relay_update_filesize(buf, PAGE_SIZE);
+	spin_unlock_irqrestore(&buf->lock, flags);
 
-	return rpage;
+	relay_wakeup_readers(buf);
 }
 
 /**
- *	relay_alloc_pool - allocate a pool of pages for writers
+ *	relay_add_page - add a page to relay
  *	@buf: the buffer struct
+ *	@page: struct page
  *
- *	Returns 0 if successful.
+ *	relay now owns the page.
  */
-static int relay_alloc_pool(struct rchan_buf *buf)
+void relay_add_page(struct rchan *chan,
+		    struct page *page,
+		    struct relay_page_callbacks *cb,
+		    void *private_data)
 {
-	unsigned int i;
-	struct relay_page *rpage = NULL;
-
-	for (i = 0; i < buf->chan->n_pages; i++) {
-		rpage = kmalloc(sizeof(struct relay_page), GFP_KERNEL);
-		if (unlikely(!rpage))
-			goto depopulate;
-		rpage->page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-		if (unlikely(!rpage->page))
-			goto depopulate;
-		set_page_private(rpage->page, (unsigned long)buf);
-		list_add_tail(&rpage->list, &buf->pool);
-	}
+	struct relay_page *rpage;
+	struct rchan_buf *buf;
 
-	return 0;
+	buf = chan->buf[get_cpu()];
+	rpage = __relay_get_rpage(buf);
 
-depopulate:
-	list_for_each_entry(rpage, &buf->pool, list) {
-		__free_page(rpage->page);
-		list_del(&rpage->list);
+	if (likely(rpage)) {
+		rpage->page = page;
+		set_page_private(rpage->page, (unsigned long)buf);
+		rpage->cb = cb;
+		rpage->private_data = private_data;
+		__relay_add_page(buf, rpage);
 	}
-
-	return -ENOMEM;
+	put_cpu();
 }
+EXPORT_SYMBOL_GPL(relay_add_page);
 
 /**
  *	relay_create_buf - allocate and initialize a channel buffer
@@ -142,19 +176,12 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 	if (!buf)
 		return NULL;
 
-	INIT_LIST_HEAD(&buf->pool);
+	spin_lock_init(&buf->lock);
 	INIT_LIST_HEAD(&buf->pages);
 	buf->chan = chan;
 	kref_get(&buf->chan->kref);
 
-	if (relay_alloc_pool(buf))
-		goto free_buf;
-
 	return buf;
-
-free_buf:
-	kfree(buf);
-	return NULL;
 }
 
 /**
@@ -178,11 +205,8 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 	struct rchan *chan = buf->chan;
 	struct relay_page *rpage, *rpage2;
 
-	list_for_each_entry_safe(rpage, rpage2, &buf->pool, list) {
-		__free_page(rpage->page);
-		list_del(&rpage->list);
-		kfree(rpage);
-	}
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
+		__relay_release_page(buf, rpage);
 
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf);
@@ -225,39 +249,30 @@ static int relay_buf_empty(struct rchan_buf *buf)
  */
 
 /*
- * create_buf_file_create() default callback.  Does nothing.
+ * create_buf_file_create() default callback.  Creates debugfs file.
  */
 static struct dentry *create_buf_file_default_callback(const char *filename,
 						       struct dentry *parent,
 						       int mode,
 						       struct rchan_buf *buf)
 {
-	return NULL;
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
 }
 
 /*
- * remove_buf_file() default callback.  Does nothing.
+ * remove_buf_file() default callback.  Removes debugfs file.
  */
 static int remove_buf_file_default_callback(struct dentry *dentry)
 {
-	return -EINVAL;
-}
-
-/*
- * new_page() default callback.
- */
-static void new_page_default_callback(struct rchan_buf *buf,
-				      void *page_data)
-{
-	relay_wakeup_readers(buf);
+	debugfs_remove(dentry);
+	return 0;
 }
 
 /* relay channel default callbacks */
 static struct rchan_callbacks default_channel_callbacks = {
-	.new_page = new_page_default_callback,
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
-	.switch_page = relay_switch_page_default_callback,
 };
 
 /**
@@ -272,6 +287,8 @@ static void wakeup_readers(unsigned long data)
 	wake_up_interruptible(&buf->read_wait);
 }
 
+
+
 /**
  *	__relay_reset - reset a channel buffer
  *	@buf: the channel buffer
@@ -290,11 +307,6 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 
 	buf->consumed_offset = 0;
 	buf->finalized = 0;
-	buf->page = relay_get_free_page(buf);
-	buf->data = page_address(buf->page->page);
-	buf->offset = 0;
-
-	buf->chan->cb->new_page(buf, buf->data);
 }
 
 /**
@@ -411,7 +423,7 @@ static void relay_close_buf(struct rchan_buf *buf)
 }
 
 static void setup_callbacks(struct rchan *chan,
-				   struct rchan_callbacks *cb)
+			    struct rchan_callbacks *cb)
 {
 	if (!cb) {
 		chan->cb = &default_channel_callbacks;
@@ -422,60 +434,13 @@ static void setup_callbacks(struct rchan *chan,
 		cb->create_buf_file = create_buf_file_default_callback;
 	if (!cb->remove_buf_file)
 		cb->remove_buf_file = remove_buf_file_default_callback;
-	if (!cb->new_page)
-		cb->new_page = new_page_default_callback;
-	if (!cb->switch_page)
-		cb->switch_page = relay_switch_page_default_callback;
 	chan->cb = cb;
 }
 
 /**
- * 	relay_hotcpu_callback - CPU hotplug callback
- * 	@nb: notifier block
- * 	@action: hotplug action to take
- * 	@hcpu: CPU number
- *
- * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
- */
-static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
-				unsigned long action,
-				void *hcpu)
-{
-	unsigned int hotcpu = (unsigned long)hcpu;
-	struct rchan *chan;
-
-	switch(action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		mutex_lock(&relay_channels_mutex);
-		list_for_each_entry(chan, &relay_channels, list) {
-			if (chan->buf[hotcpu])
-				continue;
-			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
-			if(!chan->buf[hotcpu]) {
-				printk(KERN_ERR
-					"relay_hotcpu_callback: cpu %d buffer "
-					"creation failed\n", hotcpu);
-				mutex_unlock(&relay_channels_mutex);
-				return NOTIFY_BAD;
-			}
-		}
-		mutex_unlock(&relay_channels_mutex);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		/* No need to flush the cpu : will be flushed upon
-		 * final relay_flush() call. */
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-/**
  *	relay_open - create a new relay channel
  *	@base_filename: base name of files to create, %NULL for buffering only
  *	@parent: dentry of parent directory, %NULL for root directory or buffer
- *	@n_pages: number of pages to use for each buffer
  *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
  *	@cb: client callback functions
  *	@private_data: user-defined data
@@ -489,7 +454,6 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
  */
 struct rchan *relay_open(const char *base_filename,
 			 struct dentry *parent,
-			 size_t n_pages,
 			 size_t n_pages_wakeup,
 			 struct rchan_callbacks *cb,
 			 void *private_data,
@@ -498,19 +462,13 @@ struct rchan *relay_open(const char *base_filename,
 	unsigned int i;
 	struct rchan *chan;
 
-	if (!n_pages)
-		return NULL;
-
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
 	if (!chan)
 		return NULL;
 
-	chan->version = RELAYFS_CHANNEL_VERSION;
-	chan->n_pages = n_pages;
 	chan->n_pages_wakeup = n_pages_wakeup;
 	chan->parent = parent;
 	chan->flags = rchan_flags;
-	atomic_set(&chan->dropped, 0);
 
 	chan->private_data = private_data;
 	if (base_filename) {
@@ -633,59 +591,6 @@ int relay_late_setup_files(struct rchan *chan,
 }
 
 /**
- *	relay_switch_page_default_callback - switch to a new page
- *	@buf: channel buffer
- *	@length: size of current event
- *	@reserved: a pointer to the space reserved
- *
- *	Returns either the length passed in or 0 if full.
- *
- *	Performs page-switch tasks such as invoking callbacks,
- *	waking up readers, etc.
- */
-size_t relay_switch_page_default_callback(struct rchan_buf *buf,
-					  size_t length,
-					  void **reserved)
-{
-	size_t remainder;
-	struct relay_page *new_page;
-
-	if (unlikely(relay_event_toobig(buf, length)))
-		goto toobig;
-
-	/* don't write anything unless we can write it all. */
-	new_page = relay_get_free_page(buf);
-	if (!new_page) {
-		if (reserved)
-			*reserved = NULL;
-		atomic_inc(&buf->chan->dropped);
-		return 0;
-	}
-
-	remainder = length - (PAGE_SIZE - buf->offset);
-
-	__relay_add_page(buf, buf->page);
-
-	buf->page = new_page;
-	buf->data = page_address(buf->page->page);
-
-	buf->offset = 0; /* remainder will be added by caller */
-	buf->chan->cb->new_page(buf, buf->data);
-
-	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
-		goto toobig;
-
-	if (reserved)
-		*reserved = buf->data;
-
-	return remainder;
-toobig:
-	buf->chan->last_toobig = length;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(relay_switch_page_default_callback);
-
-/**
  *	relay_close - close the channel
  *	@chan: the channel
  *
@@ -706,11 +611,6 @@ void relay_close(struct rchan *chan)
 			if (chan->buf[i])
 				relay_close_buf(chan->buf[i]);
 
-	if (chan->last_toobig)
-		printk(KERN_WARNING "relay: one or more items not logged "
-		       "[item size (%Zd) > PAGE_SIZE (%lu)]\n",
-		       chan->last_toobig, PAGE_SIZE);
-
 	list_del(&chan->list);
 	kref_put(&chan->kref, relay_destroy_channel);
 	mutex_unlock(&relay_channels_mutex);
@@ -735,7 +635,6 @@ void relay_flush(struct rchan *chan)
 		chan->n_pages_wakeup = 1;
 
 	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
-		chan->cb->switch_page(chan->buf[0], 0, NULL);
 		chan->n_pages_wakeup = prev_wakeup;
 		return;
 	}
@@ -743,7 +642,7 @@ void relay_flush(struct rchan *chan)
 	mutex_lock(&relay_channels_mutex);
 	for_each_possible_cpu(i)
 		if (chan->buf[i])
-			chan->cb->switch_page(chan->buf[i], 0, NULL);
+			relay_wakeup_readers(chan->buf[i]);
 	mutex_unlock(&relay_channels_mutex);
 	chan->n_pages_wakeup = prev_wakeup;
 }
@@ -829,7 +728,7 @@ static void relay_consume(struct rchan_buf *buf, int bytes_consumed)
 	if (buf->consumed_offset == PAGE_SIZE) {
 		struct relay_page *rpage;
 		rpage = list_first_entry(&buf->pages, struct relay_page, list);
-		__relay_remove_page(buf, rpage); 
+		__relay_release_page(buf, rpage);
 
 		buf->consumed_offset = 0;
 	}
@@ -917,12 +816,32 @@ static ssize_t relay_file_read(struct file *filp,
 }
 
 static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
-				   struct pipe_buffer *buf)
+				   struct pipe_buffer *pipe_buf)
 {
-	struct rchan_buf *rbuf;
+	struct rchan_buf *buf;
+
+	buf = (struct rchan_buf *)page_private(pipe_buf->page);
+	relay_consume(buf, pipe_buf->private);
+}
+
+static int relay_pipe_buf_steal(struct pipe_inode_info *pipe,
+				struct pipe_buffer *pipe_buf)
+{
+	int ret;
+	struct rchan_buf *buf;
 
-	rbuf = (struct rchan_buf *)page_private(buf->page);
-	relay_consume(rbuf, buf->private);
+	buf = (struct rchan_buf *)page_private(pipe_buf->page);
+	ret = generic_pipe_buf_steal(pipe, pipe_buf);
+	if (!ret) {
+		struct relay_page *rpage;
+		rpage = list_first_entry(&buf->pages, struct relay_page, list);
+		__relay_remove_page(buf, rpage);
+		if (rpage->cb && rpage->cb->page_stolen)
+			rpage->cb->page_stolen(pipe_buf->page,
+					       rpage->private_data);
+	}
+
+	return ret;
 }
 
 static struct pipe_buf_operations relay_pipe_buf_ops = {
@@ -931,7 +850,7 @@ static struct pipe_buf_operations relay_pipe_buf_ops = {
 	.unmap = generic_pipe_buf_unmap,
 	.confirm = generic_pipe_buf_confirm,
 	.release = relay_pipe_buf_release,
-	.steal = generic_pipe_buf_steal,
+	.steal = relay_pipe_buf_steal,
 	.get = generic_pipe_buf_get,
 };
 
@@ -1044,9 +963,50 @@ const struct file_operations relay_file_operations = {
 };
 EXPORT_SYMBOL_GPL(relay_file_operations);
 
-static __init int relay_init(void)
+/**
+ * 	relay_hotcpu_callback - CPU hotplug callback
+ * 	@nb: notifier block
+ * 	@action: hotplug action to take
+ * 	@hcpu: CPU number
+ *
+ * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
+ */
+static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
+				unsigned long action,
+				void *hcpu)
 {
+	unsigned int hotcpu = (unsigned long)hcpu;
+	struct rchan *chan;
 
+	switch(action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		mutex_lock(&relay_channels_mutex);
+		list_for_each_entry(chan, &relay_channels, list) {
+			if (chan->buf[hotcpu])
+				continue;
+			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
+			if(!chan->buf[hotcpu]) {
+				printk(KERN_ERR
+					"relay_hotcpu_callback: cpu %d buffer "
+					"creation failed\n", hotcpu);
+				mutex_unlock(&relay_channels_mutex);
+				return NOTIFY_BAD;
+			}
+		}
+		mutex_unlock(&relay_channels_mutex);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		/* No need to flush the cpu : will be flushed upon
+		 * final relay_flush() call. */
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static __init int relay_init(void)
+{
 	hotcpu_notifier(relay_hotcpu_callback, 0);
 	return 0;
 }
diff --git a/kernel/relay_pagewriter.c b/kernel/relay_pagewriter.c
new file mode 100644
index 0000000..1f566a5
--- /dev/null
+++ b/kernel/relay_pagewriter.c
@@ -0,0 +1,545 @@
+/*
+ * Page writers for relay interface.
+ *
+ * See Documentation/filesystems/relay.txt for an overview.
+ *
+ * Copyright (C) 2002-2005 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
+ * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
+ * Copyright (C) 2008 - Tom Zanussi (tzanussi@gmail.com)
+ *
+ * Moved to kernel/relay.c by Paul Mundt, 2006.
+ * November 2006 - CPU hotplug support by Mathieu Desnoyers
+ * 	(mathieu.desnoyers@polymtl.ca)
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/errno.h>
+#include <linux/stddef.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/relay.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/splice.h>
+#include <linux/relay_pagewriter.h>
+#include <linux/debugfs.h>
+
+/* list of open pagewriters, for cpu hotplug */
+static DEFINE_MUTEX(pagewriters_mutex);
+static LIST_HEAD(pagewriters);
+
+/**
+ *	pagewriter_get_free_page - get a free relay page from the pool
+ *	@buf: the buffer struct
+ *
+ *	Returns relay page if successful, NULL if not.
+ */
+static struct relay_page *pagewriter_get_free_page(struct pagewriter_buf *buf)
+{
+	struct relay_page *rpage = NULL;
+
+	if (!list_empty(&buf->pool)) {
+		rpage = list_first_entry(&buf->pool, struct relay_page, list);
+		list_del(&rpage->list);
+	}
+
+	return rpage;
+}
+
+static void pagewriter_add_free_page(struct pagewriter_buf *buf,
+				     struct relay_page *rpage)
+{
+	list_add_tail(&rpage->list, &buf->pool);
+}
+
+/**
+ *	get_empty_rpage_struct - get a free relay page from the pool
+ *	@buf: the buffer struct
+ *
+ *	Returns relay page if successful, NULL if not.
+ */
+static struct relay_page *get_empty_rpage_struct(struct pagewriter_buf *buf)
+{
+	struct relay_page *rpage = NULL;
+
+	if (!list_empty(&buf->empty_rpage_structs)) {
+		rpage = list_first_entry(&buf->empty_rpage_structs,
+					 struct relay_page, list);
+		list_del(&rpage->list);
+	}
+
+	return rpage;
+}
+
+/**
+ *	add_empty_rpage_struct - add a relay page to relay
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
+ */
+static void add_empty_rpage_struct(struct pagewriter_buf *buf,
+				   struct relay_page *rpage)
+{
+	list_add_tail(&rpage->list, &buf->empty_rpage_structs);
+}
+
+/**
+ *	pagewriter_alloc_pool - allocate a pool of pages for writers
+ *	@buf: the buffer struct
+ *
+ *	Returns 0 if successful.
+ */
+static int pagewriter_alloc_pool(struct pagewriter_buf *buf)
+{
+	unsigned int i;
+	struct relay_page *rpage = NULL;
+
+	for (i = 0; i < buf->pagewriter->n_pages; i++) {
+		rpage = kmalloc(sizeof(struct relay_page), GFP_KERNEL);
+		if (unlikely(!rpage))
+			goto depopulate;
+		rpage->page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (unlikely(!rpage->page))
+			goto depopulate;
+		list_add_tail(&rpage->list, &buf->pool);
+	}
+
+	return 0;
+
+depopulate:
+	list_for_each_entry(rpage, &buf->pool, list) {
+		__free_page(rpage->page);
+		list_del(&rpage->list);
+	}
+
+	return -ENOMEM;
+}
+
+/**
+ *	pagewriter_create_buf - allocate and initialize a channel buffer
+ *	@chan: the relay channel
+ *
+ *	Returns channel buffer if successful, %NULL otherwise.
+ */
+static struct pagewriter_buf *pagewriter_create_buf(struct pagewriter *pagewriter)
+{
+	struct pagewriter_buf *buf = kzalloc(sizeof(struct pagewriter_buf),
+					     GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	INIT_LIST_HEAD(&buf->pool);
+	INIT_LIST_HEAD(&buf->empty_rpage_structs);
+	buf->pagewriter = pagewriter;
+	kref_get(&buf->pagewriter->kref);
+
+	if (pagewriter_alloc_pool(buf))
+		goto free_buf;
+
+	return buf;
+
+free_buf:
+	kfree(buf);
+	return NULL;
+}
+
+/**
+ *	__pagewriter_reset - reset a pagewriter
+ *	@buf: the channel buffer
+ *	@init: 1 if this is a first-time initialization
+ *
+ *	See relay_reset() for description of effect.
+ */
+static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init)
+{
+	if (init)
+		kref_init(&buf->kref);
+
+	buf->page = pagewriter_get_free_page(buf);
+	buf->data = page_address(buf->page->page);
+	buf->offset = 0;
+
+	buf->pagewriter->cb->new_page(buf, buf->data);
+}
+
+/**
+ *	pagewriter_destroy - free the pagewriter struct
+ *	@kref: target kernel reference that contains the relay channel
+ *
+ *	Should only be called from kref_put().
+ */
+static void pagewriter_destroy(struct kref *kref)
+{
+	struct pagewriter *pagewriter = container_of(kref, struct pagewriter,
+						     kref);
+	kfree(pagewriter);
+}
+
+/**
+ *	pagewriter_destroy_buf - destroy a pagewriter_buf struct and associated buffer
+ *	@buf: the buffer struct
+ */
+static void pagewriter_destroy_buf(struct pagewriter_buf *buf)
+{
+	struct pagewriter *pagewriter = buf->pagewriter;
+	struct relay_page *rpage, *rpage2;
+
+	list_for_each_entry_safe(rpage, rpage2, &buf->pool, list) {
+		__free_page(rpage->page);
+		list_del(&rpage->list);
+		kfree(rpage);
+	}
+
+	pagewriter->buf[buf->cpu] = NULL;
+	kfree(buf);
+	kref_put(&pagewriter->kref, pagewriter_destroy);
+}
+
+/**
+ *	pagewriter_remove_buf - remove a pagewriter buffer
+ *	@kref: target kernel reference that contains the relay buffer
+ *
+ *	Removes the file from the fileystem, which also frees the
+ *	rchan_buf_struct and the channel buffer.  Should only be called from
+ *	kref_put().
+ */
+static void pagewriter_remove_buf(struct kref *kref)
+{
+	struct pagewriter_buf *buf = container_of(kref, struct pagewriter_buf,
+						  kref);
+	pagewriter_destroy_buf(buf);
+}
+
+/*
+ *	pagewriter_open_buf - create a new relay channel buffer
+ *
+ *	used by pagewriter_open() and CPU hotplug.
+ */
+static struct pagewriter_buf *pagewriter_open_buf(struct pagewriter *pagewriter,
+					     unsigned int cpu)
+{
+ 	struct pagewriter_buf *buf = NULL;
+
+	buf = pagewriter_create_buf(pagewriter);
+	if (!buf)
+		return NULL;
+
+ 	buf->cpu = cpu;
+
+ 	__pagewriter_reset(buf, 1);
+
+	return buf;
+}
+
+/*
+ * new_page() default callback.
+ */
+static void new_page_default_callback(struct pagewriter_buf *buf,
+				      void *page_data)
+{
+}
+
+/* pagewriter default callbacks */
+static struct pagewriter_callbacks default_pagewriter_callbacks = {
+	.new_page = new_page_default_callback,
+	.switch_page = pagewriter_switch_page_default_callback,
+};
+
+static void setup_callbacks(struct pagewriter *pagewriter,
+			    struct pagewriter_callbacks *cb)
+{
+	if (!cb) {
+		pagewriter->cb = &default_pagewriter_callbacks;
+		return;
+	}
+
+	if (!cb->new_page)
+		cb->new_page = new_page_default_callback;
+	if (!cb->switch_page)
+		cb->switch_page = pagewriter_switch_page_default_callback;
+	pagewriter->cb = cb;
+}
+
+/**
+ *	pagewriter_close_buf - close a pagewriter buffer
+ *	@buf: channel buffer
+ *
+ *	Marks the buffer finalized and restores the default callbacks.
+ *	The channel buffer and channel buffer data structure are then freed
+ *	automatically when the last reference is given up.
+ */
+static void pagewriter_close_buf(struct pagewriter_buf *buf)
+{
+	kref_put(&buf->kref, pagewriter_remove_buf);
+}
+
+/**
+ *	pagewriter_open - create a new relay channel
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
+ *	@n_pages: number of pages to use for each buffer
+ *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
+ *	@cb: client callback functions
+ *	@private_data: user-defined data
+ *
+ *	Returns channel pointer if successful, %NULL otherwise.
+ *
+ *	Creates a channel buffer for each cpu using the sizes and
+ *	attributes specified.  The created channel buffer files
+ *	will be named base_filename0...base_filenameN-1.  File
+ *	permissions will be %S_IRUSR.
+ */
+struct pagewriter *pagewriter_open(const char *base_filename,
+				   struct dentry *parent,
+				   size_t n_pages,
+				   size_t n_pages_wakeup,
+				   struct pagewriter_callbacks *cb,
+				   void *private_data,
+				   unsigned long rchan_flags)
+{
+	unsigned int i;
+	struct pagewriter *pagewriter;
+	struct rchan *rchan;
+
+	if (!n_pages)
+		return NULL;
+
+	rchan = relay_open(base_filename, parent, n_pages_wakeup, NULL,
+			   private_data, rchan_flags);
+	if (!rchan)
+		return NULL;
+
+	pagewriter = kzalloc(sizeof(struct pagewriter), GFP_KERNEL);
+	if (!pagewriter) {
+		relay_close(rchan);
+		return NULL;
+	}
+
+	pagewriter->rchan = rchan;
+	pagewriter->n_pages = n_pages;
+	atomic_set(&pagewriter->dropped, 0);
+
+	pagewriter->private_data = private_data;
+	setup_callbacks(pagewriter, cb);
+	kref_init(&pagewriter->kref);
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_online_cpu(i) {
+		pagewriter->buf[i] = pagewriter_open_buf(pagewriter, i);
+		if (!pagewriter->buf[i])
+			goto free_bufs;
+	}
+	list_add(&pagewriter->list, &pagewriters);
+	mutex_unlock(&pagewriters_mutex);
+
+	return pagewriter;
+
+free_bufs:
+	for_each_online_cpu(i) {
+		if (!pagewriter->buf[i])
+			break;
+		pagewriter_close_buf(pagewriter->buf[i]);
+	}
+
+	kfree(pagewriter);
+	relay_close(rchan);
+	kref_put(&pagewriter->kref, pagewriter_destroy);
+	mutex_unlock(&pagewriters_mutex);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(pagewriter_open);
+
+static void pagewriter_page_released_callback(struct page *page,
+					      void *private_data)
+{
+	struct pagewriter_buf *buf = private_data;
+	struct relay_page *rpage = get_empty_rpage_struct(buf);
+
+	rpage->page = page;
+	pagewriter_add_free_page(buf, rpage);
+}
+
+static void pagewriter_page_stolen_callback(struct page *page,
+					    void *private_data)
+{
+	struct pagewriter_buf *buf = private_data;
+	struct relay_page *rpage;
+	struct page *new_page;
+
+	new_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (unlikely(!new_page))
+		return;
+	set_page_private(new_page, (unsigned long)buf);
+	rpage = get_empty_rpage_struct(buf);
+
+	rpage->page = new_page;
+	pagewriter_add_free_page(buf, rpage);
+}
+
+static struct relay_page_callbacks pagewriter_relay_page_callbacks = {
+	.page_released	= pagewriter_page_released_callback,
+	.page_stolen	= pagewriter_page_stolen_callback,
+};
+
+/**
+ *	pagewriter_switch_page_default_callback - switch to a new page
+ *	@buf: channel buffer
+ *	@length: size of current event
+ *	@reserved: a pointer to the space reserved
+ *
+ *	Returns either the length passed in or 0 if full.
+ *
+ *	Performs page-switch tasks such as invoking callbacks,
+ *	waking up readers, etc.
+ */
+size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
+					       size_t length,
+					       void **reserved)
+{
+	size_t remainder;
+	struct relay_page *new_page;
+
+	if (unlikely(pagewriter_event_toobig(buf, length)))
+		goto toobig;
+
+	/* don't write anything unless we can write it all. */
+	new_page = pagewriter_get_free_page(buf);
+	if (!new_page) {
+		if (reserved)
+			*reserved = NULL;
+		atomic_inc(&buf->pagewriter->dropped);
+		return 0;
+	}
+
+	remainder = length - (PAGE_SIZE - buf->offset);
+
+	relay_add_page(buf->pagewriter->rchan, buf->page->page,
+		       &pagewriter_relay_page_callbacks, (void *)buf);
+
+	buf->page->page = NULL;
+	add_empty_rpage_struct(buf, buf->page);
+
+	buf->page = new_page;
+	buf->data = page_address(buf->page->page);
+
+	buf->offset = 0; /* remainder will be added by caller */
+	buf->pagewriter->cb->new_page(buf, buf->data);
+
+	if (unlikely(pagewriter_event_toobig(buf, length + buf->offset)))
+		goto toobig;
+
+	if (reserved)
+		*reserved = buf->data;
+
+	return remainder;
+toobig:
+	buf->pagewriter->last_toobig = length;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pagewriter_switch_page_default_callback);
+
+/**
+ *	pagewriter_close - close the pagewriter
+ *	@chan: the channel
+ *
+ *	Closes all channel buffers and frees the channel.
+ */
+void pagewriter_close(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_possible_cpu(i)
+		if (pagewriter->buf[i])
+			pagewriter_close_buf(pagewriter->buf[i]);
+
+	relay_close(pagewriter->rchan);
+	if (pagewriter->last_toobig)
+		printk(KERN_WARNING "pagewriter: one or more items not logged "
+		       "[item size (%Zd) > PAGE_SIZE (%lu)]\n",
+		       pagewriter->last_toobig, PAGE_SIZE);
+
+	list_del(&pagewriter->list);
+	kref_put(&pagewriter->kref, pagewriter_destroy);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_close);
+
+/**
+ *	pagewriter_flush - close the channel
+ *	@chan: the channel
+ *
+ *	Flushes all channel buffers, i.e. forces buffer switch.
+ */
+void pagewriter_flush(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_possible_cpu(i)
+		if (pagewriter->buf[i])
+			pagewriter->cb->switch_page(pagewriter->buf[i], 0, NULL);
+	relay_flush(pagewriter->rchan);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_flush);
+
+
+/**
+ * 	pagewriter_hotcpu_callback - CPU hotplug callback
+ * 	@nb: notifier block
+ * 	@action: hotplug action to take
+ * 	@hcpu: CPU number
+ *
+ * 	Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
+ */
+static int __cpuinit pagewriter_hotcpu_callback(struct notifier_block *nb,
+						unsigned long action,
+						void *hcpu)
+{
+	unsigned int hotcpu = (unsigned long)hcpu;
+	struct pagewriter *pagewriter;
+
+	switch(action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		mutex_lock(&pagewriters_mutex);
+		list_for_each_entry(pagewriter, &pagewriters, list) {
+			if (pagewriter->buf[hotcpu])
+				continue;
+			pagewriter->buf[hotcpu] = pagewriter_open_buf(pagewriter,
+								      hotcpu);
+			if(!pagewriter->buf[hotcpu]) {
+				printk(KERN_ERR
+					"pagewriter_hotcpu_callback: cpu %d "
+				        "buffer creation failed\n", hotcpu);
+				mutex_unlock(&pagewriters_mutex);
+				return NOTIFY_BAD;
+			}
+		}
+		mutex_unlock(&pagewriters_mutex);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		/* No need to flush the cpu : will be flushed upon
+		 * final relay_flush() call. */
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static __init int pagewriter_init(void)
+{
+
+	hotcpu_notifier(pagewriter_hotcpu_callback, 0);
+	return 0;
+}
+
+early_initcall(pagewriter_init);
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 9373b34..5560635 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -15,7 +15,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/relay.h>
+#include <linux/relay_pagewriter.h>
 #include <linux/debugfs.h>
 
 #include <linux/kvm_host.h>
@@ -26,7 +26,7 @@
 
 struct kvm_trace {
 	int trace_state;
-	struct rchan *rchan;
+	struct pagewriter *pagewriter;
 	struct dentry *lost_file;
 	int first_page;
 };
@@ -82,7 +82,7 @@ static void kvm_add_trace(void *probe_private, void *call_data,
 	}
 
 	size = calc_rec_size(rec.cycle_in, rec.extra_u32 * sizeof(u32));
-	relay_write(kt->rchan, &rec, size);
+	pagewriter_write(kt->pagewriter, &rec, size);
 }
 
 static struct kvm_trace_probe kvm_trace_probes[] = {
@@ -94,7 +94,7 @@ static int lost_records_get(void *data, u64 *val)
 {
 	struct kvm_trace *kt = data;
 
-	*val = atomic_read(&kt->rchan->dropped);
+	*val = atomic_read(&kt->pagewriter->dropped);
 	return 0;
 }
 
@@ -105,12 +105,10 @@ DEFINE_SIMPLE_ATTRIBUTE(kvm_trace_lost_ops, lost_records_get, NULL, "%llu\n");
  *  many times we encountered a full subbuffer, to tell user space app the
  *  lost records there were.
  */
-static void kvm_new_page_callback(struct rchan_buf *buf,
+static void kvm_new_page_callback(struct pagewriter_buf *buf,
 				  void *page_data)
 {
-	struct kvm_trace *kt = buf->chan->private_data;
-
-	relay_wakeup_readers(buf);
+	struct kvm_trace *kt = buf->pagewriter->private_data;
 
 	if (kt->first_page) {
 		/*
@@ -123,25 +121,8 @@ static void kvm_new_page_callback(struct rchan_buf *buf,
 	}
 }
 
-static struct dentry *kvm_create_buf_file_callack(const char *filename,
-						  struct dentry *parent,
-						  int mode,
-						  struct rchan_buf *buf)
-{
-	return debugfs_create_file(filename, mode, parent, buf,
-				   &relay_file_operations);
-}
-
-static int kvm_remove_buf_file_callback(struct dentry *dentry)
-{
-	debugfs_remove(dentry);
-	return 0;
-}
-
-static struct rchan_callbacks kvm_relay_callbacks = {
+static struct pagewriter_callbacks kvm_pagewriter_callbacks = {
 	.new_page		= kvm_new_page_callback,
-	.create_buf_file 	= kvm_create_buf_file_callack,
-	.remove_buf_file 	= kvm_remove_buf_file_callback,
 };
 
 static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
@@ -166,9 +147,10 @@ static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
 
 	n_pages = (kuts->buf_size * kuts->buf_nr) / PAGE_SIZE;
 	n_pages_wakeup = kuts->buf_size / PAGE_SIZE;
-	kt->rchan = relay_open("trace", kvm_debugfs_dir, n_pages,
-			       n_pages_wakeup, &kvm_relay_callbacks, kt, 0UL);
-	if (!kt->rchan)
+	kt->pagewriter = pagewriter_open("trace", kvm_debugfs_dir, n_pages,
+					 n_pages_wakeup,
+					 &kvm_pagewriter_callbacks, kt, 0UL);
+	if (!kt->pagewriter)
 		goto err;
 
 	kvm_trace = kt;
@@ -189,8 +171,8 @@ err:
 	if (kt) {
 		if (kt->lost_file)
 			debugfs_remove(kt->lost_file);
-		if (kt->rchan)
-			relay_close(kt->rchan);
+		if (kt->pagewriter)
+			pagewriter_close(kt->pagewriter);
 		kfree(kt);
 	}
 	return r;
@@ -222,7 +204,7 @@ static int kvm_trace_pause(void)
 
 	if (kt->trace_state == KVM_TRACE_STATE_RUNNING) {
 		kt->trace_state = KVM_TRACE_STATE_PAUSE;
-		relay_flush(kt->rchan);
+		pagewriter_flush(kt->pagewriter);
 		r = 0;
 	}
 
@@ -247,7 +229,7 @@ void kvm_trace_cleanup(void)
 			marker_probe_unregister(p->name, p->probe_func, p);
 		}
 
-		relay_close(kt->rchan);
+		pagewriter_close(kt->pagewriter);
 		debugfs_remove(kt->lost_file);
 		kfree(kt);
 	}
-- 
1.5.3.5



