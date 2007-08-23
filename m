Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbXHWHoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbXHWHoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbXHWHoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:44:10 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:51284 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbXHWHoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:44:09 -0400
Message-Id: <200708230742.AA00247@paprika.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 23 Aug 2007 16:42:59 +0900
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ecryptfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       moriai.satoshi@lab.ntt.co.jp
Subject: [PATCH] eCryptfs: fix possible fault in ecryptfs_sync_page
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This will avoid a possible fault in ecryptfs_sync_page().

In the function, eCryptfs calls sync_page() method of a lower 
filesystem without checking its existence.  However, there 
are many filesystems that don't have this method including
network filesystems such as NFS, AFS, and so forth.
They may fail when an eCryptfs page is waiting for lock.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/ecryptfs/mmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index e4ab7bc..fd3f94d 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -834,7 +834,8 @@ static void ecryptfs_sync_page(struct page *page)
 		ecryptfs_printk(KERN_DEBUG, "find_lock_page failed\n");
 		return;
 	}
-	lower_page->mapping->a_ops->sync_page(lower_page);
+	if (lower_page->mapping->a_ops->sync_page)
+		lower_page->mapping->a_ops->sync_page(lower_page);
 	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
 			lower_page->index);
 	unlock_page(lower_page);
