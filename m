Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZFDIuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZFDIuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbZFDItO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:14 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34100 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433AbZFDItJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:09 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH v2 10/17] JFFS2: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:47 +0300
Message-Id: <1244112114-23144-11-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:40.0732 (UTC) FILETIME=[424C55C0:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
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

