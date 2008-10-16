Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYJPGQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYJPGQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYJPGMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:12:52 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:46405 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819AbYJPGMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:12:50 -0400
X-Authority-Analysis: v=1.0 c=1 a=d728KSVTm2UA:10 a=MsmdzJcb9H8A:10
 a=DZlNO97b9MHlZIiY7lIA:9 a=OvTaYti-Jq8qhcZ0IOoA:7
 a=-t30Bs3BvjKoK3SD2hneZX7tdQ4A:4 a=wZiCkNY6m2YA:10 a=i92e0Ub4el8A:10
 a=d_-3mwAUsuEA:10 a=vNGxQsTWjH8A:10
Subject: [RFC PATCH 13/21] Make relay buffers variable-length.
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
Date: Thu, 16 Oct 2008 01:06:23 -0500
Message-Id: <1224137183.16328.232.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make everything use variable-length relay buffers and remove
everything that this change makes obsolete, including mmap.
---
 include/linux/relay.h |   69 +++-------
 kernel/relay.c        |  385 +++++++++++++------------------------------------
 2 files changed, 121 insertions(+), 333 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 35912d6..91e253f 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -27,8 +27,7 @@
 /*
  * relay channel flags
  */
-#define RCHAN_MODE_OVERWRITE		0x00000001	/* 'flight' mode */
-#define RCHAN_GLOBAL_BUFFER		0x00000002	/* not using per-cpu */
+#define RCHAN_GLOBAL_BUFFER		0x00000001	/* not using per-cpu */
 
 struct relay_page
 {
@@ -44,16 +43,15 @@ struct rchan_buf
 	void *data;			/* address of current page */
 	struct relay_page *page;	/* current write page */
 	size_t offset;			/* current offset into page */
-	size_t consumed_offset;		/* bytes consumed in cur page */
-	size_t produced;		/* count of pages produced */
-	size_t consumed;		/* count of pages consumed */
 	struct rchan *chan;		/* associated channel */
 	wait_queue_head_t read_wait;	/* reader wait queue */
 	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
 	struct list_head pages;		/* current set of unconsumed pages */
-	unsigned int page_count;	/* number of current buffer pages */
+	size_t consumed_offset;		/* bytes consumed in cur page */
+	size_t nr_pages;		/* number of unconsumed pages */
+	struct list_head pool;		/* current set of unused pages */
 	unsigned int finalized;		/* buffer has been finalized */
 	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
@@ -67,7 +65,6 @@ struct rchan
 	u32 version;			/* the version of this struct */
 	size_t n_pages;			/* number of pages per buffer */
 	size_t n_pages_wakeup;		/* wake up readers after filling n */
-	size_t alloc_size;		/* total buffer size allocated */
 	struct rchan_callbacks *cb;	/* client callbacks */
 	struct kref kref;		/* channel refcount */
 	void *private_data;		/* for user-defined data */
@@ -107,25 +104,6 @@ struct rchan_callbacks
 			  void *page_data);
 
 	/*
-	 * buf_mapped - relay buffer mmap notification
-	 * @buf: the channel buffer
-	 * @filp: relay file pointer
-	 *
-	 * Called when a relay file is successfully mmapped
-	 */
-        void (*buf_mapped)(struct rchan_buf *buf,
-			   struct file *filp);
-
-	/*
-	 * buf_unmapped - relay buffer unmap notification
-	 * @buf: the channel buffer
-	 * @filp: relay file pointer
-	 *
-	 * Called when a relay file is successfully unmapped
-	 */
-        void (*buf_unmapped)(struct rchan_buf *buf,
-			     struct file *filp);
-	/*
 	 * create_buf_file - create file to represent a relay channel buffer
 	 * @filename: the name of the file to create
 	 * @parent: the parent of the file to create
@@ -184,23 +162,21 @@ struct rchan_callbacks
  * CONFIG_RELAY kernel API, kernel/relay.c
  */
 
