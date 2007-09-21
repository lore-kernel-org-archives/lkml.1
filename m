Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbXIUOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbXIUOwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbXIUOt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:49:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760727AbXIUOtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/22] AFS: Implement shared-writable mmap
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:48:46 +0100
Message-ID: <20070921144846.8323.83846.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
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

 fs/afs/file.c     |   20 +++++++++++++++++++-
 fs/afs/internal.h |    1 +
 fs/afs/write.c    |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 525f7c5..1323df4 100644
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
 	.splice_read	= generic_file_splice_read,
 	.fsync		= afs_fsync,
 	.lock		= afs_lock,
@@ -56,6 +57,11 @@ const struct address_space_operations afs_fs_aops = {
 	.writepages	= afs_writepages,
 };
 
+static struct vm_operations_struct afs_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= afs_page_mkwrite,
+};
+
 /*
  * open an AFS file or directory and attach a key to it
  */
@@ -295,3 +301,15 @@ static int afs_releasepage(struct page *page, gfp_t gfp_flags)
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
index e1bcce0..12afccc 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -743,6 +743,7 @@ extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
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

