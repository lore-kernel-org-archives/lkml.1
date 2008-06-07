Return-Path: <linux-kernel-owner+w=401wt.eu-S1765172AbYFGBbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765172AbYFGBbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761753AbYFGBOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:14:33 -0400
Received: from sous-sol.org ([216.99.217.87]:51055 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbYFGBOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:14:30 -0400
Message-Id: <20080607010634.138735129@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:03:00 -0700
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
       Eric Sandeen <sandeen@redhat.com>,
       Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [patch 45/50] eCryptfs: remove unnecessary page decrypt call
Content-Disposition: inline; filename=ecryptfs-remove-unnecessary-page-decrypt-call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Michael Halcrow <mhalcrow@us.ibm.com>

upstream commit: d3e49afbb66109613c3474f2273f5830ac2dcb09

The page decrypt calls in ecryptfs_write() are both pointless and buggy.
Pointless because ecryptfs_get_locked_page() has already brought the page
up to date, and buggy because prior mmap writes will just be blown away by
the decrypt call.

This patch also removes the declaration of a now-nonexistent function
ecryptfs_write_zeros().

Thanks to Eric Sandeen and David Kleikamp for helping to track this
down.

Eric said:

   fsx w/ mmap dies quickly ( < 100 ops) without this, and survives
   nicely (to millions of ops+) with it in place.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[chrisw: backport to 2.6.25.5]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ecryptfs/ecryptfs_kernel.h |    2 --
 fs/ecryptfs/read_write.c      |   22 ----------------------
 2 files changed, 24 deletions(-)

--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -626,8 +626,6 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      struct ecryptfs_auth_tok **auth_tok,
 				      char *sig);
-int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
-			 int num_zeros);
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -157,20 +157,6 @@ int ecryptfs_write(struct file *ecryptfs
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		if (start_offset_in_page) {
-			/* Read in the page from the lower
-			 * into the eCryptfs inode page cache,
-			 * decrypting */
-			rc = ecryptfs_decrypt_page(ecryptfs_page);
-			if (rc) {
-				printk(KERN_ERR "%s: Error decrypting "
-				       "page; rc = [%d]\n",
-				       __FUNCTION__, rc);
-				ClearPageUptodate(ecryptfs_page);
-				page_cache_release(ecryptfs_page);
-				goto out;
-			}
-		}
 		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
 
 		/*
@@ -349,14 +335,6 @@ int ecryptfs_read(char *data, loff_t off
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		rc = ecryptfs_decrypt_page(ecryptfs_page);
-		if (rc) {
-			printk(KERN_ERR "%s: Error decrypting "
-			       "page; rc = [%d]\n", __FUNCTION__, rc);
-			ClearPageUptodate(ecryptfs_page);
-			page_cache_release(ecryptfs_page);
-			goto out;
-		}
 		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
 		memcpy((data + data_offset),
 		       ((char *)ecryptfs_page_virt + start_offset_in_page),

-- 
