Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZFELRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZFELRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZFELOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:14:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49474 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbZFELOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:14:44 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>, xfs-masters@oss.sgi.com
Subject: [PATCH v2.1 16/17] XFS: do not manipulate s_dirt directly
Date: Fri,  5 Jun 2009 16:05:54 +0300
Message-Id: <1244207155-2092-17-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
References: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 05 Jun 2009 11:13:20.0118 (UTC) FILETIME=[A2074960:01C9E5CE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com
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

