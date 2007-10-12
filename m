Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbXJLJK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbXJLJK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760032AbXJLJHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:07:43 -0400
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:54921 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241AbXJLJHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:33 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 05:07:32 EDT
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Fri, 12 Oct 2007 09:37:15 +0100 (BST)
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH] NTFS: Fix a mount time deadlock.
Message-ID: <Pine.LNX.4.64.0710120913120.30712@hermes-2.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please apply the below patch.

This NTFS update fixes the deadlock at mount time reported by 
several people over the years but it was only recently that someone who 
reported it actually replied to my response and helped me track it down (I 
have never been able to reproduce the deadlock).

So big thanks go to Mathias Kolehmainen for reporting the bug, providing 
debug output and testing the patches I sent him to get it working.

The fix was to stop calling ntfs_attr_set() at mount time as that causes 
balance_dirty_pages_ratelimited() to be called which on systems with 
little memory actually tries to go and balance the dirty pages which tries 
to take the s_umount semaphore but because we are still in fill_super() 
across which the VFS holds s_umount for writing this results in a 
deadlock.

We now do the dirty work by hand by submitting individual buffers.  This 
has the annoying "feature" that mounting can take a few seconds if the 
journal is large as we have clear it all.  One day someone should improve 
on this by deferring the journal clearing to a helper kernel thread so it 
can be done in the background but I don't have time for this at the moment 
and the current solution works fine so I am leaving it like this for now.

The patch also fixes a bunch of sparse warnings I noticed had appeared...

Please apply.  Thanks!

Diffstat:

 Documentation/filesystems/ntfs.txt |    4 -
 fs/ntfs/ChangeLog                  |   12 +++
 fs/ntfs/Makefile                   |    2 
 fs/ntfs/aops.c                     |   22 ++---
 fs/ntfs/attrib.c                   |    8 +-
 fs/ntfs/file.c                     |   36 ++++-----
 fs/ntfs/inode.c                    |    3 
 fs/ntfs/logfile.c                  |  143 
+++++++++++++++++++++++++++++++++----
 fs/ntfs/runlist.c                  |    4 -
 9 files changed, 181 insertions(+), 53 deletions(-)

The patch is below.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

---
NTFS: Fix a mount time deadlock.

Big thanks go to Mathias Kolehmainen for reporting the bug, providing 
debug output and testing the patches I sent him to get it working.

The fix was to stop calling ntfs_attr_set() at mount time as that causes 
balance_dirty_pages_ratelimited() to be called which on systems with 
little memory actually tries to go and balance the dirty pages which tries 
to take the s_umount semaphore but because we are still in fill_super() 
across which the VFS holds s_umount for writing this results in a 
deadlock.

We now do the dirty work by hand by submitting individual buffers.  This 
has the annoying "feature" that mounting can take a few seconds if the 
journal is large as we have clear it all.  One day someone should improve 
on this by deferring the journal clearing to a helper kernel thread so it 
can be done in the background but I don't have time for this at the moment 
and the current solution works fine so I am leaving it like this for now.

Signed-off-by: Anton Altaparmakov <aia21@cantab.net>

diff --git a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
index 8ee10ec..e79ee2d 100644
--- a/Documentation/filesystems/ntfs.txt
+++ b/Documentation/filesystems/ntfs.txt
@@ -407,7 +407,7 @@ raiddev /dev/md0
 	device		/dev/hda5
 	raid-disk	0
 	device		/dev/hdb1
-	raid-disl	1
+	raid-disk	1
 
 For linear raid, just change the raid-level above to "raid-level linear", for
 mirrors, change it to "raid-level 1", and for stripe sets with parity, change
@@ -457,6 +457,8 @@ ChangeLog
 
 Note, a technical ChangeLog aimed at kernel hackers is in fs/ntfs/ChangeLog.
 
+2.1.29:
+	- Fix a deadlock when mounting read-write.
 2.1.28:
 	- Fix a deadlock.
 2.1.27:
diff --git a/fs/ntfs/ChangeLog b/fs/ntfs/ChangeLog
index af4ef80..345798e 100644
--- a/fs/ntfs/ChangeLog
+++ b/fs/ntfs/ChangeLog
@@ -17,6 +17,18 @@ ToDo/Notes:
 	  happen is unclear however so it is worth waiting until someone hits
 	  the problem.
 
