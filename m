Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbXL3TFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbXL3TFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 14:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbXL3TFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 14:05:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:11215 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXL3TFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 14:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=K9d1J701Pxge7GVqRPKBwj6XaH61UkON7ZPQqfCi4yxcMdc8iB93sqOYaxBXlOqg2MQbw/DEW1j+EmYesMeSOK98jzUn5+8UmC4ZuQ35cYP2x7N0wOuyYS440mGwD+4pf5NGGfW1i7BMAAW3qi1t8lUvKOt2+KDhvhu4ATrqjQs=
Date: Sun, 30 Dec 2007 20:06:34 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: [RFC][PATCH] byteorder: introduce le32_add_cpu & friends to core
Message-ID: <20071230190619.GA13757@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many places where these functions would be useful.
(just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/)
What do you think?

ps: this patch depends on http://lkml.org/lkml/2007/12/25/35
--

add inline functions which add native byte order variable to
little/big endian variable to core header and as an example
convert ext3 to use them

le16_add_cpu(__le16 *var, u16 val)
le32_add_cpu(__le32 *var, u32 val)
le64_add_cpu(__le64 *var, u64 val)
be16_add_cpu(__be16 *var, u16 val)
be32_add_cpu(__be32 *var, u32 val)
be64_add_cpu(__be64 *var, u64 val)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 fs/ext3/balloc.c                  |    7 +----
 fs/ext3/ialloc.c                  |   12 +++------
 fs/ext3/resize.c                  |   12 +++------
 fs/ext3/super.c                   |    2 +-
 fs/ext3/xattr.c                   |    6 +---
 fs/ocfs2/cluster/endian.h         |   30 ------------------------
 fs/ocfs2/cluster/nodemanager.c    |    1 -
 fs/ocfs2/dlm/dlmast.c             |    1 -
 fs/ocfs2/endian.h                 |   45 -------------------------------------
 fs/ocfs2/ocfs2.h                  |    1 -
 include/linux/byteorder/generic.h |   30 ++++++++++++++++++++++++
 11 files changed, 43 insertions(+), 104 deletions(-)
 delete mode 100644 fs/ocfs2/cluster/endian.h
 delete mode 100644 fs/ocfs2/endian.h

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a8ba7e8..89f320f 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -566,9 +566,7 @@ do_more:
 	jbd_unlock_bh_state(bitmap_bh);
 
 	spin_lock(sb_bgl_lock(sbi, block_group));
-	desc->bg_free_blocks_count =
-		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
-			group_freed);
+	le16_add_cpu(&desc->bg_free_blocks_count, group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
@@ -1630,8 +1628,7 @@ allocated:
 			ret_block, goal_hits, goal_attempts);
 
 	spin_lock(sb_bgl_lock(sbi, group_no));
-	gdp->bg_free_blocks_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
+	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 1bc8cd8..3b6b9da 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -164,11 +164,9 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 
 		if (gdp) {
 			spin_lock(sb_bgl_lock(sbi, block_group));
-			gdp->bg_free_inodes_count = cpu_to_le16(
-				le16_to_cpu(gdp->bg_free_inodes_count) + 1);
+			le16_add_cpu(&gdp->bg_free_inodes_count, 1);
 			if (is_directory)
-				gdp->bg_used_dirs_count = cpu_to_le16(
-				  le16_to_cpu(gdp->bg_used_dirs_count) - 1);
+				le16_add_cpu(&gdp->bg_used_dirs_count, -1);
 			spin_unlock(sb_bgl_lock(sbi, block_group));
 			percpu_counter_inc(&sbi->s_freeinodes_counter);
 			if (is_directory)
@@ -527,11 +525,9 @@ got:
 	err = ext3_journal_get_write_access(handle, bh2);
 	if (err) goto fail;
 	spin_lock(sb_bgl_lock(sbi, group));
-	gdp->bg_free_inodes_count =
-		cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+	le16_add_cpu(&gdp->bg_free_inodes_count, -1);
 	if (S_ISDIR(mode)) {
-		gdp->bg_used_dirs_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_used_dirs_count) + 1);
+		le16_add_cpu(&gdp->bg_used_dirs_count, 1);
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 	BUFFER_TRACE(bh2, "call ext3_journal_dirty_metadata");
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 44de145..5b402a7 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -518,8 +518,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	EXT3_SB(sb)->s_gdb_count++;
 	kfree(o_group_desc);
 
-	es->s_reserved_gdt_blocks =
-		cpu_to_le16(le16_to_cpu(es->s_reserved_gdt_blocks) - 1);
+	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
 	ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
 
 	return 0;
@@ -891,10 +890,8 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 	 * blocks/inodes before the group is live won't actually let us
 	 * allocate the new space yet.
 	 */
