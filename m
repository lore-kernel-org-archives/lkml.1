Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbYG3Xlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbYG3Xlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759578AbYG3XlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:41:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:34501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760828AbYG3XlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:41:04 -0400
Date: Wed, 30 Jul 2008 16:27:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
       Michael Halcrow <mhalcrow@us.ibm.com>, Rik van Riel <riel@redhat.com>
Subject: [patch 23/29] eCryptfs: use page_alloc not kmalloc to get a page
	of memory
Message-ID: <20080730232732.GX30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Eric Sandeen <sandeen@redhat.com>

commit 7fcba054373d5dfc43d26e243a5c9b92069972ee upstream
Date: Mon, 28 Jul 2008 15:46:39 -0700
Subject: [patch 23/29] eCryptfs: use page_alloc not kmalloc to get a page of memory

With SLUB debugging turned on in 2.6.26, I was getting memory corruption
when testing eCryptfs.  The root cause turned out to be that eCryptfs was
doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that as a nice
page-aligned chunk of memory.  But at least with SLUB debugging on, this
is not always true, and the page we get from virt_to_page does not
necessarily match the PAGE_CACHE_SIZE worth of memory we got from kmalloc.

My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for 2
different multi-megabyte files.  With this change I no longer see the
corruption.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/crypto.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
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
 

-- 
