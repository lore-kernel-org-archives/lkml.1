Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYJVROV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYJVROV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYJVROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:14:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYJVROL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:14:11 -0400
Message-ID: <48FF5F58.6040502@redhat.com>
Date: Wed, 22 Oct 2008 12:14:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Michael Halcrow <mhalcrow@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH] ecryptfs: fix memory corruption when storing crypto info
 in xattrs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ecryptfs allocates space to write crypto headers into, before
copying it out to file headers or to xattrs, it looks at the value of
crypt_stat->num_header_bytes_at_front to determine how much space it
needs.  This is also used as the file offset to the actual encrypted
data, so for xattr-stored crypto info, the value was zero.

So, we kzalloc'd 0 bytes, and then ran off to write to that memory.
(Which returned as ZERO_SIZE_PTR, so we explode quickly).

The right answer is to always allocate a page to write into; the current
code won't ever write more than that (this is enforced by the 
(PAGE_CACHE_SIZE - offset) length in the call to 
ecryptfs_generate_key_packet_set).  To be explicit about this, we now
send in a "max" parameter, rather than magically using PAGE_CACHE_SIZE 
there.

Also, since the pointer we pass down the callchain eventually gets the
virt_to_page() treatment, we should be using a alloc_page variant, not
kzalloc (see also 7fcba054373d5dfc43d26e243a5c9b92069972ee)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.27.x86_64/fs/ecryptfs/crypto.c
===================================================================
--- linux-2.6.27.x86_64.orig/fs/ecryptfs/crypto.c
+++ linux-2.6.27.x86_64/fs/ecryptfs/crypto.c
@@ -1251,6 +1251,7 @@ struct kmem_cache *ecryptfs_header_cache
 /**
  * ecryptfs_write_headers_virt
  * @page_virt: The virtual address to write the headers to
+ * @max: The size of memory allocated at page_virt
  * @size: Set to the number of bytes written by this function
  * @crypt_stat: The cryptographic context
  * @ecryptfs_dentry: The eCryptfs dentry
@@ -1278,7 +1279,8 @@ struct kmem_cache *ecryptfs_header_cache
  *
  * Returns zero on success
  */
-static int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
+static int ecryptfs_write_headers_virt(char *page_virt, size_t max,
+				       size_t *size,
 				       struct ecryptfs_crypt_stat *crypt_stat,
 				       struct dentry *ecryptfs_dentry)
 {
@@ -1296,7 +1298,7 @@ static int ecryptfs_write_headers_virt(c
 	offset += written;
 	rc = ecryptfs_generate_key_packet_set((page_virt + offset), crypt_stat,
 					      ecryptfs_dentry, &written,
-					      PAGE_CACHE_SIZE - offset);
+					      max - offset);
 	if (rc)
 		ecryptfs_printk(KERN_WARNING, "Error generating key packet "
 				"set; rc = [%d]\n", rc);
@@ -1368,14 +1370,14 @@ int ecryptfs_write_metadata(struct dentr
 		goto out;
 	}
 	/* Released in this function */
-	virt = kzalloc(crypt_stat->num_header_bytes_at_front, GFP_KERNEL);
+	virt = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!virt) {
 		printk(KERN_ERR "%s: Out of memory\n", __func__);
 		rc = -ENOMEM;
 		goto out;
 	}
-	rc = ecryptfs_write_headers_virt(virt, &size, crypt_stat,
-					 ecryptfs_dentry);
+	rc = ecryptfs_write_headers_virt(virt, PAGE_CACHE_SIZE, &size,
+					 crypt_stat, ecryptfs_dentry);
 	if (unlikely(rc)) {
 		printk(KERN_ERR "%s: Error whilst writing headers; rc = [%d]\n",
 		       __func__, rc);
@@ -1393,8 +1395,7 @@ int ecryptfs_write_metadata(struct dentr
 		goto out_free;
 	}
 out_free:
-	memset(virt, 0, crypt_stat->num_header_bytes_at_front);
-	kfree(virt);
+	free_page((unsigned long)virt);
 out:
 	return rc;
 }

