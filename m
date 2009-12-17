Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbZLQIuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbZLQIuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZLQIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:49:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594AbZLQIt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:49:58 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Zach Brown <zach.brown@oracle.com>
Subject: [PATCH] direct_io: fix use after free in __blockdev_direct_IO
Date: Thu, 17 Dec 2009 16:49:32 +0800
Message-Id: <1261039772-18403-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dio might be freed in direct_io_worker, then check of dio->flags causes
a use after free bug, which results following kmemcheck warning:

[  247.720572] WARNING: kmemcheck: Caught 8-bit read from freed memory (ffff88022dd9b020)
[  247.720575] 0000000009000000010000000100000003000000000000000002000000000000
[  247.720593]  f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f
[  247.720611]  ^
[  247.720612]
[  247.720616] Pid: 0, comm: swapper Not tainted 2.6.32 #7 0M860N/OptiPlex 760
[  247.720618] RIP: 0010:[<ffffffff81160f76>]  [<ffffffff81160f76>] __blockdev_direct_IO+0xae6/0xc10
[  247.720626] RSP: 0018:ffff88022dd0fbe8  EFLAGS: 00010286
[  247.720628] RAX: ffff88000ae13540 RBX: ffff88022dd9b000 RCX: ffff88022dd9d400
[  247.720630] RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000286
[  247.720632] RBP: ffff88022dd0fcc8 R08: 0000000000000000 R09: ffff88022ddbb000
[  247.720634] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000200
[  247.720637] R13: 0000000000000000 R14: ffff88022dd9b108 R15: 0000000000000000
[  247.720640] FS:  0000000000000000(0000) GS:ffff88000ae00000(0000) knlGS:0000000000000000
[  247.720642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  247.720644] CR2: ffff88021cfc9218 CR3: 000000022d843000 CR4: 00000000000406f0
[  247.720647] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  247.720649] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  247.720651]  [<ffffffff8115e229>] blkdev_direct_IO+0x49/0x50
[  247.720655]  [<ffffffff810e415b>] generic_file_aio_read+0x62b/0x660
[  247.720659]  [<ffffffff8112feb2>] do_sync_read+0xd2/0x110
[  247.720663]  [<ffffffff811303b5>] vfs_read+0xb5/0x1a0
[  247.720666]  [<ffffffff8113095c>] sys_read+0x4c/0x80
[  247.720669]  [<ffffffff81009f02>] system_call_fastpath+0x16/0x1b
[  247.720674]  [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Zach Brown <zach.brown@oracle.com>
---
 fs/direct-io.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 4012885..de1ad3d 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -935,7 +935,7 @@ static ssize_t
 direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
 	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
-	struct dio *dio)
+	struct dio *dio, bool *dio_freed)
 {
 	unsigned long user_addr; 
 	unsigned long flags;
@@ -944,6 +944,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	ssize_t ret2;
 	size_t bytes;
 
+	*dio_freed = false;
 	dio->inode = inode;
 	dio->rw = rw;
 	dio->blkbits = blkbits;
@@ -1081,6 +1082,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	if (ret2 == 0) {
 		ret = dio_complete(dio, offset, ret);
 		kfree(dio);
+		*dio_freed = true;
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
 
@@ -1113,6 +1115,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	int flags)
 {
 	int seg;
+	bool dio_freed;
 	size_t size;
 	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
@@ -1197,7 +1200,11 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		(end > i_size_read(inode)));
 
 	retval = direct_io_worker(rw, iocb, inode, iov, offset,
-				nr_segs, blkbits, get_block, end_io, dio);
+				  nr_segs, blkbits, get_block, end_io,
+				  dio, &dio_freed);
+
+	if (dio_freed)
+		goto out;
 
 	/*
 	 * In case of error extending write may have instantiated a few
-- 
1.6.5.2

