Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbYDCWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbYDCWek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbYDCWe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 18:34:29 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45552 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbYDCWe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 18:34:28 -0400
Date: Thu, 3 Apr 2008 23:35:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] splice: use mapping_gfp_mask
Message-ID: <Pine.LNX.4.64.0804032331190.27180@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop block driver is careful to mask __GFP_IO|__GFP_FS out of its
mapping_gfp_mask, to avoid hangs under memory pressure.  But nowadays
it uses splice, usually going through __generic_file_splice_read.  That
must use mapping_gfp_mask instead of GFP_KERNEL to avoid those hangs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Ought to go into 2.6.25.  For 2.6.23 and 2.6.24 stable?  Well, I've
not actually seen this hang on any of these, though presumably it's
lurking there.  Where I did see it, and test the fix, was 2.6.25-rc5-mm1:
whose SLUB had a disturbing predilection (since corrected) for order-4
allocations, even when allocating radix tree nodes.

 fs/splice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.25-rc8/fs/splice.c	2008-03-05 10:47:40.000000000 +0000
+++ linux/fs/splice.c	2008-04-01 22:28:41.000000000 +0100
@@ -320,7 +320,7 @@ __generic_file_splice_read(struct file *
 				break;
 
 			error = add_to_page_cache_lru(page, mapping, index,
-					      GFP_KERNEL);
+						mapping_gfp_mask(mapping));
 			if (unlikely(error)) {
 				page_cache_release(page);
 				if (error == -EEXIST)
