Return-Path: <linux-kernel-owner+w=401wt.eu-S965981AbXEWTQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965981AbXEWTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764041AbXEWTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:15:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763667AbXEWTPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:15:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] AFS: Implement shared-writable mmap
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 23 May 2007 20:15:34 +0100
Message-ID: <20070523191534.24135.72841.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
References: <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement shared-writable mmap for AFS.

The key with which to access the file is obtained from the VMA at the point
where the PTE is made writable by the page_mkwrite() VMA op and cached in the
affected page.

If there's an outstanding write on the page made with a different key, then
page_mkwrite() will flush it before attaching a record of the new key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/file.c     |   21 ++++++++++++++++++++-
 fs/afs/internal.h |    1 +
 fs/afs/write.c    |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 9c0e721..1547500 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -22,6 +22,7 @@ static int afs_readpage(struct file *file, struct page *page);
 static void afs_invalidatepage(struct page *page, unsigned long offset);
 static int afs_releasepage(struct page *page, gfp_t gfp_flags);
 static int afs_launder_page(struct page *page);
+static int afs_mmap(struct file *file, struct vm_area_struct *vma);
 
 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
@@ -31,7 +32,7 @@ const struct file_operations afs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= afs_file_write,
-	.mmap		= generic_file_readonly_mmap,
+	.mmap		= afs_mmap,
 	.sendfile	= generic_file_sendfile,
 	.fsync		= afs_fsync,
 };
@@ -54,6 +55,12 @@ const struct address_space_operations afs_fs_aops = {
 	.writepages	= afs_writepages,
 };
 
+static struct vm_operations_struct afs_file_vm_ops = {
+	.nopage		= filemap_nopage,
+	.populate	= filemap_populate,
+	.page_mkwrite	= afs_page_mkwrite,
+};
+
 /*
  * open an AFS file or directory and attach a key to it
  */
@@ -293,3 +300,15 @@ static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 	_leave(" = 0");
 	return 0;
 }
+
+/*
+ * memory map part of an AFS file
+ */
+static int afs_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	_enter("");
+
+	file_accessed(file);
+	vma->vm_ops = &afs_file_vm_ops;
+	return 0;
+}
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index ddb18d9..bc39eba 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -711,6 +711,7 @@ extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
 			      unsigned long, loff_t);
 extern int afs_writeback_all(struct afs_vnode *);
 extern int afs_fsync(struct file *, struct dentry *, int);
+extern int afs_page_mkwrite(struct vm_area_struct *, struct page *);
 
 
 /*****************************************************************************/
diff --git a/fs/afs/write.c b/fs/afs/write.c
index ac621e8..dd471f0 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -155,6 +155,8 @@ static int afs_prepare_page(struct afs_vnode *vnode, struct page *page,
  * prepare to perform part of a write to a page
  * - the caller holds the page locked, preventing it from being written out or
  *   modified by anyone else
+ * - may be called from afs_page_mkwrite() to set up a page for modification
+ *   through shared-writable mmap
  */
 int afs_prepare_write(struct file *file, struct page *page,
 		      unsigned offset, unsigned to)
@@ -833,3 +835,36 @@ int afs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	_leave(" = %d", ret);
 	return ret;
 }
+
+/*
+ * notification that a previously read-only page is about to become writable
+ * - if it returns an error, the caller will deliver a bus error signal
+ *
+ * we use this to make a record of the key with which the writeback should be
+ * performed and to flush any outstanding writes made with a different key
+ *
+ * the key to be used is attached to the struct file pinned by the VMA
+ */
+int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct afs_vnode *vnode = AFS_FS_I(vma->vm_file->f_mapping->host);
+	struct key *key = vma->vm_file->private_data;
+	int ret;
+
+	_enter("{{%x:%u},%x},{%lx}",
+	       vnode->fid.vid, vnode->fid.vnode, key_serial(key), page->index);
+
+	do {
+		lock_page(page);
+		if (page->mapping == vma->vm_file->f_mapping)
+			ret = afs_prepare_write(vma->vm_file, page, 0,
+						PAGE_SIZE);
+		else
+			ret = 0; /* seems there was interference - let the
+				  * caller deal with it */
+		unlock_page(page);
+	} while (ret == AOP_TRUNCATED_PAGE);
+
+	_leave(" = %d", ret);
+	return ret;
+}

