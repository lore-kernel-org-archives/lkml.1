Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbYJPGQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbYJPGQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbYJPGMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:12:46 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:52414 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718AbYJPGMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:12:45 -0400
X-Authority-Analysis: v=1.0 c=1 a=Vmd7uDE3s1cA:10 a=Z7WqBkqoVtEA:10
 a=oZYl7j6-XEw7o5bR72oA:9 a=8pgw5NIJD5u_fOOV1NQA:7
 a=L6GuLMrmJpTVRaVj6YL3sNz0F8AA:4 a=rPt6xJ-oxjAA:10
Subject: [RFC PATCH 12/21] Use linked lists instead of arrays for relay
	buffers.
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
Date: Thu, 16 Oct 2008 01:06:17 -0500
Message-Id: <1224137177.16328.231.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 include/linux/relay.h |   12 ++++-
 kernel/relay.c        |  108 ++++++++++++++++++++++++------------------------
 2 files changed, 63 insertions(+), 57 deletions(-)

diff --git a/include/linux/relay.h b/include/linux/relay.h
index 35a6e8c..35912d6 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -30,14 +30,21 @@
 #define RCHAN_MODE_OVERWRITE		0x00000001	/* 'flight' mode */
 #define RCHAN_GLOBAL_BUFFER		0x00000002	/* not using per-cpu */
 
+struct relay_page
+{
+	struct page *page;
+	struct list_head list;
+};
+
 /*
  * Per-cpu relay channel buffer
  */
 struct rchan_buf
 {
 	void *data;			/* address of current page */
-	struct page *page;		/* current page */
+	struct relay_page *page;	/* current write page */
 	size_t offset;			/* current offset into page */
+	size_t consumed_offset;		/* bytes consumed in cur page */
 	size_t produced;		/* count of pages produced */
 	size_t consumed;		/* count of pages consumed */
 	struct rchan *chan;		/* associated channel */
@@ -45,10 +52,9 @@ struct rchan_buf
 	struct timer_list timer; 	/* reader wake-up timer */
 	struct dentry *dentry;		/* channel file dentry */
 	struct kref kref;		/* channel buffer refcount */
-	struct page **page_array;	/* array of current buffer pages */
+	struct list_head pages;		/* current set of unconsumed pages */
 	unsigned int page_count;	/* number of current buffer pages */
 	unsigned int finalized;		/* buffer has been finalized */
-	size_t consumed_offset;		/* bytes consumed in cur page */
 	size_t early_bytes;		/* bytes consumed before VFS inited */
 	unsigned int cpu;		/* this buf's cpu */
 } ____cacheline_aligned;
diff --git a/kernel/relay.c b/kernel/relay.c
index 1a151b8..198301d 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -36,19 +36,35 @@ static void relay_file_mmap_close(struct vm_area_struct *vma)
 	buf->chan->cb->buf_unmapped(buf, vma->vm_file);
 }
 
+/* yeah, stupid, but temporary */
+static struct relay_page *find_buf_page_n(struct rchan_buf *buf, int n)
+{
+	struct list_head *page = buf->pages.next;
+	struct relay_page *rpage;
+
+	while(n--)
+		page = page->next;
+
+	rpage = list_entry(page, struct relay_page, list);
+
+	return rpage;
+}
+
 /*
  * fault() vm_op implementation for relay file mapping.
  */
 static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page;
+	struct relay_page *rpage;
 	struct rchan_buf *buf = vma->vm_private_data;
 	pgoff_t pgoff = vmf->pgoff;
 
 	if (!buf)
 		return VM_FAULT_OOM;
 
-	page = buf->page_array[pgoff];
+	rpage = find_buf_page_n(buf, pgoff);
+	page = rpage->page;
 
 	if (!page)
 		return VM_FAULT_SIGBUS;
@@ -66,35 +82,6 @@ static struct vm_operations_struct relay_file_mmap_ops = {
 	.close = relay_file_mmap_close,
 };
 
