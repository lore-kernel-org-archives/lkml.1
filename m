Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344Ab0AUEY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0AUEY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294Ab0AUEXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:23:12 -0500
Received: from kroah.org ([198.145.64.141]:60218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab0AUEXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:36 2010
Message-Id: <20100121041836.416215024@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nick Piggin <npiggin@suse.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [30/30] vfs: Fix vmtruncate() regression
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit cedabed49b39b4319bccc059a63344b6232b619c upstream.

If __block_prepare_write() was failed in block_write_begin(), the
allocated blocks can be outside of ->i_size.

But new truncate_pagecache() in vmtuncate() does nothing if new < old.
It means the above usage is not working anymore.

So, this patch fixes it by removing "new < old" check. It would need
more cleanup/change. But, now -rc and truncate working is in progress,
so, this tried to fix it minimum change.

Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/truncate.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -516,22 +516,20 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  */
 void truncate_pagecache(struct inode *inode, loff_t old, loff_t new)
 {
-	if (new < old) {
-		struct address_space *mapping = inode->i_mapping;
+	struct address_space *mapping = inode->i_mapping;
 
-		/*
-		 * unmap_mapping_range is called twice, first simply for
-		 * efficiency so that truncate_inode_pages does fewer
-		 * single-page unmaps.  However after this first call, and
-		 * before truncate_inode_pages finishes, it is possible for
-		 * private pages to be COWed, which remain after
-		 * truncate_inode_pages finishes, hence the second
-		 * unmap_mapping_range call must be made for correctness.
-		 */
-		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
-		truncate_inode_pages(mapping, new);
-		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
-	}
+	/*
+	 * unmap_mapping_range is called twice, first simply for
+	 * efficiency so that truncate_inode_pages does fewer
+	 * single-page unmaps.  However after this first call, and
+	 * before truncate_inode_pages finishes, it is possible for
+	 * private pages to be COWed, which remain after
+	 * truncate_inode_pages finishes, hence the second
+	 * unmap_mapping_range call must be made for correctness.
+	 */
+	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(mapping, new);
+	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
 }
 EXPORT_SYMBOL(truncate_pagecache);
 


