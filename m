Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbXIYP5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbXIYP5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbXIYP53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:57:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54838 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbXIYP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:57:27 -0400
Date: Tue, 25 Sep 2007 10:56:26 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [Ecryptfs-devel] [PATCH 3/11] eCryptfs: read_write.c routines
Message-ID: <20070925155626.GG11833@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com> <20070917214632.GK13679@halcrow.austin.ibm.com> <20070919223850.3e1132ac.akpm@linux-foundation.org> <20070921215125.GB11833@halcrow.austin.ibm.com> <20070921150540.fa285609.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921150540.fa285609.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 03:05:40PM -0700, Andrew Morton wrote:
> btw, I'm not really a great admirer of the whole patchset: it does
> some pretty nasty-looking things: allocating dynamic memory,
> grabbing the underlying pageframes with virt_to_page(), passing them
> back into kernel APIs which are supposed to be called from
> userspace, etc.  It's all rather ugly and abusive-looking.

Functions higher up the execution stack should be the ones mucking
with the Uptodate flag. The patch below addresses some of these
issues. I also whipped up a post-patch partial call graph to help
illustrate what is going on with the page mapping and Uptodate status
in the various eCryptfs read/write paths:

http://ecryptfs.sourceforge.net/ecryptfs-pageuptodate-call-graph.png

---

The functions that eventually call down to ecryptfs_read_lower(),
ecryptfs_decrypt_page(), and ecryptfs_copy_up_encrypted_with_header()
should have the responsibility of managing the page Uptodate
status. This patch gets rid of some of the ugliness that resulted from
trying to push some of the page flag setting too far down the stack.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index b3795f6..bbec711 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -605,14 +605,14 @@ int ecryptfs_decrypt_page(struct page *page)
 			printk(KERN_ERR "%s: Error attempting to copy "
 			       "page at index [%ld]\n", __FUNCTION__,
 			       page->index);
-		goto out_clear_uptodate;
+		goto out;
 	}
 	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
 	if (!enc_extent_virt) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
 				"encrypted extent\n");
-		goto out_clear_uptodate;
+		goto out;
 	}
 	enc_extent_page = virt_to_page(enc_extent_virt);
 	for (extent_offset = 0;
@@ -631,21 +631,17 @@ int ecryptfs_decrypt_page(struct page *page)
 			ecryptfs_printk(KERN_ERR, "Error attempting "
 					"to read lower page; rc = [%d]"
 					"\n", rc);
-			goto out_clear_uptodate;
+			goto out;
 		}
 		rc = ecryptfs_decrypt_extent(page, crypt_stat, enc_extent_page,
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
 			       "rc = [%d]\n", __FUNCTION__, rc);
-			goto out_clear_uptodate;
+			goto out;
 		}
 		extent_offset++;
 	}
-	SetPageUptodate(page);
-	goto out;
-out_clear_uptodate:
-	ClearPageUptodate(page);
 out:
 	kfree(enc_extent_virt);
 	return rc;
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
index 4eb09c1..16a7a55 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -37,23 +37,27 @@
 struct kmem_cache *ecryptfs_lower_page_cache;
 
 /**
- * ecryptfs_get1page
+ * ecryptfs_get_locked_page
  *
  * Get one page from cache or lower f/s, return error otherwise.
  *
- * Returns unlocked and up-to-date page (if ok), with increased
+ * Returns locked and up-to-date page (if ok), with increased
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
+	return page;
 }
 
 /**
@@ -146,12 +150,10 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 			kunmap_atomic(page_virt, KM_USER0);
 			flush_dcache_page(page);
 			if (rc) {
-				ClearPageUptodate(page);
 				printk(KERN_ERR "%s: Error reading xattr "
 				       "region; rc = [%d]\n", __FUNCTION__, rc);
 				goto out;
 			}
-			SetPageUptodate(page);
 		} else {
 			/* This is an encrypted data extent */
 			loff_t lower_offset =
