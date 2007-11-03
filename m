Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbXKCE4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbXKCE4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 00:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXKCE4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 00:56:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:38316 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752949AbXKCE4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 00:56:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/fZyU4Ljjfg7DupRr7chr/8fxW2z/JiQr3n8mVGF
	zNF0ahBvtGPZOW
Subject: Re: [Linux-NTFS-Dev] 2.6.23 regression: second access of empty
	ntfs file leads to D	state hang
From: Mike Galbraith <efault@gmx.de>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ntfs-dev <linux-ntfs-dev@lists.sourceforge.net>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <1EEFFD17-64E7-41C6-BFED-529A5794EC36@cam.ac.uk>
References: <1193638086.7409.21.camel@Homer.simpson.net>
	 <E3E758D0-25AC-45B8-9BAB-F8CDF75AF3CA@cam.ac.uk>
	 <1193658311.7324.2.camel@Homer.simpson.net>
	 <4E61D235-B8E8-43DF-96A5-B3169E6AB223@cam.ac.uk>
	 <1193668997.7284.2.camel@Homer.simpson.net>
	 <1193671099.7172.0.camel@Homer.simpson.net>
	 <1193731202.7229.9.camel@Homer.simpson.net>
	 <3BFCE55A-F7E2-4A19-8FD9-F23AF2A29D76@cam.ac.uk>
	 <1EEFFD17-64E7-41C6-BFED-529A5794EC36@cam.ac.uk>
Content-Type: text/plain
Date: Sat, 03 Nov 2007 05:56:17 +0100
Message-Id: <1194065777.11539.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 19:22 +0000, Anton Altaparmakov wrote:

> Would you be able to test it in your setup?  Thanks a lot in advance!

Modulo uninitialized vi, works fine.  I moved it up, and all is well.
Thanks.

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


