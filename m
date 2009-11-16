Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZKPDIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZKPDIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 22:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZKPDH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 22:07:59 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:54425 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZKPDH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 22:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lrmXPVghQuaDSWmz6Z98cT1l7gwLVRvugT/tOu8G8PM69HRNybLShywDRtsy7+cwmS
         dLP/xOuZF0ckyTDDJzrO5jtoniTxZCRh9rWpf2Gk0gSM6nKDt9DFn152VdQ+EpH89pu5
         H7fGaYxfcBcOUw0+wGZYsXy2ElCcNs2Xwy2uk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH] ntfs: Use bitmap_weight
Date: Mon, 16 Nov 2009 12:07:20 +0900
Message-Id: <1258340840-28200-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_weight instead of doing hweight32 for each u32 element
in page

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-ntfs-dev@lists.sourceforge.net
---
 fs/ntfs/super.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 80b0477..55be660 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -31,6 +31,7 @@
 #include <linux/vfs.h>
 #include <linux/moduleparam.h>
 #include <linux/smp_lock.h>
+#include <linux/bitmap.h>
 
 #include "sysctl.h"
 #include "logfile.h"
@@ -2457,7 +2458,6 @@ static void ntfs_put_super(struct super_block *sb)
 static s64 get_nr_free_clusters(ntfs_volume *vol)
 {
 	s64 nr_free = vol->nr_clusters;
-	u32 *kaddr;
 	struct address_space *mapping = vol->lcnbmp_ino->i_mapping;
 	struct page *page;
 	pgoff_t index, max_index;
@@ -2476,7 +2476,8 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 	ntfs_debug("Reading $Bitmap, max_index = 0x%lx, max_size = 0x%lx.",
 			max_index, PAGE_CACHE_SIZE / 4);
 	for (index = 0; index < max_index; index++) {
-		unsigned int i;
+		unsigned long *kaddr;
+
 		/*
 		 * Read the page from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
@@ -2489,16 +2490,16 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
-		 * For each 4 bytes, subtract the number of set bits. If this
+		 * Subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
 		 * it just means we do a little extra work but it won't affect
 		 * the result as all out of range bytes are set to zero by
 		 * ntfs_readpage().
 		 */
-	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
-			nr_free -= (s64)hweight32(kaddr[i]);
+		nr_free -= bitmap_weight(kaddr,
+					PAGE_CACHE_SIZE * BITS_PER_BYTE);
 		kunmap_atomic(kaddr, KM_USER0);
 		page_cache_release(page);
 	}
@@ -2537,7 +2538,6 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 		s64 nr_free, const pgoff_t max_index)
 {
-	u32 *kaddr;
 	struct address_space *mapping = vol->mftbmp_ino->i_mapping;
 	struct page *page;
 	pgoff_t index;
@@ -2547,7 +2547,8 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 	ntfs_debug("Reading $MFT/$BITMAP, max_index = 0x%lx, max_size = "
 			"0x%lx.", max_index, PAGE_CACHE_SIZE / 4);
 	for (index = 0; index < max_index; index++) {
-		unsigned int i;
+		unsigned long *kaddr;
+
 		/*
 		 * Read the page from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
@@ -2560,16 +2561,16 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = (u32*)kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page, KM_USER0);
 		/*
-		 * For each 4 bytes, subtract the number of set bits. If this
+		 * Subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
 		 * it just means we do a little extra work but it won't affect
 		 * the result as all out of range bytes are set to zero by
 		 * ntfs_readpage().
 		 */
-	  	for (i = 0; i < PAGE_CACHE_SIZE / 4; i++)
-			nr_free -= (s64)hweight32(kaddr[i]);
+		nr_free -= bitmap_weight(kaddr,
+					PAGE_CACHE_SIZE * BITS_PER_BYTE);
 		kunmap_atomic(kaddr, KM_USER0);
 		page_cache_release(page);
 	}
-- 
1.6.5.1

