Return-Path: <linux-kernel-owner+w=401wt.eu-S1161112AbXBMHnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161112AbXBMHnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161108AbXBMHnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:43:39 -0500
Received: from adsl-207-214-87-82.dsl.snfc21.pacbell.net ([207.214.87.82]:41476
	"EHLO heimdal.trondhjem.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161112AbXBMHni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:43:38 -0500
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 2/2] VM: invalidate_inode_pages2_range() shouldn't fail on page dirty...
Date: Mon, 12 Feb 2007 23:43:38 -0800
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <20070213074338.24191.28711.stgit@heimdal.trondhjem.org>
In-Reply-To: <20070213074335.24191.51525.stgit@heimdal.trondhjem.org>
References: <20070213074335.24191.51525.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

invalidate_inode_pages2() should not try to fix races between direct_IO and
mmap(). It should only be trying to clear out pages that were dirty before
the direct_IO write (see generic_file_direct_IO()).
Skipping dirty pages should therefore not result in an error.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 mm/truncate.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 0f4b6d1..c3ff820 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -318,6 +318,8 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * invalidation guarantees, and cannot afford to leave pages behind because
  * shrink_list() has a temp ref on them, or because they're transiently sitting
  * in the lru_cache_add() pagevecs.
+ * Note: this function just skips pages that are dirty without flagging
+ * an error.
  */
 static int
 invalidate_complete_page2(struct address_space *mapping, struct page *page)
@@ -330,7 +332,7 @@ invalidate_complete_page2(struct address
 
 	write_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))
-		goto failed;
+		goto dirty;
 
 	BUG_ON(PagePrivate(page));
 	__remove_from_page_cache(page);
@@ -338,9 +340,9 @@ invalidate_complete_page2(struct address
 	ClearPageUptodate(page);
 	page_cache_release(page);	/* pagecache ref */
 	return 1;
-failed:
+dirty:
 	write_unlock_irq(&mapping->tree_lock);
-	return 0;
+	return 1;
 }
 
 static int do_launder_page(struct address_space *mapping, struct page *page)
