Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbYCUWx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbYCUWx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763495AbYCUWt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:49:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58970 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763493AbYCUWtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:49:24 -0400
Message-Id: <20080321224428.514851580@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Benedikt Driessen <bdriessen@escrypt.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 52/76] eCryptfs: make ecryptfs_prepare_write decrypt the page
Content-Disposition: inline; filename=ecryptfs-make-ecryptfs_prepare_write-decrypt-the-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Michael Halcrow <mhalcrow@us.ibm.com>

When the page is not up to date, ecryptfs_prepare_write() should be
acting much like ecryptfs_readpage(). This includes the painfully
obvious step of actually decrypting the page contents read from the
lower encrypted file.

Note that this patch resolves a bug in eCryptfs in 2.6.24 that one can
produce with these steps:

# mount -t ecryptfs /secret /secret
# echo "abc" > /secret/file.txt
# umount /secret
# mount -t ecryptfs /secret /secret
# echo "def" >> /secret/file.txt
# cat /secret/file.txt

Without this patch, the resulting data returned from cat is likely to
be something other than "abc\ndef\n".

(Thanks to Benedikt Driessen for reporting this.)

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Benedikt Driessen <bdriessen@escrypt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[chrisw@sous-sol.org: backport to 2.6.24.3]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/mmap.c |  102 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 76 insertions(+), 26 deletions(-)

--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -263,52 +263,102 @@ out:
 	return 0;
 }
 
-/* This function must zero any hole we create */
+/**
+ * ecryptfs_prepare_write
+ * @file: The eCryptfs file
+ * @page: The eCryptfs page
+ * @from: The start byte from which we will write
+ * @to: The end byte to which we will write
+ *
+ * This function must zero any hole we create
+ *
+ * Returns zero on success; non-zero otherwise
+ */
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
-	int rc = 0;
 	loff_t prev_page_end_size;
+	int rc = 0;
 
 	if (!PageUptodate(page)) {
-		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
-						      PAGE_CACHE_SIZE,
-						      page->mapping->host);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attemping to read lower "
-			       "page segment; rc = [%d]\n", __FUNCTION__, rc);
-			ClearPageUptodate(page);
-			goto out;
-		} else
+		struct ecryptfs_crypt_stat *crypt_stat =
+			&ecryptfs_inode_to_private(
+				file->f_path.dentry->d_inode)->crypt_stat;
+
+		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)
+		    || (crypt_stat->flags & ECRYPTFS_NEW_FILE)) {
+			rc = ecryptfs_read_lower_page_segment(
+				page, page->index, 0, PAGE_CACHE_SIZE,
+				page->mapping->host);
+			if (rc) {
+				printk(KERN_ERR "%s: Error attemping to read "
+				       "lower page segment; rc = [%d]\n",
+				       __FUNCTION__, rc);
+				ClearPageUptodate(page);
+				goto out;
+			} else
+				SetPageUptodate(page);
+		} else if (crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED) {
+			if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR) {
+				rc = ecryptfs_copy_up_encrypted_with_header(
+					page, crypt_stat);
+				if (rc) {
+					printk(KERN_ERR "%s: Error attempting "
+					       "to copy the encrypted content "
+					       "from the lower file whilst "
+					       "inserting the metadata from "
+					       "the xattr into the header; rc "
+					       "= [%d]\n", __FUNCTION__, rc);
+					ClearPageUptodate(page);
+					goto out;
+				}
+				SetPageUptodate(page);
+			} else {
+				rc = ecryptfs_read_lower_page_segment(
+					page, page->index, 0, PAGE_CACHE_SIZE,
+					page->mapping->host);
+				if (rc) {
+					printk(KERN_ERR "%s: Error reading "
+					       "page; rc = [%d]\n",
+					       __FUNCTION__, rc);
+					ClearPageUptodate(page);
+					goto out;
+				}
+				SetPageUptodate(page);
+			}
+		} else {
+			rc = ecryptfs_decrypt_page(page);
+			if (rc) {
+				printk(KERN_ERR "%s: Error decrypting page "
+				       "at index [%ld]; rc = [%d]\n",
+				       __FUNCTION__, page->index, rc);
+				ClearPageUptodate(page);
+				goto out;
+			}
 			SetPageUptodate(page);
+		}
 	}
-
 	prev_page_end_size = ((loff_t)page->index << PAGE_CACHE_SHIFT);
-
-	/*
-	 * If creating a page or more of holes, zero them out via truncate.
-	 * Note, this will increase i_size.
-	 */
+	/* If creating a page or more of holes, zero them out via truncate.
+	 * Note, this will increase i_size. */
 	if (page->index != 0) {
 		if (prev_page_end_size > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
 					       prev_page_end_size);
 			if (rc) {
-				printk(KERN_ERR "Error on attempt to "
+				printk(KERN_ERR "%s: Error on attempt to "
 				       "truncate to (higher) offset [%lld];"
-				       " rc = [%d]\n", prev_page_end_size, rc);
+				       " rc = [%d]\n", __FUNCTION__,
+				       prev_page_end_size, rc);
 				goto out;
 			}
 		}
 	}
-	/*
-	 * Writing to a new page, and creating a small hole from start of page?
-	 * Zero it out.
-	 */
-	if ((i_size_read(page->mapping->host) == prev_page_end_size) &&
-	    (from != 0)) {
+	/* Writing to a new page, and creating a small hole from start
+	 * of page?  Zero it out. */
+	if ((i_size_read(page->mapping->host) == prev_page_end_size)
+	    && (from != 0))
 		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
-	}
 out:
 	return rc;
 }

-- 
