Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYAYQJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYAYQJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYAYQJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:09:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:38038 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751512AbYAYQJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:09:32 -0500
Date: Fri, 25 Jan 2008 17:09:31 +0100
From: Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: Zach Brown <zach.brown@oracle.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, ext3-users@redhat.com,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
Message-ID: <20080125160931.GC1767@duck.suse.cz>
References: <200712242302.lBON2O8s011190@agora.fsl.cs.sunysb.edu> <477BF72B.4000608@oracle.com> <20080114170609.GH4214@duck.suse.cz> <20080114131454.37eb7c12@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114131454.37eb7c12@think.oraclecorp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-01-08 13:14:54, Chris Mason wrote:
> On Mon, 14 Jan 2008 18:06:09 +0100
> Jan Kara <jack@suse.cz> wrote:
> > On Wed 02-01-08 12:42:19, Zach Brown wrote:
> > > Erez Zadok wrote:
> > > > Setting: ltp-full-20071031, dio01 test on ext3 with Linus's
> > > > latest tree. Kernel w/ SMP, preemption, and lockdep configured.
> > > 
> > > This is a real lock ordering problem.  Thanks for reporting it.
> > > 
> > > The updating of atime inside sys_mmap() orders the mmap_sem in the
> > > vfs outside of the journal handle in ext3's inode dirtying:
> > > 
> 
> [ lock inversion traces ]
>  
> > > Two fixes come to mind:
> > > 
> > > 1) use something like Peter's ->mmap_prepare() to update atime
> > > before acquiring the mmap_sem.
> > > ( http://lkml.org/lkml/2007/11/11/97 ).  I don't know if this would
> > > leave more paths which do a journal_start() while holding the
> > > mmap_sem.
> > > 
> > > 2) rework ext3's dio to only hold the jbd handle in
> > > ext3_get_block(). Chris has a patch for this kicking around
> > > somewhere but I'm told it has problems exposing old blocks in
> > > ordered data mode.
> > > 
> > > Does anyone have preferences?  I could go either way.  I certainly
> > > don't like the idea of journal handles being held across the
> > > entirety of fs/direct-io.c.  It's yet another case of O_DIRECT
> > > differing wildly from the buffered path :(.
> >   I've looked more into it and I think that 2) is the only way to go
> > since transaction start ranks below page lock (standard buffered
> > write path) and page lock ranks below mmap_sem. So we have at least
> > one more dependency mmap_sem must go before transaction start...
> 
> Just to clarify a little bit:
> 
> If ext3's DIO code only touches transactions in get_block, then it can
> violate data=ordered rules.  Basically the transaction that allocates
> the blocks might commit before the DIO code gets around to writing them.
> 
> A crash in the wrong place will expose stale data on disk.
  Hmm, I've looked at it and I don't think so - look at the rationale in
the patch below... That patch should fix the lock-inversion problem (at
least I see no lockdep warnings on my test machine).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

We cannot start transaction in ext3_direct_IO() and just let it last during the
whole write because dio_get_page() acquires mmap_sem which ranks above
transaction start (e.g. because we have dependency chain
mmap_sem->PageLock->journal_start, or because we update atime while holding
mmap_sem) and thus deadlocks could happen. We solve the problem by starting
a transaction separately for each ext3_get_block() call.

We *could* have a problem that we allocate a block and before its data are
written out the machine crashes and thus we expose stale data. But that
does not happen because for hole-filling generic code falls back to buffered
writes and for file extension, we add inode to orphan list and thus in
case of crash, journal replay will truncate inode back to the original size.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 9b162cd..5ab7c57 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -941,55 +941,45 @@ out:
 	return err;
 }
 
-#define DIO_CREDITS (EXT3_RESERVE_TRANS_BLOCKS + 32)
+/* Maximum number of blocks we map for direct IO at once. */
+#define DIO_MAX_BLOCKS 4096
+/*
+ * Number of credits we need for writing DIO_MAX_BLOCKS:
+ * We need sb + group descriptor + bitmap + inode -> 4
+ * For B blocks with A block pointers per block we need:
+ * 1 (triple ind.) + (B/A/A + 2) (doubly ind.) + (B/A + 2) (indirect).
+ * If we plug in 4096 for B and 256 for A (for 1KB block size), we get 25.
+ */
+#define DIO_CREDITS 25
 
 static int ext3_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	int ret = 0;