@@ -232,6 +234,10 @@ static int ecryptfs_readpage(struct file *file, struct page *page)
 		}
 	}
 out:
+	if (rc)
+		ClearPageUptodate(page);
+	else
+		SetPageUptodate(page);
 	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
 			page->index);
 	unlock_page(page);
@@ -265,10 +271,18 @@ static int ecryptfs_prepare_write(struct file *file, struct page *page,
 	if (from == 0 && to == PAGE_CACHE_SIZE)
 		goto out;	/* If we are writing a full page, it will be
 				   up to date. */
-	if (!PageUptodate(page))
+	if (!PageUptodate(page)) {
 		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
 						      PAGE_CACHE_SIZE,
 						      page->mapping->host);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attemping to read lower "
+			       "page segment; rc = [%d]\n", __FUNCTION__, rc);
+			ClearPageUptodate(page);
+			goto out;
+		} else
+			SetPageUptodate(page);
+	}
 	if (page->index != 0) {
 		loff_t end_of_prev_pg_pos =
 			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 272eaeb..2150edf 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -142,8 +142,8 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
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
@@ -161,6 +161,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 				printk(KERN_ERR "%s: Error decrypting "
 				       "page; rc = [%d]\n",
 				       __FUNCTION__, rc);
+				ClearPageUptodate(ecryptfs_page);
 				page_cache_release(ecryptfs_page);
 				goto out;
 			}
@@ -180,14 +181,15 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		}
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
 		flush_dcache_page(ecryptfs_page);
+		SetPageUptodate(ecryptfs_page);
+		unlock_page(ecryptfs_page);
 		rc = ecryptfs_encrypt_page(ecryptfs_page);
+		page_cache_release(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
-			page_cache_release(ecryptfs_page);
 			goto out;
 		}
-		page_cache_release(ecryptfs_page);
 		pos += num_bytes;
 	}
 	if ((offset + size) > ecryptfs_file_size) {
@@ -225,7 +227,6 @@ int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 		ecryptfs_inode_to_private(ecryptfs_inode);
 	ssize_t octets_read;
 	mm_segment_t fs_save;
-	size_t i;
 	int rc = 0;
 
 	mutex_lock(&inode_info->lower_file_mutex);
@@ -242,16 +243,6 @@ int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 		rc = -EINVAL;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
-	for (i = 0; i < size; i += PAGE_CACHE_SIZE) {
-		struct page *data_page;
-
-		data_page = virt_to_page(data + i);
-		flush_dcache_page(data_page);
-		if (rc)
-			ClearPageUptodate(data_page);
-		else
-			SetPageUptodate(data_page);
-	}
 	return rc;
 }
 
@@ -283,6 +274,7 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 	virt = kmap(page_for_ecryptfs);
 	rc = ecryptfs_read_lower(virt, offset, size, ecryptfs_inode);
 	kunmap(page_for_ecryptfs);
+	flush_dcache_page(page_for_ecryptfs);
 	return rc;
 }
 
@@ -331,8 +323,8 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
-		ecryptfs_page = ecryptfs_get1page(ecryptfs_file,
-						  ecryptfs_page_idx);
+		ecryptfs_page = ecryptfs_get_locked_page(ecryptfs_file,
+							 ecryptfs_page_idx);
 		if (IS_ERR(ecryptfs_page)) {
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
@@ -345,6 +337,7 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 		if (rc) {
 			printk(KERN_ERR "%s: Error decrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			ClearPageUptodate(ecryptfs_page);
 			page_cache_release(ecryptfs_page);
 			goto out;
 		}
@@ -353,6 +346,9 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),
 		       num_bytes);
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
+		flush_dcache_page(ecryptfs_page);
+		SetPageUptodate(ecryptfs_page);
+		unlock_page(ecryptfs_page);
 		page_cache_release(ecryptfs_page);
 		pos += num_bytes;
 		data_offset += num_bytes;
