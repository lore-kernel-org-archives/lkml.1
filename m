Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYI0GUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYI0GUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 02:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYI0GS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 02:18:28 -0400
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40]:42009
	"EHLO QMTA04.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbYI0GSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 02:18:25 -0400
X-Authority-Analysis: v=1.0 c=1 a=6XRo3bHIte8A:10 a=mNnMj8Na5yMA:10
 a=MvdaoaLojAP3mZP-tZUA:9 a=rxBClAoXen4VjL2bOecA:7
 a=FRdDYKRvP4-3f-h7G5TFam_VupgA:4 a=wZiCkNY6m2YA:10 a=i92e0Ub4el8A:10
 a=d_-3mwAUsuEA:10 a=eZLSmJVMEtUA:10
Subject: [RFC PATCH 10/10] relay - Remove sub-buffers from relay.
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
Date: Sat, 27 Sep 2008 01:18:32 -0500
Message-Id: <1222496313.6710.81.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove sub-buffers from relay.

This patch removes the concept of sub-buffers from relay - everything
now just operates on pages.  relay_open() was also changed
accordingly; instead of specifying buffer sizes in terms of sub-buffer
sizes and numbers, the buffer size is specfied in pages.  There's also
a new param that specifies how often to wake up consumers, in terms of
every n pages produced.  If 0 is given for this param, consumers are
never woken up.
---
 block/blktrace.c      |    7 +-
 include/linux/relay.h |  113 +++++++++++-----------
 kernel/relay.c        |  257
