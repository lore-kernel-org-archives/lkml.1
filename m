Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYCQTVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYCQTVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYCQTUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:20:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34055 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYCQTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:19:51 -0400
Message-Id: <20080317191947.989369784@szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 20:19:14 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [patch 6/8] fuse: clean up setting i_size in write
Content-Disposition: inline; filename=fuse_write_update_size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Extract common code for setting i_size in write functions into a
common helper.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2008-03-17 18:26:04.000000000 +0100
+++ linux/fs/fuse/file.c	2008-03-17 18:26:28.000000000 +0100
@@ -610,13 +610,24 @@ static int fuse_write_begin(struct file 
 	return 0;
 }
 
+static void fuse_write_update_size(struct inode *inode, loff_t pos)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	spin_lock(&fc->lock);
+	fi->attr_version = ++fc->attr_version;
+	if (pos > inode->i_size)
+		i_size_write(inode, pos);
+	spin_unlock(&fc->lock);
+}
+
 static int fuse_buffered_write(struct file *file, struct inode *inode,
 			       loff_t pos, unsigned count, struct page *page)
 {
 	int err;
 	size_t nres;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 	struct fuse_req *req;
 
@@ -643,12 +654,7 @@ static int fuse_buffered_write(struct fi
 		err = -EIO;
 	if (!err) {
 		pos += nres;
-		spin_lock(&fc->lock);
-		fi->attr_version = ++fc->attr_version;
-		if (pos > inode->i_size)
-			i_size_write(inode, pos);
-		spin_unlock(&fc->lock);
-
+		fuse_write_update_size(inode, pos);
 		if (count == PAGE_CACHE_SIZE)
 			SetPageUptodate(page);
 	}
@@ -766,12 +772,8 @@ static ssize_t fuse_direct_io(struct fil
 	}
 	fuse_put_request(fc, req);
 	if (res > 0) {
-		if (write) {
-			spin_lock(&fc->lock);
-			if (pos > inode->i_size)
-				i_size_write(inode, pos);
-			spin_unlock(&fc->lock);
-		}
+		if (write)
+			fuse_write_update_size(inode, pos);
 		*ppos = pos;
 	}
 	fuse_invalidate_attr(inode);

--