-	es->s_blocks_count = cpu_to_le32(le32_to_cpu(es->s_blocks_count) +
-		input->blocks_count);
-	es->s_inodes_count = cpu_to_le32(le32_to_cpu(es->s_inodes_count) +
-		EXT3_INODES_PER_GROUP(sb));
+	le32_add_cpu(&es->s_blocks_count, input->blocks_count);
+	le32_add_cpu(&es->s_inodes_count, EXT3_INODES_PER_GROUP(sb));
 
 	/*
 	 * We need to protect s_groups_count against other CPUs seeing
@@ -927,8 +924,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
-	es->s_r_blocks_count = cpu_to_le32(le32_to_cpu(es->s_r_blocks_count) +
-		input->reserved_blocks);
+	le32_add_cpu(&es->s_r_blocks_count, input->reserved_blocks);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeblocks_counter,
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 92f03b6..70da5a3 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1224,7 +1224,7 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT3_DFL_MAX_MNT_COUNT);
-	es->s_mnt_count=cpu_to_le16(le16_to_cpu(es->s_mnt_count) + 1);
+	le16_add_cpu(&es->s_mnt_count, 1);
 	es->s_mtime = cpu_to_le32(get_seconds());
 	ext3_update_dynamic_rev(sb);
 	EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 4083738..fb89c29 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -492,8 +492,7 @@ ext3_xattr_release_block(handle_t *handle, struct inode *inode,
 		get_bh(bh);
 		ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
-		BHDR(bh)->h_refcount = cpu_to_le32(
-				le32_to_cpu(BHDR(bh)->h_refcount) - 1);
+		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		error = ext3_journal_dirty_metadata(handle, bh);
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
@@ -780,8 +779,7 @@ inserted:
 				if (error)
 					goto cleanup_dquot;
 				lock_buffer(new_bh);
-				BHDR(new_bh)->h_refcount = cpu_to_le32(1 +
-					le32_to_cpu(BHDR(new_bh)->h_refcount));
+				le32_add_cpu(&BHDR(new_bh)->h_refcount, 1);
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
 				unlock_buffer(new_bh);
diff --git a/fs/ocfs2/cluster/endian.h b/fs/ocfs2/cluster/endian.h
deleted file mode 100644
index 2df9082..0000000
--- a/fs/ocfs2/cluster/endian.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * Copyright (C) 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef OCFS2_CLUSTER_ENDIAN_H
-#define OCFS2_CLUSTER_ENDIAN_H
-
-static inline void be32_add_cpu(__be32 *var, u32 val)
-{
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
-}
-
-#endif /* OCFS2_CLUSTER_ENDIAN_H */
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index af2070d..709fba2 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -24,7 +24,6 @@
 #include <linux/sysctl.h>
 #include <linux/configfs.h>
 
-#include "endian.h"
 #include "tcp.h"
 #include "nodemanager.h"
 #include "heartbeat.h"
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 2fd8bde..644bee5 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -43,7 +43,6 @@
 #include "cluster/heartbeat.h"
 #include "cluster/nodemanager.h"
 #include "cluster/tcp.h"
-#include "cluster/endian.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
diff --git a/fs/ocfs2/endian.h b/fs/ocfs2/endian.h
deleted file mode 100644
index 1942e09..0000000
--- a/fs/ocfs2/endian.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * Copyright (C) 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef OCFS2_ENDIAN_H
-#define OCFS2_ENDIAN_H
-
-static inline void le16_add_cpu(__le16 *var, u16 val)
-{
-	*var = cpu_to_le16(le16_to_cpu(*var) + val);
-}
-
-static inline void le32_add_cpu(__le32 *var, u32 val)
-{
-	*var = cpu_to_le32(le32_to_cpu(*var) + val);
-}
-
-static inline void le64_add_cpu(__le64 *var, u64 val)
-{
-	*var = cpu_to_le64(le64_to_cpu(*var) + val);
-}
-
-static inline void be32_add_cpu(__be32 *var, u32 val)
-{
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
-}
-
-#endif /* OCFS2_ENDIAN_H */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 60a23e1..cda15fd 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -43,7 +43,6 @@
 #include "dlm/dlmapi.h"
 
 #include "ocfs2_fs.h"
-#include "endian.h"
 #include "ocfs2_lockid.h"
 
 /* Most user visible OCFS2 inodes will have very few pieces of
diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 3dc715b..d377155 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -146,6 +146,36 @@
 #define htons(x) ___htons(x)
 #define ntohs(x) ___ntohs(x)
 
+static inline void le16_add_cpu(__le16 *var, u16 val)
+{
+	*var = cpu_to_le16(le16_to_cpu(*var) + val);
+}
+
+static inline void le32_add_cpu(__le32 *var, u32 val)
+{
+	*var = cpu_to_le32(le32_to_cpu(*var) + val);
+}
+
+static inline void le64_add_cpu(__le64 *var, u64 val)
+{
+	*var = cpu_to_le64(le64_to_cpu(*var) + val);
+}
+
+static inline void be16_add_cpu(__be16 *var, u16 val)
+{
+	*var = cpu_to_be16(be16_to_cpu(*var) + val);
+}
+
+static inline void be32_add_cpu(__be32 *var, u32 val)
+{
+	*var = cpu_to_be32(be32_to_cpu(*var) + val);
+}
+
+static inline void be64_add_cpu(__be64 *var, u64 val)
+{
+	*var = cpu_to_be64(be64_to_cpu(*var) + val);
+}
+
 #endif /* KERNEL */
 
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
-- 
1.5.3.7

