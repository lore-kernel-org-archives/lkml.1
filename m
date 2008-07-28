Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYG1QNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYG1QNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbYG1QNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:13:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbYG1QNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:13:21 -0400
Message-ID: <488DF00F.3080809@redhat.com>
Date: Mon, 28 Jul 2008 11:13:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Michael Halcrow <mhalcrow@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of memory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With SLUB debugging turned on in 2.6.26, I was getting memory corruption
when testing eCryptfs.  The root cause turned out to be that eCryptfs
was doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that
as a nice page-aligned chunk of memory.  But at least with SLUB debugging
on, this is not always true, and the page we get from virt_to_page does
not necessarily match the PAGE_CACHE_SIZE worth of memory we got from 
kmalloc.

My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for
2 different multi-megabyte files.  With this change I no longer see
the corruption.

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.26/fs/ecryptfs/crypto.c
===================================================================
--- linux-2.6.26.orig/fs/ecryptfs/crypto.c
+++ linux-2.6.26/fs/ecryptfs/crypto.c
@@ -474,8 +474,8 @@ int ecryptfs_encrypt_page(struct page *p
 {
 	struct inode *ecryptfs_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
-	char *enc_extent_virt = NULL;
-	struct page *enc_extent_page;
+	char *enc_extent_virt;
+	struct page *enc_extent_page = NULL;
 	loff_t extent_offset;
 	int rc = 0;
 
@@ -491,14 +491,14 @@ int ecryptfs_encrypt_page(struct page *p
 			       page->index);
 		goto out;
 	}
-	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
-	if (!enc_extent_virt) {
+	enc_extent_page = alloc_page(GFP_USER);
+	if (!enc_extent_page) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
 				"encrypted extent\n");
 		goto out;
 	}
-	enc_extent_page = virt_to_page(enc_extent_virt);
+	enc_extent_virt = kmap(enc_extent_page);
 	for (extent_offset = 0;
 	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
 	     extent_offset++) {
@@ -526,7 +526,10 @@ int ecryptfs_encrypt_page(struct page *p
 		}
 	}
 out:
-	kfree(enc_extent_virt);
+	if (enc_extent_page) {
+		kunmap(enc_extent_page);
+		__free_page(enc_extent_page);
+	}
 	return rc;
 }
 
@@ -608,8 +611,8 @@ int ecryptfs_decrypt_page(struct page *p
 {
 	struct inode *ecryptfs_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
-	char *enc_extent_virt = NULL;
-	struct page *enc_extent_page;
+	char *enc_extent_virt;
+	struct page *enc_extent_page = NULL;
 	unsigned long extent_offset;
 	int rc = 0;
 
@@ -626,14 +629,14 @@ int ecryptfs_decrypt_page(struct page *p
 			       page->index);
 		goto out;
 	}
-	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
-	if (!enc_extent_virt) {
+	enc_extent_page = alloc_page(GFP_USER);
+	if (!enc_extent_page) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
 				"encrypted extent\n");
 		goto out;
 	}
-	enc_extent_page = virt_to_page(enc_extent_virt);
+	enc_extent_virt = kmap(enc_extent_page);
 	for (extent_offset = 0;
 	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
 	     extent_offset++) {
@@ -661,7 +664,10 @@ int ecryptfs_decrypt_page(struct page *p
 		}
 	}
 out:
-	kfree(enc_extent_virt);
+	if (enc_extent_page) {
+		kunmap(enc_extent_page);
+		__free_page(enc_extent_page);
+	}
 	return rc;
 }
 

