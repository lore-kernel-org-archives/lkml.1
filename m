Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab0BKXGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:06:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:36681 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab0BKXGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:06:31 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       fengguang.wu@intel.com, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] mm: Debugging of new livelock avoidance
Date: Fri, 12 Feb 2010 00:06:24 +0100
Message-Id: <1265929584-5080-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1265929584-5080-1-git-send-email-jack@suse.cz>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make some paranoic checks to verify that code does what it's expected to do.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f37cbc2..a389feb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -822,6 +822,45 @@ void tag_pages_for_writeback(struct address_space *mapping,
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_gang_tag_if_tagged(&mapping->page_tree, start, end,
 				PAGECACHE_TAG_DIRTY, PAGECACHE_TAG_TOWRITE);
+	/* Debugging aid */
+	{
+	int i;
+	pgoff_t index;
+	unsigned int nr_pages;
+	struct pagevec pvec;
+
+	index = start;
+	do {
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		for (i = 0; i < nr_pages; i++) {
+			if (pvec.pages[i]->index > end) {
+				nr_pages = 0;
+				break;
+			}
+			if (!radix_tree_tag_get(&mapping->page_tree, pvec.pages[i]->index, PAGECACHE_TAG_TOWRITE))
+				printk("Seeing DIRTY !TOWRITE page %lu, state %lu\n", pvec.pages[i]->index, pvec.pages[i]->flags);
+		}
+		pagevec_release(&pvec);
+	} while (nr_pages);
+
+	index = start;
+	do {
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_TOWRITE,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		for (i = 0; i < nr_pages; i++) {
+			if (pvec.pages[i]->index > end) {
+				nr_pages = 0;
+				break;
+			}
+			if (!radix_tree_tag_get(&mapping->page_tree, pvec.pages[i]->index, PAGECACHE_TAG_DIRTY))
+				printk("Seeing !DIRTY TOWRITE page %lu, state %lu\n", pvec.pages[i]->index, pvec.pages[i]->flags);
+		}
+		pagevec_release(&pvec);
+	} while (nr_pages);
+	}
 	spin_unlock_irq(&mapping->tree_lock);
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
-- 
1.6.4.2

