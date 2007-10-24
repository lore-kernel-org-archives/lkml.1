Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbXJXVjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbXJXVjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXJXVi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:38:58 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49404 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbXJXVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:38:56 -0400
Date: Wed, 24 Oct 2007 22:37:56 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, ezk@cs.sunysb.edu, ryan@finnie.org,
       mhalcrow@us.ibm.com, cjwatson@ubuntu.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: [PATCH+comment] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE
In-Reply-To: <20071024140836.a0098180.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710242233470.17796@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI>
 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
 <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
 <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0710242152020.13001@blonde.wat.veritas.com>
 <20071024140836.a0098180.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to provoke unionfs (not yet in mainline, though in mm
and some distros) to hit shmem_writepage's BUG_ON(page_mapped(page)).
I expect it's possible to provoke the 2.6.23 ecryptfs in the same way
(but the 2.6.24 ecryptfs no longer calls lower level's ->writepage).

This came to light with the recent find that AOP_WRITEPAGE_ACTIVATE
could leak from tmpfs via write_cache_pages and unionfs to userspace.
There's already a fix (e423003028183df54f039dfda8b58c49e78c89d7 -
writeback: don't propagate AOP_WRITEPAGE_ACTIVATE) in the tree for
that, and it's okay so far as it goes; but insufficient because it
doesn't address the underlying issue, that shmem_writepage expects
to be called only by vmscan (relying on backing_dev_info capabilities
to prevent the normal writeback path from ever approaching it).

That's an increasingly fragile assumption, and ramdisk_writepage
(the other source of AOP_WRITEPAGE_ACTIVATEs) is already careful
to check wbc->for_reclaim before returning it.  Make the same check
in shmem_writepage, thereby sidestepping the page_mapped BUG also.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Unionfs intends its own, third fix to these issues, checking
backing_dev_info capabilities as the normal writeback path does.
And I intend a fourth fix, getting rid of AOP_WRITEPAGE_ACTIVATE
entirely (mainly to put a stop to everybody asking what it means
and when it happens and how to handle it) - but that's a slightly
bigger patch, needing a little more testing, probably for 2.6.25.

I've CC'ed this to stable as you did for the write_cache_pages
fix: it's probably required for ecryptfs (but unionfs was much
easier to set up and test), and helpful to distros using unionfs
and checking stable for fixes.  Does this make the write_cache_pages
fix redundant?  Probably, but let's have both in for safety.

 mm/shmem.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- 2.6.24-rc1/mm/shmem.c	2007-10-24 07:16:04.000000000 +0100
+++ linux/mm/shmem.c	2007-10-24 22:31:09.000000000 +0100
@@ -915,6 +915,21 @@ static int shmem_writepage(struct page *
 	struct inode *inode;
 
 	BUG_ON(!PageLocked(page));
+	/*
+	 * shmem_backing_dev_info's capabilities prevent regular writeback or
+	 * sync from ever calling shmem_writepage; but a stacking filesystem
+	 * may use the ->writepage of its underlying filesystem, in which case
+	 * we want to do nothing when that underlying filesystem is tmpfs
+	 * (writing out to swap is useful as a response to memory pressure, but
+	 * of no use to stabilize the data) - just redirty the page, unlock it
+	 * and claim success in this case.  AOP_WRITEPAGE_ACTIVATE, and the
+	 * page_mapped check below, must be avoided unless we're in reclaim.
+	 */
+	if (!wbc->for_reclaim) {
+		set_page_dirty(page);
+		unlock_page(page);
+		return 0;
+	}
 	BUG_ON(page_mapped(page));
 
 	mapping = page->mapping;
