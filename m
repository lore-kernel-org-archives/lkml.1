Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbXBEOIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbXBEOIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXBEOIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:08:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbXBEOIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:08:42 -0500
Subject: [GFS2] Fix DIO deadlock [9/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wendy Cheng <wcheng@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:16:41 +0000
Message-Id: <1170685001.11001.288.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From a22b0aa4d1fe6c359001e3a807d4916684bf862d Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 14 Dec 2006 18:24:26 +0000
Subject: [PATCH] [GFS2] Fix DIO deadlock

This patch fixes Red Hat bugzilla #212627 in which a deadlock occurs
due to trying to take the i_mutex while holding a glock. The correct
locking order is defined as i_mutex -> glock in all cases.

I've left dealing with allocating writes. I know that we need to do
that, but for now this should do the trick. We don't need to take the
i_mutex on write, because the VFS has already taken it for us. On read
we don't need it since the glock is enough protection. The reason that
I've made some of the checks into a separate function is that we'll need
to do the checks again in the allocating write case eventually, so this
is partly in preparation for this. Likewise the return value test of !=
1 might look a bit odd and thats because we'll need a third return value
in case of requiring an allocation.

I've made the change to deferred mode on the glock to ensure flushing
read caches on other nodes. I notice that (using blktrace to look at
whats going on) we appear to do a better job of large I/Os than ext3
after this patch (in terms of not splitting up the I/Os).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Wendy Cheng <wcheng@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index d8d69a7..0118aa4 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -594,6 +594,36 @@ static void gfs2_invalidatepage(struct page *page, unsigned long offset)
 	return;
 }
 
+/**
+ * gfs2_ok_for_dio - check that dio is valid on this file
+ * @ip: The inode
+ * @rw: READ or WRITE
+ * @offset: The offset at which we are reading or writing
+ *
+ * Returns: 0 (to ignore the i/o request and thus fall back to buffered i/o)
+ *          1 (to accept the i/o request)
+ */
+static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
+{
+	/*
+	 * Should we return an error here? I can't see that O_DIRECT for
+	 * a journaled file makes any sense. For now we'll silently fall
+	 * back to buffered I/O, likewise we do the same for stuffed
+	 * files since they are (a) small and (b) unaligned.
+	 */
+	if (gfs2_is_jdata(ip))
+		return 0;
+
+	if (gfs2_is_stuffed(ip))
+		return 0;
+
+	if (offset > i_size_read(&ip->i_inode))
+		return 0;
+	return 1;
+}
+
+
+
 static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 			      const struct iovec *iov, loff_t offset,
 			      unsigned long nr_segs)
@@ -604,42 +634,28 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	struct gfs2_holder gh;
 	int rv;
 
-	if (rw == READ)
-		mutex_lock(&inode->i_mutex);
 	/*
-	 * Shared lock, even if its a write, since we do no allocation
-	 * on this path. All we need change is atime.
+	 * Deferred lock, even if its a write, since we do no allocation
+	 * on this path. All we need change is atime, and this lock mode
+	 * ensures that other nodes have flushed their buffered read caches
+	 * (i.e. their page cache entries for this inode). We do not,
+	 * unfortunately have the option of only flushing a range like
+	 * the VFS does.
 	 */
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, GL_ATIME, &gh);
 	rv = gfs2_glock_nq_atime(&gh);
 	if (rv)
-		goto out;
-
-	if (offset > i_size_read(inode))
-		goto out;
-
-	/*
-	 * Should we return an error here? I can't see that O_DIRECT for
-	 * a journaled file makes any sense. For now we'll silently fall
-	 * back to buffered I/O, likewise we do the same for stuffed
-	 * files since they are (a) small and (b) unaligned.
-	 */
-	if (gfs2_is_jdata(ip))
-		goto out;
-
-	if (gfs2_is_stuffed(ip))
-		goto out;
-
-	rv = blockdev_direct_IO_own_locking(rw, iocb, inode,
-					    inode->i_sb->s_bdev,
-					    iov, offset, nr_segs,
-					    gfs2_get_block_direct, NULL);
+		return rv;
+	rv = gfs2_ok_for_dio(ip, rw, offset);
+	if (rv != 1)
+		goto out; /* dio not valid, fall back to buffered i/o */
+
+	rv = blockdev_direct_IO_no_locking(rw, iocb, inode, inode->i_sb->s_bdev,
+					   iov, offset, nr_segs,
+					   gfs2_get_block_direct, NULL);
 out:
 	gfs2_glock_dq_m(1, &gh);
 	gfs2_holder_uninit(&gh);
-	if (rw == READ)
-		mutex_unlock(&inode->i_mutex);
-
 	return rv;
 }
 
-- 
1.4.4.2



