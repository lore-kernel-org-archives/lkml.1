Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZJBW46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZJBW46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZJBW45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZJBW45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:56:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: zach.brown@oracle.com
Cc: linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch v4 1/2] block: get rid of the WRITE_ODIRECT flag
References: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 02 Oct 2009 18:56:53 -0400
In-Reply-To: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 02 Oct 2009 18:54:20 -0400")
Message-ID: <x49vdix76bu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The WRITE_ODIRECT flag is only used in one place, and that code path
happens to also call blk_run_address_space.  The introduction of this
flag, then, could result in the device being unplugged twice for every
I/O.

Further, with the batching changes in the next patch, we don't want an
O_DIRECT write to imply a queue unplug.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8b10b87..c86d35f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1124,7 +1124,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	int acquire_i_mutex = 0;
 
 	if (rw & WRITE)
-		rw = WRITE_ODIRECT;
+		rw = WRITE_SYNC_PLUG;
 
 	if (bdev)
 		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2adaa25..2aac751 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -129,7 +129,6 @@ struct inodes_stat_t {
  * WRITE_SYNC		Like WRITE_SYNC_PLUG, but also unplugs the device
  *			immediately after submission. The write equivalent
  *			of READ_SYNC.
- * WRITE_ODIRECT	Special case write for O_DIRECT only.
  * SWRITE_SYNC
  * SWRITE_SYNC_PLUG	Like WRITE_SYNC/WRITE_SYNC_PLUG, but locks the buffer.
  *			See SWRITE.
@@ -151,7 +150,6 @@ struct inodes_stat_t {
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
 #define WRITE_SYNC	(WRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
-#define WRITE_ODIRECT	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define SWRITE_SYNC_PLUG	\
 			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
 #define SWRITE_SYNC	(SWRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
