Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXGaXA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXGaXA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbXGaXAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:00:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756411AbXGaXAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:00:40 -0400
Date: Tue, 31 Jul 2007 15:59:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Badari Pulavarty <pbadari@us.ibm.com>, Joe Jin <joe.jin@oracle.com>,
       Zach Brown <zach.brown@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>, jens.axboe@oracle.com,
       lkml <linux-kernel@vger.kernel.org>, wen.gang.wang@oracle.com
Subject: Re: [PATCH] add check do_direct_IO() return val
In-Reply-To: <20070731153410.fcbf9a1b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707311555410.4161@woody.linux-foundation.org>
References: <20070727071547.GA25084@joejin-pc.cn.oracle.com> <46A9E6F9.20603@oracle.com>
 <20070728034719.GA24448@joejin-pc.cn.oracle.com>
 <20070730135316.2ce21b28.akpm@linux-foundation.org>
 <1185830683.24525.2.camel@dyn9047017100.beaverton.ibm.com>
 <6C87D322-FB28-4DA8-A130-327FE35C2DCC@oracle.com>
 <1185832738.24525.4.camel@dyn9047017100.beaverton.ibm.com>
 <05506FB8-1164-4E62-8C02-3AC3681E7D89@oracle.com> <20070731005348.GA8308@joejin-pc.cn.oracle.com>
 <46AEB055.9050607@us.ibm.com> <20070731043554.GA3393@joejin-pc.cn.oracle.com>
 <1185920712.31134.21.camel@dyn9047017100.beaverton.ibm.com>
 <20070731153410.fcbf9a1b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Andrew Morton wrote:
> 
> We zero out so many fields in there now that a kzalloc() might yield
> a net gain.  0.000001% in an unnamed benchmark!

Indeed. That's *especially* true since right now it passes a mostly 
totally uninitialized structure pointer down to direct_io_worker(), but it 
has actually initialized a _few_ fields. Ie the "die" pointer is almost 
totally filled with random crap, except for two members: dio->lock_type 
and dio->is_async have been initialized the rest is random crud.

That kind of mixing of totally-but-not-entirely-uninitialized pointer 
passing is just a recipe for disaster.

Does a patch like this work? I don't have any test-cases, but it would be 
good to have something like this tested and passed back with proper 
explanations and sign-offs.

		Linus

---
 fs/direct-io.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 52bb263..901dc55 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -958,35 +958,22 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
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
@@ -994,8 +981,6 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	if (unlikely(dio->blkfactor))
 		dio->pages_in_io = 2;
-	else
-		dio->pages_in_io = 0;
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
@@ -1183,7 +1168,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		}
 	}
 
-	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kzalloc(sizeof(*dio), GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;

