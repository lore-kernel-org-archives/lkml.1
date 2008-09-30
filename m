Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYI3Hqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYI3Hqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYI3HmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:23 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59012 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYI3HmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:10 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: fix bulk-read handling uptodate pages
Date: Tue, 30 Sep 2008 12:19:15 +0300
Message-Id: <1222766358-21886-20-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:37.0850 (UTC) FILETIME=[F87101A0:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Bulk-read skips uptodate pages but this was putting its
array index out and causing it to treat subsequent pages
as holes.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/file.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 2f20a49..51cf511 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -595,7 +595,7 @@ out:
 static int populate_page(struct ubifs_info *c, struct page *page,
 			 struct bu_info *bu, int *n)
 {
-	int i = 0, nn = *n, offs = bu->zbranch[0].offs, hole = 1, read = 0;
+	int i = 0, nn = *n, offs = bu->zbranch[0].offs, hole = 0, read = 0;
 	struct inode *inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
 	unsigned int page_block;
@@ -609,6 +609,7 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 
 	end_index = (i_size - 1) >> PAGE_CACHE_SHIFT;
 	if (!i_size || page->index > end_index) {
+		hole = 1;
 		memset(addr, 0, PAGE_CACHE_SIZE);
 		goto out_hole;
 	}
@@ -617,10 +618,10 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 	while (1) {
 		int err, len, out_len, dlen;
 
-		if (nn >= bu->cnt ||
-		    key_block(c, &bu->zbranch[nn].key) != page_block)
+		if (nn >= bu->cnt) {
+			hole = 1;
 			memset(addr, 0, UBIFS_BLOCK_SIZE);
-		else {
+		} else if (key_block(c, &bu->zbranch[nn].key) == page_block) {
 			struct ubifs_data_node *dn;
 
 			dn = bu->buf + (bu->zbranch[nn].offs - offs);
@@ -643,8 +644,13 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 				memset(addr + len, 0, UBIFS_BLOCK_SIZE - len);
 
 			nn += 1;
-			hole = 0;
 			read = (i << UBIFS_BLOCK_SHIFT) + len;
+		} else if (key_block(c, &bu->zbranch[nn].key) < page_block) {
+			nn += 1;
+			continue;
+		} else {
+			hole = 1;
+			memset(addr, 0, UBIFS_BLOCK_SIZE);
 		}
 		if (++i >= UBIFS_BLOCKS_PER_PAGE)
 			break;
-- 
1.5.4.1

