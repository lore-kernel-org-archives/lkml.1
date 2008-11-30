Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYK3Ndp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYK3Ndp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYK3Ndd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:33:33 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36619 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYK3Ndc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:33:32 -0500
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Dmitri Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] fs: truncate blocks outside i_size after O_DIRECT write error.
Date: Sun, 30 Nov 2008 16:32:46 +0300
Message-Id: <1228051966-23866-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error extending write may have instantiated a few  blocks
outside i_size. We need to trim these blocks. We have to do it *regardless*
to blocksize. At least ext2, ext3 and reiserfs interpret
(i_size < biggest block) condition as error. Fsck will complain about wrong
i_size. Then fsck will fix the error by changing i_size according to the
biggest block. This is bad because this blocks contain garbage from previous
write attempt. And result in data corruption.

Changes from previous version:
 - Move error handling from generic mm code to __blockdev_direct_IO(). As soon
   as i remember this is 11'th version of the patch, and now finally it looks
   simple and clean.

####TESTCASE_BEGIN
$touch /mnt/test/BIG_FILE
## at this moment /mnt/test/BIG_FILE size and blocks equal to zero
open("/mnt/test/BIG_FILE", O_WRONLY|O_CREAT|O_DIRECT, 0666) = 3
write(3, "aaaaaaaaaaaa"..., 104857600) = -1 ENOSPC (No space left on device)
## size and block sould't be changed because write op failed.
$stat /mnt/test/BIG_FILE
File: `/mnt/test/BIG_FILE'
Size: 0 Blocks: 110896 IO Block: 1024 regular empty file
<<<<<<<<^^^^^^^^^^^^^^^^^^^^^^^^^^^^^file size is less than biggest block idx
Device: fe07h/65031d Inode: 14 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2007-01-24 20:03:38.000000000 +0300
Modify: 2007-01-24 20:03:38.000000000 +0300
Change: 2007-01-24 20:03:39.000000000 +0300

#fsck.ext3 -f /dev/VG/test
e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Inode 14, i_size is 0, should be 56556544. Fix<y>? yes
Pass 2: Checking directory structure
....
#####TESTCASE_ENDdiff --git a/fs/direct-io.c b/fs/direct-io.c
index af0558d..4e88bea 100644

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/direct-io.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index af0558d..4e88bea 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1209,6 +1209,16 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	retval = direct_io_worker(rw, iocb, inode, iov, offset,
 				nr_segs, blkbits, get_block, end_io, dio);
 
+	/*
+	 * In case of error extending write may have instantiated a few
+	 * blocks outside i_size. Trim these off again for DIO_LOCKING.
+	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this by
+	 * it's own meaner.
+	 */
+	if (unlikely(retval < 0 && (rw & WRITE) && (end > i_size_read(inode))
+			&& dio_lock_type == DIO_LOCKING))
+		vmtruncate(inode, inode->i_size);
+
 	if (rw == READ && dio_lock_type == DIO_LOCKING)
 		release_i_mutex = 0;
 
-- 
1.5.4.3

