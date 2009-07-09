Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZGIG6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZGIG6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZGIG62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:28 -0400
Received: from smtp.nokia.com ([192.100.122.233]:29966 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZGIG61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:27 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:48:29 +0300
Message-Id: <20090709084829.12122.7367.sendpatchset@localhost.localdomain>
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 01/18] VFS: introduce helpers for manipulation s_dirty flag
X-OriginalArrivalTime: 09 Jul 2009 06:57:58.0529 (UTC) FILETIME=[97B1D710:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces 3 new VFS helpers: 'mark_sb_dirty()',
'mark_sb_clean()', and 'is_sb_dirty()'. The helpers simply
set 'sb->s_dirt' or test 'sb->s_dirt'. The plan is to make
every FS use these helpers instead of manipulating
'sb->s_dirt' directly. And the further plan is to stop the
periodic write-back when there is no dirt.

This patch is just a preparation for further periodic write-back
timer optimizations. No functional changes yet.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/fs.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8f0478c..d98d8d1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1789,6 +1789,23 @@ extern int get_sb_pseudo(struct file_system_type *, char *,
 extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 
+/*
+ * Note, VFS does not provide any protection for the super block clean/dirty
+ * state. File-systems should take care of this.
+ */
+static inline void mark_sb_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+static inline void mark_sb_clean(struct super_block *sb)
+{
+	sb->s_dirt = 0;
+}
+static inline int is_sb_dirty(struct super_block *sb)
+{
+	return sb->s_dirt;
+}
+
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.6.0.6

