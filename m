Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZFDIxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZFDIxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbZFDIts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:48 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34236 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573AbZFDItb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:31 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH v2 14/17] UDF: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:51 +0300
Message-Id: <1244112114-23144-15-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:43.0533 (UTC) FILETIME=[43F7BBD0:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Jan Kara <jack@suse.cz>
---
 fs/udf/super.c   |    6 +++---
 fs/udf/udfdecl.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e2e06b0..7926436 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1908,7 +1908,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	sb->s_op = &udf_sb_ops;
 	sb->s_export_op = &udf_export_ops;
 	sb->dq_op = NULL;
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	sb->s_magic = UDF_SUPER_MAGIC;
 	sb->s_time_gran = 1000;
 
@@ -2035,7 +2035,7 @@ static void udf_error(struct super_block *sb, const char *function,
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		/* mark sb error */
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
@@ -2095,7 +2095,7 @@ static int udf_sync_fs(struct super_block *sb, int wait)
 		 * the buffer for IO
 		 */
 		mark_buffer_dirty(sbi->s_lvid_bh);
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 		sbi->s_lvid_dirty = 0;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index cac51b7..8ad1818 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -119,7 +119,7 @@ static inline void udf_updated_lvid(struct super_block *sb)
 	WARN_ON_ONCE(((struct logicalVolIntegrityDesc *)
 		     bh->b_data)->integrityType !=
 		     cpu_to_le32(LVID_INTEGRITY_TYPE_OPEN));
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	UDF_SB(sb)->s_lvid_dirty = 1;
 }
 
-- 
1.6.0.6

