Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbXFLSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbXFLSST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbXFLSSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:18:05 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9241 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbXFLSSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:18:02 -0400
Date: Tue, 12 Jun 2007 20:15:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of     splice actor
Message-ID: <20070612181540.GP18832@kernel.dk>
References: <20070611163433.dbc541ec.akpm@linux-foundation.org> <20070612063510.GO18832@kernel.dk> <20070612112059.GY18832@kernel.dk> <20070612113101.GZ18832@kernel.dk> <1181649983.7348.309.camel@twins> <20070612121047.GB18832@kernel.dk> <1181650572.7348.312.camel@twins> <20070612124449.GD18832@kernel.dk> <20070612094615.9e5557e5.akpm@linux-foundation.org> <20070612173202.GO18832@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612173202.GO18832@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2007, Jens Axboe wrote:
> On Tue, Jun 12 2007, Andrew Morton wrote:
> > On Tue, 12 Jun 2007 14:44:50 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > splice
> > 
> > btw, I'm staring in profound mystification at this:
> > 
> > int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
> > 			   struct pipe_buffer *buf)
> > {
> > 	struct page *page = buf->page;
> > 
> > 	if (page_count(page) == 1) {
> > 		lock_page(page);
> > 		return 0;
> > 	}
> > 
> > 	return 1;
> > }
> > 
> > 
> > afacit that `if page_count(page)' test could be replaced by
> > `if today_is_tuesday()'.  But then I don't have the foggiest idea
> > what it's trying to do.
> > 
> > It would be nice to get some comments in and around here.
> > 
> > Also, I was trying to work out the role and responsibility of the ->pin
> > callback, and gave up.
> > 
> > There isn't a lot of point in explaining this over email - one should be
> > able to gain an understanding of these things by reading the code.  I think
> > the best way of tackling this would be to comprehensively document
> > pipe_buf_operations and pipe_inode_info, please...
> 
> OK so I wont explain it in detail here, I'll write up a good set of
> comments tonight.

I'll merge this into the #splice branch.

diff --git a/fs/pipe.c b/fs/pipe.c
index 3694af1..d007830 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -164,6 +164,20 @@ static void anon_pipe_buf_release(struct pipe_inode_info *pipe,
 		page_cache_release(page);
 }
 
+/**
+ * generic_pipe_buf_map - virtually map a pipe buffer
+ * @pipe:	the pipe that the buffer belongs to
+ * @buf:	the buffer that should be mapped
+ * @atomic:	whether to use an atomic map
+ *
+ * Description:
+ *	This function returns a kernel virtual address mapping for the
+ *	passed in @pipe_buffer. If @atomic is set, an atomic map is provided
+ *	and the caller has to be careful not to fault before calling
+ *	the unmap function.
+ *
+ *	Note that this function occupies KM_USER0 if @atomic != 0.
+ */
 void *generic_pipe_buf_map(struct pipe_inode_info *pipe,
 			   struct pipe_buffer *buf, int atomic)
 {
@@ -175,6 +189,15 @@ void *generic_pipe_buf_map(struct pipe_inode_info *pipe,
 	return kmap(buf->page);
 }
 
+/**
+ * generic_pipe_buf_unmap - unmap a previously mapped pipe buffer
+ * @pipe:	the pipe that the buffer belongs to
+ * @buf:	the buffer that should be unmapped
+ * @map_data:	the data that the mapping function returned
+ *
+ * Description:
+ *	This function undoes the mapping that ->map() provided.
+ */
 void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
 			    struct pipe_buffer *buf, void *map_data)
 {
@@ -185,11 +208,28 @@ void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
 		kunmap(buf->page);
 }
 
