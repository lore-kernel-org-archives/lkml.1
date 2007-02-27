Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbXB0By3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbXB0By3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXB0By3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:54:29 -0500
Received: from gw.goop.org ([64.81.55.164]:45319 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbXB0By2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:54:28 -0500
Message-ID: <45E38F4C.7040305@goop.org>
Date: Mon, 26 Feb 2007 17:54:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: [PATCH] rename PG_checked page flag to PG_owner_priv_1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rename PG_checked to PG_owner_priv_1 to reflect its availablilty as a
subsystem/filesystem private flag.  A subsystem which "owns" a page
(for example, a pagecache page belonging to a filesystem) may use this
flag for whatever it wants.

ext3 is the only current in-tree user of this flag.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: William Lee Irwin III <wli@holomorphy.com>

---
 fs/ext3/inode.c            |   10 +++++-----
 include/linux/page-flags.h |    8 ++++----
 mm/page_alloc.c            |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

===================================================================
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1596,12 +1596,12 @@ static int ext3_journalled_writepage(str
 		goto no_write;
 	}
 
-	if (!page_has_buffers(page) || PageChecked(page)) {
+	if (!page_has_buffers(page) || PageOwnerPriv(page)) {
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
 		 */
-		ClearPageChecked(page);
+		ClearPageOwnerPriv(page);
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
 					ext3_get_block);
 		if (ret != 0) {
@@ -1658,7 +1658,7 @@ static void ext3_invalidatepage(struct p
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
 	if (offset == 0)
-		ClearPageChecked(page);
+		ClearPageOwnerPriv(page);
 
 	journal_invalidatepage(journal, page, offset);
 }
@@ -1667,7 +1667,7 @@ static int ext3_releasepage(struct page 
 {
 	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
 
-	WARN_ON(PageChecked(page));
+	WARN_ON(PageOwnerPriv(page));
 	if (!page_has_buffers(page))
 		return 0;
 	return journal_try_to_free_buffers(journal, page, wait);
@@ -1763,7 +1763,7 @@ out:
  */
 static int ext3_journalled_set_page_dirty(struct page *page)
 {
-	SetPageChecked(page);
+	SetPageOwnerPriv(page);
 	return __set_page_dirty_nobuffers(page);
 }
 
===================================================================
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -76,7 +76,7 @@
 #define PG_active		 6
 #define PG_slab			 7	/* slab debug (Suparna wants this) */
 
-#define PG_checked		 8	/* kill me in 2.5.<early>. */
+#define PG_owner_priv_1		 8	/* subsystem/owner-private flag*/
 #define PG_arch_1		 9
 #define PG_reserved		10
 #define PG_private		11	/* If pagecache, has fs-private data */
@@ -165,9 +165,9 @@ static inline void SetPageUptodate(struc
 #define PageHighMem(page)	0 /* needed to optimize away at compile time */
 #endif
 
-#define PageChecked(page)	test_bit(PG_checked, &(page)->flags)
-#define SetPageChecked(page)	set_bit(PG_checked, &(page)->flags)
-#define ClearPageChecked(page)	clear_bit(PG_checked, &(page)->flags)
+#define PageOwnerPriv(page)	test_bit(PG_owner_priv_1, &(page)->flags)
+#define SetPageOwnerPriv(page)	set_bit(PG_owner_priv_1, &(page)->flags)
+#define ClearPageOwnerPriv(page)	clear_bit(PG_owner_priv_1, &(page)->flags)
 
 #define PageReserved(page)	test_bit(PG_reserved, &(page)->flags)
 #define SetPageReserved(page)	set_bit(PG_reserved, &(page)->flags)
===================================================================
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -600,7 +600,7 @@ static int prep_new_page(struct page *pa
 
 	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
 			1 << PG_referenced | 1 << PG_arch_1 |
-			1 << PG_checked | 1 << PG_mappedtodisk);
+			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 


