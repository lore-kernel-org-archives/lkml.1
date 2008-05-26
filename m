Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYEZMXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYEZMXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYEZMX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:23:28 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49185 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYEZMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:23:27 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 02/29] VFS: export sync_sb_inodes
Date: Mon, 26 May 2008 17:05:16 +0300
Message-Id: <1211810743-18936-3-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 26 May 2008 12:23:25.0354 (UTC) FILETIME=[4BA320A0:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports the 'sync_sb_inodes()' which is needed for
UBIFS because it have to force write-back from time to time.
Namely, the UBIFS budgeting subsystem forces write-back when
its pessimistic callculations show that there is not free
space on the media.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c  |   11 +++++++++--
 include/linux/fs.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 16519fe..25adfc3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -439,8 +439,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static void
-sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
@@ -526,6 +526,13 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 	spin_unlock(&inode_lock);
 	return;		/* Leave any unwritten inodes on s_io */
 }
+EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
+
+static void sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
+{
+	generic_sync_sb_inodes(sb, wbc);
+}
 
 /*
  * Start writeback of dirty pagecache data against all unlocked inodes.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f413085..6a0b9b8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1730,6 +1730,8 @@ static inline void invalidate_remote_inode(struct inode *inode)
 extern int invalidate_inode_pages2(struct address_space *mapping);
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
+extern void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc);
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
-- 
1.5.4.1