+/**
+ * generic_pipe_buf_steal - attempt to take ownership of a @pipe_buffer
+ * @pipe:	the pipe that the buffer belongs to
+ * @buf:	the buffer to attempt to steal
+ *
+ * Description:
+ *	This function attempts to steal the @struct page attached to
+ *	@buf. If successful, this function returns 0 and returns with
+ *	the page locked. The caller may then reuse the page for whatever
+ *	he wishes, the typical use is insertion into a different file
+ *	page cache.
+ */
 int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
 			   struct pipe_buffer *buf)
 {
 	struct page *page = buf->page;
 
+	/*
+	 * A reference of one is golden, that means that the owner of this
+	 * page is the only one holding a reference to it. lock the page
+	 * and return OK.
+	 */
 	if (page_count(page) == 1) {
 		lock_page(page);
 		return 0;
@@ -198,11 +238,30 @@ int generic_pipe_buf_steal(struct pipe_inode_info *pipe,
 	return 1;
 }
 
-void generic_pipe_buf_get(struct pipe_inode_info *info, struct pipe_buffer *buf)
+/**
+ * generic_pipe_buf_get - get a reference to a @struct pipe_buffer
+ * @pipe:	the pipe that the buffer belongs to
+ * @buf:	the buffer to get a reference to
+ *
+ * Description:
+ *	This function grabs an extra reference to @buf. It's used in
+ *	in the tee() system call, when we duplicate the buffers in one
+ *	pipe into another.
+ */
+void generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
 {
 	page_cache_get(buf->page);
 }
 
+/**
+ * generic_pipe_buf_confirm - verify contents of the pipe buffer
+ * @pipe:	the pipe that the buffer belongs to
+ * @buf:	the buffer to confirm
+ *
+ * Description:
+ *	This function does nothing, because the generic pipe code uses
+ *	pages that are always good when inserted into the pipe.
+ */
 int generic_pipe_buf_confirm(struct pipe_inode_info *info,
 			     struct pipe_buffer *buf)
 {
diff --git a/fs/splice.c b/fs/splice.c
index b125a61..dd3be2c 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -85,6 +85,10 @@ static void page_cache_pipe_buf_release(struct pipe_inode_info *pipe,
 	buf->flags &= ~PIPE_BUF_FLAG_LRU;
 }
 
+/*
+ * Check whether the contents of buf is OK to access. Since the content
+ * is a page cache page, IO may be in flight.
+ */
 static int page_cache_pipe_buf_confirm(struct pipe_inode_info *pipe,
 				       struct pipe_buffer *buf)
 {
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index cc09fe8..333f389 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -17,6 +17,22 @@ struct pipe_buffer {
 	unsigned long private;
 };
 
+/**
+ *	struct pipe_inode_info - a linux kernel pipe
+ *	@wait: reader/writer wait point in case of empty/full pipe
+ *	@nrbufs: the number of non-empty pipe buffers in this pipe
+ *	@curbuf: the current pipe buffer entry
+ *	@tmp_page: cached released page
+ *	@readers: number of current readers of this pipe
+ *	@writers: number of current writers of this pipe
+ *	@waiting_writers: number of writers blocked waiting for room
+ *	@r_counter: reader counter
+ *	@w_counter: writer counter
+ *	@fasync_readers: reader side fasync
+ *	@fasync_writers: writer side fasync
+ *	@inode: inode this pipe is attached to
+ *	@bufs: the circular array of pipe buffers
+ **/
 struct pipe_inode_info {
 	wait_queue_head_t wait;
 	unsigned int nrbufs, curbuf;
@@ -43,15 +59,65 @@ struct pipe_inode_info {
  *	->unmap()
  *
  * That is, ->map() must be called on a confirmed buffer,
- * same goes for ->steal().
+ * same goes for ->steal(). See below for the meaning of each
+ * operation. Also see kerneldoc in fs/pipe.c for the pipe
+ * and generic variants of these hooks.
  */
 struct pipe_buf_operations {
+	/*
+	 * This is set to 1, if the generic pipe read/write may coalesce
+	 * data into an existing buffer. If this is set to 0, a new pipe
+	 * page segment is always used for new data.
+	 */
 	int can_merge;
+
+	/*
+	 * ->map() returns a virtual address mapping of the pipe buffer.
+	 * The last integer flag reflects whether this should be an atomic
+	 * mapping or not. The atomic map is faster, however you can't take
+	 * page faults before calling ->unmap() again. So if you need to eg
+	 * access user data through copy_to/from_user(), then you must get
+	 * a non-atomic map. ->map() uses the KM_USER0 atomic slot for
+	 * atomic maps, so you can't map more than one pipe_buffer at once
+	 * and you have to be careful if mapping another page as source
+	 * or destination for a copy (IOW, it has to use something else
+	 * than KM_USER0).
+	 */
 	void * (*map)(struct pipe_inode_info *, struct pipe_buffer *, int);
+
+	/*
+	 * Undoes ->map(), finishes the virtual mapping of the pipe buffer.
+	 */
 	void (*unmap)(struct pipe_inode_info *, struct pipe_buffer *, void *);
+
+	/*
+	 * ->confirm() verifies that the data in the pipe buffer is there
+	 * and that the contents are good. If the pages in the pipe belong
+	 * to a file system, we may need to wait for IO completion in this
+	 * hook. Returns 0 for good, or a negative error value in case of
+	 * error.
+	 */
 	int (*confirm)(struct pipe_inode_info *, struct pipe_buffer *);
+
+	/*
+	 * When the contents of this pipe buffer has been completely
+	 * consumed by a reader, ->release() is called.
+	 */
 	void (*release)(struct pipe_inode_info *, struct pipe_buffer *);
+
+	/*
+	 * Attempt to take ownership of the pipe buffer and its contents.
+	 * ->steal() returns 0 for success, in which case the contents
+	 * of the pipe (the buf->page) is locked and now completely owned
+	 * by the caller. The page may then be transferred to a different
+	 * mapping, the most often used case is insertion into different
+	 * file address space cache.
+	 */
 	int (*steal)(struct pipe_inode_info *, struct pipe_buffer *);
+
+	/*
+	 * Get a reference to the pipe buffer.
+	 */
 	void (*get)(struct pipe_inode_info *, struct pipe_buffer *);
 };
 

-- 
Jens Axboe