+2.1.29 - Fix a deadlock at mount time.
+
+	- During mount the VFS holds s_umount lock on the superblock.  So when
+	  we try to empty the journal $LogFile contents by calling
+	  ntfs_attr_set() when the machine does not have much memory and the
+	  journal is large ntfs_attr_set() results in the VM trying to balance
+	  dirty pages which in turn tries to that the s_umount lock and thus we
+	  get a deadlock.  The solution is to not use ntfs_attr_set() and
+	  instead do the zeroing by hand at the block level rather than page
+	  cache level.
+	- Fix sparse warnings.
+
 2.1.28 - Fix a deadlock.
 
 	- Fix deadlock in fs/ntfs/inode.c::ntfs_put_inode().  Thanks to Sergey
diff --git a/fs/ntfs/Makefile b/fs/ntfs/Makefile
index 8255083..58b6be9 100644
--- a/fs/ntfs/Makefile
+++ b/fs/ntfs/Makefile
@@ -6,7 +6,7 @@ ntfs-objs := aops.o attrib.o collate.o compress.o debug.o dir.o file.o \
 	     index.o inode.o mft.o mst.o namei.o runlist.o super.o sysctl.o \
 	     unistr.o upcase.o
 
-EXTRA_CFLAGS = -DNTFS_VERSION=\"2.1.28\"
+EXTRA_CFLAGS = -DNTFS_VERSION=\"2.1.29\"
 
 ifeq ($(CONFIG_NTFS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 6e5c253..cfdc790 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -2,7 +2,7 @@
  * aops.c - NTFS kernel address space operations and page cache handling.
  *	    Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2006 Anton Altaparmakov
+ * Copyright (c) 2001-2007 Anton Altaparmakov
  * Copyright (c) 2002 Richard Russon
  *
  * This program/include file is free software; you can redistribute it and/or
@@ -396,7 +396,7 @@ static int ntfs_readpage(struct file *file, struct page *page)
 	loff_t i_size;
 	struct inode *vi;
 	ntfs_inode *ni, *base_ni;
-	u8 *kaddr;
+	u8 *addr;
 	ntfs_attr_search_ctx *ctx;
 	MFT_RECORD *mrec;
 	unsigned long flags;
@@ -491,15 +491,15 @@ retry_readpage:
 		/* Race with shrinking truncate. */
 		attr_len = i_size;
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic(page, KM_USER0);
 	/* Copy the data to the page. */
-	memcpy(kaddr, (u8*)ctx->attr +
+	memcpy(addr, (u8*)ctx->attr +
 			le16_to_cpu(ctx->attr->data.resident.value_offset),
 			attr_len);
 	/* Zero the remainder of the page. */
-	memset(kaddr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
+	memset(addr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(addr, KM_USER0);
 put_unm_err_out:
 	ntfs_attr_put_search_ctx(ctx);
 unm_err_out:
@@ -1344,7 +1344,7 @@ static int ntfs_writepage(struct page *page, struct writeback_control *wbc)
 	loff_t i_size;
 	struct inode *vi = page->mapping->host;
 	ntfs_inode *base_ni = NULL, *ni = NTFS_I(vi);
-	char *kaddr;
+	char *addr;
 	ntfs_attr_search_ctx *ctx = NULL;
 	MFT_RECORD *m = NULL;
 	u32 attr_len;
@@ -1484,14 +1484,14 @@ retry_writepage:
 		/* Shrinking cannot fail. */
 		BUG_ON(err);
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic(page, KM_USER0);
 	/* Copy the data from the page to the mft record. */
 	memcpy((u8*)ctx->attr +
 			le16_to_cpu(ctx->attr->data.resident.value_offset),
-			kaddr, attr_len);
+			addr, attr_len);
 	/* Zero out of bounds area in the page cache page. */
-	memset(kaddr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
-	kunmap_atomic(kaddr, KM_USER0);
+	memset(addr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
+	kunmap_atomic(addr, KM_USER0);
 	flush_dcache_page(page);
 	flush_dcache_mft_record_page(ctx->ntfs_ino);
 	/* We are done with the page. */
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 1c08fef..92dabdc 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1,7 +1,7 @@
 /**
  * attrib.c - NTFS attribute operations.  Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2006 Anton Altaparmakov
+ * Copyright (c) 2001-2007 Anton Altaparmakov
  * Copyright (c) 2002 Richard Russon
  *
  * This program/include file is free software; you can redistribute it and/or
@@ -2500,7 +2500,7 @@ int ntfs_attr_set(ntfs_inode *ni, const s64 ofs, const s64 cnt, const u8 val)
 	struct page *page;
 	u8 *kaddr;
 	pgoff_t idx, end;
-	unsigned int start_ofs, end_ofs, size;
+	unsigned start_ofs, end_ofs, size;
 
 	ntfs_debug("Entering for ofs 0x%llx, cnt 0x%llx, val 0x%hx.",
 			(long long)ofs, (long long)cnt, val);
@@ -2548,6 +2548,8 @@ int ntfs_attr_set(ntfs_inode *ni, const s64 ofs, const s64 cnt, const u8 val)
 		kunmap_atomic(kaddr, KM_USER0);
 		set_page_dirty(page);
 		page_cache_release(page);
+		balance_dirty_pages_ratelimited(mapping);
+		cond_resched();
 		if (idx == end)
 			goto done;
 		idx++;
@@ -2604,6 +2606,8 @@ int ntfs_attr_set(ntfs_inode *ni, const s64 ofs, const s64 cnt, const u8 val)
 		kunmap_atomic(kaddr, KM_USER0);
 		set_page_dirty(page);
 		page_cache_release(page);
+		balance_dirty_pages_ratelimited(mapping);
+		cond_resched();
 	}
 done:
 	ntfs_debug("Done.");
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index ffcc504..c814204 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1,7 +1,7 @@
 /*
  * file.c - NTFS kernel file operations.  Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2006 Anton Altaparmakov
+ * Copyright (c) 2001-2007 Anton Altaparmakov
  *
  * This program/include file is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as published
@@ -26,7 +26,6 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
-#include <linux/sched.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -362,7 +361,7 @@ static inline void ntfs_fault_in_pages_readable(const char __user *uaddr,
 	volatile char c;
 
 	/* Set @end to the first byte outside the last page we care about. */
-	end = (const char __user*)PAGE_ALIGN((ptrdiff_t __user)uaddr + bytes);
+	end = (const char __user*)PAGE_ALIGN((unsigned long)uaddr + bytes);
 
 	while (!__get_user(c, uaddr) && (uaddr += PAGE_SIZE, uaddr < end))
 		;
@@ -532,7 +531,8 @@ static int ntfs_prepare_pages_for_non_resident_write(struct page **pages,
 	blocksize_bits = vol->sb->s_blocksize_bits;
 	u = 0;
 	do {
-		struct page *page = pages[u];
+		page = pages[u];
+		BUG_ON(!page);
 		/*
 		 * create_empty_buffers() will create uptodate/dirty buffers if
 		 * the page is uptodate/dirty.
@@ -1291,7 +1291,7 @@ static inline size_t ntfs_copy_from_user(struct page **pages,
 		size_t bytes)
 {
 	struct page **last_page = pages + nr_pages;
-	char *kaddr;
+	char *addr;
 	size_t total = 0;
 	unsigned len;
 	int left;
@@ -1300,13 +1300,13 @@ static inline size_t ntfs_copy_from_user(struct page **pages,
 		len = PAGE_CACHE_SIZE - ofs;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		left = __copy_from_user_inatomic(kaddr + ofs, buf, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		addr = kmap_atomic(*pages, KM_USER0);
+		left = __copy_from_user_inatomic(addr + ofs, buf, len);
+		kunmap_atomic(addr, KM_USER0);
 		if (unlikely(left)) {
 			/* Do it the slow way. */
-			kaddr = kmap(*pages);
-			left = __copy_from_user(kaddr + ofs, buf, len);
+			addr = kmap(*pages);
+			left = __copy_from_user(addr + ofs, buf, len);
 			kunmap(*pages);
 			if (unlikely(left))
 				goto err_out;
@@ -1408,26 +1408,26 @@ static inline size_t ntfs_copy_from_user_iovec(struct page **pages,
 		size_t *iov_ofs, size_t bytes)
 {
 	struct page **last_page = pages + nr_pages;
-	char *kaddr;
+	char *addr;
 	size_t copied, len, total = 0;
 
 	do {
 		len = PAGE_CACHE_SIZE - ofs;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		copied = __ntfs_copy_from_user_iovec_inatomic(kaddr + ofs,
+		addr = kmap_atomic(*pages, KM_USER0);
+		copied = __ntfs_copy_from_user_iovec_inatomic(addr + ofs,
 				*iov, *iov_ofs, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(addr, KM_USER0);
 		if (unlikely(copied != len)) {
 			/* Do it the slow way. */
-			kaddr = kmap(*pages);
-			copied = __ntfs_copy_from_user_iovec_inatomic(kaddr + ofs,
+			addr = kmap(*pages);
+			copied = __ntfs_copy_from_user_iovec_inatomic(addr + ofs,
 					*iov, *iov_ofs, len);
 			/*
 			 * Zero the rest of the target like __copy_from_user().
 			 */
-			memset(kaddr + ofs + copied, 0, len - copied);
+			memset(addr + ofs + copied, 0, len - copied);
 			kunmap(*pages);
 			if (unlikely(copied != len))
 				goto err_out;
@@ -1735,8 +1735,6 @@ static int ntfs_commit_pages_after_write(struct page **pages,
 	read_unlock_irqrestore(&ni->size_lock, flags);
 	BUG_ON(initialized_size != i_size);
 	if (end > initialized_size) {
-		unsigned long flags;
-
 		write_lock_irqsave(&ni->size_lock, flags);
 		ni->initialized_size = end;
 		i_size_write(vi, end);
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index b532a73..e9da092 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -34,7 +34,6 @@
 #include "dir.h"
 #include "debug.h"
 #include "inode.h"
-#include "attrib.h"
 #include "lcnalloc.h"
 #include "malloc.h"
 #include "mft.h"
@@ -2500,8 +2499,6 @@ retry_truncate:
 	/* Resize the attribute record to best fit the new attribute size. */
 	if (new_size < vol->mft_record_size &&
 			!ntfs_resident_attr_value_resize(m, a, new_size)) {
-		unsigned long flags;
-
 		/* The resize succeeded! */
 		flush_dcache_mft_record_page(ctx->ntfs_ino);
 		mark_mft_record_dirty(ctx->ntfs_ino);
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index acfed32..d7932e9 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -1,7 +1,7 @@
 /*
  * logfile.c - NTFS kernel journal handling. Part of the Linux-NTFS project.
  *
- * Copyright (c) 2002-2005 Anton Altaparmakov
+ * Copyright (c) 2002-2007 Anton Altaparmakov
  *
  * This program/include file is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as published
@@ -724,24 +724,139 @@ bool ntfs_is_logfile_clean(struct inode *log_vi, const RESTART_PAGE_HEADER *rp)
  */
 bool ntfs_empty_logfile(struct inode *log_vi)
 {
-	ntfs_volume *vol = NTFS_SB(log_vi->i_sb);
+	VCN vcn, end_vcn;
+	ntfs_inode *log_ni = NTFS_I(log_vi);
+	ntfs_volume *vol = log_ni->vol;
+	struct super_block *sb = vol->sb;
+	runlist_element *rl;
+	unsigned long flags;
+	unsigned block_size, block_size_bits;
+	int err;
+	bool should_wait = true;
 
 	ntfs_debug("Entering.");
-	if (!NVolLogFileEmpty(vol)) {
-		int err;
-		
-		err = ntfs_attr_set(NTFS_I(log_vi), 0, i_size_read(log_vi),
-				0xff);
-		if (unlikely(err)) {
-			ntfs_error(vol->sb, "Failed to fill $LogFile with "
-					"0xff bytes (error code %i).", err);
-			return false;
-		}
-		/* Set the flag so we do not have to do it again on remount. */
-		NVolSetLogFileEmpty(vol);
+	if (NVolLogFileEmpty(vol)) {
+		ntfs_debug("Done.");
+		return true;
 	}
+	/*
+	 * We cannot use ntfs_attr_set() because we may be still in the middle
+	 * of a mount operation.  Thus we do the emptying by hand by first
+	 * zapping the page cache pages for the $LogFile/$DATA attribute and
+	 * then emptying each of the buffers in each of the clusters specified
+	 * by the runlist by hand.
+	 */
+	block_size = sb->s_blocksize;
+	block_size_bits = sb->s_blocksize_bits;
+	vcn = 0;
+	read_lock_irqsave(&log_ni->size_lock, flags);
+	end_vcn = (log_ni->initialized_size + vol->cluster_size_mask) >>
+			vol->cluster_size_bits;
+	read_unlock_irqrestore(&log_ni->size_lock, flags);
+	truncate_inode_pages(log_vi->i_mapping, 0);
+	down_write(&log_ni->runlist.lock);
+	rl = log_ni->runlist.rl;
+	if (unlikely(!rl || vcn < rl->vcn || !rl->length)) {
+map_vcn:
+		err = ntfs_map_runlist_nolock(log_ni, vcn, NULL);
+		if (err) {
+			ntfs_error(sb, "Failed to map runlist fragment (error "
+					"%d).", -err);
+			goto err;
+		}
+		rl = log_ni->runlist.rl;
+		BUG_ON(!rl || vcn < rl->vcn || !rl->length);
+	}
+	/* Seek to the runlist element containing @vcn. */
+	while (rl->length && vcn >= rl[1].vcn)
+		rl++;
+	do {
+		LCN lcn;
+		sector_t block, end_block;
+		s64 len;
+
+		/*
+		 * If this run is not mapped map it now and start again as the
+		 * runlist will have been updated.
+		 */
+		lcn = rl->lcn;
+		if (unlikely(lcn == LCN_RL_NOT_MAPPED)) {
+			vcn = rl->vcn;
+			goto map_vcn;
+		}
+		/* If this run is not valid abort with an error. */
+		if (unlikely(!rl->length || lcn < LCN_HOLE))
+			goto rl_err;
+		/* Skip holes. */
+		if (lcn == LCN_HOLE)
+			continue;
+		block = lcn << vol->cluster_size_bits >> block_size_bits;
+		len = rl->length;
+		if (rl[1].vcn > end_vcn)
+			len = end_vcn - rl->vcn;
+		end_block = (lcn + len) << vol->cluster_size_bits >>
+				block_size_bits;
+		/* Iterate over the blocks in the run and empty them. */
+		do {
+			struct buffer_head *bh;
+
+			/* Obtain the buffer, possibly not uptodate. */
+			bh = sb_getblk(sb, block);
+			BUG_ON(!bh);
+			/* Setup buffer i/o submission. */
+			lock_buffer(bh);
+			bh->b_end_io = end_buffer_write_sync;
+			get_bh(bh);
+			/* Set the entire contents of the buffer to 0xff. */
+			memset(bh->b_data, -1, block_size);
+			if (!buffer_uptodate(bh))
+				set_buffer_uptodate(bh);
+			if (buffer_dirty(bh))
+				clear_buffer_dirty(bh);
+			/*
+			 * Submit the buffer and wait for i/o to complete but
+			 * only for the first buffer so we do not miss really
+			 * serious i/o errors.  Once the first buffer has
+			 * completed ignore errors afterwards as we can assume
+			 * that if one buffer worked all of them will work.
+			 */
+			submit_bh(WRITE, bh);
+			if (should_wait) {
+				should_wait = false;
+				wait_on_buffer(bh);
+				if (unlikely(!buffer_uptodate(bh)))
+					goto io_err;
+			}
+			brelse(bh);
+		} while (++block < end_block);
+	} while ((++rl)->vcn < end_vcn);
+	up_write(&log_ni->runlist.lock);
+	/*
+	 * Zap the pages again just in case any got instantiated whilst we were
+	 * emptying the blocks by hand.  FIXME: We may not have completed
+	 * writing to all the buffer heads yet so this may happen too early.
+	 * We really should use a kernel thread to do the emptying
+	 * asynchronously and then we can also set the volume dirty and output
+	 * an error message if emptying should fail.
+	 */
+	truncate_inode_pages(log_vi->i_mapping, 0);
+	/* Set the flag so we do not have to do it again on remount. */
+	NVolSetLogFileEmpty(vol);
 	ntfs_debug("Done.");
 	return true;
+io_err:
+	ntfs_error(sb, "Failed to write buffer.  Unmount and run chkdsk.");
+	goto dirty_err;
+rl_err:
+	ntfs_error(sb, "Runlist is corrupt.  Unmount and run chkdsk.");
+dirty_err:
+	NVolSetErrors(vol);
+	err = -EIO;
+err:
+	up_write(&log_ni->runlist.lock);
+	ntfs_error(sb, "Failed to fill $LogFile with 0xff bytes (error %d).",
+			-err);
+	return false;
 }
 
 #endif /* NTFS_RW */
diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index 9afd72c..56a9a6d 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -1,7 +1,7 @@
 /**
  * runlist.c - NTFS runlist handling code.  Part of the Linux-NTFS project.
  *
- * Copyright (c) 2001-2005 Anton Altaparmakov
+ * Copyright (c) 2001-2007 Anton Altaparmakov
  * Copyright (c) 2002-2005 Richard Russon
  *
  * This program/include file is free software; you can redistribute it and/or
@@ -1714,7 +1714,7 @@ extend_hole:
 					sizeof(*rl));
 		/* Adjust the beginning of the tail if necessary. */
 		if (end > rl->vcn) {
-			s64 delta = end - rl->vcn;
+			delta = end - rl->vcn;
 			rl->vcn = end;
 			rl->length -= delta;
 			/* Only adjust the lcn if it is real. */
