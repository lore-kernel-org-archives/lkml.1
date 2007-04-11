Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXDKDlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXDKDlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030770AbXDKDlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:41:07 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030354AbXDKDiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=ijO3jojoZdcU2Xs+nANBQ2huVds1Im+dvyqYvXCVQ7CeOER9zvoJE36c85TlM5EJfppLsb2Vr6Cq70uPkBKZVcQrV2dsWpvuV1sGLImKCaFFPsArDdEMH6CCI78jLhwbNhTs2vPaQHld3ZWvrjaUePJtu2A4T5HvmxDwMTE9res=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.49949.patchbomb.py@localhost>
In-Reply-To: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 8/13] ntfs: use zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use zero_user_page() instead of open-coding it. 

Signed-off-by: Nate Diller <nate.diller@gmail.com>

--- 

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ntfs/aops.c linux-2.6.21-rc6-mm1-test/fs/ntfs/aops.c
--- linux-2.6.21-rc6-mm1/fs/ntfs/aops.c	2007-04-09 10:41:47.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ntfs/aops.c	2007-04-09 18:18:23.000000000 -0700
@@ -245,8 +241,7 @@ static int ntfs_read_block(struct page *
 	rl = NULL;
 	nr = i = 0;
 	do {
-		u8 *kaddr;
-		int err;
+		int err = 0;
 
 		if (unlikely(buffer_uptodate(bh)))
 			continue;
@@ -254,7 +249,6 @@ static int ntfs_read_block(struct page *
 			arr[nr++] = bh;
 			continue;
 		}
-		err = 0;
 		bh->b_bdev = vol->sb->s_bdev;
 		/* Is the block within the allowed limits? */
 		if (iblock < lblock) {
@@ -340,10 +334,7 @@ handle_hole:
 		bh->b_blocknr = -1UL;
 		clear_buffer_mapped(bh);
 handle_zblock:
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + i * blocksize, 0, blocksize);
-		kunmap_atomic(kaddr, KM_USER0);
-		flush_dcache_page(page);
+		zero_user_page(page, i * blocksize, blocksize);
 		if (likely(!err))
 			set_buffer_uptodate(bh);
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
@@ -460,10 +451,7 @@ retry_readpage:
 	 * ok to ignore the compressed flag here.
 	 */
 	if (unlikely(page->index > 0)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr, 0, PAGE_CACHE_SIZE);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, 0, PAGE_CACHE_SIZE);
 		goto done;
 	}
 	if (!NInoAttr(ni))
@@ -790,14 +778,9 @@ lock_retry_remap:
 		 * uptodate so it can get discarded by the VM.
 		 */
 		if (err == -ENOENT || lcn == LCN_ENOENT) {
-			u8 *kaddr;
-
 			bh->b_blocknr = -1;
 			clear_buffer_dirty(bh);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + bh_offset(bh), 0, blocksize);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page);
+			zero_user_page(page, bh_offset(bh), blocksize);
 			set_buffer_uptodate(bh);
 			err = 0;
 			continue;
@@ -1422,10 +1405,7 @@ retry_writepage:
 		if (page->index >= (i_size >> PAGE_CACHE_SHIFT)) {
 			/* The page straddles i_size. */
 			unsigned int ofs = i_size & ~PAGE_CACHE_MASK;
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + ofs, 0, PAGE_CACHE_SIZE - ofs);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page);
+			zero_user_page(page, ofs, PAGE_CACHE_SIZE - ofs);
 		}
 		/* Handle mst protected attributes. */
 		if (NInoMstProtected(ni))
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ntfs/file.c linux-2.6.21-rc6-mm1-test/fs/ntfs/file.c
--- linux-2.6.21-rc6-mm1/fs/ntfs/file.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ntfs/file.c	2007-04-09 18:18:23.000000000 -0700
@@ -606,11 +606,8 @@ do_next_page:
 					ntfs_submit_bh_for_read(bh);
 					*wait_bh++ = bh;
 				} else {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_user_page(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -685,12 +682,8 @@ map_buffer_cached:
 						ntfs_submit_bh_for_read(bh);
 						*wait_bh++ = bh;
 					} else {
-						u8 *kaddr = kmap_atomic(page,
-								KM_USER0);
-						memset(kaddr + bh_offset(bh),
-								0, blocksize);
-						kunmap_atomic(kaddr, KM_USER0);
-						flush_dcache_page(page);
+						zero_user_page(page, bh_offset(bh),
+								blocksize);
 						set_buffer_uptodate(bh);
 					}
 				}
@@ -708,11 +701,8 @@ map_buffer_cached:
 			 */
 			if (bh_end <= pos || bh_pos >= end) {
 				if (!buffer_uptodate(bh)) {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_user_page(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 				mark_buffer_dirty(bh);
@@ -751,10 +741,7 @@ map_buffer_cached:
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 			} else if (!buffer_uptodate(bh)) {
-				u8 *kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + bh_offset(bh), 0, blocksize);
-				kunmap_atomic(kaddr, KM_USER0);
-				flush_dcache_page(page);
+				zero_user_page(page, bh_offset(bh), blocksize);
 				set_buffer_uptodate(bh);
 			}
 			continue;
@@ -878,11 +865,8 @@ rl_not_mapped_enoent:
 					if (!buffer_uptodate(bh))
 						set_buffer_uptodate(bh);
 				} else if (!buffer_uptodate(bh)) {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_user_page(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 				continue;
@@ -1137,16 +1121,12 @@ rl_not_mapped_enoent:
 			 * to zero the overflowing region.
 			 */
 			if (unlikely(bh_pos + blocksize > initialized_size)) {
-				u8 *kaddr;
 				int ofs = 0;
 
 				if (likely(bh_pos < initialized_size))
 					ofs = initialized_size - bh_pos;
-				kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + bh_offset(bh) + ofs, 0,
+				zero_user_page(page, bh_offset(bh) + ofs,
 						blocksize - ofs);
-				kunmap_atomic(kaddr, KM_USER0);
-				flush_dcache_page(page);
 			}
 		} else /* if (unlikely(!buffer_uptodate(bh))) */
 			err = -EIO;
@@ -1286,11 +1266,8 @@ rl_not_mapped_enoent:
 				if (PageUptodate(page))
 					set_buffer_uptodate(bh);
 				else {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_user_page(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1350,9 +1327,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		memset(kaddr, 0, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(*pages, 0, len);
 	}
 	goto out;
 }
@@ -1473,9 +1448,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		memset(kaddr, 0, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(*pages, 0, len);
 	}
 	goto out;
 }
