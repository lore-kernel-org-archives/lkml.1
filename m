Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYCUGYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYCUGYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYCUGTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:19:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49205 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753547AbYCUGS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:56 -0400
Message-Id: <20080321061727.269764652@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:16 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [13/14] vcompound: Use vcompound for swap_map
Content-Disposition: inline; filename=fixswapon
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use virtual compound pages for the large swap maps. This only works for
swap maps that are smaller than a MAX_ORDER block though. If the swap map
is larger then there is no way around the use of vmalloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.25-rc5-mm1/mm/swapfile.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/mm/swapfile.c	2008-03-20 20:32:12.793950570 -0700
+++ linux-2.6.25-rc5-mm1/mm/swapfile.c	2008-03-20 20:37:43.367821147 -0700
@@ -1312,7 +1312,7 @@ asmlinkage long sys_swapoff(const char _
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 	mutex_unlock(&swapon_mutex);
-	vfree(swap_map);
+	__free_vcompound(swap_map);
 	inode = mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		struct block_device *bdev = I_BDEV(inode);
@@ -1636,13 +1636,13 @@ asmlinkage long sys_swapon(const char __
 			goto bad_swap;
 
 		/* OK, set up the swap map and apply the bad block list */
-		if (!(p->swap_map = vmalloc(maxpages * sizeof(short)))) {
+		if (!(p->swap_map = __alloc_vcompound(GFP_KERNEL | __GFP_ZERO,
+					get_order(maxpages * sizeof(short))))) {
 			error = -ENOMEM;
 			goto bad_swap;
 		}
 
 		error = 0;
-		memset(p->swap_map, 0, maxpages * sizeof(short));
 		for (i = 0; i < swap_header->info.nr_badpages; i++) {
 			int page_nr = swap_header->info.badpages[i];
 			if (page_nr <= 0 || page_nr >= swap_header->info.last_page)
@@ -1718,7 +1718,7 @@ bad_swap_2:
 	if (!(swap_flags & SWAP_FLAG_PREFER))
 		++least_priority;
 	spin_unlock(&swap_lock);
-	vfree(swap_map);
+	__free_vcompound(swap_map);
 	if (swap_file)
 		filp_close(swap_file, NULL);
 out:

-- 
