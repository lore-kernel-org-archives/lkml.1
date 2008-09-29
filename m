Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYI2FnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYI2FnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 01:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYI2Fk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 01:40:58 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:43453 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004AbYI2Fkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 01:40:55 -0400
X-Authority-Analysis: v=1.0 c=1 a=FRWCsyH6KJwA:10 a=jlwINyl7EjUA:10
 a=bvnsfeOpY1UewBW1VOEA:9 a=c2EkQLGFZRjbaGwsi0MA:7
 a=jw-LT78xvfEGqeeEdLjqnJAjxvUA:4 a=si9q_4b84H0A:10 a=eZLSmJVMEtUA:10
Subject: [RFC PATCH 11/11] relay - Remove vmap of relay buffers.
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
Date: Mon, 29 Sep 2008 00:40:51 -0500
Message-Id: <1222666851.7637.184.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove vmap of relay buffers.

Also removes relay_reserve and switches callers over to relay_write.

Signed-off-by: Tom Zanussi <zanussi@comcast.net>

---
 block/blktrace.c      |    8 ++++-
 include/linux/relay.h |   47 +++++++++---------------------------
 kernel/relay.c        |   63 +++++++++++++++++++++---------------------------
 3 files changed, 46 insertions(+), 72 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 84a9cb4..f60665e 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -35,7 +35,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + len);
+	t = kmalloc(sizeof(*t) + len, GFP_KERNEL);
 	if (t) {
 		const int cpu = smp_processor_id();
 
@@ -47,6 +47,8 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 		t->cpu = cpu;
 		t->pdu_len = len;
 		memcpy((void *) t + sizeof(*t), data, len);
+		relay_write(bt->rchan, t, sizeof(*t) + len);
+		kfree(t);
 	}
 }
 
@@ -166,7 +168,7 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (unlikely(tsk->btrace_seq != blktrace_seq))
 		trace_note_tsk(bt, tsk);
 
-	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
+	t = kmalloc(sizeof(*t) + pdu_len, GFP_KERNEL);
 	if (t) {
 		cpu = smp_processor_id();
 		sequence = per_cpu_ptr(bt->sequence, cpu);
@@ -185,6 +187,8 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 		if (pdu_len)
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
+		relay_write(bt->rchan, t, sizeof(*t) + pdu_len);
+		kfree(t);
 	}
 
 	local_irq_restore(flags);
