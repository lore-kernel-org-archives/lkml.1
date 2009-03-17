Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZCQUqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZCQUqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZCQUpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:45:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532AbZCQUpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:45:39 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 31/32] ocfs2: Pagecache usage optimization on ocfs2
Date: Tue, 17 Mar 2009 13:01:21 -0700
Message-Id: <1237320082-12921-32-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

A page can have multiple buffers and even if a page is not uptodate, some buffers
can be uptodate on pagesize != blocksize environment.
This aops checks that all buffers which correspond to a part of a file
that we want to read are uptodate. If so, we do not have to issue actual
read IO to HDD even if a page is not uptodate because the portion we
want to read are uptodate.
"block_is_partially_uptodate" function is already used by ext2/3/4.
With the following patch random read/write mixed workloads or random read after
random write workloads can be optimized and we can get performance improvement.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/aops.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 8e1709a..b2c52b3 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1956,15 +1956,16 @@ static int ocfs2_write_end(struct file *file, struct address_space *mapping,
 }
 
 const struct address_space_operations ocfs2_aops = {
-	.readpage	= ocfs2_readpage,
-	.readpages	= ocfs2_readpages,
-	.writepage	= ocfs2_writepage,
-	.write_begin	= ocfs2_write_begin,
-	.write_end	= ocfs2_write_end,
-	.bmap		= ocfs2_bmap,
-	.sync_page	= block_sync_page,
-	.direct_IO	= ocfs2_direct_IO,
-	.invalidatepage	= ocfs2_invalidatepage,
-	.releasepage	= ocfs2_releasepage,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ocfs2_readpage,
+	.readpages		= ocfs2_readpages,
+	.writepage		= ocfs2_writepage,
+	.write_begin		= ocfs2_write_begin,
+	.write_end		= ocfs2_write_end,
+	.bmap			= ocfs2_bmap,
+	.sync_page		= block_sync_page,
+	.direct_IO		= ocfs2_direct_IO,
+	.invalidatepage		= ocfs2_invalidatepage,
+	.releasepage		= ocfs2_releasepage,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate	= block_is_partially_uptodate,
 };
-- 
1.5.6