-struct rchan *relay_open(const char *base_filename,
-			 struct dentry *parent,
-			 size_t n_pages,
-			 size_t n_pages_wakeup,
-			 struct rchan_callbacks *cb,
-			 void *private_data,
-			 unsigned long rchan_flags);
-extern int relay_late_setup_files(struct rchan *chan,
-				  const char *base_filename,
-				  struct dentry *parent);
+extern struct rchan *relay_open(const char *base_filename,
+				struct dentry *parent,
+				size_t n_pages,
+				size_t n_pages_wakeup,
+				struct rchan_callbacks *cb,
+				void *private_data,
+				unsigned long rchan_flags);
 extern void relay_close(struct rchan *chan);
 extern void relay_flush(struct rchan *chan);
-extern void relay_pages_consumed(struct rchan *chan,
-				 unsigned int cpu,
-				 size_t consumed);
 extern void relay_reset(struct rchan *chan);
-extern int relay_buf_full(struct rchan_buf *buf);
+extern void relay_add_page(struct rchan_buf *buf, struct page *page);
+
+extern int relay_late_setup_files(struct rchan *chan,
+				  const char *base_filename,
+				  struct dentry *parent);
 
 extern size_t relay_switch_page_default_callback(struct rchan_buf *buf,
 						 size_t length,
@@ -221,7 +197,7 @@ static inline void relay_wakeup_readers(struct rchan_buf *buf)
 {
 	size_t wakeup = buf->chan->n_pages_wakeup;
 
-	if (wakeup && (buf->produced % wakeup == 0) &&
+	if (wakeup && (buf->nr_pages % wakeup == 0) &&
 	    (waitqueue_active(&buf->read_wait)))
 		/*
 		 * Calling wake_up_interruptible() from here
@@ -264,17 +240,6 @@ static inline void relay_update_filesize(struct rchan_buf *buf, size_t length)
 }
 
 /**
- *	relay_inc_produced - increase number of pages produced by 1
- *	@buf: relay channel buffer
- *
- *	switch_page() helper function.
- */
-static inline void relay_inc_produced(struct rchan_buf *buf)
-{
-	buf->produced++;
-}
-
-/**
  *	relay_write - write data into the channel
  *	@chan: relay channel
  *	@data: data to be written
diff --git a/kernel/relay.c b/kernel/relay.c
index 198301d..574b995 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -27,96 +27,83 @@
 static DEFINE_MUTEX(relay_channels_mutex);
 static LIST_HEAD(relay_channels);
 
-/*
- * close() vm_op implementation for relay file mapping.
+/**
+ *	__relay_get_rpage - get an empty relay page struct
+ *	@buf: the buffer struct
  */
-static void relay_file_mmap_close(struct vm_area_struct *vma)
+struct relay_page *__relay_get_rpage(struct rchan_buf *buf)
 {
-	struct rchan_buf *buf = vma->vm_private_data;
-	buf->chan->cb->buf_unmapped(buf, vma->vm_file);
+	return kmalloc(sizeof(struct relay_page), GFP_ATOMIC);
 }
 
-/* yeah, stupid, but temporary */
-static struct relay_page *find_buf_page_n(struct rchan_buf *buf, int n)
+/**
+ *	__relay_remove_page - remove a page from relay and add to free pool
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
+ */
+static void __relay_remove_page(struct rchan_buf *buf,
+				struct relay_page *rpage)
 {
-	struct list_head *page = buf->pages.next;
-	struct relay_page *rpage;
-
-	while(n--)
-		page = page->next;
-
-	rpage = list_entry(page, struct relay_page, list);
-
-	return rpage;
+	list_del(&rpage->list);
+	buf->nr_pages--;
+	list_add_tail(&rpage->list, &buf->pool);
 }
 
-/*
- * fault() vm_op implementation for relay file mapping.
+/**
+ *	__relay_add_page - add a relay page to relay
+ *	@buf: the buffer struct
+ *	@rpage: struct relay_page
  */
-static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static void __relay_add_page(struct rchan_buf *buf, struct relay_page *rpage)
 {
-	struct page *page;
-	struct relay_page *rpage;
-	struct rchan_buf *buf = vma->vm_private_data;
-	pgoff_t pgoff = vmf->pgoff;
-
-	if (!buf)
-		return VM_FAULT_OOM;
-
-	rpage = find_buf_page_n(buf, pgoff);
-	page = rpage->page;
-
-	if (!page)
-		return VM_FAULT_SIGBUS;
-	get_page(page);
-	vmf->page = page;
-
-	return 0;
+	list_add_tail(&rpage->list, &buf->pages);
+	buf->nr_pages++;
+	relay_update_filesize(buf, PAGE_SIZE);
 }
 
-/*
- * vm_ops for relay file mappings.
- */
-static struct vm_operations_struct relay_file_mmap_ops = {
-	.fault = relay_buf_fault,
-	.close = relay_file_mmap_close,
-};
-
 /**
- *	relay_mmap_buf: - mmap channel buffer to process address space
- *	@buf: relay channel buffer
- *	@vma: vm_area_struct describing memory to be mapped
- *
- *	Returns 0 if ok, negative on error
+ *	relay_add_page - add a page to relay
+ *	@buf: the buffer struct
+ *	@page: struct page
  *
- *	Caller should already have grabbed mmap_sem.
+ *	relay now owns the page.
  */
-static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
+void relay_add_page(struct rchan_buf *buf, struct page *page)
 {
-	unsigned long length = vma->vm_end - vma->vm_start;
-	struct file *filp = vma->vm_file;
+	struct relay_page *rpage = __relay_get_rpage(buf);
 
-	if (!buf)
-		return -EBADF;
+	if (likely(rpage)) {
+		rpage->page = page;
+		__relay_add_page(buf, rpage);
+	}
+}
+EXPORT_SYMBOL_GPL(relay_add_page);
 
-	if (length != (unsigned long)buf->chan->alloc_size)
-		return -EINVAL;
+/**
+ *	relay_get_page - get a free relay page from the pool
+ *	@buf: the buffer struct
+ *
+ *	Returns relay page if successful, NULL if not.
+ */
+static struct relay_page *relay_get_free_page(struct rchan_buf *buf)
+{
+	struct relay_page *rpage = NULL;
 
-	vma->vm_ops = &relay_file_mmap_ops;
-	vma->vm_flags |= VM_DONTEXPAND;
-	vma->vm_private_data = buf;
-	buf->chan->cb->buf_mapped(buf, filp);
+	if (!list_empty(&buf->pool)) {
+		rpage = list_first_entry(&buf->pool, struct relay_page, list);
+		list_del(&rpage->list);
+	}
 
-	return 0;
+	return rpage;
 }
 
 /**
- *	relay_alloc_buf - allocate a channel buffer
+ *	relay_alloc_pool - allocate a pool of pages for writers
  *	@buf: the buffer struct
  *
  *	Returns 0 if successful.
  */
-static int relay_alloc_buf(struct rchan_buf *buf)
+static int relay_alloc_pool(struct rchan_buf *buf)
 {
 	unsigned int i;
 	struct relay_page *rpage = NULL;
@@ -129,14 +116,13 @@ static int relay_alloc_buf(struct rchan_buf *buf)
 		if (unlikely(!rpage->page))
 			goto depopulate;
 		set_page_private(rpage->page, (unsigned long)buf);
-		list_add_tail(&rpage->list, &buf->pages);
+		list_add_tail(&rpage->list, &buf->pool);
 	}
 
-	buf->page_count = buf->chan->n_pages;
 	return 0;
 
 depopulate:
-	list_for_each_entry(rpage, &buf->pages, list) {
+	list_for_each_entry(rpage, &buf->pool, list) {
 		__free_page(rpage->page);
 		list_del(&rpage->list);
 	}
@@ -156,11 +142,12 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 	if (!buf)
 		return NULL;
 
+	INIT_LIST_HEAD(&buf->pool);
 	INIT_LIST_HEAD(&buf->pages);
 	buf->chan = chan;
 	kref_get(&buf->chan->kref);
 
-	if (relay_alloc_buf(buf))
+	if (relay_alloc_pool(buf))
 		goto free_buf;
 
 	return buf;
@@ -191,7 +178,7 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 	struct rchan *chan = buf->chan;
 	struct relay_page *rpage, *rpage2;
 
-	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list) {
+	list_for_each_entry_safe(rpage, rpage2, &buf->pool, list) {
 		__free_page(rpage->page);
 		list_del(&rpage->list);
 		kfree(rpage);
@@ -225,22 +212,9 @@ static void relay_remove_buf(struct kref *kref)
  */
 static int relay_buf_empty(struct rchan_buf *buf)
 {
-	return (buf->produced - buf->consumed) ? 0 : 1;
+	return !buf->nr_pages;
 }
 
-/**
- *	relay_buf_full - boolean, is the channel buffer full?
- *	@buf: channel buffer
- *
- *	Returns 1 if the buffer is full, 0 otherwise.
- */
-int relay_buf_full(struct rchan_buf *buf)
-{
-	size_t ready = buf->produced - buf->consumed;
-	return (ready >= buf->chan->n_pages) ? 1 : 0;
-}
-EXPORT_SYMBOL_GPL(relay_buf_full);
-
 /*
  * High-level relay kernel API and associated functions.
  */
@@ -251,22 +225,6 @@ EXPORT_SYMBOL_GPL(relay_buf_full);
  */
 
 /*
- * buf_mapped() default callback.  Does nothing.
- */
-static void buf_mapped_default_callback(struct rchan_buf *buf,
-					struct file *filp)
-{
-}
-
-/*
- * buf_unmapped() default callback.  Does nothing.
- */
-static void buf_unmapped_default_callback(struct rchan_buf *buf,
-					  struct file *filp)
-{
-}
-
-/*
  * create_buf_file_create() default callback.  Does nothing.
  */
 static struct dentry *create_buf_file_default_callback(const char *filename,
@@ -297,8 +255,6 @@ static void new_page_default_callback(struct rchan_buf *buf,
 /* relay channel default callbacks */
 static struct rchan_callbacks default_channel_callbacks = {
 	.new_page = new_page_default_callback,
-	.buf_mapped = buf_mapped_default_callback,
-	.buf_unmapped = buf_unmapped_default_callback,
 	.create_buf_file = create_buf_file_default_callback,
 	.remove_buf_file = remove_buf_file_default_callback,
 	.switch_page = relay_switch_page_default_callback,
@@ -332,11 +288,9 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 	} else
 		del_timer_sync(&buf->timer);
 
-	buf->produced = 0;
-	buf->consumed = 0;
 	buf->consumed_offset = 0;
 	buf->finalized = 0;
-	buf->page = list_first_entry(&buf->pages, struct relay_page, list);
+	buf->page = relay_get_free_page(buf);
 	buf->data = page_address(buf->page->page);
 	buf->offset = 0;
 
@@ -464,10 +418,6 @@ static void setup_callbacks(struct rchan *chan,
 		return;
 	}
 
-	if (!cb->buf_mapped)
-		cb->buf_mapped = buf_mapped_default_callback;
-	if (!cb->buf_unmapped)
-		cb->buf_unmapped = buf_unmapped_default_callback;
 	if (!cb->create_buf_file)
 		cb->create_buf_file = create_buf_file_default_callback;
 	if (!cb->remove_buf_file)
@@ -558,7 +508,6 @@ struct rchan *relay_open(const char *base_filename,
 	chan->version = RELAYFS_CHANNEL_VERSION;
 	chan->n_pages = n_pages;
 	chan->n_pages_wakeup = n_pages_wakeup;
-	chan->alloc_size = PAGE_SIZE * n_pages;
 	chan->parent = parent;
 	chan->flags = rchan_flags;
 	atomic_set(&chan->dropped, 0);
@@ -683,18 +632,6 @@ int relay_late_setup_files(struct rchan *chan,
 	return err;
 }
 
-static inline int next_page_free(struct rchan_buf *buf)
-{
-	size_t full_pages;
-
-	if (buf->chan->flags & RCHAN_MODE_OVERWRITE)
-		return 1;
-
-	full_pages = buf->produced - buf->consumed;
-
-	return (full_pages < buf->chan->n_pages - 1);
-}
-
 /**
  *	relay_switch_page_default_callback - switch to a new page
  *	@buf: channel buffer
@@ -711,13 +648,14 @@ size_t relay_switch_page_default_callback(struct rchan_buf *buf,
 					  void **reserved)
 {
 	size_t remainder;
-	struct list_head *next_page;
+	struct relay_page *new_page;
 
 	if (unlikely(relay_event_toobig(buf, length)))
 		goto toobig;
 
 	/* don't write anything unless we can write it all. */
-	if (!next_page_free(buf)) {
+	new_page = relay_get_free_page(buf);
+	if (!new_page) {
 		if (reserved)
 			*reserved = NULL;
 		atomic_inc(&buf->chan->dropped);
@@ -725,13 +663,10 @@ size_t relay_switch_page_default_callback(struct rchan_buf *buf,
 	}
 
 	remainder = length - (PAGE_SIZE - buf->offset);
-	relay_inc_produced(buf);
-	relay_update_filesize(buf, PAGE_SIZE + remainder);
 
-	next_page = buf->page->list.next;
-	if (next_page == &buf->pages)
-		next_page = buf->pages.next;
-	buf->page = list_entry(next_page, struct relay_page, list);
+	__relay_add_page(buf, buf->page);
+
+	buf->page = new_page;
 	buf->data = page_address(buf->page->page);
 
 	buf->offset = 0; /* remainder will be added by caller */
@@ -751,38 +686,6 @@ toobig:
 EXPORT_SYMBOL_GPL(relay_switch_page_default_callback);
 
 /**
- *	relay_pages_consumed - update the buffer's pages-consumed count
- *	@chan: the channel
- *	@cpu: the cpu associated with the channel buffer to update
- *	@consumed: number of pages to add to current buf's count
- *
- *	Adds to the channel buffer's consumed page count.
- *	consumed should be the number of pages newly consumed,
- *	not the total consumed.
- *
- *	NOTE. Kernel clients don't need to call this function if the channel
- *	mode is 'overwrite'.
- */
-void relay_pages_consumed(struct rchan *chan,
-			  unsigned int cpu,
-			  size_t consumed)
-{
-	struct rchan_buf *buf;
-
-	if (!chan)
-		return;
-
-	if (cpu >= NR_CPUS || !chan->buf[cpu])
-		return;
-
-	buf = chan->buf[cpu];
-	buf->consumed += consumed;
-	if (buf->consumed > buf->produced)
-		buf->consumed = buf->produced;
-}
-EXPORT_SYMBOL_GPL(relay_pages_consumed);
-
-/**
  *	relay_close - close the channel
  *	@chan: the channel
  *
@@ -863,19 +766,6 @@ static int relay_file_open(struct inode *inode, struct file *filp)
 }
 
 /**
- *	relay_file_mmap - mmap file op for relay files
- *	@filp: the file
- *	@vma: the vma describing what to map
- *
- *	Calls upon relay_mmap_buf() to map the file into user space.
- */
-static int relay_file_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct rchan_buf *buf = filp->private_data;
-	return relay_mmap_buf(buf, vma);
-}
-
-/**
  *	relay_file_poll - poll file op for relay files
  *	@filp: the file
  *	@wait: poll table
@@ -915,91 +805,40 @@ static int relay_file_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/*
- *	relay_file_read_consume - update the consumed count for the buffer
- */
-static void relay_file_read_consume(struct rchan_buf *buf,
-				    size_t read_pos,
-				    size_t bytes_consumed)
-{
-	buf->consumed_offset += bytes_consumed;
-
-	if (buf->consumed_offset == PAGE_SIZE) {
-		relay_pages_consumed(buf->chan, buf->cpu, 1);
-		buf->consumed_offset = 0;
-	}
-}
-
 /**
- *	relay_file_read_page_avail - return bytes available in page
- *	@read_pos: file read position
+ *	relay_file_read_page_avail - return bytes available in next page
  *	@buf: relay channel buffer
  */
-static size_t relay_file_read_page_avail(size_t read_pos,
-					 struct rchan_buf *buf)
+static size_t relay_file_read_page_avail(struct rchan_buf *buf)
 {
-	size_t avail;
-	struct relay_page *read_page, *write_page;
-	size_t read_offset, write_offset;
+	size_t avail = 0;
 
-	write_page = buf->page;
-	write_offset = buf->offset;
-	read_page = find_buf_page_n(buf, read_pos / PAGE_SIZE);
-	read_offset = read_pos % PAGE_SIZE;
-
-	if (read_page == write_page && read_offset == write_offset)
-		return 0;
-
-	avail = PAGE_SIZE - read_offset;
-
-	if (read_page == write_page && read_offset < write_offset)
-		avail = write_offset - read_offset;
+	if (!list_empty(&buf->pages))
+		avail = PAGE_SIZE - buf->consumed_offset;
 
 	return avail;
 }
 
-/**
- *	relay_file_read_start_pos - find the first available byte to read
- *	@read_pos: file read position
- *	@buf: relay channel buffer
- *
- *	If the @read_pos is 0, return the position of the first
- *	unconsumed byte, otherwise return the original value.
- */
-static size_t relay_file_read_start_pos(size_t read_pos,
-					struct rchan_buf *buf)
-{
-	size_t consumed = buf->consumed % buf->chan->n_pages;
-
-	if (!read_pos)
-		read_pos = consumed * PAGE_SIZE + buf->consumed_offset;
-
-	return read_pos;
-}
-
-/**
- *	relay_file_read_end_pos - return the new read position
- *	@read_pos: file read position
- *	@buf: relay channel buffer
- *	@count: number of bytes to be read
+/*
+ *	relay_consume - update the consumed count for the buffer
  */
-static size_t relay_file_read_end_pos(struct rchan_buf *buf,
-				      size_t read_pos,
-				      size_t count)
+static void relay_consume(struct rchan_buf *buf, int bytes_consumed)
 {
-	size_t end_pos = read_pos + count;
+	buf->consumed_offset += bytes_consumed;
 
-	if (end_pos >= PAGE_SIZE * buf->chan->n_pages)
-		end_pos = 0;
+	if (buf->consumed_offset == PAGE_SIZE) {
+		struct relay_page *rpage;
+		rpage = list_first_entry(&buf->pages, struct relay_page, list);
+		__relay_remove_page(buf, rpage); 
 
-	return end_pos;
+		buf->consumed_offset = 0;
+	}
 }
 
 /*
  *	page_read_actor - read up to one page's worth of data
  */
-static int page_read_actor(size_t read_start,
-			   struct rchan_buf *buf,
+static int page_read_actor(struct rchan_buf *buf,
 			   size_t avail,
 			   read_descriptor_t *desc,
 			   read_actor_t actor)
@@ -1008,9 +847,10 @@ static int page_read_actor(size_t read_start,
 	int ret = 0;
 	struct relay_page *rpage;
 
-	rpage = find_buf_page_n(buf, read_start / PAGE_SIZE);
+	rpage = list_first_entry(&buf->pages, struct relay_page, list);
+
 	from = page_address(rpage->page);
-	from += read_start % PAGE_SIZE;
+	from += PAGE_SIZE - avail;
 	ret = avail;
 	if (copy_to_user(desc->arg.buf, from, avail)) {
 		desc->error = -EFAULT;
@@ -1023,8 +863,7 @@ static int page_read_actor(size_t read_start,
 	return ret;
 }
 
-typedef int (*page_actor_t) (size_t read_start,
-			     struct rchan_buf *buf,
+typedef int (*page_actor_t) (struct rchan_buf *buf,
 			     size_t avail,
 			     read_descriptor_t *desc,
 			     read_actor_t actor);
@@ -1038,7 +877,7 @@ static ssize_t relay_file_read_pages(struct file *filp, loff_t *ppos,
 				     read_descriptor_t *desc)
 {
 	struct rchan_buf *buf = filp->private_data;
-	size_t read_start, avail;
+	size_t avail;
 	int ret;
 
 	if (!desc->count)
@@ -1046,17 +885,16 @@ static ssize_t relay_file_read_pages(struct file *filp, loff_t *ppos,
 
 	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	do {
-		read_start = relay_file_read_start_pos(*ppos, buf);
-		avail = relay_file_read_page_avail(read_start, buf);
+		avail = relay_file_read_page_avail(buf);
 		if (!avail)
 			break;
 		avail = min(desc->count, avail);
-		ret = page_actor(read_start, buf, avail, desc, actor);
+		ret = page_actor(buf, avail, desc, actor);
 		if (desc->error < 0)
 			break;
 		if (ret) {
-			relay_file_read_consume(buf, read_start, ret);
-			*ppos = relay_file_read_end_pos(buf, read_start, ret);
+			relay_consume(buf, ret);
+			*ppos += ret;
 		}
 	} while (desc->count && ret);
 	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
@@ -1078,23 +916,13 @@ static ssize_t relay_file_read(struct file *filp,
 				     NULL, &desc);
 }
 
-static void relay_consume_bytes(struct rchan_buf *rbuf, int bytes_consumed)
-{
-	rbuf->consumed_offset += bytes_consumed;
-
-	if (rbuf->consumed_offset >= PAGE_SIZE) {
-		relay_pages_consumed(rbuf->chan, rbuf->cpu, 1);
-		rbuf->consumed_offset %= PAGE_SIZE;
-	}
-}
-
 static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
 				   struct pipe_buffer *buf)
 {
 	struct rchan_buf *rbuf;
 
 	rbuf = (struct rchan_buf *)page_private(buf->page);
-	relay_consume_bytes(rbuf, buf->private);
+	relay_consume(rbuf, buf->private);
 }
 
 static struct pipe_buf_operations relay_pipe_buf_ops = {
@@ -1115,16 +943,13 @@ static void relay_page_release(struct splice_pipe_desc *spd, unsigned int i)
  *	page_splice_actor - splice available data
  */
 static int page_splice_actor(struct file *in,
-			     loff_t *ppos,
 			     struct pipe_inode_info *pipe,
 			     size_t len,
 			     unsigned int flags)
 {
-	unsigned int pidx, poff, total_len, buf_pages, nr_pages, ret;
-	struct rchan_buf *rbuf = in->private_data;
-	uint64_t pos = (uint64_t) *ppos;
-	uint32_t alloc_size = (uint32_t) rbuf->chan->alloc_size;
-	size_t read_start = (size_t) do_div(pos, alloc_size);
+	unsigned int poff, total_len, nr_pages, ret;
+	struct rchan_buf *buf = in->private_data;
+	struct relay_page *rpage;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
 	struct splice_pipe_desc spd = {
@@ -1136,34 +961,33 @@ static int page_splice_actor(struct file *in,
 		.spd_release = relay_page_release,
 	};
 
-	if (rbuf->produced == rbuf->consumed &&
-	    rbuf->offset == rbuf->consumed_offset)
+	if (list_empty(&buf->pages))
 		return 0;
 
-	buf_pages = rbuf->chan->alloc_size >> PAGE_SHIFT;
-	pidx = (read_start / PAGE_SIZE) % buf_pages;
-	poff = read_start & ~PAGE_MASK;
-	nr_pages = min_t(unsigned int, buf_pages, PIPE_BUFFERS);
+	poff = buf->consumed_offset;
+	nr_pages = min_t(unsigned int, buf->nr_pages, PIPE_BUFFERS);
+	total_len = 0;
 
-	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
+	list_for_each_entry(rpage, &buf->pages, list) {
 		unsigned int this_len;
-		struct relay_page *rpage;
+
+		if (spd.nr_pages >= nr_pages)
+			break;
 
 		if (!len)
 			break;
 
 		this_len = min_t(unsigned long, len, PAGE_SIZE - poff);
 
-		rpage = find_buf_page_n(rbuf, pidx);
 		spd.pages[spd.nr_pages] = rpage->page;
 		spd.partial[spd.nr_pages].offset = poff;
-
 		spd.partial[spd.nr_pages].len = this_len;
+		spd.partial[spd.nr_pages].private = this_len;
 
 		len -= this_len;
 		total_len += this_len;
 		poff = 0;
-		pidx = (pidx + 1) % buf_pages;
+		spd.nr_pages++;
 	}
 
 	ret = splice_to_pipe(pipe, &spd);
@@ -1184,7 +1008,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 	spliced = 0;
 
 	while (len && !spliced) {
-		ret = page_splice_actor(in, ppos, pipe, len, flags);
+		ret = page_splice_actor(in, pipe, len, flags);
 		if (ret < 0)
 			break;
 		else if (!ret) {
@@ -1213,7 +1037,6 @@ static ssize_t relay_file_splice_read(struct file *in,
 const struct file_operations relay_file_operations = {
 	.open		= relay_file_open,
 	.poll		= relay_file_poll,
-	.mmap		= relay_file_mmap,
 	.read		= relay_file_read,
 	.llseek		= no_llseek,
 	.release	= relay_file_release,
-- 
1.5.3.5



