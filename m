Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbZHMULG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbZHMULG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbZHMULE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:11:04 -0400
Received: from kroah.org ([198.145.64.141]:41730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbZHMT7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:29 2009
Message-Id: <20090813195128.860303934@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [patch 29/74] nilfs2: fix oops due to inconsistent state in page with discrete b-tree nodes
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-fix-oops-due-to-inconsistent-state-in-page-with-discrete-b-tree-nodes.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit a97778457f22181e8c38c4cd7d7e528378738a98 upstream.

Andrea Gelmini gave me a report that a kernel oops hit on a nilfs
filesystem with a 1KB block size when doing rsync.

This turned out to be caused by an inconsistency of dirty state
between a page and its buffers storing b-tree node blocks.

If the page had multiple buffers split over multiple logs, and if the
logs were written at a time, a dirty flag remained in the page even
every dirty flag in the buffers was cleared.

This will fix the failure by dropping the dirty flag properly for
pages with the discrete multiple b-tree nodes.

Reported-by: Andrea Gelmini <andrea.gelmini@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Andrea Gelmini <andrea.gelmini@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/segment.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1876,12 +1876,26 @@ static void nilfs_end_page_io(struct pag
 	if (!page)
 		return;
 
-	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page))
+	if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {
 		/*
 		 * For b-tree node pages, this function may be called twice
 		 * or more because they might be split in a segment.
 		 */
+		if (PageDirty(page)) {
+			/*
+			 * For pages holding split b-tree node buffers, dirty
+			 * flag on the buffers may be cleared discretely.
+			 * In that case, the page is once redirtied for
+			 * remaining buffers, and it must be cancelled if
+			 * all the buffers get cleaned later.
+			 */
+			lock_page(page);
+			if (nilfs_page_buffers_clean(page))
+				__nilfs_clear_page_dirty(page);
+			unlock_page(page);
+		}
 		return;
+	}
 
 	__nilfs_end_page_io(page, err);
 }


