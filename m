Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXKCHjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXKCHjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 03:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXKCHjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 03:39:04 -0400
Received: from ppsw-3.csi.cam.ac.uk ([131.111.8.133]:36605 "EHLO
	ppsw-3.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbXKCHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 03:39:03 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Sat, 3 Nov 2007 07:38:59 +0000 (GMT)
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH] Fix NTFS reads regression.
Message-ID: <Pine.LNX.4.64.0711030728420.10326@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please apply the below patch which fixes a regression in NTFS reads 
identified by Mike Galbraith.  He also tested the below patch and 
confirmed that it works.

The regression was caused by:
	commit[a32ea1e1f925399e0d81ca3f7394a44a6dafa12c] Fix read/truncate race

This causes ntfs_readpage() to be called for a zero i_size inode, which 
failed when the file was compressed and non-resident.

Looking into it I found three bugs which the patch fixes.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

---
NTFS: Fix read regression.

The regression was caused by:
        commit[a32ea1e1f925399e0d81ca3f7394a44a6dafa12c] Fix read/truncate race

This causes ntfs_readpage() to be called for a zero i_size inode, which 
failed when the file was compressed and non-resident.

Thanks a lot to Mike Galbraith for reporting the issue and tracking down 
the commit that caused the regression.

Looking into it I found three bugs which the patch fixes.

Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
Tested-by:  Mike Galbraith <efault@gmx.de>

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index cfdc790..ad87cb0 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -405,6 +405,15 @@ static int ntfs_readpage(struct file *file, struct page *page)
 
 retry_readpage:
 	BUG_ON(!PageLocked(page));
+	vi = page->mapping->host;
+	i_size = i_size_read(vi);
+	/* Is the page fully outside i_size? (truncate in progress) */
+	if (unlikely(page->index >= (i_size + PAGE_CACHE_SIZE - 1) >>
+			PAGE_CACHE_SHIFT)) {
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		ntfs_debug("Read outside i_size - truncated?");
+		goto done;
+	}
 	/*
 	 * This can potentially happen because we clear PageUptodate() during
 	 * ntfs_writepage() of MstProtected() attributes.
@@ -413,7 +422,6 @@ retry_readpage:
 		unlock_page(page);
 		return 0;
 	}
-	vi = page->mapping->host;
 	ni = NTFS_I(vi);
 	/*
 	 * Only $DATA attributes can be encrypted and only unnamed $DATA
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 92dabdc..50d3b0c 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -179,10 +179,7 @@ int ntfs_map_runlist_nolock(ntfs_inode *ni, VCN vcn, ntfs_attr_search_ctx *ctx)
 	 * ntfs_mapping_pairs_decompress() fails.
 	 */
 	end_vcn = sle64_to_cpu(a->data.non_resident.highest_vcn) + 1;
-	if (!a->data.non_resident.lowest_vcn && end_vcn == 1)
-		end_vcn = sle64_to_cpu(a->data.non_resident.allocated_size) >>
-				ni->vol->cluster_size_bits;
-	if (unlikely(vcn >= end_vcn)) {
+	if (unlikely(vcn && vcn >= end_vcn)) {
 		err = -ENOENT;
 		goto err_out;
 	}
diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index d98daf5..d1619d0 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -561,6 +561,16 @@ int ntfs_read_compressed_block(struct page *page)
 	read_unlock_irqrestore(&ni->size_lock, flags);
 	max_page = ((i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT) -
 			offset;
+	/* Is the page fully outside i_size? (truncate in progress) */
+	if (xpage >= max_page) {
+		kfree(bhs);
+		kfree(pages);
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		ntfs_debug("Compressed read outside i_size - truncated?");
+		SetPageUptodate(page);
+		unlock_page(page);
+		return 0;
+	}
 	if (nr_pages < max_page)
 		max_page = nr_pages;
 	for (i = 0; i < max_page; i++, offset++) {
