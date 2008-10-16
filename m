Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYJPGR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYJPGR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYJPGNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:13:14 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:59414 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915AbYJPGNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:13:10 -0400
X-Authority-Analysis: v=1.0 c=1 a=RF41OZ9uZGwA:10 a=HGpZt2s1RSMA:10
 a=V3NWXwn7KudRqiPAeQ8A:9 a=ZlN3WdkC3nvnWeGAms4A:7
 a=eVVRqerOQl7Q91Qs7bADkZgHx94A:4 a=i92e0Ub4el8A:10 a=d_-3mwAUsuEA:10
 a=rPt6xJ-oxjAA:10
Subject: [RFC PATCH 17/21]  Major cleanup, moving things around,
	documenting, etc
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
Date: Thu, 16 Oct 2008 01:06:40 -0500
Message-Id: <1224137201.16328.236.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/linux/relay.h            |   52 +--
 include/linux/relay_pagewriter.h |   72 ++---
 kernel/relay.c                   |  700 +++++++++++++++++++-------------------
 kernel/relay_pagewriter.c        |  513 ++++++++++++++++------------
 4 files changed, 698 insertions(+), 639 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 1dbed4e..99f79db 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -26,8 +26,10 @@
  */
 #define RCHAN_GLOBAL_BUFFER		0x00000001	/* not using per-cpu */
 
