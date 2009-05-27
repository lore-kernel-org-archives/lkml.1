Return-Path: <linux-kernel-owner+w=401wt.eu-S1763320AbZE0LR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763320AbZE0LR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761409AbZE0LNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:13:20 -0400
Received: from smtp.nokia.com ([192.100.122.233]:65304 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761323AbZE0LNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:13:18 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:06:46 +0300
Message-Id: <20090527130646.4913.86027.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/19] XFS: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:12:49.0250 (UTC) FILETIME=[11E97420:01C9DEBC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] XFS: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/xfs/linux-2.6/xfs_super.c |    6 +++---
 fs/xfs/xfs_trans.c           |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index d29218e..4c25456 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1114,7 +1114,7 @@ xfs_fs_write_super(
 {
 	if (!(sb->s_flags & MS_RDONLY))
 		xfs_sync_fsdata(XFS_M(sb), 0);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 }
 
 STATIC int
@@ -1141,7 +1141,7 @@ xfs_fs_sync_super(
 		error = xfs_quiesce_data(mp);
 	else
 		error = xfs_sync_fsdata(mp, 0);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	if (unlikely(laptop_mode)) {
 		int	prev_sync_seq = mp->m_sync_seq;
@@ -1447,7 +1447,7 @@ xfs_fs_fill_super(
 
 	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, mtpt, mp->m_fsname);
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8570b82..2552bae 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -629,7 +629,7 @@ xfs_trans_apply_sb_deltas(
 				  offsetof(xfs_dsb_t, sb_frextents) +
 				  sizeof(sbp->sb_frextents) - 1);
 
-	tp->t_mountp->m_super->s_dirt = 1;
+	mark_sb_dirty(tp->t_mountp->m_super);
 }
 
 /*
-- 
1.6.0.6