diff --git a/include/linux/relay.h b/include/linux/relay.h
index e0b1730..35a6e8c 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -35,8 +35,8 @@
  */
 struct rchan_buf
 {
-	void *start;			/* start of channel buffer */
-	void *data;			/* start of current page */
+	void *data;			/* address of current page */
+	struct page *page;		/* current page */
 	size_t offset;			/* current offset into page */
 	size_t produced;		/* count of pages produced */
 	size_t consumed;		/* count of pages consumed */
@@ -288,17 +288,19 @@ static inline void relay_write(struct rchan *chan,
 	size_t remainder = length;
 	struct rchan_buf *buf;
 	unsigned long flags;
-	void *reserved;
+	void *reserved, *reserved2;
 
 	local_irq_save(flags);
 	buf = chan->buf[smp_processor_id()];
 	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > PAGE_SIZE)) {
-		remainder = chan->cb->switch_page(buf, length, &reserved);
-		if (unlikely(!reserved)) {
+		remainder = chan->cb->switch_page(buf, length, &reserved2);
+		if (unlikely(!reserved2)) {
 			local_irq_restore(flags);
 			return;
 		}
+		length -= remainder;
+		memcpy(reserved2, data + length, remainder);
 	}
 	memcpy(reserved, data, length);
 	buf->offset += remainder;
@@ -324,16 +326,18 @@ static inline void __relay_write(struct rchan *chan,
 	size_t remainder = length;
 	struct rchan_buf *buf;
 	unsigned long flags;
-	void *reserved;
+	void *reserved, *reserved2;
 
 	buf = chan->buf[get_cpu()];
 	reserved = buf->data + buf->offset;
 	if (unlikely(buf->offset + length > PAGE_SIZE)) {
-		remainder = chan->cb->switch_page(buf, length, &reserved);
-		if (unlikely(!reserved)) {
+		remainder = chan->cb->switch_page(buf, length, &reserved2);
+		if (unlikely(!reserved2)) {
 			local_irq_restore(flags);
 			return;
 		}
+		length -= remainder;
+		memcpy(reserved2, data + length, remainder);
 	}
 	memcpy(reserved, data, length);
 	buf->offset += remainder;
@@ -341,33 +345,6 @@ static inline void __relay_write(struct rchan *chan,
 }
 
 /**
- *	relay_reserve - reserve slot in channel buffer
- *	@chan: relay channel
- *	@length: number of bytes to reserve
- *
- *	Returns pointer to reserved slot, NULL if full.
- *
- *	Reserves a slot in the current cpu's channel buffer.
- *	Does not protect the buffer at all - caller must provide
- *	appropriate synchronization.
- */
-static inline void *relay_reserve(struct rchan *chan,
-				  size_t length)
-{
-	struct rchan_buf *buf = chan->buf[smp_processor_id()];
-	void *reserved = buf->data + buf->offset;
-
-	if (unlikely(buf->offset + length > PAGE_SIZE)) {
-		length = chan->cb->switch_page(buf, length, &reserved);
-		if (unlikely(!reserved))
-			return NULL;
-	}
-	buf->offset += length;
-
-	return reserved;
-}
-
-/**
  *	page_start_reserve - reserve bytes at the start of a page
  *	@buf: relay channel buffer
  *	@length: number of bytes to reserve
diff --git a/kernel/relay.c b/kernel/relay.c
index 137f13f..1a151b8 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -48,7 +48,8 @@ static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (!buf)
 		return VM_FAULT_OOM;
 
-	page = vmalloc_to_page(buf->start + (pgoff << PAGE_SHIFT));
+	page = buf->page_array[pgoff];
+
 	if (!page)
 		return VM_FAULT_SIGBUS;
 	get_page(page);
@@ -126,39 +127,32 @@ static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
  *	relay_alloc_buf - allocate a channel buffer
  *	@buf: the buffer struct
  *
- *	Returns a pointer to the resulting buffer, %NULL if unsuccessful. The
- *	passed in size will get page aligned, if it isn't already.
+ *	Returns 0 if successful.
  */
-static void *relay_alloc_buf(struct rchan_buf *buf)
+static int relay_alloc_buf(struct rchan_buf *buf)
 {
-	void *mem;
 	unsigned int i, j;
 
 	buf->page_array = relay_alloc_page_array(buf->chan->n_pages + 1);
 	if (!buf->page_array)
-		return NULL;
+		return -ENOMEM;
 
 	for (i = 0; i < buf->chan->n_pages; i++) {
-		buf->page_array[i] = alloc_page(GFP_KERNEL);
+		buf->page_array[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (unlikely(!buf->page_array[i]))
 			goto depopulate;
 		set_page_private(buf->page_array[i], (unsigned long)buf);
 	}
 	buf->page_array[buf->chan->n_pages] = buf->page_array[0];
-	mem = vmap(buf->page_array, buf->chan->n_pages + 1, VM_MAP,
-		   PAGE_KERNEL);
-	if (!mem)
-		goto depopulate;
 
-	memset(mem, 0, buf->chan->alloc_size);
 	buf->page_count = buf->chan->n_pages;
-	return mem;
+	return 0;
 
 depopulate:
 	for (j = 0; j < i; j++)
 		__free_page(buf->page_array[j]);
 	relay_free_page_array(buf->page_array);
-	return NULL;
+	return -ENOMEM;
 }
 
 /**
@@ -176,8 +170,7 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 	buf->chan = chan;
 	kref_get(&buf->chan->kref);
 
-	buf->start = relay_alloc_buf(buf);
-	if (!buf->start)
+	if (relay_alloc_buf(buf))
 		goto free_buf;
 
 	return buf;
@@ -208,12 +201,10 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 	struct rchan *chan = buf->chan;
 	unsigned int i;
 
-	if (likely(buf->start)) {
-		vunmap(buf->start);
-		for (i = 0; i < buf->page_count; i++)
-			__free_page(buf->page_array[i]);
-		relay_free_page_array(buf->page_array);
-	}
+	for (i = 0; i < buf->page_count; i++)
+		__free_page(buf->page_array[i]);
+	relay_free_page_array(buf->page_array);
+
 	chan->buf[buf->cpu] = NULL;
 	kfree(buf);
 	kref_put(&chan->kref, relay_destroy_channel);
@@ -353,7 +344,8 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 	buf->consumed = 0;
 	buf->consumed_offset = 0;
 	buf->finalized = 0;
-	buf->data = buf->start;
+	buf->page = buf->page_array[0];
+	buf->data = page_address(buf->page);
 	buf->offset = 0;
 
 	buf->chan->cb->new_page(buf, buf->data);
@@ -726,8 +718,7 @@ size_t relay_switch_page_default_callback(struct rchan_buf *buf,
 					  size_t length,
 					  void **reserved)
 {
-	size_t remainder, new_page;
-	void *new_data;
+	size_t remainder;
 
 	if (unlikely(relay_event_toobig(buf, length)))
 		goto toobig;
@@ -744,16 +735,18 @@ size_t relay_switch_page_default_callback(struct rchan_buf *buf,
 	relay_inc_produced(buf);
 	relay_update_filesize(buf, PAGE_SIZE + remainder);
 
-	new_page = buf->produced % buf->chan->n_pages;
-	new_data = buf->start + new_page * PAGE_SIZE;
+	buf->page = buf->page_array[buf->produced % buf->chan->n_pages];
+	buf->data = page_address(buf->page);
 
-	buf->data = new_data;
 	buf->offset = 0; /* remainder will be added by caller */
-	buf->chan->cb->new_page(buf, new_data);
+	buf->chan->cb->new_page(buf, buf->data);
 
 	if (unlikely(relay_event_toobig(buf, length + buf->offset)))
 		goto toobig;
 
+	if (reserved)
+		*reserved = buf->data;
+
 	return remainder;
 toobig:
 	buf->chan->last_toobig = length;
@@ -950,11 +943,12 @@ static size_t relay_file_read_page_avail(size_t read_pos,
 					 struct rchan_buf *buf)
 {
 	size_t avail;
-	size_t read_page, read_offset, write_page, write_offset;
+	struct page *read_page, *write_page;
+	size_t read_offset, write_offset;
 
-	write_page = (buf->data - buf->start) / PAGE_SIZE;
+	write_page = buf->page;
 	write_offset = buf->offset;
-	read_page = read_pos / PAGE_SIZE;
+	read_page = buf->page_array[read_pos / PAGE_SIZE];
 	read_offset = read_pos % PAGE_SIZE;
 
 	if (read_page == write_page && read_offset == write_offset)
@@ -1017,7 +1011,8 @@ static int page_read_actor(size_t read_start,
 	void *from;
 	int ret = 0;
 
-	from = buf->start + read_start;
+	from = page_address(buf->page_array[read_start / PAGE_SIZE]);
+	from += read_start % PAGE_SIZE;
 	ret = avail;
 	if (copy_to_user(desc->arg.buf, from, avail)) {
 		desc->error = -EFAULT;
@@ -1057,12 +1052,10 @@ static ssize_t relay_file_read_pages(struct file *filp, loff_t *ppos,
 		avail = relay_file_read_page_avail(read_start, buf);
 		if (!avail)
 			break;
-
 		avail = min(desc->count, avail);
 		ret = page_actor(read_start, buf, avail, desc, actor);
 		if (desc->error < 0)
 			break;
-
 		if (ret) {
 			relay_file_read_consume(buf, read_start, ret);
 			*ppos = relay_file_read_end_pos(buf, read_start, ret);
-- 
1.5.3.5



