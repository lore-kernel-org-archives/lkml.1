Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573Ab0AKSkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0AKSkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432Ab0AKSkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:40:45 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:36031 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab0AKSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:40:45 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: Fix vmtruncate() regression
Date: Tue, 12 Jan 2010 03:40:42 +0900
Message-ID: <876378jxhx.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you review this one?



If __block_prepare_write() was failed in block_write_begin(), the
allocated blocks can be outside of ->i_size.

But new truncate_pagecache() in vmtuncate() does nothing if new < old.
It means the above usage is not working anymore.

So, this patch fixes it by removing "new < old" check. It would need
more cleanup/change. But, now -rc and truncate working is in progress,
so, this tried to fix it minimum change.

Cc: stable@kernel.org
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 mm/truncate.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN mm/truncate.c~truncate_pagecache-fix mm/truncate.c
--- linux-2.6/mm/truncate.c~truncate_pagecache-fix	2010-01-12 02:41:27.000000000 +0900
+++ linux-2.6-hirofumi/mm/truncate.c	2010-01-12 02:42:53.000000000 +0900
@@ -522,22 +522,20 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
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
 
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
