Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbXGTNSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbXGTNSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXGTNSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:18:23 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6178 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbXGTNSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:18:23 -0400
Date: Fri, 20 Jul 2007 15:18:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] splice: fix bad unlock_page() in error case
Message-ID: <20070720131812.GC11657@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If add_to_page_cache_lru() fails, the page will not be locked. But
splice jumps to an error path that does a page release and unlock,
causing a BUG() in unlock_page().

Fix this by adding one more label that just releases the page. This bug
was actually triggered on EL5 by gurudas pai <gurudas.pai@oracle.com>
using fio.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/splice.c b/fs/splice.c
index 099b831..4960085 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -628,7 +628,7 @@ find_page:
 		ret = add_to_page_cache_lru(page, mapping, index,
 					    GFP_KERNEL);
 		if (unlikely(ret))
-			goto out;
+			goto out_release;
 	}
 
 	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
@@ -684,8 +684,9 @@ find_page:
 	 */
 	mark_page_accessed(page);
 out:
-	page_cache_release(page);
 	unlock_page(page);
+out_release:
+	page_cache_release(page);
 out_ret:
 	return ret;
 }

-- 
Jens Axboe

