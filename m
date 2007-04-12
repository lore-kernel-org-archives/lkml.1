Return-Path: <linux-kernel-owner+w=401wt.eu-S1161531AbXDLC41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161531AbXDLC41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161544AbXDLCyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:54:00 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61978 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161530AbXDLCxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=AIbkPyRCdYe7A/Tx/7jbjlkGKUhhizZpDtK33yoW/YysgBpVL67oMhBwU409rXBgVPANANZ+uOPXZFxngxPvmKpps9hqfqPXDM6a1UgP74/v4LvdUf35GPy7caBgrty0jQr/MWGZJiTK3IGZcs+VKS56XccQsh+sxU4jqUfP9c8=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.58821.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 11/17] ntfs: convert ntfs_map_page to read_kmap_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ntfs_map_page() and ntfs_unmap_page() using the new read_kmap_page()
and put_kmapped_page() calls, and their locking variants, and remove
unneeded PageError checking.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/aops.h linux-2.6.21-rc5-mm4-test/fs/ntfs/aops.h
--- linux-2.6.21-rc5-mm4/fs/ntfs/aops.h	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/aops.h	2007-04-06 01:59:19.000000000 -0700
@@ -31,73 +31,6 @@
 
 #include "inode.h"
 
-/**
- * ntfs_unmap_page - release a page that was mapped using ntfs_map_page()
- * @page:	the page to release
- *
- * Unpin, unmap and release a page that was obtained from ntfs_map_page().
- */
-static inline void ntfs_unmap_page(struct page *page)
-{
-	kunmap(page);
-	page_cache_release(page);
-}
-
-/**
- * ntfs_map_page - map a page into accessible memory, reading it if necessary
- * @mapping:	address space for which to obtain the page
- * @index:	index into the page cache for @mapping of the page to map
- *
- * Read a page from the page cache of the address space @mapping at position
- * @index, where @index is in units of PAGE_CACHE_SIZE, and not in bytes.
- *
- * If the page is not in memory it is loaded from disk first using the readpage
- * method defined in the address space operations of @mapping and the page is
- * added to the page cache of @mapping in the process.
- *
- * If the page belongs to an mst protected attribute and it is marked as such
- * in its ntfs inode (NInoMstProtected()) the mst fixups are applied but no
- * error checking is performed.  This means the caller has to verify whether
- * the ntfs record(s) contained in the page are valid or not using one of the
- * ntfs_is_XXXX_record{,p}() macros, where XXXX is the record type you are
- * expecting to see.  (For details of the macros, see fs/ntfs/layout.h.)
- *
- * If the page is in high memory it is mapped into memory directly addressible
- * by the kernel.
- *
- * Finally the page count is incremented, thus pinning the page into place.
- *
- * The above means that page_address(page) can be used on all pages obtained
- * with ntfs_map_page() to get the kernel virtual address of the page.
- *
- * When finished with the page, the caller has to call ntfs_unmap_page() to
- * unpin, unmap and release the page.
- *
- * Note this does not grant exclusive access. If such is desired, the caller
- * must provide it independently of the ntfs_{un}map_page() calls by using
- * a {rw_}semaphore or other means of serialization. A spin lock cannot be
- * used as ntfs_map_page() can block.
- *
- * The unlocked and uptodate page is returned on success or an encoded error
- * on failure. Caller has to test for error using the IS_ERR() macro on the
- * return value. If that evaluates to 'true', the negative error code can be
- * obtained using PTR_ERR() on the return value of ntfs_map_page().
- */
-static inline struct page *ntfs_map_page(struct address_space *mapping,
-		unsigned long index)
-{
-	struct page *page = read_mapping_page(mapping, index, NULL);
-
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (!PageError(page))
-			return page;
-		ntfs_unmap_page(page);
-		return ERR_PTR(-EIO);
-	}
-	return page;
-}
-
 #ifdef NTFS_RW
 
 extern void mark_ntfs_record_dirty(struct page *page, const unsigned int ofs);
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/bitmap.c linux-2.6.21-rc5-mm4-test/fs/ntfs/bitmap.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/bitmap.c	2006-11-29 13:57:37.000000000 -0800
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/bitmap.c	2007-04-06 12:40:53.000000000 -0700
@@ -72,7 +72,7 @@ int __ntfs_bitmap_set_bits_in_run(struct
 
 	/* Get the page containing the first bit (@start_bit). */
 	mapping = vi->i_mapping;
-	page = ntfs_map_page(mapping, index);
+	page = read_kmap_page(mapping, index);
 	if (IS_ERR(page)) {
 		if (!is_rollback)
 			ntfs_error(vi->i_sb, "Failed to map first page (error "
@@ -123,8 +123,8 @@ int __ntfs_bitmap_set_bits_in_run(struct
 		/* Update @index and get the next page. */
 		flush_dcache_page(page);
 		set_page_dirty(page);
-		ntfs_unmap_page(page);
-		page = ntfs_map_page(mapping, ++index);
+		put_kmapped_page(page);
+		page = read_kmap_page(mapping, ++index);
 		if (IS_ERR(page))
 			goto rollback;
 		kaddr = page_address(page);
@@ -159,7 +159,7 @@ done:
 	/* We are done.  Unmap the page and return success. */
 	flush_dcache_page(page);
 	set_page_dirty(page);
-	ntfs_unmap_page(page);
+	put_kmapped_page(page);
 	ntfs_debug("Done.");
 	return 0;
 rollback:
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/dir.c linux-2.6.21-rc5-mm4-test/fs/ntfs/dir.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/dir.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/dir.c	2007-04-06 12:40:53.000000000 -0700
@@ -317,7 +317,7 @@ descend_into_child_node:
 	 * of PAGE_CACHE_SIZE and map the page cache page, reading it from
 	 * disk if necessary.
 	 */
-	page = ntfs_map_page(ia_mapping, vcn <<
+	page = __read_kmap_page(ia_mapping, vcn <<
 			dir_ni->itype.index.vcn_size_bits >> PAGE_CACHE_SHIFT);
 	if (IS_ERR(page)) {
 		ntfs_error(sb, "Failed to map directory index page, error %ld.",
@@ -325,7 +325,6 @@ descend_into_child_node:
 		err = PTR_ERR(page);
 		goto err_out;
 	}
-	lock_page(page);
 	kaddr = (u8*)page_address(page);
 fast_descend_into_child_node:
 	/* Get to the index allocation block. */
@@ -446,8 +445,7 @@ found_it2:
 				*res = NULL;
 			}
 			mref = le64_to_cpu(ie->data.dir.indexed_file);
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			return mref;
 		}
 		/*
@@ -479,8 +477,7 @@ found_it2:
 						"this message to "
 						"linux-ntfs-dev@lists."
 						"sourceforge.net.");
-				unlock_page(page);
-				ntfs_unmap_page(page);
+				put_locked_page(page);
 				goto dir_err_out;
 			}
 
@@ -562,8 +559,7 @@ found_it2:
 					vol->cluster_size_bits >>
 					PAGE_CACHE_SHIFT)
 				goto fast_descend_into_child_node;
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			goto descend_into_child_node;
 		}
 		ntfs_error(sb, "Negative child node vcn in directory inode "
@@ -576,15 +572,13 @@ found_it2:
 	 * associated with it.
 	 */
 	if (name) {
-		unlock_page(page);
-		ntfs_unmap_page(page);
+		put_locked_page(page);
 		return name->mref;
 	}
 	ntfs_debug("Entry not found.");
 	err = -ENOENT;
 unm_err_out:
-	unlock_page(page);
-	ntfs_unmap_page(page);
+	put_locked_page(page);
 err_out:
 	if (!err)
 		err = -EIO;
@@ -795,7 +789,7 @@ descend_into_child_node:
 	 * of PAGE_CACHE_SIZE and map the page cache page, reading it from
 	 * disk if necessary.
 	 */
-	page = ntfs_map_page(ia_mapping, vcn <<
+	page = __read_kmap_page(ia_mapping, vcn <<
 			dir_ni->itype.index.vcn_size_bits >> PAGE_CACHE_SHIFT);
 	if (IS_ERR(page)) {
 		ntfs_error(sb, "Failed to map directory index page, error %ld.",
@@ -803,7 +797,6 @@ descend_into_child_node:
 		err = PTR_ERR(page);
 		goto err_out;
 	}
-	lock_page(page);
 	kaddr = (u8*)page_address(page);
 fast_descend_into_child_node:
 	/* Get to the index allocation block. */
@@ -907,8 +900,7 @@ fast_descend_into_child_node:
 				vol->upcase, vol->upcase_len)) {
 found_it2:
 			mref = le64_to_cpu(ie->data.dir.indexed_file);
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			return mref;
 		}
 		/*
@@ -971,8 +963,7 @@ found_it2:
 					vol->cluster_size_bits >>
 					PAGE_CACHE_SHIFT)
 				goto fast_descend_into_child_node;
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			goto descend_into_child_node;
 		}
 		ntfs_error(sb, "Negative child node vcn in directory inode "
@@ -983,8 +974,7 @@ found_it2:
 	ntfs_debug("Entry not found.");
 	err = -ENOENT;
 unm_err_out:
-	unlock_page(page);
-	ntfs_unmap_page(page);
+	put_locked_page(page);
 err_out:
 	if (!err)
 		err = -EIO;
@@ -1271,7 +1261,7 @@ get_next_bmp_page:
 			(unsigned long long)bmp_pos >> (3 + PAGE_CACHE_SHIFT),
 			(unsigned long long)bmp_pos &
 			(unsigned long long)((PAGE_CACHE_SIZE * 8) - 1));
-	bmp_page = ntfs_map_page(bmp_mapping,
+	bmp_page = read_kmap_page(bmp_mapping,
 			bmp_pos >> (3 + PAGE_CACHE_SHIFT));
 	if (IS_ERR(bmp_page)) {
 		ntfs_error(sb, "Reading index bitmap failed.");
@@ -1289,7 +1279,7 @@ find_next_index_buffer:
 		 * page, and put away the old one.
 		 */
 		if (unlikely((cur_bmp_pos >> 3) >= PAGE_CACHE_SIZE)) {
-			ntfs_unmap_page(bmp_page);
+			put_kmapped_page(bmp_page);
 			bmp_pos += PAGE_CACHE_SIZE * 8;
 			cur_bmp_pos = 0;
 			goto get_next_bmp_page;
@@ -1306,22 +1296,20 @@ find_next_index_buffer:
 	if ((prev_ia_pos & (s64)PAGE_CACHE_MASK) !=
 			(ia_pos & (s64)PAGE_CACHE_MASK)) {
 		prev_ia_pos = ia_pos;
-		if (likely(ia_page != NULL)) {
-			unlock_page(ia_page);
-			ntfs_unmap_page(ia_page);
-		}
+		if (likely(ia_page != NULL))
+			put_locked_page(ia_page);
+
 		/*
 		 * Map the page cache page containing the current ia_pos,
 		 * reading it from disk if necessary.
 		 */
-		ia_page = ntfs_map_page(ia_mapping, ia_pos >> PAGE_CACHE_SHIFT);
+		ia_page = __read_kmap_page(ia_mapping, ia_pos >> PAGE_CACHE_SHIFT);
 		if (IS_ERR(ia_page)) {
 			ntfs_error(sb, "Reading index allocation data failed.");
 			err = PTR_ERR(ia_page);
 			ia_page = NULL;
 			goto err_out;
 		}
-		lock_page(ia_page);
 		kaddr = (u8*)page_address(ia_page);
 	}
 	/* Get the current index buffer. */
@@ -1422,19 +1410,18 @@ find_next_index_buffer:
 				filldir);
 		if (rc) {
 			/* @ia_page is already unlocked in this case. */
-			ntfs_unmap_page(ia_page);
-			ntfs_unmap_page(bmp_page);
+			put_kmapped_page(ia_page);
+			put_kmapped_page(bmp_page);
 			iput(bmp_vi);
 			goto abort;
 		}
 	}
 	goto find_next_index_buffer;
 unm_EOD:
-	if (ia_page) {
-		unlock_page(ia_page);
-		ntfs_unmap_page(ia_page);
-	}
-	ntfs_unmap_page(bmp_page);
+	if (ia_page)
+		put_locked_page(ia_page);
+
+	put_kmapped_page(bmp_page);
 	iput(bmp_vi);
 EOD:
 	/* We are finished, set fpos to EOD. */
@@ -1453,14 +1440,12 @@ done:
 	return 0;
 err_out:
 	if (bmp_page) {
-		ntfs_unmap_page(bmp_page);
+		put_kmapped_page(bmp_page);
 iput_err_out:
 		iput(bmp_vi);
 	}
-	if (ia_page) {
-		unlock_page(ia_page);
-		ntfs_unmap_page(ia_page);
-	}
+	if (ia_page)
+		put_locked_page(ia_page);
 	kfree(ir);
 	kfree(name);
 	if (ctx)
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/index.c linux-2.6.21-rc5-mm4-test/fs/ntfs/index.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/index.c	2007-04-05 17:13:11.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/index.c	2007-04-06 01:59:19.000000000 -0700
@@ -64,8 +64,7 @@ void ntfs_index_ctx_put(ntfs_index_conte
 			struct page *page = ictx->page;
 			if (page) {
 				BUG_ON(!PageLocked(page));
-				unlock_page(page);
-				ntfs_unmap_page(page);
+				put_locked_page(page);
 			}
 		}
 	}
@@ -273,7 +272,7 @@ descend_into_child_node:
 	 * of PAGE_CACHE_SIZE and map the page cache page, reading it from
 	 * disk if necessary.
 	 */
-	page = ntfs_map_page(ia_mapping, vcn <<
+	page = __read_kmap_page(ia_mapping, vcn <<
 			idx_ni->itype.index.vcn_size_bits >> PAGE_CACHE_SHIFT);
 	if (IS_ERR(page)) {
 		ntfs_error(sb, "Failed to map index page, error %ld.",
@@ -281,7 +280,6 @@ descend_into_child_node:
 		err = PTR_ERR(page);
 		goto err_out;
 	}
-	lock_page(page);
 	kaddr = (u8*)page_address(page);
 fast_descend_into_child_node:
 	/* Get to the index allocation block. */
@@ -429,15 +427,13 @@ ia_done:
 				vol->cluster_size_bits >>
 				PAGE_CACHE_SHIFT)
 			goto fast_descend_into_child_node;
-		unlock_page(page);
-		ntfs_unmap_page(page);
+		put_locked_page(page);
 		goto descend_into_child_node;
 	}
 	ntfs_error(sb, "Negative child node vcn in inode 0x%lx.",
 			idx_ni->mft_no);
 unm_err_out:
-	unlock_page(page);
-	ntfs_unmap_page(page);
+	put_locked_page(page);
 err_out:
 	if (!err)
 		err = -EIO;
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/lcnalloc.c linux-2.6.21-rc5-mm4-test/fs/ntfs/lcnalloc.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/lcnalloc.c	2006-11-29 13:57:37.000000000 -0800
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/lcnalloc.c	2007-04-06 01:59:19.000000000 -0700
@@ -280,9 +280,9 @@ runlist_element *ntfs_cluster_alloc(ntfs
 				set_page_dirty(page);
 				need_writeback = 0;
 			}
-			ntfs_unmap_page(page);
+			put_kmapped_page(page);
 		}
-		page = ntfs_map_page(mapping, last_read_pos >>
+		page = read_kmap_page(mapping, last_read_pos >>
 				PAGE_CACHE_SHIFT);
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
@@ -748,7 +748,7 @@ out:
 			set_page_dirty(page);
 			need_writeback = 0;
 		}
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 	}
 	if (likely(!err)) {
 		up_write(&vol->lcnbmp_lock);
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/logfile.c linux-2.6.21-rc5-mm4-test/fs/ntfs/logfile.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/logfile.c	2006-11-29 13:57:37.000000000 -0800
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/logfile.c	2007-04-06 01:59:19.000000000 -0700
@@ -396,7 +396,7 @@ static int ntfs_check_and_load_restart_p
 		idx = (pos + size) >> PAGE_CACHE_SHIFT;
 		BUG_ON((pos + size) & ~PAGE_CACHE_MASK);
 		do {
-			page = ntfs_map_page(vi->i_mapping, idx);
+			page = read_kmap_page(vi->i_mapping, idx);
 			if (IS_ERR(page)) {
 				ntfs_error(vi->i_sb, "Error mapping $LogFile "
 						"page (index %lu).", idx);
@@ -407,7 +407,7 @@ static int ntfs_check_and_load_restart_p
 			}
 			size = min_t(int, to_read, PAGE_CACHE_SIZE);
 			memcpy((u8*)trp + have_read, page_address(page), size);
-			ntfs_unmap_page(page);
+			put_kmapped_page(page);
 			have_read += size;
 			to_read -= size;
 			idx++;
@@ -541,8 +541,8 @@ bool ntfs_check_logfile(struct inode *lo
 		pgoff_t idx = pos >> PAGE_CACHE_SHIFT;
 		if (!page || page->index != idx) {
 			if (page)
-				ntfs_unmap_page(page);
-			page = ntfs_map_page(mapping, idx);
+				put_kmapped_page(page);
+			page = read_kmap_page(mapping, idx);
 			if (IS_ERR(page)) {
 				ntfs_error(vol->sb, "Error mapping $LogFile "
 						"page (index %lu).", idx);
@@ -602,7 +602,7 @@ bool ntfs_check_logfile(struct inode *lo
 		 * find a valid one further in the file.
 		 */
 		if (err != -EINVAL) {
-			ntfs_unmap_page(page);
+			put_kmapped_page(page);
 			goto err_out;
 		}
 		/* Continue looking. */
@@ -610,7 +610,7 @@ bool ntfs_check_logfile(struct inode *lo
 			pos = NTFS_BLOCK_SIZE >> 1;
 	}
 	if (page)
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 	if (logfile_is_empty) {
 		NVolSetLogFileEmpty(vol);
 is_empty:
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/mft.c linux-2.6.21-rc5-mm4-test/fs/ntfs/mft.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/mft.c	2006-11-29 13:57:37.000000000 -0800
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/mft.c	2007-04-06 01:59:19.000000000 -0700
@@ -80,7 +80,7 @@ static inline MFT_RECORD *map_mft_record
 		}
 	}
 	/* Read, map, and pin the page. */
-	page = ntfs_map_page(mft_vi->i_mapping, index);
+	page = read_kmap_page(mft_vi->i_mapping, index);
 	if (likely(!IS_ERR(page))) {
 		/* Catch multi sector transfer fixup errors. */
 		if (likely(ntfs_is_mft_recordp((le32*)(page_address(page) +
@@ -91,7 +91,7 @@ static inline MFT_RECORD *map_mft_record
 		}
 		ntfs_error(vol->sb, "Mft record 0x%lx is corrupt.  "
 				"Run chkdsk.", ni->mft_no);
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 		page = ERR_PTR(-EIO);
 		NVolSetErrors(vol);
 	}
@@ -192,7 +192,7 @@ static inline void unmap_mft_record_page
 	BUG_ON(!ni->page);
 
 	// TODO: If dirty, blah...
-	ntfs_unmap_page(ni->page);
+	put_kmapped_page(ni->page);
 	ni->page = NULL;
 	ni->page_ofs = 0;
 	return;
@@ -486,14 +486,13 @@ int ntfs_sync_mft_mirror(ntfs_volume *vo
 		goto err_out;
 	}
 	/* Get the page containing the mirror copy of the mft record @m. */
-	page = ntfs_map_page(vol->mftmirr_ino->i_mapping, mft_no >>
+	page = __read_kmap_page(vol->mftmirr_ino->i_mapping, mft_no >>
 			(PAGE_CACHE_SHIFT - vol->mft_record_size_bits));
 	if (IS_ERR(page)) {
 		ntfs_error(vol->sb, "Failed to map mft mirror page.");
 		err = PTR_ERR(page);
 		goto err_out;
 	}
-	lock_page(page);
 	BUG_ON(!PageUptodate(page));
 	ClearPageUptodate(page);
 	/* Offset of the mft mirror record inside the page. */
@@ -618,8 +617,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vo
 	post_write_mst_fixup((NTFS_RECORD*)kmirr);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
-	unlock_page(page);
-	ntfs_unmap_page(page);
+	put_locked_page(page);
 	if (likely(!err)) {
 		ntfs_debug("Done.");
 	} else {
@@ -1189,7 +1187,7 @@ static int ntfs_mft_bitmap_find_and_allo
 		 * for a zero bit.
 		 */
 		if (size) {
-			page = ntfs_map_page(mftbmp_mapping,
+			page = read_kmap_page(mftbmp_mapping,
 					ofs >> PAGE_CACHE_SHIFT);
 			if (unlikely(IS_ERR(page))) {
 				ntfs_error(vol->sb, "Failed to read mft "
@@ -1211,13 +1209,13 @@ static int ntfs_mft_bitmap_find_and_allo
 				if (b < 8 && b >= (bit & 7)) {
 					ll = data_pos + (bit & ~7ull) + b;
 					if (unlikely(ll > (1ll << 32))) {
-						ntfs_unmap_page(page);
+						put_kmapped_page(page);
 						return -ENOSPC;
 					}
 					*byte |= 1 << b;
 					flush_dcache_page(page);
 					set_page_dirty(page);
-					ntfs_unmap_page(page);
+					put_kmapped_page(page);
 					ntfs_debug("Done.  (Found and "
 							"allocated mft record "
 							"0x%llx.)",
@@ -1229,7 +1227,7 @@ static int ntfs_mft_bitmap_find_and_allo
 					"data_pos 0x%llx, bit 0x%llx", size,
 					(long long)data_pos, (long long)bit);
 			data_pos += size;
-			ntfs_unmap_page(page);
+			put_kmapped_page(page);
 			/*
 			 * If the end of the pass has not been reached yet,
 			 * continue searching the mft bitmap for a zero bit.
@@ -1327,7 +1325,7 @@ static int ntfs_mft_bitmap_extend_alloca
 	 * to us.
 	 */
 	ll = lcn >> 3;
-	page = ntfs_map_page(vol->lcnbmp_ino->i_mapping,
+	page = read_kmap_page(vol->lcnbmp_ino->i_mapping,
 			ll >> PAGE_CACHE_SHIFT);
 	if (IS_ERR(page)) {
 		up_write(&mftbmp_ni->runlist.lock);
@@ -1343,7 +1341,7 @@ static int ntfs_mft_bitmap_extend_alloca
 		flush_dcache_page(page);
 		set_page_dirty(page);
 		up_write(&vol->lcnbmp_lock);
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 		/* Update the mft bitmap runlist. */
 		rl->length++;
 		rl[1].vcn++;
@@ -1351,7 +1349,7 @@ static int ntfs_mft_bitmap_extend_alloca
 		ntfs_debug("Appending one cluster to mft bitmap.");
 	} else {
 		up_write(&vol->lcnbmp_lock);
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 		/* Allocate a cluster from the DATA_ZONE. */
 		rl2 = ntfs_cluster_alloc(vol, rl[1].vcn, 1, lcn, DATA_ZONE,
 				true);
@@ -2117,13 +2115,12 @@ static int ntfs_mft_record_format(const 
 		}
 	}
 	/* Read, map, and pin the page containing the mft record. */
-	page = ntfs_map_page(mft_vi->i_mapping, index);
+	page = __read_kmap_page(mft_vi->i_mapping, index);
 	if (unlikely(IS_ERR(page))) {
 		ntfs_error(vol->sb, "Failed to map page containing mft record "
 				"to format 0x%llx.", (long long)mft_no);
 		return PTR_ERR(page);
 	}
-	lock_page(page);
 	BUG_ON(!PageUptodate(page));
 	ClearPageUptodate(page);
 	m = (MFT_RECORD*)((u8*)page_address(page) + ofs);
@@ -2132,20 +2129,18 @@ static int ntfs_mft_record_format(const 
 		ntfs_error(vol->sb, "Failed to layout mft record 0x%llx.",
 				(long long)mft_no);
 		SetPageUptodate(page);
-		unlock_page(page);
-		ntfs_unmap_page(page);
+		put_locked_page(page);
 		return err;
 	}
 	flush_dcache_page(page);
 	SetPageUptodate(page);
-	unlock_page(page);
 	/*
 	 * Make sure the mft record is written out to disk.  We could use
 	 * ilookup5() to check if an inode is in icache and so on but this is
 	 * unnecessary as ntfs_writepage() will write the dirty record anyway.
 	 */
 	mark_ntfs_record_dirty(page, ofs);
-	ntfs_unmap_page(page);
+	put_locked_page(page);
 	ntfs_debug("Done.");
 	return 0;
 }
@@ -2518,14 +2513,13 @@ mft_rec_already_initialized:
 	index = bit << vol->mft_record_size_bits >> PAGE_CACHE_SHIFT;
 	ofs = (bit << vol->mft_record_size_bits) & ~PAGE_CACHE_MASK;
 	/* Read, map, and pin the page containing the mft record. */
-	page = ntfs_map_page(vol->mft_ino->i_mapping, index);
+	page = __read_kmap_page(vol->mft_ino->i_mapping, index);
 	if (unlikely(IS_ERR(page))) {
 		ntfs_error(vol->sb, "Failed to map page containing allocated "
 				"mft record 0x%llx.", (long long)bit);
 		err = PTR_ERR(page);
 		goto undo_mftbmp_alloc;
 	}
-	lock_page(page);
 	BUG_ON(!PageUptodate(page));
 	ClearPageUptodate(page);
 	m = (MFT_RECORD*)((u8*)page_address(page) + ofs);
@@ -2541,8 +2535,7 @@ mft_rec_already_initialized:
 					(long long)bit);
 			err = -EIO;
 			SetPageUptodate(page);
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			NVolSetErrors(vol);
 			goto undo_mftbmp_alloc;
 		}
@@ -2560,8 +2553,7 @@ mft_rec_already_initialized:
 			ntfs_error(vol->sb, "Failed to layout allocated mft "
 					"record 0x%llx.", (long long)bit);
 			SetPageUptodate(page);
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			goto undo_mftbmp_alloc;
 		}
 		if (seq_no)
@@ -2599,8 +2591,7 @@ mft_rec_already_initialized:
 			flush_dcache_page(page);
 			/* Make sure the mft record is written out to disk. */
 			mark_ntfs_record_dirty(page, ofs);
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			goto undo_mftbmp_alloc;
 		}
 		/*
@@ -2611,12 +2602,11 @@ mft_rec_already_initialized:
 		 * the mft record.
 		 */
 		mark_ntfs_record_dirty(page, ofs);
-		unlock_page(page);
 		/*
 		 * Need to unmap the page since map_extent_mft_record() mapped
 		 * it as well so we have it mapped twice at the moment.
 		 */
-		ntfs_unmap_page(page);
+		put_locked_page(page);
 	} else {
 		/*
 		 * Allocate a new VFS inode and set it up.  NOTE: @vi->i_nlink
@@ -2632,8 +2622,7 @@ mft_rec_already_initialized:
 			flush_dcache_page(page);
 			/* Make sure the mft record is written out to disk. */
 			mark_ntfs_record_dirty(page, ofs);
-			unlock_page(page);
-			ntfs_unmap_page(page);
+			put_locked_page(page);
 			goto undo_mftbmp_alloc;
 		}
 		vi->i_ino = bit;
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/super.c linux-2.6.21-rc5-mm4-test/fs/ntfs/super.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/super.c	2007-04-05 17:14:25.000000000 -0700
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/super.c	2007-04-06 12:40:53.000000000 -0700
@@ -1078,11 +1078,11 @@ static bool check_mft_mirror(ntfs_volume
 		/* Switch pages if necessary. */
 		if (!(i % mrecs_per_page)) {
 			if (index) {
-				ntfs_unmap_page(mft_page);
-				ntfs_unmap_page(mirr_page);
+				put_kmapped_page(mft_page);
+				put_kmapped_page(mirr_page);
 			}
 			/* Get the $MFT page. */
-			mft_page = ntfs_map_page(vol->mft_ino->i_mapping,
+			mft_page = read_kmap_page(vol->mft_ino->i_mapping,
 					index);
 			if (IS_ERR(mft_page)) {
 				ntfs_error(sb, "Failed to read $MFT.");
@@ -1090,7 +1090,7 @@ static bool check_mft_mirror(ntfs_volume
 			}
 			kmft = page_address(mft_page);
 			/* Get the $MFTMirr page. */
-			mirr_page = ntfs_map_page(vol->mftmirr_ino->i_mapping,
+			mirr_page = read_kmap_page(vol->mftmirr_ino->i_mapping,
 					index);
 			if (IS_ERR(mirr_page)) {
 				ntfs_error(sb, "Failed to read $MFTMirr.");
@@ -1107,9 +1107,9 @@ static bool check_mft_mirror(ntfs_volume
 						"transfer detected in mft "
 						"record %i.", i);
 mm_unmap_out:
-				ntfs_unmap_page(mirr_page);
+				put_kmapped_page(mirr_page);
 mft_unmap_out:
-				ntfs_unmap_page(mft_page);
+				put_kmapped_page(mft_page);
 				return false;
 			}
 		}
@@ -1143,8 +1143,8 @@ mft_unmap_out:
 		kmirr += vol->mft_record_size;
 	} while (++i < vol->mftmirr_size);
 	/* Release the last pages. */
-	ntfs_unmap_page(mft_page);
-	ntfs_unmap_page(mirr_page);
+	put_kmapped_page(mft_page);
+	put_kmapped_page(mirr_page);
 
 	/* Construct the mft mirror runlist by hand. */
 	rl2[0].vcn = 0;
@@ -1289,7 +1289,7 @@ static int check_windows_hibernation_sta
 		goto iput_out;
 	}
 	ni = NTFS_I(vi);
-	page = ntfs_map_page(vi->i_mapping, 0);
+	page = read_kmap_page(vi->i_mapping, 0);
 	if (IS_ERR(page)) {
 		ntfs_error(vol->sb, "Failed to read from hiberfil.sys.");
 		ret = PTR_ERR(page);
@@ -1319,7 +1319,7 @@ static int check_windows_hibernation_sta
 			"volume.");
 	ret = 0;
 unm_iput_out:
-	ntfs_unmap_page(page);
+	put_kmapped_page(page);
 iput_out:
 	iput(vi);
 	return ret;
@@ -1509,7 +1509,7 @@ not_enabled:
 		return false;
 	}
 	/* Read the USN_HEADER from $DATA/$Max. */
-	page = ntfs_map_page(vol->usnjrnl_max_ino->i_mapping, 0);
+	page = read_kmap_page(vol->usnjrnl_max_ino->i_mapping, 0);
 	if (IS_ERR(page)) {
 		ntfs_error(vol->sb, "Failed to read from $UsnJrnl/$DATA/$Max "
 				"attribute.");
@@ -1523,7 +1523,7 @@ not_enabled:
 				"maximum size (0x%llx).  $UsnJrnl is corrupt.",
 				(long long)sle64_to_cpu(uh->allocation_delta),
 				(long long)sle64_to_cpu(uh->maximum_size));
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 		return false;
 	}
 	/*
@@ -1534,7 +1534,7 @@ not_enabled:
 			i_size_read(vol->usnjrnl_j_ino))) {
 		if (likely(sle64_to_cpu(uh->lowest_valid_usn) ==
 				i_size_read(vol->usnjrnl_j_ino))) {
-			ntfs_unmap_page(page);
+			put_kmapped_page(page);
 			ntfs_debug("$UsnJrnl is enabled but nothing has been "
 					"logged since it was last stamped.  "
 					"Treating this as if the volume does "
@@ -1547,10 +1547,10 @@ not_enabled:
 				"is corrupt.",
 				(long long)sle64_to_cpu(uh->lowest_valid_usn),
 				i_size_read(vol->usnjrnl_j_ino));
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 		return false;
 	}
-	ntfs_unmap_page(page);
+	put_kmapped_page(page);
 	ntfs_debug("Done.");
 	return true;
 }
@@ -1592,12 +1592,12 @@ static bool load_and_init_attrdef(ntfs_v
 	while (index < max_index) {
 		/* Read the attrdef table and copy it into the linear buffer. */
 read_partial_attrdef_page:
-		page = ntfs_map_page(ino->i_mapping, index);
+		page = read_kmap_page(ino->i_mapping, index);
 		if (IS_ERR(page))
 			goto free_iput_failed;
 		memcpy((u8*)vol->attrdef + (index++ << PAGE_CACHE_SHIFT),
 				page_address(page), size);
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 	};
 	if (size == PAGE_CACHE_SIZE) {
 		size = i_size & ~PAGE_CACHE_MASK;
@@ -1661,12 +1661,12 @@ static bool load_and_init_upcase(ntfs_vo
 	while (index < max_index) {
 		/* Read the upcase table and copy it into the linear buffer. */
 read_partial_upcase_page:
-		page = ntfs_map_page(ino->i_mapping, index);
+		page = read_kmap_page(ino->i_mapping, index);
 		if (IS_ERR(page))
 			goto iput_upcase_failed;
 		memcpy((char*)vol->upcase + (index++ << PAGE_CACHE_SHIFT),
 				page_address(page), size);
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 	};
 	if (size == PAGE_CACHE_SIZE) {
 		size = i_size & ~PAGE_CACHE_MASK;
diff -urpN -X dontdiff linux-2.6.21-rc5-mm4/fs/ntfs/usnjrnl.c linux-2.6.21-rc5-mm4-test/fs/ntfs/usnjrnl.c
--- linux-2.6.21-rc5-mm4/fs/ntfs/usnjrnl.c	2006-11-29 13:57:37.000000000 -0800
+++ linux-2.6.21-rc5-mm4-test/fs/ntfs/usnjrnl.c	2007-04-06 01:59:19.000000000 -0700
@@ -52,7 +52,7 @@ bool ntfs_stamp_usnjrnl(ntfs_volume *vol
 		struct page *page;
 		USN_HEADER *uh;
 
-		page = ntfs_map_page(vol->usnjrnl_max_ino->i_mapping, 0);
+		page = read_kmap_page(vol->usnjrnl_max_ino->i_mapping, 0);
 		if (IS_ERR(page)) {
 			ntfs_error(vol->sb, "Failed to read from "
 					"$UsnJrnl/$DATA/$Max attribute.");
@@ -73,7 +73,7 @@ bool ntfs_stamp_usnjrnl(ntfs_volume *vol
 		uh->journal_id = stamp;
 		flush_dcache_page(page);
 		set_page_dirty(page);
-		ntfs_unmap_page(page);
+		put_kmapped_page(page);
 		/* Set the flag so we do not have to do it again on remount. */
 		NVolSetUsnJrnlStamped(vol);
 	}
