Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbZLKEuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbZLKEuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760688AbZLKEuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:50:00 -0500
Received: from kroah.org ([198.145.64.141]:36939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760826AbZLKEgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:17 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:00 2009
Message-Id: <20091211042800.341947927@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [50/90] ext4: fix a BUG_ON crash by checking that page has buffers attached to it
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0050-ext4-fix-a-BUG_ON-crash-by-checking-that-page-has-bu.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 1f94533d9cd75f6d2826018d54a971b9cc085992)

In ext4_num_dirty_pages() we were calling page_buffers() before
checking to see if the page actually had pages attached to it; this
would cause a BUG check crash in the inline function page_buffers().

Thanks to Markus Trippelsdorf for reporting this bug.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1147,8 +1147,8 @@ static int check_block_validity(struct i
 }
 
 /*
- * Return the number of dirty pages in the given inode starting at
- * page frame idx.
+ * Return the number of contiguous dirty pages in a given inode
+ * starting at page frame idx.
  */
 static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
 				    unsigned int max_pages)
@@ -1182,15 +1182,15 @@ static pgoff_t ext4_num_dirty_pages(stru
 				unlock_page(page);
 				break;
 			}
-			head = page_buffers(page);
-			bh = head;
-			do {
-				if (!buffer_delay(bh) &&
-				    !buffer_unwritten(bh)) {
-					done = 1;
-					break;
-				}
-			} while ((bh = bh->b_this_page) != head);
+			if (page_has_buffers(page)) {
+				bh = head = page_buffers(page);
+				do {
+					if (!buffer_delay(bh) &&
+					    !buffer_unwritten(bh))
+						done = 1;
+					bh = bh->b_this_page;
+				} while (!done && (bh != head));
+			}
 			unlock_page(page);
 			if (done)
 				break;


