Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbZENQT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbZENQT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZENQTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:19:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:65364 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZENQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xwJftZq8/TZQuOQobLZJVZcQwE8j3cO2GolptUljaYJIY5PHxvI7fJIyBdqNOjONBE
         zggfVNsGktuFs+YmH+4gnBYoXc4clW5BwU27ZTLRiB6o8U9+fLtguuEdKNqwUYU3dtiM
         WneFCGYem447GL9lWaNv1gJKXnAN8xILxkNh0=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Date: Thu, 14 May 2009 18:19:01 +0200
Message-Id: <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes iov_iter_fault_in_readable() to use check_readable_bytes()
instead of fault_in_pages_readable(). It allows iov_iter_fault_in_readable()
callers to know how much data is accessible and proceed with it. It makes
sys_write() more POSIX-friendly.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 fs/fuse/file.c |    6 ++++--
 mm/filemap.c   |   13 +++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 06f30e9..c74ef04 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -782,13 +782,15 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
 		pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 		size_t bytes = min_t(size_t, PAGE_CACHE_SIZE - offset,
 				     iov_iter_count(ii));
-
+		long accessible;
 		bytes = min_t(size_t, bytes, fc->max_write - count);
 
  again:
 		err = -EFAULT;
-		if (iov_iter_fault_in_readable(ii, bytes))
+		accessible = iov_iter_fault_in_readable(ii, bytes);
+		if (accessible < 0)
 			break;
+		bytes = accessible;
 
 		err = -ENOMEM;
 		page = grab_cache_page_write_begin(mapping, index, 0);
diff --git a/mm/filemap.c b/mm/filemap.c
index 379ff0b..ef598a1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1947,8 +1947,9 @@ EXPORT_SYMBOL(iov_iter_advance);
 
 /*
  * Fault in the first iovec of the given iov_iter, to a maximum length
- * of bytes. Returns 0 on success, or non-zero if the memory could not be
- * accessed (ie. because it is an invalid address).
+ * of bytes. Returns count of accessible bytes on success, or -EFAULT
+ * if the  memory could not be accessed (ie. because it is an invalid
+ * address).
  *
  * writev-intensive code may want this to prefault several iovecs -- that
  * would be possible (callers must not rely on the fact that _only_ the
@@ -1958,7 +1959,7 @@ int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 {
 	char __user *buf = i->iov->iov_base + i->iov_offset;
 	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
-	return fault_in_pages_readable(buf, bytes);
+	return check_readable_bytes(buf, bytes);
 }
 EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
@@ -2215,6 +2216,7 @@ static ssize_t generic_perform_write(struct file *file,
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
+		long accessible;
 		void *fsdata;
 
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
@@ -2234,10 +2236,13 @@ again:
 		 * to check that the address is actually valid, when atomic
 		 * usercopies are used, below.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+
+		accessible = iov_iter_fault_in_readable(i, bytes);
+		if (accessible < 0) {
 			status = -EFAULT;
 			break;
 		}
+		bytes = accessible;
 
 		status = a_ops->write_begin(file, mapping, pos, bytes, flags,
 						&page, &fsdata);
-- 
1.6.2.2

