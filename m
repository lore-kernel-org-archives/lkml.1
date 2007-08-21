Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbXHUAmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbXHUAmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXHUAm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:42:27 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:51707 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbXHUAm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:42:27 -0400
X-Greylist: delayed 1790 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 20:42:26 EDT
Date: Mon, 20 Aug 2007 17:12:01 -0700
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Joe Jin <joe.jin@oracle.com>
Subject: [PATCH] dio: zero struct dio with kzalloc instead of manually
Message-ID: <20070821001201.GA20626@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses kzalloc to zero all of struct dio rather than manually trying
to track which fields we rely on being zero.   It passed aio+dio stress testing
and some bug regression testing on ext3.

This patch was introduced by Linus in the conversation that lead up to Badari's
minimal fix to manually zero .map_bh.b_state in commit:

  6a648fa72161d1f6468dabd96c5d3c0db04f598a

It makes the code a bit smaller.  Maybe a couple fewer cachelines to
load, if we're lucky:

   text    data     bss     dec     hex filename
3285925  568506 1304616 5159047  4eb887 vmlinux
3285797  568506 1304616 5158919  4eb807 vmlinux.patched

I was unable to measure a stable difference in the number of cpu cycles spent
in blockdev_direct_IO() when pushing aio+dio 256K reads at ~340MB/s.

So the resulting intent of the patch isn't a performance gain but to
avoid exposing ourselves to the risk of finding another field like
.map_bh.b_state where we rely on zeroing but don't enforce it in the
code.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

---

 fs/direct-io.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1d0bdf0..be86702 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -958,36 +958,22 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	ssize_t ret2;
 	size_t bytes;
 
-	dio->bio = NULL;
 	dio->inode = inode;
 	dio->rw = rw;
 	dio->blkbits = blkbits;
 	dio->blkfactor = inode->i_blkbits - blkbits;
-	dio->start_zero_done = 0;
-	dio->size = 0;
 	dio->block_in_file = offset >> blkbits;
-	dio->blocks_available = 0;
-	dio->cur_page = NULL;
 
-	dio->boundary = 0;
-	dio->reap_counter = 0;
 	dio->get_block = get_block;
 	dio->end_io = end_io;
-	dio->map_bh.b_private = NULL;
-	dio->map_bh.b_state = 0;
 	dio->final_block_in_bio = -1;
 	dio->next_block_for_io = -1;
 
-	dio->page_errors = 0;
-	dio->io_error = 0;
-	dio->result = 0;
 	dio->iocb = iocb;
 	dio->i_size = i_size_read(inode);
 
 	spin_lock_init(&dio->bio_lock);
 	dio->refcount = 1;
-	dio->bio_list = NULL;
-	dio->waiter = NULL;
 
 	/*
 	 * In case of non-aligned buffers, we may need 2 more
@@ -995,8 +981,6 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	if (unlikely(dio->blkfactor))
 		dio->pages_in_io = 2;
-	else
-		dio->pages_in_io = 0;
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
@@ -1194,7 +1178,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		}
 	}
 
-	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kzalloc(sizeof(*dio), GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