-/*
- * allocate an array of pointers of struct page
- */
-static struct page **relay_alloc_page_array(unsigned int n_pages)
-{
-	struct page **array;
-	size_t pa_size = n_pages * sizeof(struct page *);
-
-	if (pa_size > PAGE_SIZE) {
-		array = vmalloc(pa_size);
-		if (array)
-			memset(array, 0, pa_size);
-	} else {
-		array = kzalloc(pa_size, GFP_KERNEL);
-	}
-	return array;
-}
-
-/*
- * free an array of pointers of struct page
- */
-static void relay_free_page_array(struct page **array)
-{
-	if (is_vmalloc_addr(array))
-		vfree(array);
-	else
-		kfree(array);
-}
-
 /**
  *	relay_mmap_buf: - mmap channel buffer to process address space
  *	@buf: relay channel buffer
@@ -131,27 +118,29 @@ static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
  */
 static int relay_alloc_buf(struct rchan_buf *buf)
 {
-	unsigned int i, j;
-
-	buf->page_array = relay_alloc_page_array(buf->chan->n_pages + 1);
-	if (!buf->page_array)
-		return -ENOMEM;
+	unsigned int i;
+	struct relay_page *rpage = NULL;
 
 	for (i = 0; i < buf->chan->n_pages; i++) {
-		buf->page_array[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
-		if (unlikely(!buf->page_array[i]))
+		rpage = kmalloc(sizeof(struct relay_page), GFP_KERNEL);
+		if (unlikely(!rpage))
+			goto depopulate;
+		rpage->page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (unlikely(!rpage->page))
 			goto depopulate;
-		set_page_private(buf->page_array[i], (unsigned long)buf);
+		set_page_private(rpage->page, (unsigned long)buf);
+		list_add_tail(&rpage->list, &buf->pages);
 	}
-	buf->page_array[buf->chan->n_pages] = buf->page_array[0];
 
 	buf->page_count = buf->chan->n_pages;
 	return 0;
 
 depopulate:
-	for (j = 0; j < i; j++)
-		__free_page(buf->page_array[j]);
-	relay_free_page_array(buf->page_array);
+	list_for_each_entry(rpage, &buf->pages, list) {
+		__free_page(rpage->page);
+		list_del(&rpage->list);
+	}
+
 	return -ENOMEM;
 }
 
@@ -167,6 +156,7 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 	if (!buf)
 		return NULL;
 
+	INIT_LIST_HEAD(&buf->pages);
 	buf->chan = chan;
 	kref_get(&buf->chan->kref);
 
@@ -199,11 +189,13 @@ static void relay_destroy_channel(struct kref *kref)
 static void relay_destroy_buf(struct rchan_buf *buf)
 {
 	struct rchan *chan = buf->chan;
-	unsigned int i;
+	struct relay_page *rpage, *rpage2;
 
-	for (i = 0; i < buf->page_count; i++)
-		__free_page(buf->page_array[i]);
-	relay_free_page_array(buf->page_array);
+	list_for_each_entry_safe(rpage, rpage2, &buf->pages, list) {
+		__free_page(rpage->page);
+		list_del(&rpage->list);
+		kfree(rpage);
+	}
 
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf);
@@ -344,8 +336,8 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 	buf->consumed = 0;
 	buf->consumed_offset = 0;
 	buf->finalized = 0;
-	buf->page = buf->page_array[0];
-	buf->data = page_address(buf->page);
+	buf->page = list_first_entry(&buf->pages, struct relay_page, list);
+	buf->data = page_address(buf->page->page);
 	buf->offset = 0;
 
 	buf->chan->cb->new_page(buf, buf->data);
@@ -719,6 +711,7 @@ size_t relay_switch_page_default_callback(struct rchan_buf *buf,
 					  void **reserved)
 {
 	size_t remainder;
+	struct list_head *next_page;
 
 	if (unlikely(relay_event_toobig(buf, length)))
 		goto toobig;
@@ -735,8 +728,11 @@ size_t relay_switch_page_default_callback(struct rchan_buf *buf,
 	relay_inc_produced(buf);
 	relay_update_filesize(buf, PAGE_SIZE + remainder);
 
-	buf->page = buf->page_array[buf->produced % buf->chan->n_pages];
-	buf->data = page_address(buf->page);
+	next_page = buf->page->list.next;
+	if (next_page == &buf->pages)
+		next_page = buf->pages.next;
+	buf->page = list_entry(next_page, struct relay_page, list);
+	buf->data = page_address(buf->page->page);
 
 	buf->offset = 0; /* remainder will be added by caller */
 	buf->chan->cb->new_page(buf, buf->data);
@@ -943,12 +939,12 @@ static size_t relay_file_read_page_avail(size_t read_pos,
 					 struct rchan_buf *buf)
 {
 	size_t avail;
-	struct page *read_page, *write_page;
+	struct relay_page *read_page, *write_page;
 	size_t read_offset, write_offset;
 
 	write_page = buf->page;
 	write_offset = buf->offset;
-	read_page = buf->page_array[read_pos / PAGE_SIZE];
+	read_page = find_buf_page_n(buf, read_pos / PAGE_SIZE);
 	read_offset = read_pos % PAGE_SIZE;
 
 	if (read_page == write_page && read_offset == write_offset)
@@ -1010,8 +1006,10 @@ static int page_read_actor(size_t read_start,
 {
 	void *from;
 	int ret = 0;
+	struct relay_page *rpage;
 
-	from = page_address(buf->page_array[read_start / PAGE_SIZE]);
+	rpage = find_buf_page_n(buf, read_start / PAGE_SIZE);
+	from = page_address(rpage->page);
 	from += read_start % PAGE_SIZE;
 	ret = avail;
 	if (copy_to_user(desc->arg.buf, from, avail)) {
@@ -1149,13 +1147,15 @@ static int page_splice_actor(struct file *in,
 
 	for (total_len = 0; spd.nr_pages < nr_pages; spd.nr_pages++) {
 		unsigned int this_len;
+		struct relay_page *rpage;
 
 		if (!len)
 			break;
 
 		this_len = min_t(unsigned long, len, PAGE_SIZE - poff);
 
-		spd.pages[spd.nr_pages] = rbuf->page_array[pidx];
+		rpage = find_buf_page_n(rbuf, pidx);
+		spd.pages[spd.nr_pages] = rpage->page;
 		spd.partial[spd.nr_pages].offset = poff;
 
 		spd.partial[spd.nr_pages].len = this_len;
-- 
1.5.3.5



