Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbYC0NL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbYC0NL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759178AbYC0NH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:07:57 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64513 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407AbYC0NHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:07:35 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [RFC PATCH 01/26] VFS: introduce writeback_inodes_sb()
Date: Thu, 27 Mar 2008 16:55:21 +0200
Message-Id: <1206629746-4298-2-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 27 Mar 2008 13:06:19.0070 (UTC) FILETIME=[58E805E0:01C8900B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let file systems to writeback their pages and inodes when needed. This
is needed for UBIFS budgeting sub-system because it has to force
write-back from time to time.

Note, it cannot be called if one of the dirty pages is locked by
the caller, otherwise it'll deadlock.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c         |    8 ++++++++
 include/linux/writeback.h |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c007607..062aa4a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -573,6 +573,14 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 	spin_unlock(&inode_lock);
 }
 
+void writeback_inodes_sb(struct super_block *sb, struct writeback_control *wbc)
+{
+	spin_lock(&inode_lock);
+	sync_sb_inodes(sb, wbc);
+	spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL_GPL(writeback_inodes_sb);
+
 /*
  * Rather lame livelock avoidance.
  */
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b7b3362..0083a0a 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -71,6 +71,7 @@ struct writeback_control {
 void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
+void writeback_inodes_sb(struct super_block *sb, struct writeback_control *wbc);
 void sync_inodes(int wait);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
-- 
1.5.4.1

