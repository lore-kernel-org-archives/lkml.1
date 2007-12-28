Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbXL1IEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbXL1IEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 03:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbXL1IDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 03:03:55 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37816 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751425AbXL1IDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 03:03:54 -0500
Message-ID: <398829041.61992@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 28 Dec 2007 16:03:49 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shaggy@austin.ibm.com, jfs-discussion@lists.sourceforge.net
Subject: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J8AC5-0002BE-RP@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This patch fixed the 'pdflush stuck in D state' bug
        http://bugzilla.kernel.org/show_bug.cgi?id=9291
and should be pushed to mainline ASAP.
---

When JFS decides to drop a dirty metapage, it simply clears the META_dirty bit
and leave alone the PG_dirty and PAGECACHE_TAG_DIRTY bits.

When such no-write page goes to metapage_writepage(), the `relic'
PAGECACHE_TAG_DIRTY tag should be cleared, to prevent pdflush from
repeatedly trying to sync them.

Also, avoid the redirty when a bio submission is planned.

Tested-by: Markus Rehbach <Markus.Rehbach@gmx.de>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 
---

diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index f5cd8d3..0c3ffc4 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -353,7 +353,8 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct bio *bio = NULL;
 	unsigned int block_offset;	/* block offset of mp within page */
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
 	unsigned int blocks_per_mp = JFS_SBI(inode->i_sb)->nbperpage;
 	unsigned int len;
 	unsigned int xlen;
@@ -449,9 +450,15 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 			goto dump_bio;
 
 		submit_bio(WRITE, bio);
-	}
-	if (redirty)
+	} else if (redirty) {
 		redirty_page_for_writepage(wbc, page);
+	} else {
+		write_lock_irq(&mapping->tree_lock);
+		radix_tree_tag_clear(&mapping->page_tree,
+				page_index(page),
+				PAGECACHE_TAG_DIRTY);
+		write_unlock_irq(&mapping->tree_lock);
+	}
 
 	unlock_page(page);
 

