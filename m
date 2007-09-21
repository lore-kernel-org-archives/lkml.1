Return-Path: <linux-kernel-owner+w=401wt.eu-S1762711AbXIUUmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711AbXIUUmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbXIUUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:42:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34467 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbXIUUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:42:41 -0400
Date: Fri, 21 Sep 2007 21:42:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] LBS: fix unexported swapper_space
Message-ID: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If any loadable module uses the page_mapping() inline, we would need to
export swapper_space (again: it was exported once, but janitorially
unexported); but a filesystem sees only its own pages, so reiserfs can
use page->mapping directly without needing the page_mapping() inline.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc6-lbs/fs/reiserfs/stree.c	2007-09-11 20:01:08.000000000 +0100
+++ linux/fs/reiserfs/stree.c	2007-09-13 20:04:04.000000000 +0100
@@ -1440,7 +1440,7 @@ static void unmap_buffers(struct page *p
 
 	if (page) {
 		if (page_has_buffers(page)) {
-			tail_index = page_cache_offset(page_mapping(page), pos);
+			tail_index = page_cache_offset(page->mapping, pos);
 			cur_index = 0;
 			head = page_buffers(page);
 			bh = head;
@@ -1461,7 +1461,7 @@ static void unmap_buffers(struct page *p
 			} while (bh != head);
 			if (PAGE_SIZE == bh->b_size) {
 				cancel_dirty_page(page,
-					page_cache_size(page_mapping(page)));
+					page_cache_size(page->mapping));
 			}
 		}
 	}
