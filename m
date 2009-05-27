Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbZE0LOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbZE0LOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbZE0LMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:22 -0400
Received: from smtp.nokia.com ([192.100.122.233]:65040 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043AbZE0LMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:18 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:06:08 +0300
Message-Id: <20090527130608.4913.31227.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/19] JFFS2: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:12:07.0887 (UTC) FILETIME=[F941F5F0:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] JFFS2: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/jffs2/os-linux.h |    2 +-
 fs/jffs2/super.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 2228380..ad12212 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -147,7 +147,7 @@ void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c);
 /* erase.c */
 static inline void jffs2_erase_pending_trigger(struct jffs2_sb_info *c)
 {
-	OFNI_BS_2SFFJ(c)->s_dirt = 1;
+	mark_sb_dirty(OFNI_BS_2SFFJ(c));
 }
 
 /* background.c */
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index f7bfd3a..5b321fa 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -58,7 +58,7 @@ static void jffs2_write_super(struct super_block *sb)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
 	lock_super(sb);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		D1(printk(KERN_DEBUG "jffs2_write_super()\n"));
@@ -193,7 +193,7 @@ static void jffs2_put_super (struct super_block *sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
+	if (sb_is_dirty(sb))
 		jffs2_write_super(sb);
 
 	mutex_lock(&c->alloc_sem);
-- 
1.6.0.6

