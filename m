Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZCEXfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZCEXfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZCEXed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:34:33 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37054 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbZCEXeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:34:31 -0500
Message-Id: <20090305225512.756882817@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [RFC patch 06/41] LTTng optimize write to page function
Content-Disposition: inline; filename=lttng-optimize-write-to-page-function.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions in ltt-relay-alloc.c take care of writing the data into
the buffer pages. Those pages are allocated from the page allocator and
no virtual mapping is done so we can save precious TLB entries.
ltt-relay-alloc.c is the abstraction layer which makes the buffers
"look" like a contiguous memory area, although they are made from
physically discontiguous pages linked with a linked list. A caching
mechanism makes sure we never walk over more than 1-2 entries of the
list. We use a linked list rather than a table to make sure we don't
depend on vmalloc to allocate large pointer arrays.

I did a bit of profiling with oprofile on LTTng and found out that write
functions in ltt-relay-alloc.c were taking a lot of CPU time. I thought it would
be good to improve them a bit.

Running a 2.6.29-rc3 kernel

Compiling a 2.6.25 kernel using make -j10 on a 8-cores x86_64 with a vanilla
2.6.29-rc3 kernel (all tests are cache-hot) :
real 1m22.103s

With dormant instrumentation
real 1m24.667s
(note : this 2s regression should be identified eventually by doing a bissection
of the LTTng tree.)

ltt-armall

Without modification, with flight recorder tracing active :
real 1m31.135s

Replacing the memcpy call with a specialized call for 1, 2, 4 and 8 bytes :
real 1m30.440s

Inlining the fast path of the write function (v2) :
real 1m29.349s


* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
>
> > +static inline void ltt_relay_do_copy(void *dest, const void *src, size_t
+len)
> > +{
> > +   switch (len) {
> > +   case 1: *(u8 *)dest = *(const u8 *)src;
> > +           break;
> > +   case 2: *(u16 *)dest = *(const u16 *)src;
> > +           break;
> > +   case 4: *(u32 *)dest = *(const u32 *)src;
> > +           break;
> > +#if (BITS_PER_LONG == 64)
> > +   case 8: *(u64 *)dest = *(const u64 *)src;
> > +           break;
> > +#endif
> > +   default:
> > +           memcpy(dest, src, len);
> > +   }
> > +}
>
> hm, interesting.
>
> IIRC, few month ago, linus said this optimization is not optimazation.
> lastest gcc does this inlining automatically.
> (but I can't point its url, sorry)
>
> Is this result gcc version independent? and can you send
> the difference of gcc assembly outout?



Here we go :

x86_64
gcc (Debian 4.3.2-1) 4.3.2 (haven't tried other compiler versions)
kernel 2.6.29-rc3

char dataout[100];
char datain[100];

int sizea = 8;

void testfct_ltt(void)
{
        asm ("/* begin */");
        ltt_relay_do_copy(dataout, datain, sizea);
        asm ("/* end*/");
}

Turns into a jump table :

        movslq  sizea(%rip),%rdx
        cmpq    $8, %rdx
        jbe     .L15
.L6:
        movq    $datain, %rsi
        movq    $dataout, %rdi
        call    memcpy
        .p2align 4,,10
        .p2align 3
.L7:
[...]
.L15:
        jmp     *.L12(,%rdx,8)

        .section        .rodata
        .align 8
        .align 4
.L12:
        .quad   .L7
        .quad   .L8
        .quad   .L9
        .quad   .L6
        .quad   .L10
        .quad   .L6
        .quad   .L6
        .quad   .L6
        .quad   .L11
        .text
        .p2align 4,,10
        .p2align 3
.L11:
        movq    datain(%rip), %rax
        movq    %rax, dataout(%rip)
        jmp     .L7
        .p2align 4,,10
        .p2align 3
.L8:
        movzbl  datain(%rip), %eax
        movb    %al, dataout(%rip)
        jmp     .L7
        .p2align 4,,10
        .p2align 3
.L9:
        movzwl  datain(%rip), %eax
        movw    %ax, dataout(%rip)
        jmp     .L7
        .p2align 4,,10
        .p2align 3
.L10:
        movl    datain(%rip), %eax
        movl    %eax, dataout(%rip)
        jmp     .L7
        .size   testfct_ltt, .-testfct_ltt
        .p2align 4,,15


void testfct_memcpy(void)
{
        asm ("/* begin */");
        memcpy(dataout, datain, sizea);
        asm ("/* end */");
}

Turns into a function call because the size is not statically known :

        movslq  sizea(%rip),%rdx
        movq    $datain, %rsi
        movq    $dataout, %rdi
        call    memcpy


Below, when a constant is passed, both behave similarly :

void testfct_ltt_const(void)
{
        asm ("/* begin */");
        ltt_relay_do_copy(dataout, datain, 8);
        asm ("/* end*/");
}

        movq    datain(%rip), %rax
        movq    %rax, dataout(%rip)


void testfct_memcpy_const(void)
{
        asm ("/* begin */");
        memcpy(dataout, datain, 8);
        asm ("/* end */");
}

        movq    datain(%rip), %rax
        movq    %rax, dataout(%rip)


Therefore, I agree that when memcpy is passed a constant, it will do
the same as my ltt_relay_do_copy. However, when we know we usually
expect sizes of 1, 2, 4 and 8 bytes (unknown at compile-time), the jump
table saves the costly function call to memcpy.


Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Martin Bligh <mbligh@google.com>
CC: Zhaolei <zhaolei@cn.fujitsu.com>
---
 include/linux/ltt-relay.h |   91 ++++++++++++++++++++++++++++++++++++++++++++--
 ltt/ltt-relay-alloc.c     |   80 +++++++++-------------------------------
 2 files changed, 107 insertions(+), 64 deletions(-)

Index: linux-2.6-lttng/ltt/ltt-relay-alloc.c
===================================================================
--- linux-2.6-lttng.orig/ltt/ltt-relay-alloc.c	2009-03-05 15:22:47.000000000 -0500
+++ linux-2.6-lttng/ltt/ltt-relay-alloc.c	2009-03-05 15:22:49.000000000 -0500
@@ -428,7 +428,7 @@ EXPORT_SYMBOL_GPL(ltt_relay_close);
 /*
  * Start iteration at the previous element. Skip the real list head.
  */
-static struct buf_page *ltt_relay_find_prev_page(struct rchan_buf *buf,
+struct buf_page *ltt_relay_find_prev_page(struct rchan_buf *buf,
 	struct buf_page *page, size_t offset, ssize_t diff_offset)
 {
 	struct buf_page *iter;
@@ -460,13 +460,15 @@ static struct buf_page *ltt_relay_find_p
 			return iter;
 		}
 	}
+	WARN_ON(1);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(ltt_relay_find_prev_page);
 
 /*
  * Start iteration at the next element. Skip the real list head.
  */
-static struct buf_page *ltt_relay_find_next_page(struct rchan_buf *buf,
+struct buf_page *ltt_relay_find_next_page(struct rchan_buf *buf,
 	struct buf_page *page, size_t offset, ssize_t diff_offset)
 {
 	struct buf_page *iter;
@@ -498,48 +500,10 @@ static struct buf_page *ltt_relay_find_n
 			return iter;
 		}
 	}
+	WARN_ON(1);
 	return NULL;
 }
-
-/*
- * Find the page containing "offset". Cache it if it is after the currently
- * cached page.
- */
-static struct buf_page *ltt_relay_cache_page(struct rchan_buf *buf,
-		struct buf_page **page_cache,
-		struct buf_page *page, size_t offset)
-{
-	ssize_t diff_offset;
-	ssize_t half_buf_size = buf->chan->alloc_size >> 1;
-
-	/*
-	 * Make sure this is the page we want to write into. The current
-	 * page is changed concurrently by other writers. [wrh]page are
-	 * used as a cache remembering the last page written
-	 * to/read/looked up for header address. No synchronization;
-	 * could have to find the previous page is a nested write
-	 * occured. Finding the right page is done by comparing the
-	 * dest_offset with the buf_page offsets.
-	 * When at the exact opposite of the buffer, bias towards forward search
-	 * because it will be cached.
-	 */
-
-	diff_offset = (ssize_t)offset - (ssize_t)page->offset;
-	if (diff_offset <= -(ssize_t)half_buf_size)
-		diff_offset += buf->chan->alloc_size;
-	else if (diff_offset > half_buf_size)
-		diff_offset -= buf->chan->alloc_size;
-
-	if (unlikely(diff_offset >= (ssize_t)PAGE_SIZE)) {
-		page = ltt_relay_find_next_page(buf, page, offset, diff_offset);
-		WARN_ON(!page);
-		*page_cache = page;
-	} else if (unlikely(diff_offset < 0)) {
-		page = ltt_relay_find_prev_page(buf, page, offset, diff_offset);
-		WARN_ON(!page);
-	}
-	return page;
-}
+EXPORT_SYMBOL_GPL(ltt_relay_find_next_page);
 
 /**
  * ltt_relay_write - write data to a ltt_relay buffer.
@@ -547,26 +511,14 @@ static struct buf_page *ltt_relay_cache_
  * @offset : offset within the buffer
  * @src : source address
  * @len : length to write
+ * @page : cached buffer page
+ * @pagecpy : page size copied so far
  */
-int ltt_relay_write(struct rchan_buf *buf, size_t offset,
-	const void *src, size_t len)
+void _ltt_relay_write(struct rchan_buf *buf, size_t offset,
+	const void *src, size_t len, struct buf_page *page, ssize_t pagecpy)
 {
-	struct buf_page *page;
-	ssize_t pagecpy, orig_len;
-
-	orig_len = len;
-	offset &= buf->chan->alloc_size - 1;
-	page = buf->wpage;
-	if (unlikely(!len))
-		return 0;
-	for (;;) {
-		page = ltt_relay_cache_page(buf, &buf->wpage, page, offset);
-		pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
-		memcpy(page_address(page->page)
-			+ (offset & ~PAGE_MASK), src, pagecpy);
+	do {
 		len -= pagecpy;
-		if (likely(!len))
-			break;
 		src += pagecpy;
 		offset += pagecpy;
 		/*
@@ -574,10 +526,14 @@ int ltt_relay_write(struct rchan_buf *bu
 		 * subbuffers.
 		 */
 		WARN_ON(offset >= buf->chan->alloc_size);
-	}
-	return orig_len;
+
+		page = ltt_relay_cache_page(buf, &buf->wpage, page, offset);
+		pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
+		ltt_relay_do_copy(page_address(page->page)
+			+ (offset & ~PAGE_MASK), src, pagecpy);
+	} while (unlikely(len != pagecpy));
 }
-EXPORT_SYMBOL_GPL(ltt_relay_write);
+EXPORT_SYMBOL_GPL(_ltt_relay_write);
 
 /**
  * ltt_relay_read - read data from ltt_relay_buffer.
Index: linux-2.6-lttng/include/linux/ltt-relay.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/ltt-relay.h	2009-03-05 15:22:47.000000000 -0500
+++ linux-2.6-lttng/include/linux/ltt-relay.h	2009-03-05 15:23:47.000000000 -0500
@@ -137,8 +137,14 @@ struct rchan_callbacks {
 	int (*remove_buf_file)(struct dentry *dentry);
 };
 
-extern int ltt_relay_write(struct rchan_buf *buf, size_t offset,
-	const void *src, size_t len);
+extern struct buf_page *ltt_relay_find_prev_page(struct rchan_buf *buf,
+	struct buf_page *page, size_t offset, ssize_t diff_offset);
+
+extern struct buf_page *ltt_relay_find_next_page(struct rchan_buf *buf,
+	struct buf_page *page, size_t offset, ssize_t diff_offset);
+
+extern void _ltt_relay_write(struct rchan_buf *buf, size_t offset,
+	const void *src, size_t len, struct buf_page *page, ssize_t pagecpy);
 
 extern int ltt_relay_read(struct rchan_buf *buf, size_t offset,
 	void *dest, size_t len);
@@ -156,6 +162,87 @@ extern void *ltt_relay_offset_address(st
 	size_t offset);
 
 /*
+ * Find the page containing "offset". Cache it if it is after the currently
+ * cached page.
+ */
+static inline struct buf_page *ltt_relay_cache_page(struct rchan_buf *buf,
+		struct buf_page **page_cache,
+		struct buf_page *page, size_t offset)
+{
+	ssize_t diff_offset;
+	ssize_t half_buf_size = buf->chan->alloc_size >> 1;
+
+	/*
+	 * Make sure this is the page we want to write into. The current
+	 * page is changed concurrently by other writers. [wrh]page are
+	 * used as a cache remembering the last page written
+	 * to/read/looked up for header address. No synchronization;
+	 * could have to find the previous page is a nested write
+	 * occured. Finding the right page is done by comparing the
+	 * dest_offset with the buf_page offsets.
+	 * When at the exact opposite of the buffer, bias towards forward search
+	 * because it will be cached.
+	 */
+
+	diff_offset = (ssize_t)offset - (ssize_t)page->offset;
+	if (diff_offset <= -(ssize_t)half_buf_size)
+		diff_offset += buf->chan->alloc_size;
+	else if (diff_offset > half_buf_size)
+		diff_offset -= buf->chan->alloc_size;
+
+	if (unlikely(diff_offset >= (ssize_t)PAGE_SIZE)) {
+		page = ltt_relay_find_next_page(buf, page, offset, diff_offset);
+		*page_cache = page;
+	} else if (unlikely(diff_offset < 0)) {
+		page = ltt_relay_find_prev_page(buf, page, offset, diff_offset);
+	}
+	return page;
+}
+
+static inline void ltt_relay_do_copy(void *dest, const void *src, size_t len)
+{
+	switch (len) {
+	case 0:
+		break;
+	case 1:
+		*(u8 *)dest = *(const u8 *)src;
+		break;
+	case 2:
+		*(u16 *)dest = *(const u16 *)src;
+		break;
+	case 4:
+		*(u32 *)dest = *(const u32 *)src;
+		break;
+#if (BITS_PER_LONG == 64)
+	case 8:
+		*(u64 *)dest = *(const u64 *)src;
+		break;
+#endif
+	default:
+		memcpy(dest, src, len);
+	}
+}
+
+static inline int ltt_relay_write(struct rchan_buf *buf, size_t offset,
+	const void *src, size_t len)
+{
+	struct buf_page *page;
+	ssize_t pagecpy;
+
+	offset &= buf->chan->alloc_size - 1;
+	page = buf->wpage;
+
+	page = ltt_relay_cache_page(buf, &buf->wpage, page, offset);
+	pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
+	ltt_relay_do_copy(page_address(page->page)
+		+ (offset & ~PAGE_MASK), src, pagecpy);
+
+	if (unlikely(len != pagecpy))
+		_ltt_relay_write(buf, offset, src, len, page, pagecpy);
+	return len;
+}
+
+/*
  * CONFIG_LTT_RELAY kernel API, ltt/ltt-relay-alloc.c
  */
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
