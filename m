Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYEIMbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYEIMbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761643AbYEIMaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:30:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40022 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759792AbYEIMao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:30:44 -0400
To: akpm@linux-foundation.org
Cc: szaka@ntfs-3g.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6.26 patch] fuse: add flag to turn on big writes
Message-Id: <E1JuRk7-0001TW-D2@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 09 May 2008 14:30:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Prior to 2.6.26 fuse only supported single page write requests.  In
theory all fuse filesystem should be able support bigger than 4k
writes, as there's nothing in the API to prevent it.  Unfortunately
there's a known case in NTFS-3G where big writes cause filesystem
corruption.  There could also be other filesystems, where the lack of
testing with big write requests would result in bugs.

To prevent such problems on a kernel upgrade, disable big writes by
default, but let filesystems set a flag to turn it on.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Szabolcs Szakacsits <szaka@ntfs-3g.org>
---
 fs/fuse/file.c       |    2 ++
 fs/fuse/fuse_i.h     |    3 +++
 fs/fuse/inode.c      |    5 ++++-
 include/linux/fuse.h |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2008-05-09 14:04:17.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2008-05-09 14:04:45.000000000 +0200
@@ -804,6 +804,8 @@ static ssize_t fuse_fill_write_pages(str
 		if (offset == PAGE_CACHE_SIZE)
 			offset = 0;
 
+		if (!fc->big_writes)
+			break;
 	} while (iov_iter_count(ii) && count < fc->max_write &&
 		 req->num_pages < FUSE_MAX_PAGES_PER_REQ && offset == 0);
 
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2008-05-09 14:04:17.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2008-05-09 14:04:45.000000000 +0200
@@ -576,6 +576,8 @@ static void process_init_reply(struct fu
 				fc->no_lock = 1;
 			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
 				fc->atomic_o_trunc = 1;
+			if (arg->flags & FUSE_BIG_WRITES)
+				fc->big_writes = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -599,7 +601,8 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
+		FUSE_BIG_WRITES;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
Index: linux-2.6/include/linux/fuse.h
===================================================================
--- linux-2.6.orig/include/linux/fuse.h	2008-05-09 14:04:17.000000000 +0200
+++ linux-2.6/include/linux/fuse.h	2008-05-09 14:04:45.000000000 +0200
@@ -109,6 +109,7 @@ struct fuse_file_lock {
 #define FUSE_POSIX_LOCKS	(1 << 1)
 #define FUSE_FILE_OPS		(1 << 2)
 #define FUSE_ATOMIC_O_TRUNC	(1 << 3)
+#define FUSE_BIG_WRITES		(1 << 5)
 
 /**
  * Release flags
Index: linux-2.6/fs/fuse/fuse_i.h
===================================================================
--- linux-2.6.orig/fs/fuse/fuse_i.h	2008-05-09 14:04:17.000000000 +0200
+++ linux-2.6/fs/fuse/fuse_i.h	2008-05-09 14:04:45.000000000 +0200
@@ -404,6 +404,9 @@ struct fuse_conn {
 	/** Is bmap not implemented by fs? */
 	unsigned no_bmap : 1;
 
+	/** Do multi-page cached writes */
+	unsigned big_writes : 1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