-struct relay_page
-{
+/*
+ * For page lists
+ */
+struct relay_page {
 	struct page *page;
 	struct list_head list;
 	struct relay_page_callbacks *cb;
@@ -37,17 +39,16 @@ struct relay_page
 /*
  * Per-cpu relay channel buffer
  */
-struct rchan_buf
-{
+struct rchan_buf {
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
 	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
 	struct list_head pages;		/* current set of unconsumed pages */
+	size_t nr_pages;		/* number of unconsumed pages */
 	spinlock_t lock;		/* protect pages list */
 	size_t consumed_offset;		/* bytes consumed in cur page */
-	size_t nr_pages;		/* number of unconsumed pages */
 	unsigned int finalized;		/* buffer has been finalized */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
@@ -115,40 +116,25 @@ struct rchan_callbacks
 struct relay_page_callbacks
 {
 	/*
-	 * page_released - called on switch to a new page
-	 * @buf: the channel buffer containing the new page
-	 * @page_data: the start of the new page
+	 * page_released - notification that a page is ready for re-use
+	 * @page: the released page
+	 * @private_data: user-defined data associated with the page
 	 *
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
+	 * This callback is a notification that a given page has been
+	 * read by userspace and can be re-used.  Always called in
+	 * user context.
 	 */
 	void (*page_released) (struct page *page, void *private_data);
 
 	/*
-	 * page_stolen - called on switch to a new page
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
+	 * page_released - notification that a page has been stolen
+	 * @page: the stolen page
+	 * @private_data: user-defined data associated with the page
 	 *
-	 * NOTE: the client can reserve bytes at the beginning of the new
-	 *       page by calling page_start_reserve() in this callback.
+	 * This callback is a notification that a given page has been
+	 * stolen by userspace.  The owner may wish to replace it;
+	 * this gives it the opportunity to do so.  Always called in
+	 * user context.
 	 */
 	void (*page_stolen) (struct page *page, void *private_data);
 };
diff --git a/include/linux/relay_pagewriter.h b/include/linux/relay_pagewriter.h
index 8bd230a..2476ef6 100644
--- a/include/linux/relay_pagewriter.h
+++ b/include/linux/relay_pagewriter.h
@@ -24,23 +24,21 @@
 /*
  * Per-cpu pagewriter buffer
  */
-struct pagewriter_buf
-{
-	void *data;			/* address of current page */
+struct pagewriter_buf {
 	struct relay_page *page;	/* current write page */
+	void *data;			/* address of current page */
 	size_t offset;			/* current offset into page */
-	struct pagewriter *pagewriter;	/* associated channel */
+	struct pagewriter *pagewriter;	/* associated pagewriter */
 	struct kref kref;		/* channel buffer refcount */
 	struct list_head pool;		/* current set of unused pages */
-	struct list_head empty_rpage_structs;		/* current set of unused pages */
+	struct list_head empty_rpage_structs;	/* cached rpage structs */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
 
 /*
  * Pagewriter data structure
  */
-struct pagewriter
-{
+struct pagewriter {
 	struct rchan *rchan;		/* associated relay channel */
 	struct pagewriter_callbacks *cb;	/* client callbacks */
 	size_t n_pages;			/* number of pages per buffer */
@@ -52,20 +50,21 @@ struct pagewriter
 	atomic_t dropped;		/* dropped events due to buffer-full */
 };
 
-extern size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
+extern size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *b,
 						      size_t length,
 						      void **reserved);
 
 /**
  *	pagewriter_event_toobig - is event too big to fit in a page?
- *	@buf: relay channel buffer
+ *	@buf: pagewriter channel buffer
  *	@length: length of event
  *
  *	Returns 1 if too big, 0 otherwise.
  *
  *	switch_page() helper function.
  */
-static inline int pagewriter_event_toobig(struct pagewriter_buf *buf, size_t length)
+static inline int pagewriter_event_toobig(struct pagewriter_buf *buf,
+					  size_t length)
 {
 	return length > PAGE_SIZE;
 }
@@ -73,21 +72,16 @@ static inline int pagewriter_event_toobig(struct pagewriter_buf *buf, size_t len
 /*
  * Pagewriter client callbacks
  */
-struct pagewriter_callbacks
-{
+struct pagewriter_callbacks {
 	/*
 	 * new_page - called on switch to a new page
 	 * @buf: the channel buffer containing the new page
 	 * @page_data: the start of the new page
 	 *
 	 * This is simply a notification that a new page has been
-	 * switched to.  The default version does nothing but call
-	 * relay_wakeup_readers().  Clients who override this callback
-	 * should also call relay_wakeup_readers() to get that default
-	 * behavior in addition to whatever they add.  Clients who
-	 * don't want to wake up readers should just not call it.
-	 * Clients can use the channel private_data to track previous
-	 * pages, determine whether this is the first page, etc.
+	 * switched to.  The default version does nothing.  Clients
+	 * can use the channel private_data to track previous pages,
+	 * determine whether this is the first page, etc.
 	 *
 	 * NOTE: the client can reserve bytes at the beginning of the new
 	 *       page by calling page_start_reserve() in this callback.
@@ -107,8 +101,7 @@ struct pagewriter_callbacks
 	 *
 	 * Returns either the length passed in or 0 if full.
 	 *
-	 * Performs page-switch tasks such as updating filesize,
-	 * waking up readers, etc.
+	 * Performs page-switch tasks.
 	 */
 	size_t (*switch_page)(struct pagewriter_buf *buf,
 			      size_t length,
@@ -116,16 +109,17 @@ struct pagewriter_callbacks
 };
 
 /**
- *	relay_write - write data into the channel
- *	@chan: relay channel
+ *	pagewriter_write - write data into the channel, without padding
+ *	@pagewriter: pagewriter
  *	@data: data to be written
  *	@length: number of bytes to write
  *
- *	Writes data into the current cpu's channel buffer.
+ *	Writes data into the current cpu's channel buffer, crossing
+ *	page boundaries.
  *
- *	Protects the buffer by disabling interrupts.  Use this
- *	if you might be logging from interrupt context.  Try
- *	__relay_write() if you know you	won't be logging from
+ *	Protects the buffer by disabling interrupts.  Use this if you
+ *	might be logging from interrupt context.  Try
+ *	__pagewriter_write() if you know you won't be logging from
  *	interrupt context.
  */
 static inline void pagewriter_write(struct pagewriter *pagewriter,
@@ -141,7 +135,8 @@ static inline void pagewriter_write(struct pagewriter *pagewriter,
 	buf = pagewriter->buf[smp_processor_id()];
 	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > PAGE_SIZE)) {
-		remainder = pagewriter->cb->switch_page(buf, length, &reserved2);
+		remainder = pagewriter->cb->switch_page(buf, length,
+							&reserved2);
 		if (unlikely(!reserved2)) {
 			local_irq_restore(flags);
 			return;
@@ -155,15 +150,16 @@ static inline void pagewriter_write(struct pagewriter *pagewriter,
 }
 
 /**
- *	__pagewriter_write - write data into the channel
- *	@chan: relay channel
+ *	__pagewriter_write - write data into the channel, without padding
+ *	@pagewriter: pagewriter
  *	@data: data to be written
  *	@length: number of bytes to write
  *
- *	Writes data into the current cpu's channel buffer.
+ *	Writes data into the current cpu's channel buffer, crossing
+ *	page boundaries.
  *
  *	Protects the buffer by disabling preemption.  Use
- *	relay_write() if you might be logging from interrupt
+ *	pagewriter_write() if you might be logging from interrupt
  *	context.
  */
 static inline void __pagewriter_write(struct pagewriter *pagewriter,
@@ -172,17 +168,15 @@ static inline void __pagewriter_write(struct pagewriter *pagewriter,
 {
 	size_t remainder = length;
 	struct pagewriter_buf *buf;
-	unsigned long flags;
 	void *reserved, *reserved2;
 
 	buf = pagewriter->buf[get_cpu()];
 	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > PAGE_SIZE)) {
-		remainder = pagewriter->cb->switch_page(buf, length, &reserved2);
-		if (unlikely(!reserved2)) {
-			local_irq_restore(flags);
+		remainder = pagewriter->cb->switch_page(buf, length,
+							&reserved2);
+		if (unlikely(!reserved2))
 			return;
-		}
 		length -= remainder;
 		memcpy(reserved2, data + length, remainder);
 	}
@@ -193,7 +187,7 @@ static inline void __pagewriter_write(struct pagewriter *pagewriter,
 
 /**
  *	page_start_reserve - reserve bytes at the start of a page
- *	@buf: relay channel buffer
+ *	@buf: pagewriter channel buffer
  *	@length: number of bytes to reserve
  *
  *	Helper function used to reserve bytes at the beginning of
@@ -213,8 +207,8 @@ extern struct pagewriter *pagewriter_open(const char *base_filename,
 					  struct pagewriter_callbacks *cb,
 					  void *private_data,
 					  unsigned long rchan_flags);
-extern void pagewriter_close(struct pagewriter *pagewriter);
 extern void pagewriter_flush(struct pagewriter *pagewriter);
+extern void pagewriter_close(struct pagewriter *pagewriter);
 extern void pagewriter_reset(struct pagewriter *pagewriter);
 
 #endif /* _LINUX_RELAY_PAGEWRITER_H */
diff --git a/kernel/relay.c b/kernel/relay.c
index 9c37cd6..888743d 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -28,121 +28,110 @@
 static DEFINE_MUTEX(relay_channels_mutex);
 static LIST_HEAD(relay_channels);
 
-/**
- *	__relay_get_rpage - get an empty relay page struct
- *	@buf: the buffer struct
- */
-struct relay_page *__relay_get_rpage(struct rchan_buf *buf)
-{
-	return kmalloc(sizeof(struct relay_page), GFP_ATOMIC);
-}
+/* forward declarations */
+static void setup_callbacks(struct rchan *chan, struct rchan_callbacks *cb);
+static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu);
+static inline void relay_wakeup_readers(struct rchan_buf *buf);
+static void relay_close_buf(struct rchan_buf *buf);
+static void relay_destroy_channel(struct kref *kref);
+static inline struct relay_page *__relay_get_rpage(struct rchan_buf *buf);
+static inline void __relay_add_page(struct rchan_buf *buf,
+				    struct relay_page *rpage);
+static inline void __relay_add_page_nolock(struct rchan_buf *buf,
+					   struct relay_page *rpage);
+static void __relay_reset(struct rchan_buf *buf, unsigned int init);
 
-/**
- *	__relay_release_page - remove page from relay and notify owner
- *	@buf: the buffer struct
- *	@rpage: struct relay_page
+/*
+ * relay kernel API
  */
-static void __relay_release_page(struct rchan_buf *buf,
-				 struct relay_page *rpage)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&buf->lock, flags);
-	list_del(&rpage->list);
-	buf->nr_pages--;
-	spin_unlock_irqrestore(&buf->lock, flags);
-
-	if (rpage->cb && rpage->cb->page_released)
-		rpage->cb->page_released(rpage->page, rpage->private_data);
-	kfree(rpage);
-}
 
 /**
- *	__relay_remove_page - remove a page from relay
- *	@buf: the buffer struct
- *	@rpage: struct relay_page
- */
-static void __relay_remove_page(struct rchan_buf *buf,
-				struct relay_page *rpage)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&buf->lock, flags);
-	list_del(&rpage->list);
-	buf->nr_pages--;
-	spin_unlock_irqrestore(&buf->lock, flags);
-
-	kfree(rpage);
-}
-
-/**
- *	relay_update_filesize - increase relay file i_size by length
- *	@buf: relay channel buffer
- *	@length: length to add
+ *	relay_open - create a new relay channel
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
+ *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
+ *	@cb: client callback functions
+ *	@private_data: user-defined data
+ *	@flags: relay channel flags
  *
- *	switch_page() helper function.
- */
-static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
-{
-	buf->dentry->d_inode->i_size +=	length;
-}
-
-/**
- *	relay_wakeup_readers - wake up readers if applicable
- *	@buf: relay channel buffer
+ *	Returns channel pointer if successful, %NULL otherwise.
  *
- *	Called by new_page() default implementation, pulled out for
- *	the convenience of user-defined new_page() implementations.
+ *	Creates per-cpu channel lists (or a single list if the
+ *	RCHAN_GLOBAL_BUFFER flag is used) to receive pages from
+ *	tracers via relay_add_page()/relay_add_pages().  These lists
+ *	will be drained by userspace via read(2), splice(2), or
+ *	sendfile(2).  Pages added to relay will be either returned to
+ *	their owners after userspace has finished reading them or the
+ *	owners will be notified if they've been stolen (see
+ *	relay_add_page).
  *
- *	Will wake up readers after each buf->n_pages_wakeup pages have
- *	been produced.  To do no waking up, simply pass 0 into relay
- *	open for this value.
+ *	buffer files will be named base_filename0...base_filenameN-1.
+ *	File permissions will be %S_IRUSR.
  */
-static inline void relay_wakeup_readers(struct rchan_buf *buf)
+struct rchan *relay_open(const char *base_filename,
+			 struct dentry *parent,
+			 size_t n_pages_wakeup,
+			 struct rchan_callbacks *cb,
+			 void *private_data,
+			 unsigned long rchan_flags)
 {
-	size_t wakeup = buf->chan->n_pages_wakeup;
+	unsigned int i;
+	struct rchan *chan;
 
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
+	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
+	if (!chan)
+		return NULL;
 
-static inline void __relay_add_page_nolock(struct rchan_buf *buf,
-					   struct relay_page *rpage)
-{
-	list_add_tail(&rpage->list, &buf->pages);
-	buf->nr_pages++;
-	relay_update_filesize(buf, PAGE_SIZE);
-}
+	chan->n_pages_wakeup = n_pages_wakeup;
+	chan->parent = parent;
+	chan->flags = rchan_flags;
 
-/**
- *	__relay_add_page - add a relay page to relay
- *	@buf: the buffer struct
- *	@rpage: struct relay_page
- */
-static void __relay_add_page(struct rchan_buf *buf, struct relay_page *rpage)
-{
-	unsigned long flags;
+	chan->private_data = private_data;
+	strlcpy(chan->base_filename, base_filename, NAME_MAX);
 
-	spin_lock_irqsave(&buf->lock, flags);
-	__relay_add_page_nolock(buf, rpage);
-	spin_unlock_irqrestore(&buf->lock, flags);
+	setup_callbacks(chan, cb);
+	kref_init(&chan->kref);
 
-	relay_wakeup_readers(buf);
+	mutex_lock(&relay_channels_mutex);
+	for_each_online_cpu(i) {
+		chan->buf[i] = relay_open_buf(chan, i);
+		if (!chan->buf[i])
+			goto free_bufs;
+	}
+	list_add(&chan->list, &relay_channels);
+	mutex_unlock(&relay_channels_mutex);
+
+	return chan;
+
+free_bufs:
+	for_each_online_cpu(i) {
+		if (!chan->buf[i])
+			break;
+		relay_close_buf(chan->buf[i]);
+	}
+
+	kref_put(&chan->kref, relay_destroy_channel);
+	mutex_unlock(&relay_channels_mutex);
+	return NULL;
 }
+EXPORT_SYMBOL_GPL(relay_open);
 
 /**
  *	relay_add_page - add a page to relay
- *	@buf: the buffer struct
- *	@page: struct page
+ *	@chan: the relay channel
+ *	@page: the page to add
+ *	@cb: relay_page callbacks associated with the page
+ *	@private_data: user data to be associated with the relay_page
  *
- *	relay now owns the page.
+ *	Add a page to relay.  When the page has been read by
+ *	userspace, the owner will be notified.  If the page has been
+ *	copied and is available for re-use by the owner, the
+ *	relay_page_callbacks page_released() callback will be invoked.
+ *	If the page has been stolen, the owner will be notified of
+ *	this fact via the page_stolen() callback; because the
+ *	page_stolen() (and page_released()) callbacks are called from
+ *	user context, the owner can allocate a new page using
+ *	GFP_KERNEL if it wants to.
  */
 void relay_add_page(struct rchan *chan,
 		    struct page *page,
@@ -167,11 +156,16 @@ void relay_add_page(struct rchan *chan,
 EXPORT_SYMBOL_GPL(relay_add_page);
 
 /**
- *	relay_add_pages - add pages to relay
- *	@buf: the buffer struct
- *	@page: struct page
+ *	relay_add_pages - add a set of pages to relay
+ *	@chan: the relay channel
+ *	@pages: the pages to add
+ *	@cb: relay_page callbacks associated with the pages
+ *	@private_data: user data to be associated with the relay_pages
  *
- *	relay now owns the page.
+ *	Add a set of pages to relay.  The added pages are guaranteed
+ *	to be inserted together as a group and in the same order as in
+ *	the pagevec.  The comments for relay_add_page() apply in the
+ *	same way to relay_add_pages().
  */
 void relay_add_pages(struct rchan *chan,
 		     struct pagevec *pages,
@@ -185,7 +179,7 @@ void relay_add_pages(struct rchan *chan,
 
 	buf = chan->buf[get_cpu()];
 	spin_lock_irqsave(&buf->lock, flags);
-	for (i = 0; i < nr_pages; i++) {
+	for (i = 0; i < nr_pages; i--) {
 		rpage = __relay_get_rpage(buf);
 
 		if (likely(rpage)) {
@@ -204,186 +198,225 @@ void relay_add_pages(struct rchan *chan,
 EXPORT_SYMBOL_GPL(relay_add_pages);
 
 /**
- *	relay_create_buf - allocate and initialize a channel buffer
- *	@chan: the relay channel
+ *	relay_flush - flush the channel
+ *	@chan: the channel
  *
- *	Returns channel buffer if successful, %NULL otherwise.
+ *	Flushes all channel buffers, i.e. wakes up readers
  */
-static struct rchan_buf *relay_create_buf(struct rchan *chan)
+void relay_flush(struct rchan *chan)
 {
-	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
-	if (!buf)
-		return NULL;
+	unsigned int i;
+	size_t prev_wakeup = chan->n_pages_wakeup;
 
-	spin_lock_init(&buf->lock);
-	INIT_LIST_HEAD(&buf->pages);
-	buf->chan = chan;
-	kref_get(&buf->chan->kref);
+	if (!chan)
+		return;
 
-	return buf;
+	if (prev_wakeup)
+		chan->n_pages_wakeup = 1;
+
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
+		chan->n_pages_wakeup = prev_wakeup;
+		return;
+	}
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_possible_cpu(i)
+		if (chan->buf[i])
+			relay_wakeup_readers(chan->buf[i]);
+	mutex_unlock(&relay_channels_mutex);
+	chan->n_pages_wakeup = prev_wakeup;
 }
+EXPORT_SYMBOL_GPL(relay_flush);
 
 /**
- *	relay_destroy_channel - free the channel struct
- *	@kref: target kernel reference that contains the relay channel
+ *	relay_close - close the channel
+ *	@chan: the channel
  *
- *	Should only be called from kref_put().
+ *	Closes all channel buffers and frees the channel.
  */
-static void relay_destroy_channel(struct kref *kref)
+void relay_close(struct rchan *chan)
 {
-	struct rchan *chan = container_of(kref, struct rchan, kref);
-	kfree(chan);
-}
+	unsigned int i;
 
-/**
- *	relay_destroy_buf - destroy an rchan_buf struct and associated buffer
- *	@buf: the buffer struct
- */
-static void relay_destroy_buf(struct rchan_buf *buf)
-{
-	struct rchan *chan = buf->chan;
-	struct relay_page *rpage, *rpage2;
+	if (!chan)
+		return;
 
-	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
-		__relay_release_page(buf, rpage);
+	mutex_lock(&relay_channels_mutex);
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0])
+		relay_close_buf(chan->buf[0]);
+	else
+		for_each_possible_cpu(i)
+			if (chan->buf[i])
+				relay_close_buf(chan->buf[i]);
 
-	chan->buf[buf->cpu] = NULL;
-	kfree(buf);
+	list_del(&chan->list);
 	kref_put(&chan->kref, relay_destroy_channel);
+	mutex_unlock(&relay_channels_mutex);
 }
+EXPORT_SYMBOL_GPL(relay_close);
 
 /**
- *	relay_remove_buf - remove a channel buffer
- *	@kref: target kernel reference that contains the relay buffer
+ *	relay_reset - reset the channel
+ *	@chan: the channel
  *
- *	Removes the file from the fileystem, which also frees the
- *	rchan_buf_struct and the channel buffer.  Should only be called from
- *	kref_put().
- */
-static void relay_remove_buf(struct kref *kref)
-{
-	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
-	buf->chan->cb->remove_buf_file(buf->dentry);
-	relay_destroy_buf(buf);
-}
-
-/**
- *	relay_buf_empty - boolean, is the channel buffer empty?
- *	@buf: channel buffer
+ *	This has the effect of erasing all data from all channel buffers
+ *	and restarting the channel in its initial state.
  *
- *	Returns 1 if the buffer is empty, 0 otherwise.
+ *	NOTE. Care should be taken that the channel isn't actually
+ *	being used by anything when this call is made.
  */
-static int relay_buf_empty(struct rchan_buf *buf)
+void relay_reset(struct rchan *chan)
 {
-	return !buf->nr_pages;
+	unsigned int i;
+
+	if (!chan)
+		return;
+
+	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
+		__relay_reset(chan->buf[0], 0);
+		return;
+	}
+
+	mutex_lock(&relay_channels_mutex);
+	for_each_online_cpu(i)
+		if (chan->buf[i])
+			__relay_reset(chan->buf[i], 0);
+	mutex_unlock(&relay_channels_mutex);
 }
+EXPORT_SYMBOL_GPL(relay_reset);
 
 /*
- * High-level relay kernel API and associated functions.
+ * end relay kernel API
  */
 
-/*
- * rchan_callback implementations defining default channel behavior.  Used
- * in place of corresponding NULL values in client callback struct.
+/**
+ *	relay_update_filesize - increase relay file i_size by length
+ *	@buf: relay channel buffer
+ *	@length: length to add
  */
+static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
+{
+	buf->dentry->d_inode->i_size +=	length;
+}
 
-/*
- * create_buf_file_create() default callback.  Creates debugfs file.
+/**
+ *	__relay_get_rpage - get an empty relay page struct
+ *	@buf: the buffer struct
  */
-static struct dentry *create_buf_file_default_callback(const char *filename,
-						       struct dentry *parent,
-						       int mode,
-						       struct rchan_buf *buf)
+static inline struct relay_page *__relay_get_rpage(struct rchan_buf *buf)
 {
-	return debugfs_create_file(filename, mode, parent, buf,
-				   &relay_file_operations);
+	return kmalloc(sizeof(struct relay_page), GFP_ATOMIC);
 }
 
-/*
- * remove_buf_file() default callback.  Removes debugfs file.
- */
-static int remove_buf_file_default_callback(struct dentry *dentry)
+static inline void __relay_add_page_nolock(struct rchan_buf *buf,
+					   struct relay_page *rpage)
 {
-	debugfs_remove(dentry);
-	return 0;
+	list_add_tail(&rpage->list, &buf->pages);
+	buf->nr_pages++;
+	relay_update_filesize(buf, PAGE_SIZE);
 }
 
-/* relay channel default callbacks */
-static struct rchan_callbacks default_channel_callbacks = {
-	.create_buf_file = create_buf_file_default_callback,
-	.remove_buf_file = remove_buf_file_default_callback,
-};
+static inline void __relay_add_page(struct rchan_buf *buf,
+				    struct relay_page *rpage)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+	__relay_add_page_nolock(buf, rpage);
+	spin_unlock_irqrestore(&buf->lock, flags);
+
+	relay_wakeup_readers(buf);
+}
 
 /**
- *	wakeup_readers - wake up readers waiting on a channel
- *	@data: contains the channel buffer
- *
- *	This is the timer function used to defer reader waking.
+ *	__relay_remove_page - remove a page from relay
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
  */
-static void wakeup_readers(unsigned long data)
+static void __relay_remove_page(struct rchan_buf *buf,
+				struct relay_page *rpage)
 {
-	struct rchan_buf *buf = (struct rchan_buf *)data;
-	wake_up_interruptible(&buf->read_wait);
-}
+	unsigned long flags;
 
+	spin_lock_irqsave(&buf->lock, flags);
+	list_del(&rpage->list);
+	buf->nr_pages--;
+	spin_unlock_irqrestore(&buf->lock, flags);
 
+	kfree(rpage);
+}
 
 /**
- *	__relay_reset - reset a channel buffer
- *	@buf: the channel buffer
- *	@init: 1 if this is a first-time initialization
- *
- *	See relay_reset() for description of effect.
+ *	__relay_release_page - remove page from relay and notify owner
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
  */
-static void __relay_reset(struct rchan_buf *buf, unsigned int init)
+static void __relay_release_page(struct rchan_buf *buf,
+				 struct relay_page *rpage)
 {
-	if (init) {
-		init_waitqueue_head(&buf->read_wait);
-		kref_init(&buf->kref);
-		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
-	} else
-		del_timer_sync(&buf->timer);
+	if (rpage->cb && rpage->cb->page_released)
+		rpage->cb->page_released(rpage->page, rpage->private_data);
 
-	buf->consumed_offset = 0;
-	buf->finalized = 0;
+	__relay_remove_page(buf, rpage);
 }
 
 /**
- *	relay_reset - reset the channel
- *	@chan: the channel
- *
- *	This has the effect of erasing all data from all channel buffers
- *	and restarting the channel in its initial state.  The buffers
- *	are not freed, so any mappings are still in effect.
+ *	relay_destroy_channel - free the channel struct
+ *	@kref: target kernel reference that contains the relay channel
  *
- *	NOTE. Care should be taken that the channel isn't actually
- *	being used by anything when this call is made.
+ *	Should only be called from kref_put().
  */
-void relay_reset(struct rchan *chan)
+static void relay_destroy_channel(struct kref *kref)
 {
-	unsigned int i;
+	struct rchan *chan = container_of(kref, struct rchan, kref);
+	kfree(chan);
+}
 
-	if (!chan)
-		return;
+/**
+ *	relay_destroy_buf - destroy an rchan_buf struct and release pages
+ *	@buf: the buffer struct
+ */
+static void relay_destroy_buf(struct rchan_buf *buf)
+{
+	struct rchan *chan = buf->chan;
+	struct relay_page *rpage, *rpage2;
 
-	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
-		__relay_reset(chan->buf[0], 0);
-		return;
-	}
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
+		__relay_release_page(buf, rpage);
 
-	mutex_lock(&relay_channels_mutex);
-	for_each_online_cpu(i)
-		if (chan->buf[i])
-			__relay_reset(chan->buf[i], 0);
-	mutex_unlock(&relay_channels_mutex);
+	chan->buf[buf->cpu] = NULL;
+	kfree(buf);
+	kref_put(&chan->kref, relay_destroy_channel);
+}
+
+/**
+ *	relay_remove_buf - remove a channel buffer
+ *	@kref: target kernel reference that contains the relay buffer
+ *
+ *	Removes the file from the fileystem, which also frees the
+ *	rchan_buf_struct and the channel buffer.  Should only be called from
+ *	kref_put().
+ */
+static void relay_remove_buf(struct kref *kref)
+{
+	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
+	buf->chan->cb->remove_buf_file(buf->dentry);
+	relay_destroy_buf(buf);
 }
-EXPORT_SYMBOL_GPL(relay_reset);
 
-static inline void relay_set_buf_dentry(struct rchan_buf *buf,
-					struct dentry *dentry)
+/**
+ *	relay_close_buf - close a channel buffer
+ *	@buf: channel buffer
+ *
+ *	Marks the buffer finalized.  The channel buffer and channel
+ *	buffer data structure are then freed automatically when the
+ *	last reference is given up.
+ */
+static void relay_close_buf(struct rchan_buf *buf)
 {
-	buf->dentry = dentry;
-	buf->dentry->d_inode->i_size = 0;
+	buf->finalized = 1;
+	del_timer_sync(&buf->timer);
+	kref_put(&buf->kref, relay_remove_buf);
 }
 
 static struct dentry *relay_create_buf_file(struct rchan *chan,
@@ -407,6 +440,26 @@ static struct dentry *relay_create_buf_file(struct rchan *chan,
 	return dentry;
 }
 
+/**
+ *	relay_create_buf - allocate and initialize a channel buffer
+ *	@chan: the relay channel
+ *
+ *	Returns channel buffer if successful, %NULL otherwise.
+ */
+static struct rchan_buf *relay_create_buf(struct rchan *chan)
+{
+	struct rchan_buf *buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	spin_lock_init(&buf->lock);
+	INIT_LIST_HEAD(&buf->pages);
+	buf->chan = chan;
+	kref_get(&buf->chan->kref);
+
+	return buf;
+}
+
 /*
  *	relay_open_buf - create a new relay channel buffer
  *
@@ -427,12 +480,13 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
 	dentry = relay_create_buf_file(chan, buf, cpu);
 	if (!dentry)
 		goto free_buf;
-	relay_set_buf_dentry(buf, dentry);
+	buf->dentry = dentry;
+	buf->dentry->d_inode->i_size = 0;
 
  	buf->cpu = cpu;
  	__relay_reset(buf, 1);
 
-	if(chan->flags & RCHAN_GLOBAL_BUFFER) {
+	if (chan->flags & RCHAN_GLOBAL_BUFFER) {
  		chan->buf[0] = buf;
  		buf->cpu = 0;
   	}
@@ -445,155 +499,109 @@ free_buf:
 }
 
 /**
- *	relay_close_buf - close a channel buffer
- *	@buf: channel buffer
+ *	relay_wakeup_readers - wake up readers if applicable
+ *	@buf: relay channel buffer
  *
- *	Marks the buffer finalized and restores the default callbacks.
- *	The channel buffer and channel buffer data structure are then freed
- *	automatically when the last reference is given up.
+ *	Will wake up readers after each buf->n_pages_wakeup pages have
+ *	been produced.  To do no waking up, simply pass 0 into relay
+ *	open for this value.
  */
-static void relay_close_buf(struct rchan_buf *buf)
-{
-	buf->finalized = 1;
-	del_timer_sync(&buf->timer);
-	kref_put(&buf->kref, relay_remove_buf);
-}
-
-static void setup_callbacks(struct rchan *chan,
-			    struct rchan_callbacks *cb)
+static inline void relay_wakeup_readers(struct rchan_buf *buf)
 {
-	if (!cb) {
-		chan->cb = &default_channel_callbacks;
-		return;
-	}
+	size_t wakeup = buf->chan->n_pages_wakeup;
 
-	if (!cb->create_buf_file)
-		cb->create_buf_file = create_buf_file_default_callback;
-	if (!cb->remove_buf_file)
-		cb->remove_buf_file = remove_buf_file_default_callback;
-	chan->cb = cb;
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
 
 /**
- *	relay_open - create a new relay channel
- *	@base_filename: base name of files to create, %NULL for buffering only
- *	@parent: dentry of parent directory, %NULL for root directory or buffer
- *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
- *	@cb: client callback functions
- *	@private_data: user-defined data
- *
- *	Returns channel pointer if successful, %NULL otherwise.
+ *	wakeup_readers - wake up readers waiting on a channel
+ *	@data: contains the channel buffer
  *
- *	Creates a channel buffer for each cpu using the sizes and
- *	attributes specified.  The created channel buffer files
- *	will be named base_filename0...base_filenameN-1.  File
- *	permissions will be %S_IRUSR.
+ *	This is the timer function used to defer reader waking.
  */
-struct rchan *relay_open(const char *base_filename,
-			 struct dentry *parent,
-			 size_t n_pages_wakeup,
-			 struct rchan_callbacks *cb,
-			 void *private_data,
-			 unsigned long rchan_flags)
+static void wakeup_readers(unsigned long data)
 {
-	unsigned int i;
-	struct rchan *chan;
-
-	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
-	if (!chan)
-		return NULL;
-
-	chan->n_pages_wakeup = n_pages_wakeup;
-	chan->parent = parent;
-	chan->flags = rchan_flags;
-
-	chan->private_data = private_data;
-	strlcpy(chan->base_filename, base_filename, NAME_MAX);
-
-	setup_callbacks(chan, cb);
-	kref_init(&chan->kref);
-
-	mutex_lock(&relay_channels_mutex);
-	for_each_online_cpu(i) {
-		chan->buf[i] = relay_open_buf(chan, i);
-		if (!chan->buf[i])
-			goto free_bufs;
-	}
-	list_add(&chan->list, &relay_channels);
-	mutex_unlock(&relay_channels_mutex);
-
-	return chan;
-
-free_bufs:
-	for_each_online_cpu(i) {
-		if (!chan->buf[i])
-			break;
-		relay_close_buf(chan->buf[i]);
-	}
-
-	kref_put(&chan->kref, relay_destroy_channel);
-	mutex_unlock(&relay_channels_mutex);
-	return NULL;
+	struct rchan_buf *buf = (struct rchan_buf *)data;
+	wake_up_interruptible(&buf->read_wait);
 }
-EXPORT_SYMBOL_GPL(relay_open);
 
 /**
- *	relay_close - close the channel
- *	@chan: the channel
+ *	__relay_reset - reset a channel buffer
+ *	@buf: the channel buffer
+ *	@init: 1 if this is a first-time initialization
  *
- *	Closes all channel buffers and frees the channel.
+ *	See relay_reset() for description of effect.
  */
-void relay_close(struct rchan *chan)
+static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 {
-	unsigned int i;
+	struct relay_page *rpage, *rpage2;
 
-	if (!chan)
-		return;
+	if (init) {
+		init_waitqueue_head(&buf->read_wait);
+		kref_init(&buf->kref);
+		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
+	} else
+		del_timer_sync(&buf->timer);
 
-	mutex_lock(&relay_channels_mutex);
-	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0])
-		relay_close_buf(chan->buf[0]);
-	else
-		for_each_possible_cpu(i)
-			if (chan->buf[i])
-				relay_close_buf(chan->buf[i]);
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list)
+		__relay_release_page(buf, rpage);
 
-	list_del(&chan->list);
-	kref_put(&chan->kref, relay_destroy_channel);
-	mutex_unlock(&relay_channels_mutex);
+	buf->consumed_offset = 0;
+	buf->finalized = 0;
 }
-EXPORT_SYMBOL_GPL(relay_close);
 
-/**
- *	relay_flush - close the channel
- *	@chan: the channel
- *
- *	Flushes all channel buffers, i.e. forces buffer switch.
+/*
+ * create_buf_file_create() default callback.  Creates debugfs file.
  */
-void relay_flush(struct rchan *chan)
+static struct dentry *create_buf_file_default_callback(const char *filename,
+						       struct dentry *parent,
+						       int mode,
+						       struct rchan_buf *buf)
 {
-	unsigned int i;
-	size_t prev_wakeup = chan->n_pages_wakeup;
+	return debugfs_create_file(filename, mode, parent, buf,
+				   &relay_file_operations);
+}
 
-	if (!chan)
-		return;
+/*
+ * remove_buf_file() default callback.  Removes debugfs file.
+ */
+static int remove_buf_file_default_callback(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+	return 0;
+}
 
-	if (prev_wakeup)
-		chan->n_pages_wakeup = 1;
+/* relay channel default callbacks */
+static struct rchan_callbacks default_channel_callbacks = {
+	.create_buf_file = create_buf_file_default_callback,
+	.remove_buf_file = remove_buf_file_default_callback,
+};
 
-	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
-		chan->n_pages_wakeup = prev_wakeup;
+static void setup_callbacks(struct rchan *chan, struct rchan_callbacks *cb)
+{
+	if (!cb) {
+		chan->cb = &default_channel_callbacks;
 		return;
 	}
 
-	mutex_lock(&relay_channels_mutex);
-	for_each_possible_cpu(i)
-		if (chan->buf[i])
-			relay_wakeup_readers(chan->buf[i]);
-	mutex_unlock(&relay_channels_mutex);
-	chan->n_pages_wakeup = prev_wakeup;
+	if (!cb->create_buf_file)
+		cb->create_buf_file = create_buf_file_default_callback;
+	if (!cb->remove_buf_file)
+		cb->remove_buf_file = remove_buf_file_default_callback;
+	chan->cb = cb;
 }
-EXPORT_SYMBOL_GPL(relay_flush);
+
+/*
+ * relay userspace implementations
+ */
 
 /**
  *	relay_file_open - open file op for relay files
@@ -628,7 +636,7 @@ static unsigned int relay_file_poll(struct file *filp, poll_table *wait)
 
 	if (filp->f_mode & FMODE_READ) {
 		poll_wait(filp, &buf->read_wait, wait);
-		if (!relay_buf_empty(buf))
+		if (buf->nr_pages)
 			mask |= POLLIN | POLLRDNORM;
 	}
 
@@ -925,7 +933,7 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 	unsigned int hotcpu = (unsigned long)hcpu;
 	struct rchan *chan;
 
-	switch(action) {
+	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&relay_channels_mutex);
@@ -933,7 +941,7 @@ static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
 			if (chan->buf[hotcpu])
 				continue;
 			chan->buf[hotcpu] = relay_open_buf(chan, hotcpu);
-			if(!chan->buf[hotcpu]) {
+			if (!chan->buf[hotcpu]) {
 				printk(KERN_ERR
 					"relay_hotcpu_callback: cpu %d buffer "
 					"creation failed\n", hotcpu);
diff --git a/kernel/relay_pagewriter.c b/kernel/relay_pagewriter.c
index 1f566a5..4b79274 100644
--- a/kernel/relay_pagewriter.c
+++ b/kernel/relay_pagewriter.c
@@ -1,5 +1,8 @@
 /*
- * Page writers for relay interface.
+ * Provides per-cpu page writers and page pool management for current
+ * users of the relay interface.  Basically this provides functions to
+ * write into pages, feed them into a relay object for consumption by
+ * usespace, and reclaim them after they've been read.
  *
  * See Documentation/filesystems/relay.txt for an overview.
  *
@@ -30,8 +33,179 @@
 static DEFINE_MUTEX(pagewriters_mutex);
 static LIST_HEAD(pagewriters);
 
+/* forward declarations */
+static void setup_callbacks(struct pagewriter *pagewriter,
+			    struct pagewriter_callbacks *cb);
+static void pagewriter_close_buf(struct pagewriter_buf *buf);
+static struct pagewriter_buf *pagewriter_open_buf(struct pagewriter *pw,
+						  unsigned int cpu);
+static void pagewriter_destroy(struct kref *kref);
+static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init);
+
+/*
+ * pagewriter kernel API
+ */
+
+/**
+ *	pagewriter_open - create a new pagewriter
+ *	@base_filename: base name of files to create, %NULL for buffering only
+ *	@parent: dentry of parent directory, %NULL for root directory or buffer
+ *	@n_pages: number of pages to use for each buffer
+ *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
+ *	@cb: client callback functions
+ *	@private_data: user-defined data
+ *	@rchan_flags: relay flags, passed on to relay
+ *
+ *	Returns pagewriter pointer if successful, %NULL otherwise.
+ *
+ *	Creates a pagewriter page pool for each cpu using the sizes and
+ *	attributes specified.
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
+/**
+ *	pagewriter_flush - close the pagewriter
+ *	@pagewriter: the pagewriter
+ *
+ *	Flushes all channel buffers, i.e. forces page switch.
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
+			pagewriter->cb->switch_page(pagewriter->buf[i], 0,
+						    NULL);
+	relay_flush(pagewriter->rchan);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_flush);
+
+/**
+ *	pagewriter_close - close the pagewriter
+ *	@pagewriter: the pagewriter
+ *
+ *	Closes all buffers and frees their page pools, and also frees
+ *	the pagewriter.
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
 /**
- *	pagewriter_get_free_page - get a free relay page from the pool
+ *	pagewriter_reset - reset the pagewriter
+ *	@pagewriter: the pagewriter
+ *
+ *	This has the effect of erasing all data from the current page
+ *	and restarting the pagewriter in its initial state.
+ *
+ *	NOTE. Care should be taken that the pagewriter isn't actually
+ *	being used by anything when this call is made.
+ */
+void pagewriter_reset(struct pagewriter *pagewriter)
+{
+	unsigned int i;
+
+	if (!pagewriter)
+		return;
+
+	mutex_lock(&pagewriters_mutex);
+	for_each_online_cpu(i)
+		if (pagewriter->buf[i])
+			__pagewriter_reset(pagewriter->buf[i], 0);
+	mutex_unlock(&pagewriters_mutex);
+}
+EXPORT_SYMBOL_GPL(pagewriter_reset);
+
+/*
+ * end relay kernel API
+ */
+
+/**
+ *	pagewriter_get_free_page - get a free relay_page from the pool
  *	@buf: the buffer struct
  *
  *	Returns relay page if successful, NULL if not.
@@ -48,6 +222,13 @@ static struct relay_page *pagewriter_get_free_page(struct pagewriter_buf *buf)
 	return rpage;
 }
 
+/**
+ *	pagewriter_add_free_page - add/return a free relay_page to the pool
+ *	@buf: the buffer struct
+ *	@rpage: relay_page to add
+ *
+ *	Returns relay page if successful, NULL if not.
+ */
 static void pagewriter_add_free_page(struct pagewriter_buf *buf,
 				     struct relay_page *rpage)
 {
@@ -55,10 +236,10 @@ static void pagewriter_add_free_page(struct pagewriter_buf *buf,
 }
 
 /**
- *	get_empty_rpage_struct - get a free relay page from the pool
+ *	get_empty_rpage_struct - get an empty rpage_struct to hold a page
  *	@buf: the buffer struct
  *
- *	Returns relay page if successful, NULL if not.
+ *	Returns an rpage_struct if successful, NULL if not.
  */
 static struct relay_page *get_empty_rpage_struct(struct pagewriter_buf *buf)
 {
@@ -74,7 +255,7 @@ static struct relay_page *get_empty_rpage_struct(struct pagewriter_buf *buf)
 }
 
 /**
- *	add_empty_rpage_struct - add a relay page to relay
+ *	add_empty_rpage_struct - add/return a free rpage_struct to the pool
  *	@buf: the buffer struct
  *	@rpage: struct relay_page
  */
@@ -85,9 +266,69 @@ static void add_empty_rpage_struct(struct pagewriter_buf *buf,
 }
 
 /**
- *	pagewriter_alloc_pool - allocate a pool of pages for writers
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
+ *	pagewriter_destroy_buf - destroy a pagewriter_buf struct and page pool
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
+ *	Frees the pagweriter_buf and the buffer's page pool.  Should
+ *	only be called from kref_put().
+ */
+static void pagewriter_remove_buf(struct kref *kref)
+{
+	struct pagewriter_buf *buf = container_of(kref, struct pagewriter_buf,
+						  kref);
+	pagewriter_destroy_buf(buf);
+}
+
+/**
+ *	pagewriter_close_buf - close a pagewriter buffer
+ *	@buf: channel buffer
+ *
+ *	The channel buffer and channel buffer data structure are freed
+ *	automatically when the last reference is given up.
+ */
+static void pagewriter_close_buf(struct pagewriter_buf *buf)
+{
+	kref_put(&buf->kref, pagewriter_remove_buf);
+}
+
+/**
+ *	pagewriter_alloc_pool - allocate a pool of pages for the buffer
  *	@buf: the buffer struct
  *
+ *	Allocates buf->pagewriter->n_pages pages to the buffer.
  *	Returns 0 if successful.
  */
 static int pagewriter_alloc_pool(struct pagewriter_buf *buf)
@@ -117,12 +358,12 @@ depopulate:
 }
 
 /**
- *	pagewriter_create_buf - allocate and initialize a channel buffer
- *	@chan: the relay channel
+ *	pagewriter_create_buf - allocate and initialize a buffer's page pool
+ *	@pagewriter: the pagewriter
  *
- *	Returns channel buffer if successful, %NULL otherwise.
+ *	Returns pagewriter buffer if successful, %NULL otherwise.
  */
-static struct pagewriter_buf *pagewriter_create_buf(struct pagewriter *pagewriter)
+static struct pagewriter_buf *pagewriter_create_buf(struct pagewriter *pw)
 {
 	struct pagewriter_buf *buf = kzalloc(sizeof(struct pagewriter_buf),
 					     GFP_KERNEL);
@@ -131,7 +372,7 @@ static struct pagewriter_buf *pagewriter_create_buf(struct pagewriter *pagewrite
 
 	INIT_LIST_HEAD(&buf->pool);
 	INIT_LIST_HEAD(&buf->empty_rpage_structs);
-	buf->pagewriter = pagewriter;
+	buf->pagewriter = pw;
 	kref_get(&buf->pagewriter->kref);
 
 	if (pagewriter_alloc_pool(buf))
@@ -144,90 +385,23 @@ free_buf:
 	return NULL;
 }
 
-/**
- *	__pagewriter_reset - reset a pagewriter
- *	@buf: the channel buffer
- *	@init: 1 if this is a first-time initialization
- *
- *	See relay_reset() for description of effect.
- */
-static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init)
-{
-	if (init)
-		kref_init(&buf->kref);
-
-	buf->page = pagewriter_get_free_page(buf);
-	buf->data = page_address(buf->page->page);
-	buf->offset = 0;
-
-	buf->pagewriter->cb->new_page(buf, buf->data);
-}
-
-/**
- *	pagewriter_destroy - free the pagewriter struct
- *	@kref: target kernel reference that contains the relay channel
- *
- *	Should only be called from kref_put().
- */
-static void pagewriter_destroy(struct kref *kref)
-{
-	struct pagewriter *pagewriter = container_of(kref, struct pagewriter,
-						     kref);
-	kfree(pagewriter);
-}
-
-/**
- *	pagewriter_destroy_buf - destroy a pagewriter_buf struct and associated buffer
- *	@buf: the buffer struct
- */
-static void pagewriter_destroy_buf(struct pagewriter_buf *buf)
-{
-	struct pagewriter *pagewriter = buf->pagewriter;
-	struct relay_page *rpage, *rpage2;
-
-	list_for_each_entry_safe(rpage, rpage2, &buf->pool, list) {
-		__free_page(rpage->page);
-		list_del(&rpage->list);
-		kfree(rpage);
-	}
-
-	pagewriter->buf[buf->cpu] = NULL;
-	kfree(buf);
-	kref_put(&pagewriter->kref, pagewriter_destroy);
-}
-
-/**
- *	pagewriter_remove_buf - remove a pagewriter buffer
- *	@kref: target kernel reference that contains the relay buffer
- *
- *	Removes the file from the fileystem, which also frees the
- *	rchan_buf_struct and the channel buffer.  Should only be called from
- *	kref_put().
- */
-static void pagewriter_remove_buf(struct kref *kref)
-{
-	struct pagewriter_buf *buf = container_of(kref, struct pagewriter_buf,
-						  kref);
-	pagewriter_destroy_buf(buf);
-}
-
 /*
- *	pagewriter_open_buf - create a new relay channel buffer
+ *	pagewriter_open_buf - create a new pagewriter buf with page pool
  *
  *	used by pagewriter_open() and CPU hotplug.
  */
 static struct pagewriter_buf *pagewriter_open_buf(struct pagewriter *pagewriter,
 					     unsigned int cpu)
 {
- 	struct pagewriter_buf *buf = NULL;
+	struct pagewriter_buf *buf = NULL;
 
 	buf = pagewriter_create_buf(pagewriter);
 	if (!buf)
 		return NULL;
 
- 	buf->cpu = cpu;
+	buf->cpu = cpu;
 
- 	__pagewriter_reset(buf, 1);
+	__pagewriter_reset(buf, 1);
 
 	return buf;
 }
@@ -262,94 +436,14 @@ static void setup_callbacks(struct pagewriter *pagewriter,
 }
 
 /**
- *	pagewriter_close_buf - close a pagewriter buffer
- *	@buf: channel buffer
+ * 	pagewriter_page_released_callback - relay_page page_released impl
+ * 	@page: the page released
+ * 	@private_data: contains associated pagewriter_buf
  *
- *	Marks the buffer finalized and restores the default callbacks.
- *	The channel buffer and channel buffer data structure are then freed
- *	automatically when the last reference is given up.
+ * 	relay has notified us that a page we gave it has been read and
+ * 	is now available for us to re-use.  We simply add it back to
+ * 	the page pool for that buf.
  */
-static void pagewriter_close_buf(struct pagewriter_buf *buf)
-{
-	kref_put(&buf->kref, pagewriter_remove_buf);
-}
-
-/**
- *	pagewriter_open - create a new relay channel
- *	@base_filename: base name of files to create, %NULL for buffering only
- *	@parent: dentry of parent directory, %NULL for root directory or buffer
- *	@n_pages: number of pages to use for each buffer
- *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
- *	@cb: client callback functions
- *	@private_data: user-defined data
- *
- *	Returns channel pointer if successful, %NULL otherwise.
- *
- *	Creates a channel buffer for each cpu using the sizes and
- *	attributes specified.  The created channel buffer files
- *	will be named base_filename0...base_filenameN-1.  File
- *	permissions will be %S_IRUSR.
- */
-struct pagewriter *pagewriter_open(const char *base_filename,
-				   struct dentry *parent,
-				   size_t n_pages,
-				   size_t n_pages_wakeup,
-				   struct pagewriter_callbacks *cb,
-				   void *private_data,
-				   unsigned long rchan_flags)
-{
-	unsigned int i;
-	struct pagewriter *pagewriter;
-	struct rchan *rchan;
-
-	if (!n_pages)
-		return NULL;
-
-	rchan = relay_open(base_filename, parent, n_pages_wakeup, NULL,
-			   private_data, rchan_flags);
-	if (!rchan)
-		return NULL;
-
-	pagewriter = kzalloc(sizeof(struct pagewriter), GFP_KERNEL);
-	if (!pagewriter) {
-		relay_close(rchan);
-		return NULL;
-	}
-
-	pagewriter->rchan = rchan;
-	pagewriter->n_pages = n_pages;
-	atomic_set(&pagewriter->dropped, 0);
-
-	pagewriter->private_data = private_data;
-	setup_callbacks(pagewriter, cb);
-	kref_init(&pagewriter->kref);
-
-	mutex_lock(&pagewriters_mutex);
-	for_each_online_cpu(i) {
-		pagewriter->buf[i] = pagewriter_open_buf(pagewriter, i);
-		if (!pagewriter->buf[i])
-			goto free_bufs;
-	}
-	list_add(&pagewriter->list, &pagewriters);
-	mutex_unlock(&pagewriters_mutex);
-
-	return pagewriter;
-
-free_bufs:
-	for_each_online_cpu(i) {
-		if (!pagewriter->buf[i])
-			break;
-		pagewriter_close_buf(pagewriter->buf[i]);
-	}
-
-	kfree(pagewriter);
-	relay_close(rchan);
-	kref_put(&pagewriter->kref, pagewriter_destroy);
-	mutex_unlock(&pagewriters_mutex);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(pagewriter_open);
-
 static void pagewriter_page_released_callback(struct page *page,
 					      void *private_data)
 {
@@ -360,6 +454,15 @@ static void pagewriter_page_released_callback(struct page *page,
 	pagewriter_add_free_page(buf, rpage);
 }
 
+/**
+ * 	pagewriter_page_stolen_callback - relay_page page_stolen impl
+ * 	@page: the page released
+ * 	@private_data: contains associated pagewriter_buf
+ *
+ * 	relay has notified us that a page we gave it has been stolen.
+ * 	We simply allocate a new one and add it to the page pool for
+ * 	that buf.
+ */
 static void pagewriter_page_stolen_callback(struct page *page,
 					    void *private_data)
 {
@@ -388,10 +491,12 @@ static struct relay_page_callbacks pagewriter_relay_page_callbacks = {
  *	@length: size of current event
  *	@reserved: a pointer to the space reserved
  *
- *	Returns either the length passed in or 0 if full.
+ *	Page switching function for pagewriter_write() functions,
+ *	which don't use padding because they write across page
+ *	boundaries.  Returns the remainder i.e. the amount that should
+ *	be written into the second page.
  *
- *	Performs page-switch tasks such as invoking callbacks,
- *	waking up readers, etc.
+ *	Performs page-switch tasks.
  */
 size_t pagewriter_switch_page_default_callback(struct pagewriter_buf *buf,
 					       size_t length,
@@ -440,57 +545,23 @@ toobig:
 EXPORT_SYMBOL_GPL(pagewriter_switch_page_default_callback);
 
 /**
- *	pagewriter_close - close the pagewriter
- *	@chan: the channel
- *
- *	Closes all channel buffers and frees the channel.
- */
-void pagewriter_close(struct pagewriter *pagewriter)
-{
-	unsigned int i;
-
-	if (!pagewriter)
-		return;
-
-	mutex_lock(&pagewriters_mutex);
-	for_each_possible_cpu(i)
-		if (pagewriter->buf[i])
-			pagewriter_close_buf(pagewriter->buf[i]);
-
-	relay_close(pagewriter->rchan);
-	if (pagewriter->last_toobig)
-		printk(KERN_WARNING "pagewriter: one or more items not logged "
-		       "[item size (%Zd) > PAGE_SIZE (%lu)]\n",
-		       pagewriter->last_toobig, PAGE_SIZE);
-
-	list_del(&pagewriter->list);
-	kref_put(&pagewriter->kref, pagewriter_destroy);
-	mutex_unlock(&pagewriters_mutex);
-}
-EXPORT_SYMBOL_GPL(pagewriter_close);
-
-/**
- *	pagewriter_flush - close the channel
- *	@chan: the channel
+ *	__pagewriter_reset - reset a pagewriter
+ *	@buf: the channel buffer
+ *	@init: 1 if this is a first-time initialization
  *
- *	Flushes all channel buffers, i.e. forces buffer switch.
+ *	See pagewriter_reset() for description of effect.
  */
-void pagewriter_flush(struct pagewriter *pagewriter)
+static void __pagewriter_reset(struct pagewriter_buf *buf, unsigned int init)
 {
-	unsigned int i;
+	if (init)
+		kref_init(&buf->kref);
 
-	if (!pagewriter)
-		return;
+	buf->page = pagewriter_get_free_page(buf);
+	buf->data = page_address(buf->page->page);
+	buf->offset = 0;
 
-	mutex_lock(&pagewriters_mutex);
-	for_each_possible_cpu(i)
-		if (pagewriter->buf[i])
-			pagewriter->cb->switch_page(pagewriter->buf[i], 0, NULL);
-	relay_flush(pagewriter->rchan);
-	mutex_unlock(&pagewriters_mutex);
+	buf->pagewriter->cb->new_page(buf, buf->data);
 }
-EXPORT_SYMBOL_GPL(pagewriter_flush);
-
 
 /**
  * 	pagewriter_hotcpu_callback - CPU hotplug callback
@@ -507,19 +578,19 @@ static int __cpuinit pagewriter_hotcpu_callback(struct notifier_block *nb,
 	unsigned int hotcpu = (unsigned long)hcpu;
 	struct pagewriter *pagewriter;
 
-	switch(action) {
+	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&pagewriters_mutex);
 		list_for_each_entry(pagewriter, &pagewriters, list) {
 			if (pagewriter->buf[hotcpu])
 				continue;
-			pagewriter->buf[hotcpu] = pagewriter_open_buf(pagewriter,
-								      hotcpu);
-			if(!pagewriter->buf[hotcpu]) {
+			pagewriter->buf[hotcpu] =
+				pagewriter_open_buf(pagewriter, hotcpu);
+			if (!pagewriter->buf[hotcpu]) {
 				printk(KERN_ERR
 					"pagewriter_hotcpu_callback: cpu %d "
-				        "buffer creation failed\n", hotcpu);
+				       "buffer creation failed\n", hotcpu);
 				mutex_unlock(&pagewriters_mutex);
 				return NOTIFY_BAD;
 			}
-- 
1.5.3.5