+	int ret = 0, started = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
-	if (!create)
-		goto get_block;		/* A read */
-
-	if (max_blocks == 1)
-		goto get_block;		/* A single block get */
-
-	if (handle->h_transaction->t_state == T_LOCKED) {
-		/*
-		 * Huge direct-io writes can hold off commits for long
-		 * periods of time.  Let this commit run.
-		 */
-		ext3_journal_stop(handle);
-		handle = ext3_journal_start(inode, DIO_CREDITS);
-		if (IS_ERR(handle))
+	if (create && !handle) {	/* Direct IO write... */
+		if (max_blocks > DIO_MAX_BLOCKS)
+			max_blocks = DIO_MAX_BLOCKS;
+		handle = ext3_journal_start(inode, DIO_CREDITS +
+				2 * EXT3_QUOTA_TRANS_BLOCKS(sb));
+		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-		goto get_block;
-	}
-
-	if (handle->h_buffer_credits <= EXT3_RESERVE_TRANS_BLOCKS) {
-		/*
-		 * Getting low on buffer credits...
-		 */
-		ret = ext3_journal_extend(handle, DIO_CREDITS);
-		if (ret > 0) {
-			/*
-			 * Couldn't extend the transaction.  Start a new one.
-			 */
-			ret = ext3_journal_restart(handle, DIO_CREDITS);
+			goto out;
 		}
+		started = 1;
 	}
 
-get_block:
-	if (ret == 0) {
-		ret = ext3_get_blocks_handle(handle, inode, iblock,
+	ret = ext3_get_blocks_handle(handle, inode, iblock,
 					max_blocks, bh_result, create, 0);
-		if (ret > 0) {
-			bh_result->b_size = (ret << inode->i_blkbits);
-			ret = 0;
-		}
+	if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+		ret = 0;
 	}
+	if (started)
+		ext3_journal_stop(handle);
+out:
 	return ret;
 }
 
@@ -1680,7 +1670,8 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * if the machine crashes during the write.
  *
  * If the O_DIRECT write is intantiating holes inside i_size and the machine
- * crashes then stale disk data _may_ be exposed inside the file.
+ * crashes then stale disk data _may_ be exposed inside the file. But current
+ * VFS code falls back into buffered path in that case so we are safe.
  */
 static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
@@ -1689,7 +1680,7 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct ext3_inode_info *ei = EXT3_I(inode);
-	handle_t *handle = NULL;
+	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
 	size_t count = iov_length(iov, nr_segs);
@@ -1697,17 +1688,21 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
 
-		handle = ext3_journal_start(inode, DIO_CREDITS);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out;
-		}
 		if (final_size > inode->i_size) {
+			/* Credits for sb + inode write */
+			handle = ext3_journal_start(inode, 2);
+			if (IS_ERR(handle)) {
+				ret = PTR_ERR(handle);
+				goto out;
+			}
 			ret = ext3_orphan_add(handle, inode);
-			if (ret)
-				goto out_stop;
+			if (ret) {
+				ext3_journal_stop(handle);
+				goto out;
+			}
 			orphan = 1;
 			ei->i_disksize = inode->i_size;
+			ext3_journal_stop(handle);
 		}
 	}
 
@@ -1715,18 +1710,21 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 				 offset, nr_segs,
 				 ext3_get_block, NULL);
 
-	/*
-	 * Reacquire the handle: ext3_get_block() can restart the transaction
-	 */
-	handle = ext3_journal_current_handle();
-
-out_stop:
-	if (handle) {
+	if (orphan) {
 		int err;
 
-		if (orphan && inode->i_nlink)
+		/* Credits for sb + inode write */
+		handle = ext3_journal_start(inode, 2);
+		if (IS_ERR(handle)) {
+			/* This is really bad luck. We've written the data
+			 * but cannot extend i_size. Bail out and pretend
+			 * the write failed... */
+			ret = PTR_ERR(handle);
+			goto out;
+		}
+		if (inode->i_nlink)
 			ext3_orphan_del(handle, inode);
-		if (orphan && ret > 0) {
+		if (ret > 0) {
 			loff_t end = offset + ret;
 			if (end > inode->i_size) {
 				ei->i_disksize = end;
