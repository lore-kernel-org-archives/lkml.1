Return-Path: <linux-kernel-owner+w=401wt.eu-S934243AbZKXV03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbZKXV03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934213AbZKXV02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:26:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934146AbZKXV00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:26:26 -0500
Date: Tue, 24 Nov 2009 16:26:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>, Moyer Jeff Moyer <jmoyer@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH] Fix regression in direct writes performance due to
	WRITE_ODIRECT flag removal
Message-ID: <20091124212628.GC2803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

There seems to be a regression in direct write path due to following
commit in for-2.6.33 branch of block tree.

commit 1af60fbd759d31f565552fea315c2033947cfbe6
Author: Jeff Moyer <jmoyer@redhat.com>
Date:   Fri Oct 2 18:56:53 2009 -0400

    block: get rid of the WRITE_ODIRECT flag


Marking direct writes as WRITE_SYNC_PLUG instead of WRITE_ODIRECT, sets
the NOIDLE flag in bio and hence in request. This tells CFQ to not expect
more request from the queue and not idle on it (despite the fact that
queue's think time is less and it is not seeky).

So direct writers lose big time when competing with sequential readers.

Using fio, I have run one direct writer and two sequential readers and
following are the results with 2.6.32-rc7 kernel and with for-2.6.33
branch.

Test
====
1 direct writer and 2 sequential reader running simultaneously.

[global]
directory=/mnt/sdc/fio/
runtime=10

[seqwrite]
rw=write
size=4G
direct=1

[seqread]
rw=read
size=2G
numjobs=2

2.6.32-rc7
==========
direct writes: aggrb=2,968KB/s
readers	     : aggrb=101MB/s

for-2.6.33 branch
=================
direct write: aggrb=19KB/s
readers	      aggrb=137MB/s

This patch brings back the WRITE_ODIRECT flag, with the difference that we
don't set the BIO_RW_UNPLUG flag so that device is not unplugged after 
submission of request and an explicit unplug from submitter is required.

That way we fix the jeff's issue of not enough merging taking place in aio
path as well as make sure direct writes get their fair share.

After the fix
=============
for-2.6.33 + fix
----------------
direct writes: aggrb=2,728KB/s
reads: aggrb=103MB/s

Thanks
Vivek

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/direct-io.c     |    2 +-
 include/linux/fs.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux8/include/linux/fs.h
===================================================================
--- linux8.orig/include/linux/fs.h	2009-11-24 14:44:36.000000000 -0500
+++ linux8/include/linux/fs.h	2009-11-24 15:10:04.000000000 -0500
@@ -129,6 +129,7 @@ struct inodes_stat_t {
  * WRITE_SYNC		Like WRITE_SYNC_PLUG, but also unplugs the device
  *			immediately after submission. The write equivalent
  *			of READ_SYNC.
+ * WRITE_ODIRECT_PLUG	Special case write for O_DIRECT only.
  * SWRITE_SYNC
  * SWRITE_SYNC_PLUG	Like WRITE_SYNC/WRITE_SYNC_PLUG, but locks the buffer.
  *			See SWRITE.
@@ -150,6 +151,7 @@ struct inodes_stat_t {
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
 #define WRITE_SYNC	(WRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
+#define WRITE_ODIRECT_PLUG	(WRITE | (1 << BIO_RW_SYNCIO))
 #define SWRITE_SYNC_PLUG	\
 			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
 #define SWRITE_SYNC	(SWRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
Index: linux8/fs/direct-io.c
===================================================================
--- linux8.orig/fs/direct-io.c	2009-11-24 14:44:36.000000000 -0500
+++ linux8/fs/direct-io.c	2009-11-24 15:10:04.000000000 -0500
@@ -1124,7 +1124,7 @@ __blockdev_direct_IO(int rw, struct kioc
 	int acquire_i_mutex = 0;
 
 	if (rw & WRITE)
-		rw = WRITE_SYNC_PLUG;
+		rw = WRITE_ODIRECT_PLUG;
 
 	if (bdev)
 		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
