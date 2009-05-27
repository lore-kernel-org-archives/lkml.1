Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbZE0LRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbZE0LRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbZE0LMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54658 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760502AbZE0LMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:47 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:06:34 +0300
Message-Id: <20090527130634.4913.42099.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/19] UDF: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:12:36.0499 (UTC) FILETIME=[0A4FCE30:01C9DEBC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] UDF: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
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

