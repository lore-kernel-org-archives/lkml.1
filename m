Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbXKST2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbXKST2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXKST23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:28:29 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34501 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXKST22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:28:28 -0500
Date: Mon, 19 Nov 2007 19:04:57 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Erez Zadok <ezk@cs.sunysb.edu>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 04/26] writeback: dont propagate AOP_WRITEPAGE_ACTIVATE
In-Reply-To: <20071119181825.GE15425@kroah.com>
Message-ID: <Pine.LNX.4.64.0711191852070.14717@blonde.wat.veritas.com>
References: <20071119181438.617190424@mini.kroah.org> <20071119181825.GE15425@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, Greg Kroah-Hartman wrote:
> 
> 2.6.22-stable review patch.  If anyone has any objections, please let us
> know.
> 
> ------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> patch e423003028183df54f039dfda8b58c49e78c89d7 in mainline.
> 
> This is a writeback-internal marker but we're propagating it all the way back
> to userspace!.
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

It's fine by me that this should go into 2.6.22-stable, but then please
also put in this related patch from 2.6.23-stable: it's arguable whether
either are strictly needed (they were originally provoked by unionfs, in
Ubuntu but not mainline), but more helpful to include than exclude them.

Thanks,
Hugh


Subject: [patch 12/13] fix tmpfs BUG and AOP_WRITEPAGE_ACTIVATE

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

patch 487e9bf25cbae11b131d6a14bdbb3a6a77380837 in mainline.

It's possible to provoke unionfs (not yet in mainline, though in mm and
some distros) to hit shmem_writepage's BUG_ON(page_mapped(page)).  I expect
it's possible to provoke the 2.6.23 ecryptfs in the same way (but the
2.6.24 ecryptfs no longer calls lower level's ->writepage).

This came to light with the recent find that AOP_WRITEPAGE_ACTIVATE could
leak from tmpfs via write_cache_pages and unionfs to userspace.  There's
already a fix (e423003028183df54f039dfda8b58c49e78c89d7 - writeback: don't
propagate AOP_WRITEPAGE_ACTIVATE) in the tree for that, and it's okay so
far as it goes; but insufficient because it doesn't address the underlying
issue, that shmem_writepage expects to be called only by vmscan (relying on
backing_dev_info capabilities to prevent the normal writeback path from
ever approaching it).

That's an increasingly fragile assumption, and ramdisk_writepage (the other
source of AOP_WRITEPAGE_ACTIVATEs) is already careful to check
wbc->for_reclaim before returning it.  Make the same check in
shmem_writepage, thereby sidestepping the page_mapped BUG also.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -916,6 +916,21 @@ static int shmem_writepage(struct page *
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
