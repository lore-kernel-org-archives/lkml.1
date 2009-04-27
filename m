Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZD0Otu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZD0Otu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbZD0OoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:44:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:47102 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861AbZD0On6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:43:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 8/8] quota: Introduce writeout_quota_sb() (version 4)
Date: Mon, 27 Apr 2009 16:43:55 +0200
Message-Id: <1240843435-1786-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240843435-1786-1-git-send-email-jack@suse.cz>
References: <1240843435-1786-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce this function which just writes all the quota structures but
avoids all the syncing and cache pruning work to expose quota structures
to userspace. Use this function from __sync_filesystem when wait == 0.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sync.c                |    6 +++++-
 include/linux/quotaops.h |    9 +++++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 4914f0a..8a14e20 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -26,7 +26,11 @@
  */
 static int __sync_filesystem(struct super_block *sb, int wait)
 {
-	sync_quota_sb(sb, -1);
+	/* Avoid doing twice syncing and cache pruning for quota sync */
+	if (!wait)
+		writeout_quota_sb(sb, -1);
+	else
+		sync_quota_sb(sb, -1);
 	sync_inodes_sb(sb, wait);
 	lock_super(sb);
 	if (sb->s_dirt && sb->s_op->write_super)
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 047310f..7bc4575 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -21,6 +21,11 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
  * declaration of quota_function calls in kernel.
  */
 void sync_quota_sb(struct super_block *sb, int type);
+static inline void writeout_quota_sb(struct super_block *sb, int type)
+{
+	if (sb->s_qcop->quota_sync)
+		sb->s_qcop->quota_sync(sb, type);
+}
 
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
@@ -333,6 +338,10 @@ static inline void sync_quota_sb(struct super_block *sb, int type)
 {
 }
 
+static inline void writeout_quota_sb(struct super_block *sb, int type)
+{
+}
+
 static inline int vfs_dq_off(struct super_block *sb, int remount)
 {
 	return 0;
-- 
1.6.0.2

