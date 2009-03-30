Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbZC3UC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbZC3UC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbZC3UCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:02:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38061 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbZC3UCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:02:17 -0400
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
In-reply-to: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 30 Mar 2009 22:00:37 +0200)
Subject: [patch 1/3] fuse: allow kernel to access "direct_io" files
References: <E1LoNev-0007kP-U7@pomaz-ex.szeredi.hu>
Message-Id: <E1LoNgX-0007l7-PE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Mar 2009 22:02:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow the kernel read and write on "direct_io" files.  This is
necessary for nfs export and execute support.

The implementation is simple: if an access from the kernel is
detected, don't perform get_user_pages(), just use the kernel address
provided by the requester to copy from/to the userspace filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c  |    1 +
 fs/fuse/file.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 13 deletions(-)

Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2009-03-25 10:30:52.000000000 +0100
+++ linux-2.6/fs/fuse/file.c	2009-03-25 10:35:22.000000000 +0100
@@ -386,7 +386,6 @@ void fuse_read_fill(struct fuse_req *req
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(struct fuse_read_in);
 	req->in.args[0].value = inarg;
-	req->out.argpages = 1;
 	req->out.argvar = 1;
 	req->out.numargs = 1;
 	req->out.args[0].size = count;
@@ -453,6 +452,7 @@ static int fuse_readpage(struct file *fi
 	attr_ver = fuse_get_attr_version(fc);
 
 	req->out.page_zeroing = 1;
+	req->out.argpages = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
 	num_read = fuse_send_read(req, file, inode, pos, count, NULL);
@@ -510,6 +510,8 @@ static void fuse_send_readpages(struct f
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	loff_t pos = page_offset(req->pages[0]);
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
+
+	req->out.argpages = 1;
 	req->out.page_zeroing = 1;
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	req->misc.read.attr_ver = fuse_get_attr_version(fc);
@@ -621,7 +623,6 @@ static void fuse_write_fill(struct fuse_
 	inarg->flags = file ? file->f_flags : 0;
 	req->in.h.opcode = FUSE_WRITE;
 	req->in.h.nodeid = get_node_id(inode);
-	req->in.argpages = 1;
 	req->in.numargs = 2;
 	if (fc->minor < 9)
 		req->in.args[0].size = FUSE_COMPAT_WRITE_IN_SIZE;
@@ -695,6 +696,7 @@ static int fuse_buffered_write(struct fi
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	req->in.argpages = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
 	req->page_offset = offset;
@@ -771,6 +773,7 @@ static ssize_t fuse_fill_write_pages(str
 	size_t count = 0;
 	int err;
 
+	req->in.argpages = 1;
 	req->page_offset = offset;
 
 	do {
@@ -935,21 +938,28 @@ static void fuse_release_user_pages(stru
 }
 
 static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
-			       unsigned nbytes, int write)
+			       unsigned *nbytesp, int write)
 {
+	unsigned nbytes = *nbytesp;
 	unsigned long user_addr = (unsigned long) buf;
 	unsigned offset = user_addr & ~PAGE_MASK;
 	int npages;
 
-	/* This doesn't work with nfsd */
-	if (!current->mm)
-		return -EPERM;
+	/* Special case for kernel I/O: can copy directly into the buffer */
+	if (segment_eq(get_fs(), KERNEL_DS)) {
+		if (write)
+			req->in.args[1].value = (void *) user_addr;
+		else
+			req->out.args[0].value = (void *) user_addr;
+
+		return 0;
+	}
 
 	nbytes = min(nbytes, (unsigned) FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT);
 	npages = (nbytes + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	npages = clamp(npages, 1, FUSE_MAX_PAGES_PER_REQ);
 	down_read(&current->mm->mmap_sem);
-	npages = get_user_pages(current, current->mm, user_addr, npages, write,
+	npages = get_user_pages(current, current->mm, user_addr, npages, !write,
 				0, req->pages, NULL);
 	up_read(&current->mm->mmap_sem);
 	if (npages < 0)
@@ -957,6 +967,15 @@ static int fuse_get_user_pages(struct fu
 
 	req->num_pages = npages;
 	req->page_offset = offset;
+
+	if (write)
+		req->in.argpages = 1;
+	else
+		req->out.argpages = 1;
+
+	nbytes = (req->num_pages << PAGE_SHIFT) - req->page_offset;
+	*nbytesp = min(*nbytesp, nbytes);
+
 	return 0;
 }
 
@@ -979,15 +998,13 @@ static ssize_t fuse_direct_io(struct fil
 
 	while (count) {
 		size_t nres;
-		size_t nbytes_limit = min(count, nmax);
-		size_t nbytes;
-		int err = fuse_get_user_pages(req, buf, nbytes_limit, !write);
+		size_t nbytes = min(count, nmax);
+		int err = fuse_get_user_pages(req, buf, &nbytes, write);
 		if (err) {
 			res = err;
 			break;
 		}
-		nbytes = (req->num_pages << PAGE_SHIFT) - req->page_offset;
-		nbytes = min(nbytes_limit, nbytes);
+
 		if (write)
 			nres = fuse_send_write(req, file, inode, pos, nbytes,
 					       current->files);
@@ -1163,6 +1180,7 @@ static int fuse_writepage_locked(struct
 	fuse_write_fill(req, NULL, ff, inode, page_offset(page), 0, 1);
 
 	copy_highpage(tmp_page, page);
+	req->in.argpages = 1;
 	req->num_pages = 1;
 	req->pages[0] = tmp_page;
 	req->page_offset = 0;
Index: linux-2.6/fs/fuse/dir.c
===================================================================
--- linux-2.6.orig/fs/fuse/dir.c	2009-03-25 10:31:06.000000000 +0100
+++ linux-2.6/fs/fuse/dir.c	2009-03-25 10:31:10.000000000 +0100
@@ -1032,6 +1032,7 @@ static int fuse_readdir(struct file *fil
 		fuse_put_request(fc, req);
 		return -ENOMEM;
 	}
+	req->out.argpages = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
 	fuse_read_fill(req, file, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
