Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXLRWDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXLRWDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXLRWDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:03:23 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54154 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbXLRWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:03:21 -0500
Date: Tue, 18 Dec 2007 22:02:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] tmpfs: allocate on read when stacked
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182201290.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmpfs is expected to limit the memory used (unless mounted with nr_blocks=0
or size=0).  But if a stacked filesystem such as unionfs gets pages from a
sparse tmpfs file by reading holes, and then writes to them, it can easily
exceed any such limit at present.

So suppress the SGP_READ "don't allocate page" ZERO_PAGE optimization when
reading for the kernel (a KERNEL_DS check, ugh, sorry about that).  Indeed,
pessimistically mark such pages as dirty, so they cannot get reclaimed and
unaccounted by mistake.  The venerable shmem_recalc_inode code (originally
to account for the reclaim of clean pages) suffices to get the accounting
right when swappages are dropped in favour of more uptodate filepages.

This also fixes the NULL shmem_swp_entry BUG or oops in shmem_writepage,
caused by unionfs writing to a very sparse tmpfs file: to minimize memory
allocation in swapout, tmpfs requires the swap vector be allocated upfront,
which wasn't always happening in this stacked case.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- tmpfs4/mm/shmem.c	2007-12-05 16:42:19.000000000 +0000
+++ tmpfs5/mm/shmem.c	2007-12-05 16:42:19.000000000 +0000
@@ -80,6 +80,7 @@
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
+	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
 	SGP_WRITE,	/* may exceed i_size, may allocate page */
 };
 
@@ -1333,6 +1334,8 @@ repeat:
 		clear_highpage(filepage);
 		flush_dcache_page(filepage);
 		SetPageUptodate(filepage);
+		if (sgp == SGP_DIRTY)
+			set_page_dirty(filepage);
 	}
 done:
 	*pagep = filepage;
@@ -1518,6 +1521,15 @@ static void do_shmem_file_read(struct fi
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index, offset;
+	enum sgp_type sgp = SGP_READ;
+
+	/*
+	 * Might this read be for a stacking filesystem?  Then when reading
+	 * holes of a sparse file, we actually need to allocate those pages,
+	 * and even mark them dirty, so it cannot exceed the max_blocks limit.
+	 */
+	if (segment_eq(get_fs(), KERNEL_DS))
+		sgp = SGP_DIRTY;
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
@@ -1536,7 +1548,7 @@ static void do_shmem_file_read(struct fi
 				break;
 		}
 
-		desc->error = shmem_getpage(inode, index, &page, SGP_READ, NULL);
+		desc->error = shmem_getpage(inode, index, &page, sgp, NULL);
 		if (desc->error) {
 			if (desc->error == -EINVAL)
 				desc->error = 0;
