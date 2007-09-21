Return-Path: <linux-kernel-owner+w=401wt.eu-S1764001AbXIUVvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764001AbXIUVvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761028AbXIUVvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:51:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35765 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760603AbXIUVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:51:39 -0400
Date: Fri, 21 Sep 2007 16:51:25 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [Ecryptfs-devel] [PATCH 3/11] eCryptfs: read_write.c routines
Message-ID: <20070921215125.GB11833@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com> <20070917214632.GK13679@halcrow.austin.ibm.com> <20070919223850.3e1132ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919223850.3e1132ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:38:50PM -0700, Andrew Morton wrote:
> > +	virt = kmap(page_for_lower);
> > +	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
> > +	kunmap(page_for_lower);
> > +	return rc;
> > +}
> 
> argh, kmap.  http://lkml.org/lkml/2007/9/15/55

Here is a patch that moves to kmap_atomic(), adding an intermediate
copy. Although I would really like to find a way to avoid having to do
this extra copy.

---

Replace kmap() with kmap_atomic() for read_write.c routines

kmap() can lead to deadlock when multiple tasks attempt to take more
than one simultaneously:

http://lkml.org/lkml/2007/9/15/55

In order to avoid this possibility, eCryptfs must allocate an
intermediate block of memory to use with vfs_read() and vfs_write(),
copying the data through this memory region, since kmap_atomic()
cannot be held during calls which may block.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index bb92b74..ce7a5d4 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -648,6 +648,6 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 				     struct inode *ecryptfs_inode);
 int ecryptfs_read(char *data, loff_t offset, size_t size,
 		  struct file *ecryptfs_file);
-struct page *ecryptfs_get1page(struct file *file, loff_t index);
+struct page *ecryptfs_get_locked_page(struct file *file, loff_t index);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index c6a8a33..6abf805 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -37,23 +37,30 @@
 struct kmem_cache *ecryptfs_lower_page_cache;
 
 /**
- * ecryptfs_get1page
+ * ecryptfs_get_locked_page
  *
  * Get one page from cache or lower f/s, return error otherwise.
  *
- * Returns unlocked and up-to-date page (if ok), with increased
+ * Returns a locked and up-to-date page (if ok), with increased
  * refcnt.
  */