++++++++++++++++++++++++-------------------------
 virt/kvm/kvm_trace.c  |   25 +++--
 4 files changed, 202 insertions(+), 200 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index c04168b..84a9cb4 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -359,6 +359,7 @@ int do_blk_trace_setup(struct request_queue *q, char
*name, dev_t dev,
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
 	int ret, i;
+	int n_pages, n_pages_wakeup;
 
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
@@ -403,8 +404,10 @@ int do_blk_trace_setup(struct request_queue *q,
char *name, dev_t dev,
 	if (!bt->msg_file)
 		goto err;
 
-	bt->rchan = relay_open("trace", dir, buts->buf_size,
-			       buts->buf_nr, &blk_relay_callbacks, bt, 0UL);
+	n_pages = (buts->buf_size * buts->buf_nr) / PAGE_SIZE;
+	n_pages_wakeup = buts->buf_size / PAGE_SIZE;
+	bt->rchan = relay_open("trace", dir, n_pages, n_pages_wakeup,
+			       &blk_relay_callbacks, bt, 0UL);
 	if (!bt->rchan)
 		goto err;
 
diff --git a/include/linux/relay.h b/include/linux/relay.h
index dd51caf..e0b1730 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -19,9 +19,6 @@
 #include <linux/poll.h>
 #include <linux/kref.h>
 
-/* Needs a _much_ better name... */
-#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
-
 /*
  * Tracks changes to rchan/rchan_buf structs
  */
@@ -39,10 +36,10 @@
 struct rchan_buf
 {
 	void *start;			/* start of channel buffer */
-	void *data;			/* start of current sub-buffer */
-	size_t offset;			/* current offset into sub-buffer */
-	size_t subbufs_produced;	/* count of sub-buffers produced */
-	size_t subbufs_consumed;	/* count of sub-buffers consumed */
+	void *data;			/* start of current page */
+	size_t offset;			/* current offset into page */
+	size_t produced;		/* count of pages produced */
+	size_t consumed;		/* count of pages consumed */
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
 	struct timer_list timer; 	/* reader wake-up timer */
@@ -51,7 +48,7 @@ struct rchan_buf
 	struct page **page_array;	/* array of current buffer pages */
 	unsigned int page_count;	/* number of current buffer pages */
 	unsigned int finalized;		/* buffer has been finalized */
-	size_t bytes_consumed;		/* bytes consumed in cur read subbuf */
+	size_t consumed_offset;		/* bytes consumed in cur page */
 	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
@@ -62,13 +59,13 @@ struct rchan_buf
 struct rchan
 {
 	u32 version;			/* the version of this struct */
-	size_t subbuf_size;		/* sub-buffer size */
-	size_t n_subbufs;		/* number of sub-buffers per buffer */
+	size_t n_pages;			/* number of pages per buffer */
+	size_t n_pages_wakeup;		/* wake up readers after filling n */
 	size_t alloc_size;		/* total buffer size allocated */
 	struct rchan_callbacks *cb;	/* client callbacks */
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
-	size_t last_toobig;		/* tried to log event > subbuf size */
+	size_t last_toobig;		/* tried to log event > page size */
 	struct rchan_buf *buf[NR_CPUS]; /* per-cpu channel buffers */
 	struct list_head list;		/* for channel list */
 	struct dentry *parent;		/* parent dentry passed to open */
@@ -84,25 +81,24 @@ struct rchan
 struct rchan_callbacks
 {
 	/*
-	 * new_subbuf - called on buffer-switch to a new sub-buffer
-	 * @buf: the channel buffer containing the new sub-buffer
-	 * @subbuf: the start of the new sub-buffer
+	 * new_page - called on switch to a new page
+	 * @buf: the channel buffer containing the new page
+	 * @page_data: the start of the new page
 	 *
-	 * This is simply a notification that a new sub-buffer has
-	 * been started.  The default version does nothing but call
+	 * This is simply a notification that a new page has been
+	 * switched to.  The default version does nothing but call
 	 * relay_wakeup_readers().  Clients who override this callback
 	 * should also call relay_wakeup_readers() to get that default
 	 * behavior in addition to whatever they add.  Clients who
 	 * don't want to wake up readers should just not call it.
 	 * Clients can use the channel private_data to track previous
-	 * sub-buffers, determine whether this is the first
-	 * sub-buffer, etc.
+	 * pages, determine whether this is the first page, etc.
 	 *
 	 * NOTE: the client can reserve bytes at the beginning of the new
-	 *       sub-buffer by calling subbuf_start_reserve() in this
callback.
+	 *       page by calling page_start_reserve() in this callback.
 	 */
-	void (*new_subbuf) (struct rchan_buf *buf,
-			    void *subbuf);
+	void (*new_page) (struct rchan_buf *buf,
+			  void *page_data);
 
 	/*
 	 * buf_mapped - relay buffer mmap notification
@@ -159,7 +155,7 @@ struct rchan_callbacks
 	int (*remove_buf_file)(struct dentry *dentry);
 
 	/*
-	 * switch_subbuf - sub-buffer switch callback
+	 * switch_page - page switch callback
 	 * @buf: the channel buffer
 	 * @length: size of current event
 	 * @reserved: a pointer to the space reserved
@@ -170,12 +166,12 @@ struct rchan_callbacks
 	 *
 	 * Returns either the length passed in or 0 if full.
 	 *
-	 * Performs sub-buffer-switch tasks such as updating filesize,
+	 * Performs page-switch tasks such as updating filesize,
 	 * waking up readers, etc.
 	 */
-	size_t (*switch_subbuf)(struct rchan_buf *buf,
-				size_t length,
-				void **reserved);
+	size_t (*switch_page)(struct rchan_buf *buf,
+			      size_t length,
+			      void **reserved);
 };
 
 /*
@@ -184,8 +180,8 @@ struct rchan_callbacks
 
 struct rchan *relay_open(const char *base_filename,
 			 struct dentry *parent,
-			 size_t subbuf_size,
-			 size_t n_subbufs,
+			 size_t n_pages,
+			 size_t n_pages_wakeup,
 			 struct rchan_callbacks *cb,
 			 void *private_data,
 			 unsigned long rchan_flags);
@@ -194,26 +190,33 @@ extern int relay_late_setup_files(struct rchan
*chan,
 				  struct dentry *parent);
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
-extern void relay_subbufs_consumed(struct rchan *chan,
-				   unsigned int cpu,
-				   size_t consumed);
+extern void relay_pages_consumed(struct rchan *chan,
+				 unsigned int cpu,
+				 size_t consumed);
 extern void relay_reset(struct rchan *chan);
 extern int relay_buf_full(struct rchan_buf *buf);
 
-extern size_t relay_switch_subbuf_default_callback(struct rchan_buf
*buf,
-						   size_t length,
-						   void **reserved);
+extern size_t relay_switch_page_default_callback(struct rchan_buf *buf,
+						 size_t length,
+						 void **reserved);
 
 /**
  *	relay_wakeup_readers - wake up readers if applicable
  *	@buf: relay channel buffer
  *
- *	Called by new_subbuf() default implementation, pulled out for
- *	the conveiennce of user-defined new_subbuf() implementations.
+ *	Called by new_page() default implementation, pulled out for
+ *	the convenience of user-defined new_page() implementations.
+ *
+ *	Will wake up readers after each buf->n_pages_wakeup pages have
+ *	been produced.  To do no waking up, simply pass 0 into relay
+ *	open for this value.
  */
 static inline void relay_wakeup_readers(struct rchan_buf *buf)
 {
-	if (waitqueue_active(&buf->read_wait))
+	size_t wakeup = buf->chan->n_pages_wakeup;
+
+	if (wakeup && (buf->produced % wakeup == 0) &&
+	    (waitqueue_active(&buf->read_wait)))
 		/*
 		 * Calling wake_up_interruptible() from here
 		 * will deadlock if we happen to be logging
@@ -224,17 +227,17 @@ static inline void relay_wakeup_readers(struct
rchan_buf *buf)
 }
 
 /**
- *	relay_event_toobig - is event too big to fit in a sub-buffer?
+ *	relay_event_toobig - is event too big to fit in a page?
  *	@buf: relay channel buffer
  *	@length: length of event
  *
  *	Returns 1 if too big, 0 otherwise.
  *
- *	switch_subbuf() helper function.
+ *	switch_page() helper function.
  */
 static inline int relay_event_toobig(struct rchan_buf *buf, size_t
length)
 {
-	return length > buf->chan->subbuf_size;
+	return length > PAGE_SIZE;
 }
 
 /**
@@ -242,7 +245,7 @@ static inline int relay_event_toobig(struct
rchan_buf *buf, size_t length)
  *	@buf: relay channel buffer
  *	@length: length to add
  *
- *	switch_subbuf() helper function.
+ *	switch_page() helper function.
  */
 static inline void relay_update_filesize(struct rchan_buf *buf, size_t
length)
 {
@@ -255,14 +258,14 @@ static inline void relay_update_filesize(struct
rchan_buf *buf, size_t length)
 }
 
 /**
- *	relay_inc_produced - increase number of sub-buffers produced by 1
+ *	relay_inc_produced - increase number of pages produced by 1
  *	@buf: relay channel buffer
  *
- *	switch_subbuf() helper function.
+ *	switch_page() helper function.
  */
 static inline void relay_inc_produced(struct rchan_buf *buf)
 {
-	buf->subbufs_produced++;
+	buf->produced++;
 }
 
 /**
@@ -290,8 +293,8 @@ static inline void relay_write(struct rchan *chan,
 	local_irq_save(flags);
 	buf = chan->buf[smp_processor_id()];
 	reserved = buf->data + buf->offset;
-	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
-		remainder = chan->cb->switch_subbuf(buf, length, &reserved);
+	if (unlikely(buf->offset + length > PAGE_SIZE)) {
+		remainder = chan->cb->switch_page(buf, length, &reserved);
 		if (unlikely(!reserved)) {
 			local_irq_restore(flags);
 			return;
@@ -325,8 +328,8 @@ static inline void __relay_write(struct rchan *chan,
 
 	buf = chan->buf[get_cpu()];
 	reserved = buf->data + buf->offset;
-	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
-		remainder = chan->cb->switch_subbuf(buf, length, &reserved);
+	if (unlikely(buf->offset + length > PAGE_SIZE)) {
+		remainder = chan->cb->switch_page(buf, length, &reserved);
 		if (unlikely(!reserved)) {
 			local_irq_restore(flags);
 			return;
@@ -354,8 +357,8 @@ static inline void *relay_reserve(struct rchan
*chan,
 	struct rchan_buf *buf = chan->buf[smp_processor_id()];
 	void *reserved = buf->data + buf->offset;
 
-	if (unlikely(buf->offset + length > buf->chan->subbuf_size)) {
-		length = chan->cb->switch_subbuf(buf, length, &reserved);
+	if (unlikely(buf->offset + length > PAGE_SIZE)) {
+		length = chan->cb->switch_page(buf, length, &reserved);
 		if (unlikely(!reserved))
 			return NULL;
 	}
@@ -365,17 +368,17 @@ static inline void *relay_reserve(struct rchan
*chan,
 }
 
 /**
- *	subbuf_start_reserve - reserve bytes at the start of a sub-buffer
+ *	page_start_reserve - reserve bytes at the start of a page
  *	@buf: relay channel buffer
  *	@length: number of bytes to reserve
  *
  *	Helper function used to reserve bytes at the beginning of
- *	a sub-buffer in the subbuf_start() callback.
+ *	a page in the new_page() callback.
  */
-static inline void subbuf_start_reserve(struct rchan_buf *buf,
-					size_t length)
+static inline void page_start_reserve(struct rchan_buf *buf,
+				      size_t length)
 {
-	BUG_ON(length >= buf->chan->subbuf_size - 1);
+	BUG_ON(length >= PAGE_SIZE - 1);
 	buf->offset = length;
 }
 
diff --git a/kernel/relay.c b/kernel/relay.c
index 3d06970..137f13f 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -132,31 +132,26 @@ static int relay_mmap_buf(struct rchan_buf *buf,
struct vm_area_struct *vma)
 static void *relay_alloc_buf(struct rchan_buf *buf)
 {
 	void *mem;
-	unsigned int i, j, n_pages, n_subbuf_pages;
+	unsigned int i, j;
 
-	buf->chan->alloc_size = PAGE_ALIGN(buf->chan->alloc_size);
-	n_pages = buf->chan->alloc_size >> PAGE_SHIFT;
-	n_subbuf_pages = PAGE_ALIGN(buf->chan->subbuf_size) >> PAGE_SHIFT;
-
-	buf->page_array = relay_alloc_page_array(n_pages + n_subbuf_pages);
+	buf->page_array = relay_alloc_page_array(buf->chan->n_pages + 1);
 	if (!buf->page_array)
 		return NULL;
 
-	for (i = 0; i < n_pages; i++) {
+	for (i = 0; i < buf->chan->n_pages; i++) {
 		buf->page_array[i] = alloc_page(GFP_KERNEL);
 		if (unlikely(!buf->page_array[i]))
 			goto depopulate;
 		set_page_private(buf->page_array[i], (unsigned long)buf);
 	}
-	for (i = 0; i < n_subbuf_pages; i++)
-		buf->page_array[n_pages + i] = buf->page_array[i];
-	mem = vmap(buf->page_array, n_pages + n_subbuf_pages, VM_MAP,
+	buf->page_array[buf->chan->n_pages] = buf->page_array[0];
+	mem = vmap(buf->page_array, buf->chan->n_pages + 1, VM_MAP,
 		   PAGE_KERNEL);
 	if (!mem)
 		goto depopulate;
 
 	memset(mem, 0, buf->chan->alloc_size);
-	buf->page_count = n_pages;
+	buf->page_count = buf->chan->n_pages;
 	return mem;
 
 depopulate:
@@ -247,7 +242,7 @@ static void relay_remove_buf(struct kref *kref)
  */
 static int relay_buf_empty(struct rchan_buf *buf)
 {
-	return (buf->subbufs_produced - buf->subbufs_consumed) ? 0 : 1;
+	return (buf->produced - buf->consumed) ? 0 : 1;
 }
 
 /**
@@ -258,8 +253,8 @@ static int relay_buf_empty(struct rchan_buf *buf)
  */
 int relay_buf_full(struct rchan_buf *buf)
 {
-	size_t ready = buf->subbufs_produced - buf->subbufs_consumed;
-	return (ready >= buf->chan->n_subbufs) ? 1 : 0;
+	size_t ready = buf->produced - buf->consumed;
+	return (ready >= buf->chan->n_pages) ? 1 : 0;
 }
 EXPORT_SYMBOL_GPL(relay_buf_full);
 
@@ -308,22 +303,22 @@ static int remove_buf_file_default_callback(struct
dentry *dentry)
 }
 
 /*
- * new_subbuf() default callback.
+ * new_page() default callback.
  */
-static void new_subbuf_default_callback(struct rchan_buf *buf,
-					void *subbuf)
+static void new_page_default_callback(struct rchan_buf *buf,
+				      void *page_data)
 {
 	relay_wakeup_readers(buf);
 }
 
 /* relay channel default callbacks */
 static struct rchan_callbacks default_channel_callbacks = {
-	.new_subbuf = new_subbuf_default_callback,
+	.new_page = new_page_default_callback,
 	.buf_mapped = buf_mapped_default_callback,
 	.buf_unmapped = buf_unmapped_default_callback,
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
-	.switch_subbuf = relay_switch_subbuf_default_callback,
+	.switch_page = relay_switch_page_default_callback,
 };
 
 /**
@@ -354,14 +349,14 @@ static void __relay_reset(struct rchan_buf *buf,
unsigned int init)
 	} else
 		del_timer_sync(&buf->timer);
 
-	buf->subbufs_produced = 0;
-	buf->subbufs_consumed = 0;
-	buf->bytes_consumed = 0;
+	buf->produced = 0;
+	buf->consumed = 0;
+	buf->consumed_offset = 0;
 	buf->finalized = 0;
 	buf->data = buf->start;
 	buf->offset = 0;
 
-	buf->chan->cb->new_subbuf(buf, buf->data);
+	buf->chan->cb->new_page(buf, buf->data);
 }
 
 /**
@@ -493,10 +488,10 @@ static void setup_callbacks(struct rchan *chan,
 		cb->create_buf_file = create_buf_file_default_callback;
 	if (!cb->remove_buf_file)
 		cb->remove_buf_file = remove_buf_file_default_callback;
-	if (!cb->new_subbuf)
-		cb->new_subbuf = new_subbuf_default_callback;
-	if (!cb->switch_subbuf)
-		cb->switch_subbuf = relay_switch_subbuf_default_callback;
+	if (!cb->new_page)
+		cb->new_page = new_page_default_callback;
+	if (!cb->switch_page)
+		cb->switch_page = relay_switch_page_default_callback;
 	chan->cb = cb;
 }
 
@@ -546,8 +541,8 @@ static int __cpuinit relay_hotcpu_callback(struct
notifier_block *nb,
  *	relay_open - create a new relay channel
  *	@base_filename: base name of files to create, %NULL for buffering
only
  *	@parent: dentry of parent directory, %NULL for root directory or
buffer
- *	@subbuf_size: size of sub-buffers
- *	@n_subbufs: number of sub-buffers
+ *	@n_pages: number of pages to use for each buffer
+ *	@n_pages_wakeup: wakeup readers after this many pages, 0 means never
  *	@cb: client callback functions
  *	@private_data: user-defined data
  *
@@ -560,8 +555,8 @@ static int __cpuinit relay_hotcpu_callback(struct
notifier_block *nb,
  */
 struct rchan *relay_open(const char *base_filename,
 			 struct dentry *parent,
-			 size_t subbuf_size,
-			 size_t n_subbufs,
+			 size_t n_pages,
+			 size_t n_pages_wakeup,
 			 struct rchan_callbacks *cb,
 			 void *private_data,
 			 unsigned long rchan_flags)
@@ -569,7 +564,7 @@ struct rchan *relay_open(const char *base_filename,
 	unsigned int i;
 	struct rchan *chan;
 
-	if (!(subbuf_size && n_subbufs))
+	if (!n_pages)
 		return NULL;
 
 	chan = kzalloc(sizeof(struct rchan), GFP_KERNEL);
@@ -577,9 +572,9 @@ struct rchan *relay_open(const char *base_filename,
 		return NULL;
 
 	chan->version = RELAYFS_CHANNEL_VERSION;
-	chan->n_subbufs = n_subbufs;
-	chan->subbuf_size = subbuf_size;
-	chan->alloc_size = FIX_SIZE(subbuf_size * n_subbufs);
+	chan->n_pages = n_pages;
+	chan->n_pages_wakeup = n_pages_wakeup;
+	chan->alloc_size = PAGE_SIZE * n_pages;
 	chan->parent = parent;
 	chan->flags = rchan_flags;
 	atomic_set(&chan->dropped, 0);
@@ -704,57 +699,57 @@ int relay_late_setup_files(struct rchan *chan,
 	return err;
 }
 
-static inline int next_subbuf_free(struct rchan_buf *buf)
+static inline int next_page_free(struct rchan_buf *buf)
 {
-	size_t full_subbufs;
+	size_t full_pages;
 
 	if (buf->chan->flags & RCHAN_MODE_OVERWRITE)
 		return 1;
 
-	full_subbufs = buf->subbufs_produced - buf->subbufs_consumed;
+	full_pages = buf->produced - buf->consumed;
 
-	return (full_subbufs < buf->chan->n_subbufs - 1);
+	return (full_pages < buf->chan->n_pages - 1);
 }
 
 /**
- *	relay_switch_subbuf_default_callback - switch to a new sub-buffer
+ *	relay_switch_page_default_callback - switch to a new page
  *	@buf: channel buffer
  *	@length: size of current event
  *	@reserved: a pointer to the space reserved
  *
  *	Returns either the length passed in or 0 if full.
  *
- *	Performs sub-buffer-switch tasks such as invoking callbacks,
+ *	Performs page-switch tasks such as invoking callbacks,
  *	waking up readers, etc.
  */
-size_t relay_switch_subbuf_default_callback(struct rchan_buf *buf,
-					    size_t length,
-					    void **reserved)
+size_t relay_switch_page_default_callback(struct rchan_buf *buf,
+					  size_t length,
+					  void **reserved)
 {
-	size_t remainder, new_subbuf;
+	size_t remainder, new_page;
 	void *new_data;
 
 	if (unlikely(relay_event_toobig(buf, length)))
 		goto toobig;
 
 	/* don't write anything unless we can write it all. */
-	if (!next_subbuf_free(buf)) {
+	if (!next_page_free(buf)) {
 		if (reserved)
 			*reserved = NULL;
 		atomic_inc(&buf->chan->dropped);
 		return 0;
 	}
 
-	remainder = length - (buf->chan->subbuf_size - buf->offset);
+	remainder = length - (PAGE_SIZE - buf->offset);
 	relay_inc_produced(buf);
-	relay_update_filesize(buf, buf->chan->subbuf_size + remainder);
+	relay_update_filesize(buf, PAGE_SIZE + remainder);
 
-	new_subbuf = buf->subbufs_produced % buf->chan->n_subbufs;
-	new_data = buf->start + new_subbuf * buf->chan->subbuf_size;
+	new_page = buf->produced % buf->chan->n_pages;
+	new_data = buf->start + new_page * PAGE_SIZE;
 
 	buf->data = new_data;
 	buf->offset = 0; /* remainder will be added by caller */
-	buf->chan->cb->new_subbuf(buf, new_data);
+	buf->chan->cb->new_page(buf, new_data);
 
 	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
 		goto toobig;
@@ -764,24 +759,24 @@ toobig:
 	buf->chan->last_toobig = length;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(relay_switch_subbuf_default_callback);
+EXPORT_SYMBOL_GPL(relay_switch_page_default_callback);
 
 /**
- *	relay_subbufs_consumed - update the buffer's sub-buffers-consumed
count
+ *	relay_pages_consumed - update the buffer's pages-consumed count
  *	@chan: the channel
  *	@cpu: the cpu associated with the channel buffer to update
- *	@subbufs_consumed: number of sub-buffers to add to current buf's
count
+ *	@consumed: number of pages to add to current buf's count
  *
- *	Adds to the channel buffer's consumed sub-buffer count.
- *	subbufs_consumed should be the number of sub-buffers newly consumed,
+ *	Adds to the channel buffer's consumed page count.
+ *	consumed should be the number of pages newly consumed,
  *	not the total consumed.
  *
  *	NOTE. Kernel clients don't need to call this function if the channel
  *	mode is 'overwrite'.
  */
-void relay_subbufs_consumed(struct rchan *chan,
-			    unsigned int cpu,
-			    size_t subbufs_consumed)
+void relay_pages_consumed(struct rchan *chan,
+			  unsigned int cpu,
+			  size_t consumed)
 {
 	struct rchan_buf *buf;
 
@@ -792,11 +787,11 @@ void relay_subbufs_consumed(struct rchan *chan,
 		return;
 
 	buf = chan->buf[cpu];
-	buf->subbufs_consumed += subbufs_consumed;
-	if (buf->subbufs_consumed > buf->subbufs_produced)
-		buf->subbufs_consumed = buf->subbufs_produced;
+	buf->consumed += consumed;
+	if (buf->consumed > buf->produced)
+		buf->consumed = buf->produced;
 }
-EXPORT_SYMBOL_GPL(relay_subbufs_consumed);
+EXPORT_SYMBOL_GPL(relay_pages_consumed);
 
 /**
  *	relay_close - close the channel
@@ -821,8 +816,8 @@ void relay_close(struct rchan *chan)
 
 	if (chan->last_toobig)
 		printk(KERN_WARNING "relay: one or more items not logged "
-		       "[item size (%Zd) > sub-buffer size (%Zd)]\n",
-		       chan->last_toobig, chan->subbuf_size);
+		       "[item size (%Zd) > PAGE_SIZE (%lu)]\n",
+		       chan->last_toobig, PAGE_SIZE);
 
 	list_del(&chan->list);
 	kref_put(&chan->kref, relay_destroy_channel);
@@ -839,20 +834,26 @@ EXPORT_SYMBOL_GPL(relay_close);
 void relay_flush(struct rchan *chan)
 {
 	unsigned int i;
+	size_t prev_wakeup = chan->n_pages_wakeup;
 
 	if (!chan)
 		return;
 
+	if (prev_wakeup)
+		chan->n_pages_wakeup = 1;
+
 	if (chan->flags & RCHAN_GLOBAL_BUFFER && chan->buf[0]) {
-		chan->cb->switch_subbuf(chan->buf[0], 0, NULL);
+		chan->cb->switch_page(chan->buf[0], 0, NULL);
+		chan->n_pages_wakeup = prev_wakeup;
 		return;
 	}
 
 	mutex_lock(&relay_channels_mutex);
 	for_each_possible_cpu(i)
 		if (chan->buf[i])
-			chan->cb->switch_subbuf(chan->buf[i], 0, NULL);
+			chan->cb->switch_page(chan->buf[i], 0, NULL);
 	mutex_unlock(&relay_channels_mutex);
+	chan->n_pages_wakeup = prev_wakeup;
 }
 EXPORT_SYMBOL_GPL(relay_flush);
 
@@ -932,36 +933,36 @@ static void relay_file_read_consume(struct
rchan_buf *buf,
 				    size_t read_pos,
 				    size_t bytes_consumed)
 {
-	size_t subbuf_size = buf->chan->subbuf_size;
+	buf->consumed_offset += bytes_consumed;
 
-	buf->bytes_consumed += bytes_consumed;
-
-	if (buf->bytes_consumed == subbuf_size) {
-		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
-		buf->bytes_consumed = 0;
+	if (buf->consumed_offset == PAGE_SIZE) {
+		relay_pages_consumed(buf->chan, buf->cpu, 1);
+		buf->consumed_offset = 0;
 	}
 }
 
 /**
- *	relay_file_read_subbuf_avail - return bytes available in sub-buffer
+ *	relay_file_read_page_avail - return bytes available in page
  *	@read_pos: file read position
  *	@buf: relay channel buffer
  */
-static size_t relay_file_read_subbuf_avail(size_t read_pos,
-					   struct rchan_buf *buf)
+static size_t relay_file_read_page_avail(size_t read_pos,
+					 struct rchan_buf *buf)
 {
 	size_t avail;
-	size_t read_subbuf, read_offset, write_subbuf, write_offset;
-	size_t subbuf_size = buf->chan->subbuf_size;
+	size_t read_page, read_offset, write_page, write_offset;
 
-	write_subbuf = (buf->data - buf->start) / subbuf_size;
+	write_page = (buf->data - buf->start) / PAGE_SIZE;
 	write_offset = buf->offset;
-	read_subbuf = read_pos / subbuf_size;
-	read_offset = read_pos % subbuf_size;
+	read_page = read_pos / PAGE_SIZE;
+	read_offset = read_pos % PAGE_SIZE;
 
-	avail = subbuf_size - read_offset;
+	if (read_page == write_page && read_offset == write_offset)
+		return 0;
 
-	if (read_subbuf == write_subbuf && read_offset < write_offset)
+	avail = PAGE_SIZE - read_offset;
+
+	if (read_page == write_page && read_offset < write_offset)
 		avail = write_offset - read_offset;
 
 	return avail;
@@ -978,11 +979,10 @@ static size_t relay_file_read_subbuf_avail(size_t
read_pos,
 static size_t relay_file_read_start_pos(size_t read_pos,
 					struct rchan_buf *buf)
 {
-	size_t subbuf_size = buf->chan->subbuf_size;
-	size_t consumed = buf->subbufs_consumed % buf->chan->n_subbufs;
+	size_t consumed = buf->consumed % buf->chan->n_pages;
 
 	if (!read_pos)
-		read_pos = consumed * subbuf_size + buf->bytes_consumed;
+		read_pos = consumed * PAGE_SIZE + buf->consumed_offset;
 
 	return read_pos;
 }
@@ -999,20 +999,20 @@ static size_t relay_file_read_end_pos(struct
rchan_buf *buf,
 {
 	size_t end_pos = read_pos + count;
 
-	if (end_pos >= buf->chan->subbuf_size * buf->chan->n_subbufs)
+	if (end_pos >= PAGE_SIZE * buf->chan->n_pages)
 		end_pos = 0;
 
 	return end_pos;
 }
 
 /*
- *	subbuf_read_actor - read up to one subbuf's worth of data
+ *	page_read_actor - read up to one page's worth of data
  */
-static int subbuf_read_actor(size_t read_start,
-			     struct rchan_buf *buf,
-			     size_t avail,
-			     read_descriptor_t *desc,
-			     read_actor_t actor)
+static int page_read_actor(size_t read_start,
+			   struct rchan_buf *buf,
+			   size_t avail,
+			   read_descriptor_t *desc,
+			   read_actor_t actor)
 {
 	void *from;
 	int ret = 0;
@@ -1030,19 +1030,19 @@ static int subbuf_read_actor(size_t read_start,
 	return ret;
 }
 
-typedef int (*subbuf_actor_t) (size_t read_start,
-			       struct rchan_buf *buf,
-			       size_t avail,
-			       read_descriptor_t *desc,
-			       read_actor_t actor);
+typedef int (*page_actor_t) (size_t read_start,
+			     struct rchan_buf *buf,
+			     size_t avail,
+			     read_descriptor_t *desc,
+			     read_actor_t actor);
 
 /*
- *	relay_file_read_subbufs - read count bytes, bridging subbuf
boundaries
+ *	relay_file_read_pages - read count bytes, bridging page boundaries
  */
-static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
-					subbuf_actor_t subbuf_actor,
-					read_actor_t actor,
-					read_descriptor_t *desc)
+static ssize_t relay_file_read_pages(struct file *filp, loff_t *ppos,
+				     page_actor_t page_actor,
+				     read_actor_t actor,
+				     read_descriptor_t *desc)
 {
 	struct rchan_buf *buf = filp->private_data;
 	size_t read_start, avail;
@@ -1054,12 +1054,12 @@ static ssize_t relay_file_read_subbufs(struct
file *filp, loff_t *ppos,
 	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	do {
 		read_start = relay_file_read_start_pos(*ppos, buf);
-		avail = relay_file_read_subbuf_avail(read_start, buf);
+		avail = relay_file_read_page_avail(read_start, buf);
 		if (!avail)
 			break;
 
 		avail = min(desc->count, avail);
-		ret = subbuf_actor(read_start, buf, avail, desc, actor);
+		ret = page_actor(read_start, buf, avail, desc, actor);
 		if (desc->error < 0)
 			break;
 
@@ -1083,17 +1083,17 @@ static ssize_t relay_file_read(struct file
*filp,
 	desc.count = count;
 	desc.arg.buf = buffer;
 	desc.error = 0;
-	return relay_file_read_subbufs(filp, ppos, subbuf_read_actor,
-				       NULL, &desc);
+	return relay_file_read_pages(filp, ppos, page_read_actor,
+				     NULL, &desc);
 }
 
 static void relay_consume_bytes(struct rchan_buf *rbuf, int
bytes_consumed)
 {
-	rbuf->bytes_consumed += bytes_consumed;
+	rbuf->consumed_offset += bytes_consumed;
 
-	if (rbuf->bytes_consumed >= rbuf->chan->subbuf_size) {
-		relay_subbufs_consumed(rbuf->chan, rbuf->cpu, 1);
-		rbuf->bytes_consumed %= rbuf->chan->subbuf_size;
+	if (rbuf->consumed_offset >= PAGE_SIZE) {
+		relay_pages_consumed(rbuf->chan, rbuf->cpu, 1);
+		rbuf->consumed_offset %= PAGE_SIZE;
 	}
 }
 
@@ -1121,17 +1121,16 @@ static void relay_page_release(struct
splice_pipe_desc *spd, unsigned int i)
 }
 
 /*
- *	subbuf_splice_actor - splice up to one subbuf's worth of data
+ *	page_splice_actor - splice available data
  */
-static int subbuf_splice_actor(struct file *in,
-			       loff_t *ppos,
-			       struct pipe_inode_info *pipe,
-			       size_t len,
-			       unsigned int flags)
+static int page_splice_actor(struct file *in,
+			     loff_t *ppos,
+			     struct pipe_inode_info *pipe,
+			     size_t len,
+			     unsigned int flags)
 {
-	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
+	unsigned int pidx, poff, total_len, buf_pages, nr_pages, ret;
 	struct rchan_buf *rbuf = in->private_data;
-	unsigned int subbuf_size = rbuf->chan->subbuf_size;
 	uint64_t pos = (uint64_t) *ppos;
 	uint32_t alloc_size = (uint32_t) rbuf->chan->alloc_size;
 	size_t read_start = (size_t) do_div(pos, alloc_size);
@@ -1146,20 +1145,14 @@ static int subbuf_splice_actor(struct file *in,
 		.spd_release = relay_page_release,
 	};
 
-	if (rbuf->subbufs_produced == rbuf->subbufs_consumed &&
-	    rbuf->offset == rbuf->bytes_consumed)
+	if (rbuf->produced == rbuf->consumed &&
+	    rbuf->offset == rbuf->consumed_offset)
 		return 0;
 
-	/*
-	 * Adjust read len, if longer than what is available
-	 */
-	if (len > (subbuf_size - read_start % subbuf_size))
-		len = subbuf_size - read_start % subbuf_size;
-
-	subbuf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
-	pidx = (read_start / PAGE_SIZE) % subbuf_pages;
+	buf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
+	pidx = (read_start / PAGE_SIZE) % buf_pages;
 	poff = read_start & ~PAGE_MASK;
-	nr_pages = min_t(unsigned int, subbuf_pages, PIPE_BUFFERS);
+	nr_pages = min_t(unsigned int, buf_pages, PIPE_BUFFERS);
 
 	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
 		unsigned int this_len;
@@ -1177,7 +1170,7 @@ static int subbuf_splice_actor(struct file *in,
 		len -= this_len;
 		total_len += this_len;
 		poff = 0;
-		pidx = (pidx + 1) % subbuf_pages;
+		pidx = (pidx + 1) % buf_pages;
 	}
 
 	ret = splice_to_pipe(pipe, &spd);
@@ -1198,7 +1191,7 @@ static ssize_t relay_file_splice_read(struct file
*in,
 	spliced = 0;
 
 	while (len && !spliced) {
-		ret = subbuf_splice_actor(in, ppos, pipe, len, flags);
+		ret = page_splice_actor(in, ppos, pipe, len, flags);
 		if (ret < 0)
 			break;
 		else if (!ret) {
diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 293a3c2..9373b34 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -28,7 +28,7 @@ struct kvm_trace {
 	int trace_state;
 	struct rchan *rchan;
 	struct dentry *lost_file;
-	int first_subbuf;
+	int first_page;
 };
 static struct kvm_trace *kvm_trace;
 
@@ -105,21 +105,21 @@ DEFINE_SIMPLE_ATTRIBUTE(kvm_trace_lost_ops,
lost_records_get, NULL, "%llu\n");
  *  many times we encountered a full subbuffer, to tell user space app
the
  *  lost records there were.
  */
-static void kvm_new_subbuf_callback(struct rchan_buf *buf,
-				    void *subbuf)
+static void kvm_new_page_callback(struct rchan_buf *buf,
+				  void *page_data)
 {
 	struct kvm_trace *kt = buf->chan->private_data;
 
 	relay_wakeup_readers(buf);
 
-	if (kt->first_subbuf) {
+	if (kt->first_page) {
 		/*
 		 * executed only once when the channel is opened
 		 * save metadata as first record
 		 */
-		subbuf_start_reserve(buf, sizeof(u32));
-		*(u32 *)subbuf = 0x12345678;
-		kt->first_subbuf = 0;
+		page_start_reserve(buf, sizeof(u32));
+		*(u32 *)page_data = 0x12345678;
+		kt->first_page = 0;
 	}
 }
 
@@ -139,7 +139,7 @@ static int kvm_remove_buf_file_callback(struct
dentry *dentry)
 }
 
 static struct rchan_callbacks kvm_relay_callbacks = {
-	.new_subbuf		= kvm_new_subbuf_callback,
+	.new_page		= kvm_new_page_callback,
 	.create_buf_file 	= kvm_create_buf_file_callack,
 	.remove_buf_file 	= kvm_remove_buf_file_callback,
 };
@@ -148,6 +148,7 @@ static int do_kvm_trace_enable(struct
kvm_user_trace_setup *kuts)
 {
 	struct kvm_trace *kt;
 	int i, r = -ENOMEM;
+	int n_pages, n_pages_wakeup;
 
 	if (!kuts->buf_size || !kuts->buf_nr)
 		return -EINVAL;
@@ -157,14 +158,16 @@ static int do_kvm_trace_enable(struct
kvm_user_trace_setup *kuts)
 		goto err;
 
 	r = -EIO;
-	kt->first_subbuf = 1;
+	kt->first_page = 1;
 	kt->lost_file = debugfs_create_file("lost_records", 0444,
kvm_debugfs_dir,
 					    kt, &kvm_trace_lost_ops);
 	if (!kt->lost_file)
 		goto err;
 
-	kt->rchan = relay_open("trace", kvm_debugfs_dir, kuts->buf_size,
-			       kuts->buf_nr, &kvm_relay_callbacks, kt, 0UL);
+	n_pages = (kuts->buf_size * kuts->buf_nr) / PAGE_SIZE;
+	n_pages_wakeup = kuts->buf_size / PAGE_SIZE;
+	kt->rchan = relay_open("trace", kvm_debugfs_dir, n_pages,
+			       n_pages_wakeup, &kvm_relay_callbacks, kt, 0UL);
 	if (!kt->rchan)
 		goto err;
 
-- 
1.5.3.5



