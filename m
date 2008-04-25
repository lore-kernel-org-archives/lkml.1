Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbYDYR6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbYDYR6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764768AbYDYR5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55829 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764750AbYDYR45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:56:57 -0400
Message-Id: <20080425175653.953206207@szeredi.hu>
References: <20080425175520.735386844@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 25 Apr 2008 19:55:21 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 1/5] fuse: fix max i/o size calculation
Content-Disposition: inline; filename=fuse_max_write_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix a bug that Werner Baumann reported: fuse can send a bigger write
request than the maximum specified.  This only affected direct_io
operation.

In addition set a sane minimum for the max_read and max_write
tunables, so I/O always makes some progress.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c  |    7 ++++---
 fs/fuse/inode.c |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2008-04-25 18:48:08.000000000 +0200
+++ linux/fs/fuse/file.c	2008-04-25 19:38:05.000000000 +0200
@@ -960,14 +960,15 @@ static ssize_t fuse_direct_io(struct fil
 
 	while (count) {
 		size_t nres;
-		size_t nbytes = min(count, nmax);
-		int err = fuse_get_user_pages(req, buf, nbytes, !write);
+		size_t nbytes_limit = min(count, nmax);
+		size_t nbytes;
+		int err = fuse_get_user_pages(req, buf, nbytes_limit, !write);
 		if (err) {
 			res = err;
 			break;
 		}
 		nbytes = (req->num_pages << PAGE_SHIFT) - req->page_offset;
-		nbytes = min(count, nbytes);
+		nbytes = min(nbytes_limit, nbytes);
 		if (write)
 			nres = fuse_send_write(req, file, inode, pos, nbytes,
 					       current->files);
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2008-04-25 19:07:27.000000000 +0200
+++ linux/fs/fuse/inode.c	2008-04-25 19:38:05.000000000 +0200
@@ -585,6 +585,7 @@ static void process_init_reply(struct fu
 		fc->bdi.ra_pages = min(fc->bdi.ra_pages, ra_pages);
 		fc->minor = arg->minor;
 		fc->max_write = arg->minor < 5 ? 4096 : arg->max_write;
+		fc->max_write = min_t(unsigned, 4096, fc->max_write);
 		fc->conn_init = 1;
 	}
 	fuse_put_request(fc, req);
@@ -659,7 +660,7 @@ static int fuse_fill_super(struct super_
 	fc->flags = d.flags;
 	fc->user_id = d.user_id;
 	fc->group_id = d.group_id;
-	fc->max_read = d.max_read;
+	fc->max_read = min_t(unsigned, 4096, d.max_read);
 
 	/* Used by get_root_inode() */
 	sb->s_fs_info = fc;

--