-struct page *ecryptfs_get1page(struct file *file, loff_t index)
+struct page *ecryptfs_get_locked_page(struct file *file, loff_t index)
 {
 	struct dentry *dentry;
 	struct inode *inode;
 	struct address_space *mapping;
+	struct page *page;
 
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
 	mapping = inode->i_mapping;
-	return read_mapping_page(mapping, index, (void *)file);
+	page = read_mapping_page(mapping, index, (void *)file);
+	if (!IS_ERR(page))
+		lock_page(page);
+	else
+		printk(KERN_ERR "%s: Error from read_mapping_page()\n",
+		       __FUNCTION__);
+	return page;
 }
 
 /**
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index ccd2599..6732a4c 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -83,14 +83,24 @@ int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
 				      struct page *page_for_lower,
 				      size_t offset_in_page, size_t size)
 {
-	char *virt;
+	char *page_for_lower_virt;
+	char *tmp_virt;
 	loff_t offset;
 	int rc;
 
-	offset = (page_for_lower->index << PAGE_CACHE_SHIFT) + offset_in_page;
-	virt = kmap(page_for_lower);
-	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
-	kunmap(page_for_lower);
+	tmp_virt = kmalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
+	if (!tmp_virt) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	offset = ((((loff_t)page_for_lower->index) << PAGE_CACHE_SHIFT)
+		  + offset_in_page);
+	page_for_lower_virt = kmap_atomic(page_for_lower, KM_USER0);
+	memcpy(tmp_virt, page_for_lower_virt, PAGE_CACHE_SIZE);
+	kunmap_atomic(page_for_lower_virt, KM_USER0);
+	rc = ecryptfs_write_lower(ecryptfs_inode, tmp_virt, offset, size);
+	kfree(tmp_virt);
+out:
 	return rc;
 }
 
@@ -140,8 +150,8 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 			if (num_bytes > total_remaining_zeros)
 				num_bytes = total_remaining_zeros;
 		}
-		ecryptfs_page = ecryptfs_get1page(ecryptfs_file,
-						  ecryptfs_page_idx);
+		ecryptfs_page = ecryptfs_get_locked_page(ecryptfs_file,
+							 ecryptfs_page_idx);
 		if (IS_ERR(ecryptfs_page)) {
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
@@ -159,6 +169,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 				printk(KERN_ERR "%s: Error decrypting "
 				       "page; rc = [%d]\n",
 				       __FUNCTION__, rc);
+				unlock_page(ecryptfs_page);
 				page_cache_release(ecryptfs_page);
 				goto out;
 			}
@@ -182,9 +193,11 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			unlock_page(ecryptfs_page);
 			page_cache_release(ecryptfs_page);
 			goto out;
 		}
+		unlock_page(ecryptfs_page);
 		page_cache_release(ecryptfs_page);
 		pos += num_bytes;
 	}
@@ -245,10 +258,6 @@ int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 
 		data_page = virt_to_page(data + i);
 		flush_dcache_page(data_page);
-		if (rc)
-			ClearPageUptodate(data_page);
-		else
-			SetPageUptodate(data_page);
 	}
 	return rc;
 }
@@ -273,14 +282,34 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 				     size_t offset_in_page, size_t size,
 				     struct inode *ecryptfs_inode)
 {
-	char *virt;
+	char *page_for_ecryptfs_virt;
+	char *tmp_virt;
 	loff_t offset;
 	int rc;
 
-	offset = ((page_index << PAGE_CACHE_SHIFT) + offset_in_page);
-	virt = kmap(page_for_ecryptfs);
-	rc = ecryptfs_read_lower(virt, offset, size, ecryptfs_inode);
-	kunmap(page_for_ecryptfs);
+	tmp_virt = kmalloc(PAGE_CACHE_SIZE, GFP_KERNEL);
+	if (!tmp_virt) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	offset = ((((loff_t)page_index) << PAGE_CACHE_SHIFT) + offset_in_page);
+	rc = ecryptfs_read_lower(tmp_virt, offset, size, ecryptfs_inode);
+	if (rc) {
+		printk(KERN_ERR "%s: Error reading lower; rc = [%d]\n",
+		       __FUNCTION__, rc);
+		goto out_free;
+	}
+	page_for_ecryptfs_virt = kmap_atomic(page_for_ecryptfs, KM_USER0);
+	memcpy(page_for_ecryptfs_virt, tmp_virt, PAGE_CACHE_SIZE);
+	kunmap_atomic(page_for_ecryptfs_virt, KM_USER0);
+	flush_dcache_page(page_for_ecryptfs);
+out_free:
+	kfree(tmp_virt);
+out:
+	if (rc)
+		ClearPageUptodate(page_for_ecryptfs);
+	else
+		SetPageUptodate(page_for_ecryptfs);
 	return rc;
 }
 
@@ -328,8 +357,8 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
-		ecryptfs_page = ecryptfs_get1page(ecryptfs_file,
-						  ecryptfs_page_idx);
+		ecryptfs_page = ecryptfs_get_locked_page(ecryptfs_file,
+							 ecryptfs_page_idx);
 		if (IS_ERR(ecryptfs_page)) {
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
@@ -342,6 +371,7 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 		if (rc) {
 			printk(KERN_ERR "%s: Error decrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			unlock_page(ecryptfs_page);
 			page_cache_release(ecryptfs_page);
 			goto out;
 		}
@@ -350,6 +380,7 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),
 		       num_bytes);
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
+		unlock_page(ecryptfs_page);
 		page_cache_release(ecryptfs_page);
 		pos += num_bytes;
 		data_offset += num_bytes;
