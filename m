Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYG1MhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYG1MhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYG1MhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:37:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:57315 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYG1MhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:37:04 -0400
Date: Mon, 28 Jul 2008 14:37:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com,
       xen-devel@lists.xensource.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net
Subject: [rfc][patch 3/3] xfs: use new vmap API
Message-ID: <20080728123703.GC13926@wotan.suse.de>
References: <20080728123438.GA13926@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728123438.GA13926@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement XFS's large buffer support with the new vmap APIs. See the vmap
rewrite patch for some numbers.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -265,7 +265,7 @@ xfs_buf_free(
 		uint		i;
 
 		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
-			vunmap(bp->b_addr - bp->b_offset);
+			vm_unmap_ram(bp->b_addr - bp->b_offset, bp->b_page_count);
 
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
@@ -387,8 +387,8 @@ _xfs_buf_map_pages(
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
 	} else if (flags & XBF_MAPPED) {
-		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
-					VM_MAP, PAGE_KERNEL);
+		bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
+					-1, PAGE_KERNEL);
 		if (unlikely(bp->b_addr == NULL))
 			return -ENOMEM;
 		bp->b_addr += bp->b_offset;
