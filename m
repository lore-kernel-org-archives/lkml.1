Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381Ab0AMMOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0AMMOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192Ab0AMMOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:14:15 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:33712 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0AMMOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:14:15 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vfs: Fix vmtruncate() regression
References: <876378jxhx.fsf@devron.myhome.or.jp> <20100113060734.GC3901@nick>
	<87r5pucin4.fsf@devron.myhome.or.jp>
Date: Wed, 13 Jan 2010 21:14:09 +0900
In-Reply-To: <87r5pucin4.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Wed, 13 Jan 2010 21:07:59 +0900")
Message-ID: <877hrmcicu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If __block_prepare_write() was failed in block_write_begin(), the
allocated blocks can be outside of ->i_size.

But new truncate_pagecache() in vmtuncate() does nothing if new < old.
It means the above usage is not working anymore.

So, this patch fixes it by removing "new < old" check. It would need
more cleanup/change. But, now -rc and truncate working is in progress,
so, this tried to fix it minimum change.

Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 mm/truncate.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN mm/truncate.c~truncate_pagecache-fix mm/truncate.c
--- linux-2.6/mm/truncate.c~truncate_pagecache-fix	2010-01-12 05:43:06.000000000 +0900
+++ linux-2.6-hirofumi/mm/truncate.c	2010-01-12 05:43:06.000000000 +0900
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
