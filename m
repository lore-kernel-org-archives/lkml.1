Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYF2AYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYF2AYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 20:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYF2AYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 20:24:35 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34120 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYF2AYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 20:24:34 -0400
Date: Sun, 29 Jun 2008 01:24:18 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] splitlru: BDI_CAP_SWAP_BACKED
In-Reply-To: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
Message-ID: <Pine.LNX.4.64.0806290122330.21758@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The split-lru patches put file and swap-backed pages on different lrus.
shmem/tmpfs pages are awkward because they are swap-backed file pages.
Since it's difficult to change lru midstream, they are treated as swap-
backed throughout, with SetPageSwapBacked on allocation in shmem_getpage.

However, splice read (used by loop and sendfile) and readahead* allocate
pages first, add_to_page_cache_lru, and then call into the filesystem
through ->readpage.  Under memory pressure, the shmem pages arrive at
add_to_swap_cache and hit its BUG_ON(!PageSwapBacked(page)).

I've not yet found a better way to handle this than a "capability"
flag in shmem_backing_dev_info, tested by add_to_page_cache_lru.
And solely because it would look suspicious without it, set that
BDI_CAP_SWAP_BACKED in swap_backing_dev_info also.

* readahead on shmem/tmpfs?  I'd always thought ra_pages 0 prevented
that; but in fact readahead(2), fadvise(POSIX_FADV_WILLNEED) and
madvise(MADV_WILLNEED) all force_page_cache_readahead and get there.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Should follow mmotm's vmscan-split-lru-lists-into-anon-file-sets.patch

 include/linux/backing-dev.h |   13 +++++++++++++
 mm/filemap.c                |   13 ++++++++++++-
 mm/shmem.c                  |    2 +-
 mm/swap_state.c             |    2 +-
 4 files changed, 27 insertions(+), 3 deletions(-)

--- mmotm/include/linux/backing-dev.h	2008-05-03 21:55:10.000000000 +0100
+++ linux/include/linux/backing-dev.h	2008-06-27 17:02:45.000000000 +0100
@@ -175,6 +175,8 @@ int bdi_set_max_ratio(struct backing_dev
  * BDI_CAP_READ_MAP:       Can be mapped for reading
  * BDI_CAP_WRITE_MAP:      Can be mapped for writing
  * BDI_CAP_EXEC_MAP:       Can be mapped for execution
+ *
+ * BDI_CAP_SWAP_BACKED:    Count shmem/tmpfs objects as swap-backed.
  */
 #define BDI_CAP_NO_ACCT_DIRTY	0x00000001
 #define BDI_CAP_NO_WRITEBACK	0x00000002
@@ -184,6 +186,7 @@ int bdi_set_max_ratio(struct backing_dev
 #define BDI_CAP_WRITE_MAP	0x00000020
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
+#define BDI_CAP_SWAP_BACKED	0x00000100
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
@@ -248,6 +251,11 @@ static inline bool bdi_cap_account_write
 				      BDI_CAP_NO_WRITEBACK));
 }
 
+static inline bool bdi_cap_swap_backed(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
+}
+
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
 	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
@@ -258,4 +266,9 @@ static inline bool mapping_cap_account_d
 	return bdi_cap_account_dirty(mapping->backing_dev_info);
 }
 
+static inline bool mapping_cap_swap_backed(struct address_space *mapping)
+{
+	return bdi_cap_swap_backed(mapping->backing_dev_info);
+}
+
 #endif		/* _LINUX_BACKING_DEV_H */
--- mmotm/mm/filemap.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/filemap.c	2008-06-27 18:16:07.000000000 +0100
@@ -493,7 +493,18 @@ EXPORT_SYMBOL(add_to_page_cache);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t offset, gfp_t gfp_mask)
 {
-	int ret = add_to_page_cache(page, mapping, offset, gfp_mask);
+	int ret;
+
+	/*
+	 * Splice_read and readahead add shmem/tmpfs pages into the page cache
+	 * before shmem_readpage has a chance to mark them as SwapBacked: they
+	 * need to go on the active_anon lru below, and mem_cgroup_cache_charge
+	 * (called in add_to_page_cache) needs to know where they're going too.
+	 */
+	if (mapping_cap_swap_backed(mapping))
+		SetPageSwapBacked(page);
+
+	ret = add_to_page_cache(page, mapping, offset, gfp_mask);
 	if (ret == 0) {
 		if (page_is_file_cache(page))
 			lru_cache_add_file(page);
--- mmotm/mm/shmem.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/shmem.c	2008-06-27 17:25:41.000000000 +0100
@@ -201,7 +201,7 @@ static struct vm_operations_struct shmem
 
 static struct backing_dev_info shmem_backing_dev_info  __read_mostly = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
 	.unplug_io_fn	= default_unplug_io_fn,
 };
 
--- mmotm/mm/swap_state.c	2008-06-27 13:39:20.000000000 +0100
+++ linux/mm/swap_state.c	2008-06-27 17:26:49.000000000 +0100
@@ -33,7 +33,7 @@ static const struct address_space_operat
 };
 
 static struct backing_dev_info swap_backing_dev_info = {
-	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
 	.unplug_io_fn	= swap_unplug_io_fn,
 };
 
