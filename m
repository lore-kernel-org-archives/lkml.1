Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYI3Hrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYI3Hrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYI3Hmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:35 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59036 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYI3HmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:14 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: ensure data read beyond i_size is zeroed out correctly
Date: Tue, 30 Sep 2008 12:19:07 +0300
Message-Id: <1222766358-21886-12-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:37.0006 (UTC) FILETIME=[F7F038E0:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/file.c        |   10 ++++++++--
 fs/ubifs/ubifs-media.h |    1 -
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index cdcfe95..2f20a49 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -147,6 +147,12 @@ static int do_readpage(struct page *page)
 				err = ret;
 				if (err != -ENOENT)
 					break;
+			} else if (block + 1 == beyond) {
+				int dlen = le32_to_cpu(dn->size);
+				int ilen = i_size & (UBIFS_BLOCK_SIZE - 1);
+
+				if (ilen && ilen < dlen)
+					memset(addr + ilen, 0, dlen - ilen);
 			}
 		}
 		if (++i >= UBIFS_BLOCKS_PER_PAGE)
@@ -601,7 +607,7 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 
 	addr = zaddr = kmap(page);
 
-	end_index = (i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	end_index = (i_size - 1) >> PAGE_CACHE_SHIFT;
 	if (!i_size || page->index > end_index) {
 		memset(addr, 0, PAGE_CACHE_SIZE);
 		goto out_hole;
@@ -649,7 +655,7 @@ static int populate_page(struct ubifs_info *c, struct page *page,
 	if (end_index == page->index) {
 		int len = i_size & (PAGE_CACHE_SIZE - 1);
 
-		if (len < read)
+		if (len && len < read)
 			memset(zaddr + len, 0, read - len);
 	}
 
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index a9ecbd9..0b37804 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -75,7 +75,6 @@
  */
 #define UBIFS_BLOCK_SIZE  4096
 #define UBIFS_BLOCK_SHIFT 12
-#define UBIFS_BLOCK_MASK  0x00000FFF
 
 /* UBIFS padding byte pattern (must not be first or last byte of node magic) */
 #define UBIFS_PADDING_BYTE 0xCE
-- 
1.5.4.1

