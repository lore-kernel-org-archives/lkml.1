Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYKYVtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYKYVtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbYKYVq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:46:28 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35773 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbYKYVqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:46:25 -0500
Date: Tue, 25 Nov 2008 21:44:34 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Woodhouse <dwmw2@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Joern Engel <joern@logfs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Donjun Shin <djshin90@gmail.com>, Tejun Heo <teheo@suse.de>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] swapfile: swapon use discard (trim)
In-Reply-To: <Pine.LNX.4.64.0811252132580.17555@blonde.site>
Message-ID: <Pine.LNX.4.64.0811252140230.17555@blonde.site>
References: <Pine.LNX.4.64.0811252132580.17555@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding swap, all the old data on swap can be forgotten: sys_swapon()
discard all but the header page of the swap partition (or every extent
but the header of the swap file), to give a solidstate swap device the
opportunity to optimize its wear-levelling.

If that succeeds, note SWP_DISCARDABLE for later use, and report it
with a "D" at the right end of the kernel's "Adding ... swap" message.
Perhaps something should be shown in /proc/swaps (swapon -s), but we
have to be more cautious before making any addition to that format.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
swapfile.c cleanup patches 0-5 just went to linux-mm: patches 6-9
may be of wider interest, so I'm extending the Cc list for them.

 include/linux/swap.h |    1 +
 mm/swapfile.c        |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

--- swapfile5/include/linux/swap.h	2008-11-25 12:41:31.000000000 +0000
+++ swapfile6/include/linux/swap.h	2008-11-25 12:41:34.000000000 +0000
@@ -120,6 +120,7 @@ struct swap_extent {
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
+	SWP_DISCARDABLE = (1 << 2),	/* blkdev supports discard */
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
--- swapfile5/mm/swapfile.c	2008-11-25 12:41:31.000000000 +0000
+++ swapfile6/mm/swapfile.c	2008-11-25 12:41:34.000000000 +0000
@@ -84,6 +84,37 @@ void swap_unplug_io_fn(struct backing_de
 	up_read(&swap_unplug_sem);
 }
 
+/*
+ * swapon tell device that all the old swap contents can be discarded,
+ * to allow the swap device to optimize its wear-levelling.
+ */
+static int discard_swap(struct swap_info_struct *si)
+{
+	struct swap_extent *se;
+	int err = 0;
+
+	list_for_each_entry(se, &si->extent_list, list) {
+		sector_t start_block = se->start_block << (PAGE_SHIFT - 9);
+		pgoff_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
+
+		if (se->start_page == 0) {
+			/* Do not discard the swap header page! */
+			start_block += 1 << (PAGE_SHIFT - 9);
+			nr_blocks -= 1 << (PAGE_SHIFT - 9);
+			if (!nr_blocks)
+				continue;
+		}
+
+		err = blkdev_issue_discard(si->bdev, start_block,
+						nr_blocks, GFP_KERNEL);
+		if (err)
+			break;
+
+		cond_resched();
+	}
+	return err;		/* That will often be -EOPNOTSUPP */
+}
+
 #define SWAPFILE_CLUSTER	256
 #define LATENCY_LIMIT		256
 
@@ -1649,6 +1680,9 @@ asmlinkage long sys_swapon(const char __
 		goto bad_swap;
 	}
 
+	if (discard_swap(p) == 0)
+		p->flags |= SWP_DISCARDABLE;
+
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
 	if (swap_flags & SWAP_FLAG_PREFER)
@@ -1662,9 +1696,10 @@ asmlinkage long sys_swapon(const char __
 	total_swap_pages += nr_good_pages;
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
-			"Priority:%d extents:%d across:%lluk\n",
+			"Priority:%d extents:%d across:%lluk%s\n",
 		nr_good_pages<<(PAGE_SHIFT-10), name, p->prio,
-		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10));
+		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
+		(p->flags & SWP_DISCARDABLE) ? " D" : "");
 
 	/* insert swap space into swap_list: */
 	prev = -1;
